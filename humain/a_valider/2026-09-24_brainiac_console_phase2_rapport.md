# Proposition — 2026-09-24_brainiac_console_phase2_rapport

## Action proposée
Clore la phase 2 de BRAINIAC Console (suivi en lecture, commits `3022006` puis `34c18e1` du dépôt `projet/brainiac-console/`) et autoriser la phase 3 (écritures : réponses aux questions, approbations, création de tâches) comme nouvelle tâche.

## Pourquoi
Point de contrôle exigé par l'approbation du 2026-09-23 (« point de contrôle à la fin de chaque phase »). Sans accord, rien ne s'écrit au-delà de la phase 2. La phase 3 est la première qui écrit dans l'espace suivi : elle demande ton accord explicite.

## Contenu exact

### 1. Livré
| Élément | Où |
|---|---|
| Onglet « Suivi » en lecture seule : État (rendu Markdown, date, indicateur « ANCIEN »), Questions en attente, À valider, Budget et modèle (jauges durée et actions, seuils 70 % et 90 %, texte en plus de la couleur), Activité (30 lignes, `BLOQUÉ`, refus de la session), Mémoire (5 dernières entrées, repliables) | `src/suivi/Suivi.svelte`, `calculs.ts`, `types.ts` |
| Module de lecture unique, liste blanche, sans paramètre de chemin venu de la fenêtre, canonicalisation, refus des liens symboliques et de `..`, plafond de 1 Mo | `src-tauri/src/suivi.rs` (commande `lire_suivi`) |
| Surveillance `notify` 8.2.0 avec anti-rebond de 200 ms, événement `suivi-change`, relancée au changement de projet | `src-tauri/src/surveillance.rs`, `lib.rs` |
| Markdown assaini : `marked` puis `DOMPurify`, HTML brut échappé, échec fermé sans assainisseur | `src/suivi/rendu.ts` |
| Points de l'audit du 2026-09-23 : `AppManifest`, fin de `core:default` (12 permissions explicites), `nosniff`, `frame-ancestors 'none'`, `Referrer-Policy` par `<meta>`, garde de navigation, mesures et aperçu réservés au débogage, README remplacé, `docs/dependances.md`, gabarit retiré | `build.rs`, `capabilities/default.json`, `tauri.conf.json`, `lib.rs`, `index.html`, `README.md`, `docs/dependances.md` |

### 2. Tests couverts et résultat (relancés par moi, sorties dans `docs/preuves/phase2/`)
| Test / critère | Résultat |
|---|---|
| `cargo test` | 39 réussis, 0 échec |
| Assainissement : `<script>`, `onerror`, `javascript:`, `<iframe>` | 0 échec ; contre-épreuve sans assainissement : 7 échecs (code 1) |
| Contraste AA (test 18), 40 couples, nouveaux écrans compris | 0 échec |
| `npm run build`, aperçu absent de `dist/` | OK, 0 occurrence |
| Options interdites | 0 occurrence |
| API d'écriture hors `ecriture.rs` | 0 occurrence hors tests ; garde permanent `aucune_api_d_ecriture` avec test négatif |
| Test 2 (rafraîchissement < 1 s) | **partiel** : 5 mesures à 200 ms jusqu'au rappel du débounceur ; trajet jusqu'à l'affichage non mesuré |
| Test 17 (`prefers-reduced-motion`) | **partiel** : règle globale `styles.css:45-48`, non observée en fenêtre |

### 3. Audit différentiel (`pentest/rapports/2026-09-24_differentiel_phase2/synthese.md`)
54 exigences (V1, V3, V13, V15) : 28 conformes, 2 non conformes (V3.4.7, V3.4.8, information, inchangées), 10 partielles, 14 indéterminées. **0 critique, 0 élevé**, 2 moyennes (V15.1.1, V15.2.1), 0 régression. Le livrable n'est pas bloqué. Une incohérence de compteur dans `application_config.json` est signalée dans la synthèse (rapport en ajout seul, non modifié).

