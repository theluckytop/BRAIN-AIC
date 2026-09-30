# Application de maths — Parcours v2b : corpus L1 Math-info (programme, cours, partiels)

- **Priorité** : moyenne (après v2a)
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Construire dans `projet/maths/corpus/` le niveau « L1 Math-info » : programme (chapitres), cours et sujets d'examen
(partiels) issus de sources universitaires françaises publiques ; chaque source mène à un cours ou à un partiel.

## Contexte
- Dépend de v2a (schéma du corpus, onglet Cours, modale). Découpe décidée par l'humain le 2026-09-30 (réponse A).
- Accord : `validations.md`, ligne « maths_parcours_v2b.md » (réseau en lecture seule, sources universitaires françaises
  publiques, sans installation ni identifiants, 300 requêtes, cache relu avant tout appel, budget 5,00 USD).
- Chaque hôte consulté est consigné dans le corpus avec sa licence ; licence inconnue ou « NC » signalée, titres et
  liens seulement si la reprise du texte n'est pas permise. Rien d'inventé ; statut GÉNÉRÉE tant que non relu.

## Critères d'acceptation
- [ ] Niveau « L1 Math-info » dans `corpus.json` (schema_version incrémentée) : chapitres, cours, partiels
- [ ] Chaque chapitre : lien vers un cours ; partiels rattachés aux chapitres quand c'est établi
- [ ] Hôtes et licences consignés ; ≤ 300 requêtes, tous appels comptés relances comprises, cache relu d'abord
- [ ] `construire.py --hors-ligne` rejoue le résultat ; tests, fmt, build de l'app propres

## Hors périmètre
Autres niveaux du supérieur, code de l'app (v2a), comptes utilisateurs, déploiement, push.
