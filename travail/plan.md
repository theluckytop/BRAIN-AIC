# Plan — BRAINIAC Console, phase 1 : coquille

**Objectif** : coquille Tauri 2 dans `projet/brainiac-console/` : fenêtre translucide avec repli opaque,
identité §7, logo SVG en 3 variantes, sélecteur de projets, module d'écriture unique testé, rapport.
**Périmètre** : `projet/brainiac-console/` ; `travail/`, `humain/a_valider/`, `humain/etat.md`,
`memoire/`, `pentest/rapports/`. Réseau : `npm create`, `npm install`, `cargo` seulement.
**Palier de modèle** : recommandé moyen (sonnet) par l'estimateur, qui mesure un `projet/` vide ;
session courante opus, bascule proposée à l'humain (pas de désescalade en cours de tâche).
**Conditions de l'approbation du 2026-09-23** : phase 1 seule ; police via `@fontsource` ; `taches/` et
`pieces_jointes/` en création seule, jamais d'écrasement ; point de contrôle en fin de phase.
**Hook** : session à 90 min / 300 actions. Si le plafond approche, arrêt propre à la fin d'une étape.
Jamais de `cd` nu : sous-shell, `--prefix`, `--manifest-path`, `git -C`.

| # | Étape | Critère de réussite | Statut |
|---|---|---|---|
| 1 | Échafaudage : `npm create tauri-app` (gabarit vanilla-ts, pour éviter SvelteKit), puis `npm install` de svelte, @sveltejs/vite-plugin-svelte et @fontsource/inter ; `git init` | `npm run build` et `cargo check` passent ; `package-lock.json` et `Cargo.lock` présents | fait |
| 2 | Module d'écriture unique `ecriture.rs` : canonicalisation, liste blanche, création seule (`create_new`), ajout seul, configuration | `cargo test` vert : `..`, lien symbolique, chemin absolu hors zone, écrasement refusé, ajout conservant l'existant (test 5) | fait : 13 tests |
| 3 | Configuration et projets (`config.rs`, `projets.rs`) : validation `AGENTS.md`/`.claude/`/`humain/` avec motif, liste persistante (nom, chemin, couleur, dernière ouverture), état « introuvable » | tests unitaires des tests 1 et 10 ; configuration écrite par `ecriture.rs` seulement | fait : 5 tests |
| 4 | Fenêtre : `transparent`, sans décorations système, barre de titre maison ; composition détectée côté Rust (GTK), repli opaque automatique ; réglage « translucidité » | tests 14 et 15 : mode opaque forcé lisible ; mode repli choisi quand le compositeur ne compose pas | fait : composition détectée ; repli non observable ici |
| 5 | Interface Svelte : palette, Inter embarquée, grille 8 px, sélecteur toujours visible, états vides, `prefers-reduced-motion` | rendu à 420 px vérifié (capture Firefox sans affichage), contraste AA calculé par script (tests 12, 17, 18, 19) | fait : capture 420 px, contraste 0 échec |
| 6 | Logo SVG : complet, simplifié, monochrome | rendu à 16, 32, 128 et 512 px capturé et jugé (test 16) | fait : capture jointe |
| 7 | Démarrage < 2 s mesuré (horodatage Rust du lancement jusqu'au signal « prêt » de l'interface) | mesure consignée | fait : 976 / 981 / 987 ms (débogage) |
| 8 | Recherche des options interdites (§2 de la proposition de phase 0) | aucune occurrence, sortie jointe | fait : 0 occurrence (git grep) |
| 9 | `/pentest` sur le périmètre `application` (vague limitée, arbitrée) | rapport dans `pentest/rapports/`, aucun critique ouvert | fait : 0 critique, 0 élevé |
| 10 | Commit de fin de phase ; relecture `verificateur` ; rapport dans `humain/a_valider/` avec l'estimation de la phase 2 | verdict conforme, rapport déposé | fait : NON CONFORME → 4 écarts corrigés, 3 déclarés |
