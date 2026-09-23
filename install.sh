#!/usr/bin/env bash
# BRAINIAC — installation. Déterministe, idempotente, sans réseau ni privilège.
# Usage :  bash install.sh
set -uo pipefail

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$RACINE" || exit 1
ECHECS=0
ok()    { printf '  OK       %s\n' "$1"; }
info()  { printf '  ·        %s\n' "$1"; }
echec() { printf '  ÉCHEC    %s\n' "$1"; ECHECS=$((ECHECS + 1)); }

echo "BRAINIAC — installation dans $RACINE"
echo
echo "1. Environnement"
if [ "${BASH_VERSINFO[0]:-0}" -ge 4 ]; then ok "bash ${BASH_VERSION%%(*}"
else echec "bash 4 minimum requis"; fi
for o in realpath sed grep awk date sha256sum; do
  command -v "$o" >/dev/null 2>&1 && ok "$o" || echec "$o absent (apt install coreutils)"
done
command -v git >/dev/null 2>&1 || info "git absent : utile pour projet/ (apt install git)"
if command -v python3 >/dev/null 2>&1; then ok "python3"
elif command -v jq >/dev/null 2>&1; then info "python3 absent, jq utilisé en repli ; estimer.py sera indisponible"
else
  echec "ni python3 ni jq : les hooks ne peuvent pas lire leur entrée.
           apt install python3   (ou : apt install jq)"
fi

echo
echo "2. Intégrité de l'archive"
if [ -f MANIFESTE.sha256 ]; then
  if sha256sum -c --quiet MANIFESTE.sha256 2>/dev/null; then ok "fichiers conformes au manifeste"
  else echec "un fichier diffère du manifeste : archive incomplète ou altérée"; fi
else
  info "MANIFESTE.sha256 absent : contrôle ignoré"
fi
if [ -f pentest/referentiels/EMPREINTES.txt ]; then
  ( cd pentest/referentiels && sha256sum -c --status EMPREINTES.txt ) \
    && ok "référentiels de sécurité intacts" || echec "référentiel de sécurité altéré"
fi

echo
echo "3. Dossiers et droits"
for d in travail/brouillons livrables pentest/rapports humain/taches/pieces_jointes \
         quarantaine memoire/contexte journal projet versions/update versions/historique; do
  mkdir -p "$d" && [ -e "$d/.gitkeep" ] || [ "$(ls -A "$d" 2>/dev/null)" ] || touch "$d/.gitkeep"
done
ok "arborescence complète"
chmod +x .claude/hooks/*.sh .claude/outils/verifier.sh .claude/outils/estimer.py install.sh 2>/dev/null
ok "scripts exécutables"

echo
echo "4. État initial (rien n'est écrasé)"
[ -s journal/actions.log ]     || printf '# horodatage\tsession\toutil\tcible\tdecision\traison\n' > journal/actions.log
[ -s journal/erreurs.log ]     || printf '# horodatage\tfichier\terreur\n' > journal/erreurs.log
[ -s journal/.compteurs.json ] || echo '{}' > journal/.compteurs.json
ok "journal prêt"
for f in memoire/lecons.md memoire/decisions.md humain/etat.md; do
  [ -f "$f" ] || echec "$f manquant"
done
ok "mémoire et tableau de bord préservés"

echo
echo "5. Autotest des réflexes (sur copie jetable, l'espace n'est pas touché)"
if bash .claude/outils/autotest.sh > /tmp/brainiac_autotest.log 2>&1; then
  ok "$(grep -c "OK " /tmp/brainiac_autotest.log) contrôles passés"
else
  echec "autotest en échec, détail :"; grep "ÉCHEC" /tmp/brainiac_autotest.log | head -10
fi

echo
echo "6. Diagnostic"
bash .claude/outils/verifier.sh
DIAG=$?

echo
if [ "$ECHECS" -gt 0 ] || [ "$DIAG" -ne 0 ]; then
  echo "Installation incomplète : corrige les points ci-dessus, puis relance bash install.sh"
  exit 1
fi
cat <<'FIN'
Installation terminée.

Il te reste trois choses, qu'aucun script ne peut décider à ta place :

  1. Tarifs   — renseigne les prix dans ressources/arbitrage.yaml et la date de relevé.
                Sans eux, l'estimateur refuse de chiffrer. C'est voulu.
  2. Protection — pour rendre les zones [R] inaltérables au niveau du système :
                chmod a-w AGENTS.md CLAUDE.md ressources/*.yaml .claude/settings.json
                chmod -R a-w .claude/hooks .claude/outils pentest/referentiels
                (à défaire avec u+w quand tu veux les modifier toi-même)
  3. Démarrage — lance claude depuis CE dossier. Les hooks refusent de travailler ailleurs.

Ensuite : dépose ton code dans projet/ et ta première tâche dans humain/taches/.
FIN
exit 0
