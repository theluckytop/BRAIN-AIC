# Proposition — 2026-09-30_maths_parcours_rapport

## Action proposée
Approuver la tâche `maths_parcours` telle que livrée (commit `9d683f1` dans `projet/maths`, local, non poussé) et trancher les 4 points ci-dessous. Suite prévue : responsivité + clé API persistante + cahier des charges, en nouvelle session.

## Pourquoi
Menu ☰ → Parcours : modale des 8 niveaux (CM2 à Terminale) avec leur source officielle ; choisir un niveau remplace les 3 énoncés du bandeau par une étape par notion (décision A : titre, extrait de cours s'il existe, sinon titres d'exercices avec liens Coopmaths, aucun énoncé inventé) ; niveau et avancement conservés dans le navigateur ; Haiku reçoit l'extrait de la notion courante ; étiquettes GÉNÉRÉE / RELUE / DOUTEUX par notion. Ne rien faire laisse le corpus sans usage.

## Contenu exact
- Livré (`git -C projet/maths show 9d683f1 --stat` : 36 fichiers) : `corpus.rs` (corpus embarqué par `include_str!`), `modale.rs`, `parcours_modale.rs`, `parcours.rs`, bandeau réactif (`consigne_card.rs`), bloc `<cours>` du prompt (`api.rs`), hash CSP rejoué (`csp.mjs`), preuves dans `app/docs/preuves/parcours/` (README de provenance).
- Rejoué par moi puis par le `verificateur` : 62 tests app, 55 moteur, clippy `-D warnings` (natif et wasm32), fmt, `csp.mjs --verifier` code 0. Observations Firefox headless : 16/16 (bandeau, hors CSP) et 4/4 sous la CSP réelle.
- **Relecture `verificateur` : CONFORME avec réserves**, 0 bloquant, 6 critères conformes. `inner_html` : 0 ligne ; liens `https` seulement avec `noopener noreferrer` ; aucun `unwrap` de production sur le corpus ou le stockage ; aucune clé ni donnée personnelle stockée.
- Coût : estimation `estimer.py` 8,4 à 25,3 USD (artefact, `projet/` entier), la mienne 1,5 à 4,5 USD ; ≈ 425 k jetons sonnet (7 sous-agents dont un repris après une coupure de l'API). Réel en USD à relever de ton côté.

## Points à trancher
1. **Taille du WASM : 2 384 679 o brut, 348 933 o gzip** (objectif < 500 Ko tenu). Mon chiffre « ≈ 245 ko de corpus » était faux : c'était celui de la v1 ; le corpus v2 embarqué fait **802 514 o brut, 68 531 o gzip**. Reste inexpliqué ≈ 0,8 Mo : code ajouté et section `name` du WASM (1 082 204 o, 45 % du fichier, présente en release). Piste non appliquée : retirer la section `name` (`wasm-strip` est installé). Le build de la phase 3 (769 484 o, 164 766 o gzip) n'est attesté que par du texte (le dossier `preuves/phase3` est introuvable). Veux-tu que je traite la taille avant la suite ?
2. **Bandeau à 420 px** plafonné à 40 % de la hauteur : il serre le tableau (`bandeau_420px.png`). Une ligne de CSS ; valeur souhaitée ?
3. **CSS ≤ 480 px hors périmètre** (64 lignes dans `composants.css`) corrigeant un débordement horizontal déjà présent : à relire par toi.
4. **Citation de la source par Haiku non vérifiée à l'exécution** : `source_citee_valide` existe, testée, mais n'est pas branchée à l'interface. Le critère « cite une source réelle » repose sur le prompt seul. Branchement à décider (petit).

## Limites connues
Non observés : violations CSP du chargement initial côté client ; envoi du prompt et mesure 420 px sous la CSP réelle (hors CSP seulement) ; « Corpus indisponible » ; Haiku réel ; téléphone réel et lecteur d'écran. Tout le corpus est GÉNÉRÉE (0 RELUE) et 10 extraits sur 28 sont douteux. `parcours.py` est périmé (A10/A11) ; le README d'app cite encore `trunk serve` (page blanche sous cette CSP) ; le chiffre « 245 ko » figure aussi dans mes notes de session, corrigé ici.

## Risques et réversibilité
- Risque : faible ; application locale, aucun réseau à l'exécution hors appel Haiku déjà existant ; contenu de cours non relu.
- Réversible : oui, `git -C projet/maths revert 9d683f1` (commit local, aucun push).

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
