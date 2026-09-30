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

## 2026-09-24 — Police embarquée : vérifier la couverture des glyphes
- Symptôme : ▾ ⚙ □ affichés dans l'interface alors qu'ils ne figurent pas dans le sous-ensemble latin d'Inter ; rendu confié en silence à une police système (test 19).
- Cause réelle : caractères Unicode employés comme icônes, sans vérifier le jeu de caractères de la police.
- Correctif : icônes en SVG ; contrôle par `fc-query -f '%{charset}'` sur le fichier de police et `git grep -P` des caractères hors plage.
- Règle : aucune icône sous forme de caractère ; tout texte affiché doit tenir dans le jeu de caractères de la police embarquée.

## 2026-09-24 — Une preuve annoncée doit exister sur le disque
- Symptôme : le rapport annonçait une recherche « jointe », mais le fichier faisait 0 octet et ne contenait pas la commande ; la capture du test 10 venait de données d'exemple sans que le rapport le dise.
- Cause réelle : rapport rédigé de mémoire, sans relire les fichiers de preuve.
- Correctif : chaque fichier de preuve contient la commande, la date et la sortie ; la provenance de chaque capture est écrite.
- Règle : avant de citer une preuve, l'ouvrir.

## 2026-09-24 — La durée de session compte aussi le temps d'attente de l'humain
- Symptôme : `/cloture` coupée par le hook (94 min > 90), alors que la dernière mesure donnait 66 min ; la pause entre deux messages humains a consommé le reste.
- Cause réelle : le hook mesure le temps réel depuis le début de la session, pas le temps de travail.
- Correctif : aucun dans cette session ; clôture à reprendre dans une nouvelle session.
- Règle : passé 60 min, finir la clôture avant de rendre la main ; ne jamais enchaîner deux phases dans une même session.

## 2026-09-24 — Les agents d'audit n'ont pas de shell : leur donner le diff
- Symptôme : l'audit différentiel n'a pas pu lancer `git diff` et a comparé par numéros de ligne, avec une limite déclarée.
- Cause réelle : `pentest_*` n'ont que Read, Grep, Glob, Write ; le prompt demandait un diff.
- Correctif : l'agent principal a lancé le diff et l'a versé dans `complement.md`.
- Règle : pour un audit différentiel, coller le diff dans le prompt de l'auditeur.

## 2026-09-24 — Un fichier `.log` de preuve est ignoré par git
- Symptôme : `*.log` figure dans le `.gitignore` du gabarit ; les journaux de lancement n'auraient pas été commités.
- Correctif : copies en `.txt` (README de provenance).
- Règle : nommer les preuves `.txt` d'emblée.

## 2026-09-24 — Récidive : un `cd` nu dans une commande de lecture
- Symptôme : `cd projet/brainiac-console && ls …` a verrouillé la session (garde-fou : « lancé depuis …/projet/brainiac-console ») ; le `cd` de retour était refusé lui aussi, ainsi que Edit.
- Cause réelle : `cd` écrit par réflexe en groupant des lectures, alors que la leçon du 2026-09-23 l'interdit. Une leçon lue au démarrage ne protège pas d'un réflexe.
- Correctif : l'humain a tapé `! cd /home/aouadon/BRAIN-AIC/BRAINIAC`. Aucun contournement de ma part.
- Règle : lire dans `projet/` par `ls chemin`, `git -C`, `--prefix` ou l'outil Read, jamais par `cd`, même pour une simple lecture.

