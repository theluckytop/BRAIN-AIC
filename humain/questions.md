# Questions de l'agent
Ajout uniquement, du plus ancien au plus récent. L'agent n'efface rien, tu réponds sous la question.

Format :
```
## AAAA-MM-JJ hh:mm — tâche concernée
Question : …
Options : A … (recommandée, parce que …) / B …
En attendant : je poursuis sur …
Réponse : 
```
---

## 2026-09-23 22:15 — brainiac_console
Question : la phase 0 exige de vérifier la version majeure actuelle de Tauri et sa documentation, ainsi que la documentation du flux JSON de Claude Code. Cela demande un accès réseau en lecture (tauri.app, crates.io, npmjs.com, documentation Anthropic). Tu l'autorises ?
Options : A lecture web limitée à ces sources officielles, sans rien télécharger ni installer (recommandée, parce que la tâche exige une vérification et non une supposition) / B aucun accès : la proposition de phase 0 s'appuiera sur `claude --help` et sur les versions locales, et les points non vérifiés y seront signalés
En attendant : je poursuis sur les vérifications locales (versions installées, `claude --help`, question 4.3).
Réponse : 
(Consigné par l'agent, 2026-09-23 23:01) Réponse donnée en session : « A, accès web limité aux sources officielles ». Utilisée en lecture seule : crates.io, registry.npmjs.org, v2.tauri.app, code.claude.com.

## 2026-09-24 — brainiac_console_phase1 (clôture)
Question : le budget de session (90 min) est épuisé en pleine `/cloture` de la phase 1. Comment la termines-tu ? Et que faire de `travail/brouillons/`, qui contient les preuves citées dans le rapport ?
Options : A nouvelle session (`/model sonnet` conseillé) qui relance `/cloture` ; preuves déplacées dans `quarantaine/2026-09-24_phase1_preuves/` avant vidage (recommandée : la clôture reste complète et les preuves citées restent accessibles) / B clôture acceptée en l'état, sur le rapport déjà déposé ; brouillons laissés en place
En attendant : rien, la session est bloquée par le hook.
Réponse : A, avec un changement (humain, 2026-09-24). Nouvelle session sous sonnet qui termine /cloture : relecture après 9805a10, audit différentiel de src/App.svelte et scripts/contraste.mjs, ligne d'estimation. Les preuves citées dans le rapport ne vont PAS dans quarantaine/ (réservée aux échecs, AGENTS.md) : copie-les dans projet/brainiac-console/docs/preuves/phase1/ et commite-les avec le code. Ensuite, tu as mon accord pour vider travail/brouillons/ (sauf .gitkeep), y compris ff/ et apercu/.

## 2026-09-24 01:01 — brainiac_console_phase2 (budget)
Question : l'estimateur donnait 1,81 à 5,43 USD en sonnet pour la phase 2 (plafond de 5,00 USD dépassé par la borne haute) et demandait de découper la tâche. Tu la découpes ? (Question annoncée dans mon message précédent, consignée ici seulement après ta réponse.)
Options : A garder la tâche entière (recommandée, parce que la borne basse est sous le plafond et que le périmètre mesuré incluait des fichiers générés) / B découper en deux tâches
En attendant : je poursuis sur le plan et l'état de la phase 2.
Réponse : A (humain, 2026-09-24). Tâche entière, pas de découpe. L'estimation était gonflée par src-tauri/gen/, src-tauri/icons/ et docs/, ajoutés aux exclusions de ressources/arbitrage.yaml. Nouvelle estimation : 0,44 à 1,33 USD en sonnet. Continuer la phase 2 avec l'arrêt à 60 min.
(Consigné par l'agent, 2026-09-24 01:01) Relance de l'estimateur : périmètre 27 fichiers (203 ko), sonnet 0,442 à 1,327 USD, opus 0,885 à 2,654 USD, plafond de 5,00 USD tenu. Aucune bascule à proposer.

## 2026-09-24 01:25 — brainiac_console_phase2 (délais de correction)
Question : ta décision du 2026-09-24 fixe les délais (critique 7 j, élevée 30 j, moyenne 90 j) mais pas leur point de départ. Il court depuis quand ? `docs/dependances.md` le laisse « à préciser ».
Options : A depuis la publication de l'avis (recommandée, parce que c'est mesurable et indépendant de nos audits) / B depuis la date où un audit le signale chez nous
En attendant : je poursuis la phase 2 ; le document reste marqué « à préciser ».
Réponse : A (humain, 2026-09-24). Le délai part de la publication de l'avis de sécurité.
(Consigné par l'agent, 2026-09-24) `docs/dependances.md` mis à jour dans ce sens.

## 2026-09-28 22:05 — projet maths (humain/dossier-projet-maths/), avant toute tâche
Question : tu demandes de réaliser le projet décrit dans `humain/dossier-projet-maths/dossier/Cahier des charges.md`. Aucun fichier de tâche n'existe dans `humain/taches/`. Je prépare une proposition de phase 0 ; il me faut le périmètre, la pile et l'accès réseau pour la vérifier.
Options : périmètre A vague 1 seule (recommandée, seule vague engagée par le cahier) / B vagues 1 et 2 / C tout le cahier ; pile A Leptos CSR + Trunk (recommandée, choix du cahier) / B hybride Vite + TS + moteur Rust ; réseau A lecture web des sources officielles, sans rien installer (recommandée) / B aucun accès
En attendant : lecture locale du cahier et de `tableau-pixel.zip`.
Réponse : 
(Consigné par l'agent, 2026-09-28 22:05) Réponse donnée en session : périmètre « tout le cahier » (vagues 1 à 3) ; pile Leptos CSR + Trunk ; réseau en lecture web officielle, sans téléchargement ni installation.

## 2026-09-28 23:53 — maths_phase2 (suite après la seconde relecture NON CONFORME)
Question : la seconde relecture trouve 2 régressions (réponses justes jugées « à simplifier ») et des règles de forme encore contournables ; un 3e cycle ne tient pas avant la limite de 60 min. Comment terminer la phase 2 ?
Options : A principe « jamais de sanction à tort » en nouvelle session (recommandée, parce que le cahier interdit de sanctionner une réponse juste et que les règles au cas par cas ne convergent pas) / B forme normale mathématique (plus juste, plus long) / C clore en l'état
En attendant : état consigné, arrêt de la session.
Réponse : 
(Consigné par l'agent, 2026-09-28 23:54) Réponse donnée en session : A.

## 2026-09-29 — maths_phase3 (budget et palier)
Question : `estimer.py` classe la phase 3 en palier grand (mot-clé « securite », présent dans mes exigences reportées E-04 / ErreurReference) : 2,00 à 5,99 USD en opus, 1,00 à 2,99 USD en sonnet (jugé inadapté). La borne haute dépasse le plafond de 5,00 USD. Que fais-tu ?
Options : A découper en deux tâches, 3a composants et 3b liaison au moteur + mesure WASM (recommandée : chaque moitié est sous le plafond et le classement « sécurité » ne concerne que 3b) / B garder la tâche entière en sonnet, avec bascule en opus seulement sur échec constaté (la borne basse est sous le plafond, le périmètre mesuré inclut BRAINIAC Console) / C garder la tâche entière en opus
En attendant : lecture du cahier et des `preview.html` de Tableau Pixel, sans écriture de code.
Réponse : 
(Consigné par l'agent, 2026-09-29) Réponse donnée en session : B. Tâche entière en sonnet, bascule en opus seulement sur échec constaté ; plafond de 5,00 USD par tâche.

## 2026-09-29 — maths_phase3 (l'app est blanche sous la CSP ; suite de session)
Question : l'observation en Firefox réel (première de l'app) montre que **la page reste vide** : le `<script type="module">` inline que Trunk injecte pour démarrer le WASM est bloqué par la CSP (`script-src 'self' 'wasm-unsafe-eval'`, sans `'unsafe-inline'`), dans `app/index.html` (meta) et dans `netlify.toml` (en-tête). Sans la meta, l'app démarre. La phase 1 avait validé la CSP par lecture et par `trunk build`, jamais dans un navigateur. Que fais-tu ?
Options : A hash sha256 du script inline dans `script-src` (recommandée : CSP stricte conservée ; le hash change à chaque build, il faut le calculer après `trunk build`, à automatiser) / B configurer Trunk pour sortir le script en fichier externe (`data-no-minify`/pas d'injection inline, à vérifier dans Trunk 0.21.14) : CSP inchangée / C ajouter `'unsafe-inline'` à `script-src` (déconseillée : annule l'intérêt de la CSP). Corriger `index.html` et `netlify.toml` est une modification hors périmètre de la tâche de phase 3, d'où la question.
En attendant : rien (session bloquée par le hook, 92 min pour 90).
Réponse : 
(Consigné par l'agent, 2026-09-29) Réponse donnée en session : A. Hash sha256 du script d'amorçage inline dans `script-src`. À appliquer en nouvelle session : calculer le hash après chaque `trunk build --release` (script sans installation), l'injecter dans `index.html` (meta) et `netlify.toml` (en-tête), puis prouver par un lancement réel (WebDriver headless : la page rend, texte lu, 0 violation CSP en console). Le hash dépend du script exact que Trunk émet : à recalculer à chaque build, avec un test qui échoue si l'en-tête et le build divergent.

## 2026-09-29 15:30 — maths_phase3 (escalade : 2 relectures NON CONFORME ; que fais-tu ?)
Question : la 1re relecture (`26dbe0f`) et la 2e (`6519fce`) rendent NON CONFORME. Tous les écarts de la 1re sont traités ; la 2e ne retient plus que la preuve clavier (Entrée sur un bouton ne produit pas de `click` après des Tab envoyés par le pilote WebDriver) et des imprécisions de preuves, corrigées depuis au commit `34cad26` (page statique sans l'app : 6/6 échecs après Tab préalables, 0/6 sans ; 3 essais sans rechargement archivés ; cause Firefox 149 ou geckodriver, non tranchée). Une 3e relecture dépasse le maximum de 2 avant escalade.
Options : A accepter la limite (24/24 avec rechargement, 15/24 sans, défaut reproduit hors app) et clore la phase, avec un test sur Firefox à écran de ta part (recommandée : le défaut se reproduit sans l'app, aucun défaut de l'app n'est établi) / B une 3e relecture ciblée sur `34cad26` avant clôture / C tester toi-même avec un vrai clavier (Tab puis Entrée sur un bouton de la page de démo servie sous la CSP) avant de décider
En attendant : rapport de phase déposé dans `humain/a_valider/`, `etat.md` à jour, aucune autre action.
Réponse : 
(Consigné par l'agent, 2026-09-29) Réponse donnée en session : A. Clore la phase 3 avec la réserve sur la preuve clavier. Bascule en opus demandée par l'humain (`/model opus`), hors échec constaté. `/cloture` non lancée : le garde-fou a arrêté la session (189 min > 90, attente de l'humain comprise) ; à faire en nouvelle session.

## 2026-09-29 — maths : réorientation du produit (demande de l'humain après ouverture de l'app)
Question : la phase 3 livre une galerie de composants ; l'humain veut autre chose. Voir `humain/a_valider/2026-09-29_maths_reorientation.md` (plan corrigé + 6 décisions bloquantes : clé API et proxy, vérification des réponses, corpus officiel, moteur, coût, vie privée). Rien n'est lancé tant que l'humain n'a pas tranché.
En attendant : phase 4 d'origine (KaTeX + MathLive) **suspendue** ; son brouillon `2026-09-29_maths_phase4_tache.md` est caduc.
Réponse : 
(Consigné par l'agent, 2026-09-29) Demande de l'humain, en session : le whiteboard est l'entrée principale ; énoncé dans un bandeau (ConsigneCard) juste au-dessus ; la réponse (le dessin) est soumise à un LLM (Haiku) qui explique pourquoi c'est juste ou faux ; l'explication s'affiche dans un second onglet rattaché au whiteboard, qui est un chatbot ; plus de bloc « Exercices (moteur relié) » ; contenu fondé sur les programmes officiels (Éducation nationale, universitaires) que Haiku vulgarise ; conserver AppShell et ConsigneCard, le reste évolue selon le besoin.

## 2026-09-29 — maths : quelles API pour les cours, et quand les appeler ?
Question : tu veux que les cours viennent d'API. Je ne connais pas d'API officielle unique qui serve les programmes de l'Éducation nationale ou des universités en contenu de cours ; je n'ai rien vérifié en ligne. Quelles API vises-tu, et les appelle-t-on à l'exécution ou en amont ?
Options : A **en amont** : un script récupère les cours via les API choisies et les range dans un corpus versionné, cité, que l'app lit en local (recommandée : fonctionne hors ligne, sources figées et relisibles, aucune ouverture de CSP vers ces API) / B **à l'exécution** : l'app interroge les API à chaque séance (contenu toujours à jour, mais CORS, disponibilité, CSP `connect-src` à ouvrir, et rien ne garantit ce que Haiku citera).
En attendant : aucun accès réseau, aucun code.
Réponse : 

## 2026-09-29 — maths : évolution responsivité + clé API persistante (session bloquée avant tout travail)
Question : le garde-fou (103 min > 90, temps d'attente compris) a refusé dès le premier appel Bash de cette évolution ; rien n'a été fait. Tu relances la même demande (A à D) dans une nouvelle session ?
Options : A nouvelle session, palier sonnet, même demande, avec démarrage direct sur les fichiers listés (recommandée : compteur remis à zéro, aucun état intermédiaire à réconcilier) / B découper : d'abord la clé API persistante (A), puis la responsivité et l'outil DÉPLACER (B) dans une seconde session (la moitié la plus longue est la vérification Firefox ; utile si la session risque de dépasser 60 min)
En attendant : rien, `etat.md` à jour, aucun fichier de `projet/maths` touché.
Réponse : 

## 2026-09-29 — maths : parcours par niveau scolaire, alimenté par des API de cours (demande de l'humain, session arrêtée par le garde-fou, 267 min > 90)
Demande (reformulée) : depuis le menu ☰ → « Parcours », une nouvelle fenêtre s'ouvre ; on y sélectionne un niveau scolaire précis, en fonction des sources (programmes officiels, Éducation nationale et universitaires) ; l'app construit un parcours d'apprentissage pour ce niveau à partir des cours récupérés par API. Rien n'a été fait : brouillon de plan non écrit (hook), à refaire en nouvelle session.
Question : trois points bloquent. (1) **Quelles API ?** Déjà posée plus haut (« quelles API pour les cours »), sans réponse : je ne connais pas d'API officielle unique qui serve le contenu de cours ; je propose un repérage en lecture seule des sources existantes (accord de lecture web de la phase 0), qui te reviendrait en liste comparée (couverture, licence, format) avant tout code. (2) **Quand les appeler ?** Recommandé : en amont, script → corpus versionné et cité, lu en local. (3) **« Nouvelle fenêtre » et niveaux** : fenêtre modale dans l'app (recommandé : marche sur téléphone, accessible) ou vrai nouvel onglet ? Liste de niveaux au départ (ex. CM2 à Terminale, puis L1) ?
Options : A repérage des API en nouvelle session (sonnet), puis tâche déposée par toi (recommandée : sans source réelle et sans licence vérifiée, rien à intégrer) / B tu fournis toi-même les API et les niveaux, je pars directement sur la fenêtre « Parcours » et le corpus.
En attendant : rien ; plan proposé pour la reprise : 1 repérage des API, 2 script → corpus avec source et licence, 3 menu ☰ → Parcours (modale, clavier, téléphone), 4 parcours par niveau qui change les énoncés, 5 Haiku reçoit l'extrait de cours et cite la source.
Réponse : 

## 2026-09-29 — maths : résultat du repérage des API de cours (lecture seule)
Repérage fait à ta demande (recherche web + 2 appels de l'API publique data.education.gouv.fr ; rien téléchargé, rien écrit dans le dépôt). Se rattache à la question « quelles API pour les cours » ci-dessus.
- **Programmes officiels (Éducation nationale)** : API publique Explore v2.1, sans clé, Licence Ouverte 2.0, 5 000 appels/jour/IP. Jeux `fr-en-programmes-enseignement-2nd-degre` (688 lignes), `fr-en-programmes-enseignement-premier-degre`, `fr-en-complements-programmes-second-degre` (14 lignes : attendus de fin d'année et repères annuels de progression, dont « Mathématiques », par niveau). Vérifié : **métadonnées et liens seulement** (niveau, discipline, arrêté, lien Légifrance, lien vers un **PDF**), **pas le texte** des programmes. Utile pour la liste des niveaux et pour citer la source officielle ; le contenu exige de lire les PDF. Ontologies RDF/XML des programmes (surtout second degré) signalées, non vérifiées.
- **Contenu de cours réutilisable** : **Wikiversité / Wikibooks (API MediaWiki)**, CC BY-SA, cours de maths lycée et faculté, non officiel. **Coopmaths / MathALÉA** : référentiel Niveaux > Thèmes > Sous-thèmes et exercices de la 6e à la Terminale, code AGPL, documents CC BY-SA, association d'enseignants, non officiel ; pas d'API confirmée (dépôt GitHub). Supérieur : portail data.enseignementsup-recherche.gouv.fr (API), contenu de cours non vérifié ; UNT et MIT OpenCourseWare cités, pas d'API de cours confirmée.
- **Non trouvé** : aucune API officielle qui serve le texte des programmes ou des cours par niveau. Lumni, Canopé, Éduscol : ressources en ligne, pas d'API repérée.
- **Conséquence** : la liste des niveaux (menu ☰ → Parcours) peut venir des jeux officiels ; le texte de cours vient d'ailleurs (Wikiversité, Coopmaths) ou des PDF officiels, licence citée. Recommandé : corpus constitué en amont par script, niveau par niveau, source officielle citée en plus du cours.
Réponse : 
(Consigné par l'agent, 2026-09-29) Réponse donnée en session : le mélange convient (niveaux issus des jeux officiels data.education.gouv.fr ; contenu de cours issu de Wikiversité/Wikibooks et Coopmaths, source officielle et licence citées) ; fenêtre « Parcours » = **modale dans l'app** ; niveaux de départ : **CM2 à Terminale** (CM2, 6e, 5e, 4e, 3e, seconde, première, terminale). Corpus constitué en amont par script (recommandation non contredite). Reste : l'humain dépose la tâche dans `humain/taches/` (l'agent ne peut pas écrire dans `taches/`) et ajoute la ligne dans `validations.md` (accord réseau : API data.education.gouv.fr, API MediaWiki Wikiversité/Wikibooks, dépôt GitHub Coopmaths, lecture seule, à la construction du corpus).

## 2026-09-29 22:50 — Consignation : réponse à « évolution responsivité + clé API persistante »
(Consigné par l'agent, 2026-09-29) Réponse donnée en session : **A**, nouvelle session (palier sonnet) pour la
responsivité et « les changements apportés dans le cahier des charges ». Lecture de l'agent : la demande A à D
(clé `localStorage` avec RENOUVELER/EFFACER, responsivité, outil DÉPLACER, captures Firefox) et la réorientation du
produit (`a_valider/2026-09-29_maths_reorientation.md`). Note : `memoire/contexte/cahier_des_charges*.md` n'a pas
changé depuis le 2026-09-23 ; si un autre document est visé, le préciser au lancement de la session.

## 2026-09-29 — Consignation : ordre des travaux maths
(Consigné par l'agent, 2026-09-29) Décision de l'humain, en session : **parcours avant la responsivité**. Ordre :
1 `maths_corpus` (en cours) → 2 `maths_parcours` (dès le corpus approuvé dans `validations.md`) → 3 responsivité,
clé API persistante et changements du cahier des charges (nouvelle session, sonnet). Écart assumé au contexte de
`maths_parcours.md` (« la responsivité et la clé API persistante auront été faites avant ») : le parcours sera bâti
sur l'app de la phase 3bis, clé saisie à chaque onglet.

## 2026-09-29 23:45 — maths_corpus : corpus maigre, quelle suite ?
Question : le corpus existe (8 niveaux sourcés, 51 notions, 245 Ko) mais il est maigre. Le dépôt GitHub mathalea/mathalea
est un état figé de 2023 **sans le référentiel Niveaux > Thèmes** : celui-ci vit sur `forge.aeif.fr`, hors de ton accord
réseau. Les notions viennent donc des pages « Mathématiques en <classe> » de Wikiversité : Seconde 1 notion, CM2 2,
Terminale 0 exercice ; extraits utiles 15/21 au contrôle (`projet/maths/corpus/docs/pertinence.md`).
Options : A étendre l'accord réseau (lecture seule) à `forge.aeif.fr` (dépôt Coopmaths actuel) pour reprendre le
référentiel officiel des notions de la 6e à la Terminale, puis reconstruire (recommandée : ordre des notions calé sur
les programmes, Seconde et Terminale comblées) / B garder ce corpus, ajouter le filtre des extraits faibles, et lancer
`maths_parcours` tel quel (plus rapide, parcours pauvre en Seconde et CM2) / C compléter à la main la liste des notions
par niveau (depuis les « Attendus » officiels), l'agent reprenant ensuite extraits et exercices.
En attendant : rien de commité ; filtre des extraits faibles, relecture et rapport à faire en nouvelle session.
Réponse : 
(Consigné par l'agent, 2026-09-30 00:05) Réponse donnée en session à « corpus maigre » : **A**. L'humain annonce ajouter
`forge.aeif.fr` dans `validations.md` ; à 00:05 la ligne n'y est pas encore. Aucun accès à forge.aeif.fr tant qu'elle
n'y figure pas.

## 2026-09-30 — maths_corpus : forge.aeif.fr injoignable depuis la session
Question : l'accord du 2026-09-30 est bien dans `validations.md`, mais `forge.aeif.fr` ne se résout pas depuis le bac à
sable de Claude Code (`git clone` : « Could not resolve host », `curl` code 6, `getent hosts` vide), alors que github.com
et fr.wikiversity.org passent. Cause non établie : filtre d'hôtes du bac à sable système ou DNS. Aucun contournement fait.
Options : A tu ajoutes `forge.aeif.fr` aux hôtes autorisés du bac à sable (ou tu vérifies `getent hosts forge.aeif.fr`
dans ton terminal via `! getent hosts forge.aeif.fr`), puis je relance l'étape 5b (recommandée : garde le bac à sable
intact) / B tu m'autorises explicitement, pour cette seule commande de clonage en lecture, à lever le bac à sable /
C tu clones toi-même `https://forge.aeif.fr/coopmaths/mathalea` (superficiel) dans `travail/brouillons/mathalea-forge/`
/ D on renonce au référentiel : corpus actuel (51 notions) filtré, puis étape 6.
En attendant : filtre des extraits faibles fait (5c) ; je refais le contrôle de pertinence sur la nouvelle sortie.
Réponse : 
(Consigné par l'agent, 2026-09-30) Diagnostic : `getent hosts forge.aeif.fr` est vide aussi dans le terminal de l'humain :
le nom **n'existe plus** (pointeur du README gelé de 2023), ce n'est pas le bac à sable. `forge.apps.education.fr`
(forge de l'Éducation nationale) se résout, y compris depuis le bac à sable. Lieu probable du dépôt Coopmaths actuel
(`forge.apps.education.fr/coopmaths/mathalea`), non vérifié, aucun accès fait. Les options A à C deviennent :
A' ajouter à `validations.md` l'accord lecture seule pour `forge.apps.education.fr` (même périmètre que la ligne du
2026-09-30), puis je vérifie l'adresse, clone superficiel et reprends 5b (recommandée) / D renoncer au référentiel.

## 2026-09-30 — maths_corpus : notions complètes, extraits de cours rares
Question : avec le référentiel Coopmaths (forge.apps.education.fr), le corpus passe à **166 notions** ordonnées selon
les programmes et 841 exercices rattachés (titres + liens), 8 niveaux couverts (commit `3c26fe9` dans `projet/maths`).
Mais **26 notions seulement ont un extrait de cours** (CM2 0/20, Seconde 0/24) : l'appariement par titre avec les
leçons Wikiversité rate la plupart des thèmes, et quelques-uns tombent sur un chapitre voisin (Terminale).
Options : A une passe de plus : pour chaque notion sans extrait, recherche dans l'API MediaWiki Wikiversité (déjà dans
l'accord, ~300 appels, ~6 min), filtre 5c, puis contrôle de pertinence ; coût estimé ≈ 1 USD de plus, plafond 5 USD
à surveiller (recommandée si les extraits doivent servir au parcours) / B livrer tel quel : notions et exercices
complets, extraits partiels et marqués ; le cours manquant sera produit ailleurs (à trancher dans `maths_parcours`) /
C garder les notions v2 mais retirer les extraits mal appariés, puis livrer.
En attendant : relecture `verificateur` de la v2 telle quelle.
Réponse : 
(Consigné par l'agent, 2026-09-30 01:17) Réponse donnée en session à « notions complètes, extraits rares » : **A**
(passe de recherche Wikiversité pour les notions sans extrait). Reportée en nouvelle session : 63 min écoulées sur 90.

## 2026-09-30 — maths_corpus : la recherche Wikiversité ne comble pas les trous
Question : l'étape 5d (commit `f2ba25e`) fait passer les extraits de cours de 26 à **28 sur 166** seulement (CM2 0/20,
Seconde 1/24, et cet extrait est douteux) ; 9 extraits sur 28 sont marqués douteux. Le moteur de recherche de
Wikiversité est global : « un mot commun » donnait ~20 appariements hors sujet sur 27 (« Espace » → « Course à
l'espace »). Wikiversité n'a tout simplement pas de leçons pour la plupart des thèmes de CM2 à Seconde.
Écart à signaler : ≈ 510 appels Wikiversité au lieu de ~350 prévus au plan (relance qui rejouait le cache ; corrigé,
leçon écrite). Hôte autorisé seulement, lecture seule.
Options : A clore le corpus ainsi (notions + exercices complets, 28 extraits dont 9 douteux, trous marqués), étape 6,
et traiter le cours manquant dans `maths_parcours` (par ex. fiches rédigées marquées GÉNÉRÉE, relues par toi)
(recommandée) / B chercher une autre source ouverte de cours par niveau (à nommer, nouvel accord réseau) /
C finir les recherches restantes sur Wikiversité (~330 appels, gain probablement quasi nul).
En attendant : rien d'autre sur le corpus ; relecture `verificateur` de la v2 possible sans décision.
Réponse : 
(Consigné par l'agent, 2026-09-30 02:45) Réponse donnée en session : **A** — clore le corpus tel quel (trous marqués), étape 6 ; cours manquant traité dans `maths_parcours`.
