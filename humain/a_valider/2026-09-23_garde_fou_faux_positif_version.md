# Proposition — 2026-09-23_garde_fou_faux_positif_version

## Action proposée
Rendre le motif `ecriture-zone-R` de `.claude/hooks/garde_fou.sh` sensible à la casse, et ne
reconnaître `AGENTS.md`, `CLAUDE.md` et `VERSION` que comme composants de chemin entiers.

## Pourquoi
Le motif actuel est testé par `grep -Eqi`, donc sans tenir compte de la casse, et `VERSION` y figure
sans délimiteur. Il suffit d'un déclencheur d'écriture (`>`, `tee`, `install`…) suivi, avant le prochain `|`
ou `;`, du mot « version » écrit n'importe comment. Deux refus à tort ont été journalisés le 2026-09-23 :
- un `cat >> humain/questions.md <<EOF` dont le texte contenait « installer … la version » ;
- `claude --option-inventee x --version 2>&1 | head`, où « inven**tee** » a été pris pour `tee`, et
  `--version` pour le fichier `VERSION`.
Sans correction, l'agent ne perd pas de protection, mais il se rabat sur les outils d'édition et
passe du temps à chercher la cause. Aucun risque de sécurité : c'est un excès de blocage.

## Contenu exact
```diff
--- a/.claude/hooks/garde_fou.sh
+++ b/.claude/hooks/garde_fou.sh
@@ -260,7 +260,11 @@
     bloquer "Push forcé refusé." "push-force"
   motif '(curl|wget)[^|]*\|[[:space:]]*(ba)?sh' && \
     bloquer "Téléchargement exécuté directement : refusé." "pipe-shell"
-  motif "(>|>>|sed[[:space:]]+-i|tee|truncate|shred|install)[^|;]*($ZONES_R)" && \
+  # Écriture vers une zone [R] : comparaison sensible à la casse, comme le système de fichiers.
+  # AGENTS.md, CLAUDE.md et VERSION ne comptent que comme composant de chemin entier :
+  # « --version » ou « la version » dans un texte ne sont pas le fichier VERSION.
+  ZONES_R_ECR="(^|[[:space:]'\"=/])(AGENTS\.md|CLAUDE\.md|VERSION)([[:space:]'\";&|)]|\$)|\.claude/|\.codex/|ressources/|humain/taches/|pentest/referentiels|pentest/exemptions\.md|versions/update/"
+  printf '%s' "$COMMANDE" | grep -Eq "(>|>>|sed[[:space:]]+-i|tee|truncate|shred|install)[^|;]*($ZONES_R_ECR)" && \
     bloquer "Cette commande écrit dans une zone en lecture seule.
 Passe par humain/a_valider/." "ecriture-zone-R"
```
Les autres motifs (`modif-zone-R`, `secrets`…) restent inchangés.

Ajouts suggérés à `.claude/outils/autotest.sh`, avant la ligne 72 (`echo "=== Versions ==="`) :
```bash
essai 13c "--version n'est pas VERSION"   0 "$(j_bash 'claude --option-inventee x --version 2>&1 | head -3')"
essai 13d "echo > VERSION reste bloqué"   2 "$(j_bash 'echo x > VERSION')"
essai 13e "tee vers AGENTS.md bloqué"     2 "$(j_bash 'printf a | tee AGENTS.md')"
```

## Vérification faite
Le hook, avant et après correctif, a été rejoué sur une copie jetable (dossier temporaire de session,
avec un faux `AGENTS.md`) par `travail/brouillons/test_garde_fou.sh`. Résultat : 20 cas, 0 échec.
- Toujours bloqués (code 2) : `> ressources/…`, `> VERSION`, `>> ./VERSION`, `> "VERSION"`,
  `tee AGENTS.md`, `sed -i … AGENTS.md`, `sed -i … CLAUDE.md`, `> .claude/…`, `> humain/taches/validations.md`,
  `> pentest/exemptions.md`, `> versions/update/x`, `npm install --prefix ressources/x`.
- Débloqués (2 avant, 0 après) : les deux commandes refusées à tort, citées plus haut.
- Toujours permis : `> humain/etat.md`, `> travail/…`, `claude --help 2>&1`.

## Risques et réversibilité
- Risque : un chemin écrit avec une autre casse (`ressources/` en majuscules, par ex.) ne serait plus
  reconnu. Sous Linux, c'est un autre dossier : la zone réelle n'est pas atteinte. Seul un système de
  fichiers insensible à la casse ferait exception, et ce n'est pas la cible (Ubuntu, ext4).
- Risque résiduel inchangé : le motif reste une heuristique textuelle, contournable par une
  indirection (variable, `eval`). Ce n'est pas nouveau : les outils Edit/Write restent contrôlés par
  chemin, et c'est là que repose la garantie.
- Réversible : oui, en rétablissant l'ancienne ligne.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`, puis applique toi-même le diff : `.claude/` est en
lecture seule pour moi. C'est le seul endroit qui fait foi.
