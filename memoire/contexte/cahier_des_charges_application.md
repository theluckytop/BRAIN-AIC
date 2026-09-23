# BRAINIAC Console — Cahier des charges de l'application de suivi

> Document indépendant. Le cahier des charges de l'espace BRAINIAC reste inchangé.
> L'application est un **client** de cet espace : elle occupe la place de l'humain, jamais celle de l'agent.
>
> Réalisation suggérée : en faire la première vraie tâche confiée à BRAINIAC, le dépôt étant placé dans `projet/`.

---

## 1. Ce que c'est

Une petite fenêtre, toujours ouverte à côté du travail, qui permet de **suivre un projet et de discuter avec lui**. Elle sert deux usages à la fois :

- un **tableau de bord** qui lit `humain/` et montre en un coup d'œil où en est l'agent, ce qu'il attend et ce qu'il a consommé ;
- une **discussion** qui pilote une vraie session Claude Code dans le dossier du projet, avec entrée texte, captures d'écran et liens, et sortie texte, code, diagrammes ou maquettes.

Plusieurs projets sont suivis, choisis dans un sélecteur.

**Nom de travail** : BRAINIAC Console. À renommer librement.

---

## 2. Principe directeur : l'application est l'humain

C'est la règle dont tout le reste découle. L'agent est déjà encadré par les permissions, les hooks et le budget de son espace. L'application ne doit surtout pas devenir une seconde porte d'entrée qui contournerait ces garde-fous.

Concrètement :

- Elle écrit **uniquement** dans `humain/taches/` (et son sous-dossier `pieces_jointes/`), `humain/taches/validations.md`, `humain/questions.md` pour les réponses, et dans sa propre configuration.
- Elle **ne touche jamais** à `.claude/`, `.codex/`, `ressources/`, `memoire/`, `journal/`, `projet/`, `livrables/`, `travail/`, `quarantaine/`. Elle les lit, c'est tout.
- Elle ne lance **jamais** la session avec une option qui désactive les permissions ou les hooks. C'est un interdit absolu, y compris « juste pour tester ».
- Elle ne stocke **aucune clé d'API** : la session hérite de l'authentification de l'outil déjà installé sur la machine.

---

## 3. Contraintes techniques

- **Cœur en Rust, interface en JS** : Tauri. Vérifie la version majeure actuelle et sa documentation avant d'écrire du code ; n'invente aucune API.
- Interface : Vite avec TypeScript, et un framework léger au plus (Svelte ou équivalent). **Pas de bibliothèque de composants** : l'esthétique est écrite à la main, selon la section 7.
- **Fenêtre translucide** : fenêtre transparente avec fond teinté sombre. Attention, le flou d'arrière-plan n'est pas garanti sous Linux : il dépend du compositeur, KDE le propose, GNOME non. Traite donc la translucidité comme un **agrément dégradable** — teinte semi-transparente si le compositeur suit, surface opaque sinon — et prévois un réglage pour la désactiver. L'application ne doit jamais devenir illisible à cause de ce qui se trouve derrière elle.
- L'agent tourne **sur la même machine** que l'application, lancé comme processus enfant.
- Démarrage de la fenêtre en moins de deux secondes. Fenêtre utilisable à partir de 420 pixels de large.
- Dépendances Rust minimales, à confirmer : `tauri`, `serde`, `serde_json`, `tokio`, `notify` pour la surveillance de fichiers, `anyhow`, `chrono`. Toute autre dépendance doit être justifiée.
- Aucun envoi de données vers un service tiers autre que celui qu'utilise déjà l'outil en ligne de commande.

---

## 4. Fonctionnalités

### 4.1 Sélecteur de projets

Un projet est un dossier valide, c'est-à-dire contenant `AGENTS.md`, `.claude/` et `humain/`. L'application refuse d'ajouter un dossier qui ne remplit pas ces conditions, en expliquant ce qui manque.

La liste est stockée dans la configuration de l'application (dossier de configuration standard du système), avec pour chaque entrée : nom affiché, chemin, couleur d'accent, date de dernière ouverture. Le sélecteur est toujours visible en haut de la fenêtre, avec la couleur du projet courant, pour éviter toute confusion entre deux projets ouverts.

Si un projet devient introuvable, il apparaît grisé, jamais supprimé en silence.

### 4.2 Onglet « Suivi »

Lecture seule, rafraîchi automatiquement par surveillance des fichiers, avec anti-rebond d'environ 200 millisecondes.

