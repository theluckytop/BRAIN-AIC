# Proposition — 2026-10-01_maths_parcours_v3b_rapport

## Action proposée
Approuver v3b (tableaux, repères, figures et schémas dans le chat, couleur dans le chat seulement) et commiter les changements de `projet/maths`.

## Pourquoi
Accords du 2026-10-01 (`validations.md`) : spécification structurée validée, couleur dans le chat seulement, plafond 5,00 USD.
**Relecture `verificateur` : NON CONFORME au 1er passage** (1 bloquant, 4 mineurs) ; bloquant et 2 mineurs corrigés, **correctifs non relus par un tiers** (rejoués par moi).
- **B1 (bloquant, corrigé)** : le bandeau d'énoncé partage `texte_math` avec le chat ; une figure colorée y aurait été rendue. Désormais `Figures::Autorisees` dans `tableau_chat.rs` seulement, `Figures::Refusees` dans `consigne_card.rs` (texte « [Figure non affichée ici] »). Observé : 0 svg, 0 table, 0 `px-c-` dans le bandeau.
- M1 (corrigé) : caractères bidi et invisibles refusés dans les libellés. M4 (corrigé) : deux repères dans un message ont des ids `px-rogne-0` / `px-rogne-1` distincts, observé.
- Restent, non corrigés : **M2** (légende seulement à partir de deux couleurs : deux éléments sans nom, de même style et de couleurs différentes ne se distinguent que par la couleur) ; **M3** (graduations plafonnées à 40, aucun cas réel trouvé) ; cosmétique : étiquettes « A » et « C » superposées dans la figure de démonstration.

Fonctionnement : Haiku écrit un bloc ```figure {json}``` ; le code pur `figure.rs` le valide (types `tableau`, `repere`, `figure`, `schema`, clés fermées, couleurs = `noir`/`accent1..4`, styles plein/tirets/pointillés, 9 fonctions d'une liste fermée, bornes, NaN/inf refusés), puis `figure_svg.rs` dessine par le DOM (`create_element_ns`, nœuds texte, 0 `inner_html`). Un bloc invalide donne « [Figure non affichée : … ] » sans recopier le JSON. Couleurs dans `app/public/chat-couleurs.css` (2 thèmes), `tokens.css` inchangé.

Rejoué par moi : 144 + 55 tests, fmt, clippy `-D warnings` natif et wasm32, `contraste.mjs` 0 échec, `csp.mjs --verifier` OK (hash `HBoPJlLu…`), `Cargo.toml`/`Cargo.lock` inchangés. Observé sous la CSP réelle, Firefox headless, 1280 px et 420 px (iframe), thèmes clair et sombre. Preuves : `projet/maths/docs/preuves/parcours_v3b/`.
**Non observé** : le JSON réel de Haiku (aucune clé API : réponses simulées par un serveur local) ; aucun autre navigateur ; pas d'essai de figure dans un message de l'utilisateur (saisie sur une ligne).

## Points à trancher
1. M2 : imposer une légende dès qu'il y a une couleur (et pas deux) ? À corriger avant le commit, ou reporter ?
2. `MAX_TOKENS` passé de 1024 à 1536 (un JSON de figure peut tronquer la réponse) : accord ?
3. Le premier essai réel avec ta clé reste à faire : Haiku produira-t-il du JSON valide ? Un JSON mal formé donne un refus lisible, sans figure.
4. `composants.css:168` contient un `rgba(0,0,0,.55)` (fond de modale), antérieur à v3b : à laisser ?

## Contenu exact
```
git -C projet/maths add app/src app/public app/scripts app/index.html netlify.toml docs/preuves/parcours_v3b
git -C projet/maths commit -m "Parcours v3b : tableaux, repères, figures et schémas dans le chat (JSON validé), couleur du chat seulement, CSP rejouée"
```
(`app/dist/` est ignoré par git ; ajouter `app/src` couvre `figure.rs` et `figure_svg.rs`.)

## Risques et réversibilité
- Risque : JSON de Haiku mal formé (refus lisible), M2.
- Réversible : oui, `git revert` du commit.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
