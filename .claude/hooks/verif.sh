#!/usr/bin/env bash
# BRAINIAC — correction PostToolUse.
# Vérifie ce qui vient d'être écrit dans projet/. Code 2 = l'agent lit le message et corrige.
set -uo pipefail

if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
fi
ROOT="$(cd "$ROOT" 2>/dev/null && pwd -P)" || exit 0

COMPTEURS="$ROOT/journal/.compteurs.json"
ERREURS="$ROOT/journal/erreurs.log"
PY=""; command -v python3 >/dev/null 2>&1 && PY="python3"
JQ=""; command -v jq      >/dev/null 2>&1 && JQ="jq"

ENTREE="$(cat)"
[ -n "$ENTREE" ] || exit 0

lire() {
  if [ -n "$PY" ]; then
    printf '%s' "$ENTREE" | "$PY" -c '
import sys, json
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
v = d
for k in sys.argv[1].split("."):
    v = v.get(k) if isinstance(v, dict) else None
print(v if isinstance(v, str) else "")
' "$1" 2>/dev/null
  elif [ -n "$JQ" ]; then
    printf '%s' "$ENTREE" | "$JQ" -r --arg p "$1" \
      'getpath($p|split(".")) as $v | if ($v|type)=="string" then $v else "" end' 2>/dev/null
  fi
}

SESSION="$(lire session_id)"; [ -n "$SESSION" ] || SESSION="sans-session"
FICHIER="$(lire tool_input.file_path)"
[ -n "$FICHIER" ] || exit 0

case "$FICHIER" in /*) ABS="$FICHIER" ;; *) ABS="$ROOT/$FICHIER" ;; esac
ABS="$(realpath -m "$ABS" 2>/dev/null)" || exit 0
case "$ABS" in "$ROOT"/projet/*) : ;; *) exit 0 ;; esac
[ -f "$ABS" ] || exit 0

echecs() { # $1 = incr | reset ; affiche la valeur résultante
  if [ -n "$PY" ]; then
    "$PY" - "$COMPTEURS" "$SESSION" "$1" <<'PYEOF'
import sys, json, os, time
chemin, session, action = sys.argv[1], sys.argv[2], sys.argv[3]
d = {}
if os.path.exists(chemin):
    try:
        d = json.load(open(chemin))
        if not isinstance(d, dict): d = {}
    except Exception: d = {}
e = d.get(session) or {"debut": int(time.time()), "actions": 0, "echecs": 0}
e["echecs"] = int(e.get("echecs", 0)) + 1 if action == "incr" else 0
d[session] = e
try:
    tmp = chemin + ".tmp"; json.dump(d, open(tmp, "w")); os.replace(tmp, chemin)
except Exception: pass
print(e["echecs"])
PYEOF
  elif [ -n "$JQ" ]; then
    [ -f "$COMPTEURS" ] || echo '{}' > "$COMPTEURS" 2>/dev/null
    local t; t="$(date +%s)"
    local expr
    if [ "$1" = "incr" ]; then expr='.echecs += 1'; else expr='.echecs = 0'; fi
    "$JQ" --arg s "$SESSION" --argjson t "$t" \
      ".[\$s] = ((.[\$s] // {debut:\$t, actions:0, echecs:0}) | $expr)" \
      "$COMPTEURS" > "$COMPTEURS.tmp" 2>/dev/null && mv "$COMPTEURS.tmp" "$COMPTEURS"
    "$JQ" -r --arg s "$SESSION" '.[$s].echecs // 0' "$COMPTEURS" 2>/dev/null
  else
    echo 0
  fi
}

SORTIE=""; STATUT=0
verifier() {
  case "$ABS" in
    *.sh)   command -v bash >/dev/null && { SORTIE="$(bash -n "$ABS" 2>&1)"; STATUT=$?; }
            if [ $STATUT -eq 0 ] && command -v shellcheck >/dev/null 2>&1; then
              SORTIE="$(shellcheck -S error "$ABS" 2>&1)"; STATUT=$?
            fi ;;
    *.py)   command -v python3 >/dev/null && { SORTIE="$(python3 -m py_compile "$ABS" 2>&1)"; STATUT=$?; } ;;
    *.json) command -v python3 >/dev/null && { SORTIE="$(python3 -m json.tool "$ABS" /dev/null 2>&1)"; STATUT=$?; } ;;
    *.js|*.mjs|*.cjs) command -v node >/dev/null && { SORTIE="$(node --check "$ABS" 2>&1)"; STATUT=$?; } ;;
    *.yaml|*.yml) if command -v python3 >/dev/null; then
                    SORTIE="$(python3 -c 'import sys;
try:
    import yaml; yaml.safe_load(open(sys.argv[1]))
except ImportError: pass
except Exception as e:
    print(e); sys.exit(1)' "$ABS" 2>&1)"; STATUT=$?
                  fi ;;
    *) return 0 ;;
  esac
  return 0
}
verifier

# Vérification propre au projet, si elle existe et est exécutable.
if [ -x "$ROOT/projet/.brainiac-verif.sh" ] && [ $STATUT -eq 0 ]; then
  SORTIE="$("$ROOT/projet/.brainiac-verif.sh" "$ABS" 2>&1)"; STATUT=$?
fi

TENTATIVES_MAX="$(grep -E '^[[:space:]]*tentatives_max[[:space:]]*:' "$ROOT/ressources/budget.yaml" 2>/dev/null \
  | head -1 | sed -E 's/^[^:]*:[[:space:]]*//; s/[[:space:]]*(#.*)?$//')"
[ -n "$TENTATIVES_MAX" ] || TENTATIVES_MAX=3

if [ $STATUT -ne 0 ]; then
  N="$(echecs incr)"
  printf '%s\t%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${FICHIER}" "échec de vérification" >> "$ERREURS" 2>/dev/null
  {
    echo "Vérification en échec sur ${FICHIER} (échec ${N}/${TENTATIVES_MAX})."
    printf '%s\n' "$SORTIE" | head -20
    if [ "${N:-0}" -ge "$TENTATIVES_MAX" ] 2>/dev/null; then
      echo "Seuil atteint : arrête-toi. Copie les fichiers concernés dans quarantaine/AAAA-MM-JJ_hhmm_slug/,"
      echo "écris la leçon dans memoire/lecons.md, pose ta question dans humain/questions.md."
    fi
  } >&2
  exit 2
fi

echecs reset >/dev/null
exit 0