## 2026-09-24 — Un test ne peut pas se dire « réel » s'il a été retouché
- Symptôme : `questions_extrait_reel` prétendait reproduire `humain/questions.md`, mais sa constante était modifiée ; la relecture a montré que le fichier réel donne 0 question en attente, pas 1.
- Cause réelle : extrait adapté pour obtenir le cas voulu, étiqueté « réel » sans le dire.
- Correctif : test renommé « synthétique », cas de la note « (Consigné par l'agent…) » ajouté.
- Règle : un jeu de données est « réel » seulement s'il est copié tel quel ; sinon « synthétique », dit en toutes lettres.

## 2026-09-24 — Les sous-agents écrivent un `cd` malgré l'interdiction du prompt
- Symptôme : les six `executant` et `verificateur` lancés ont chacun écrit un `cd` dans leur premier appel Bash, alors que la consigne l'interdisait (sans effet, leur shell étant réinitialisé).
- Cause réelle : réflexe de l'agent ; la règle vit dans mon contexte, pas dans le leur.
- Correctif : consigne répétée en tête de chaque prompt ; aucune conséquence cette fois.
- Règle : répéter la règle du `cd` en première ligne de tout prompt de sous-agent, et vérifier leurs rapports plutôt que de s'y fier.

## 2026-09-24 — Une preuve citée doit survivre au vidage des brouillons
- Symptôme : les rapports d'audit citent `travail/brouillons/phase2_diff.txt`, un espace jetable que `/cloture` vide.
- Cause réelle : diff déposé en brouillon pour le donner aux auditeurs, sans prévoir sa conservation.
- Correctif : copie dans `docs/preuves/phase2/diff_audite.txt` avant tout vidage.
- Règle : ce qu'un rapport cite est copié dans un lieu durable au moment où il est cité.

## 2026-09-28 — `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` ne protège pas d'un `cd` explicite
- Symptôme : `cd projet/maths/app && trunk build --release` a laissé le répertoire courant dans
  `app/` pour l'appel Bash suivant, alors que le réglage du 2026-09-24 (commit `972f10e`) est censé
  ramener le shell à la racine après chaque commande.
- Cause réelle : ce réglage rattrape la dérive *entre deux appels* de l'outil Bash, mais un `cd`
  suivi de `&&` dans la même commande déplace bien le répertoire pour la suite de cette commande-là ;
  je n'ai pas vérifié `pwd` avant de continuer, et l'appel suivant s'est retrouvé dans `app/`.
- Correctif : `cd` revenu manuellement à la racine ; les commandes suivantes de la phase ont utilisé
  un sous-shell `( cd chemin && commande )`, qui ne change pas le répertoire de l'appel Bash
  lui-même.
- Règle : le réglage du 2026-09-24 n'est pas un filet de sécurité contre un `cd` écrit dans la même
  commande. Toujours passer par un sous-shell `( cd … && … )`, jamais un `cd` nu même suivi d'un
  `&&`, et vérifier `pwd` après toute commande qui en contient un.

## 2026-09-28 — Récidive du `cd` nu, en préparant un script Python
- Symptôme : `cd projet/maths/moteur/src && python3 - <<EOF …` a laissé la session dans `src/` ;
  remarqué au retour de la commande, `cd` de retour immédiat.
- Cause réelle : le chemin relatif du script a appelé un `cd` par réflexe, une heure après avoir écrit
  la leçon précédente sur le même sujet. Troisième occurrence dans cet espace.
- Correctif : les scripts suivants ont ouvert leurs fichiers par chemin absolu.
- Règle : un script écrit en ligne ouvre ses fichiers par chemin absolu ; jamais de `cd` pour lui
  fournir un répertoire courant. Relire `pwd` après toute commande qui en contiendrait un.

## 2026-09-28 — Mesurer le « pire cas » demande de le chercher, pas de le supposer
- Symptôme : la preuve de phase 2 annonçait un pire cas de 5,6 ms ; la relecture a trouvé des saisies
  valides à 430 ms (debug), l'audit une autre piste de déni de service.
- Cause réelle : pire cas choisi à l'intuition (une saisie « longue »), sans raisonner sur ce qui
  maximise le coût (puissances élevées de facteurs distincts, opérations répétées sur de grands
  nombres) ; et une borne par nombre ne borne pas le nombre d'opérations.
- Correctif : budget de calcul global, pires cas des relecteurs ajoutés au programme de mesure.
- Règle : une exigence de temps sur une saisie non fiable se garantit par une borne de coût, puis se
  mesure sur des cas construits pour l'atteindre. « Pire cas raisonnable » ne vaut pas preuve.

## 2026-09-28 — Des règles au cas par cas ne convergent pas : fixer d'abord le sens de l'erreur
- Symptôme : deux relectures NON CONFORME de suite sur la forme simplifiée ; chaque correctif
  bouchait les cas cités et en ouvrait d'autres, jusqu'à sanctionner des réponses justes.
- Cause réelle : aucune décision préalable sur l'erreur acceptable (laisser passer un calcul non
  fait, ou sanctionner une réponse juste) ; les règles étaient écrites contre les exemples des
  relecteurs, pas contre un principe.
- Correctif : décision de l'humain (« jamais de sanction à tort ») avant tout nouveau code.
- Règle : devant une heuristique qui doit trancher, écrire d'abord quel type d'erreur est tolérable,
  puis tester la règle sur un grand nombre de cas aléatoires (comme l'a fait la relecture :
  14 258 expressions) avant de la soumettre.

## 2026-09-29 — Quatrième `cd` nu : `cd /tmp` pour lire les fichiers d'un relecteur
- Symptôme : `cd /tmp && wc -l verif2_*.txt …` en début de reprise ; sans effet cette fois (le
  réglage du commit 972f10e ramène le shell à la racine après chaque commande), `pwd` vérifié aussitôt.
- Cause réelle : des fichiers hors de l'espace (`/tmp/verif2_*`) ont semblé « hors règle » ; le
  réflexe du répertoire courant a pris le dessus sur la leçon, lue une heure avant.
