#!/usr/bin/env bash
# BRAINIAC — réflexe PreToolUse.
# Bloque avant l'action. Code 2 = refus, message sur stderr lu par l'agent.
# Sécurité par défaut : toute anomalie interne bloque.
set -uo pipefail

# ---------------------------------------------------------------- racine
if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
fi
ROOT="$(cd "$ROOT" 2>/dev/null && pwd -P)" || ROOT=""

JOURNAL="$ROOT/journal/actions.log"
COMPTEURS="$ROOT/journal/.compteurs.json"

PY=""; command -v python3 >/dev/null 2>&1 && PY="python3"
JQ=""; command -v jq      >/dev/null 2>&1 && JQ="jq"

journaliser() { # $1 décision  $2 outil  $3 cible  $4 raison
  [ -d "$ROOT/journal" ] || return 0
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${SESSION:-?}" "$2" "$3" "$1" "$4" >> "$JOURNAL" 2>/dev/null
}

bloquer() { # $1 message  $2 raison courte
  printf 'BRAINIAC refuse cette action.\n%s\n' "$1" >&2
  journaliser "BLOQUE" "${OUTIL:-?}" "${CIBLE:-?}" "$2"
  exit 2
}

autoriser() { journaliser "OK" "${OUTIL:-?}" "${CIBLE:-?}" "${1:-}"; exit 0; }

# ---------------------------------------------------------------- prérequis
[ -n "$ROOT" ] || { echo "Racine BRAINIAC introuvable." >&2; exit 2; }
[ -f "$ROOT/AGENTS.md" ] && [ -d "$ROOT/.claude" ] || {
  echo "Racine invalide : AGENTS.md ou .claude/ manquant dans $ROOT" >&2; exit 2; }
[ -n "$PY$JQ" ] || { echo "Ni python3 ni jq : impossible de lire l'entrée du hook." >&2; exit 2; }

PWD_P="$(pwd -P)"
if [ "$PWD_P" != "$ROOT" ]; then
  echo "BRAINIAC refuse de travailler : lancé depuis $PWD_P au lieu de $ROOT." >&2
  echo "Relance l'outil depuis la racine de BRAINIAC, sinon les règles ne s'appliquent pas." >&2
  exit 2
fi

ENTREE="$(cat)"
[ -n "$ENTREE" ] || { echo "Entrée du hook vide." >&2; exit 2; }

# ---------------------------------------------------------------- lecture JSON
lire() { # $1 : chemin pointé, ex. tool_input.file_path
  if [ -n "$PY" ]; then
    printf '%s' "$ENTREE" | "$PY" -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(3)
v = d
for k in sys.argv[1].split("."):
    v = v.get(k) if isinstance(v, dict) else None
if v is None: print("")
elif isinstance(v, str): print(v)
else: print(json.dumps(v, ensure_ascii=False))
' "$1" 2>/dev/null
  else
    printf '%s' "$ENTREE" | "$JQ" -r --arg p "$1" '
      getpath($p | split(".")) as $v
      | if $v == null then "" elif ($v|type) == "string" then $v else ($v|tojson) end
    ' 2>/dev/null
  fi
}

if [ -n "$PY" ]; then
  printf '%s' "$ENTREE" | "$PY" -c 'import sys,json; json.load(sys.stdin)' 2>/dev/null \
    || { echo "Entrée du hook illisible : blocage par précaution." >&2; exit 2; }
else
  printf '%s' "$ENTREE" | "$JQ" -e . >/dev/null 2>&1 \
    || { echo "Entrée du hook illisible : blocage par précaution." >&2; exit 2; }
fi

SESSION="$(lire session_id)"; [ -n "$SESSION" ] || SESSION="sans-session"
OUTIL="$(lire tool_name)"
FICHIER="$(lire tool_input.file_path)"
[ -n "$FICHIER" ] || FICHIER="$(lire tool_input.notebook_path)"
COMMANDE="$(lire tool_input.command)"
CIBLE="${FICHIER:-${COMMANDE:0:60}}"

