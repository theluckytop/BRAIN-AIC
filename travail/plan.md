# Plan — Maths : menu ☰ qui ne recouvre rien, police lisible, réglage A− / A+ et zoom

**Tâche** : `humain/taches/maths_ui_menu_police.md` ; accord `validations.md` du 2026-10-05 (aucune installation, aucun réseau, plafond 5,00 USD). Décisions de l'humain : police B (lisible, système, pour le texte long seulement), cette tâche avant v3c.
**Estimation** : `estimer.py` 18,5 à 55,5 USD en sonnet, plafond « DÉPASSÉ » (artefact : périmètre `projet/` entier, 473 fichiers). Ma fourchette : **≈ 1 à 2,5 USD** (tâche CSS/UI, un `executant` + un `verificateur`). Repère d'arrêt et question : ≈ 400 k jetons de sous-agents.
**Palier minimal suffisant : sonnet.** Escalade seulement sur échec constaté.
**Durée** : session déjà très longue : exécution en **nouvelle session** depuis la racine, avant tout sous-agent d'écriture (test du compteur par une commande triviale).

## Carte du code (explorateur, à reverifier avant écriture)
- ☰ : `app/src/composants/menu_button.rs:8-28` (classe `px-menu`, 56×56) ; conteneur `px-shell__menu` **absolute, top:0, left:0, z:3**, tiroir `px-shell__drawer` absolute top:68px z:4 (`bundle.css:27-116`, `app_shell.rs:18-173`). Le bouton flotte donc au-dessus du contenu, d'où le recouvrement.
- Mise en page : `composants.css:128-134` (`px-app` 100dvh, `px-shell`, `px-seance`) ; onglets dans `tableau_chat.rs:262-581` (Cours : `.px-cours`, encoche 72×72 coin haut gauche).
- Police : `composants.css:101-104` fixe `--font-body` sur VT323 (chasse fixe) ; tailles 19 à 26 px (`composants.css:109-114`). `tokens.css` n'est pas touché (à garder inchangé).
- Pas de `font-size` sur `:root` (rem = 16 px). Aucun réglage A−/A+ aujourd'hui.
- `localStorage` : helpers tolérants `parcours::lire/ecrire` (`parcours.rs:381-389`), `theme.rs:70-87` ; clés `brainiac-*`.
- Outils : `app/scripts/contraste.mjs`, `app/scripts/csp.mjs` ; l'observation Firefox headless (preuves `docs/preuves/l1_phase1/observation/`) est à retrouver.
- Non déterminé par l'exploration : effet exact du ☰ sous 480 px (à mesurer, pas à supposer).

## Règles de conception
- Le ☰ gagne son propre espace : barre d'en-tête (ou réserve de 56 + marge en haut), sans passer par `tokens.css`. Cible ≥ 44 px, clavier inchangé.
- Police du texte long : pile système lisible (sans nouvelle police, sans chasse fixe), règle locale dans `composants.css` ; titres, boutons, étiquettes gardent le thème pixel.
- Taille : facteur sur le conteneur de l'app (classe ou variable CSS), 3 à 5 crans, `localStorage` tolérant (try/catch, absence = cran par défaut). Rien d'inline `style` posé par le code sur les éléments (leçon du 2026-10-01).
- Hash CSP : toute retouche de `index.html` ou du build suit la chaîne fixe (code figé → build → `csp.mjs --ecrire` → build → preuves → commit).

## Étapes
0. **Mesure de départ** (`executant`, lecture et observation) : rectangles du ☰ et du contenu à 1280, 768, 420, 360 px, clair et sombre, onglets Cours, Chat et modale Parcours ; famille de police calculée du texte long.
   *Réussite* : tableau des chevauchements mesurés (avant), preuve archivée en `.txt` avec commande et date.
1. **Espace du ☰** : barre d'en-tête ou décalage du contenu, `app_shell.rs` / `composants.css`.
   *Réussite* : rectangles disjoints à 4 largeurs, 2 thèmes, 3 écrans ; cible ≥ 44 px ; Tab et Entrée ouvrent le tiroir ; tests, fmt, clippy natif et wasm32 verts.
2. **Police lisible pour le texte long** (`composants.css`) : énoncés, cours, extraits, chat, sources.
   *Réussite* : famille calculée = pile système (pas de chasse fixe) sur ces textes, thème pixel conservé sur titres et boutons ; `contraste.mjs` 0 échec ; `tokens.css` inchangé (diff vide).
3. **Réglage A− / A+** : 2 boutons accessibles (étiquettes, focus), crans, persistance `localStorage`.
   *Réussite* : texte des énoncés, du cours et du chat agrandi ; 0 débordement horizontal à 1280 et 420 px au cran maximal ; page rechargée avec stockage vide ou bloqué : cran par défaut, sans erreur.
4. **Zoom 200 %** : observation à viewport équivalent 640 px et 210 px de large (cas extrême : 420 px à 200 %).
   *Réussite* : mise en page utilisable, ☰ non recouvert, actions atteignables.
5. **Chaîne de clôture** (moi, rejeu complet) : tests, fmt, clippy natif et wasm32, `trunk build --release`, `csp.mjs --ecrire` puis `--verifier`, `contraste.mjs`, observation finale sous la CSP réelle ; `Cargo.toml`, `Cargo.lock`, `tokens.css` inchangés ; 0 `inner_html`.
6. **Relecture** `verificateur`, rapport `humain/a_valider/`, mémoire (décision, leçon, estimation), `etat.md`, `/cloture`. Commit dans `projet/maths` seulement à la demande de l'humain.

## Périmètre
Dans : `projet/maths/app` (CSS, `app_shell.rs`, `menu_button.rs`, un composant de réglage, preuves `docs/preuves/ui_menu_police/`).
Hors : `tokens.css`, `Cargo.*`, nouvelle police ou dépendance, figures du chat (v3c), L1 phase 2, push, déploiement.
Non observable ici : écran réel, Chrome, Netlify ; le zoom 200 % est simulé par la taille du viewport.
