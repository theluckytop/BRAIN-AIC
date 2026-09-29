# Proposition — 2026-09-28_maths_phase1_rapport

## Action proposée
Clore la phase 1 de l'application de maths (socle Leptos + Trunk, commits `0b23065`, `61fe849`,
`65c4265` du dépôt `projet/maths/`) et autoriser la phase 2 (moteur mathématique) comme nouvelle tâche.

## Pourquoi
Point de contrôle prévu par le plan par phase de `humain/a_valider/2026-09-28_maths_phase0.md`.
Sans ton accord, rien ne s'écrit au-delà de la phase 1.

## Contenu exact

### 1. Livré
| Élément | Où |
|---|---|
| Espace Cargo : `moteur` (bibliothèque pure, sans dépendance web) + `app` (Leptos 0.8.21 CSR, Trunk 0.21.14) | `Cargo.toml`, `moteur/`, `app/` |
| `tokens.css` et `bundle.css` de Tableau Pixel, repris à l'identique (empreintes SHA-256 vérifiées deux fois, par moi puis par `verificateur`) | `app/public/tokens.css`, `app/public/bundle.css` |
| Polices Silkscreen et Pixelify Sans auto-hébergées (woff2, 5.3.0, MIT) ; KaTeX 0.18.9 et MathLive 0.110.0 installés, versions figées pour la phase 4 | `app/public/fonts/`, `app/public/fonts.css`, `app/package.json` |
| Squelette Leptos CSR minimal, écran vide conforme au thème | `app/src/main.rs`, `app/index.html` |
| CSP stricte en **en-tête HTTP réel** (`connect-src 'self'`, pas de domaine externe), `X-Content-Type-Options`, `Referrer-Policy`, `X-Frame-Options`, `Permissions-Policy` ; `<meta>` CSP en défense en profondeur dans `app/index.html` | `netlify.toml`, `app/index.html` |
| Configuration Netlify (site dans `app/`, publication depuis `app/dist`) et `rust-toolchain.toml` | `netlify.toml`, `rust-toolchain.toml` |
| Preuves des vérifications (empreintes, build, recherches, qualité, `npm audit`) | `docs/preuves/phase1/` |

### 2. Critères d'acceptation de `humain/taches/maths_phase1.md`
| Critère | Résultat |
|---|---|
| `trunk build --release` réussit ; sortie dans `dist/` | **réussi**, rejoué par moi puis par `verificateur` |
| `cargo clippy --all-targets` 0 avertissement ; `cargo fmt --check` propre | **réussi** sur `moteur` et `app`, rejoué par `verificateur` |
| `tokens.css`/`bundle.css` repris sans modification, empreintes identiques | **réussi**, `sha256sum` recalculé deux fois |
| Aucune ressource chargée hors du site (CSP stricte, polices locales) | **réussi sur le fond** ; 1 exception connue et documentée (§4) |
| Taille du WASM compressé relevée | **108 959 o brut / 29 413 o compressé gzip** (objectif du cahier : < 500 Ko), recalculé par `verificateur` |
| `netlify.toml` et `rust-toolchain.toml` présents, sans publication | **réussi**, aucune commande de publication dans l'historique |

### 3. Dépendances effectives (versions figées par les fichiers de verrouillage)
Rust : `leptos` 0.8.21 (`csr`), `wasm-bindgen` 0.2.129, `console_error_panic_hook` 0.1, `console_log`
1.0, `log` 0.4. `moteur` n'a encore aucune dépendance (bibliothèque vide, phase 2 y ajoutera
`num-rational` comme prévu).
npm (`app/package.json`, sert uniquement à figer et copier des fichiers statiques, aucun JS écrit à
la main n'est exécuté par l'app en phase 1) : `katex` 0.18.9, `mathlive` 0.110.0,
`@fontsource/silkscreen` 5.3.0, `@fontsource/pixelify-sans` 5.3.0.
- **Écart de version signalé en phase 0** : `@fontsource/silkscreen`/`pixelify-sans` avaient été
  annoncés en 5.2.9 (extrapolation depuis KaTeX/MathLive, non vérifiée) ; la version réelle disponible
  est 5.3.0. Sans conséquence (paquet mineur, mêmes fichiers de police), mais à noter : une version
  non vérifiée par une lecture directe du registre peut être fausse.
- `npm` 9.2.0 (paquet Ubuntu) reste ancien : avertissement `EBADENGINE` sur une dépendance de
  `mathlive` (`@cortex-js/compute-engine` demande npm ≥ 10.5.0) lors de l'installation. Sans effet en
  phase 1 (KaTeX/MathLive ne sont pas encore intégrés au rendu) ; à surveiller en phase 4.

