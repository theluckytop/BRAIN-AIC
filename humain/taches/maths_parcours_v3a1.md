# Application de maths — Parcours v3a1 : `R\{2}` et `R^2` d'ensemble s'affichent ℝ²
- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

> Brouillon de l'agent, à copier par l'humain dans `humain/taches/maths_parcours_v3a1.md`, avec une ligne dans `humain/taches/validations.md`.

## Objectif
Dans `projet/maths/app/src/notation.rs` (normalisation du texte hors formule) : quand l'énoncé ou le chat contient `R\{2}` (ou `R\{2\}`), afficher **ℝ²**
et non plus ℝ∖{2}. Un `R^2` nu qui désigne un ensemble (« sur R^2 », « dans R^2 », « de R^2 dans R ») s'affiche aussi ℝ².

## Contexte
- Demande de l'humain (2026-10-01) : « quand je parlais de `R\{2}`, je fais référence à ℝ² ». Corrige la lecture de l'agent de v3a (ℝ∖{2}).
- État actuel, testé dans `notation.rs` (l.919-992) : `R\{2}` → ℝ∖{2} ; `\R^2`, `\mathbb R^2`, `\mathbb{R}^2` → ℝ² ; `R^2` nu → R² (sans ajouré) ;
  « coefficient R^2 = 0,98 » reste R² (la relecture de v3a avait refusé de deviner ℝ² : faux pour un coefficient de détermination).
- Code de v3a commité (`ba57024`). `Cargo.toml` et `Cargo.lock` ne changent pas.
- **Décisions à confirmer par l'humain avant démarrage** (recommandations de l'agent) :
  1. `R\{2}` → ℝ², seulement sous cette forme exacte (`R\{2}` et `R\{2\}`) : oui / non.
  2. Les formes qui disent vraiment « privé de » restent ℝ∖{2} : `\mathbb R\setminus\{2\}`, `ℝ∖{2}`, `R\{-1; 2}` (plusieurs valeurs) : oui / non.
  3. `R^2` nu → ℝ² uniquement après un mot d'ensemble (« sur », « dans », « de », « ∈ », « vers », « sous-ensemble de ») ; partout ailleurs R² : oui / non.
  Conséquence de la décision 1 : un énoncé de Haiku qui écrit `R\{2}` en voulant dire « ℝ privé de 2 » serait affiché ℝ² (faux) ; le prompt de Haiku doit donc
  demander `\mathbb{R}\setminus\{2\}` pour ce sens et `\mathbb{R}^2` pour le plan.

## Critères d'acceptation
- [ ] Tests purs : `R\{2}` et `R\{2\}` → ℝ² ; `\mathbb R\setminus\{2\}` et `R\{-1; 2}` inchangés (ℝ∖…) ; « sur R^2 », « dans R^2 » → ℝ² ; « coefficient R^2 = 0,98 » → R² ; URL jamais modifiées
- [ ] Les anciens tests de `notation.rs` qui décrivaient ℝ∖{2} pour `R\{2}` sont corrigés explicitement, pas supprimés en silence
- [ ] Consigne du prompt Haiku mise à jour (ℝ² en `\mathbb{R}^2`, « ℝ privé de » en `\setminus`), test sur le texte du prompt
- [ ] `inner_html` 0 ligne ; `Cargo.toml`/`Cargo.lock` inchangés ; liste blanche de commandes KaTeX non élargie
- [ ] `cargo test --workspace --locked`, `cargo fmt --check`, clippy `-D warnings` (natif et wasm32), `trunk build --release` puis `csp.mjs --ecrire` et `--verifier` (le hash peut changer)
- [ ] Observation d'un énoncé et d'un message de chat contenant `R\{2}` à 1280 px et 420 px, preuve dans `docs/preuves/parcours_v3a1/`

## Estimation de l'agent
Environ 0,3 à 1 USD en sonnet (un appel d'`executant`, une relecture). `estimer.py` surestimera (périmètre `projet/` entier) ; palier minimal suffisant : sonnet.

## Hors périmètre
Figures, tableaux, schémas et couleur (v3b), corrections de l'audit du tuteur, corpus L1, push, déploiement.

## Ligne d'accord proposée pour `validations.md`
`| 2026-10-0x | maths_parcours_v3a1.md | APPROUVÉ | Normalisation de R\{2} en ℝ² (et R^2 d'ensemble), prompt Haiku ajusté. Aucune installation, aucun réseau à la construction. Budget : plafond de 5,00 USD. |`
