# Brouillon de tâche — à copier par l'humain dans `humain/taches/maths_parcours_v3a.md` (v3a), v3b séparée plus bas

> Rédigé par l'agent le 2026-09-30. Une tâche n'existe que dans `humain/taches/` ; un accord n'existe que dans `humain/taches/validations.md`.

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

---

# Brouillon — Parcours v3b : figures et couleur dans le chat (séparée, plus risquée)

## Objectif
La partie chat, branchée à Haiku, peut produire des **tableaux**, des **schémas**, des **figures géométriques** et des **représentations dans le plan**
(repère, courbes, points, vecteurs) pour expliquer un concept ; **couleur autorisée dans le chat seulement**, pour mettre un concept en exergue.

## Conception proposée (sécurité)
- Haiku ne renvoie **jamais de SVG ni de HTML**. Il renvoie une **spécification structurée** (JSON : type `tableau` | `repere` | `figure`, éléments bornés,
  nombres et libellés), validée par l'app (types, bornes, longueurs), puis dessinée par **notre propre code** (SVG construit par l'API DOM, aucun `inner_html`).
  Une spécification invalide est refusée avec un message, jamais affichée.
- Couleur : jeu de couleurs **propre au chat**, sans toucher à `tokens.css` (repris tel quel de Tableau Pixel) ; contrastes vérifiés (`contraste.mjs`) ;
  jamais la couleur seule pour porter le sens (motifs ou libellés en plus).
- Prompt : vocabulaire fermé décrit à Haiku ; contenu du corpus et réponses traités comme des données.

## Critères d'acceptation (à affiner)
- [ ] Les types tableau, repère/courbe, figure géométrique, schéma rendus depuis une spécification validée
- [ ] Refus testé de toute spécification hors vocabulaire ou hors bornes
- [ ] Couleur limitée au chat ; contrastes 0 échec ; information non portée par la couleur seule
- [ ] Observé sous la CSP réelle ; Haiku réel non observé sauf clé fournie par l'humain

## Estimation et budget
`estimer.py` n'accepte qu'un fichier de `humain/taches/` : **pas d'estimation officielle tant que la tâche n'y est pas**. Ordre de grandeur de l'agent, à confirmer :
v3a ≈ 1,5 à 3 USD ; **v3b ≈ 3 à 6 USD (borne haute au-dessus du plafond de 5 USD)**, d'où la découpe. Plafond à fixer par toi pour chaque tâche.
