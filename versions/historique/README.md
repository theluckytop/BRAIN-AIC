# versions/historique/
Archives `.zip` des états précédents, une par mise à jour ou restauration, plus `JOURNAL.md`.

Nom : `BRAINIAC_<version>_avant-maj_<AAAA-MM-JJ_hhmmss>.zip`

Contenu : tout l'espace, **sauf** le code de `projet/` (qui a son propre dépôt) et cet historique
lui-même. Mémoire, rapports d'audit, tâches et journal sont donc restaurables.

Revenir en arrière :

```bash
python3 .claude/outils/mettre_a_jour.py --restaurer versions/historique/<archive>.zip --je-confirme
```

Zone en **ajout uniquement** : une archive déposée ici n'est jamais réécrite. Au-delà de
`historique_max` (voir `ressources/versions.yaml`), la plus ancienne est supprimée.
