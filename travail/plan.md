# Plan — Application de maths, phase 3 : composants Leptos

**Objectif** : dans `projet/maths/app/`, AppShell, ConsigneCard, Whiteboard, MenuButton, Button,
ExplainPanel et retour de verdict (Leptos 0.8 CSR), reliés au moteur, sur une page de démonstration
à données fixes. Styles `tokens.css` / `bundle.css` inchangés.
**Périmètre** : `projet/maths/app/` seulement (`moteur/` intouché : N-01 accepté, reporté).
Réseau : crates.io et Trunk selon l'accord de la phase 0 ; **aucun `npm install`, aucune installation**
(pas de `wasm-bindgen-cli`, pas de Selenium). Outils déjà là : Trunk 0.21.14, Firefox (mode
`--headless --screenshot`), node.
**Base d'accord** : ligne du 2026-09-29 dans `validations.md` ; tâche `humain/taches/maths_phase3.md` ;
question budget du 2026-09-29 : **B, tâche entière en sonnet**, opus seulement sur échec constaté.
**Palier** : moyen (sonnet). Estimé 1,00 à 2,99 USD en sonnet (l'estimateur classe « grand » sur le
mot-clé « securite » et mesure tout `projet/`, BRAINIAC Console incluse) ; plafond 5,00 USD.
**Démarrage** : 14:03. Arrêt à 60 min (≈ 15:03) : finir l'étape en cours, consigner, rendre la main.
**Règles** : jamais de `cd` nu (`--manifest-path`, `git -C`, sous-shell). Preuves `.txt` dans
`projet/maths/docs/preuves/phase3/`, ouvertes avant citation. Texte de l'élève et messages : texte
seulement (`{}` de Leptos), jamais `inner_html`. Noir et blanc strict (pas de rouge/vert).
**Sources** : aperçus `travail/brouillons/tableau-pixel/components/*/preview.html` (copie jetable).

| # | Étape | Critère de réussite | Statut |
|---|---|---|---|
| 1 | Squelette : modules `composants/` dans `app/src`, page de démonstration, classes `px-*` de `bundle.css` réutilisées | `cargo check -p app --target wasm32-unknown-unknown` sans erreur | fait : `app/src/composants/`, page de démo ; check wasm32, trunk build OK |
| 2 | Button (default, primary, ghost, danger), MenuButton (`aria-expanded`), AppShell (grille, tiroir) | rendu fidèle aux `preview.html` (étape 8) ; Tab/Entrée/Espace actionnent tout contrôle | fait : `button.rs`, `menu_button.rs`, `app_shell.rs` ; rendu et clavier : à observer (étape 8) |
| 3 | ConsigneCard (tag inversé, navigation ◀ n/N ▶) et ExplainPanel (onglets SIMPLE / POURQUOI, `role="tablist"`, flèches) | clavier complet ; texte seul | fait : `consigne_card.rs`, `explain_panel.rs` (ARIA tablist) ; rendu et clavier : à observer (étape 8) |
| 4 | Whiteboard : canvas, grille 16 px, crayons noir/gris, tailles 1/3/6, gomme, effacer, encoche | dessin à la souris et au clavier-tactile équivalent documenté ; `aria-pressed` sur les outils | fait : `whiteboard.rs`, 3 tests natifs ; dessin à observer (étape 8) |
| 5 | Verdict : `Juste`, `ASimplifier`, `FormeIncorrecte`, `Faux`, `SaisieInvalide`, `ErreurReference` → libellé, glyphe et inversion, sans rouge/vert ; `role="status"` ; aucune pénalité | table de correspondance testée : 6 cas natifs (`cargo test -p app`), libellés jamais vides ni punitifs | fait : `verdict.rs`, 7 tests natifs (6 cas + mots punitifs) ; relu et rejoué par moi |
| 6 | Liaison moteur : champ de saisie + `moteur::verifier` sur exercices fixes ; `ErreurReference` = « exercice défectueux », jamais faute de l'élève | test natif : `ErreurReference` ne produit ni « Faux » ni « Juste » ; recherche `inner_html` : 0 occurrence (consignée) | fait : `exercice.rs`, `juger` testé (7 tests) ; `inner_html` : 0 ligne (rejoué) ; 17 tests app, clippy 2 cibles, fmt OK |
| 7 | Mesure du temps de vérification en WASM (`performance.now`, pires cas de `mesure_temps`) affichée sur une page de mesure, capturée par Firefox headless | < 50 ms en WASM, sortie consignée ; sinon constat et question | à faire |
| 8 | Captures clair/sombre de chaque composant contre `preview.html` (Firefox headless) ; `prefers-reduced-motion` ; contraste ≥ 4,5:1 calculé sur les couples de tokens réellement utilisés (script node, sans dépendance) | captures comparées et commentées ; 0 couple sous 4,5:1 ; animation absente sous `reduce` | à faire |
| 9 | Qualité : `cargo test`, `clippy --all-targets -D warnings` (moteur et app), `fmt --check`, `trunk build --release` | 0 échec, 0 avertissement ; taille WASM gzip relevée (< 500 Ko) | à faire |
| 10 | Commit ; audit `pentest_entrees` + `pentest_config` (CSP, sorties, `inner_html`) avec le diff dans le prompt | 0 critique/élevé ou écarts traités | à faire |
| 11 | Relecture `verificateur` (une par cycle, max 2 avant escalade), rapport dans `humain/a_valider/`, mémoire, `etat.md`, estimation | verdict rendu, rapport déposé | à faire |

**Attention** : 3 relectures NON CONFORME sur une même heuristique ont coûté la phase 2. Ici, fixer
d'abord les critères vérifiables (table du verdict, contraste, clavier) et les tester avant de
soumettre. À `tentatives_max` (3) échecs sur un même problème : arrêt, `quarantaine/`, leçon, question.

**Suivi (2026-09-29, ≈ 14:35)** : étapes 1 à 6 faites et rejouées par moi. Contraste : script
`app/scripts/contraste.mjs`, 16 couples de tokens, 0 échec (pire texte 6,09:1). Étapes 7 et 8
(mesure WASM, captures, clavier, dessin, reduced-motion, contraste appliqué) confiées à `executant`
via geckodriver. Web-sys ajouté à `app/Cargo.toml` (déjà dans `Cargo.lock`, aucun téléchargement).