### 4. Écarts
- **`app/public/bundle.css:2` garde son `@import url("https://fonts.googleapis.com/...")` d'origine.**
  Décision du 2026-09-28 (`memoire/decisions.md`) : le fichier devait rester identique, octet pour
  octet, à l'archive `tableau-pixel.zip` ; la CSP réelle bloque cet import sans perte, puisque les
  mêmes familles de polices sont déjà déclarées localement par `app/public/fonts.css`. C'est la seule
  occurrence de `https://` dans le site publié (`dist/`), vérifiée deux fois (moi, puis
  `verificateur`).
- **Relecture `verificateur` du 2026-09-28 : NON CONFORME**, sur deux écarts, tous deux corrigés au
  commit `65c4265`, **sans seconde relecture** (même pratique qu'à la phase 2 de BRAINIAC Console) :
  1. Le critère littéral de l'étape 4 du plan (« 0 occurrence de `fonts.googleapis` ») ne tenait pas
     compte de l'exception ci-dessus ; le plan a été corrigé pour la rendre explicite.
  2. Les preuves étaient dans `app/docs/preuves/` au lieu de `docs/preuves/` écrit dans le plan,
     ce qui cassait le lien relatif du `README.md`. Déplacées à l'emplacement prévu.
  Sur le fond technique (build, tests, empreintes, taille du WASM), `verificateur` a tout rejoué
  lui-même et n'a rien trouvé à redire.
- **Le réglage `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` (commit `972f10e`) ne protège pas d'un
  `cd` écrit dans la même commande** (`cd X && trunk build`) : la session s'est retrouvée dans
  `app/` pour l'appel suivant. Corrigé manuellement, leçon consignée (2026-09-28) : toujours un
  sous-shell `( cd … && … )`.
- **Aucune fenêtre de navigateur réellement ouverte** : le rendu visuel (thème, contraste,
  `prefers-reduced-motion`) n'est pas vérifié en phase 1, conformément au plan (composants et rendu
  visuel : phase 3).

### 5. Sécurité
Audit `pentest_config` (périmètre `application`, sous-périmètre `projet/maths/`, à distinguer de
`projet/brainiac-console/`), `pentest/rapports/2026-09-28_maths_phase1/` : **84 exigences** (V13, V15,
V16, WSTG-FW/INFO/CONF), 55 conformes, 8 partielles, 3 non conformes, 18 indéterminées.
**Gravité : 0 critique, 0 élevée**, 2 moyennes, 17 faibles. **Aucun constat critique ouvert.**
- Corrigés dans la foulée (commit `61fe849`) : `WSTG-CONF-14.1` (en-tête `Permissions-Policy` absent,
  ajouté) ; `V16.1.1` (inventaire de journalisation absent, documenté dans `README.md`).
- **V15.1.1 (moyenne), réglé le 2026-09-28** : politique de délai de correction des dépendances
  vulnérables fixée sur ta délégation explicite, identique à `projet/brainiac-console/` (critique
  7 j, élevée 30 j, moyenne 90 j, depuis la publication de l'avis). Documentée dans
  `projet/maths/README.md`, décision consignée dans `memoire/decisions.md` (commit `527a16b`).
- `npm audit --prefix projet/maths/app` : **0 vulnérabilité** (`docs/preuves/phase1/npm_audit.txt`).
  `cargo-audit` non installé (hors accord réseau de la phase 1) : à installer et lancer par toi, ou à
  demander en phase 2.
- Exemptions Tauri de `pentest/exemptions.md` (V3.\*/V5.\*, motivées par « pas de domaine public, IPC
  local ») **non appliquées** à `projet/maths/`, qui aura un domaine public réel sur Netlify : signalé
  explicitement dans le rapport d'audit pour éviter toute confusion future entre les deux applications.
- 18 constats indéterminés : en grande majorité des exigences liées à ce qui n'existe pas encore
  (journalisation applicative réelle, déploiement effectif, domaine public) — à réévaluer à la
  clôture d'une phase ultérieure, en particulier avant la première publication.

### 6. Estimation de la phase 2 (moteur mathématique)
Ampleur du plan de phase 0 : analyseur d'expressions, fractions exactes (`num-rational`), test
d'équivalence par évaluation en points aléatoires, règles de forme simplifiée, équations du 1er degré,
avec `cargo test` pour chaque cas cité au cahier (`2(x+1)` ≡ `2x+2`, `6/8` → « à simplifier ») et une
mesure du temps de vérification (< 50 ms). Bibliothèque pure, sans interface : plus circonscrite que
la phase 1. Compter une session courte à moyenne (30 à 60 min, 60 à 100 actions). Je relance
`estimer.py` au démarrage de la tâche ; la mesure restera faussée par `projet/brainiac-console/`
existant (périmètre mesuré = tout `projet/`), donc indicative.

### 7. Coût réel de la phase 1
Non lisible depuis l'agent (même limite que toutes les tâches précédentes de cet espace, cf.
`memoire/estimations.md`). Estimé : 0,62 à 1,86 USD (sonnet), plafond 5,00 USD tenu. Deux sous-agents
utilisés (`pentest_config`, `verificateur`), en tâche de fond.

