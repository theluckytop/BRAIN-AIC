#!/usr/bin/env bash
# BRAINIAC — diagnostic. Lecture seule. Code 0 si tout va bien, 1 sinon.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
ROOT="$(cd "$ROOT" && pwd -P)"
ECHECS=0

ok()      { printf '  OK       %s\n' "$1"; }
degrade() { printf '  DÉGRADÉ  %s\n' "$1"; }
echec()   { printf '  ÉCHEC    %s\n' "$1"; ECHECS=$((ECHECS + 1)); }

echo "BRAINIAC — diagnostic  ($ROOT)"
echo
echo "Environnement"
if [ -r /etc/os-release ]; then
  . /etc/os-release
  case "${ID:-}${ID_LIKE:-}" in
    *debian*|*ubuntu*) ok "${PRETTY_NAME:-inconnu} — base Debian" ;;
    *) degrade "${PRETTY_NAME:-inconnu} — hors base Debian, non testé" ;;
  esac
else
  degrade "distribution indéterminée"
fi
ok "architecture $(uname -m)"
if [ "${BASH_VERSINFO[0]:-0}" -ge 4 ]; then ok "bash ${BASH_VERSION%%(*}"
else echec "bash ${BASH_VERSION%%(*} : version 4 minimum"; fi

for o in git realpath sed grep awk; do
  command -v "$o" >/dev/null 2>&1 && ok "$o présent" || echec "$o absent"
done
command -v python3 >/dev/null 2>&1 && ok "python3 présent" || degrade "python3 absent (apt install python3)"
command -v jq      >/dev/null 2>&1 && ok "jq présent"      || degrade "jq absent (apt install jq)"
command -v python3 >/dev/null 2>&1 || command -v jq >/dev/null 2>&1 || \
  echec "ni python3 ni jq : les hooks ne peuvent pas lire leur entrée (apt install jq)"
command -v shellcheck >/dev/null 2>&1 && ok "shellcheck présent" || degrade "shellcheck absent (apt install shellcheck)"
command -v claude >/dev/null 2>&1 && ok "claude $(claude --version 2>/dev/null | head -1)" || degrade "claude introuvable dans le PATH"
command -v codex  >/dev/null 2>&1 && ok "codex présent" || degrade "codex absent (facultatif)"

echo
echo "Structure"
for f in AGENTS.md CLAUDE.md .claude/settings.json .claude/hooks/garde_fou.sh \
         .claude/hooks/verif.sh .claude/outils/estimer.py .claude/outils/verifier.sh \
         ressources/budget.yaml ressources/arbitrage.yaml ressources/pentest.yaml \
         ressources/priorites.yaml ressources/versions.yaml humain/etat.md humain/questions.md \
         humain/taches/validations.md pentest/exemptions.md VERSION \
         .claude/outils/mettre_a_jour.py; do
  [ -f "$ROOT/$f" ] && ok "$f" || echec "$f manquant"
done
for d in humain/taches humain/a_valider travail/brouillons memoire/contexte \
         pentest/referentiels pentest/rapports projet livrables journal quarantaine \
         .claude/agents .claude/commands versions/update versions/historique; do
  [ -d "$ROOT/$d" ] && ok "$d/" || echec "$d/ manquant"
done

echo
echo "Scripts"
for s in .claude/hooks/garde_fou.sh .claude/hooks/verif.sh .claude/outils/verifier.sh; do
  [ -x "$ROOT/$s" ] && ok "$s exécutable" || echec "$s non exécutable (chmod +x)"
  bash -n "$ROOT/$s" 2>/dev/null && ok "$s syntaxe" || echec "$s erreur de syntaxe"
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck -S error "$ROOT/$s" >/dev/null 2>&1 && ok "$s shellcheck" || degrade "$s signalé par shellcheck"
  fi
done
if command -v python3 >/dev/null 2>&1; then
  python3 -c "import ast,sys; ast.parse(open(sys.argv[1]).read())" "$ROOT/.claude/outils/estimer.py" 2>/dev/null && ok "estimer.py compile" \
    || echec "estimer.py erreur de syntaxe"
  python3 -m json.tool "$ROOT/.claude/settings.json" /dev/null 2>/dev/null && ok "settings.json valide" \
    || echec "settings.json invalide"
