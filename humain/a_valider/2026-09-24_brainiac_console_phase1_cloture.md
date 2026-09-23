# Proposition — 2026-09-24_brainiac_console_phase1_cloture

## Action proposée
Prendre acte de la clôture de la phase 1 : verdict de relecture **NON CONFORME sur un seul critère (test 14, déjà déclaré)**, audit différentiel sans nouveau constat, et reporter la preuve du repli opaque à la phase 6 (session X11 sans composition).

## Pourquoi
Ton approbation du 2026-09-24 subordonnait la clôture à la relecture, à l'audit différentiel et au dépôt des preuves. Les trois sont faits. Rien ne s'écrit au-delà sans ta décision sur le point ci-dessous. Aucun constat critique : rien ne bloque.

## Contenu exact
- **Relecture `verificateur` (après `9805a10`)** : 9 critères sur 10 conformes. Critère 4 (fenêtre) non conforme : le choix du repli quand le compositeur ne compose pas n'est ni testé ni observé ici (`composition=true` seul relevé). C'est l'écart « test 14 partiel » du rapport, sans changement. Les 4 corrections de `9805a10` sont effectives ; les 3 écarts déclarés le sont honnêtement.
- **Audit différentiel** (`pentest/rapports/2026-09-24_differentiel_phase1/`, avec `complement.md`) : `src/App.svelte` et `scripts/contraste.mjs` : 0 critique, 0 nouveau constat, 0 régression. Les icônes en SVG statiques n'introduisent aucune entrée variable.
- **Preuves** copiées et commitées : `projet/brainiac-console/docs/preuves/phase1/` (commit `eb8b542`, README de provenance). `travail/brouillons/` vidé.
- **Point non tranché** : que faire du test 14. Options : A le reporter en phase 6 (recommandée, la vérification exige une session X11 sans composition, non disponible ici) / B le faire tester par toi avant la phase 2 (`GDK_BACKEND=x11` sans compositeur) / C l'accepter sans autre preuve.
- Les rouges des yeux du logo ne sont pas un écart : le cahier (`cahier_des_charges_application.md:153`) fait du « regard rouge » un trait du logo de référence.

## Risques et réversibilité
- Risque : le repli opaque automatique reste non prouvé ; le réglage manuel « Translucidité » le couvre en attendant (test 15 réussi).
- Réversible : oui, seuls des fichiers sont ajoutés.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (option A, B ou C). C'est le seul endroit qui fait foi.