### 4. Relecture `verificateur`
Verdict : NON CONFORME au plan, écarts mineurs, code et tests bons. Écarts corrigés au commit `34c18e1` : le test de questions se disait « extrait réel » alors qu'il était retouché (renommé « synthétique ») ; mesure du test 2 et sorties de tests non consignées (consignées) ; README périmé (à jour) ; test négatif du garde d'écriture absent (écrit) ; `.gitignore` (nettoyé). **Ces corrections n'ont pas fait l'objet d'une seconde relecture** : je les ai seulement relancées (39 tests). Sur l'état actuel de `humain/questions.md`, la règle « question en attente » donne **0** question, ce qui est correct : toutes ont une réponse.

### 5. Écarts et points non vérifiables
- **Aucune fenêtre n'a été lancée.** Non observés : rendu et capture à 420 px, événement `suivi-change` de bout en bout, refus d'une commande hors ACL, en-têtes réellement émis, garde de navigation en situation. À faire en session interactive.
- Pas de barre de **coût** : aucun fichier suivi ne donne la consommation (`credits_max_par_tache` est une limite). Deux jauges seulement.
- `Referrer-Policy` posé par `<meta>` (Tauri n'expose pas d'en-tête) : à trancher par toi (V3.4.5).
- « Session qui tourne » : heuristique (compteurs présents et dernière ligne du journal de moins de 10 min), non validée par toi.
- Test 14 toujours reporté en phase 6 (décision du 2026-09-24).
- `cargo audit` non disponible : le côté Rust n'est pas audité par outil (V15.2.1).
- Récidive du `cd` nu de ma part (session verrouillée jusqu'à ton `! cd`), et dans le premier appel de chaque `executant` (sans effet). Leçon consignée.

### 6. Dépendances ajoutées
| Dépendance | Version | Usage | Statut |
|---|---|---|---|
| `notify` | 8.2.0 (`inotify` 0.11.5, `mio` 1.2.3) | surveillance | approuvée |
| `marked` | 18.0.14 | Markdown | approuvée |
| `dompurify` | 3.4.16 | assainissement | approuvée |
| `jsdom` | 30.1.1, **dev seulement** | DOM pour tester DOMPurify en Node | **non prévue, à confirmer** (hors `dist/`) |
Aucune autre. Deux petits fichiers `scripts/ts-loader.mjs` et `ts-hooks.mjs` transpilent `rendu.ts` pour le test avec le `typescript` existant. `docs/dependances.md` ne cite pas encore ces ajouts (V15.1.2 partiel).

### 7. À traiter en phase 3 ou avant
Les dix points de la synthèse d'audit, dont : anti-rebond sans délai maximal (V15.2.2), `on_new_window` absent (V3.7.2), exception de rendu non rattrapée dans `Suivi.svelte`, `O_NOFOLLOW` et refus de `nlink > 1` avant la première écriture réelle (reportés de la phase 1).

### 8. Estimation de la phase 3
Indicative, l'estimateur ne voit pas le code à écrire : 0,5 à 1,5 USD en sonnet, une session de 60 à 90 min (écritures par `ecriture.rs` seul, `O_NOFOLLOW`, refus de `nlink > 1`, formulaires de réponse et d'approbation, création de tâche, tests d'écriture). Palier moyen (sonnet) suffisant ; l'audit d'entrée des écritures justifie un audit V5 en plus. Coût réel des phases 1 et 2 : non lisible depuis l'agent (≈ 600 k jetons de sous-agents sur la phase 2), à relever de ton côté.

## Risques et réversibilité
- Risque : la phase 3 ouvre les premières écritures dans l'espace suivi ; les protections `O_NOFOLLOW` et `nlink` doivent être en place d'abord.
- Réversible : oui. Tout vit dans `projet/brainiac-console/`, dépôt local jamais poussé (`git -C projet/brainiac-console revert` ou retour à `eb8b542`).

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` (phase 2 close, phase 3 autorisée ou non ; `jsdom` en dev accepté ou non ; lecture de V3.4.5 ; réseau pour `cargo` seulement ?), puis dépose la tâche de la phase 3. C'est le seul endroit qui fait foi.
