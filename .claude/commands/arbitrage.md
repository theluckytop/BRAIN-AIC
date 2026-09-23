---
description: Estimer le coût d'une tâche et recommander le palier de modèle
argument-hint: [chemin du fichier de tâche]
allowed-tools: Bash(python3 ./.claude/outils/estimer.py:*), Read
---
Exécute `python3 .claude/outils/estimer.py $ARGUMENTS` et restitue, en cinq lignes au plus :

- la fourchette de coût du palier recommandé et le motif du classement ;
- le palier minimal suffisant ;
- la découpe conseillée (exploration au petit palier, puis exécution) si elle est rentable ;
- si le modèle courant est supérieur au palier recommandé, la commande exacte de bascule et
  l'économie estimée, **en proposition** : la bascule du modèle de session revient à l'humain ;
- si l'estimateur refuse de chiffrer, dis-le et indique ce qui manque.

Tu appliques seul la délégation au sous-agent `explorateur` : c'est l'économie qui ne demande
aucun accord. Pas de désescalade en cours de tâche, seulement à la clôture.
