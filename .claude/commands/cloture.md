---
description: Clôturer proprement une tâche
---
1. Délègue au sous-agent `verificateur` : verdict argumenté contre les critères de `travail/plan.md`.
2. Lance l'audit différentiel sur les fichiers modifiés (`/pentest` restreint à ces fichiers).
3. Si un constat critique est ouvert : ne propose aucun livrable, remonte-le en tête de `etat.md`
   et prépare la correction dans `humain/a_valider/`.
4. Sinon, prépare la proposition de livrable dans `humain/a_valider/` selon le modèle.
5. Ajoute les décisions à `memoire/decisions.md` et les leçons à `memoire/lecons.md`.
6. Ajoute l'entrée estimé/réel à `memoire/estimations.md`. Si dix relevés exploitables sont
   disponibles, propose dans `a_valider/` une mise à jour du coefficient de calibration.
7. Compare le modèle courant au palier requis par la tâche suivante : s'ils diffèrent, propose
   la commande de retour. S'ils correspondent, ne dis rien.
8. Mets `humain/etat.md` à jour et vide `travail/brouillons/`.
