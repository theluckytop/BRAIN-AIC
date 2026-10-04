# Maths — Bouton menu qui recouvre le contenu, taille de police réglable (A− / A+) et zoom

À copier dans `humain/taches/maths_ui_menu_police.md`, avec une ligne dans `validations.md` (aucun réseau, aucune installation, API Claude inchangée, plafond de 5,00 USD).

- **Priorité** : normale
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
1. Le bouton menu (☰, en haut à gauche) ne recouvre plus aucun contenu : il a son propre espace (barre d'en-tête) ou le contenu est décalé.
2. Le texte est lisible : réglage A− / A+ dans l'interface, et le zoom du navigateur (200 %) ne casse pas la mise en page.

## Contexte
Retour de l'humain (2026-10-04, onglet Cours) : le ☰ masque le début du titre (« …et raisonnements ») et la première étiquette (« …CE » à côté de DOUTEUX et SOMMAIRE SEUL) ; texte petit, police à chasse fixe sur fond sombre, lecture fatigante. Constaté aussi par l'observation L1 (captures `docs/preuves/l1_phase1/observation/`, 1280 et 420 px) et en Terminale : le défaut est antérieur à L1. Recoupe la v3c (`maths_parcours_v3c_TACHE_A_COPIER.md`, mise en page du chat) : à traiter ensemble ou à ordonner.
Code probable : `app/public/composants.css`, `composants/app_shell.rs` (ou équivalent), `tableau_chat.rs`. Ne pas modifier `tokens.css` : la taille se règle par un facteur sur la taille racine ou par une classe sur le conteneur de l'app (à vérifier).

## Critères d'acceptation
- [ ] Aucun élément n'est recouvert par le ☰ à 1280, 768, 420 et 360 px, clair et sombre (mesuré : rectangles du bouton et du contenu disjoints), sur l'onglet Cours, le chat, le Parcours.
- [ ] Le ☰ reste atteignable au clavier et cliquable (cible ≥ 44 px).
- [ ] Texte long en police lisible (famille mesurée dans le navigateur, pas de chasse fixe), titres, boutons et étiquettes en thème pixel ; contraste 0 échec.
- [ ] Boutons A− / A+ (3 à 5 crans, valeur conservée en `localStorage`, tolérant si absent) ; texte des énoncés, du cours et du chat agrandi ; aucun débordement horizontal à 1280 et 420 px au cran maximal.
- [ ] Zoom navigateur 200 % : mise en page utilisable (observé, 1280 px équivalent 640 px).
- [ ] Tests, fmt, clippy natif et wasm32, `contraste.mjs`, `csp.mjs --verifier` verts ; `tokens.css`, `Cargo.toml`, `Cargo.lock` inchangés ; 0 `inner_html` ; relecture `verificateur` CONFORME.

## Hors périmètre
Changer la police des titres et boutons (thème pixel gardé), figures du chat (v3c, traitée après cette tâche), push, déploiement.

## Décisions de l'humain (2026-10-04)
- Police : **B** — police lisible (sans chasse fixe, police système, pas de nouvelle police téléchargée) pour le texte long (énoncés, cours, extraits, chat, sources) ; thème pixel gardé pour titres, boutons et étiquettes. Règle locale dans `composants.css`, `tokens.css` inchangé.
- Ordre : **A** — cette tâche seule, avant v3c.

## Estimation indicative
`estimer.py` surévaluera (périmètre `projet/` entier). Ma fourchette : 1 à 2,5 USD, palier sonnet.
