# État — mis à jour le : 2026-09-30 (session 7, 02:56)

## maths_corpus : clos, APPROUVÉ par toi le 2026-09-30 (`validations.md`) ; prochaine tâche : `maths_parcours`
- À lancer en **nouvelle session, palier sonnet** : estimation `estimer.py`, puis plan. Aucun réseau à l'exécution.

## Rapport de clôture : `a_valider/2026-09-30_maths_corpus_rapport.md`
- **Étape 6 faite** : relecture `verificateur` (sonnet) de `f2ba25e` : **CONFORME**, 0 bloquant, 4 écarts mineurs du README
  corrigés (commit `11b65e2` dans `projet/maths`, non relu par un tiers).
- Chiffres : 166 notions, 841 exercices (titres + liens), 28 extraits dont **10 douteux** (et non 9 comme annoncé
  auparavant), CM2 0/20, Seconde 1/24.
- Estimation du jour : `estimer.py` donne 8,4 à 25,3 USD (périmètre `projet/` entier, 434 fichiers : artefact connu) ;
  étape 6 réelle ≈ 51 k jetons sonnet. **Réel total de la tâche à relever de ton côté** (plafond 5 USD peut-être dépassé
  à cause du pilotage en opus).
- Suite : ton approbation du rapport dans `validations.md`, puis `maths_parcours` (le cours manquant s'y traite) ;
  palier conseillé : sonnet, en nouvelle session.

## Historique — maths_corpus (corpus de cours CM2 à Terminale)
- **Session 6 (2026-09-30, 01:19)** : étape 5d lancée (`executant`, sonnet). Estimation `estimer.py` du jour :
  6,4 à 19,3 USD, gonflée par le périmètre `projet/` entier (273 fichiers) ; estimation initiale 1,26 à 3,77 USD.
  Dépense relevée ≈ 300 k jetons sonnet (≈ 1,5 USD) + 5d ≈ 1 USD : plafond de 5 USD tenu selon mon relevé,
  à confirmer par le coût réel. Ensuite : contrôle de pertinence, puis étape 6.
- **5d faite, objectif non atteint** (02:10, commit `f2ba25e`) : 28 extraits sur 166 (26 avant), 9 douteux ; CM2 0,
  Seconde 1 (douteux) ; Terminale : Matrices et lois discrètes retirés, TVI et complexes 15/18 douteux.
  **Écart** : ≈ 510 appels Wikiversité au lieu de ~350 (relance qui rejouait le cache ; corrigé, leçon écrite).
  Coût executant : ≈ 99 k jetons sonnet, 40 outils, 51 min. **Question posée** (A clore et traiter le cours
  manquant dans `maths_parcours` / B autre source / C finir la recherche Wikiversité).
- Arrêt 02:45 (86 min sur 90), sans réponse à la question. Reprise en nouvelle session : lire la réponse dans
  `questions.md`, relecture `verificateur` de la v2 (commit `f2ba25e`), puis étape 6 selon la réponse.
  Deux boucles d'attente orphelines laissées par l'executant ont été arrêtées (aucun appel réseau).
- **Réponse A** (02:45) : corpus clos tel quel, trous marqués ; cours manquant traité dans `maths_parcours`.
  Reprise en nouvelle session : relecture `verificateur` de `f2ba25e`, rapport `a_valider/` (corpus livré, 28/166
  extraits dont 9 douteux, écart ≈ 510 appels), mémoire (décision), estimation, puis `maths_parcours` après ton
  approbation dans `validations.md`.
- **Reprise 2026-09-30 (session 5)** : accord forge.aeif.fr présent dans `validations.md`. Étapes 5b (référentiel
  Coopmaths de la forge → notions) et 5c (filtre des extraits faibles) confiées à `executant` en sonnet ; puis contrôle
  de pertinence refait, étape 6 (commit, relecture, rapport).
- **Bloqué 5b** : forge.aeif.fr n'existe plus (vérifié par l'humain hors bac à sable) ; dépôt probable sur
  forge.apps.education.fr. **Accord A' inscrit** (2026-09-30), dépôt vérifié (HEAD 11847f7) ; 5b relancée (executant).
