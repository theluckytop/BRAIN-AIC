# Proposition — 2026-09-23_brainiac_console_phase1_rapport

## Action proposée
Clore la phase 1 de BRAINIAC Console (coquille, commits `d77b4da` puis `9805a10` du dépôt `projet/brainiac-console/`)
et autoriser la phase 2 (suivi en lecture) comme nouvelle tâche.

## Pourquoi
Point de contrôle exigé par l'approbation du 2026-09-23 (« point de contrôle à la fin de chaque phase »).
Sans accord, rien ne s'écrit au-delà de la phase 1.

## Contenu exact

### 1. Livré
| Élément | Où |
|---|---|
| Échafaudage Tauri 2 + Vite 8 + TS + Svelte 5 (gabarit `vanilla-ts`, pour éviter SvelteKit) | `package.json`, `vite.config.ts`, `src-tauri/` |
| Module d'écriture unique : liste blanche, création seule, ajout seul, remplacement limité à la configuration | `src-tauri/src/ecriture.rs` |
| Projets et configuration persistante (`~/.config/fr.brainiac.console/config.json`) | `src-tauri/src/projets.rs` |
| Fenêtre transparente sans décorations système, barre de titre maison, détection du compositeur (GTK), repli opaque, réglage « Translucidité » | `src-tauri/src/lib.rs`, `tauri.conf.json`, `src/App.svelte` |
| Identité §7 : palette en jetons, Inter embarquée, 3 tailles, grille 8 px, `prefers-reduced-motion`, `prefers-reduced-transparency` | `src/styles.css`, `src/App.svelte` |
| Logo SVG vectorisé à la main : complet, simplifié, monochrome | `src/assets/logo/` |
| Contrôle automatique du contraste AA | `scripts/contraste.mjs` (`npm run test:contraste`) |
| CSP stricte (`default-src 'self'`, pas de cadre, pas d'objet), `withGlobalTauri: false`, permissions de fenêtre limitées à déplacer/réduire/agrandir/fermer | `tauri.conf.json`, `capabilities/default.json` |

### 2. Tests d'acceptation couverts par la phase 1
| # | Résultat | Preuve |
|---|---|---|
| 1 | **réussi** | `projets::tests::test_1_refus_motive_sans_agents_md` : message « il manque AGENTS.md, .claude/ » |
| 5 | **réussi** | 13 tests dans `ecriture.rs` : `..`, `.` brut, chemin relatif, absolu hors zone (`/etc`, dossier voisin), zones de l'agent (`AGENTS.md`, `etat.md`, `.claude/`, `memoire/`), lien symbolique de fichier, lien de dossier sortant, lien vers `questions.md`, écrasement d'une tâche et d'une pièce jointe refusé, ajout conservant l'existant, ajout sur fichier absent refusé, configuration remplacée sans suivre un lien. `cargo test` : **18 réussis, 0 échec** |
| 10 | **réussi** | `projets::tests::test_10_projet_supprime_grise_jamais_retire`. Le rendu grisé « Introuvable » est vérifié sur une capture faite hors Tauri, avec des **données d'exemple** (`?apercu=projets`), et non dans l'application réelle |
| 12 | **réussi, avec réserve** | capture à 420 px (accueil et menu des projets) : rien ne déborde. Réserve : rendu par Firefox sans affichage, pas par WebKitGTK |
| 14 | **partiel** | détection `is_composited()` puis `data-fond="opaque"` ; sur cette machine (GNOME Wayland) : `composition=true`. Le chemin sans compositeur n'est **pas observable ici** ; il sera à revoir sur une session X11 sans composition |
| 15 | **réussi** | fond opaque : contraste calculé (texte 17,1 ; texte secondaire 8,3) ; le réglage bascule `data-fond` et il est enregistré |
| 16 | **réussi, jugé à l'œil** | captures à 16, 32, 128 et 512 px : le crâne simplifié reste lisible à 16 et 32 px, la version monochrome à 16 px ; la version complète devient illisible à 32 px, d'où l'emploi réservé ≥ 128 px (règle du cahier confirmée) |
| 17 | **vérifié par lecture du code** | règle `prefers-reduced-motion` qui annule animations et transitions ; aucune animation continue en phase 1 (l'œil-indicateur arrive en phase 4) |
| 18 | **réussi** | `npm run test:contraste` : 0 échec, fond translucide posé sur blanc (pire cas) compris |
| 19 | **réussi après correction** | Inter 400/600 (sous-ensemble latin) incluse dans `dist/` par `@fontsource/inter`. La relecture a trouvé les glyphes ▾ ⚙ □ absents d'Inter (jeu de caractères vérifié par `fc-query`) : ils passaient par une police système. Ils sont remplacés par des icônes SVG (commit `9805a10`). Plus aucun caractère de l'interface ne sort de ce jeu de caractères (`git grep -P`). Absence de police système non simulée |
| 13 | **réussi (anticipé)** | 0 occurrence. Commande exacte, date et sortie dans `travail/brouillons/recherche_options_interdites.txt` : `git -C projet/brainiac-console grep -nE -e "--dangerously-skip-permissions\|--allow-dangerously-skip-permissions\|bypassPermissions\|--permission-mode\|--bare\|--safe-mode\|--setting-sources\|--settings\|--allowedTools\|--allowed-tools\|--restricted\|ANTHROPIC_API_KEY"`, code de sortie 1 sur 45 fichiers suivis |

Démarrage (critère < 2 s) : **976, 981 et 987 ms** du lancement du processus jusqu'au signal « prêt »
de l'interface, en build de **débogage** (le build de production sera plus rapide) ; journaux dans
`travail/brouillons/lancement*.log`. Aucun processus résiduel après arrêt (`travail/brouillons/processus_residuels.txt`).

### 3. Dépendances effectives (versions figées par les fichiers de verrouillage)
npm : `@tauri-apps/api` 2.11.1, `@fontsource/inter` 5.3.0 ; dev : `@tauri-apps/cli` 2.11.5, `vite` 8.3.0,
`typescript` 6.0.3, `svelte` 5.57.1, `@sveltejs/vite-plugin-svelte` 7.3.1.
Rust : `tauri` 2, `tauri-build` 2, `serde`, `serde_json`, `anyhow`, `chrono` (horloge seule).
- **Ajout à justifier : `gtk` 0.18 (Linux seulement)**, déjà compilé comme dépendance de `tauri`. Il sert
  uniquement à `is_composited()` pour le repli opaque automatique (test 14).
- **Retiré pour l'instant : `tauri-plugin-opener`**, inutilisé en phase 1 et fourni par le gabarit. Il
  revient en phase 5, comme prévu au §3.
- `tokio` et `notify` ne sont pas encore ajoutés : ils arrivent en phases 2 et 4.
- `anyhow` est déclaré mais pas encore utilisé.

### 4. Écarts
- **Survol du bouton Fermer** : il était rouge, alors que le §7 réserve le rouge aux alertes. Il passe en gris (commit `9805a10`).
- **Critères non remplis** : coût réel non relevé (illisible depuis l'agent) ; test 14 seulement partiel (le repli sans compositeur n'a pas pu être observé ici).
- **Réseau, hors autorisation** : 4 appels `npm view` (lecture seule du registre) avant l'échafaudage.
  Leçon consignée. Hors cela : `npm create`, `npm install` et `cargo` uniquement.
- **Palette ajustée** : fond translucide à **86 %** au lieu de 82 %, texte secondaire `#9AAA9C` au lieu de
  `#8A9A8C`, et nouveau rouge de texte `--alerte-texte: #FF8088`. `#E8323C` n'atteint pas le niveau AA
  en texte sur fond translucide (3,41) ; il reste réservé aux aplats.
- **CSP** : `style-src 'unsafe-inline'`, pour les styles dynamiques de Svelte (couleur du projet). Les
  scripts restent `'self'`. À resserrer si l'audit le demande.
- **Fichiers du gabarit non retirés** : `src/assets/{tauri,vite,typescript}.svg`, `README.md`, `.vscode/`,
  icônes par défaut de `src-tauri/icons/`. Leur retrait est une suppression, qui demande ton accord ; les
  icônes seront de toute façon remplacées en phase 6.
- **Vérifications visuelles faites dans Firefox sans affichage**, à défaut d'outil de capture pour
  WebKitGTK sous Wayland.
- **Effets sur ta machine** : la fenêtre s'est ouverte 4 fois quelques secondes (mesure du démarrage) ;
  le dossier `~/.config/fr.brainiac.console/` a été créé, vide.
- Brouillons de contrôle (captures, journaux de lancement, recherche) : `travail/brouillons/`.

### 5. Sécurité
Audit `/pentest` du périmètre `application` (commit `d77b4da`), vague de 4 chapitres (V3, V5, V13, V15),
dans `pentest/rapports/2026-09-23_235354/` (`synthese.md`) : 70 exigences, 15 conformes, 5 partielles,
7 non conformes, 43 indéterminées. **Gravité : 0 critique, 0 élevée**, 2 moyennes, 15 faibles.
**Aucun constat critique ouvert.**
- Moyenne, V15.1.1 : aucun délai de correction des dépendances vulnérables n'est défini. Je le rédige en
  phase 2 ; donne-moi tes délais si tu en as.
- Moyenne, V15.2.1 : `npm audit` et `cargo audit` interrogent le réseau, ce que je ne suis pas autorisé à
  faire. **À lancer de ton côté** : `npm --prefix projet/brainiac-console audit --omit=dev` et, si
  `cargo-audit` est installé, `cargo audit --file projet/brainiac-console/src-tauri/Cargo.lock`.
- Faibles, à corriger en tête de phase 2 : garde de navigation, permissions réduites au strict
  nécessaire au lieu de `core:default`, en-têtes `nosniff`/`no-referrer`/`frame-ancestors`, mesures
  de démarrage et mode aperçu exclus de la version publiée, README.
- Exemptions **proposées** par l'auditeur, pas accordées : V3.3.* (aucun cookie), V3.4.1 et V3.7.4
  (pas d'HTTPS), V3.5.2 à V3.5.4 (pas de serveur HTTP), V5.2.3, V5.2.5 et V5.3.3 (aucune archive).
  À inscrire par toi dans `pentest/exemptions.md` si tu les retiens.

### 6. Estimation de la phase 2 (suivi en lecture)
Ampleur comparable à la phase 1 : lecture et rendu de `etat.md`, questions ouvertes, `a_valider/`,
compteurs, journal et mémoire ; surveillance `notify` avec anti-rebond ; rendu Markdown assaini
(`marked` + `dompurify`, déjà approuvés au §3). Compter **une session complète** (60 à 90 min, 100 à
150 actions). L'estimateur ne mesure que la taille de `projet/`, maintenant réelle : je l'exécuterai
au démarrage de la tâche. Le coût réel de la phase 1 n'est pas lisible depuis l'agent : à relever de ton côté.

## Risques et réversibilité
- Risque : limite connue (TOCTOU) de l'ajout seul, documentée en tête de `ecriture.rs`. Fermeture
  prévue en phase 3 par `O_NOFOLLOW` (dépendance `libc`, déjà acceptée), avant la première écriture
  réelle dans un espace suivi.
- Risque relevé par la relecture : l'ajout seul ne contrôle pas les liens physiques (`nlink`). Il suffirait
  d'un lien physique vers un fichier extérieur, créé par un tiers, pour que l'ajout y écrive. À fermer en
  phase 3 avec la limite TOCTOU : refuser `nlink > 1`.
- Remarque : `Zones::nouvelles` crée le dossier de configuration (`create_dir_all`) hors de `ecrire`. C'est
  sans écriture de contenu ; je le documenterai ou le déplacerai en phase 2.
- Réversible : oui. Tout vit dans `projet/brainiac-console/`, dépôt local jamais poussé.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (phase 1 close, phase 2 autorisée ou non), puis
dépose la tâche de la phase 2. Précise si j'ai ton accord pour retirer les fichiers du gabarit (§4).
C'est le seul endroit qui fait foi.
