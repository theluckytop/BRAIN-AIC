# Historique du projet BRAINIAC — toutes modifications depuis le début

Ajouté le 2026-09-27. Objet : consolider, en un seul document, tout ce qui a été fait
depuis l'installation initiale (2026-09-23), pour servir de mémoire aux versions
suivantes de l'espace et de l'application `brainiac-console`. Sources : `git log`
(dépôt BRAINIAC et sous-dépôt `projet/brainiac-console`), `memoire/decisions.md`,
`memoire/lecons.md`, `memoire/estimations.md`, `humain/etat.md`, `humain/a_valider/`,
`pentest/rapports/`.

Ce fichier est une photographie à une date donnée : il ne remplace pas `memoire/` ni
`versions/historique/`, qui restent les sources vivantes en ajout seul.

---

## 1. Chronologie — dépôt de l'espace BRAINIAC

| Commit | Date | Résumé |
|---|---|---|
| `668adf3` | 2026-09-23 | Installation initiale de BRAINIAC 1.0.0 (autotest 50/50), corrections locales de `verifier.sh` et `autotest.sh` pour la protection chmod des zones [R] |
| `199f9c2` | 2026-09-23 | Première tâche de l'espace : BRAINIAC Console (application de suivi décrite dans `memoire/contexte/cahier_des_charges_application.md`), phase par phase avec accord humain après la phase 0 |
| `30dbe93` | 2026-09-23 | Contexte de tâche mis à jour avec la chaîne de compilation installée (Rust, Node.js, dépendances Tauri 2) |
| `be3e030` | 2026-09-23 | Tarifs Haiku 4.5 / Sonnet 5 / Opus 5.5 renseignés en USD dans `arbitrage.yaml` ; autotest et manifeste rendus indépendants des réglages |
| `6a63228` | 2026-09-23 | Manifeste d'intégrité limité à la mécanique et aux fichiers de référence (exclusion des fichiers que l'agent/l'humain font vivre : `etat.md`, `questions.md`, `validations.md`, `lecons.md`, `decisions.md`, `estimations.md`, `plan.md`, `exemptions.md`) |
| `3384b8b` | 2026-09-23 | Phase 0 de BRAINIAC Console approuvée (Tauri 2.11, réseau limité npm/cargo, une tâche par phase) ; tâche de la phase 1 créée ; proposition de correctif du garde-fou (faux positif « version ») |
| `2beb42a` | 2026-09-24 | Phase 1 livrée ; décisions humaines consignées (preuves versionnées dans le dépôt applicatif, phase 2 autorisée, gabarit retiré, gtk accepté, délais de correction 7/30/90 j) ; exemptions pentest posées ; tâche de la phase 2 créée |
| `4b34a30` | 2026-09-24 | Clôture de la phase 1 : relecture conforme sauf test 14 (repli opaque sans compositeur, non observable sous GNOME Wayland) ; audit différentiel sans nouveau constat |
| `e0c3f73` | 2026-09-24 | Validation de la clôture de la phase 1 ; test 14 reporté en phase 6 |
| `0a43350` | 2026-09-24 | Estimateur corrigé : exclusion de `gen/`, `icons/`, `docs/` du périmètre mesuré (la mesure passait de 1,81-5,43 USD à 0,44-1,33 USD pour la phase 2) |
| `972f10e` | 2026-09-24 | `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` réglé par l'humain : le shell revient à la racine de BRAINIAC après chaque commande Bash (corrige les blocages de session par `cd`) |

## 2. Chronologie — sous-dépôt `projet/brainiac-console`

| Commit | Phase | Résumé |
|---|---|---|
| `d77b4da` | 1 | Coquille de BRAINIAC Console (Tauri 2.11 + Vite + TypeScript + Svelte) |
| `9805a10` | 1 | Icônes remplacées par du SVG (Inter ne couvre pas ▾ ⚙ □) ; rouge `#E8323C` réservé aux alertes |
| `eb8b542` | 1 | Preuves de clôture versionnées dans `docs/preuves/phase1/` |
| `3022006` | 2 | Onglet « Suivi » en lecture seule (six blocs) ; points de l'audit initial traités (ACL, permissions réduites, en-têtes, garde de navigation, README, délais de dépendances, gabarit retiré) |
| `34c18e1` | 2 | Corrections après relecture NON CONFORME (test présenté à tort comme « réel », mesures non consignées, README périmé, test négatif du garde manquant) |
| `09f99fa` | 2 | Diff de la phase 2 soumis à l'audit différentiel |

## 3. Décisions structurantes (voir `memoire/decisions.md` pour le détail complet)

