# Application de maths — phase 3bis : écran de séance centré sur le whiteboard, chat Haiku (local)

- **Priorité** : haute
- **Autonomie accordée** : seul
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/`, corriger la direction de l'app (demande de l'humain, 2026-09-29) :
écran de séance unique = AppShell + ConsigneCard (énoncé) au-dessus du Whiteboard (entrée principale) ;
bouton VALIDER qui envoie le dessin à Claude Haiku ; second onglet rattaché au whiteboard = chatbot qui
affiche la réponse ; clé API saisie à la main, en local. Supprimer le bloc « Exercices (moteur relié) ».

## Contexte
- Décisions de l'humain : `humain/questions.md` (2026-09-29, réorientation) ; plan : `humain/a_valider/2026-09-29_maths_reorientation.md`.
- Réponse de Haiku, structure fixe : « ce que j'ai compris » (recopie de la réponse) / pertinence (dessin hors sujet dit
  explicitement, jamais compté comme faute) / éléments de réponse / source.
- Priorité de l'humain : **fonctionnalité, pas sécurité** (application locale). Pas de `/pentest` sur cette tâche ; la clé
  reste hors du dépôt (mémoire de l'onglet), la CSP n'est ouverte que vers l'origine de l'API.
- Corpus par API : **hors périmètre** (question ouverte). Énoncés fixes en attendant.

## Critères d'acceptation
- [ ] L'écran de séance ressemble à la description : énoncé dans le bandeau, whiteboard dessous, onglet chat rattaché
- [ ] Saisie manuelle de la clé ; sans clé, message clair et aucun appel
- [ ] VALIDER envoie l'image du dessin à Haiku et affiche la réponse structurée dans le chat ; échec réseau géré
- [ ] Le chat permet de poser une question de suite ; texte seul
- [ ] `trunk build --release`, tests, clippy `-D warnings`, fmt propres ; app lancée en local et observée

## Hors périmètre
Corpus et API de cours, déploiement, tout pentest, `moteur/`.
