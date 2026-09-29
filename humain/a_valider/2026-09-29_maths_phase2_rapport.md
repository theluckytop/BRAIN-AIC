# Proposition — 2026-09-29_maths_phase2_rapport

## Action proposée
Clore la phase 2 (moteur mathématique de `projet/maths/moteur/`) et autoriser la phase 3.

## Pourquoi
Le moteur est livré et testé. Après deux relectures NON CONFORME, la reprise du 2026-09-29 applique
ta décision « jamais de sanction à tort ». La 3e relecture `verificateur` rend **CONFORME** au plan,
avec 5 écarts mineurs, dont 3 corrigés ensuite. L'audit différentiel `pentest_entrees` ne relève
**aucun constat critique ni élevé**. Sans clôture, la phase 3 (interface) ne démarre pas.

**Clôture (`/cloture`)** : la relecture et l'audit de `0733742` concluent **CONFORME, 0 critique,
0 élevé** (`pentest/rapports/2026-09-29_maths_phase2_cloture/`). Une régression mineure relevée
par les deux passes (`(1/2)^-1(x+1)`, `x^-1(x+1)` refusés avec « Factorise ») a été corrigée au
commit de clôture. Ce dernier correctif d'une ligne n'a pas été relu par un tiers : seulement mes
tests (55 réussis) et la mesure de temps (8,4 ms release).

## Contenu exact
Dépôt `projet/maths/`, commits de la phase : `2a51a0c`, `e07fbfb`, `3236c64`, `2a2b1a2`, `4c1bc78`,
`4fd1b0b`, `0733742`, `4855590`, et le correctif de clôture (voir `git -C projet/maths log`). Preuves : `projet/maths/docs/preuves/phase2/` (`qualite_moteur.txt`,
`temps_verification.txt`, `differentiel_forme.txt`, `build_trunk.txt`, diffs audités).

- **API** : `verifier(saisie, attendue, exiger_forme_simplifiee)` et
  `verifier_forme(…, FormeAttendue)`. Verdicts possibles : `Juste`, `ASimplifier`,
  `FormeIncorrecte`, `Faux`, `SaisieInvalide`. Une référence invalide renvoie `ErreurReference`,
  qui signale un défaut du contenu de l'exercice.
- **Forme simplifiée** :
  - Valeurs et équations résolues : garantie exacte.
  - Expressions en `x` : sanction sur règles sûres seulement (liste en tête de `forme.rs`).
  - 20 000 expressions aléatoires évidemment simplifiées : 0 sanction.
  - Test différentiel sur les 14 258 expressions de la 2e relecture.
  - La 3e relecture n'a trouvé aucune sanction à tort, sur 150 formes ciblées et 30 000 expressions
    aléatoires.
- **Temps** : pire cas **7,8 ms en release** natif, pour un seuil de 50 ms. En debug : 73 à 107 ms,
  indicatif. Le temps en WebAssembly sera mesuré en phase 4.
- **Qualité** : 55 tests, clippy `-D warnings` propre, fmt propre. WASM inchangé : 29 413 o en gzip.

## Risques et réversibilité
- **Limites acceptées** selon « dans le doute, juste » (3e relecture, M3 et M4) :
  - Certains calculs non faits passent : `2(x+1)+3(x+1)`, `1/(x+1)+1/(x+1)`, `(x+1)^2/(x+1)`.
  - Une équation sans solution, ou toujours vraie, recopiée telle quelle est jugée `Juste`.
- **Audit, ouverts après clôture** : 2 moyennes, 5 faibles, 2 informations
  (`pentest/rapports/2026-09-29_maths_phase2_cloture/`). R-01 clos.
  - **E-01 et N-01, partiels** : la factorisation complète n'est pas vérifiée. `1/2(2x^2+4x+2)` et
    `2(x^2/2+x+1/2)` et `(x+1)/(1+x)(x^2+2x+1)` passent encore avec « Factorise ». L'audit
    recommande d'exiger un facteur somme de degré ≥ 1 et inférieur au degré de l'expression :
    cette règle fermerait ces trois contournements. C'est à trancher par toi, ce qui revient à la
    décision 1 ci-dessous.
  - **E-05, partiel** : `mesure_temps` ne mesure pas le chemin « Factorise ».
  - **R-02, information** : une référence lourde avec des pôles peut réussir le test « face à
    elle-même » de la phase 5, puis échouer face à la bonne réponse. Le test de contenu de la
    phase 5 devra donc la confronter à une réponse définie aux pôles.
  - **Exigence pour la phase 3** : n'afficher les messages qu'en texte, jamais en `inner_html`
    (E-04), et ne jamais compter une `ErreurReference` comme une réussite.
- **Non mesuré** : la pile wasm32 (récursion bornée seulement par les 32 niveaux de l'analyseur),
  et le temps en WebAssembly.
- **Réversible** : oui. Le moteur n'est encore branché à aucune interface ; `git -C projet/maths
  revert` sur les commits cités.

## Décisions à prendre
1. Clore la phase 2 avec les limites ci-dessus, ou exiger la vérification de factorisation complète
   (forme normale) avant la phase 3.
2. Autoriser la phase 3 : fichier de tâche `maths_phase3.md` à déposer par toi.
3. Budget : la phase 2 a demandé deux sessions en opus. Le plafond de 5,00 USD est probablement
   dépassé ; à relever de ton côté.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