- **État** : rendu de `humain/etat.md` en tête de fenêtre, avec l'horodatage de la dernière modification et un indicateur visuel si le fichier n'a pas bougé depuis longtemps alors qu'une session tourne.
- **Questions en attente** : entrées de `humain/questions.md` dont la ligne `Réponse :` est vide. Chacune dispose d'un champ de réponse ; valider **ajoute** la réponse à la suite dans le fichier, sans jamais réécrire l'existant.
- **À valider** : liste des fichiers de `humain/a_valider/`, avec leur contenu rendu et deux boutons, *Approuver* et *Refuser*, plus un champ de commentaire. La décision ajoute une ligne à `humain/taches/validations.md` au format prévu par l'espace. Le fichier de proposition n'est pas modifié : c'est l'agent qui en tirera les conséquences.
- **Budget et modèle** : lecture de `ressources/budget.yaml` et de `journal/.compteurs.json` ; affichage de la durée écoulée, du nombre d'actions, des échecs consécutifs, du modèle courant et du modèle nominal tels que déclarés dans `etat.md`. Barre de progression qui change de couleur aux seuils.
- **Activité** : les trente dernières lignes de `journal/actions.log`, avec les lignes bloquées mises en évidence, et un compteur des actions refusées sur la session.
- **Mémoire** : les cinq dernières entrées de `memoire/lecons.md` et de `memoire/decisions.md`, en accès repliable.

### 4.3 Onglet « Discussion »

Pilote une session de l'outil en ligne de commande lancée dans le dossier du projet.

- **Démarrage** : processus enfant lancé avec le répertoire de travail du projet, en mode sans interface, avec entrée et sortie en flux JSON. **Vérifie les options exactes** (`--help` et documentation) avant de coder, et centralise-les dans un module unique pour qu'un changement d'options ne casse qu'un fichier.
- **Reprise** : l'identifiant de session est conservé par projet, pour reprendre la conversation au lancement suivant. L'utilisateur peut aussi démarrer une session neuve.
- **Affichage** : messages en flux, appels d'outils repliés par défaut sous une ligne résumée (`Lecture de src/auth.rs`), réponses en Markdown, blocs de code colorés avec bouton de copie, diffs lisibles en deux couleurs.
- **Interruption** : un bouton arrête proprement la génération en cours ; un second arrête la session.
- **Bouton « Au fait »** : envoie un message annexe pendant que l'agent travaille, via la commande prévue à cet effet par l'outil. Cette commande n'existe pas dans toutes les versions : détecte sa disponibilité au démarrage et, à défaut, mets simplement le message en file d'attente en le signalant à l'utilisateur.
- **Approbations** : si la version permet de router les demandes d'autorisation vers l'application, affiche-les dans la fenêtre avec le détail de l'action. Si ce n'est pas possible, **ne contourne rien** : indique clairement que l'action est en attente et renvoie l'utilisateur vers le circuit asynchrone de l'onglet Suivi. Ce point doit être tranché par vérification, pas par supposition, et le résultat figurer dans le rapport.
- **Une seule session par projet.** Un fichier de verrou dans la configuration de l'application empêche d'en ouvrir deux. Si une session tourne déjà dans un terminal, l'application le signale au lieu d'entrer en concurrence.

### 4.4 Entrées : texte, captures, liens

- **Barre de saisie** multiligne, envoi au clavier, historique des messages précédents.
- **Captures d'écran** : par glisser-déposer ou collage depuis le presse-papiers. Le fichier est enregistré dans `humain/taches/pieces_jointes/AAAA-MM-JJ_hhmm_nom.png` et le message transmis référence **le chemin**, que l'agent sait lire. Une vignette apparaît dans la conversation.
- **Liens** : collés tels quels dans le message. Rappelle dans l'interface que la consultation d'un lien demande une autorisation, puisque l'accès réseau relève des actions soumises à accord.
- **Transformer en tâche** : un bouton sur n'importe quel message compose un fichier dans `humain/taches/` au format du modèle de l'espace, prérempli avec le contenu et les pièces jointes. C'est le pont entre la discussion informelle et le travail cadré.

### 4.5 Sorties : texte et exemples visuels

L'agent ne génère pas d'images. Il produit en revanche du SVG, du HTML, des diagrammes Mermaid et des maquettes, et c'est cela qu'il faut savoir afficher.

