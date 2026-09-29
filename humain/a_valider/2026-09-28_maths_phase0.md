# Proposition — 2026-09-28_maths_phase0

## Action proposée
Réaliser l'application d'apprentissage mathématique de `humain/dossier-projet-maths/dossier/Cahier des charges.md`
(vagues 1 à 3), en Leptos CSR + Trunk publié sur Netlify, découpée en 16 phases d'une session chacune,
avec ton point de contrôle à la fin de chaque phase.

## Pourquoi
Tu as demandé le 2026-09-28 de réaliser ce projet, sur tout le cahier, avec la pile Leptos + Trunk
(réponses consignées dans `humain/questions.md`). Il n'existe encore aucun fichier de tâche : sans
tâche dans `humain/taches/` ni accord dans `validations.md`, je ne peux ni estimer (`estimer.py`
n'accepte qu'un fichier de `humain/taches/`), ni installer, ni écrire le moindre code.

## Contenu exact

### 1. Versions vérifiées (2026-09-28, lecture web seule)

| Élément | Constaté | Source | Verdict |
|---|---|---|---|
| Rust / cargo | 1.98.1 stable | `rustc --version` local | OK |
| Cible `wasm32-unknown-unknown` | **absente** (seule `x86_64-unknown-linux-gnu`) | `rustup target list --installed` | à installer |
| Trunk | **non installé** ; 0.21.14 stable (2025-05-08), 0.22.0-beta.5 en préversion | `which trunk`, crates.io API | installer **0.21.14** (pas de bêta) |
| Leptos | 0.8.21 stable (2026-09-26) ; 0.9.0-beta2 en préversion | crates.io API | retenir **0.8.x** |
| wasm-bindgen | 0.2.129 (2026-09-25) | crates.io API | OK |
| num-rational | 0.4.2 (2024-05-08) | crates.io API | OK (le cahier la nomme) |
| KaTeX | 0.18.9, MIT | registry.npmjs.org | OK |
| MathLive | 0.110.0, MIT | registry.npmjs.org | OK |
| Node.js | 22.22.1 | local | suffit pour récupérer KaTeX/MathLive et les polices |
| Déploiement Netlify d'une app Leptos CSR | `netlify.toml` identique à celui du cahier, plus un `rust-toolchain.toml` (canal stable, cible wasm32) | book.leptos.dev/deployment/csr.html | conforme au cahier |
| API Models | `GET https://api.anthropic.com/v1/models`, en-têtes `anthropic-version` et `x-api-key` | platform.claude.com/docs/en/api/models/list | OK pour la vague 2 |
| En-tête `anthropic-dangerous-direct-browser-access` | **documenté par le cahier, non vérifié dans cette session** : la page Models ne le mentionne pas | — | à prouver par un appel réel en tête de phase 6 |

### 2. Pile retenue
- Espace de travail Cargo dans `projet/maths/` (dépôt git propre, comme `brainiac-console`) :
  - crate `moteur` : bibliothèque Rust pure, **sans dépendance web**, testable par `cargo test` natif
    (c'est la « porte de sortie » du cahier : elle survit à un changement d'interface) ;
  - crate `app` : Leptos 0.8 en CSR, construite par Trunk, qui dépend de `moteur`.
- `tokens.css` et `bundle.css` de Tableau Pixel repris **tels quels**. `bundle.js` n'est pas repris : sa
  logique est réécrite en composants Leptos.
- Canevas du tableau blanc piloté par `web-sys`. KaTeX et MathLive derrière **un seul module Rust**
  (`passerelle_js`), testé à part (risque du cahier).
- Profil de compilation `opt-level = "z"`, `lto = true`, `wasm-opt` via Trunk ; cible : WASM compressé
  sous 500 Ko, mesurée à chaque phase.

### 3. Écarts au cahier que je propose, et pourquoi
1. **Polices auto-hébergées** (Silkscreen, Pixelify Sans, KaTeX) au lieu de fonts.googleapis.com : la
   CSP stricte du cahier interdit de charger quoi que ce soit depuis un domaine non maîtrisé.
2. **✓ / ✗ dessinés en SVG pixel**, pas en caractères : leçon du 2026-09-24 (une police embarquée ne
   couvre pas forcément ces glyphes ; Silkscreen et Pixelify sont à vérifier par `fc-query`). Le
   README de Tableau Pixel interdit aussi tout glyphe décoratif autre que ◀ ▶.