- **Pile technique** : Tauri 2.11 (stable) plutôt que 3.0 (alpha, API instable).
- **Autorisations de session** : pas de `--permission-prompt-tool` (non documenté en sortie propre) ; repli sur `--permission-prompts none` + onglet Suivi.
- **Découpage en tâches** : une tâche BRAINIAC par phase de BRAINIAC Console (l'estimateur sous-évalue une construction ex nihilo si tout est regroupé).
- **Écriture par zone** : le mode d'écriture (`create_new` / `append` / renommage atomique) est déduit du chemin canonique, jamais choisi par l'appelant (`ecriture::Zones::ecrire`).
- **Palette** : fond à 86 % (au lieu de 82 %), `--texte-2: #9AAA9C`, `--alerte-texte: #FF8088` pour tenir le contraste AA mesuré par `scripts/contraste.mjs` ; `#E8323C` réservé aux aplats.
- **Preuves de phase** : conservées dans le dépôt de l'application (`docs/preuves/phaseN/`), pas dans `quarantaine/` (réservée aux échecs) ; fichiers `.txt` et non `.log` (`*.log` est dans le `.gitignore` du gabarit).
- **Clôture phase 1** : acceptée avec le test 14 encore partiel (repli sans compositeur non observable sous GNOME Wayland), reporté en phase 6.
- **Budget phase 2** : tâche menée en une session malgré un dépassement initial du plafond de 5 USD, après correction du périmètre mesuré par l'estimateur (voir §4).
- **Lecture de l'espace depuis l'UI** : module unique `suivi.rs`, sans chemin fourni par la fenêtre (pas de `lire_fichier(chemin)`, pas de plugin `fs` Tauri) — liste blanche, canonicalisation, refus des liens symboliques.
- **En-tête `Referrer-Policy`** : posé par `<meta>` faute de support dans `app.security.headers` de Tauri 2.11 ; classé conforme avec réserve.
- **`jsdom`** : ajouté en devDependency (hors liste approuvée du cahier des charges §3) pour tester réellement l'assainissement DOMPurify ; signalé pour confirmation humaine, non encore tranché.

## 4. Leçons opérationnelles (voir `memoire/lecons.md` pour le détail complet)

Ces leçons sont relues au démarrage de chaque tâche ; elles conditionnent la façon de
travailler dans cet espace et doivent être respectées dans les versions suivantes :

1. Toute option d'outil citée doit porter sa source exacte (« vérifié » ne vaut que pour la source nommée).
2. Le garde-fou (`garde_fou.sh`) bloque toute redirection dont le texte contient « version » (motif insensible à la casse) — écrire via Edit/Write, éviter `>` / `2>&1` dans ce cas, ne jamais modifier le hook.
3. Un `cd` nu dans le shell principal verrouille la session derrière le garde-fou (persiste sur `pwd`) — utiliser un sous-shell, `--prefix`, `--manifest-path` ou `git -C`. (Corrigé en pratique le 2026-09-24 par `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1`, commit `972f10e`.)
4. `npm view` est un accès réseau au même titre qu'une installation — lire les versions dans `package-lock.json` / `Cargo.lock` après coup plutôt que d'interroger le registre.
5. Une police embarquée doit être vérifiée pour la couverture de ses glyphes avant d'en faire des icônes (`fc-query -f '%{charset}'`) — préférer le SVG.
6. Une preuve citée dans un rapport doit exister sur le disque et être relue avant d'être citée (commande, date, sortie, provenance).
7. La durée de session mesurée par le hook inclut le temps d'attente humain, pas seulement le temps de travail — finir une clôture avant de rendre la main au-delà de 60 min.
8. Les sous-agents `pentest_*` n'ont pas de shell : leur fournir le diff dans le prompt plutôt que de leur demander de le produire.
9. Les fichiers de preuve `.log` sont ignorés par le `.gitignore` du gabarit — les nommer `.txt` d'emblée.
10. Un `cd` nu peut récidiver malgré la leçon écrite (réflexe) — lire `projet/` par `ls chemin`, `git -C`, `--prefix` ou l'outil Read, jamais par `cd`.
11. Un jeu de données de test n'est « réel » que s'il est copié tel quel ; sinon le qualifier explicitement de « synthétique ».
12. Les sous-agents répètent les mêmes erreurs que l'agent principal (ex. `cd`) car les leçons vivent dans le contexte de l'agent principal, pas dans le leur — répéter la règle en tête de chaque prompt de sous-agent.
13. Une preuve citée dans un rapport doit être copiée dans un lieu durable avant que `/cloture` ne vide `travail/brouillons/`.

## 5. Estimations — estimé contre réel (voir `memoire/estimations.md`)

Le réel en jetons/USD n'a jamais pu être relevé depuis l'agent lui-même sur les 4 tâches
menées à ce jour (phase 0, phase 1, clôture phase 1, phase 2) : les écarts sont
« inexploitables » et le calibrage automatique de `arbitrage.yaml` (seuil de 10 relevés
exploitables) n'a donc jamais pu se déclencher. Point notable : la première estimation de
la phase 2 (1,81–5,43 USD) était gonflée par des fichiers générés/mesurés à tort
(`gen/`, `icons/`, `docs/`) ; correction du périmètre → 0,44–1,33 USD (commit `0a43350`).

## 6. État applicatif atteint (BRAINIAC Console, au 2026-09-24)

- **Phase 0** (cadrage) : approuvée — Tauri 2.11 + Vite + TS + Svelte, réseau limité npm/cargo.
- **Phase 1** (coquille) : livrée et clôturée. Icônes SVG, palette conforme AA, preuves versionnées. Écart connu : test 14 (repli sans compositeur) reporté en phase 6.
- **Phase 2** (onglet Suivi, lecture seule) : livrée, en attente du point de contrôle humain (rapport `humain/a_valider/2026-09-24_brainiac_console_phase2_rapport.md`).
  - Tests : `cargo test` 39 réussis ; assainissement Markdown/DOMPurify 0 échec (contre-épreuve 7 échecs) ; contraste 0 échec ; build OK ; 0 option interdite ; 0 API d'écriture hors `ecriture.rs`.
  - Relecture `verificateur` : NON CONFORME au plan sur des écarts mineurs, tous corrigés (`34c18e1`), sans seconde relecture formelle.
  - Audit différentiel (V1, V3, V13, V15) : 54 exigences couvertes, 0 critique, 0 élevé, 2 moyennes, 0 régression.
  - Décisions en attente humaine : sort de `jsdom` (dépendance non prévue), lecture de l'écart V3.4.5 (`Referrer-Policy`), autorisation de la phase 3 (écritures) et de son accès réseau.
  - Suppressions en attente d'accord humain : `travail/brouillons/phase2_diff.txt` (copié dans `docs/preuves/phase2/diff_audite.txt`) et `travail/_tmp_calc.mjs` (fichier vide créé par erreur).
- **Phase 3** (écritures) : non commencée à la date de rédaction.

### Sécurité (au 2026-09-24)
Aucun constat critique ni élevé ouvert. Ouverts : V15.1.1 et V15.2.1 (moyenne), 8 faibles
dont V3.7.2 (`on_new_window` absent) et V15.2.2 (anti-rebond sans délai maximal).
`cargo audit` non disponible dans l'environnement d'audit.

### Écarts connus non résolus
- Aucune fenêtre Tauri réellement lancée pendant les tests : rendu 420 px, événement
  `suivi-change` de bout en bout, refus d'ACL au runtime, en-têtes réellement émis, test 17,
  non observés en conditions réelles.
- Pas de barre de coût dans l'UI (aucune source de données identifiée).
- Incohérence de compteur relevée dans `application_config.json` (non corrigée, rapport en zone ajout seul).
- L'estimateur n'accepte qu'un chemin `humain/taches/<fichier>` : la ligne d'estimation de
  la phase 2 a dû être insérée avant celle de la clôture de la phase 1 (même date) dans
  `estimations.md`, par contrainte d'outil plutôt que par ordre chronologique strict.

## 7. Pour les versions suivantes

- Le réglage `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` (commit `972f10e`) doit être
  conservé dans toute réinstallation : il élimine la classe d'incidents « session
  verrouillée par `cd` » qui s'est produite deux fois (2026-09-23 et 2026-09-24).
  Autrement dit, il faut vérifier lors de la mise à jour que le nouveau `.claude/settings.json` livré par `versions/update/` ne l'écrase pas silencieusement.
- Le correctif proposé pour le faux positif « version » du garde-fou
  (`humain/a_valider/2026-09-23_garde_fou_faux_positif_version.md`) n'est toujours pas
  appliqué : à trancher avant que la leçon n°2 ne cause une nouvelle perte de temps.
- Le périmètre mesuré par l'estimateur (`gen/`, `icons/`, `docs/` exclus) doit rester
  aligné avec la structure réelle du projet Tauri au fil des phases suivantes, sous peine
  de fausser à nouveau les fourchettes de coût.
- Le sort de `jsdom` et la lecture de l'écart V3.4.5 restent à trancher par l'humain avant
  d'ouvrir la phase 3 ; les reporter silencieusement referait grossir la dette déjà notée
  pour le test 14 (phase 6).
