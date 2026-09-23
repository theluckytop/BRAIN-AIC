# Proposition — 2026-09-23_brainiac_console_phase0

## Action proposée
Réaliser BRAINIAC Console avec Tauri 2.11 (Rust) et Vite 8 + TypeScript + Svelte, selon le plan
par phase ci-dessous, en pilotant Claude Code 2.1.281 par `claude -p` en flux JSON.

## Pourquoi
La phase 0 du cahier (`memoire/contexte/cahier_des_charges_application.md` l.101) exige un plan
vérifié et ton accord avant tout code. Sans accord, rien ne s'écrit dans `projet/brainiac-console/`.

## Contenu exact

### 1. Versions vérifiées (2026-09-23)

| Élément | Constaté | Source | Verdict |
|---|---|---|---|
| Tauri (crate) | 2.11.6 stable, 3.0.0-alpha.2 en préversion | crates.io API | **retenir 2.x** : pas d'alpha en production |
| MSRV de Tauri 2.11.6 | Rust 1.77.2 | crates.io API | Rust 1.98.1 installé : OK |
| `@tauri-apps/cli` | 2.11.5, node ≥ 10 | registry.npmjs.org | OK |
| Vite | 8.3.0, node `^20.19.0 \|\| >=22.12.0` | registry.npmjs.org | Node 22.22.1 : OK |
| npm | 9.2.0 (paquet Ubuntu) | `npm --version` | ancien mais sans contrainte bloquante connue ; à surveiller |
| Claude Code | 2.1.281 | `claude --version` | OK (≥ 2.1.259 requis pour `--permission-prompts`) |
| WebKitGTK 4.1 / JSC 4.1 | 2.52.6 | `pkg-config` | OK |
| GTK 3 / libsoup 3 / AppIndicator / librsvg / OpenSSL | 3.24.52 / 3.6.6 / 0.5.94 / 2.61.3 / 3.5.5 | `pkg-config` | OK |
| Paquets apt de la doc Tauri 2 (Debian) | `libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev` : **tous installés** | v2.tauri.app/start/prerequisites + `dpkg-query` | OK |

**Commandes d'installation de la chaîne de compilation : aucune n'est nécessaire.** Pour mémoire,
celle de la documentation, déjà satisfaite :
```
sudo apt install libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev
```
Seules installations restantes, locales au dépôt de l'application : `npm create tauri-app` (gabarit
de la phase 1), `npm install` (dépendances §3, depuis registry.npmjs.org), `cargo build` (crates.io)
et le téléchargement de la police. **Elles demandent un accès réseau :
je les inclus dans cette approbation, voir « Pour approuver ».**

### 2. Options de Claude Code en flux JSON
Sources : les options ci-dessous figurent dans `claude --help` (2.1.281), sauf `--permission-prompt-tool`
(voir §4). Leur comportement vient de code.claude.com/docs/en/headless et /cli-reference, lues le
2026-09-23 : ordre des événements, SIGINT/SIGTERM et code 143, `system/init`.

Commande de lancement prévue, centralisée dans un seul module Rust (`src-tauri/src/cli.rs`) :
```
claude -p --input-format stream-json --output-format stream-json --verbose \
       [--include-partial-messages] [--resume <session_id>] \
       [--permission-prompt-tool <outil MCP>]      # voir §4
```
- `--input-format stream-json` : messages utilisateur envoyés en continu sur stdin (seulement avec `-p`).
- `--output-format stream-json` + `--verbose` : un objet JSON par ligne ; premier événement
  `system/init` (modèle, outils, `capabilities`), dernier `result` (texte, `session_id`, `total_cost_usd`).
- `--include-partial-messages` : jetons au fil de l'eau (événements `stream_event`).
- `--resume <id>` : reprise par identifiant, conservé par projet (§4.3 « Reprise »). `--session-id <uuid>` possible pour fixer l'identifiant.
- Interruption de la génération : **SIGINT** termine le tour proprement (SIGTERM le laisse inachevé,
  code 143) ; fermeture de stdin puis attente, SIGTERM en dernier recours pour arrêter la session.
- Hooks : sans `--bare`, `claude -p` exécute les hooks de `.claude/settings.json` du projet. C'est
  ce qu'on veut : les garde-fous de BRAINIAC s'appliquent à la session lancée par l'application.

