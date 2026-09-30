# Application de maths — Parcours v3a : carrousel d'une notion, notation mathématique
- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/` :
1. Le **carton d'annonce** (bandeau) ne montre qu'**un énoncé et sa notion** (titre du chapitre), jamais l'extrait de cours ni la liste des
   exercices ; des **flèches ◀ ▶** passent à la notion suivante ou précédente, comme l'ancien carrousel, « toujours avec le même fonctionnement »
   (avancement par niveau conservé, restauration au rechargement). L'extrait, le statut et la source restent dans l'onglet « Cours ».
2. Les **énoncés** et les **réponses du chat** s'affichent en **écriture mathématique** : plus de syntaxe brute du type `R\{2}` ou `x^2`.

## Décisions à trancher avant démarrage (voir `humain/questions.md`, 2026-09-30 « carrousel, notation, figures »)
- **Notation** : `R\{2}` (ℝ privé de 2) et `R²` (le plan) sont deux objets différents. Lecture de l'agent : ℝ∖{2} doit s'afficher ℝ∖{2}, et ℝ² s'afficher ℝ².
  Moyen proposé : Haiku écrit en LaTeX entre `$…$`, rendu par KaTeX 0.18.9 (déjà installé, polices locales, aucun réseau). À vérifier : KaTeX sous la CSP
  réelle (styles en ligne), sans `inner_html` (rendu par l'API DOM). Repli : table de remplacement Unicode (ℝ, ², ∖, √, ≤, ∈…), plus simple, moins complète.
- **Couleur** : l'accord du 2026-09-28 (§6) impose **noir et blanc strict**. Ton autorisation de couleur **dans le chat seulement** doit figurer dans
  `humain/taches/validations.md` (ligne « couleur autorisée dans la partie chat, à des fins pédagogiques, nulle part ailleurs »). Concerne v3b.

## Critères d'acceptation
- [ ] Bandeau : un énoncé + le titre de la notion ; aucun extrait ; ◀ ▶ fonctionnels au clavier et au clic ; avancement et chapitre restaurés
- [ ] Énoncés et chat en notation mathématique rendue (ℝ, ℝ², ∖, puissances, fractions, racines) ; texte brut accessible (`aria-label`)
- [ ] Sortie de Haiku jamais injectée en HTML brut ; tests sur entrées hostiles (`<script>`, `\href`, `\url`, macros dangereuses)
- [ ] `trunk build --release`, tests, clippy `-D warnings`, fmt, `csp.mjs --verifier` ; observation sous la CSP réelle à 420 px et 1280 px

## Hors périmètre
Figures, tableaux, schémas (v3b), corpus L1 (v2b), push, déploiement.