- Correctif : lectures suivantes par chemins absolus ou par une variable (`S=…; $S/…`).
- Règle : l'interdiction du `cd` nu vaut pour tout répertoire, y compris `/tmp` et le bloc-notes ;
  pour plusieurs fichiers d'un même dossier, une variable de chemin plutôt qu'un `cd`.

## 2026-09-29 — Un correctif de fin de cycle doit borner sa règle à ce qu'il vise
- Symptôme : le refus des exposants négatifs (visant `(x^2+2x+1)^-1`) a refusé aussi
  `(1/2)^-1(x+1)` et `x^-1(x+1)`, formes justes ; relevé par la relecture et l'audit de clôture.
- Cause réelle : règle écrite sur le motif (`Pow(_, n<0)`) et non sur l'objet visé (une somme en `x`) ;
  pas de cas légitimes voisins dans les tests ajoutés.
- Correctif : condition restreinte à une base somme contenant `x`, trois cas légitimes ajoutés.
- Règle : tout refus ajouté s'accompagne, dans le même test, de ses voisins légitimes (même
  motif, autre base) ; sous le principe « jamais de sanction à tort », ce sont eux qui comptent.

## 2026-09-29 — Une CSP « conforme » par lecture n'est pas une app qui démarre
- Symptôme : en phase 3, premier vrai lancement dans Firefox : page blanche. La CSP de la phase 1
  (approuvée, auditée, `trunk build` OK) bloque le script inline d'amorçage de Trunk.
- Cause réelle : les preuves de la phase 1 étaient des lectures de configuration et un build ; aucune
  n'exécutait l'app dans un navigateur. Le pentest de configuration ne peut pas voir cela.
- Correctif : en attente de décision humaine (question du 2026-09-29).
- Règle : toute phase qui pose une CSP ou un en-tête est prouvée par un lancement réel (WebDriver
  headless : la page rend, texte lu). Ce test entre dans le critère de sortie de la phase 1 des
  projets suivants, et dans la phase 3 avant toute capture.

## 2026-09-29 — Le compteur de durée du garde-fou court depuis le début de la session, pas de la tâche
- Symptôme : arrêt du hook à 92 min alors que je comptais 60 min depuis le démarrage de la phase 3
  (14:03) ; l'agent `executant` des étapes 7-8 a été coupé en plein travail, avec des processus
  (geckodriver, serveurs locaux) restés ouverts et un clavier.txt d'un harnais bugué.
- Cause réelle : j'ai chronométré la tâche, pas la session ; la session comprenait la clôture de la
  phase 2 et deux relectures avant elle.
- Correctif : aucun contournement ; état consigné, arrêt.
- Règle : lire l'heure de démarrage de la SESSION (pas de la tâche) pour le budget ; en début de
  session, s'il reste moins de 60 min, ne lancer que des étapes qui tiennent, sans agent en tâche de
  fond qui ouvre des processus.

