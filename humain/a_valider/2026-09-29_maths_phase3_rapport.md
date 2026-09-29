# Proposition — 2026-09-29_maths_phase3_rapport

## Action proposée
Clore la phase 3 (composants Leptos de `projet/maths/app/`) **avec une réserve sur la preuve clavier**, et autoriser la phase 4, ou demander une 3e relecture (voir `humain/questions.md`, 2026-09-29 15:30).

## Pourquoi
Livré et commité (`26dbe0f`, `6519fce`, `34cad26` dans `projet/maths`) : Button, MenuButton, AppShell, ConsigneCard, ExplainPanel, Whiteboard, Verdict (6 verdicts du moteur, noir et blanc, aucune pénalité), Exercice relié au moteur.
- **CSP** (ton choix A) : hash sha256 du script d'amorçage, script `app/scripts/csp.mjs`, build Netlify qui échoue si le hash diverge. L'app démarre sous la CSP réelle (Firefox 149) ; sans le hash, page vide (contre-épreuve).
- **Mesures** : temps de vérification WASM, pire cas 11 ms sous la CSP réelle (`temps_wasm_csp.txt:40`, seuil 50) ; WASM du build final 769 484 o, 164 766 o en gzip -9 (< 500 Ko, `erratum_cloture.txt`) ; contraste appliqué, 0 échec, pire 7,00:1 ; reduced-motion vérifié ; `inner_html` : 0 ligne ; 17 tests app + 55 moteur, clippy `-D warnings` natif et wasm32, fmt propres.
- **Relectures** : 1re NON CONFORME (7 écarts, tous traités), 2e NON CONFORME (preuve clavier conditionnelle, README et plan imprécis : traités ou nuancés au commit `34cad26`, non relus).
- **Audits** (`pentest/rapports/2026-09-29_maths_phase3/`, revue de code) : entrées 0 critique, 0 élevé, 0 moyen, 4 faibles ; config 0 critique, 0 élevé, 2 moyens hérités (V15.1.1, V15.2.1), 20 faibles ; erratum sur la ligne 16 du rapport de config. **Le correctif de relecture (CSS du verdict, démo, hash) n'a pas été ré-audité.**

## Clôture (2026-09-29, nouvelle session, opus)
- **Relecture finale de `34cad26` : CONFORME**, 0 bloquant, 8 mineurs (chiffres de preuves périmés,
  plan incomplet, pieds de fichiers) : corrigés par `erratum_cloture.txt` (commit `84a03a5`), ce
  rapport et `travail/plan.md`. Tests, clippy (2 cibles), fmt, hash CSP et `inner_html` rejoués par le
  relecteur.
- **Audit différentiel du correctif** (`pentest/rapports/2026-09-29_maths_phase3_cloture/`) :
  **0 critique, 0 élevé, aucune régression**. Config (base 84) : 2 moyens hérités, 20 faibles,
  V15.2.3 non conforme faible (code de démo en production) ; CLO-HASH-1 (indéterminé, l'auditeur n'a
  pas de shell) levé par la sortie brute de `csp.mjs --verifier`, code 0 (`erratum_cloture.txt` §6,
  commit `f852273`). Entrées : 0 régression, 4 conformes, 2 informations (IC-01
  `aria-expanded="true"` sur une cible vide de la démo ; IC-02 levé : `git diff --stat 26dbe0f 34cad26 -- app/`
  = les 4 fichiers du périmètre).

## Contenu exact
- Code : `projet/maths/app/src/composants/`, `main.rs`, `mesure.rs`, `public/composants.css`, `netlify.toml`, `index.html` ; commits ci-dessus (`git -C projet/maths log`).
- Preuves : `projet/maths/docs/preuves/phase3/` (README qui les décrit, notes de provenance).
- **Réserve clavier** : 24/24 avec rechargement de page avant 5 scénarios ; 15/24 sans (3 essais archivés). Firefox reçoit keydown, keypress, keyup d'Entrée sur le bon bouton mais ne produit pas de `click` après des Tab envoyés par le pilote. Reproduit sur une page HTML statique sans l'app (`enter_page_simple.txt`). Cause (Firefox ou geckodriver) non établie ; jamais testé avec un vrai clavier ni un écran.
- **À trancher** :
  1. Page `#mesure` et page de démonstration livrées en production : les mettre derrière une feature Cargo (recommandé) ou accepter.
  2. `maxlength` sur le champ de saisie (exporter la constante du moteur : touche `moteur/`, hors périmètre).
  3. `style-src 'unsafe-inline'` avec 8 attributs `style=` : les remplacer par des classes (phase 4 ?).
  4. `RUST_VERSION = "stable"` non épinglé : un autre compilateur change le hash et fait échouer le build (visible, pas silencieux) ; épingler.
  5. `@import` Google Fonts de `bundle.css` : violation CSP connue et sans perte (décision du 2026-09-28).
  6. Recommandations de l'audit de clôture, à retenir ou non pour la phase 4 : `csp.mjs` vérifie la CSP
     entière (pas seulement le hash) ; `--locked` au build Netlify ; `.env*` et `.netlify/` dans `.gitignore`.
- **Budget** : estimé 1,10 à 3,31 USD en sonnet (plafond 5,00 USD) ; réel non lisible depuis l'agent : 2 sessions, ≈ 100 actions dans la session 2, 4 sous-agents (2 audits, 2 relectures) ; clôture en opus : 3 sous-agents (≈ 231 k jetons).

## Risques et réversibilité
- Risque : une clôture avec une preuve clavier réservée ; un défaut réel d'activation au clavier (peu probable : reproduit sans l'app) ne serait vu qu'avec un vrai clavier.
- Réversible : oui, tout est commité dans `projet/maths` ; aucun push, merge ni déploiement.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
