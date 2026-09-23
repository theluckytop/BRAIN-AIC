# Déployer BRAINIAC

## En une commande

Dans le dossier `BRAINIAC` issu de l'archive :

```bash
bash install.sh
```

Le script vérifie l'environnement Debian, contrôle l'intégrité de l'archive et des référentiels de
sécurité, rend les scripts exécutables, éprouve les réflexes sur une copie jetable et lance le
diagnostic. Il n'écrase aucun contenu existant : relancer est sans danger.

## Par Claude Code

```bash
claude "Lis DEPLOIEMENT.md et exécute-le, puis rends-moi compte."
```

## Ce que l'agent doit faire, et rien de plus

1. `bash install.sh` et restituer le verdict.
2. Confronter `.claude/settings.json` et `.claude/hooks/` à la documentation **actuelle** de Claude
   Code : noms des événements de hook, syntaxe des règles de permissions, format d'en-tête des
   sous-agents et des commandes. C'est le seul point que l'archive ne peut pas garantir, puisque la
   syntaxe évolue. Tout écart est **signalé**, jamais corrigé en silence.
3. Vérifier si `.codex/config.toml` est pris en compte au niveau du projet par la version installée.
   Sinon, indiquer comment l'appliquer.
4. Ne rien créer, ne rien réécrire d'autre. L'archive est complète et testée.

## Ce qui reste à l'humain

- **Tarifs** : renseigner les prix dans `ressources/arbitrage.yaml` et la date de relevé.
  Sans eux l'estimateur refuse de chiffrer, c'est volontaire.
- **Protection système**, facultative mais recommandée :
  ```bash
  chmod a-w AGENTS.md CLAUDE.md ressources/*.yaml .claude/settings.json
  chmod -R a-w .claude/hooks .claude/outils pentest/referentiels
  ```
- **Redémarrer Claude Code** après l'installation : hooks et permissions sont lus au démarrage.
- Déposer le code dans `projet/` et la première tâche dans `humain/taches/`.

## Mettre à jour plus tard

Dépose l'archive de la nouvelle version dans `versions/update/`, puis :

```bash
python3 .claude/outils/mettre_a_jour.py --etat
python3 .claude/outils/mettre_a_jour.py versions/update/<archive>.zip --je-confirme
```

L'état courant est archivé dans `versions/historique/` avant toute modification. Seule la mécanique
est remplacée : mémoire, journal, tâches, rapports d'audit et réglages de `ressources/` sont
conservés, la nouvelle configuration arrivant à côté en `.nouveau`. Si l'autotest échoue après
application, le retour en arrière est automatique et l'archive refusée.

Revenir en arrière à tout moment :

```bash
python3 .claude/outils/mettre_a_jour.py --restaurer versions/historique/<archive>.zip --je-confirme
```

L'agent ne lance jamais ces commandes : elles réécrivent ses propres garde-fous. Il se contente de
signaler dans `humain/etat.md` qu'une archive attend.

## Vérifier à tout moment

```bash
bash .claude/outils/verifier.sh   # état de l'environnement et de l'intégrité
bash .claude/outils/autotest.sh   # 44 contrôles des réflexes, sur copie jetable
```

Après un déplacement du dossier ou une copie sur une autre machine, ces deux commandes sont le
premier réflexe.
