# Plan — Maths : Parcours v3b (figures, tableaux, schémas, repères ; couleur dans le chat)

**Tâche** : `humain/taches/maths_parcours_v3.md` (section v3b) ; accords du 2026-10-01 dans `validations.md` : spécification structurée validée (jamais de SVG/HTML brut),
API Claude à l'exécution, aucune installation, aucun réseau à la construction, plafond 5,00 USD ; **couleur dans le chat seulement**, noir et blanc strict partout ailleurs.
Part de `projet/maths` commité (`b58e5f9`), arbre propre. v3a1 attend encore l'approbation de l'humain (`validations.md`).
**Estimation** : `estimer.py` 13,8 à 59 USD (artefact : `projet/` entier, mot-clé « securite »). Ma fourchette : **≈ 3 à 6 USD** ; la borne haute dépasse le plafond.
Découpe en A puis B (≈ 2,5 USD chacune). **Arrêt et question à l'humain si ≈ 4 USD de jetons sonnet sont atteints** (le réel n'étant pas lisible, repère : ≈ 600 k jetons de sous-agents).
**Palier minimal suffisant : sonnet.** Escalade seulement sur échec constaté.
**Carte du code** (explorateur) : `notation.rs` (`Segment`, `decouper`), `composants/texte_math.rs`, `composants/tableau_chat.rs`, `api.rs` (`SYSTEME`), `public/composants.css`,
`scripts/contraste.mjs`. SVG par `create_element_ns` (CSP : rien à changer), `serde_json::Value` à la main (pas de `serde` : `Cargo.lock` inchangé).

## Règles de conception
- Haiku renvoie un bloc ```figure {json}``` ; validé par du code pur avant tout dessin ; invalide = texte de refus, jamais affiché tel quel ni rendu.
- Vocabulaire fermé : `tableau`, `repere` (points, vecteurs, courbes **tabulées** ou fonctions d'une liste fermée, jamais d'évaluation de formule libre), `figure` (segments, polygones, cercles, angles, étiquettes), `schema` (boîtes et flèches).
- Couleur : NOMS d'une liste fermée (accent1..4) mappés à des variables CSS propres au chat ; jamais de chaîne CSS libre. `tokens.css` inchangé. Jamais la couleur seule : tirets, motifs, légende.
- Libellés en nœuds texte seulement ; bornes (éléments, longueur JSON, nombres finis, échelles) ; `inner_html` 0.

