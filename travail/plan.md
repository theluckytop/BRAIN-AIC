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
**Palier** : moyen (sonnet). Estimé 1,00 à 2,99 USD en sonnet au démarrage, 1,10 à 3,31 USD à la reprise (valeur retenue dans `estimations.md`) (l'estimateur classe « grand » sur le
mot-clé « securite » et mesure tout `projet/`, BRAINIAC Console incluse) ; plafond 5,00 USD.
**Démarrage** : 14:03 (session 1, arrêtée par le hook à 92 min). **Reprise : session 2, démarrée
≈ 14:45** ; arrêt à 60 min (≈ 15:45), limite du hook à 90 min (≈ 16:15). Finir l'étape en cours,
consigner, rendre la main. Aucun agent en tâche de fond qui ouvre des processus si moins de 60 min restent.
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
| 6b | **CSP (choix A de l'humain, 2026-09-29)** : hash sha256 du script d'amorçage inline de Trunk, calculé après `trunk build --release`, injecté dans `index.html` (meta) et `netlify.toml` (en-tête) ; script de calcul sans installation ; test qui échoue si en-tête et build divergent | lancement réel sous la CSP réelle (WebDriver headless) : la page rend, texte lu, 0 violation CSP en console ; test de divergence : contre-épreuve qui échoue | **fait (2026-09-29 14:50)** : `app/scripts/csp.mjs` (`--ecrire`, `--verifier`), hash dans `index.html`, `netlify.toml` ; build Netlify échoue si divergence ; preuves `docs/preuves/phase3/csp_hash.txt` (contre-épreuve : code 1 avant écriture) et `csp_reel.txt` (Firefox 149 : page rendue, 683 car. lus ; sans hash : page vide) ; reste 1 violation connue, l'`@import` Google Fonts de `bundle.css` (décision 2026-09-28) |
| 7 | Mesure du temps de vérification en WASM (`performance.now`, pires cas de `mesure_temps`) affichée sur une page de mesure, capturée par Firefox headless | < 50 ms en WASM, sortie consignée ; sinon constat et question | **fait sous la CSP réelle (15:07)** : pire cas 11,0 ms dans le fichier final (25 cas, Firefox 149, release), `temps_wasm_csp.txt:40` ; 13,0 ms d'une exécution antérieure non archivée |
| 8 | Captures clair/sombre de chaque composant contre `preview.html` ; `prefers-reduced-motion` ; contraste ≥ 4,5:1 sur les couleurs appliquées | captures comparées ; 0 couple sous 4,5:1 ; animation absente sous `reduce` | **fait (15:29), réserve sur le clavier** : 24/24 clavier+dessin avec rechargement de page avant T2c, T3, T5, T6 et le dessin ; 15/24 sans rechargement (3 essais archivés) ; défaut reproduit sur page statique sans l'app (6/6 avec Tab préalables, 0/6 sans) : hypothèse fortement étayée, cause non établie (Firefox 149 ou geckodriver) ; reduced-motion OK (curseur `px-blink` → `none`), contraste appliqué 14 couples × 2 thèmes, pire 7,00:1, 0 échec (limite : textes visibles au chargement seulement), Whiteboard corrigé (ordre des outils = `bundle.js`, note sans chevauchement à 4 largeurs, Effacer en `danger`), comparaison des captures rédigée dans le README des preuves (à l'œil, écarts de cadrage cités ; ExplainPanel et verdicts sans référence) |
| 9 | Qualité : `cargo test`, `clippy --all-targets -D warnings` (moteur et app), `fmt --check`, `trunk build --release` | 0 échec, 0 avertissement ; taille WASM gzip relevée (< 500 Ko) | **fait (15:07)** : test 17 (app) + 55 (moteur) OK, clippy `-D warnings` natif et wasm32 OK (2 `vec!` inutiles corrigés dans `mesure.rs`), fmt OK, `trunk build --release` OK, WASM 769 339 o brut, 164 735 o gzip (`taille_wasm.txt`, avant correctifs) ; build final 769 484 o, 164 766 o (`erratum_cloture.txt`) |
| 10 | Commit ; audit `pentest_entrees` + `pentest_config` (CSP, sorties, `inner_html`) avec le diff dans le prompt | 0 critique/élevé ou écarts traités | **fait (15:15)** : commits `26dbe0f`, `6519fce` ; `pentest/rapports/2026-09-29_maths_phase3/` : entrées 0 critique, 0 élevé, 0 moyen, 4 faibles, 2 informations ; config 0 critique, 0 élevé, 2 moyens hérités (V15.1.1, V15.2.1), 20 faibles ; correctif de relecture (`6519fce`, `34cad26`) ré-audité à la clôture : `pentest/rapports/2026-09-29_maths_phase3_cloture/` |
| 11 | Relecture `verificateur` (une par cycle, max 2 avant escalade), rapport dans `humain/a_valider/`, mémoire, `etat.md`, estimation | verdict rendu, rapport déposé | 1re relecture (26dbe0f) : NON CONFORME (7 écarts, dont 1 bloquant : preuve clavier), tous traités au commit `6519fce` ; 2e relecture (6519fce) : NON CONFORME (preuve clavier, README, plan), traitée au commit `34cad26` ; escalade, décision A de l'humain (clore avec réserve clavier) ; rapport déposé ; **relecture finale de `34cad26` à la clôture : CONFORME** (8 mineurs, erratum `84a03a5`) |

**Attention** : 3 relectures NON CONFORME sur une même heuristique ont coûté la phase 2. Ici, fixer
d'abord les critères vérifiables (table du verdict, contraste, clavier) et les tester avant de
soumettre. À `tentatives_max` (3) échecs sur un même problème : arrêt, `quarantaine/`, leçon, question.

**Suivi (2026-09-29, ≈ 14:35)** : étapes 1 à 6 faites et rejouées par moi. Contraste : script
`app/scripts/contraste.mjs`, 16 couples de tokens, 0 échec (pire texte 6,09:1). Étapes 7 et 8
(mesure WASM, captures, clavier, dessin, reduced-motion, contraste appliqué) confiées à `executant`
via geckodriver. Web-sys ajouté à `app/Cargo.toml` (déjà dans `Cargo.lock`, aucun téléchargement).
