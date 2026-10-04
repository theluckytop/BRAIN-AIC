# Maths — Parcours v3c : mise en page du chat et accessibilité du tableau défilant

À copier dans `humain/taches/maths_parcours_v3c.md`, avec une ligne dans `validations.md` (aucun réseau, aucune installation, API Claude inchangée, plafond 5,00 USD).

- **Priorité** : normale
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
Rendre la zone des messages du chat assez haute pour afficher une figure entière, et rendre la zone défilante d'un tableau utilisable au clavier.

## Contexte
Suite de v3b-T (taille des figures, relecture CONFORME). À 1280x814 la zone des messages ne fait que ≈ 165 px (panneau de clé API, énoncé et saisie occupent le reste) : une figure de 270 px y est rognée. La zone défilante d'un tableau n'a ni `tabindex`, ni `role`, ni `aria-label`. La légende d'un petit tableau passe sur deux lignes. Code : `app/public/composants.css`, `chat-couleurs.css`, `composants/texte_math.rs`, `tableau_chat.rs`. Prérequis : v3b approuvée et commitée.
Réponse de l'humain (2026-10-01) : A pour les trois points.

## Critères d'acceptation
- [ ] À 1280x814, 768, 420 et 360 px, la zone des messages affiche une figure de 270 px de haut sans la rogner (mesuré, clair et sombre) ; le panneau de clé API est repliable.
- [ ] La zone défilante d'un tableau a `tabindex="0"`, `role="region"` et un `aria-label` ; le focus clavier est visible et le défilement fléchable (observé).
- [ ] Légende d'un petit tableau sur une ligne à 1280 px, ou retour à la ligne sans rognage (mesuré).
- [ ] Tests, fmt, clippy natif et wasm32, `contraste.mjs`, `csp.mjs --verifier` verts ; `tokens.css`, `Cargo.lock` inchangés ; 0 `inner_html` ; relecture `verificateur` CONFORME.

## Hors périmètre
Corrections de l'audit du tuteur, v2b, tout autre écran que le chat, push.
