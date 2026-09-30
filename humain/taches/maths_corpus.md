# Application de maths — corpus de cours par niveau (CM2 à Terminale)

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/corpus/`, un script rejouable qui construit, en amont et en lecture seule sur le
réseau, un corpus de cours de maths par niveau (CM2, 6e, 5e, 4e, 3e, seconde, première, terminale),
chaque entrée portant sa source, sa licence et sa date de récupération. L'app n'y touche pas encore.

## Contexte
- Décisions de l'humain du 2026-09-29 (`humain/questions.md`) : niveaux issus des jeux officiels de
  data.education.gouv.fr (Licence Ouverte 2.0) ; contenu issu de Wikiversité/Wikibooks (CC BY-SA)
  et Coopmaths/MathALÉA (CC BY-SA) ; corpus en amont, lu en local par l'app plus tard.
- Repérage des API : `humain/questions.md`, entrée « résultat du repérage des API de cours ».
  Les jeux officiels ne donnent que des métadonnées et des liens vers des PDF, pas le texte.
- Priorité fonctionnelle : pas de /pentest sur cette tâche.

## Critères d'acceptation
- [ ] Script rejouable dans `projet/maths/corpus/`, sans installation hors outils déjà présents
      (python3 stdlib, node, git) ; il ne fait que des lectures réseau
- [ ] Pour chaque niveau : liste ordonnée de notions ; pour chaque notion, un extrait de cours et,
      si disponible, des exercices ; source officielle du niveau (arrêté, lien) citée
- [ ] Chaque entrée porte : URL source, licence, date de récupération, statut GÉNÉRÉE
- [ ] Format de sortie documenté (JSON) et lisible par l'app sans réseau ; taille relevée
- [ ] Rapport de couverture : notions trouvées par niveau, trous signalés (ex. CM2 peu couvert)
- [ ] Respect des conditions des sources (limite de 5 000 appels/jour de data.education.gouv.fr,
      politesse envers l'API MediaWiki : User-Agent identifiable, pauses entre requêtes)

## Hors périmètre
Modification de l'app, génération de contenu par IA, niveaux au-delà de la Terminale,
lecture des PDF ministériels ligne à ligne.
