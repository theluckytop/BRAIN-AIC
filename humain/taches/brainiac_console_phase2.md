# BRAINIAC Console — phase 2 : suivi en lecture

- **Priorité** : haute
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
Réaliser l'onglet « Suivi » de BRAINIAC Console : lire et afficher l'état d'un espace BRAINIAC, mis à jour
automatiquement quand ses fichiers changent, sans rien y écrire. Traiter en tête de phase les points
faibles de l'audit du 2026-09-23 prévus pour la phase 2, puis déposer le rapport de fin de phase dans
`humain/a_valider/` et s'arrêter.

## Contexte
- Tâche mère : `humain/taches/brainiac_console.md`. Référence : `memoire/contexte/cahier_des_charges_application.md`,
  sections 4.2, 6 et 7. Plan : `humain/a_valider/2026-09-23_brainiac_console_phase0.md` §3 et §6.
- Point de départ : phase 1 close (commits `d77b4da` et `9805a10`, puis ceux de sa clôture), rapport
  `humain/a_valider/2026-09-23_brainiac_console_phase1_rapport.md`, audit `pentest/rapports/2026-09-23_235354/`.
- **Condition préalable** : la clôture de la phase 1 doit être terminée (relecture, audit différentiel,
  preuves dans `projet/brainiac-console/docs/preuves/phase1/`). Sinon, la terminer d'abord et s'arrêter là.
- Décisions de l'humain du 2026-09-24 (`humain/taches/validations.md`) : retrait des fichiers du gabarit
  accordé, `gtk` 0.18 accepté, délais de correction des dépendances vulnérables (critique 7 j, élevée
  30 j, moyenne 90 j), `npm audit` à 0 vulnérabilité, exemptions inscrites dans `pentest/exemptions.md`.
- Dépendances de la phase, déjà approuvées au §3 : `notify` (surveillance), `tokio` si nécessaire,
  `marked` et `dompurify` (Markdown assaini). Toute autre dépendance est justifiée dans le rapport.
- Réseau : `npm install` et `cargo` uniquement.
- **Une seule session** (limite de 90 min et 300 actions). Au-delà de 60 min, finir l'étape en cours,
  mettre `humain/etat.md` à jour et rendre la main : la leçon du 2026-09-24 s'applique.
- Jamais de `cd` qui change le répertoire de la session : sous-shells, `--prefix`, `--manifest-path`,
  `git -C`.

## Critères d'acceptation
- [ ] `humain/etat.md` mis à jour au démarrage, puis à chaque étape importante.
- [ ] Points de l'audit traités et vérifiés :
      - garde de navigation qui refuse toute URL hors de l'application (V3.7.2) ;
      - permissions réduites au strict nécessaire, au lieu de `core:default` (V13.2.2) ;
      - `AppManifest` déclaré dans `build.rs`, pour que les commandes passent par l'ACL de Tauri ;
      - en-têtes `nosniff`, `no-referrer` et `frame-ancestors 'none'` (V3.4.4 à V3.4.6) ;
      - mesures de démarrage et mode aperçu exclus de la version publiée (V15.2.3) ;
      - délais de correction des dépendances documentés dans le dépôt (V15.1.1) ;
      - README du gabarit remplacé (V3.1.1, V3.7.5, V13.1.1) ;
      - création du dossier de configuration ramenée dans le module d'écriture, ou documentée.
- [ ] Fichiers du gabarit retirés : `src/assets/{tauri,vite,typescript}.svg`, `.vscode/`.
- [ ] Onglet « Suivi », en lecture seule (section 4.2 du cahier) :
      - **État** : rendu de `humain/etat.md` avec l'heure de sa dernière modification, et un indicateur
        quand le fichier n'a pas bougé depuis longtemps alors qu'une session tourne ;
      - **Questions en attente** : entrées de `humain/questions.md` dont la ligne `Réponse :` est vide,
        affichées sans champ de réponse (les réponses arrivent en phase 3) ;
      - **À valider** : liste des fichiers de `humain/a_valider/` avec leur contenu rendu, sans boutons
        de décision (phase 3) ;
      - **Budget et modèle** : lecture de `ressources/budget.yaml`, de `journal/.compteurs.json` et de
        `humain/etat.md`, avec barre de progression qui change de couleur aux seuils ;
      - **Activité** : 30 dernières lignes de `journal/actions.log`, lignes bloquées mises en évidence,
        compteur des refus de la session ;
      - **Mémoire** : 5 dernières entrées de `memoire/lecons.md` et de `memoire/decisions.md`, repliables.
- [ ] Markdown assaini avant rendu (`marked` puis `dompurify`). Un test montre qu'un `<script>` ou un
      gestionnaire `onerror` présent dans `etat.md` n'est pas exécuté.
- [ ] Surveillance des fichiers par `notify` avec anti-rebond d'environ 200 ms. Test 2 : `etat.md`
      modifié de l'extérieur est réaffiché en moins d'une seconde (mesure consignée).
- [ ] Tests 17 et 18 : aucune animation sous `prefers-reduced-motion`, contraste AA des nouveaux écrans
      (`npm run test:contraste` étendu).
- [ ] Aucune écriture dans l'espace suivi : toute lecture passe par un module de lecture, et
      `ecriture.rs` reste la seule porte d'écriture. Vérification jointe au rapport.
- [ ] États vides qui expliquent en une ligne ce qu'ils montreront (section 7).
- [ ] `cargo test` vert, recherche des options interdites à 0 occurrence, audit différentiel `/pentest`
      sans constat critique ou élevé ouvert.
- [ ] Commit de fin de phase, puis rapport dans `humain/a_valider/` : tests couverts et leur résultat,
      écarts, dépendances ajoutées, points non vérifiables, estimation de la phase 3.

## Hors périmètre
- Toute écriture dans l'espace suivi : réponses aux questions, approbations, création de tâches
  (phase 3).
- L'onglet « Discussion » et le lancement de `claude` (phase 4). Pièces jointes et aperçu (phase 5).
- Toute écriture hors de `projet/brainiac-console/`, sauf `travail/`, `humain/a_valider/`,
  `humain/etat.md`, `humain/questions.md`, `memoire/` et `pentest/rapports/` selon `AGENTS.md`.
- `npm view` et tout accès réseau autre que `npm install` et `cargo`.
- Modifier la mécanique de BRAINIAC. Pousser un dépôt vers un service distant.
