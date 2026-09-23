# versions/update/
Dépose ici l'archive `.zip` d'une nouvelle version de BRAINIAC. Rien ne s'applique tout seul.

```bash
python3 .claude/outils/mettre_a_jour.py --etat
python3 .claude/outils/mettre_a_jour.py versions/update/BRAINIAC_1.1.0.zip --je-confirme
```

Ce dossier est en **lecture seule pour l'agent** : une mise à jour modifie les règles qui
l'encadrent, c'est donc une décision humaine. L'agent peut signaler qu'une archive attend ici,
il ne peut ni la déposer, ni l'appliquer.

Avant d'appliquer, l'outil contrôle l'archive et son manifeste, archive l'état courant dans
`../historique/`, puis vérifie l'espace. Si l'autotest échoue, le retour en arrière est automatique.
