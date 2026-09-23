# BRAINIAC Console — phase 1 : coquille

- **Priorité** : haute
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
Créer dans `projet/brainiac-console/` la coquille de l'application : une application Tauri 2 qui
démarre, avec sa fenêtre translucide et son repli opaque, son identité visuelle, son logo vectorisé,
le sélecteur de projets et le module d'écriture unique. La phase se termine par un rapport dans
`humain/a_valider/`, puis on s'arrête : la phase 2 fera l'objet d'une autre tâche.

## Contexte
- Tâche mère : `humain/taches/brainiac_console.md`. Référence : `memoire/contexte/cahier_des_charges_application.md`,
  sections 2, 3, 4.1, 5 (phase 1), 6 et 7.
- Plan approuvé : `humain/a_valider/2026-09-23_brainiac_console_phase0.md`, §3 (dépendances) et §6
  (ligne « 1 Coquille »). Approbation du 2026-09-23 dans `humain/taches/validations.md` : **ses
  conditions font partie de cette tâche**.
- Pile : Tauri 2.11 (cœur Rust), Vite 8 + TypeScript + Svelte, aucune bibliothèque de composants.
  Chaîne installée et vérifiée en phase 0 : rien à installer au niveau système.
- Réseau autorisé uniquement pour `npm create`, `npm install` et `cargo` (registres npm et crates.io).
  Police : paquet `@fontsource` (licence OFL), pas de téléchargement séparé.
- Code dans `projet/brainiac-console/`, avec son propre dépôt git, jamais poussé. `projet/` est exclu
  du dépôt BRAINIAC.
- Logo de référence : `assets/logo_brainiac.png`. Vectorisation à la main (aucun outil de tracé
  installé) : approximation acceptée, à juger à l'œil dans le rapport.
- Faux positif connu du garde-fou sur le mot « version » : voir `memoire/lecons.md`.

## Critères d'acceptation
- [ ] Dépôt git initialisé dans `projet/brainiac-console/`, versions figées par `package-lock.json`
      et `Cargo.lock`, un commit de fin de phase.
- [ ] Seules les dépendances du §3 de la proposition sont présentes, plus `@fontsource/<famille>`.
      Tout ajout est justifié dans le rapport.
- [ ] L'application démarre en moins de 2 secondes (mesure consignée).
- [ ] Fenêtre transparente avec fond teinté, repli opaque automatique quand le compositeur ne suit pas,
      réglage pour désactiver la translucidité (tests 14 et 15).
- [ ] Palette, typographie et rythme de la section 7, police embarquée (test 19). Interface
      utilisable à 420 pixels de large (test 12).
- [ ] Logo en SVG, trois variantes (complète, simplifiée, monochrome), rendu vérifié à 16, 32, 128 et
      512 pixels (test 16).
- [ ] Sélecteur de projets : refus motivé d'un dossier sans `AGENTS.md`, `.claude/` ou `humain/`
      (test 1), projet introuvable affiché grisé sans être supprimé (test 10), configuration
      persistante dans le dossier de configuration de l'application.
- [ ] Une seule fonction d'écriture dans le cœur Rust : elle canonicalise le chemin et le compare à la
      liste blanche. `humain/taches/*.md` et `humain/taches/pieces_jointes/` sont en **création seule,
      jamais d'écrasement**. `humain/taches/validations.md` et `humain/questions.md` sont en **ajout
      seul**. Le dossier de configuration de l'application est aussi autorisé.
- [ ] Test unitaire de cette fonction couvrant `..`, les liens symboliques, les chemins absolus hors
      zone et la tentative d'écrasement d'un fichier existant (test 5). `cargo test` vert.
- [ ] Aucune option désactivant les permissions ou les hooks dans le code (liste du §2 de la
      proposition, recherche jointe au rapport).
- [ ] `/pentest` lancé sur le périmètre `application`, sans constat critique ouvert au moment du rapport.
- [ ] Coût réel relevé, rapport de fin de phase déposé dans `humain/a_valider/` : tests couverts et leur
      résultat, écarts, dépendances, points non vérifiables, estimation de la phase 2.

## Hors périmètre
- Tout ce qui relève des phases 2 à 7 : lecture et surveillance de `humain/`, écritures réelles dans
  l'espace suivi, discussion et lancement de `claude`, pièces jointes, aperçu, empaquetage.
- Toute écriture hors de `projet/brainiac-console/`, sauf `travail/`, `humain/a_valider/`,
  `humain/etat.md`, `humain/questions.md`, `memoire/` et `pentest/rapports/` selon les règles de
  `AGENTS.md`.
- Installer des paquets système ou élargir l'accès réseau au-delà de ce qui est autorisé ci-dessus.
- Modifier la mécanique de BRAINIAC, y compris le garde-fou : proposition dans `a_valider/` seulement.
- Pousser un dépôt vers un service distant.
