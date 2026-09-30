# Proposition — 2026-09-30_maths_parcours_v2_tache

## Action proposée
Déposer par toi `humain/taches/maths_parcours_v2.md` (brouillon ci-dessous) et inscrire dans `validations.md` l'accord « API Claude à l'exécution » et, si tu retiens l'option B de la question, l'accord réseau « sujets d'examen du supérieur ». Je ne peux pas écrire dans `humain/taches/`.

## Pourquoi
Ta demande (session du 2026-09-30) : (1) choisir un niveau (ex. CM2) dans la modale Parcours affiche **tout le programme de ce niveau dans cette même fenêtre**, plus dans le « carton » des énoncés ; (2) cliquer un chapitre déverrouille un **troisième onglet « Cours »** ; (3) **chaque énoncé est généré par Haiku** ; (4) **chaque source mène à un cours, ou à des sujets d'examen pour le supérieur**.
Elle change des décisions déjà prises : la tâche `maths_parcours` disait « aucune API appelée à l'exécution » et « niveaux CM2 à Terminale » ; la décision A du 2026-09-30 03:05 disait « aucun énoncé inventé » (le bandeau affichait titres et liens). Rien n'est modifié tant que ces points ne sont pas tranchés.

## Contenu exact (brouillon de `maths_parcours_v2.md`)
- **Priorité** : haute · **Autonomie** : faire approuver · **Palier conseillé** : sonnet, nouvelle session.
- **Modale Parcours en deux niveaux** : liste des niveaux → programme du niveau (chapitres = notions du corpus, 166 au total) dans la même modale, retour possible, clavier, Échap, téléphone.
- **Onglet « Cours »** : verrouillé tant qu'aucun chapitre n'est choisi ; disponible ensuite, il montre l'extrait de cours du chapitre (statut GÉNÉRÉE / RELUE / DOUTEUX) et le lien de la source.
- **Énoncés** : générés à la demande par Haiku pour le chapitre choisi, dans le bandeau (comme aujourd'hui pour la réponse), avec le cours du chapitre dans le prompt ; `source_citee_valide` branchée pour vérifier la source citée.
- **Sources** : chaque chapitre porte un lien vers un cours ; les chapitres sans cours (CM2 : 0/20, Seconde : 1/24) restent marqués « cours manquant », rien d'inventé.
- **Critères** : `trunk build --release`, tests, clippy `-D warnings`, fmt, `csp.mjs --verifier`, observation en local sous la CSP réelle.

## Points qui te reviennent (aussi dans `questions.md`)
1. **API Claude à l'exécution** : accord séparé exigé par la phase 0 ; la clé reste saisie par l'utilisateur, jamais partagée. Le mécanisme d'appel Haiku existe déjà (`api.rs`, `connect-src https://api.anthropic.com`). Coût des énoncés à la charge de la personne qui saisit la clé.
2. **Supérieur** : le corpus s'arrête à la Terminale et ne contient aucun sujet d'examen. Il faut choisir les niveaux (L1, prépa, BTS…) et la source des sujets (nouvel accord réseau, licence à vérifier).
3. **Cours manquants** : 138 chapitres sur 166 n'ont pas d'extrait. Sans rédaction par l'agent (contenu non relu, dépassement probable du plafond de 5 USD), l'onglet « Cours » sera vide pour eux.
4. **Rapport `maths_parcours`** (4 points) non encore approuvé : ce travail part du commit `9d683f1`.

## Risques et réversibilité
- Risque : moyen. Énoncés générés non vérifiés par le moteur (le moteur corrige les réponses, pas les énoncés) ; coût API variable ; sujets d'examen sous licence à vérifier.
- Réversible : oui, commits locaux dans `projet/maths`, revert possible ; aucun push.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (accord API Claude, et accord réseau supérieur si B) et dépose `maths_parcours_v2.md`. C'est le seul endroit qui fait foi.