## 2026-09-29 — Un harnais qui échoue se diagnostique avant d'être blâmé ou contourné
- Symptôme : `clavier.py` donnait 14/20 puis 15/20 ; l'état de la session précédente attribuait déjà
  cela à « un harnais bugué ». Deux causes distinctes : une erreur de mon `pos()` (l'index 0 était exclu,
  T1a) et Firefox 149 headless qui reçoit keydown/keyup d'Entrée sur le bon bouton sans produire de `click`
  après certaines séquences (journal d'événements relevé ; un `click()` par script marche).
- Cause réelle : (1) bug de recherche dans mon script ; (2) comportement du navigateur piloté, cause
  non établie.
- Correctif : `pos()` corrigé ; page rechargée avant les trois scénarios touchés (20/20), la note de
  provenance dans `clavier.txt` dit le contournement et la réserve.
- Règle : devant un échec de preuve, isoler par bissection (script minimal, journal d'événements) et
  écrire dans la preuve ce qui a été contourné ; ne jamais citer un score sans cette note.

## 2026-09-29 — Le hash CSP suit le code : le rejouer après toute modification de l'app
- Symptôme : après la correction de `mesure.rs` et du Whiteboard, `csp.mjs --verifier` a échoué (attendu).
- Cause réelle : le script d'amorçage de Trunk cite le nom du `.js` haché, qui dépend du wasm.
- Correctif : `--ecrire`, rebuild, `--verifier`, puis toutes les preuves rejouées sur ce build.
- Règle : ordre fixe en fin de phase : code figé → build → `csp.mjs --ecrire` → build → preuves → commit.
  Toute retouche après cela recommence la chaîne.

## 2026-09-29 — « Cause démontrée » exige un témoin positif, des répétitions et le déclencheur isolé
- Symptôme : j'ai écrit « CAUSE DÉMONTRÉE » sur une seule exécution d'une page statique dont la séquence
  différait de celle qui échouait dans l'app ; la 2e relecture l'a refusé (NON CONFORME).
- Cause réelle : un seul échec reproduit, sans page témoin, sans compteur d'événements, sans isoler l'étape
  nécessaire. Mon premier script de page statique avait même une séquence qui ne déclenchait rien.
- Correctif : expérience refaite (témoin t=0, 3 répétitions, événements comptés, 3 voies) : le déclencheur est
  l'envoi préalable de Tab par le pilote ; la note dit ce qui est établi et ce qui ne l'est pas.
- Règle : une cause ne s'écrit « démontrée » qu'avec un témoin positif, ≥ 3 répétitions, le déclencheur isolé et
  la sortie brute archivée ; sinon « hypothèse étayée ».

## 2026-09-29 — Rendre la main sur une question en fin de session laisse filer le compteur
- Symptôme : question d'escalade posée à ≈ 45 min ; l'humain a répondu plus tard, le garde-fou a refusé
  toute action (189 min > 90). `/cloture` n'a pas pu être lancée.
- Cause réelle : même cause que la leçon du 2026-09-24 (le hook compte le temps réel, attente comprise) ;
  j'ai rendu la main sans prévenir que la réponse devrait être traitée en nouvelle session.
- Correctif : réponse A consignée, `etat.md` à jour ; clôture reportée à une nouvelle session.
- Règle : toute question posée après 30 min de session dit explicitement que la suite se fera en nouvelle
  session, et l'`etat.md` est laissé prêt pour cette reprise avant de rendre la main.

## 2026-09-29 — Une preuve datée avant le dernier changement de code n'est pas une preuve du build final
- Symptôme : la relecture finale relève `taille_wasm.txt` (15:08) et des temps cités (13 ms, « 11 à 14 ms »)
  antérieurs aux correctifs de 15:16-15:19, alors que le README affirmait « toutes rejouées sur le build final ».
- Cause réelle : la chaîne « code figé → build → hash → preuves » (leçon du même jour) n'a pas été suivie
  pour toutes les preuves ; certains chiffres venaient d'exécutions non archivées.
- Correctif : erratum de clôture, taille remesurée sur le build final, temps ramené au seul fichier archivé.
- Règle : avant de citer un chiffre, comparer l'heure du fichier de preuve à celle du dernier commit de code
  (`ls -l --time-style` contre `git log -1 --format=%ci`) ; un chiffre sans fichier archivé ne se cite pas.

## 2026-09-29 — Une évolution lourde lancée dans une session déjà expirée n'aboutit à rien
- Symptôme : sous-agent lancé pour une évolution de l'app (clé API, responsivité, captures) : refus du hook
  dès le premier appel Bash (103 min > 90) ; aucun travail possible.
- Cause réelle : le compteur court depuis le début de la session, attente de l'humain comprise (déjà noté
  les 2026-09-24 et 2026-09-29) ; la demande a été déléguée sans vérifier le temps restant.
- Correctif : aucun contournement ; état et question consignés, arrêt.
- Règle : avant de déléguer une tâche longue, vérifier le temps de session écoulé ; au-delà de 60 min,
  la lancer en nouvelle session plutôt que d'empiler.

## 2026-09-30 — `trunk serve` donne une page blanche avec la CSP de l'app maths
- Symptôme : app lancée par `trunk serve` (commande du README) : page entièrement blanche.
- Cause réelle : la CSP de `index.html` n'autorise que le hash du script d'amorçage du build **release** ; le build
  de dev cite un autre `.js` haché et ajoute un script de rechargement : les deux sont bloqués, le wasm ne démarre
  pas. En plus, `trunk serve` réécrit `dist/` avec ce build de dev.
- Correctif : `trunk build --release`, `node scripts/csp.mjs --verifier` (OK), puis service statique de `dist/`
  (`python3 -m http.server --directory projet/maths/app/dist`).
- Règle : pour montrer l'app maths, servir le build release vérifié, jamais `trunk serve` ; corriger le README.

## 2026-09-30 — maths_corpus 5d : plafond d'appels réseau dépassé (≈ 510 pour ~350)
- Symptôme : passe de recherche Wikiversité lancée deux fois en mode réseau ; ≈ 510 tentatives au total.
- Cause réelle : en mode réseau, `construire.py` rejouait tous les appels sans relire le cache ; chaque relance
  refaisait les ~170 appels de base. Le compteur d'appels ne couvrait que la passe nouvelle.
- Correctif : requêtes déjà en cache jamais rejouées ; `MAX_RECHERCHES = 0` sans nouvelle décision (commit f2ba25e).
- Règle : tout script réseau lit son cache d'abord et compte **tous** les appels de l'exécution contre le plafond,
  relances comprises ; la consigne au sous-agent l'exige explicitement.
