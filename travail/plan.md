# Plan — Maths : Parcours v3a (carrousel d'une notion, notation mathématique)

**Tâche** : `humain/taches/maths_parcours_v3a.md` ; accord : ligne du 2026-09-30 (`validations.md` : KaTeX déjà installé, aucun réseau à la
construction, aucune installation, API Claude à l'exécution, plafond 5,00 USD). Part du code v2a **non commité** dans `projet/maths`
(commiter v2a d'abord si l'humain l'a fait ; sinon travailler dessus sans rien défaire).
**Estimation** : `estimer.py` 8,63 à 25,90 USD en sonnet, « palier grand » (artefact : périmètre `projet/` entier, mot-clé « autorisation »).
Ma fourchette : **≈ 1,5 à 3 USD** (3 à 4 appels d'`executant` ≈ 50 à 100 k jetons sonnet chacun). **Palier minimal suffisant : sonnet.**
Bascule en opus seulement sur échec constaté. **Nouvelle session (sonnet) conseillée** : la session précédente dépasse 60 min.
**Périmètre** : `projet/maths/app/` ; KaTeX dans `app/` (installé en phase 1, polices locales). Jamais de `cd` nu ; serveurs et navigateurs
de test arrêtés en fin d'étape ; chiffres relus sur fichier avant citation. Le serveur Python du port 8080 (pid 305994 si encore en vie) sert `app/dist/`.

## Étapes (une par appel d'`executant`, relecture `verificateur` à la fin)
1. **Carrousel d'une notion.** `consigne_card.rs` / `parcours.rs` : le bandeau montre l'énoncé et le titre de la notion, rien d'autre (plus d'extrait,
   plus de liste d'exercices) ; ◀ ▶ (clavier et clic) passent à la notion suivante ou précédente du niveau ; avancement par niveau et chapitre
   restaurés au rechargement (mécanisme v2a conservé). L'extrait, le statut et la source restent dans l'onglet « Cours ».
   *Réussite* : tests purs (étape = énoncé + notion seulement, bornes du carrousel, restauration) ; observation Firefox headless à 420 et 1280 px.
2. **Analyse de la notation.** Décider sur pièce : KaTeX sous la CSP réelle (`style-src`, styles en ligne, polices locales, rendu par API DOM sans
   `inner_html`) : essai minimal observé. Si bloquant : repli table Unicode (ℝ, ℝ², ∖, √, ≤, ∈, puissances, indices) ; consigner la décision.
   *Réussite* : preuve d'observation sous la CSP réelle, décision écrite dans `memoire/decisions.md`.
3. **Rendu mathématique.** Fonction pure de découpage du texte en segments texte / formule (`$…$`), rendu des formules, texte brut accessible
   (`aria-label`), appliqué aux énoncés du bandeau et aux messages du chat. Prompt Haiku : écrire les maths en LaTeX entre `$…$`, sans syntaxe brute.
   Liste blanche de commandes ; `\href`, `\url`, `\includegraphics`, `\input` refusés ; toute erreur de rendu retombe sur le texte brut.
   *Réussite* : tests purs (découpage, `R\{2}` → ℝ∖{2}, `R^2` → ℝ², entrées hostiles) ; `inner_html` 0 ligne ; observation du rendu.
4. **Clôture** : `fmt`, `clippy -D warnings` (natif et wasm32), tests, `trunk build --release`, `csp.mjs --ecrire` puis `--verifier`, observation sous la
   CSP réelle (420 px en iframe, dit tel quel, et 1280 px), `verificateur`, rapport `a_valider/`, mémoire, `etat.md`, `/cloture`.

## Hors périmètre
Figures, tableaux, schémas et couleur (v3b, accord à part), corpus L1 (v2b), chat vidé au changement d'étape (point laissé de v2a), push, déploiement, /pentest.
