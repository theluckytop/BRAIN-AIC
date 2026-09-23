# Réaliser BRAINIAC Console, l'application de suivi

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Construire BRAINIAC Console, la petite application de bureau qui suit un espace BRAINIAC et pilote une
session Claude Code, conformément à `memoire/contexte/cahier_des_charges_application.md`.
Le travail avance phase par phase (sections 5 et 6 du cahier), avec un accord humain avant la phase 1.

## Contexte
- Référence unique : `memoire/contexte/cahier_des_charges_application.md`. En cas de doute, c'est lui
  qui tranche ; ce fichier n'en est que le cadrage.
- Le code vit dans `projet/brainiac-console/`, avec son propre dépôt git : `projet/` est exclu du
  dépôt de BRAINIAC.
- Pile imposée : Tauri (cœur Rust), Vite + TypeScript, Svelte au plus, aucune bibliothèque de
  composants. Vérifier la version majeure actuelle de Tauri et sa documentation avant d'écrire du code.
- Machine cible : Ubuntu 26.04 (base Debian), x86_64. Claude Code 2.1.281 installé.
- **Rien n'est installé pour compiler** : ni Rust (`cargo`, `rustc`), ni Node.js (`node`, `npm`), ni
  les dépendances système de Tauri. Leur installation relève de l'accord humain : la lister en phase 0,
  ne pas la lancer.
- Le logo de référence est `assets/logo_brainiac.png`.
- L'application occupe la place de l'humain, jamais celle de l'agent (section 2 du cahier).

## Critères d'acceptation
- [ ] Phase 0 livrée dans `humain/a_valider/` : versions vérifiées de Tauri et de Claude Code, options
      exactes du mode sans interface en flux JSON (vérifiées avec `claude --help` et la documentation),
      liste justifiée des dépendances, commandes d'installation de la chaîne de compilation, plan par
      phase. Aucun code écrit avant l'approbation inscrite dans `humain/taches/validations.md`.
- [ ] Phases 1 à 6 réalisées dans `projet/brainiac-console/`, chacune close par un commit dans le dépôt
      de l'application.
- [ ] Les 19 tests d'acceptation de la section 6 du cahier ont chacun un résultat consigné : réussi,
      échoué, ou non vérifiable avec sa raison.
- [ ] Test 13 : aucune option désactivant les permissions ou les hooks dans le code (recherche jointe
      au rapport).
- [ ] Test 5 : un test unitaire démontre que l'application ne peut écrire que dans `humain/taches/`,
      `humain/taches/pieces_jointes/`, `humain/taches/validations.md`, `humain/questions.md` et sa propre
      configuration.
- [ ] La question du routage des demandes d'autorisation (section 4.3) est tranchée par une
      vérification, et le résultat figure dans le rapport.
- [ ] Le rapport de phase 7 est déposé dans `humain/a_valider/` : résultats des tests, écarts, points
      non vérifiables, dépendances justifiées, actions restant à l'humain.
- [ ] Audit `/pentest` sur le périmètre `application` lancé une fois le code présent, sans constat
      critique ouvert au moment du rapport.

## Hors périmètre
- Tout ce qui est hors de `projet/brainiac-console/`, sauf les propositions et rapports dans
  `humain/a_valider/` et la mise à jour de `humain/etat.md`.
- Installer des paquets système, Rust ou Node.js sans accord explicite.
- Modifier la mécanique de BRAINIAC (`.claude/`, `ressources/`, `AGENTS.md`…) : toute faiblesse
  constatée se propose dans `humain/a_valider/`.
- La signature ou la notarisation des paquets : à signaler, pas à faire.
- Pousser un dépôt vers un service distant.
