# Proposition — 2026-09-30_maths_corpus_rapport

## Action proposée
Accepter le corpus de maths CM2 à Terminale (`projet/maths/corpus/`, commits `1740291` à `11b65e2`) comme livré, trous
marqués, et ouvrir la tâche `maths_parcours` (déjà approuvée « après livraison du corpus »).

## Pourquoi
Ta réponse A du 2026-09-30 (02:45) clôt le corpus tel quel. `maths_parcours` attend cette livraison. Si tu ne fais rien,
le parcours ne démarre pas.

## Contenu exact
- `corpus/construire.py` (python3 stdlib, rejouable `--hors-ligne` depuis `corpus/cache/`), `couverture.py`, `README.md`
  (schéma v2), `sortie/corpus.json`, `sortie/couverture.md`, `docs/{reperage,pertinence,preuves}`.
- Chiffres (recomptés par le `verificateur`) : 8 niveaux, chacun avec sa source officielle (data.education.gouv.fr) ;
  **166 notions** (thèmes du référentiel Coopmaths, forge.apps.education.fr, commit 11847f7) ; **841 exercices** (titres et
  liens seulement, AGPL-3.0) ; **28 extraits de cours Wikiversité, dont 10 douteux** ; CM2 0/20, Seconde 1/24 (douteux).
- Relecture `verificateur` de `f2ba25e` : **CONFORME**, aucun écart bloquant. JSON valide ; rejeu hors ligne identique hors
  date, 0 appel réseau ; `couverture.md` égal à la sortie de `couverture.py` ; `url`, `licence`, `recupere_le` et
  `statut: "GÉNÉRÉE"` sur tous les objets ; aucun doublon d'extrait non marqué ; hôtes limités à l'accord ; aucun fichier
  hors `corpus/` touché ; aucun secret (une adresse publique `contact@coopmaths.fr` dans un cache de page).
- Écarts mineurs relevés et corrigés dans le README (commit `11b65e2`, non relu par un tiers) : champ `collision_avec` et
  règle de collision 5d non documentés, « Seconde : aucun extrait » faux, compte d'objets (1 047, pas 1 045), nombre
  d'appels périmé.
- Non vérifié par la relecture : les ~330 pages Wikiversité en cache, relues à l'œil ; l'absence de mise à jour réseau du
  clone local de la forge.

## Écarts à la tâche et au plan
- Référentiel Coopmaths absent de GitHub : deux extensions d'accord (forge.aeif.fr inexistant, puis forge.apps.education.fr).
- Wikibooks écarté (correspondances aberrantes).
- Étape 5d : **≈ 510 appels Wikiversité au lieu de ~350** (une relance rejouait le cache ; corrigé, leçon écrite).
- Budget : estimation initiale 1,26 à 3,77 USD ; mon relevé fait ≈ 3 USD de sous-agents sonnet sur l'ensemble des
  sessions (≈ 450 k jetons), plus le pilotage en opus. **Le réel est à relever de ton côté** : le plafond de 5 USD a pu
  être dépassé à cause du pilotage.

## Risques et réversibilité
- Risque : 138 notions sans cours. `maths_parcours` devra produire des fiches (marquées GÉNÉRÉE et relues par toi) ou
  n'afficher que les exercices. 10 extraits douteux restent à écarter ou à relire avant de les montrer.
- Réversible : oui, tout est commité dans `projet/maths` ; aucun livrable publié, aucun push.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
