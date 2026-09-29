# Proposition — 2026-09-29_maths_phase4_tache

## Action proposée
Brouillon du fichier `humain/taches/maths_phase4.md`, à copier par toi si tu autorises la phase 4 (je
ne peux pas écrire dans `taches/`). Les options entre crochets reprennent les 5 points à trancher du
rapport de phase 3 : je n'en ai tranché aucun.

## Pourquoi
Plan approuvé (`2026-09-28_maths_phase0.md`, §4, ligne 4) : « Passerelle KaTeX + MathLive ; écran de
séance avec un exercice jouable ; prototype formules/polices pixel ». La phase 4 ne démarre qu'avec une
ligne dans `validations.md` et un fichier de tâche.

## Contenu exact
```
# Application de maths — phase 4 : passerelle KaTeX + MathLive, un exercice jouable

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/`, un seul module Rust de passerelle vers KaTeX 0.18.9 (rendu) et MathLive
0.110.0 (saisie), déjà installés en phase 1 ; un écran de séance avec **un** exercice jouable de bout
en bout (saisie MathLive → `moteur::verifier` → verdict de la phase 3) ; prototype de rendu des
formules avec les polices pixel.

## Contexte
- Plan approuvé : `humain/a_valider/2026-09-28_maths_phase0.md`, phase 4.
- Phase 3 close avec réserve clavier (Entrée après Tab du pilote WebDriver) : à re-tester avec un vrai
  clavier par l'humain, et à ne pas confondre avec un défaut de MathLive.
- CSP par hash (`app/scripts/csp.mjs`) : tout ajout de script change le hash ; MathLive et KaTeX
  doivent fonctionner sous la CSP réelle (`netlify.toml`), sans `'unsafe-eval'` ni `'unsafe-inline'`
  dans `script-src`. Si MathLive l'exige, s'arrêter et poser la question.
- Exigences reportées : texte de l'élève et messages en texte seulement, jamais `inner_html`
  (le HTML produit par KaTeX à partir d'une formule **de l'exercice** est le seul cas à statuer, par
  écrit, avant d'écrire le code).
- Points reportés de la phase 3 : [1 page `#mesure` et démo derrière une feature Cargo | accepté en
  l'état] ; [2 `maxlength` : exporter la constante du moteur (touche `moteur/`) | reporté] ;
  [3 attributs `style=` remplacés par des classes | reporté] ; [4 `RUST_VERSION` épinglé | reporté].
- Réseau : aucun (KaTeX, MathLive et polices déjà sur disque) ; crates.io selon l'accord de phase 0.

## Critères d'acceptation
- [ ] Saisie de « 3/4 », « x = -2 », « 2^5 » dans MathLive, convertie pour le moteur, verdict affiché
- [ ] Formule rendue par KaTeX et lisible en MathML (arbre d'accessibilité), test de la passerelle
- [ ] App lancée sous la CSP réelle : 0 violation nouvelle en console (hors `@import` Google Fonts connu)
- [ ] Clavier : saisie et validation au clavier seul
- [ ] `trunk build --release` OK, taille WASM + JS relevée, clippy `-D warnings` et fmt propres
- [ ] Preuves `.txt` dans `projet/maths/docs/preuves/phase4/`

## Hors périmètre
Contenu des exercices (phase 5), publication Netlify, tout appel réseau à l'exécution, `moteur/`
(sauf point 2 si retenu).
```

## Risques et réversibilité
- Risque principal : MathLive injecte des styles et peut exiger un assouplissement de la CSP ; la tâche
  prévoit l'arrêt et la question plutôt qu'un assouplissement silencieux.
- Palier pressenti : moyen (sonnet), à confirmer par `estimer.py` au dépôt ; l'estimateur risque de
  classer « grand » sur le mot « CSP » ou « sécurité », comme en phase 3.
- Réversible : oui, simple brouillon.

## Pour approuver
Copie le bloc dans `humain/taches/maths_phase4.md` et ajoute une ligne à `humain/taches/validations.md`.
C'est le seul endroit qui fait foi.
