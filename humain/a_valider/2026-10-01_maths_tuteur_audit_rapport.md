# Proposition — 2026-10-01_maths_tuteur_audit_rapport

## Action proposée
Prendre acte de l'audit ciblé du tuteur Anthropic (0 critique, 0 élevé), approuver v3a et le README (commits `ba57024`, `31a3da5` dans `projet/maths`, locaux, non poussés), et trancher les points ci-dessous.

## Pourquoi
L'appel à `api.anthropic.com` n'avait jamais été audité (V3A-COUV-1). Rapport : `pentest/rapports/2026-09-30_235422_maths_tuteur_anthropic/` (`synthese.md` + `erratum_synthese.md`). Relecture de clôture `verificateur` : **CONFORME** (plan v3a), **CONFORME avec réserves mineures** (audit, corrigées par l'erratum). Rejoués : 109 + 55 tests, fmt, clippy natif et wasm32, `csp.mjs --verifier`, 0 `inner_html`. Non vérifié : appel Haiku réel, CSP en navigateur, `npm audit`/`cargo audit` (accord réseau absent). Sans décision, la clé reste exposée au modèle « navigateur direct » sans avertissement ni classement des données.

## Contenu exact
Décisions demandées (aucun diff) :
1. **Clé dans le navigateur** (CR-10 / ID-08, moyen) : garder le modèle (avertir l'utilisateur : clé dédiée, plafond, révocable) ou prévoir un relais serveur.
2. **Données d'élèves envoyées à Anthropic** (CR-12 / CR-13, moyen) : classer et déclarer à l'utilisateur ; point RGPD (public possiblement mineur).
3. **HSTS** (CR-06, moyen, indéterminé) : en-tête dans `netlify.toml`, ou exemption V3.4.1 étendue au site (l'existante vise Tauri).
4. **Exemptions** V6-V9 et crypto : textes dans `application_identite.md` (ID-09) et `application_crypto.md`, à écrire par toi dans `pentest/exemptions.md`.
5. **Accord réseau** `npm audit` / `cargo audit` (V15.2.1, moyen, indéterminé).
6. **Tâche de correction à déposer** dans `humain/taches/` : URL de base en liste blanche (TA-01, moyen), `masquer_cle` dans le chat (TA-02), bornes d'entrée/réponse (TA-04 à 06), bouton « Oublier la clé » (ID-06). Fichiers : `api.rs`, `appel.rs`, `tableau_chat.rs`.
7. Bandeau v3a : invite fixe « Génère un énoncé pour cette notion. » tant que Haiku n'a rien produit, acceptée ? (point 1 du rapport v3a).
Ligne d'approbation proposée : `| date | 2026-10-01_maths_tuteur_audit_rapport.md | APPROUVÉ | v3a et README acceptés ; décisions 1 à 7 : … |`

## Risques et réversibilité
- Risque : faible (documentation et audit par revue ; aucune correction de code faite).
- Réversible : oui, `git -C projet/maths revert 31a3da5 ba57024`.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