elif command -v jq >/dev/null 2>&1; then
  jq -e . "$ROOT/.claude/settings.json" >/dev/null 2>&1 && ok "settings.json valide" || echec "settings.json invalide"
fi

echo
echo "Portabilité"
MOTIF_ABSOLU='(^|[^A-Za-z0-9_])/home/[a-z]|/Users/|/mnt/user-data'   # motif-portabilite
if grep -rInE "$MOTIF_ABSOLU" "$ROOT/.claude" "$ROOT/ressources" "$ROOT/AGENTS.md" 2>/dev/null \
     | grep -v 'motif-portabilite' | grep -vE '^[^:]*:[0-9]+:[[:space:]]*#' | head -3; then
  echec "chemin absolu détecté ci-dessus"
else
  ok "aucun chemin absolu en dur"
fi
[ "$(pwd -P)" = "$ROOT" ] && ok "répertoire courant = racine" \
  || degrade "répertoire courant différent de la racine : lance l'outil depuis $ROOT"
case "$(basename "$ROOT")" in
  BRAINIAC) ok "dossier nommé BRAINIAC" ;;
  *) degrade "dossier nommé $(basename "$ROOT") et non BRAINIAC" ;;
esac

echo
echo "Zones en lecture seule"
PROTEGES=0
for f in AGENTS.md CLAUDE.md .claude/settings.json ressources/budget.yaml; do
  [ -w "$ROOT/$f" ] || PROTEGES=$((PROTEGES + 1))
done
if [ "$PROTEGES" -eq 4 ]; then
  ok "zones [R] protégées au niveau du système"
else
  degrade "zones [R] modifiables par l'utilisateur courant — protection possible :"
  printf '           chmod a-w AGENTS.md CLAUDE.md ressources/*.yaml .claude/settings.json\n'
  printf '           chmod -R a-w .claude/hooks .claude/outils pentest/referentiels\n'
fi

echo
echo "Versions"
ok "version $(cat "$ROOT/VERSION" 2>/dev/null || echo inconnue)"
ATTENTE="$(ls -1 "$ROOT/versions/update"/*.zip 2>/dev/null | wc -l)"
if [ "$ATTENTE" -gt 0 ]; then
  degrade "$ATTENTE archive(s) en attente dans versions/update/ — à appliquer par l'humain :"
  printf '           python3 .claude/outils/mettre_a_jour.py --etat\n'
else
  ok "aucune mise à jour en attente"
fi
ok "$(ls -1 "$ROOT/versions/historique"/*.zip 2>/dev/null | wc -l) archive(s) dans l'historique"

echo
echo "Sécurité"
EMP="$ROOT/pentest/referentiels/EMPREINTES.txt"
if [ -f "$EMP" ] && command -v sha256sum >/dev/null 2>&1; then
  if ( cd "$ROOT/pentest/referentiels" && sha256sum -c --status EMPREINTES.txt ); then
    ok "référentiels intacts ($(grep -c . "$EMP") fichiers)"
  else
    echec "référentiel altéré : restaure la version d'origine"
  fi
else
  echec "EMPREINTES.txt absent ou sha256sum indisponible"
fi
if command -v python3 >/dev/null 2>&1; then
  N="$(python3 -c '
import json,sys
try:
    d=json.load(open(sys.argv[1]))
    print(d.get("total_requirements","?"))
except Exception: print("erreur")
' "$ROOT/pentest/referentiels/asvs-5.0.0-checklist.json" 2>/dev/null)"
  [ "$N" = "345" ] && ok "ASVS 5.0.0 : 345 exigences" || echec "ASVS illisible ou incomplet ($N)"
fi
TARIF="$(grep -E '^[[:space:]]*petit_prix_entree' "$ROOT/ressources/arbitrage.yaml" 2>/dev/null | sed -E 's/.*:[[:space:]]*//')"
if [ "${TARIF:-0}" = "0" ]; then
  degrade "tarifs non renseignés dans ressources/arbitrage.yaml : estimer.py refusera de chiffrer"
else
  ok "tarifs renseignés"
fi

echo
if [ "$ECHECS" -eq 0 ]; then
  echo "Verdict : opérationnel."
  exit 0
fi
echo "Verdict : $ECHECS échec(s) à corriger."
exit 1