# ---------------------------------------------------------------- zones
REL=""
if [ -n "$FICHIER" ]; then
  case "$FICHIER" in
    /*) ABS="$FICHIER" ;;
    *)  ABS="$PWD_P/$FICHIER" ;;
  esac
  ABS="$(realpath -m "$ABS" 2>/dev/null)" || ABS=""
  [ -n "$ABS" ] || bloquer "Chemin illisible : $FICHIER" "chemin-illisible"
  case "$ABS" in
    "$ROOT"/*) REL="${ABS#"$ROOT"/}" ;;
    "$ROOT")   REL="." ;;
    *) bloquer "Chemin hors de BRAINIAC : $FICHIER
Rien ne s'écrit en dehors de l'espace de travail." "hors-perimetre" ;;
  esac
fi

est_lecture_seule() {
  case "$1" in
    AGENTS.md|CLAUDE.md|VERSION|.claude/*|.codex/*|ressources/*|humain/taches/*|\
    pentest/referentiels/*|pentest/exemptions.md|versions/update/*) return 0 ;;
  esac
  return 1
}
est_ajout_seul() {
  case "$1" in
    memoire/*|journal/*|pentest/rapports/*|humain/questions.md|versions/historique/*) return 0 ;;
  esac
  return 1
}
est_reserve_hooks() {
  case "$1" in journal/actions.log|journal/.compteurs.json) return 0 ;; esac
  return 1
}

# ---------------------------------------------------------------- budget
lire_budget() { # $1 clé, $2 défaut
  local v
  v="$(grep -E "^[[:space:]]*$1[[:space:]]*:" "$ROOT/ressources/budget.yaml" 2>/dev/null \
       | head -1 | sed -E 's/^[^:]*:[[:space:]]*//; s/[[:space:]]*(#.*)?$//')"
  [ -n "$v" ] && printf '%s' "$v" || printf '%s' "$2"
}
DUREE_MAX="$(lire_budget duree_max_minutes 90)"
ACTIONS_MAX="$(lire_budget actions_max 300)"
TENTATIVES_MAX="$(lire_budget tentatives_max 3)"

compteurs() { # $1 = action (lire|incr), sortie : debut actions echecs
  if [ -n "$PY" ]; then
    "$PY" - "$COMPTEURS" "$SESSION" "$1" <<'PYEOF'
import sys, json, os, time
chemin, session, action = sys.argv[1], sys.argv[2], sys.argv[3]
d = {}
if os.path.exists(chemin):
    try:
        d = json.load(open(chemin))
        if not isinstance(d, dict): d = {}
    except Exception:
        d = {}
e = d.get(session) or {"debut": int(time.time()), "actions": 0, "echecs": 0}
if action == "incr":
    e["actions"] = int(e.get("actions", 0)) + 1
    d[session] = e
    try:
        tmp = chemin + ".tmp"
        json.dump(d, open(tmp, "w"))
        os.replace(tmp, chemin)
    except Exception:
        pass
print(int(e.get("debut", time.time())), int(e.get("actions", 0)), int(e.get("echecs", 0)))
PYEOF
  else
    local maintenant; maintenant="$(date +%s)"
    [ -f "$COMPTEURS" ] || echo '{}' > "$COMPTEURS" 2>/dev/null
    local e
    e="$("$JQ" -r --arg s "$SESSION" --argjson t "$maintenant" \
        '(.[$s] // {debut:$t, actions:0, echecs:0}) | "\(.debut) \(.actions) \(.echecs)"' \
        "$COMPTEURS" 2>/dev/null)" || e="$maintenant 0 0"
    if [ "$1" = "incr" ]; then
      "$JQ" --arg s "$SESSION" --argjson t "$maintenant" \
        '.[$s] = ((.[$s] // {debut:$t, actions:0, echecs:0}) | .actions += 1)' \
        "$COMPTEURS" > "$COMPTEURS.tmp" 2>/dev/null && mv "$COMPTEURS.tmp" "$COMPTEURS"
      e="$(echo "$e" | awk '{print $1, $2+1, $3}')"
    fi
    printf '%s\n' "$e"
  fi
}

read -r DEBUT ACTIONS ECHECS <<< "$(compteurs incr)"
[ -n "${DEBUT:-}" ] || { DEBUT="$(date +%s)"; ACTIONS=0; ECHECS=0; }
ECOULE=$(( ( $(date +%s) - DEBUT ) / 60 ))

est_soupape() { # écriture toujours permise pour rendre compte
  case "$1" in humain/etat.md|humain/questions.md|memoire/lecons.md) return 0 ;; esac
  return 1
}

DEPASSE=""
[ "$ECOULE"  -gt "$DUREE_MAX" ]       2>/dev/null && DEPASSE="durée ${ECOULE} min > ${DUREE_MAX}"
[ "$ACTIONS" -gt "$ACTIONS_MAX" ]     2>/dev/null && DEPASSE="actions ${ACTIONS} > ${ACTIONS_MAX}"
[ "$ECHECS"  -ge "$TENTATIVES_MAX" ]  2>/dev/null && DEPASSE="échecs consécutifs ${ECHECS} >= ${TENTATIVES_MAX}"

if [ -n "$DEPASSE" ] && ! { [ -n "$REL" ] && est_soupape "$REL"; }; then
  bloquer "Budget épuisé ($DEPASSE).
Mets à jour humain/etat.md, pose ta question dans humain/questions.md, écris la leçon, puis arrête-toi.
Ces trois fichiers restent accessibles." "budget-epuise"
fi

