# Proposition — 2026-10-04_maths_parcours_v3c1

## Action proposée
Relire et commiter dans `projet/maths` le parcours v3c1 (figures tolérantes, repère étendu, motif du refus, prompt strict, tableau Markdown), puis ajouter une ligne `validations.md` si tu l'approuves.

## Pourquoi
Les trois essais réels de v3b échouaient : tableau en texte brut, triangle refusé (« repere : clé non autorisée »), Pythagore sans LaTeX. Sans commit, le code reste non versionné et se mêle à v3c2.

## Ce qui a été fait (relecture `verificateur` : CONFORME sur le code, critère 8 en attente de toi)
- `figure.rs` : clé inconnue ignorée (jamais lue ni recopiée) ; refus gardés (type, bornes, non fini, couleur/style, bidi) ; `repere` lit polygones, segments, angles, étiquettes ; motif de refus avec la clé fautive, borné à 120 caractères.
- `figure_svg.rs` : segments, polygones, angles (carré pour l'angle droit) et étiquettes dans le repère.
- `api.rs` : `SYSTEME` exige ```figure pour tout tableau, schéma, repère (exemple f(x)=2x+3) et `$…$` pour toute formule.
- `notation.rs` : tableau Markdown → `Figure::Tableau` (mêmes bornes que les figures), hors chat inchangé (texte tel quel).
- Rejoué par moi et le `verificateur` : 155 tests (app), 55 (moteur), fmt, clippy natif et wasm32, `contraste.mjs` 0 échec, `csp.mjs --verifier`, `inner_html` 0 (un commentaire), `Cargo.*` et `tokens.css` inchangés.
- Observé (Firefox headless, CSP réelle, 1280 et 420 px en iframe, clair et sombre, réponses simulées) : triangle ABC avec angle droit, clé ignorée, refus « valeur hors bornes (xmax) », tableau en `<table>`, Pythagore en KaTeX, bandeau sans figure. Preuves : `projet/maths/docs/preuves/parcours_v3c1/`.

## À trancher (aussi dans `questions.md`)
1. **Énoncé tronqué à 600 caractères** (`api.rs:418`, antérieur à v3c1) : peut couper un bloc ```figure ; le bandeau affiche « bloc non fermé », sans risque de sécurité. Accepter, ou tronquer avant un bloc figure (tâche à part).
2. **Carré d'angle droit partagé** : une `figure` géométrie existante passe de l'arc au carré. Gardé ; dis-le si tu veux le limiter au repère.
3. **Mineurs** : paramètre `_permis` et listes de clés mortes dans `figure.rs` (306-308, 689-700), à nettoyer ou documenter ; cas rare d'un `$$` multi-ligne avec `|` et `---|---` sans `$` dans les cellules, non testé ; étiquette « 90 » collée à « A » sur la capture.
4. **Non observé** : Haiku réel, écran réel. Un essai avec ta clé dira si le prompt strict suffit.
5. `trunk build --release` échoue avec `--offline` (« wasm-bindgen 0.2.129 introuvable ») mais réussit sans, depuis le cache `~/.cache/trunk` : rien téléchargé.

## Contenu exact
```
git -C projet/maths add app/src app/index.html netlify.toml docs/preuves/parcours_v3c1
git -C projet/maths commit -m "Parcours v3c1 : figures tolérantes, repère étendu, motif du refus, prompt strict, tableau Markdown, CSP rejouée"
```
(`app/dist/` est ignoré par git ; `index.html` et `netlify.toml` portent le nouveau hash CSP.)

## Risques et réversibilité
- Risque : Haiku peut encore produire un JSON hors vocabulaire (refus lisible, motif précis) ; énoncés longs coupés.
- Réversible : oui, `git revert` du commit.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