3. **Contenu rédigé par l'IA, relu par toi** : je peux produire les brouillons des 30 exercices et
   leurs textes SIMPLE / POURQUOI, et le moteur vérifie chaque réponse ; la relecture humaine exigée
   par le cahier reste la tienne, je ne peux pas me l'attribuer.
4. **Le cahier dit que la vague 2 dépend des retours du MVP** (« testé par 3 personnes »). Tu as
   choisi tout le cahier : je planifie les trois vagues, mais je propose de revoir les phases 6 à 16
   après ce test, sans les ouvrir avant.

### 4. Plan par phase (une tâche BRAINIAC par phase, réestimée au démarrage)

| Phase | Contenu | Critère de sortie vérifiable |
|---|---|---|
| **Vague 1 — MVP** | | |
| 1 | Socle : espace Cargo, Trunk, tokens/CSS repris, polices locales, CSP, `netlify.toml`, `rust-toolchain.toml` | `trunk build --release` OK ; `cargo clippy` 0 avertissement ; page servie en local ; taille WASM relevée |
| 2 | Moteur mathématique : analyseur, fractions exactes, équivalence (évaluation en points aléatoires, rationnels exacts), forme simplifiée, équations du 1er degré | `2(x+1)` ≡ `2x+2` ; `6/8` → « juste mais à simplifier » ; `cargo test` vert ; < 50 ms par vérification (mesuré) |
| 3 | Composants Leptos : AppShell, ConsigneCard, Whiteboard, MenuButton, Button, ExplainPanel, retour juste/presque/faux | Rendu identique aux `preview.html` de Tableau Pixel (captures), clavier et `prefers-reduced-motion` testés, contraste ≥ 4,5:1 mesuré |
| 4 | Passerelle KaTeX + MathLive ; écran de séance avec **un** exercice jouable ; prototype formules/polices pixel | Saisie de « 3/4 », « x = -2 », « 2^5 » ; formule rendue et lisible en MathML ; test de la passerelle |
| 5 | Format JSON parcours/notion/exercice, 30 exercices « Reprendre les bases », test par exercice, bouton YOUTUBE, progression locale, carte du parcours | 30 tests verts ; progression retrouvée après fermeture ; **publication Netlify** (accord séparé) ; test par 3 personnes (ton rôle) |
| **Vague 2** | | |
| 6 | Réglages IA : clé personnelle (test, mémorisation ou séance, suppression), liste des modèles, client Claude en streaming | Appel réel en navigateur prouvé ; clé absente des journaux et des erreurs (test) ; app utilisable sans clé |
| 7 | Tuteur à indices gradués + analyse d'erreurs | Jamais la réponse d'emblée (tests) ; justesse toujours décidée par le moteur |
| 8 | Onglet CHAT : agent de compréhension, filtre anti-réponse par le moteur, cache de contexte, historique borné | Test : un message contenant la réponse attendue n'est jamais affiché |
| 9 | Répétition espacée (1, 3, 7 j) + test de positionnement | Calendrier testé ; point d'entrée proposé |
| 10 | Comptes Supabase (REST), synchronisation, suppression de compte en un clic | Projet Supabase créé **par toi** ; RGPD ; clé API jamais dans Supabase (test) |
| 11 | Générateur de parcours : lecture de source, correspondance bibliothèque, génération vérifiée, prérequis, coût estimé affiché | Parcours généré dont chaque réponse passe le moteur ; statut GÉNÉRÉE affiché |
| **Vague 3** | | |
| 12 | Exercices de géométrie sur la grille (`getPixels`) | Point/droite lus sur la grille de 16 px |
| 13 | Visualisations interactives (curseur → courbe en pixels) | Rendu fluide, `prefers-reduced-motion` respecté |
| 14 | « Pour aller plus loin » : zbMATH Open | Liens et classification MSC par notion |
| 15 | Relecture communautaire et partage de parcours par lien | Statut RELUE attribué par relecteur ; lien de partage |
| 16 | Lecture de l'écriture manuscrite (modèle de vision) | Démarche lue sur un jeu d'essai, correction par le moteur |

