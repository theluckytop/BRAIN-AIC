# Décisions
Ajout uniquement. Format :

```
## AAAA-MM-JJ — décision en une ligne
- Contexte :
- Alternatives rejetées et pourquoi :
- Conséquences :
```
---

## 2026-09-23 — BRAINIAC Console sur Tauri 2.11 (pas 3.0)
- Contexte : phase 0 ; crates.io donne 2.11.6 stable et 3.0.0-alpha.2 en préversion.
- Alternatives rejetées et pourquoi : Tauri 3 alpha, API instable et sans documentation arrêtée.
- Conséquences : pile Tauri 2.11 + Vite 8 + TS + Svelte ; plan approuvé le 2026-09-23 (plan et phase 1 seulement).

## 2026-09-23 — Autorisations de session routées par un outil MCP, repli sans contournement
- Contexte : question 4.3 du cahier ; `--permission-prompt-tool` est documentée mais absente en entrée propre de `claude --help`.
- Alternatives rejetées et pourquoi : parler en Rust le canal de contrôle stdio de l'Agent SDK (non documenté comme protocole public) ; embarquer Node et l'Agent SDK (dépendance d'exécution lourde).
- Conséquences : démonstration en session réelle en tête de phase 4 ; à défaut, `--permission-prompts none` et renvoi vers l'onglet Suivi.

## 2026-09-23 — Une tâche BRAINIAC par phase de BRAINIAC Console
- Contexte : condition de l'approbation humaine ; l'estimateur mesure `projet/` et sous-estime une construction à partir de rien.
- Alternatives rejetées et pourquoi : une seule tâche pour les 7 phases (plafonds de durée, d'actions et de 5 USD intenables).
- Conséquences : chaque phase a son fichier de tâche, son estimation au démarrage, son rapport et un point de contrôle humain.

## 2026-09-23 — Mode d'écriture imposé par la zone, jamais choisi par l'appelant
- Contexte : test 5 et condition d'approbation « création seule dans taches/ et pieces_jointes/ ».
- Alternatives rejetées et pourquoi : un paramètre `mode` passé par l'appelant, qui permettrait à une commande future de demander un écrasement.
- Conséquences : `ecriture::Zones::ecrire` déduit le mode du chemin canonique ; `create_new` pour les tâches, `append` sur fichier existant pour validations/questions, renommage atomique pour la configuration.

## 2026-09-23 — Palette ajustée au contraste AA mesuré
- Contexte : cahier §7, valeurs « indicatives » ; `scripts/contraste.mjs` mesure le pire cas (fenêtre translucide sur fond blanc).
- Alternatives rejetées et pourquoi : garder 82 % et `#8A9A8C` (4,2 : sous le seuil AA) ; employer `#E8323C` comme couleur de texte (3,4).
- Conséquences : fond à 86 %, `--texte-2: #9AAA9C`, `--alerte-texte: #FF8088` ; `#E8323C` réservé aux aplats.

## 2026-09-24 — Preuves de phase conservées dans le dépôt de l'application, pas dans `quarantaine/`
- Contexte : `/cloture` de la phase 1 ; `travail/brouillons/` devait être vidé et contenait les preuves citées par le rapport.
- Alternatives rejetées et pourquoi : `quarantaine/`, réservée aux échecs (AGENTS.md) ; laisser les brouillons, qui sont un espace jetable.
- Conséquences : preuves dans `projet/brainiac-console/docs/preuves/phase1/` (commit `eb8b542`) avec README de provenance ; `.log` renommés en `.txt` car `*.log` est ignoré par git ; `garde_fou.diff` et `test_garde_fou.sh` (espace, pas application) y sont aussi, faute d'autre lieu d'écriture libre ; `apercu/` et `ff/` (profil Firefox) non conservés.

## 2026-09-24 — Clôture de la phase 1 avec le test 14 encore partiel
- Contexte : relecture NON CONFORME sur le seul critère 4 (repli sans compositeur non observable sur GNOME Wayland).
- Alternatives rejetées et pourquoi : requalifier l'écart en conforme (aucune preuve) ; bloquer la phase 2 (l'humain l'a autorisée en connaissant l'écart).
- Conséquences : décision de report proposée dans `a_valider/2026-09-24_brainiac_console_phase1_cloture.md`.

## 2026-09-24 — Phase 2 : tâche entière malgré un plafond de 5 USD dépassé par l'estimation
- Contexte : première estimation 1,81 à 5,43 USD (périmètre gonflé par `gen/`, `icons/`, `docs/`) ; l'humain a élargi les exclusions de `arbitrage.yaml` (nouvelle fourchette 0,44 à 1,33 USD) et refusé la découpe.
- Alternatives rejetées et pourquoi : découper la phase en deux (l'estimation était un artefact de mesure, la borne basse tenait sous le plafond).
- Conséquences : phase menée en une session sous sonnet ; `arbitrage.yaml` reste à la main de l'humain.

## 2026-09-24 — Lecture de l'espace par un module unique, sans chemin venu de la fenêtre
- Contexte : onglet Suivi en lecture seule (phase 2) ; risque de faire de l'interface une porte de lecture arbitraire.
- Alternatives rejetées et pourquoi : commande `lire_fichier(chemin)` (chemin contrôlé par la fenêtre) ; plugin `fs` de Tauri (permissions trop larges) ; analyse YAML par dépendance (analyseur minimal suffisant).
- Conséquences : `lire_suivi` sans paramètre, liste blanche et canonicalisation dans `suivi.rs`, refus de tout lien symbolique ; garde permanent contre les API d'écriture ; `ecriture.rs` reste la seule porte d'écriture.

## 2026-09-24 — `Referrer-Policy` par `<meta>` faute d'en-tête dans la configuration Tauri
- Contexte : audit V3.4.5 ; `app.security.headers` de Tauri 2.11 ne connaît pas `Referrer-Policy` (source de tauri-utils lue par un agent).
- Alternatives rejetées et pourquoi : ne rien poser (écart V3.4.5 ouvert) ; intercepter le protocole en Rust (surcoût pour un en-tête sans requête sortante).
- Conséquences : classé conforme avec réserve par l'auditeur ; lecture de V3.4.5 à trancher par l'humain (rapport de phase 2).

## 2026-09-24 — `jsdom` en devDependency pour tester l'assainissement
- Contexte : DOMPurify exige un DOM ; le test doit exécuter le vrai rendu, pas une copie.
- Alternatives rejetées et pourquoi : tester sans DOM (ne prouve rien) ; simuler DOMPurify (preuve fausse).
- Conséquences : dépendance hors liste approuvée du §3, absente de `dist/`, signalée dans le rapport pour confirmation.

## 2026-09-28 — `bundle.css` de Tableau Pixel repris avec son `@import` Google Fonts intact
- Contexte : phase 1 de l'app de maths (`projet/maths/`) ; le plan exige `tokens.css` et `bundle.css`
  identiques (empreinte SHA-256) à l'archive `tableau-pixel.zip` ; `bundle.css:2` contient
  `@import url("https://fonts.googleapis.com/...")`, alors que la CSP stricte du cahier interdit les
  domaines non maîtrisés.
- Alternatives rejetées et pourquoi : retirer la ligne (casse l'empreinte, contredit « repris tel
  quel ») ; assouplir la CSP pour autoriser fonts.googleapis.com (le cahier l'interdit explicitement).
- Conséquences : la CSP réelle (en-tête HTTP Netlify, `netlify.toml`) bloque cet `@import` sans perte
  fonctionnelle : `app/public/fonts.css` déclare localement les mêmes familles (Silkscreen, Pixelify
  Sans) via des `@font-face` vers des fichiers `woff2` servis par le site. Écart signalé en preuve
  (`projet/maths/app/docs/preuves/phase1/recherches.txt`), à revoir si Tableau Pixel publie une
  nouvelle version de `bundle.css`.

## 2026-09-28 — CSP réelle en en-tête HTTP Netlify, pas seulement en `<meta>`
- Contexte : phase 1 de l'app de maths ; contrairement à Tauri (BRAINIAC Console phase 2, en-têtes non
  configurables), Netlify sert de vrais en-têtes HTTP pour un site statique.
- Alternatives rejetées et pourquoi : CSP uniquement en `<meta>` dans `index.html` (la directive
  `frame-ancestors` y est ignorée par la spécification ; c'est la limite déjà rencontrée avec Tauri,
  qui ne s'applique pas ici).
- Conséquences : CSP complète (avec `frame-ancestors 'none'`), `X-Content-Type-Options`,
  `Referrer-Policy`, `X-Frame-Options` posés dans `[[headers]]` de `netlify.toml` ; la `<meta>` de
  `app/index.html` reste en défense en profondeur, sans `frame-ancestors`.

## 2026-09-28 — Délai de correction des dépendances vulnérables de `projet/maths/` : identique à `projet/brainiac-console/`
- Contexte : audit `pentest_config` du 2026-09-28 (V15.1.1, gravité moyenne) : aucune politique fixée
  pour ce dépôt. Le rapport de phase 1 (`humain/a_valider/2026-09-28_maths_phase1_rapport.md §5`)
  laissait la décision à l'humain, sans reconduire d'office celle de `brainiac-console`. L'humain a
  explicitement délégué cette décision le 2026-09-28 (« tranche sur la politique de délai »).
- Alternatives rejetées et pourquoi : inventer des délais différents sans motif propre à ce dépôt
  (aucune raison identifiée de traiter `projet/maths/` différemment de `projet/brainiac-console/` sur
  ce point) ; laisser la question ouverte malgré la délégation reçue.
- Conséquences : critique 7 j, élevée 30 j, moyenne 90 j, depuis la publication de l'avis — mêmes
  valeurs que la décision humaine du 2026-09-24 pour `brainiac-console`. Documenté dans
  `projet/maths/README.md`. Cette décision est mienne, prise sur délégation explicite ; elle reste
  révisable par l'humain à tout moment, comme toute entrée de ce fichier.

## 2026-09-28 — Moteur mathématique : fractions à entiers non bornés, saisie bornée
- Contexte : phase 2 de l'app de maths ; la saisie de l'utilisateur est une donnée hostile, et une
  puissance mal bornée (`((2^64)^64)^64`) ferait exploser la mémoire.
- Alternatives rejetées et pourquoi : `Rational64` (débordement silencieux ou panique sur des calculs
  légitimes comme `(x+1)^12` en un point `60/17`) ; aucune borne (déni de service par une seule saisie).
- Conséquences : `BigRational` ; bornes dans `moteur/src/analyse.rs` (200 caractères, profondeur 32,
  exposant entier littéral ≤ 64) et `moteur/src/expr.rs` (4096 bits par numérateur ou dénominateur,
  contrôlés avant chaque puissance). Dépendances directes `num-bigint`, `num-integer`, `num-traits`
  en plus de `num-rational` (déjà transitives, même famille, sans web) : écart assumé au critère
  « seule `num-rational` » de la tâche, dont l'objet était l'absence de dépendance web.

## 2026-09-28 — Équivalence par points pseudo-aléatoires déterministes, sans crate `rand`
- Contexte : le cahier demande un test d'équivalence « par évaluation en points aléatoires ».
- Alternatives rejetées et pourquoi : `rand` (dépendance de plus, résultats non reproductibles d'une
  exécution à l'autre, donc des tests instables) ; calcul formel (hors périmètre du MVP).
- Conséquences : xorshift64 à graine fixe dans `moteur/src/equivalence.rs`, 24 points rationnels
  concordants exigés (0, 1, -1, 2 puis `n/d`, `n` ∈ [-60, 60], `d` ∈ [1, 17]), points non définis
  ignorés. Exact pour les polynômes de degré < 24 ; `x/x` et `1` sont tenus pour équivalents (domaine
  non examiné). Limites à revoir si le contenu dépasse le MVP.

## 2026-09-28 — Forme simplifiée : tout sous-calcul sans `x` doit être effectué
- Contexte : critère « `6/8` → juste mais à simplifier » ; aucune définition générale dans le cahier.
- Alternatives rejetées et pourquoi : forme normale développée (refuserait `2(x+1)`, que le cahier
  donne pour juste) ; comparaison textuelle à la réponse attendue (fragile aux espaces et à l'ordre).
- Conséquences : `moteur/src/forme.rs` : littéraux canoniques (entier, décimal, fraction irréductible
  de dénominateur > 1) et neutres inutiles refusés (`x*1`, `x+0`…). Une équation juste mais non
  résolue (`2x = -4` pour `x = -2`) est « à simplifier ». Factorisé et développé ne sont pas
  distingués : à préciser par exercice en phase 5 si besoin.

## 2026-09-28 — Moteur : budget de calcul par expression, 1024 bits par nombre
- Contexte : relecture (écart 3) et audit (E-03, E-05) de la phase 2 : des saisies valides de moins
  de 200 caractères coûtaient jusqu'à 430 ms (debug) et 52,9 ms (release) ; les 50 ms du cahier
  n'étaient garanties par aucune borne.
- Alternatives rejetées et pourquoi : limiter le temps par horloge (non déterministe, et
  `Instant` n'est pas disponible tel quel en WebAssembly) ; réduire seulement la longueur de saisie
  (ne borne pas le coût par caractère).
- Conséquences : `BITS_MAX` passe de 4096 à 1024 ; budget de 300 000 unités par expression
  (`n²/64 + 1` par opération sur `n` bits), un budget par côté de la comparaison, erreur
  `CalculTropLong`. Pire cas connu : 26 ms (debug), 2,8 ms (release), natif. Toute erreur de calcul
  est imputée au côté qui l'a provoquée : la référence donne `ErreurReference`, pas un reproche à
  l'élève. Linéarité des équations contrôlée aux 24 points de l'équivalence au lieu de 8 (E-02).

## 2026-09-28 — Forme simplifiée réécrite ; forme développée ou factorisée exigible (E-01)
- Contexte : relecture, écarts 1 et 2 (`-(-3/4)`, `2x+1+1`, `2x+3x`, `x+(-3)`, `-1x` jugés
  simplifiés) ; audit E-01 (recopier l'énoncé d'un « Développe » donnait « Juste »). Choix de
  l'humain : régler E-01 dès la phase 2.
- Alternatives rejetées et pourquoi : garder l'analyse arbre par arbre (l'associativité à gauche
  cache les calculs constants) ; traiter la mauvaise forme comme « à simplifier » (message trompeur :
  recopier `(x+1)^2` n'est pas une réponse « presque juste »).
- Conséquences : sommes et produits aplatis dans `moteur/src/forme.rs` (un terme constant, pas de
  termes de même degré, signe seulement en tête, facteur constant ≠ 0, 1, -1). Nouveau
  `verifier_forme(…, FormeAttendue)` et verdict `FormeIncorrecte` ; `verifier` inchangé
  (forme quelconque). Limites : `0,50` passe ; factorisation complète non vérifiée ;
  le champ correspondant du format d'exercice JSON est à ajouter en phase 5.

## 2026-09-28 — Forme simplifiée : « jamais de sanction à tort » (choix de l'humain)
- Contexte : seconde relecture de la phase 2 NON CONFORME ; la réécriture de `forme.rs` a introduit
  des régressions (`-x(x+1)`, `-1/x` jugés « à simplifier ») tout en laissant passer d'autres calculs
  non faits (`6x/8`, `-(-2x)`). Les règles syntaxiques ajoutées au cas par cas ne convergent pas.
- Alternatives rejetées et pourquoi : forme normale mathématique complète (plus longue, reportée) ;
  clore en l'état (des réponses justes seraient sanctionnées, contraire au cahier : « une erreur
  déclenche une aide, jamais une sanction »).
- Conséquences : garantie exacte de la forme simplifiée pour les valeurs numériques et les équations
  résolues (le cœur du MVP) ; pour les expressions en `x`, seules les règles sûres sont gardées, et
  dans le doute la réponse est jugée juste. R1, R2 et l'imputation de la division par zéro de la
  référence sont corrigés. Le seuil de 50 ms s'applique au build release, budget réduit pour garder
  une marge en WebAssembly. Troisième relecture avant clôture.

## 2026-09-29 — Forme simplifiée en règles sûres ; budget 150 000, 48 tirages, constantes en un point
- Contexte : reprise de la phase 2 selon la décision « jamais de sanction à tort » (2026-09-28).
- Alternatives rejetées et pourquoi : liste blanche de formes simplifiées (ce que faisait la version
  précédente : tout ce qui n'y figure pas est sanctionné, d'où R1 et R2) ; forme normale complète
  (reportée). Budget à 100 000 : le cas réaliste `-14(x+1/13)^32` restait jugé, mais le gain de
  temps était faible, le pire cas venant des 96 tirages et non du budget.
- Conséquences : `forme.rs` ne sanctionne une expression en `x` que sur une liste de règles sûres
  (documentée en tête du module) ; `x/2*3`, `(x+1)(x+1)`, `(2x)^2`, `2*(-x)` sont tenues pour
  simplifiées. « Factorise » : un signe ou ±1 seul autour d'une somme exige une somme affine
  primitive de coefficient positif. Budget 150 000 et 48 tirages : pire cas 9,5 ms en release
  natif ; `-14(x+1/13)^64` donne désormais « calcul trop long » (degré hors du MVP). Une
  comparaison sans `x` se fait en un point. Limite connue : `resoudre` évalue encore une constante
  lourde en 28 points (`x = 1024^64`), borné par le budget.

## 2026-09-29 — « Factorise » : durcissement minimal, factorisation complète laissée à l'humain
- Contexte : clôture de la phase 2 ; l'audit maintient N-01 (moyenne) : `1/2(2x^2+4x+2)`,
  `2(x^2/2+x+1/2)`, `(x+1)/(1+x)(x^2+2x+1)` passent pour factorisées.
- Alternatives rejetées et pourquoi : règle de degré recommandée par l'audit (facteur somme de degré
  ≥ 1 et < degré de l'expression), non appliquée à la clôture : elle change la définition de la forme
  factorisée et chaque règle ajoutée en fin de cycle a jusqu'ici introduit une régression.
- Conséquences : refus seulement des enveloppes signe/±1, des facteurs ±1 et des sommes à exposant
  négatif ; quotient par une constante admis. La règle de degré est soumise à l'humain dans le
  rapport de phase 2.