- Rendu Mermaid dans la conversation.
- **Panneau d'aperçu** pour les fichiers HTML et SVG produits dans `travail/brouillons/` ou `livrables/`, affichés dans un cadre isolé avec une politique de sécurité stricte : pas d'accès réseau, pas d'accès au système de fichiers, pas d'accès à l'application. Tout contenu produit par l'agent est traité comme non fiable.
- Le Markdown affiché est assaini avant rendu.
- Bouton pour ouvrir le fichier concerné dans l'application système par défaut.

---

## 5. Réalisation

**Phase 0 — Plan.** Vérifie les versions disponibles de Tauri, de l'outil en ligne de commande et de ses options de flux JSON. Présente le plan, la liste des dépendances et les points à vérifier. **Attends l'accord.**

**Phase 1 — Coquille.** Application Tauri qui démarre, fenêtre translucide avec son repli opaque, palette et typographie de la section 7, logo vectorisé et ses trois variantes, sélecteur de projets avec validation des dossiers, configuration persistante.

**Phase 2 — Suivi en lecture.** Lecture et rendu de `etat.md`, `questions.md`, `a_valider/`, compteurs, journal, mémoire. Surveillance des fichiers.

**Phase 3 — Écritures humaines.** Réponses aux questions, approbations et refus, création de tâches. Chaque écriture est en ajout, jamais en écrasement, et est testée.

**Phase 4 — Discussion.** Lancement, flux, reprise, interruption, message annexe, gestion des demandes d'autorisation selon ce que la version permet réellement.

**Phase 5 — Pièces jointes et aperçu.** Captures, liens, rendu Mermaid, panneau d'aperçu isolé.

**Phase 6 — Empaquetage.** Icône, bundles pour le système visé, entrée dans la bibliothèque d'applications, vérification qu'elle se lance depuis le lanceur. Signale ce qui relève de la signature ou de la notarisation sans y toucher.

**Phase 7 — Rapport.** Résultats des tests, écarts, points non vérifiables, actions restant à l'humain.

---

## 6. Tests d'acceptation

| # | Situation | Attendu |
|---|---|---|
| 1 | Ajout d'un dossier sans `AGENTS.md` | refus avec motif explicite |
| 2 | `etat.md` modifié depuis l'extérieur | affichage rafraîchi en moins d'une seconde |
| 3 | Réponse à une question | contenu précédent de `questions.md` intact, réponse ajoutée |
| 4 | Approbation d'une proposition | une ligne ajoutée à `validations.md`, fichier de `a_valider/` inchangé |
| 5 | Tentative d'écriture hors des zones autorisées | impossible par construction, test unitaire à l'appui |
| 6 | Capture collée | fichier créé dans `pieces_jointes/`, chemin présent dans le message |
| 7 | Session lancée alors qu'une autre tourne | refus et message clair |
| 8 | Arrêt de la génération en cours | processus enfant arrêté proprement, pas de processus orphelin |
| 9 | Fermeture de la fenêtre pendant une génération | aucun processus résiduel |
| 10 | Projet supprimé sur le disque | entrée grisée, application stable |
| 11 | Fichier HTML malveillant dans `livrables/` | aucun accès réseau ni système depuis l'aperçu |
| 12 | Fenêtre réduite à 420 pixels | interface utilisable |
| 13 | Recherche dans le code de toute option désactivant les permissions | aucune occurrence |
| 14 | Compositeur sans flou d'arrière-plan | fenêtre lisible, repli opaque automatique |
| 15 | Translucidité désactivée dans les réglages | aucun défaut de contraste |
| 16 | Logo affiché à 16, 32, 128 et 512 pixels | variante adaptée, jamais de détail illisible |
| 17 | `prefers-reduced-motion` actif | animations supprimées, indicateur d'activité statique |
| 18 | Contraste des textes sur fond translucide | conforme au niveau AA |
| 19 | Police système absente | police embarquée utilisée, rendu identique |

---

## 7. Identité visuelle et expérience

### Direction

Minimaliste, futuriste, un peu extraterrestre. Sombre par défaut, presque noir, avec un vert acide utilisé **par petites touches** et du rouge réservé aux alertes. L'effet recherché vient du vide et de la lumière, pas de l'accumulation d'éléments décoratifs.

### Logo

Le fichier fourni (`assets/logo_brainiac.png`) est la référence : crâne stylisé à tentacules mécaniques, vert pâle sur noir, œil central et regard rouge.

