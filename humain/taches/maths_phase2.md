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
