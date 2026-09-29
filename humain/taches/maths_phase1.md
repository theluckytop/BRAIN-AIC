# Application de maths — phase 1 : socle Leptos + Trunk

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Poser le socle de l'application décrite dans `humain/dossier-projet-maths/dossier/Cahier des charges.md` :
espace Cargo (`moteur` + `app`), Trunk, styles Tableau Pixel, polices locales, CSP, configuration Netlify.

## Contexte
- Référence : le cahier des charges et `humain/a_valider/2026-09-28_maths_phase0.md` (approuvée).
- Code dans `projet/maths/`, dépôt git propre.
- Design system : `humain/dossier-projet-maths/dossier/tableau-pixel.zip`.

## Critères d'acceptation
- [ ] `trunk build --release` réussit ; sortie dans `dist/`
- [ ] `cargo clippy --all-targets` : 0 avertissement ; `cargo fmt --check` propre
- [ ] `tokens.css` et `bundle.css` repris sans modification (empreintes identiques à l'archive)
- [ ] Aucune ressource chargée hors du site (CSP stricte, polices locales)
- [ ] Taille du WASM compressé relevée dans le rapport
- [ ] `netlify.toml` et `rust-toolchain.toml` présents, sans publication

## Hors périmètre
Moteur mathématique, composants, contenu, tout déploiement, tout `git push`.
