# Proposition — 2026-09-29_maths_phase3_brouillons

## Action proposée
Deux textes à copier par toi : la ligne de `humain/taches/validations.md` qui clôt la phase 2 et
autorise la phase 3, et le fichier `humain/taches/maths_phase3.md`. Je ne peux écrire ni l'un ni
l'autre (`AGENTS.md` : `validations.md` tenu par l'humain seul, `taches/` en lecture seule). Les
choix ci-dessous sont à cocher par toi : je n'en ai tranché aucun.

## Pourquoi
La phase 3 ne démarre qu'avec une approbation dans `validations.md` et un fichier de tâche.

## Contenu exact

### A. Ligne pour `validations.md` (choisis une option par point, supprime les autres)
```
| 2026-09-29 | 2026-09-29_maths_phase2_rapport.md | APPROUVÉ | Phase 2 close. Phase 3 autorisée, tâche maths_phase3.md. N-01 « Factorise » : [OPTION 1 | OPTION 2]. Budget : [OPTION 3 | OPTION 4]. |
```
- **N-01, option 1 — accepter la limite** : « Factorise » ne vérifie pas la factorisation complète ;
  reporté à une phase ultérieure ; la phase 5 évite les exercices « Factorise » ou les valide à la main.
  Pour : aucun risque de régression de plus. Contre : `1/2(2x^2+4x+2)` passe.
- **N-01, option 2 — appliquer la règle de degré** (facteur somme de degré ≥ 1 et inférieur à celui
  de l'expression) : correctif à faire en tête de phase 3, avec test différentiel, relecture et
  audit. Pour : ferme les trois contournements. Contre : chaque règle ajoutée en fin de cycle a
  jusqu'ici introduit une régression ; coût supplémentaire en opus ou sonnet.
- **Budget, option 3** : coût réel relevé par toi (à indiquer), plafond de 5,00 USD par tâche
  maintenu pour la phase 3.
- **Budget, option 4** : plafond relevé pour la phase 3 (montant à indiquer).
- Ma recommandation, à titre indicatif : option 1 (aucune exigence de la phase 3 ne dépend de
  « Factorise ») et option 3.

### B. Fichier `humain/taches/maths_phase3.md`
```markdown
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
```

## Risques et réversibilité
- Risque : `[OPTION 2]` ajoute un cycle de correctif avant l'interface.
- Réversible : oui. Ces textes sont des propositions ; rien n'est appliqué tant que tu ne les copies pas.

## Pour approuver
Copie la ligne A (options choisies) dans `humain/taches/validations.md`, et le bloc B dans
`humain/taches/maths_phase3.md`. Dis-moi « go » : je lance `/tache` (estimation, plan).