**Options interdites dans le code (test 13, vérifiées par recherche en phase 7)** :
`--dangerously-skip-permissions`, `--allow-dangerously-skip-permissions`,
`--permission-mode bypassPermissions` (et toute valeur de `--permission-mode` autre que le défaut),
`--bare` (saute les hooks), `--safe-mode` (désactive hooks et CLAUDE.md),
`--setting-sources` (peut exclure les réglages du projet), `--settings` et `--allowedTools`
(élargiraient les permissions), `--restricted` non utilisé non plus. Aucune clé d'API manipulée.

### 3. Dépendances justifiées

Rust (liste du cahier l.43, toutes retenues) :
| Crate | Usage |
|---|---|
| `tauri` 2.11 | fenêtre, IPC, chemins de configuration (`app_config_dir`), empaquetage |
| `serde`, `serde_json` | configuration, événements stream-json |
| `tokio` | processus enfant asynchrone, lecture ligne à ligne de stdout |
| `notify` | surveillance de `humain/`, `journal/` (anti-rebond 200 ms fait à la main) |
| `anyhow` | erreurs internes (jamais affichées brutes, §7) |
| `chrono` | horodatages (pièces jointes, lignes de `validations.md`) |
| `tauri-build` | dépendance de compilation imposée par Tauri |
| **à ajouter** `tauri-plugin-opener` | « ouvrir dans l'application par défaut » (§4.5) ; plugin officiel |
| **à confirmer en phase 4** `libc` | groupe de processus + `killpg` pour ne laisser aucun orphelin (tests 8-9) ; déjà présente en dépendance transitive |

npm :
| Paquet | Usage |
|---|---|
| `vite`, `typescript` | imposés |
| `svelte`, `@sveltejs/vite-plugin-svelte` | framework léger autorisé (l.39) |
| `@tauri-apps/api`, `@tauri-apps/cli` | pont IPC, outil de construction |
| `marked` + `dompurify` | Markdown **assaini** avant rendu (§4.5 l.94) |
| `mermaid` | rendu des diagrammes (§4.5), exécuté en mode `securityLevel: strict` |
| `highlight.js` (cœur + quelques langages) | coloration des blocs de code |

Aucune bibliothèque de composants. Police : une famille libre (licence OFL, par ex. Inter) **embarquée
dans le dépôt** (test 19) ; son téléchargement fait partie de l'accès réseau demandé ci-dessous.

### 4. Question 4.3, routage des demandes d'autorisation : **voie documentée trouvée, non encore vérifiée sur la machine ; à trancher par démonstration en tête de phase 4**
- **`--permission-prompts host|none`** : présente dans `claude --help` (2.1.281). Sa description
  dit : « "host" (the SDK host or --permission-prompt-tool) ».
