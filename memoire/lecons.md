# Leçons
Ajout uniquement. Relues au démarrage de chaque tâche. Format :

```
## AAAA-MM-JJ — titre court
- Symptôme :
- Cause réelle :
- Correctif :
- Règle :
```
---

## 2026-09-23 — Une option citée doit porter sa source exacte
- Symptôme : la proposition de phase 0 affirmait avoir vérifié `--permission-prompt-tool` par `claude --help`, qui n'en a pas d'entrée propre ; le verificateur l'a relevé.
- Cause réelle : fusion de deux sources (`--help` local et documentation en ligne) sous une seule mention « vérifié ».
- Correctif : chaque option est attribuée à sa source ; celle qui n'est pas dans `--help` est marquée « documentée, non vérifiée localement ». Le test `claude <option> -v` ne prouve rien : `-v` s'arrête avant la lecture des options.
- Règle : « vérifié » ne vaut que pour la source nommée ; une option cachée se prouve par une session réelle, jamais par `--version`.

## 2026-09-23 — Le garde-fou bloque les redirections qui contiennent « version »
- Symptôme : `garde_fou.sh` refuse avec « écrit dans une zone en lecture seule » des commandes qui écrivent dans `humain/etat.md` ou redirigent `2>&1`.
- Cause réelle : le motif `ecriture-zone-R` est insensible à la casse et contient `VERSION` ; tout texte après `>` qui comporte « version » ou « --version » déclenche le blocage.
- Correctif : écrire par Edit/Write, éviter `>`/`2>&1` dans une commande qui contient ce mot. Ne jamais toucher au hook.
- Règle : devant un refus du garde-fou sur une zone [W], chercher le motif en cause avant de réessayer, et passer par les outils d'édition.

## 2026-09-23 — Un `cd` dans le shell principal verrouille la session
- Symptôme : après `cd projet && npm create …`, le garde-fou refuse toute action (« lancé depuis …/projet »), y compris le `cd` de retour ; l'humain a dû taper `! cd` à la racine.
- Cause réelle : le répertoire courant du shell persiste d'un appel à l'autre, et le hook vérifie `pwd` avant tout.
- Correctif : ne jamais faire de `cd` nu ; passer par un sous-shell `( cd sous/dossier && … )`, `npm --prefix`, `cargo --manifest-path` ou `git -C`.
- Règle : chaque commande Bash doit laisser la session à la racine de BRAINIAC.

## 2026-09-23 — `npm view` est un accès réseau
- Symptôme : quatre `npm view` lancés pour lire des versions, alors que l'accord ne couvrait que `npm create`, `npm install` et `cargo`.
- Cause réelle : commande perçue comme une « simple lecture », alors qu'elle interroge le registre.
- Correctif : lire les versions dans `package-lock.json` et `Cargo.lock` après installation.
- Règle : toute commande qui touche un registre ou une URL passe par la liste d'accès accordée, mot pour mot.