## Risques et réversibilité
- Risque : la phase 1 ne prouve rien visuellement (pas de fenêtre de navigateur lancée) ; un défaut de
  rendu du thème Tableau Pixel en Leptos ne serait découvert qu'en phase 3.
- Risque : `npm` 9.2.0, ancien, a déjà produit un avertissement `EBADENGINE` ; une dépendance future
  de KaTeX/MathLive pourrait exiger une version plus récente, hors du périmètre réseau déjà accordé.
- Réversible : oui. Tout vit dans `projet/maths/`, dépôt local jamais poussé ; les installations
  système (`trunk`, cible `wasm32-unknown-unknown`) se retirent par `cargo uninstall trunk` et
  `rustup target remove wasm32-unknown-unknown`.

### 8. Brouillon de fichier de tâche, à copier par toi dans `humain/taches/maths_phase2.md`
```markdown
# Application de maths — phase 2 : moteur mathématique

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Implémenter, dans la bibliothèque `moteur` (déjà créée, vide, phase 1), le moteur mathématique du
MVP décrit dans `humain/dossier-projet-maths/dossier/Cahier des charges.md` : analyseur
d'expressions, fractions exactes, test d'équivalence, détection de forme non simplifiée, équations
du premier degré. Entièrement testé par `cargo test` natif, sans aucune dépendance web.

## Contexte
- Référence : cahier des charges, § « Vague 1 — MVP » (ligne Vérification) et § « Architecture et
  stack technique » (ligne Moteur mathématique) : « analyseur d'expressions, fractions exactes
  (crate `num-rational`), test d'équivalence par évaluation en points aléatoires, règles de forme
  simplifiée ». Périmètre du MVP uniquement : fractions, puissances, équations du 1er degré —
  aucun calcul formel plus avancé (dérivées, limites, etc.), c'est hors vague 1.
- `num-rational` 0.4.2 déjà vérifiée en phase 0 (`humain/a_valider/2026-09-28_maths_phase0.md §1`),
  à ajouter aux dépendances de `moteur/Cargo.toml` (vide pour l'instant).
- Code dans `projet/maths/moteur/` (dépôt existant, phase 1 approuvée). Ne touche pas à `projet/maths/app/`.
- Exemples du cahier à couvrir par un test nommé explicitement : `2(x+1)` et `2x+2` reconnus
  équivalents ; `6/8` signalé « juste mais à simplifier ».
- `moteur` reste une bibliothèque pure, sans dépendance web : c'est la « porte de sortie » du cahier
  si l'apprentissage de Leptos s'avérait trop lent (§ Architecture, « Autres stacks envisagées »).

## Critères d'acceptation
- [ ] Analyseur d'expressions arithmétiques : nombres, fractions, `+ - * / ^`, parenthèses, variable `x`
- [ ] Fractions exactes (`num-rational`) : addition, soustraction, multiplication, division, simplification
- [ ] Test d'équivalence de deux expressions par évaluation en plusieurs points aléatoires ; `2(x+1)` ≡ `2x+2` testé nommément
- [ ] Détection de forme non simplifiée ; `6/8` → « juste mais à simplifier » testé nommément
- [ ] Vérification d'une équation du premier degré face à une réponse candidate (ex. `x = -2`)
- [ ] `cargo test -p moteur` : tous verts ; `cargo clippy -p moteur --all-targets` : 0 avertissement ; `cargo fmt --check` propre
- [ ] Temps d'une vérification mesuré et consigné en preuve : < 50 ms (exigence du cahier, § Exigences non fonctionnelles)
- [ ] `moteur/Cargo.toml` ne liste aucune dépendance web (vérifiable : seule `num-rational`, éventuellement `rand` pour l'évaluation en points aléatoires)

## Hors périmètre
Interface (composants Leptos : phase 3), KaTeX/MathLive (phase 4), contenu des 30 exercices (phase 5),
tout calcul formel au-delà du périmètre du MVP, toute modification de `app/`.
```

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (phase 1 close, phase 2 autorisée ou non), puis
dépose le brouillon du §8 dans `humain/taches/maths_phase2.md`. C'est le seul endroit qui fait foi.