# ---------------------------------------------------------------- édition
case "$OUTIL" in
  Edit|Write|MultiEdit|NotebookEdit|Update)
    [ -n "$REL" ] || bloquer "Édition sans chemin de fichier." "sans-chemin"

    est_reserve_hooks "$REL" && bloquer "$REL est tenu par les hooks, pas par l'agent.
Écris dans journal/erreurs.log si tu dois consigner une erreur." "reserve-hooks"

    est_lecture_seule "$REL" && bloquer "$REL est en lecture seule : c'est une règle qui te contraint.
Dépose ta proposition de modification dans humain/a_valider/ et explique-la." "zone-R"

    if est_ajout_seul "$REL"; then
      if [ "$OUTIL" = "Write" ] && [ -s "$ROOT/$REL" ]; then
        bloquer "$REL est en ajout seul : Write écraserait l'existant.
Utilise Edit en conservant intégralement le texte déjà présent." "ecrasement-A"
      fi
      if [ "$OUTIL" = "Edit" ] || [ "$OUTIL" = "MultiEdit" ]; then
        AJOUT="non"
        if [ -n "$PY" ]; then
          AJOUT="$(printf '%s' "$ENTREE" | "$PY" -c '
import sys, json
d = json.load(sys.stdin)
ti = d.get("tool_input", {}) or {}
paires = ti.get("edits")
if not paires:
    paires = [{"old_string": ti.get("old_string", ""), "new_string": ti.get("new_string", "")}]
def pur(p):
    a = p.get("old_string", "") or ""
    b = p.get("new_string", "") or ""
    return a in b
print("oui" if all(pur(p) for p in paires) else "non")
' 2>/dev/null)"
        else
          AJOUT="$(printf '%s' "$ENTREE" | "$JQ" -r '
            .tool_input as $t
            | ($t.edits // [{old_string: ($t.old_string // ""), new_string: ($t.new_string // "")}])
            | if all(.[]; (.new_string // "") | contains(.old_string // "")) then "oui" else "non" end
          ' 2>/dev/null)"
        fi
        [ "$AJOUT" = "oui" ] || bloquer "$REL est en ajout seul : cette modification supprime ou remplace du texte.
Ajoute à la suite en conservant l'existant intact." "suppression-A"
      fi
    fi
    autoriser "edition"
    ;;
esac

# ---------------------------------------------------------------- commandes
if [ -n "$COMMANDE" ]; then
  ZONES_R='AGENTS\.md|CLAUDE\.md|VERSION|\.claude/|\.codex/|ressources/|humain/taches/|pentest/referentiels|pentest/exemptions\.md|versions/update/'

  motif() { printf '%s' "$COMMANDE" | grep -Eqi "$1"; }

  motif '(^|[;&|[:space:]])sudo([[:space:]]|$)' && \
    bloquer "Aucune élévation de privilège dans BRAINIAC." "sudo"
  motif '(^|[;&|[:space:]])rm[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*(-[a-zA-Z]*[rf])' && \
    motif '(/|~|\.\.|\*)' && \
    bloquer "Suppression récursive refusée. Déplace vers quarantaine/ plutôt que supprimer." "rm-recursif"
  motif '(mkfs|dd[[:space:]]+if=|:\(\)\{)' && \
    bloquer "Commande destructrice refusée." "destructif"
  motif 'chmod[[:space:]]+(-R|[0-7]{3,4}[[:space:]]+/)' && \
    bloquer "Changement de droits refusé : c'est une décision humaine." "chmod"
  motif 'git[[:space:]]+push([[:space:]]|.)*--force' && \
    bloquer "Push forcé refusé." "push-force"
  motif '(curl|wget)[^|]*\|[[:space:]]*(ba)?sh' && \
    bloquer "Téléchargement exécuté directement : refusé." "pipe-shell"
  motif "(>|>>|sed[[:space:]]+-i|tee|truncate|shred|install)[^|;]*($ZONES_R)" && \
    bloquer "Cette commande écrit dans une zone en lecture seule.
Passe par humain/a_valider/." "ecriture-zone-R"
  motif "(^|[;&|[:space:]])(mv|cp|rm|ln)[[:space:]][^|;]*($ZONES_R)" && \
    bloquer "Cette commande modifie une zone en lecture seule." "modif-zone-R"
  motif '(cat|less|more|head|tail|grep|awk|sed|strings|cp|scp)[^|;]*(\.env|\.pem|\.key|id_rsa|secrets/)' && \
    bloquer "Lecture de secrets refusée." "secrets"
  motif 'mettre_a_jour' && \
    bloquer "La mise à jour de BRAINIAC modifie les règles qui t'encadrent : c'est une décision humaine.
Signale dans humain/etat.md qu'une archive attend dans versions/update/, et n'y touche pas." "maj-agent"
  motif '(unzip|zip|tar)[^|;]*versions/' && \
    bloquer "Les archives de versions ne se manipulent pas depuis l'agent." "archives-versions"

  autoriser "commande"
fi

autoriser "autre"
