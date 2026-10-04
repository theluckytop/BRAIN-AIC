# Maths — Parcours v3c2 : sortie structurée par outil (`input_schema`) et style sobre des tableaux et schémas du chat

À copier dans `humain/taches/maths_parcours_v3c2.md`, avec une ligne dans `validations.md` qui nomme l'API Claude (outil de sortie structurée dans le même appel, même hôte `api.anthropic.com`, aucune installation, aucun réseau à la construction) et le plafond de 5,00 USD.

- **Priorité** : normale
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
Faire produire à Haiku des figures dont les clés sont conformes par construction (outil à `input_schema`) au lieu d'un JSON écrit dans le texte, et donner aux tableaux et schémas du chat un style sobre, lisible, en dehors du thème pixel.

## Contexte
Suite de v3c1 (commit `0cfcc48` : clés inconnues ignorées, repère étendu, motif du refus, prompt strict, tableau Markdown). v3c1 rend le validateur tolérant ; v3c2 ajoute la garantie à la source. Option A de la question du 2026-10-01 (« sortie structurée par outil, recommandée ») et réponse « style sobre » à confirmer ci-dessous. Code : `app/src/api.rs` (`construire_requete`, `construire_suite`, `extraire_texte`, `SYSTEME`), `app/src/appel.rs`, `app/src/figure.rs` (validateur, qui reste en défense), `notation.rs`, `composants/figure_svg.rs`, `composants/texte_math.rs`, `app/public/chat-couleurs.css`. Le périmètre touche l'appel à l'API Claude : l'audit ciblé du tuteur (`pentest/rapports/2026-09-30_235422_maths_tuteur_anthropic/`, constats TA-01, CR-10, CR-12) s'applique ; v3c2 ne doit pas l'aggraver.
À confirmer par l'humain (écrire la réponse dans `questions.md`) : « hors du thème graphique » signifie-t-il un style sobre (police système, filets fins, en-tête distinct) **dans le chat seulement**, le reste de l'app gardant le thème pixel ? Hypothèse retenue ci-dessous.

## Critères d'acceptation
- [ ] L'appel à l'API Claude déclare un outil `figure` dont l'`input_schema` reflète le vocabulaire fermé de `figure.rs` (`tableau`, `repere`, `figure`, `schema`, couleurs par noms de liste fermée, bornes) ; même hôte, même clé, aucune dépendance ajoutée.
- [ ] Une réponse contenant un bloc `tool_use` de l'outil `figure` est convertie en un `Segment::Figure` au bon endroit du message ; la réponse texte seule (sans outil) et le bloc ```figure du texte continuent de fonctionner (repli).
- [ ] Le contenu de l'outil passe par le même validateur (`valider`, bornes, nœuds texte, contrôles bidi) : l'outil n'est jamais cru. Tests hostiles : entrée d'outil hors schéma, type inconnu, valeurs non finies, chaînes énormes, plusieurs blocs d'outil (borné), `tool_use` d'un autre nom ignoré.
- [ ] `MAX_TOKENS` et le nombre de blocs d'outil sont bornés ; une réponse tronquée au milieu d'un outil donne un refus lisible, pas un panneau vide.
- [ ] L'URL de base libre (TA-01) et la clé (CR-10) ne sont pas aggravées : la clé n'apparaît ni dans le schéma, ni dans un message d'erreur (`masquer_cle` couvre les nouveaux messages).
- [ ] Style sobre pour tableaux et schémas du chat uniquement : police système, filets fins, en-tête distinct, lisible en clair et en sombre, `contraste.mjs` 0 échec, `tokens.css` inchangé ; le noir et blanc strict reste la règle hors chat (couleur du chat par noms de liste fermée, jamais seule).
- [ ] Triangle ABC (A(1,1), B(5,1), C(1,4), angle droit en A), tableau de f(x)=2x+3 et schéma simple rendus avec le nouveau style, observés à 1280 et 420 px, clair et sombre ; bandeau d'énoncé sans figure (`Figures::Refusees` inchangé).
- [ ] Tests, fmt, clippy natif et wasm32, `contraste.mjs`, `csp.mjs --ecrire` puis `--verifier` verts ; `Cargo.toml`, `Cargo.lock`, `tokens.css` inchangés ; 0 `inner_html` ; relecture `verificateur` CONFORME.
- [ ] Essai réel avec la clé de l'humain : Haiku remplit l'outil (ou le rapport dit pourquoi non) ; le rapport dit ce que l'agent n'a pas pu observer.

## Hors périmètre
Mise en page du chat et accessibilité clavier du tableau défilant (v3c), renvoi automatique d'un bloc refusé à Haiku (option C, seulement si Haiku échoue encore après v3c2), corrections de l'audit du tuteur, tronquage de l'énoncé à 600 caractères, nettoyage des listes de clés mortes de `figure.rs` (peut se faire ici si trivial, signalé), v2b, push, déploiement.

## Estimation indicative
`estimer.py` surévaluera (périmètre `projet/` entier). Ma fourchette : 2,5 à 4 USD au palier sonnet. Si la borne haute dépasse le plafond de 5,00 USD, découper : (1) outil à `input_schema` et conversion, (2) style sobre et observation.