- **Vectorise-le en SVG** avant toute chose. Le PNG ne tiendra pas la route en icône de 16 ou 32 pixels, ni sur un écran à haute densité.
- Produis **trois variantes** : complète avec tentacules pour l'écran d'accueil et le grand format ; simplifiée, crâne seul, pour les tailles réduites ; monochrome d'un seul trait pour la barre de titre et les indicateurs. Sous 32 pixels, les tentacules deviennent une bouillie : c'est la variante simplifiée qui sert.
- Le logo ne se déforme pas, ne se recolore pas, ne tourne pas. Il n'apparaît qu'à l'accueil, dans l'icône système et, en tout petit, dans la barre de titre.
- L'œil central peut servir d'**indicateur d'activité** : éteint au repos, vert pulsant lentement quand une session travaille, rouge quand une action a été bloquée ou qu'une validation attend. C'est le seul endroit où une animation est justifiée en continu.

### Palette

Dérivée du logo, à ajuster finement lors de l'intégration :

| Rôle | Valeur indicative |
|---|---|
| Fond de fenêtre | noir profond, translucide (`#05070A` à 82 % d'opacité) |
| Surface (cartes, panneaux) | `#0E1412`, bordure `#1C2622` |
| Texte principal | `#E6EFE2` |
| Texte secondaire | `#8A9A8C` |
| Accent, actions, actif | vert acide `#7ED957` |
| Accent atténué, jalons | vert pâle `#C6DCA7` |
| Alerte, blocage, refus | rouge `#E8323C`, **jamais décoratif** |

Le vert ne sert qu'à une chose à la fois par écran : l'élément qui compte maintenant. S'il y a trois verts à l'écran, la hiérarchie est ratée.

### Typographie et rythme

- Une seule famille, sans empattement, avec chiffres à chasse fixe pour les compteurs. **Embarque le fichier de police** dans l'application : sur une Debian nue, il ne faut compter sur rien.
- Trois tailles au maximum par écran. Hiérarchie par la graisse et l'espacement, pas par la couleur.
- Espacement généreux, grille de 8 pixels, coins arrondis discrets et constants.
- Animations courtes, de 150 à 250 millisecondes, en sortie douce. Rien qui clignote, rien qui rebondit. `prefers-reduced-motion` et un réglage de transparence réduite sont respectés.

### Expérience : sobre et évidente

- **Une action principale par écran**, visible immédiatement. Le reste est secondaire et le montre.
- **Peu de mots.** Libellés de un à trois mots, à l'infinitif ou à l'impératif. Aucun jargon technique dans l'interface : pas de code d'erreur brut, pas de nom de fichier de configuration, pas de vocabulaire interne. Un message d'erreur dit ce qui s'est passé et quoi faire, en une phrase.
- **Dévoilement progressif** : l'essentiel d'abord, le détail sur demande. Les appels d'outils, les journaux et les traces sont repliés par défaut.
- **Pas de boîte de dialogue de confirmation**, sauf pour une action destructrice ou irréversible. Une approbation se donne d'un geste et s'annule tant qu'elle n'a pas été consommée.
- **États vides qui enseignent** : quand il n'y a rien à afficher, l'écran explique en une ligne ce qu'il montrera et propose l'action qui l'amorce.
- **Clavier** : raccourcis pour envoyer, interrompre, changer d'onglet et de projet. Tout ce qui se clique souvent se tape aussi.
- L'application se comprend sans documentation. Si une fonction a besoin d'être expliquée, c'est l'interface qu'il faut reprendre.

### Contrôle de qualité visuelle

Avant de déclarer un écran terminé, vérifie le contraste des textes, le rendu à 420 pixels de large, le rendu avec la translucidité désactivée, et le rendu du logo à 16, 32, 128 et 512 pixels.

---

## 8. Interdits

- Désactiver, contourner ou dupliquer les permissions et les hooks de l'espace.
- Écrire ailleurs que dans les zones humaines listées en section 2.
- Stocker une clé d'API ou un jeton dans l'application ou sa configuration.
- Écrire dans `journal/` : les traces de l'application vont dans son propre dossier de configuration.
- Inventer une option de ligne de commande ou une API Tauri sans l'avoir vérifiée.
- Ajouter une dépendance non justifiée dans le rapport.
- Déformer, recolorer ou animer le logo en dehors de l'indicateur d'activité décrit en section 7.
- Afficher du jargon technique, un code d'erreur brut ou un chemin de configuration dans l'interface.
- Multiplier les boîtes de confirmation, les info-bulles explicatives ou les messages d'accompagnement : si l'écran a besoin d'être commenté, il est à refaire.
- Rendre l'application dépendante d'un effet visuel que le compositeur pourrait ne pas fournir.