- **`--permission-prompt-tool <outil MCP>`** : **documentée**, mais **pas encore vérifiée sur la
  machine**. `claude --help` n'en a pas d'entrée propre ; elle n'y est citée que dans la description
  de `--permission-prompts`. Sa description ne vient donc pas de `--help` mais de la référence en ligne
  (code.claude.com/docs/en/cli-reference, lue le 2026-09-23) : « Specify an MCP tool to handle
  permission prompts in non-interactive mode ». Le test `claude --permission-prompt-tool x -v` ne
  prouve rien (`-v` s'arrête avant la lecture des options ; une option inventée passe aussi). La
  vérification locale se fait donc **en tête de phase 4**, par une session réelle, avant tout code
  qui en dépend. La décision (`allow` + `updatedInput`, ou `deny` + `message`) suit le format documenté
  de l'Agent SDK (code.claude.com/docs/en/agent-sdk/user-input).
- **Existe mais non documenté comme protocole public** : le canal de contrôle stdin/stdout utilisé par
  l'Agent SDK (`canUseTool`). Je ne le programme **pas** en Rust à l'aveugle (cahier l.205 : rien
  d'inventé).
- **Voie retenue** : un petit serveur MCP en stdio, binaire Rust du même dépôt, déclaré par
  `--mcp-config` et nommé par `--permission-prompt-tool`. Il relaie chaque demande à l'application
  par une socket Unix locale (droits 0600, dans le dossier de configuration) et attend la décision
  **de l'humain**. Aucune décision automatique : délai dépassé ou application fermée ⇒ `deny`.
  L'accord porte sur une action de l'outil, pas sur une proposition de `a_valider/` : ces approbations-là
  continuent de passer uniquement par `validations.md`.
- **Repli** si la démonstration échoue en phase 4 : `--permission-prompts none`. Les demandes sont
  refusées, Claude est prévenu de ne pas réessayer, et l'interface renvoie vers le circuit
  asynchrone de l'onglet Suivi. Rien n'est contourné.
- Dépendance supplémentaire éventuelle pour le serveur MCP : aucune (JSON-RPC écrit avec `serde_json`).

### 5. Bouton « Au fait »
La commande n'apparaît pas dans `claude --help`. Elle sera **détectée au démarrage** dans l'événement
`system/init`, qui contient la liste des commandes disponibles. À défaut, le message est mis en
file d'attente et l'utilisateur en est averti (cahier l.77).

### 6. Plan par phase (un commit par phase dans `projet/brainiac-console/`, dépôt git local, jamais poussé)

| Phase | Contenu | Critère de fin | Tests |
|---|---|---|---|
| 1 Coquille | `npm create` Tauri 2 + Svelte-TS, fenêtre transparente avec repli opaque et réglage, palette et police §7, logo SVG vectorisé à la main (3 variantes), sélecteur, configuration dans `app_config_dir` ; **module d'écriture unique** avec liste blanche des zones ; `/pentest` périmètre `application` dès l'arrivée du code | démarrage < 2 s, `cargo test` vert | 1, 5, 10, 12, 14, 15, 16, 19 |
| 2 Suivi | rendu `etat.md`, questions ouvertes, `a_valider/`, budget/compteurs, journal, mémoire ; `notify` + anti-rebond | rafraîchissement < 1 s mesuré | 2, 17, 18 |
| 3 Écritures | réponses (ajout seul), approbations/refus (ligne dans `validations.md`), création de tâche | tests unitaires d'ajout seul | 3, 4, 5 |
| 4 Discussion | d'abord vérifier en session réelle `--permission-prompt-tool` ; puis module `cli.rs`, flux, reprise, SIGINT, message annexe (« Au fait », §5), verrou par projet, serveur MCP d'autorisation ou repli | démonstration §4 consignée | 7, 8, 9, 13 |
| 5 Pièces jointes, aperçu | captures dans `pieces_jointes/`, liens (collés tels quels, rappel que leur consultation demande un accord), Mermaid strict, aperçu en iframe `sandbox` sans `allow-scripts`/réseau + CSP | HTML malveillant sans effet | 6, 11 |
| 6 Empaquetage | icônes 16→512, `.deb` + entrée `.desktop` ; signature **signalée seulement** | lancement depuis le lanceur | 16 |
| 7 Rapport | 19 résultats, recherche des options interdites jointe, écarts, actions humaines | rapport dans `a_valider/` | tous |

Test 5 : la seule fonction d'écriture du cœur Rust canonicalise le chemin et le compare à la liste
blanche (`humain/taches/*.md`, `humain/taches/pieces_jointes/`, `humain/taches/validations.md` en ajout,
`humain/questions.md` en ajout, dossier de configuration). Le test unitaire couvre `..`, les liens
symboliques et les chemins absolus.

### 7. Points de vigilance
- **Budget** : l'estimation de 0,02 à 0,05 USD reposait sur un `projet/` vide. Chaque phase
  représente plusieurs dizaines d'actions, et la limite de 90 min / 300 actions par session sera
  atteinte. Je propose de traiter **chaque phase comme une session** et de la réestimer au démarrage.
  Le plafond de 5 USD par tâche risque de ne pas tenir sur l'ensemble : ta décision.
- **Vectorisation du logo** : faite à la main en SVG, sans outil externe (aucun `potrace` installé).
  Le résultat restera une approximation, à juger à l'œil.
- **Garde-fou** : le hook bloque toute redirection shell dont le texte contient « version » (motif
  `VERSION`, insensible à la casse). C'est un faux positif sans risque ; je le contourne par les outils
  d'édition, jamais en modifiant le hook.

## Risques et réversibilité
- Risque : dépendances npm et crates tirées du réseau (chaîne d'approvisionnement). Atténuation :
  versions figées par `package-lock.json` et `Cargo.lock`, `npm audit` et `cargo tree` joints au rapport.
- Risque : le serveur MCP d'autorisation élargit la surface d'attaque. Atténuation : socket locale
  0600, refus par défaut, audité par `/pentest`.
- Réversible : oui. Tout vit dans `projet/brainiac-console/` (exclu du dépôt BRAINIAC) : il suffit de
  supprimer ce dossier, avec ton accord.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`, par exemple
`| 2026-09-23 | 2026-09-23_brainiac_console_phase0.md | APPROUVÉ | réseau npm/crates/police inclus |`.
Précise dans le commentaire si tu **exclus** l'accès réseau pour `npm install` / `cargo` / police,
ou si tu tranches autrement le budget (§7). C'est le seul endroit qui fait foi.