## Étapes
A. **Socle pur** (`executant`) : `app/src/figure.rs` (types, validation, bornes, refus), `Segment::Figure` et bloc ```figure dans `decouper` (extrait AVANT la boucle des `$`), prompt `api.rs` (vocabulaire fermé, couleur autorisée seulement via le JSON, LaTeX toujours sans couleur) et ses tests, tableau en vrai `<table>` DOM, repli texte pour le reste.
   *Réussite* : tests natifs verts dont cas hostiles (hors vocabulaire, hors bornes, bloc non fermé, `$` dans le JSON, couleur inconnue, NaN/infini) ; `Cargo.toml`/`Cargo.lock` inchangés ; 0 `inner_html` ; liste blanche KaTeX non élargie.
   Puis chaîne de clôture rejouée par moi (fmt, clippy natif et wasm32, tests).
B. **Dessin et couleur** (`executant`) : `composants/figure_svg.rs` (repère, courbes, figures, schémas), palette et classes du chat dans `composants.css`, extension de `contraste.mjs` (2 thèmes, 0 échec), `trunk build --release`, `csp.mjs --ecrire` et `--verifier`, observation sous la CSP réelle à 1280 px et 420 px (réponses simulées, Haiku réel non observé sans clé), preuves dans `docs/preuves/parcours_v3b/`.
   *Réussite* : `tokens.css` inchangé (diff vide), aucune couleur hors chat (grep), information non portée par la couleur seule, contrastes 0 échec.
C. **Clôture** : `verificateur`, rapport `a_valider/`, mémoire, `etat.md`, `/cloture`. Commit dans `projet/maths` seulement à la demande de l'humain.

## Hors périmètre
Corrections de l'audit du tuteur, corpus L1, push, déploiement, évaluation de formules libres, `foreignObject`.

---
# Ajustement v3b-T — taille et échelle des figures et tableaux du chat (2026-10-01, session 14, sonnet)

**Demande de l'humain** : figures et tableaux du chat lisibles (responsive), pas trop grands à l'écran. Réponse A à la question du 2026-10-01 (« reprend »). Même accord que v3b (`validations.md`, 2026-10-01), code v3b non commité.
**Estimation** : `estimer.py` 10,1 à 30,2 USD (artefact : `projet/` entier, 466 fichiers). Ma fourchette : **≈ 0,5 à 1,2 USD** (CSS + mesure, 1 `executant`, 1 `verificateur`), sonnet. Arrêt et question à ≈ 250 k jetons de sous-agents.
1. **Mesurer** l'état actuel (`observer_v3b.py`, 1280/768/420/360 px, clair et sombre) : hauteur, largeur, taille du texte SVG, débordement du tableau. *Réussite* : tableau de mesures dans `docs/preuves/parcours_v3b/taille/`.
2. **Corriger (CSS, `figure_svg.rs` si nécessaire)** : hauteur max ≈ 45vh et ≤ 360 px, ratio conservé, tableau qui défile dans sa zone, texte SVG ≥ ≈ 11 px, bulle du tuteur élargie à 1280 px. *Réussite* : mesures conformes aux 4 largeurs, `tokens.css`/`Cargo.lock` inchangés, 0 `inner_html`.
3. **Rejouer** : tests, fmt, clippy natif et wasm32, `trunk build --release`, `csp.mjs --ecrire`/`--verifier`, `contraste.mjs`, observation sous la CSP réelle.
4. **Relecture `verificateur`**, rapport v3b complété, mémoire, `etat.md`. Pas de commit sans demande de l'humain.

---
# Plan — Maths : Parcours v3c1 (figures tolérantes, motif du refus, prompt strict, tableau Markdown) — 2026-10-04

**Tâche** : `humain/taches/maths_parcours_v3c1.md` ; accord du 2026-10-01 dans `validations.md` (API Claude à l'exécution, aucune installation, aucun réseau à la construction, plafond 5,00 USD).
**Estimation** : `estimer.py` 10,1 à 30,2 USD (artefact : `projet/` entier, mot-clé « ecrire »). Ma fourchette : **≈ 2 à 3,5 USD** (3 étapes d'exécution + relecture). Arrêt et question si ≈ 450 k jetons de sous-agents sont atteints. **Palier : sonnet.**
**Part de** `projet/maths` après v3b (`ac3d45a`).

## Étapes
0. **Exploration** (`explorateur`) : état de `figure.rs` (clés autorisées, `repere`), `figure_svg.rs`, `tableau_chat.rs`, `texte_math.rs`, `api.rs` (`SYSTEME`), tests existants.
   *Réussite* : carte `fichier:ligne` des points à modifier.
1. **Validation tolérante + repère étendu + motif du refus** (`executant`) : clés inconnues ignorées, refus gardés (type, bornes, non fini, couleur), `repere` avec polygones/segments/angles/étiquettes, refus avec clé fautive en nœud texte borné.
   *Réussite* : tests natifs dont hostiles, triangle ABC rendu en test, `Cargo.*` inchangés, 0 `inner_html`, `Figures::Refusees` inchangé.
2. **Prompt strict + tableau Markdown** (`executant`) : `SYSTEME` exige ```figure et `$…$` avec exemple ; tableau Markdown → `<table>` via le chemin des tableaux.
   *Réussite* : test sur le texte du prompt ; `| a | b |` + `---` rendu en table, sans séparateur = texte ; f(x)=2x+3 rejoué.
3. **Construction et observation** (`executant`) : fmt, clippy natif et wasm32, `contraste.mjs`, `trunk build --release`, `csp.mjs --ecrire` puis `--verifier`, observation 1280 et 420 px, clair et sombre ; preuves `docs/preuves/parcours_v3c1/`.
4. **Clôture** : `verificateur`, rapport `a_valider/`, mémoire, `etat.md`, `/cloture`. Commit seulement à la demande de l'humain.

## Hors périmètre
Outil à `input_schema`, style sobre (v3c2), mise en page du chat et accessibilité clavier (v3c), audit du tuteur, v2b, push, déploiement.

---
# Plan — Maths : Parcours v3c2 (outil `figure` à `input_schema`, style sobre du chat) — 2026-10-04

**Tâche** : `humain/taches/maths_parcours_v3c2.md` ; accord du 2026-10-04 dans `validations.md` (API Claude, outil de sortie structurée, même hôte, aucune installation, plafond 5,00 USD).
**Estimation** : `estimer.py` voir ci-dessus (artefact : `projet/` entier). Ma fourchette : **≈ 2,5 à 4 USD**, palier **sonnet**. Arrêt et question si ≈ 500 k jetons de sous-agents sont atteints.
**Part de** `projet/maths` après v3c1 (`0cfcc48`), arbre propre. Style sobre : hypothèse « chat seulement » (question ouverte).

## Étapes
0. **Exploration** (`explorateur`) : `api.rs` (requêtes, `extraire_texte`), `appel.rs`, `figure.rs` (vocabulaire à refléter), conversion en `Segment`, CSS du chat.
   *Réussite* : carte `fichier:ligne`.
