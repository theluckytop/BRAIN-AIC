# Rapport — maths_l1_cours_pdf, phase 1 (niveau L1, extraits, liens PDF) — 2026-10-04

## Livré (code NON commité dans `projet/maths`, base `bce916e`)
- Niveau **L1 (Math Sup)**, ordre 9 : 29 chapitres (A Fondations 6, B Analyse 9, C Algèbre linéaire 7, D Boîte à outils 7), tous « sommaire seul », 195 notions au total. Niveaux 1 à 8 identiques à `HEAD` (hors `genere_le`, `sources`).
- Source unique : les 3 PDF de `humain/Cours/`. Script rejouable `corpus/l1/extraire_l1.py` (+ `integrer_l1.py`, appelé par `construire.py --hors-ligne`, 0 réseau). 29/29 extraits retrouvés mot pour mot dans le PDF à la page citée ; **27/29 « extraction imparfaite »** (formules mal rendues par `pdftotext`).
- Onglet Cours : attribution « Source : Exo7, <livre>, p. N (page PDF M) — Auteurs : … — licence — usage non commercial », étiquettes SOMMAIRE SEUL / DOUTEUX, lien « Ouvrir le chapitre dans le PDF d'origine » (`cours/pdf/<f>.pdf#page=N`, liste blanche de 3 fichiers, bornes). 3 PDF copiés (octet pour octet, sha256 identiques).
- Licences réelles lues dans les PDF : **CC BY-NC-SA 3.0 FR** (Algèbre, Analyse), **4.0 FR** (Formules). La tâche disait 4.0 partout.

## Vérifications
- Rejoué par moi (2 fois) et le `verificateur` : 168 + 55 tests, fmt, clippy natif et wasm32 `-D warnings`, `csp.mjs --verifier` (3 fichiers), `contraste.mjs` 0 échec ; `Cargo.toml`, `Cargo.lock`, `tokens.css` inchangés ; 0 `inner_html` en code. WASM 2 947 290 o / 448 179 o gzip (v2a : 2 677 482 / 377 878).
- Relecture `verificateur` (avant correctif) : critères 1, 3, 4 CONFORMES ; critère 2 NON CONFORME (auteurs non affichés). **Corrigé** (auteurs des 3 livres, chaque nom contrôlé contre le texte du PDF) ; caractères de contrôle retirés des extraits (10 touchés). **Ces deux correctifs n'ont pas eu de seconde relecture par un tiers** (rejoués par moi et par l'observation).
- Observation Firefox headless sous la CSP de `netlify.toml`, 1280 et 420 px, clair et sombre : 74 OK, 0 écart. Les 29 liens répondent 200 `application/pdf`, titre vérifié à la page ciblée ; pdf.js ouvre « Chapitre 1, Les nombres réels » à la page 8/207. Preuves : `projet/maths/docs/preuves/l1_phase1/`.

## Non observé
Chrome (visionneur PDF sous `object-src 'none'`), écran réel, déploiement Netlify réel, contenu de l'onglet Cours des 25 chapitres non échantillonnés, tuteur Haiku sur L1.

## Points à trancher
1. **Extraits illisibles** (question dans `questions.md`) : A garder tel quel avec mention (fait) / B retirer / C écrire en LaTeX à la main.
2. **Licence 3.0 FR** au lieu de 4.0 : l'attribution suit le texte des PDF. À confirmer.
3. **Chrome** : si le PDF ne s'ouvre pas sous la CSP en production, il faudra un en-tête propre à `/cours/pdf/*` (décision CSP à toi).
4. **Tuteur L1** : `extrait.url` vide, donc « Source : non fournie » (hors périmètre).
5. **Prérequis et parcours** : choix éditoriaux de l'agent (README de `corpus/l1`), à relire.
6. **Bouton menu qui recouvre le début des titres** de l'onglet Cours (aussi en Terminale, donc antérieur à L1) : relève de v3c.
7. **Poids** : +3,8 Mo de PDF dans `dist/`, WASM +10 % (corpus embarqué).
8. **Phase 2 (captures de schémas)** : point de contrôle, non commencée.

## Commit proposé (à ta demande seulement)
`git -C projet/maths add -A && git -C projet/maths commit -m "L1 phase 1 : niveau L1 depuis les PDF Exo7, attribution et liens PDF"`
Ligne `validations.md` à écrire par toi si tu approuves.