- **5b faite** : 166 notions (thèmes Coopmaths, commit forge 11847f7), 841 exercices rattachés, schema_version 2 ;
  mais 26 notions seulement avec extrait (CM2 et Seconde : 0). Commit `3c26fe9`. Question posée (A passe de recherche
  Wikiversité / B livrer tel quel / C retirer les extraits mal appariés). Coût executant du jour ≈ 190 k jetons sonnet.
- **Réponse A** (01:17) : passe de recherche Wikiversité, étape 5d du plan. **Reportée en nouvelle session** (63 min
  écoulées sur 90 ; la passe 5b a pris 29 min). App montrée : build release servi depuis `dist/` (trunk serve = page
  blanche à cause de la CSP, leçon écrite). Parcours : pas encore construit (`maths_parcours` après le corpus).
- Reprise : lire l'étape 5d de `travail/plan.md`, déléguer à `executant` (sonnet), contrôle de pertinence, puis étape 6. Question dans
  `questions.md` (A ouvrir l'hôte / B lever le bac à sable pour le clone / C clone par toi / D renoncer). 5c fait :
  utile 17/21 (hier 15/21), Seconde et Terminale sous le seuil. Commit `1740291` dans `projet/maths`. Relecture et
  rapport en attente de la réponse.
- Tâche `humain/taches/maths_corpus.md`, accord réseau lecture seule du 2026-09-29 dans `validations.md`.
- Estimé 1,26 à 3,77 USD (sonnet), plafond 5,00 USD tenu. Pilotage en opus (palier courant), exécution
  déléguée à `executant` en **sonnet**. Démarrage 22:40, arrêt visé ≈ 23:40.
- Plan : `travail/plan.md`. **Étapes 1 à 5 faites** (23:41), étape 6 (commit, relecture, rapport) non faite.
- Résultat : `projet/maths/corpus/` (script `construire.py` rejouable, `--hors-ligne` vérifié ; `sortie/corpus.json`
  245 538 o, 28 090 o gzip ; `couverture.md` recalculée à l'identique). 8 niveaux avec source officielle ;
  **51 notions seulement** (Seconde 1, CM2 2) ; Terminale sans exercice ; extraits utiles 15/21 au contrôle
  (`docs/pertinence.md`), 3e et Seconde sous le seuil.
- Écarts : référentiel Coopmaths absent du dépôt GitHub (sur forge.aeif.fr, hors accord) ; exercices Coopmaths
  en **AGPL-3.0** (pas CC BY-SA) : titres et liens seulement ; Wikibooks écarté (correspondances aberrantes).
  Un `rm -rf` de l'executant bloqué par le hook, non contourné. Rien de commité.
- **Question posée** dans `questions.md` (A étendre l'accord à forge.aeif.fr / B garder et filtrer / C notions à la main).
  **Réponse : A** (2026-09-30 00:05). Accès à forge.aeif.fr dès que la ligne est dans `validations.md` (absente à 00:05).
- Arrêt à 23:45 (65 min, au-delà des 60 visées). Reprise : réponse à la question, filtre des extraits faibles
  dans le script, commit, relecture `verificateur`, rapport `a_valider/`, mémoire, estimation.
- Coût : executant sonnet ≈ 110 k jetons, 49 outils, 58 min ; réel en USD non lisible depuis l'agent.
- Choix : corpus avant la responsivité + clé API persistante, car il débloque `maths_parcours` et porte
  un accord écrit ; la question « responsivité » (A/B) a reçu la réponse **A** (22:50) :
  responsivité, clé API persistante et changements du cahier des charges en **nouvelle session** (sonnet).
- **Ordre décidé par toi** : corpus → parcours (dès ton approbation du corpus dans `validations.md`) →
  responsivité + clé API persistante + cahier des charges (nouvelle session).
- App lancée à ta demande : build de production servi sur http://127.0.0.1:8080/ (serveur Python local).


## Arrêt du garde-fou : évolution « responsivité + clé API persistante » NON commencée
- Demande (sous-agent, tâche A à D : clé `localStorage` avec RENOUVELER/EFFACER, responsivité, outil DÉPLACER,
  captures Firefox, commit « Phase 3bis … ») : le hook a refusé le tout premier appel Bash
  (« Budget épuisé, durée 103 min > 90 »). Lu seulement : `travail/plan.md` (ancien plan de la phase 3bis, non modifié).
- **Rien n'a été écrit dans `projet/maths/`, aucun commit, aucun processus lancé** (ni geckodriver, ni serveur).
  Les fichiers `app/src/*`, `index.html`, `composants.css` n'ont pas été lus.
- Pour reprendre : nouvelle session (compteur remis à zéro), même demande ; question dans `humain/questions.md`.
- **Nouvelle demande (parcours par niveau, menu ☰ → Parcours, API de cours)** : consignée dans `humain/questions.md` (3 points
  bloquants : quelles API, quand les appeler, modale ou onglet + liste de niveaux). Rien de fait. Session à 267 min, arrêt du
  garde-fou. À traiter dans la nouvelle session, après la responsivité + clé API persistante.
- **Parcours par niveau : décisions de l'humain reçues** (2026-09-29) : mélange niveaux officiels (data.education.gouv.fr) +
  cours Wikiversité/Wikibooks et Coopmaths ; fenêtre « Parcours » en **modale** ; niveaux **CM2 à Terminale** ; corpus en amont.
  Repérage des API consigné dans `humain/questions.md`. À faire en nouvelle session : tâche à déposer par l'humain dans
  `humain/taches/` + ligne dans `validations.md` (accord réseau lecture seule pour la construction du corpus), puis estimation.
- Rappel : relecture `verificateur` de la phase 3bis, mémoire, `etat.md` et estimation restent à faire.

**Tâche en cours** : aucune. Phase 3 de l'app de maths **close côté agent, avec réserve clavier** (ta
décision A) ; en attente de ta validation.
**Modèle** : courant opus (à ta demande) ; phase 4 pressentie au palier moyen → `/model sonnet` en
nouvelle session, à confirmer par `estimer.py` au dépôt de `maths_phase4.md`.
**Budget** : phase 3 estimée 1,10 à 3,31 USD en sonnet (plafond 5,00 USD) ; clôture en opus, 3 sous-agents
(≈ 231 k jetons) ; réel non lisible depuis l'agent, à relever de ton côté.

## Fait (clôture, session 3)
- **Relecture finale de `34cad26` : CONFORME**, 0 bloquant, 8 mineurs. Rejoués par le relecteur : 17 + 55 tests,
  clippy `-D warnings` natif et wasm32, fmt, `trunk build --release`, hash CSP (code 0), `inner_html` 0 ligne.
- **Audits différentiels** du correctif `6519fce`/`34cad26` (`pentest/rapports/2026-09-29_maths_phase3_cloture/`) :
  **0 critique, 0 élevé, aucune régression**. Entrées : 4 conformes, 2 informations. Config (base 84) :
  2 moyens hérités, 20 faibles ; CLO-HASH-1 (indéterminé, l'auditeur n'a pas de shell) levé par ma sortie brute.
- Mineurs corrigés : `docs/preuves/phase3/erratum_cloture.txt` (commits `84a03a5`, `f852273` dans
  `projet/maths`, **non relus par un tiers**) ; taille du build final 769 484 o, **164 766 o gzip** ;
  temps WASM retenu **11 ms** (seul chiffre archivé sous la CSP) ; plan et rapport mis à jour.
- Mémoire : 1 décision, 1 leçon (preuve datée avant le dernier code), 1 ligne d'estimation. Aucun
  calibrage proposé : 0 relevé exploitable sur 10.

## En attente de ta validation
- `humain/a_valider/2026-09-29_maths_phase3_rapport.md` : clôture de la phase 3 avec réserve clavier,
  **6 points à trancher** (démo et `#mesure` en production, `maxlength`, `style=`, `RUST_VERSION`,
  `@import` Google Fonts, recommandations de l'audit : CSP entière vérifiée, `--locked`, `.gitignore`).
- `humain/a_valider/2026-09-29_maths_phase4_tache.md` : **brouillon** de `humain/taches/maths_phase4.md`
  (KaTeX + MathLive, un exercice jouable), à copier par toi si tu autorises la phase 4.
- Test clavier réel de ta part (Tab puis Entrée sur un bouton de la démo), recommandé avec la décision A.

## Non fait, et pourquoi
- `travail/brouillons/` **non vidé** : pas d'accord de suppression (`phase2_diff.txt`, `tableau-pixel/`,
  qui sert encore de référence pour la phase 4).
- Dépôt BRAINIAC commité à ta demande (clôture de la phase 3).
- Aucun push dans `projet/maths` (5 commits de phase 3 locaux : `26dbe0f` à `f852273`).

## Sécurité
Aucun constat critique ni élevé ouvert sur `projet/maths`. Ouverts : 2 moyens hérités (V15.1.1, V15.2.1),
V15.2.3 non conforme faible (code de démo en production, point 1 du rapport), faibles listés dans les audits.

---

## Phase 3 de l'app de maths — composants Leptos (sonnet, tâche entière, choix B) : en cours, arrêtée
- Fait et rejoué par moi : étapes 1 à 6 (Button, MenuButton, AppShell, ConsigneCard, ExplainPanel,
  Whiteboard, Verdict, Exercice relié au moteur). 17 tests natifs, clippy `-D warnings` (natif et
  wasm32), fmt, `trunk build` OK, `inner_html` : 0 ligne. Contraste des tokens : 16 couples,
  0 échec (pire texte 6,09:1), `app/scripts/contraste.mjs`. **Rien n'est commité.**
- Étape 7 (temps WASM) : **pire cas 15,0 ms** sur 25 cas, Firefox 149, build release, seuil 50 ms tenu
  (`docs/preuves/phase3/temps_wasm.txt`). **Mesuré avec la CSP retirée par un serveur de test**
  (`outils/serve.py`), pas sous la CSP réelle : elle bloque l'app.
- Étape 8, faite en partie, **rapportée par l'agent, non revérifiée par moi** : 29 captures
  (`docs/preuves/phase3/captures/`), dessin 4/4 (`dessin.txt`), ordre de tabulation logique.
  Écarts constatés : note du Whiteboard coupée et recouverte par la barre d'outils (`max-width`
  à réduire vers `calc(100% - 460px)`), ordre des outils différent de l'aperçu de référence.
  `clavier.txt` sur disque est celui d'un harnais bugué (14/20) : **à refaire avant citation**.
  Références rendues avec les polices locales (les `preview.html` pointent vers Google Fonts).
- **Non fait** : reduced-motion (d), contraste des couleurs appliquées (e), corrections du
  Whiteboard, qualité finale après les ajouts de l'agent (`mesure.rs`, features web-sys `Window`,
  `Performance`, `Location`), taille WASM, audit (étape 10), relecture, rapport (étape 11).
