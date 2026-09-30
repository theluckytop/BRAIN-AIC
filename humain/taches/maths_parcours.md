# Application de maths — fenêtre « Parcours » et parcours par niveau

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/`, choisir un niveau depuis le menu ☰ → « Parcours » (fenêtre modale) ;
le parcours de ce niveau, lu dans le corpus de `maths_corpus.md`, fournit les énoncés du bandeau ;
Haiku reçoit l'extrait de cours de la notion courante et cite sa source.

## Contexte
- Dépend de `maths_corpus.md` : ne démarre qu'une fois le corpus livré et approuvé.
- Décisions de l'humain du 2026-09-29 : modale dans l'app ; niveaux CM2 à Terminale ;
  aucune API appelée à l'exécution.
- L'app actuelle (phase 3bis) : écran de séance, whiteboard, chat Haiku, mode sombre, scrollbars ;
  la responsivité et la clé API persistante auront été faites avant.
- Priorité fonctionnelle, application locale : pas de /pentest sur cette tâche.

## Critères d'acceptation
- [ ] Menu ☰ → « Parcours » : modale accessible (clavier, Échap, focus rendu à la fermeture),
      utilisable sur téléphone, liste des 8 niveaux avec leur source officielle
- [ ] Choisir un niveau change les énoncés du bandeau (ConsigneCard) selon le parcours
- [ ] Le niveau choisi et l'avancement sont conservés dans le navigateur
- [ ] Haiku reçoit l'extrait de cours de la notion courante et cite une source réelle
- [ ] Chaque notion affiche son statut GÉNÉRÉE ou RELUE
- [ ] `trunk build --release`, tests, clippy `-D warnings`, fmt propres ; app observée en local

## Hors périmètre
Constitution du corpus (tâche précédente), génération de parcours pour n'importe quelle cible
(vague 2), comptes utilisateurs, déploiement.
