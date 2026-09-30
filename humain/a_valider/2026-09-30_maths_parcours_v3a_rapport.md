# Proposition — 2026-09-30_maths_parcours_v3a_rapport

## Action proposée
Commiter dans `projet/maths` le travail v3a (carrousel d'une notion, écriture mathématique par KaTeX du bandeau et du chat, y compris les textes que tu colles).

## Pourquoi
Tâche `humain/taches/maths_parcours_v3a.md`, accord du 2026-09-30. Les 4 étapes du plan sont faites. Relecture `verificateur` : NON CONFORME au premier passage (couleur KaTeX acceptée, normalisation qui changeait le sens), **CONFORME** après correctifs. Audits différentiels (`pentest/rapports/2026-09-30_maths_parcours_v3a_cloture/`) : 0 critique, 0 élevé, `blocage_livrable: non`. Sans commit, v3a reste mêlée au travail suivant.

Ce que tu verras :
- Bandeau : titre de la notion et énoncé seulement ; ◀ ▶ (clic et clavier) passent d'une notion à l'autre du niveau, sans bouclage ; avancement restauré au rechargement.
- Maths écrites entre `$…$`, `$$…$$`, `\(…\)`, `\[…\]` rendues par KaTeX (énoncé, réponses de Haiku, messages que tu tapes ou colles). Prompt Haiku : maths en LaTeX entre `$…$`.
- Liste blanche d'environ 250 commandes : toute commande inconnue, de couleur (`\red`, `\textcolor`…) ou de lien laisse la formule en texte brut. Noir et blanc strict respecté (0 `style` de couleur observé).
- Hors formule : `R\{2}` → ℝ∖{2}, `\R^2` → ℝ², `x^2` → x², `C^1` → C¹ (plus de lettre ajourée déduite d'un `^`) ; URL jamais modifiées.

Chiffres rejoués par moi ou le relecteur : 109 tests app + 55 moteur, 0 échec ; fmt, clippy `-D warnings` natif et wasm32 ; 0 `inner_html` ; `Cargo.toml`/`Cargo.lock` inchangés (pont par les réexports de `web-sys`) ; CSP : seul le hash change (`sha256-6q+Z…`), `csp.mjs --verifier` OK ; copie KaTeX identique au paquet 0.18.9 (SHA-256) ; observation Firefox headless à 1280 px et 420 px (iframe, en-tête CSP sans `frame-ancestors`, dit tel quel). Preuves : `projet/maths/docs/preuves/parcours_v3a/`.

## Contenu exact
```
git -C projet/maths add app/index.html app/public/composants.css app/public/katex app/src netlify.toml docs/preuves/parcours_v3a
git -C projet/maths commit -m "Parcours v3a : carrousel d'une notion, notation KaTeX (liste blanche), CSP rejouée"
```
Modifiés : `app/index.html`, `app/public/composants.css`, `app/src/{api,main,parcours}.rs`, `app/src/composants/{app_shell,consigne_card,mod,tableau_chat}.rs`, `netlify.toml` (389 ajouts, 191 retraits). Nouveaux : `app/src/notation.rs`, `app/src/composants/texte_math.rs`, `app/public/katex/` (604 Ko), `docs/preuves/parcours_v3a/` (2,8 Mo).

## Points à trancher (aucun bloquant)
1. **Bandeau** : tant que Haiku n'a rien généré, il montre l'invite fixe « Génère un énoncé pour cette notion. » (le corpus n'a pas d'énoncés). Accepté ?
2. **Tuteur jamais audité** (V3A-COUV-1, moyenne, antérieur à v3a) : aucun rapport ne couvre l'appel à `api.anthropic.com` (`appel.rs`, clé `x-api-key`). Je propose un audit ciblé config + entrées + identité/crypto comme prochaine tâche.
3. **README périmé** (V13.1.1, faible) : `README.md:24-27` dit encore « aucun appel réseau ». Correction triviale, à faire avec le point 2 ?
4. **`npm audit`** jamais relancé depuis la phase 1 (moyenne, héritée) : demande un accès réseau, donc ton accord.
5. Faibles (dans les rapports) : longueur des messages collés non bornée (gel possible de l'onglet, provoqué par soi-même) ; `\!` permet de faire chevaucher une formule et le texte ; balises KaTeX sans `integrity`.

## Non vérifié
Appel Haiku réel (je ne sais pas s'il respecte `$…$`), vrai presse-papiers (collage simulé par l'événement `input`), mode sombre, lecteur d'écran ; commandes absentes de la liste blanche éventuellement utilisées par le corpus (s'affichent en brut) ; une URL contenant `$` peut être découpée en formule.

## Risques et réversibilité
- Risque : faible ; une formule refusée s'affiche en texte brut, jamais en HTML.
- Réversible : oui, `git -C projet/maths revert <commit>`.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