- Reprise en nouvelle session (durée du compteur remise à zéro) : décision CSP ; relancer
  `clavier.py`, faire (d) et (e), corriger le Whiteboard ; `fmt/clippy/test` ; commit ; audit
  `pentest_config` (la CSP en fait partie) et `pentest_entrees` ; relecture ; rapport.
- Budget : estimé 1,00 à 2,99 USD en sonnet, plafond 5,00 USD ; réel non lisible depuis l'agent
  (≈ 60 actions, 4 sous-agents dont deux `executant` de 60 à 100 k jetons).
- Écarts de méthode : mon horloge de 60 min partait de la tâche (14:03), celle du hook de la session ;
  leçon écrite. Deux sous-agents ont écrit un `cd` nu (sans effet).

## Accords donnés en session (2026-09-29), à appliquer à la reprise
- **Suppression** de `travail/_tmp_calc.mjs` (fichier vide créé par erreur) : accord de l'humain, à
  exécuter en début de prochaine session (accord oral en session, valable pour ce seul fichier).
- Commit du dépôt BRAINIAC : fait par l'humain (`4c0d8dd`, `84f2714`). Reste non commité : la phase 3
  de `projet/maths` (attend le correctif CSP, l'audit et la relecture).
- CSP : option A (hash sha256 du script d'amorçage), voir `humain/questions.md`.
- `travail/brouillons/` : pas d'accord de vidage ; ignoré par git.

## Fin de phase 2 (rappel)
- Phase 2 approuvée dans `validations.md` le 2026-09-29 (N-01 accepté, plafond 5,00 USD maintenu).
  Commit du dépôt BRAINIAC (mémoire, rapports, état) toujours non fait ; brouillons non vidés
  (`travail/brouillons/`, accord de suppression requis ; `tableau-pixel/` y sert encore de référence).

## En cours (2026-09-28) — app de maths, phase 2 : moteur mathématique (opus, choisi par toi)
- Tâche `humain/taches/maths_phase2.md` ; estimé 1,63 à 4,88 USD (opus), plafond tenu. Démarrage 23:09.
- **Moteur** dans `projet/maths/moteur/` : analyseur, fractions exactes, équivalence (24 points
  pseudo-aléatoires), forme simplifiée, forme développée/factorisée exigible, équations du 1er degré,
  `verifier` et `verifier_forme`. **49 tests**, clippy `-D warnings` propre, fmt propre.
- **1re relecture : NON CONFORME** (forme simplifiée trop permissive, pire cas de temps non établi) ;
  **audit `pentest_entrees` : 0 critique, 0 élevé**, 1 moyen (E-01, recopier l'énoncé), 4 faibles.
  Tout corrigé au commit `3236c64` ; E-01 réglé dès maintenant, sur ta décision.
- Temps : pire cas connu **26 ms (debug), 2,8 ms (release)** grâce à un budget de calcul borné.
- 5 décisions et 2 leçons consignées (dont une 3e récidive de `cd` nu de ma part, rattrapée aussitôt).
- **Seconde relecture (23:50) : NON CONFORME.** 3 constats corrigés, 4 en partie, et **2 régressions**
  introduites par la réécriture de `forme.rs` : réponses justes et simplifiées jugées « à simplifier »
  (R1 : `-x(x+1)`, `-(x-1)(x+1)` ; R2 : `-1/x`, `-3/(x+1)`). Restes : `6x/8`, `-(-2x)`, `1/x+1/x`
  passent ; pire temps trouvé 16,7 ms (release) mais 137 ms (debug) ; division par zéro de la
  référence encore imputée à l'élève ; polynôme de degré ≥ 24 construit exprès indétectable.
- **Audit différentiel du correctif : 0 critique, 0 élevé** ; budget non contournable ; 2 moyens
  (E-01 partiel et N-01 : « Factorise » contourné par `-(-x^2-2x-1)`), 5 faibles, 1 information.
  Rapport : `pentest/rapports/2026-09-28_maths_phase2_correctif/`. E-04 (affichage des messages en
  texte seulement, jamais `inner_html`) est une exigence pour la phase 3.
- **Arrêt à 23:52 (43 min)**, décision de l'humain à 23:54 : principe « jamais de sanction à tort » ; reprise
  en nouvelle session selon la fin de `travail/plan.md` (points a à f).

### Reprise du 2026-09-29 (nouvelle session, opus) — phase 2 livrée, en attente de validation
- **Coût** : la phase 2 était estimée 1,63 à 4,88 USD pour la tâche entière ; cette reprise s'ajoute
  aux 43 min de la veille. Le plafond de 5,00 USD par tâche risque d'être dépassé : à relever de
  ton côté (l'agent ne lit pas les crédits).
- (a) R1 et R2 corrigés ; une référence jamais définie (`1/0`, `1/(x-x)`, `3/4+0/0`) est désormais
  une erreur de la référence, plus « faux » pour l'élève.
- (b) `forme.rs` réécrit : valeurs sans `x` à garantie exacte ; expressions en `x` sanctionnées
  sur **règles sûres seulement** (liste en tête du module). Test aléatoire : 20 000 expressions
  évidemment simplifiées, 0 sanction. Test différentiel sur les 14 258 expressions de la relecture :
  0 jugée simplifiée par la nouvelle règle et pas par l'ancienne ; j'ai relu 70 des 5 329
  nouvellement sanctionnées, toutes portent un calcul. Tolérées dans le doute : `x/2*3`,
  `(x+1)(x+1)`, `(2x)^2`, `2*(-x)`.
- (c) « Factorise » : `-(-x^2-2x-1)`, `-(2x+2)`, `1(x^2+2x+1)` refusés ; `-(x+1)` accepté.
- (d) Budget 150 000 (au lieu de 300 000), 48 tirages (au lieu de 96), constantes comparées en un
  point : **pire cas 9,5 ms en release**, 73 ms en debug (indicatif). Conséquence : `-14(x+1/13)^64`
  (degré 64, hors MVP) donne « calcul trop long ».
- 55 tests, clippy `-D warnings` et fmt propres, WASM inchangé. Commits `4c1bc78`, `4fd1b0b`.
- (f) **3e relecture : CONFORME** (5 mineurs ; M1 formes factorisées en quotient refusées, M2 ±1
  non calculé, M5 commentaire : corrigés). **Audit différentiel : 0 critique, 0 élevé**, 2 moyens
  (E-01/N-01 partiels : factorisation complète non vérifiée), 6 faibles ; R-01 corrigé. Commit
  `0733742`, 55 tests, pire cas 7,8 ms release.
- **`/cloture` faite** : relecture et audit de `0733742` : CONFORME, 0 critique, 0 élevé (audit :
  `pentest/rapports/2026-09-29_maths_phase2_cloture/`, lire R-02 comme information). Régression
  mineure corrigée au commit de clôture (non relu par un tiers ; 55 tests, 8,4 ms release).
- **En attente de ta validation** : `humain/a_valider/2026-09-29_maths_phase2_rapport.md` (clôture,
  limites acceptées dont N-01 « Factorise » en gravité moyenne, phase 3, budget).
- **Modèle** : courant opus ; phase 3 (interface) probablement au palier moyen : `/model sonnet`,
  à confirmer par l'estimateur au dépôt de `maths_phase3.md`.
- **Brouillons non vidés** : `travail/brouillons/phase2_diff.txt` et `tableau-pixel/` (copie
  jetable de `tableau-pixel.zip`) attendent ton accord de suppression.
- Écart au cycle : correctifs écrits par moi, sans passer par `executant` (conception trop liée au
  diagnostic pour être déléguée utilement) ; relecture et audit restent indépendants.
- 4e `cd` nu de ma part (`cd /tmp`), sans effet grâce au retour automatique à la racine ; leçon écrite.

## Phase 1 de l'app de maths — close
- Accord reçu : ligne du 2026-09-28 dans `validations.md`, tâche `humain/taches/maths_phase1.md`.
- Estimation (`estimer.py`) : 0,62 à 1,86 USD en sonnet, mesure faussée par `projet/brainiac-console/`
  déjà présent (ordre de grandeur, pas une mesure fiable pour une construction à partir de rien).
- **Socle livré dans `projet/maths/`** (dépôt git propre, 3 commits : `0b23065`, `61fe849`, `65c4265`) :
  - Espace Cargo `moteur` (lib pure) + `app` (Leptos 0.8.21 CSR, Trunk 0.21.14).
  - `tokens.css` et `bundle.css` de Tableau Pixel repris tels quels (empreintes SHA-256 vérifiées deux
    fois, par moi puis par `verificateur`).
  - Polices Silkscreen et Pixelify Sans auto-hébergées (woff2) ; KaTeX 0.18.9 et MathLive 0.110.0
    installés (usage prévu en phase 4).
  - CSP stricte en en-tête HTTP réel (`netlify.toml`, contrairement à Tauri qui ne le permettait pas
    en phase 2 de BRAINIAC Console), `Permissions-Policy` ajouté après audit + `<meta>` en défense en
    profondeur.
  - `trunk build --release` OK : WASM 108 959 o brut, **29 413 o compressé gzip** (objectif : < 500 Ko),
    rejoué et confirmé par `verificateur`.
  - `cargo fmt --check` et `cargo clippy` (`moteur` et `app`) : propres, rejoué par `verificateur`.
  - Preuves dans `projet/maths/docs/preuves/phase1/` (`.txt`, ouvertes avant citation).
- **Audit `pentest_config`** (`pentest/rapports/2026-09-28_maths_phase1/`) : 84 exigences, **0 critique,
  0 élevée**, 2 moyennes (1 corrigée : `Permissions-Policy` ; l'autre, délai de correction des
  dépendances, laissée à ta décision), 3 non conformes de gravité faible/moyenne toutes corrigibles à
  faible effort. Les exemptions Tauri de `pentest/exemptions.md` n'ont pas été appliquées (site
  Netlify public, contexte différent de `projet/brainiac-console/`).
- **Relecture `verificateur` : NON CONFORME**, sur 2 écarts mineurs (critère de l'étape 4 du plan pas
  assez précis, chemin des preuves ne correspondant pas au plan) — **fond technique confirmé conforme**
  (build, tests, empreintes, taille WASM tous rejoués indépendamment). Corrigés au commit `65c4265`,
  **sans seconde relecture** (même pratique qu'à la phase 2 de BRAINIAC Console).
- **2 décisions consignées** : `bundle.css` gardé avec son `@import` Google Fonts d'origine (bloqué
  sans perte par la CSP réelle) ; CSP en en-tête HTTP plutôt qu'en `<meta>` seule.
- **1 leçon consignée** : le réglage `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` ne protège pas d'un
  `cd` écrit dans la même commande (`cd X && trunk build`) ; corrigé par un sous-shell `( cd … && … )`.
- `npm audit` : 0 vulnérabilité. `cargo-audit` non installé (hors accord réseau de la phase 1).
- `tableau-pixel.zip` décompressé dans `travail/brouillons/tableau-pixel/` pour lecture (copie jetable).

## En attente de ta validation (nouveau)
`humain/a_valider/2026-09-28_maths_phase1_rapport.md` : clôture de la phase 1, autorisation de la
phase 2 (moteur mathématique), décision sur la politique de délai de correction des dépendances
vulnérables pour `projet/maths/` (celle de `projet/brainiac-console/` n'a pas été reconduite d'office).

Le point de contrôle de BRAINIAC Console phase 2 (ci-dessous) reste en attente, en parallèle.

---

**Tâche en cours** : aucune. BRAINIAC Console, phase 2 (suivi en lecture) **livrée et clôturée côté agent** ; en attente de ton point de contrôle. Phase 3 (écritures) non commencée.
**Modèle** : courant sonnet / recommandé moyen (sonnet) / nominal moyen.
**Budget** : estimé 0,44 à 1,33 USD (plafond 5,00 USD tenu) / réel : non lisible depuis l'agent, à relever de ton côté (≈ 85 actions, 9 sous-agents, ≈ 690 k jetons d'agents). Session démarrée vers 00:55, arrêt à 60 min respecté.

## Fait
- Phase 2 livrée dans `projet/brainiac-console/` : commits `3022006`, `34c18e1`, `09f99fa`.
  - Points de l'audit du 2026-09-23 traités (ACL, permissions réduites, en-têtes, garde de navigation, mesures et aperçu hors version publiée, README, délais de dépendances, gabarit retiré).
  - Onglet « Suivi » en lecture seule (six blocs), `notify` 8.2.0, Markdown assaini.
  - Tests relancés par moi : `cargo test` 39 réussis ; assainissement 0 échec (contre-épreuve : 7 échecs) ; contraste 0 échec ; build OK ; 0 option interdite ; 0 API d'écriture hors `ecriture.rs`. Sorties dans `docs/preuves/phase2/`.
- **Relecture `verificateur`** : NON CONFORME au plan, écarts mineurs (test de questions présenté comme « réel » alors qu'il était retouché, mesures non consignées, README périmé, test négatif du garde manquant). Tous corrigés au commit `34c18e1` ; **pas de seconde relecture**, seulement mes relances.
- **Audit différentiel** V1, V3, V13, V15 (`pentest/rapports/2026-09-24_differentiel_phase2/synthese.md`) : 54 exigences, 0 critique, 0 élevé, 2 moyennes, 0 régression.
- Mémoire : 4 décisions, 3 leçons, 1 ligne d'estimation. Aucun calibrage proposé : 0 relevé exploitable sur 10 requis.
- Ta réponse sur le budget (tâche entière) et sur le départ des délais de correction (publication de l'avis) consignées dans `humain/questions.md`.

## En cours
—

## Bloqué
—

## En attente de ta validation
- `humain/a_valider/2026-09-24_brainiac_console_phase2_rapport.md` : clôture de la phase 2, autorisation de la phase 3, `jsdom` en dev (dépendance non prévue), lecture de V3.4.5, réseau pour la phase 3.
- `humain/a_valider/2026-09-23_garde_fou_faux_positif_version.md` : correctif de `garde_fou.sh`, à appliquer par toi.
- **Accord de suppression** : `travail/brouillons/phase2_diff.txt` (copie conservée dans `docs/preuves/phase2/diff_audite.txt`) et `travail/_tmp_calc.mjs` (fichier vide créé par erreur). Je n'ai pas vidé `brouillons/` : `AGENTS.md` exige ton accord pour une suppression, et celui de la phase 1 ne valait que pour la phase 1.
- Le commit du dépôt BRAINIAC (mémoire, rapports, état) n'est pas fait : je ne commite pas sans ta demande.

## Sécurité
Aucun constat critique ni élevé ouvert. Ouverts : V15.1.1 et V15.2.1 (moyenne), 8 faibles dont V3.7.2 (`on_new_window` absent) et V15.2.2 (anti-rebond sans délai maximal). `cargo audit` non disponible.

## Écarts à connaître
- **Aucune fenêtre lancée** : rendu 420 px, événement `suivi-change` de bout en bout, refus d'ACL au runtime, en-têtes réellement émis, test 17 en vrai, non observés. Test 2 partiel (200 ms jusqu'au rappel du débounceur, pas jusqu'à l'affichage).
- Pas de barre de coût (aucune source de données) ; « session qui tourne » est une heuristique de ma part.
- Test 14 toujours reporté en phase 6.
- Récidive du `cd` nu de ma part (session verrouillée jusqu'à ton `! cd`), et dans le premier appel de chaque sous-agent (sans effet). Leçons consignées.
- Incohérence de compteur dans `application_config.json` (rapport en ajout seul, non modifié), notée dans la synthèse.
- L'estimateur n'accepte que `humain/taches/<fichier>` ; l'estimation de la ligne phase 2 a été insérée avant la ligne de clôture de la phase 1 dans `estimations.md` (même date).

## Prochaine étape
Ton point de contrôle sur le rapport de phase 2, puis, si tu autorises la phase 3, dépôt de sa tâche et `/tache` dans une nouvelle session (`sonnet` déjà actif).
