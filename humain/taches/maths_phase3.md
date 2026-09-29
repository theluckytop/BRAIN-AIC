# Application de maths — phase 3 : composants Leptos

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/` (Leptos 0.8 CSR, Trunk), construire les composants du cahier :
AppShell, ConsigneCard, Whiteboard, MenuButton, Button, ExplainPanel et le retour
juste / presque / faux. Aucun exercice réel : une page de démonstration alimentée par des données
fixes suffit. Le style vient de `tokens.css` et `bundle.css` (Tableau Pixel), inchangés.

## Contexte
- Référence : `humain/dossier-projet-maths/dossier/Cahier des charges.md` et les `preview.html` de
  Tableau Pixel (copie de lecture : `travail/brouillons/tableau-pixel/`, à recréer depuis
  `tableau-pixel.zip` si les brouillons sont vidés).
- Plan approuvé : `humain/a_valider/2026-09-28_maths_phase0.md`, phase 3.
- Moteur : `projet/maths/moteur/` (phase 2 close). Le retour juste / presque / faux affiche les
  verdicts `Juste`, `ASimplifier`, `FormeIncorrecte`, `Faux`, `SaisieInvalide` de `moteur::verifier`.
- **Exigences de sécurité reportées de la phase 2** : messages affichés en texte seulement, jamais
  `inner_html` (E-04) ; une `ErreurReference` n'est jamais comptée comme une réussite ni comme une
  faute de l'élève (message « exercice défectueux »).
- Principe « jamais de sanction » : un verdict `Faux` ou `ASimplifier` déclenche une aide, jamais
  une pénalité visuelle punitive (cahier).
- Mesurer le temps de vérification en WebAssembly (navigateur ou `wasm-bindgen-test`) : le seuil de
  50 ms n'a été mesuré qu'en natif (pire cas 8,4 ms).
- Réseau : crates.io et Trunk selon l'accord de la phase 0, rien d'autre.

## Critères d'acceptation
- [ ] Six composants + retour de verdict, rendu identique aux `preview.html` (captures comparées)
- [ ] Navigation au clavier complète ; `prefers-reduced-motion` respecté (test)
- [ ] Contraste ≥ 4,5:1 mesuré, sortie en preuve
- [ ] Aucun `inner_html` ni équivalent dans `app/` (recherche consignée)
- [ ] Verdicts du moteur reliés à l'affichage, y compris `SaisieInvalide` et `ErreurReference`
- [ ] Temps d'une vérification mesuré en WASM et consigné (< 50 ms)
- [ ] `trunk build --release` OK, taille WASM relevée (< 500 Ko gzip), clippy `-D warnings` et fmt propres
- [ ] Preuves `.txt` dans `projet/maths/docs/preuves/phase3/`

## Hors périmètre
MathLive et KaTeX (phase 4), contenu des exercices (phase 5), publication Netlify, tout appel
réseau à l'exécution, toute modification de `moteur/` (sauf correctif N-01 si option 2).