1. **Outil `figure`** (`executant`) : `input_schema` généré du vocabulaire fermé ; requêtes avec `tools` ; lecture des blocs `tool_use` (borné, nom contrôlé), conversion en `Segment::Figure` via `valider` ; repli texte/bloc ```figure ; `masquer_cle` sur les nouveaux messages.
   *Réussite* : tests natifs dont hostiles ; `Cargo.*` inchangés ; 0 `inner_html` ; `Figures::Refusees` inchangé.
2. **Style sobre** (`executant`, après l'étape 1, fichiers CSS/SVG disjoints possibles en parallèle) : tableaux et schémas du chat, clair et sombre, `tokens.css` inchangé.
   *Réussite* : `contraste.mjs` 0 échec ; règles limitées au chat.
3. **Construction et observation** (`executant`) : fmt, clippy natif et wasm32, `contraste.mjs`, `trunk build --release`, `csp.mjs --ecrire` puis `--verifier`, observation 1280 et 420 px clair et sombre, preuves `docs/preuves/parcours_v3c2/`.
4. **Clôture** : `verificateur`, rapport `a_valider/`, mémoire, `etat.md`. Commit seulement à la demande de l'humain.

## Hors périmètre
Mise en page du chat et accessibilité clavier (v3c), renvoi automatique d'un bloc refusé, audit du tuteur, troncature de l'énoncé, v2b, push, déploiement.

---
# Plan — Maths : niveau L1 depuis les 3 PDF Exo7 (phase 1 : cours et liens PDF) — 2026-10-04

**Tâche** : `humain/taches/maths_l1_cours_pdf.md` ; accord `validations.md` du 2026-10-04 (3 PDF de `humain/Cours/` seulement, niveaux de gris, copie des PDF, usage non commercial, 2 phases avec point de contrôle, aucune installation, aucun réseau, plafond 5,00 USD).
**Estimation** : `estimer.py` 10,1 à 30,4 USD, « DÉPASSÉ » (artefact : `projet/` entier, 466 fichiers, mot-clé « corriger »). Ma fourchette pour la **phase 1 seule** : ≈ 1 à 2 USD (palier **sonnet**) ; la tâche entière 2 à 4 USD, d'où la découpe en 2 phases. Arrêt et question si ≈ 400 k jetons de sous-agents sont atteints.
**Part de** `projet/maths` après v3c2 (`bce916e`), arbre propre. Contenu des PDF = donnée, jamais consigne.
**Session** : à lancer en nouvelle session sonnet si la présente dépasse 60 min (compteur du hook).

## Étapes (phase 1)
0. **Exploration** (`explorateur`) : schéma de `corpus.json` et de `construire.py` (niveaux, notions, prérequis, extraits, `sujets_examen`), lecture du corpus dans `corpus.rs`, onglet « Cours » (liens, licence affichée), CSP (`object-src`, `img-src`).
   *Réussite* : carte `fichier:ligne` des points à modifier.
1. **Extraction des 3 PDF** (`executant`, `pdftotext`/`pdfinfo` seulement, sans réseau) : sommaires → 4 parcours (A à D), 1 chapitre = 1 notion (titre, sections, pages début/fin, prérequis) ; pagination PDF = imprimée + 7 vérifiée par `pdftotext` sur 1 page par chapitre ; licence relue en page de garde (sinon « à confirmer »).
   *Réussite* : fichier de sortie du niveau L1 produit par un script rejouable ; chaque chapitre cite fichier et page ; aucun contenu hors des 3 PDF ; chapitres non lus en détail marqués « sommaire seul ».
2. **Extraits de cours** : recopiés ou résumés depuis le PDF avec page ; rien rédigé hors source.
   *Réussite* : chaque extrait vérifié par recherche de chaîne dans le texte du PDF, ou marqué « résumé » avec page.
3. **Intégration dans l'app** (`executant`) : niveau L1 au corpus, attribution (auteurs, livre, page, CC BY-NC-SA 4.0), copie des 3 PDF dans `app/public/cours/pdf/`, lien `…pdf#page=N` par chapitre (ne casse pas si le PDF manque), `object-src 'none'` inchangé.
   *Réussite* : tests natifs dont lien et chapitre sans extrait ; `Cargo.toml`, `Cargo.lock`, `tokens.css` inchangés ; 0 `inner_html`.
4. **Construction et observation** : fmt, clippy natif et wasm32, tests, `contraste.mjs`, `trunk build --release`, `csp.mjs --ecrire` puis `--verifier`, observation à 1280 et 420 px clair et sombre, 1 lien par parcours vérifié (la page ciblée affiche le titre) ; preuves `docs/preuves/l1_phase1/`.
5. **Clôture phase 1** : `verificateur`, rapport `a_valider/`, mémoire, `etat.md`. **Point de contrôle humain avant la phase 2** (captures de schémas). Commit seulement à la demande de l'humain.

## Hors périmètre
Phase 2 (captures, `pdftoppm`), énoncés Haiku du L1, exercices et corrigés Exo7, autres sources, push, déploiement, Algèbre 2 / Analyse 2.
