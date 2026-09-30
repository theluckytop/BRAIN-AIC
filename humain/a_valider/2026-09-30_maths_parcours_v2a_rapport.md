# Proposition — 2026-09-30_maths_parcours_v2a_rapport

## Action proposée
Clore `maths_parcours_v2a` (code dans `projet/maths`, **non commité**) et autoriser soit le commit par toi, soit des retouches ciblées (points 1 à 4), puis `maths_parcours_v2b` (corpus L1, à copier par toi avec sa ligne `validations.md`).

## Pourquoi
Livré : modale Parcours en deux vues (niveaux, puis programme du niveau), onglet « Cours » verrouillé jusqu'au choix d'un chapitre (extrait, statut, source, « cours manquant »), champ optionnel `sujets_examen`, bouton « Générer un énoncé » / « Nouvel énoncé » (Haiku, clé en mémoire), `source_citee_valide` branchée.
Relecture `verificateur` : **CONFORME avec réserves**, 0 bloquant, 2 mineurs. Rejoués : 80 + 55 tests, fmt, clippy natif et wasm32, `csp.mjs --verifier` (hash `sha256-QTBcTRcG…`), `inner_html` 0 ligne, `Cargo.toml`/`Cargo.lock` et `corpus.json` inchangés.
Preuves : `projet/maths/docs/preuves/parcours_v2a/` (chiffres recoupés par le relecteur). WASM 2 672 768 o brut, 377 717 o gzip -9.

## Contenu exact — points du rapport initial, état après corrections (demandées par l'humain)
1. **Chapitre non restauré au rechargement** : **corrigé** (`parcours.rs` clé `brainiac-maths-chapitre`, `main.rs`) ; test `restaurer_chapitre_aller_retour_et_replis` ; observé dans Firefox headless (onglet Cours débloqué après rechargement, repli sur valeur corrompue) ; `docs/preuves/parcours_v2a/5_correctif_point1.txt`.
2. **Bouton « Générer un énoncé » sans cours** : **gardé** (énoncé à partir du titre seul) ; à confirmer par toi.
3. **Bouton hors vue à 420 px, sujets sans CSS, marge** : **corrigé** (zone `.px-card__actions` sticky, 44 px, styles des sujets par variables de `tokens.css`). Observé : à 420 px le bouton est à y=446 (était 570), atteignable, dernier lien non masqué. **Limite** : une fois le corps défilé jusqu'en bas, le bouton sort par le haut (il est avant les liens dans le corps). Sujets d'examen : non observés (aucun dans le corpus). Menu ☰ vs note du tableau : **non reproduit** à 860 px de haut (0 px de chevauchement vertical), non testé à d'autres hauteurs ; non corrigé.
4. **Historique du chat** : **corrigé** pour la génération (chat vidé à chaque nouvel énoncé ; observé avec `faux_api.py` : 2 messages puis 0). **Restent** : un changement d'étape ne vide pas le chat ; une réponse du tuteur en vol pendant la génération s'ajoute à l'historique vidé.
5. Extrait de la 6e : « ab » à la place d'une fraction (défaut d'extraction du corpus, pas de l'app) : inchangé.

Rejoués par moi après les corrections : 82 + 55 tests, fmt, hash CSP (`sha256-PGmX9rQA…`), `inner_html` 0, `Cargo.toml`/`Cargo.lock`/`corpus` inchangés. WASM 2 677 482 o brut, 377 878 o gzip -9. Preuves : `6_points_3_4.txt`, `captures/p34_*`.
**Les corrections (points 1, 3, 4) n'ont pas été relues par un tiers** : la relecture `verificateur` CONFORME avec réserves porte sur la version d'avant.

## Risques et réversibilité
- **Non observé** : Haiku réel (aucun appel, appel testé par fonction injectée), sujets d'examen (aucun niveau n'en a avant v2b), écran réel ou tactile (le « 420 px » est un iframe ; `frame-ancestors` retiré du serveur de test pour cette seule requête), Tab dans la vue 2 (lu dans le code).
- « Chaque source mène à un cours » : faux pour les chapitres sans cours (CM2 0/20, 6e 3/23, 5e 2/25, 4e 3/16, 3e 5/15, Seconde 1/24, Première 5/10, Terminale 9/33), marqués « cours manquant » selon ta décision.
- Coût : ≈ 250 k jetons sonnet sur cette session (4 sous-agents : 44 k, 69 k, 68 k, 67 k) ; réel en USD non lisible depuis l'agent, à relever de ton côté (plafond 5,00 USD).
- Réversible : oui, rien n'est commité ; `git -C projet/maths diff` montre tout. `csp.mjs --ecrire` a réécrit `app/index.html`, `app/dist/index.html`, `netlify.toml` (nouveau hash voulu).

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