Chaque phase : estimation, plan, exécution déléguée, relecture `verificateur`, audit `/pentest`
différentiel dès qu'il y a du code, preuves en `.txt` dans `projet/maths/docs/preuves/phaseN/`.

### 5. Installations et accès réseau demandés
Pour les phases 1 à 5 seulement (les suivantes feront l'objet de leur propre demande) :
```
rustup target add wasm32-unknown-unknown
cargo install trunk --version 0.21.14 --locked
cargo build / trunk build        # crates.io : leptos 0.8, wasm-bindgen, web-sys, js-sys, num-rational 0.4, serde
npm install katex@0.18.9 mathlive@0.110.0 @fontsource/silkscreen @fontsource/pixelify-sans   # copiés dans l'app, servis localement
```
`trunk build --release` télécharge aussi `wasm-opt` (binaryen) depuis GitHub au premier appel.
Aucun `npm view`, aucune autre URL.

**Hors de cet accord, à demander séparément** : création du dépôt GitHub, `git push`, liaison et
publication Netlify (phase 5), projet Supabase (phase 10), tout appel à l'API Claude (phase 6).

### 6. Décisions qui te reviennent (questions ouvertes du cahier)
1. Parcours du MVP : « Reprendre les bases » (proposé : c'est celui que détaille le cahier) ou un chapitre de CM2 ?
2. Le tableau reste un brouillon en vague 1 (proposé) ou sert déjà à répondre ?
3. Noir et blanc strict pour juste/faux (proposé : conforme à Tableau Pixel, retour par texte + glyphe SVG + inversion) ou une couleur d'accent ?
4. Clé partagée en plus de la clé personnelle ? (Proposé : non ; elle impose des Netlify Functions, un plafond et un coût pour toi.)
5. Nom de l'application (il donne aussi le nom du dossier ; `projet/maths/` en attendant).

### 7. Brouillon de fichier de tâche, à copier par toi dans `humain/taches/maths_phase1.md`
```markdown
# Application de maths — phase 1 : socle Leptos + Trunk

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Poser le socle de l'application décrite dans `humain/dossier-projet-maths/dossier/Cahier des charges.md` :
espace Cargo (`moteur` + `app`), Trunk, styles Tableau Pixel, polices locales, CSP, configuration Netlify.

## Contexte
- Référence : le cahier des charges et `humain/a_valider/2026-09-28_maths_phase0.md` (approuvée).
- Code dans `projet/maths/`, dépôt git propre.
- Design system : `humain/dossier-projet-maths/dossier/tableau-pixel.zip`.

## Critères d'acceptation
- [ ] `trunk build --release` réussit ; sortie dans `dist/`
- [ ] `cargo clippy --all-targets` : 0 avertissement ; `cargo fmt --check` propre
- [ ] `tokens.css` et `bundle.css` repris sans modification (empreintes identiques à l'archive)
- [ ] Aucune ressource chargée hors du site (CSP stricte, polices locales)
- [ ] Taille du WASM compressé relevée dans le rapport
- [ ] `netlify.toml` et `rust-toolchain.toml` présents, sans publication

## Hors périmètre
Moteur mathématique, composants, contenu, tout déploiement, tout `git push`.
```

## Risques et réversibilité
- Risque : l'ampleur (16 phases) dépasse de loin une session ; chaque phase est bornée par le plafond
  de 5 USD et 90 min, et ton point de contrôle peut arrêter le projet entre deux phases.
- Risque : l'estimateur mesure `projet/` avant la création du code et sous-estime une construction
  ex nihilo (leçon de BRAINIAC Console) : prévoir une marge à la phase 1.
- Risque : l'en-tête d'accès direct depuis le navigateur n'est pas vérifié ; s'il n'est pas accepté,
  la vague 2 exigerait un relais (Netlify Function), ce qui changerait le modèle « aucun serveur ».
- Réversible : oui. Tout vit dans `projet/maths/` (zone [W]) ; les installations se retirent par
  `rustup target remove wasm32-unknown-unknown` et `cargo uninstall trunk`.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (portée : plan seul, ou plan et phase 1 ; accès réseau
du §5), réponds aux questions du §6, puis dépose le fichier de tâche du §7 dans `humain/taches/`.
C'est le seul endroit qui fait foi.
