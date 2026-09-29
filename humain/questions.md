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
