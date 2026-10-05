# Proposition — 2026-10-05_maths_ui_menu_police_rapport

## Action proposée
Valider la tâche `maths_ui_menu_police` (code NON commité dans `projet/maths`) et décider du sort de la modale Parcours (point 1), puis commiter.

## Pourquoi
Le ☰ flottait sur le coin du panneau actif et masquait titres et étiquettes ; le texte long était en VT323 (chasse fixe), sans réglage de taille. Sans validation, le code reste en l'état, non commité.

## Ce qui est fait (rejoué par moi, build final du 09:38, hash CSP `sha256-9k0p/x/NRnaFWi94J/O4XmNJPbbPXarvzslei/wOeqU=`)
- ☰ dans une barre d'en-tête en flux normal (`composants.css`, `app_shell.rs`) ; encoche masquée, `padding-top: 84px` du chat supprimé. 56×56 px, Tab+Entrée ouvrent le tiroir (4/4 par largeur), tiroir jamais sur le ☰ ni sur A−/A+.
- Texte long en pile système (`--font-lecture`), titres, boutons, onglets, étiquettes en Pixelify Sans : 52 contrôles OK, 0 échec (1280, 768, 420, 360 ; clair, sombre).
- A− / A+ : 5 crans (90 à 160 %), `data-taille` sur `<main>`, `localStorage` `brainiac-maths-taille` tolérant (absent, vide, invalide, bloqué : cran 100 %), boutons 44×44, `aria-label`, `aria-live`, `aria-disabled`. Cran 4 mesuré : énoncé 32 px, autres textes 28,8 px, 0 débordement horizontal à 1280 et 420 px.
- Zoom 200 % simulé à 640 px : conforme (crans 1 et 4, clair et sombre), clics réels.
- Chaîne : fmt, clippy natif et wasm32, 172 + 55 tests (dont 4 de `taille.rs`), `csp.mjs --verifier`, `contraste.mjs` 0 échec ; `tokens.css`, `Cargo.toml`, `Cargo.lock` inchangés ; 0 `inner_html`.
- Défaut trouvé à l'observation puis corrigé par moi (**correctif non relu par un tiers**) : A−/A+ sans effet réel, car `.px-root { --px-echelle: 1 }` réinitialisait le facteur sur le `div.px-shell` (aussi `.px-root`). Preuve du défaut conservée : `etape3/diagnostic_echelle.txt`.
- Preuves : `projet/maths/docs/preuves/ui_menu_police/{avant,etape1,etape1_final,etape2,etape3,etape4}/` (`etape1` est antérieure au CSS final : c'est `etape1_final` qui fait foi).
- Relecture `verificateur` : 1er passage NON CONFORME à la lettre du critère 1 (preuves du ☰ périmées, modale). **2e passage (clôture, sur le commit `70ef8de`) : CONFORME, 0 bloquant, 4 mineurs.** `etape1_final` relu : build `dist` identique au CSS source ; les 10 cas à 34/44 sont confirmés faux positifs (note rognée par le tableau, ☰ libre) ; le correctif `--px-echelle` est relu pour la première fois par un tiers (`composants.css:273-282`, `diagnostic_echelle_apres_correctif.txt`). Chaîne rejouée : fmt, clippy natif et wasm32, 172 + 55 tests, `csp.mjs --verifier`, `contraste.mjs` 0 échec, `tokens.css`/`Cargo.*` inchangés, 0 `inner_html`. Mineurs : note du tableau coupée au cran 4 (points 2), 210 px (point 3), faux positifs du harnais, ☰ mesuré aux crans 1 et 4 seulement. Non rejoué : `trunk build`, Firefox.
- Audit différentiel (`pentest/rapports/2026-10-05_maths_ui_menu_police_cloture/`, entrées + config, revue seule) : **0 critique, 0 élevé, 0 moyen**, aucune régression, pas de blocage de livrable. Indéterminés levés par moi : diff du répertoire contre `70ef8de` vide, `csp.mjs --verifier` OK (hash `9k0p…` identique dans `index.html`, `dist`, `netlify.toml`), `Cargo.*` inchangés entre `70ef8de~1` et `70ef8de`, `style-src 'unsafe-inline'` déjà présent avant le commit (EV-11 du 30/09, non ajouté). Identité et crypto non touchés, non audités.

## Points à trancher
1. **Modale Parcours** : fixed, z:10, elle recouvre le ☰ (et A−/A+) à 420, 360 et 640 px, ouverte (32 cas sur 32), et pas à 1280 px. Le critère 1 dit « aucun élément recouvert, sur le Parcours ». A : accepter qu'une modale couvre tout par construction (réserve). B : ☰ au-dessus de la modale (changement de z-index, à une tâche courte).
2. **Note du tableau coupée** au cran 4 (768 px, carte d'énoncé haute) : première ligne « Dessine ta… » rognée. CSS, hors critère ; A : corriger dans une courte tâche, B : laisser.
3. **210 px** (420 px à 200 %) inutilisable : défilement horizontal (261/198), barre du tableau hors fenêtre, tableau sur A−/A+. Hors critère (640 px conforme). A : tâche à part, B : ignorer.
4. Tiroir `top: 64px` fixe : recouvrirait A−/A+ si la barre passait à la ligne (non observé à 420 ni 360 px).
5. Étiquette `label.px-chat__label` encore en VT323 (masquée visuellement) : classée étiquette, laissée.
6. Plafond de 5 USD : ≈ 600 k jetons de sous-agents au total (sessions 17 à 19), non contrôlable depuis l'agent ; à relever sur ta console.

## Non observé
Écran réel, Chrome, vrai zoom navigateur (simulé par la taille du viewport), tactile, bulles de chat réelles (pas d'API), erreurs console.

## Contenu exact
Fichiers modifiés dans `projet/maths` (non commités) : `app/index.html`, `app/public/composants.css`, `app/src/composants/{app_shell.rs,mod.rs}`, `app/src/main.rs`, `netlify.toml` (hash CSP) ; nouveaux : `app/src/taille.rs`, `app/src/composants/taille_texte.rs`, `docs/preuves/ui_menu_police/`.
Commande de commit proposée (à lancer par toi) :
```
git -C projet/maths add -A && git -C projet/maths commit -m "UI : barre du menu, police lisible pour le texte long, réglage A-/A+, preuves"
```

## Risques et réversibilité
- Risque : modale sur le ☰ (point 1) ; critère 1 non relu après `etape1_final`.
- Réversible : oui, `git -C projet/maths revert` du commit (rien n'est poussé).

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
