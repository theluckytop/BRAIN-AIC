# Cahier des charges — Application d'apprentissage mathématique

27 septembre 2026

## Contexte et vision

Le projet vise une application web où un adulte autodidacte progresse en maths en résolvant des exercices à la main, sur un tableau blanc, guidé étape par étape. La promesse : comprendre pourquoi une solution est juste, pas seulement comment l'obtenir.

C'est un projet personnel, mené par un développeur débutant pour apprendre. Le périmètre est donc découpé en petites vagues livrables, chacune utilisable seule.

**Contraintes techniques :** publication sur Netlify, technologies web uniquement, et interface écrite en Rust, compilée en WebAssembly, pour la rapidité d'exécution (voir « Architecture et stack technique »).

Deux ajustements par rapport au brief initial :

- **Khan Academy ne peut pas être une source de contenu.** Son API publique a fermé en 2020 et son contenu est sous licence non commerciale. Le contenu pédagogique sera rédigé pour l'app, avec l'aide de l'IA et relu.
- **zbMATH ne vérifie pas les exercices.** C'est une base bibliographique d'articles de recherche. Elle devient une couche « Pour aller plus loin » ; la vérification des réponses passe par un moteur de calcul formel.

**Pitch.** Un tableau blanc pixel où l'on apprend les maths à la main, avec un tuteur qui donne des indices plutôt que les réponses, et deux niveaux d'explication : simple, puis rigoureux.

## Public cible et personas

La cible est l'adulte qui apprend seul : sans prof, sans programme imposé, par sessions courtes, avec une motivation qui fluctue et parfois de mauvais souvenirs des maths à l'école.

| Persona | Situation | Ce qu'il attend de l'app |
| --- | --- | --- |
| Claire, 34 ans, reconversion | Doit reprendre les bases pour une formation en data | Un parcours clair, savoir où elle en est, ne pas se sentir jugée |
| Karim, 45 ans, curieux | Veut enfin comprendre ce qu'il a appris par cœur au lycée | Le « pourquoi », les démonstrations, les liens entre notions |
| Léa, 28 ans, parent | Veut aider son enfant et se remettre à niveau | Des séances de 10 à 15 minutes, des explications simples |

**Conséquences pour la conception :**

- Pas de niveau scolaire imposé : on parle de notions, et un niveau (« CM2 », « L1 ») n'apparaît que si l'utilisateur choisit un parcours calqué sur un programme.
- Des séances courtes, reprenables à tout moment.
- Une progression encourageante, sans séries (streaks) ni classements culpabilisants.
- Le droit à l'erreur : une erreur déclenche une aide, jamais une sanction.

## Analyse de l'interface existante (Tableau Pixel)

La maquette Tableau Pixel (fichier `tableau-pixel.zip` joint) est une excellente base : son principe « consigne en haut, tableau blanc en dessous » correspond exactement à une séance d'exercice de maths faite à la main. Elle est livrée comme design system complet : tokens, 5 composants en JavaScript natif sans dépendance, thèmes clair et sombre.

**Ce qui est déjà là et se transpose en composants Leptos (le CSS est repris tel quel) :**

| Composant | Rôle actuel | Rôle dans l'app de maths |
| --- | --- | --- |
| ConsigneCard | Consignes de dessin, navigation ◀ n / N ▶ | Énoncé de l'exercice, découpé en étapes |
| Whiteboard | Dessin en pixels de 2px, crayons, gomme | Brouillon : poser un calcul, tracer une figure |
| MenuButton | Hamburger dans l'encoche | Accès aux parcours, à la progression, aux réglages |
| Button | 4 variantes, dont `primary` inversé | VALIDER, INDICE, SUIVANT |
| AppShell | Écran complet | Écran « séance d'exercice » |

**Points forts à conserver :** l'identité noir et blanc très reconnaissable, l'accessibilité déjà pensée (contraste ≥ 4.5:1, focus clavier, `prefers-reduced-motion`), la voix à l'impératif et au tutoiement, qui convient à une consigne d'exercice.

**Ce qui manque pour une app de maths :**

1. **Une zone de réponse.** Le tableau sert de brouillon, mais l'app ne sait pas lire un dessin. Il faut un champ de réponse sous le carton, avec un clavier mathématique (fractions, puissances, racines).
2. **Un rendu des formules.** Les consignes affichent du texte brut ; il faut afficher proprement « x² + 3x = 0 » avec KaTeX.
3. **Un panneau d'explication à deux couches.** Un nouveau composant, par exemple `ExplainPanel`, avec deux onglets : SIMPLE et POURQUOI.
4. **Un retour de correction.** Juste, faux, ou « presque » (forme non simplifiée), dans le langage visuel existant : inversion noir/blanc, pas de rouge ni de vert.
5. **Les écrans hors séance :** accueil, test de positionnement, carte des notions, profil.

**Deux points de vigilance :**

- **Le noir et blanc strict interdit le code couleur juste/faux.** C'est cohérent avec le style, mais le retour doit passer par le texte, un glyphe (✓ / ✗ en pixel) et l'inversion. À valider sur mobile.
- **Les polices pixel limitent la lisibilité des formules.** Silkscreen est réservée aux étiquettes, et c'est bien. Pour les formules, il faudra une police mathématique standard (celle de KaTeX), ce qui crée une rupture de style à assumer ou à atténuer.

**Idée à creuser :** le tableau pixel peut devenir un support d'exercices à part entière pour la géométrie (placer un point, tracer une droite sur la grille de 16px), où la réponse se lit dans `board.getPixels()`.

## Périmètre fonctionnel

Le périmètre tient en trois vagues ; seule la vague 1 est un engagement, les suivantes restent révisables après usage réel.

### Vague 1 — MVP : une séance qui fonctionne

Objectif : un seul parcours, « Reprendre les bases » (fractions → puissances → équations du 1er degré), environ 30 exercices, jouable du début à la fin.

| Fonctionnalité | Description | Critère d'acceptation |
| --- | --- | --- |
| Écran de séance | AppShell avec l'énoncé dans ConsigneCard et le tableau en brouillon | L'exercice s'affiche, le tableau fonctionne sur ordinateur et tablette |
| Saisie de la réponse | Champ sous le carton, avec clavier mathématique (MathLive) | On peut saisir « 3/4 », « x = -2 », « 2^5 » sans syntaxe à apprendre |
| Vérification | Moteur mathématique Rust : fractions exactes et test d'équivalence | « 2(x+1) » et « 2x+2 » sont reconnus équivalents ; « 6/8 » est signalé « juste mais à simplifier » |
| Explication à deux couches | Panneau SIMPLE / POURQUOI après la réponse | Chaque exercice a ses deux textes, formules rendues avec KaTeX |
| Lien YouTube | Bouton YOUTUBE dans le panneau d'explication, ouvert dans un nouvel onglet | Chaque notion a un lien : une vidéo choisie, ou à défaut une recherche préremplie |
| Progression locale | Notions vues et réussies, gardées dans le navigateur | Fermer puis rouvrir l'app retrouve la progression |
| Carte du parcours | Liste des notions, état de chacune | On voit où on en est et on reprend là où on s'était arrêté |

### Vague 2 — l'app devient utile au quotidien

- **Comptes utilisateurs**, pour retrouver sa progression sur plusieurs appareils.
- **Générateur de parcours** : l'utilisateur vise n'importe quel programme ou objectif, et l'app construit le parcours (voir « Création de parcours d'apprentissage »).
- **Test de positionnement** d'une dizaine de questions adaptatives, qui propose un point d'entrée dans le parcours.
- **Tuteur IA à indices progressifs** : le bouton INDICE donne d'abord une question (« Que cherche-t-on ? »), puis la règle, puis une étape, jamais la réponse d'emblée.
- **Onglet CHAT** : un agent dédié répond aux questions pour comprendre l'exercice, sans le résoudre (voir « Onglet CHAT : l'agent de compréhension »).
- **Clé API personnelle et choix du modèle** : chaque utilisateur connecte sa clé Claude et choisit le modèle par usage (voir « Clé API Claude personnelle et choix du modèle »).
- **Analyse d'erreurs** : les erreurs fréquentes sont anticipées par exercice (« tu as additionné les dénominateurs ») pour un retour ciblé.
- **Répétition espacée** : une notion réussie revient 1, 3, puis 7 jours plus tard pour ancrer la mémoire.

### Vague 3 — ce qui fait la différence

- **Relecture communautaire et partage** : les notions générées peuvent être relues par des utilisateurs volontaires, et les parcours partagés par lien.
- **Exercices de géométrie sur le tableau pixel** : placer un point, tracer une droite, la réponse étant lue sur la grille.
- **Visualisations interactives** : un curseur modifie un paramètre et la courbe se redessine en pixels.
- **Couche « Pour aller plus loin »** : histoire de la notion et liens vers la recherche via l'API zbMATH Open.
- **Lecture de l'écriture manuscrite** sur le tableau, par un modèle de vision, pour corriger le raisonnement et pas seulement le résultat.

### Hors périmètre

Application mobile native, mode multijoueur ou classe, espace enseignant, paiement, contenu au-delà du niveau licence.

## Création de parcours d'apprentissage

Le parcours n'est pas choisi dans une liste figée : l'utilisateur désigne n'importe quelle cible, et l'app construit le parcours correspondant à la demande.

Exemples de cibles, sans liste limitative : « le programme de maths de CM2 », « la L1 maths-info de mon université », « la 1re année de prépa MPSI », « les maths du BTS SIO », « les probabilités pour un master de data science », « comprendre les maths de l'apprentissage automatique ».

**Ce que l'utilisateur peut fournir :**

- un simple intitulé (« programme de 3e ») ;
- le texte ou le PDF du programme, ou un lien vers sa page officielle ;
- un objectif libre, en une phrase.

Plus la source est précise, plus le parcours est fidèle. Pour une L1, qui varie d'une université à l'autre, fournir la maquette de son université donne un parcours exact.

**Chaîne de génération :**

1. **Lecture de la source.** L'IA extrait les chapitres, les notions et leur ordre ; chaque notion garde la référence du passage du programme dont elle vient.
2. **Correspondance avec la bibliothèque.** Chaque notion extraite est comparée aux notions existantes ; celles déjà présentes sont réutilisées telles quelles.
3. **Génération des notions manquantes.** L'IA rédige exercices et explications SIMPLE et POURQUOI ; chaque réponse attendue est vérifiée par calcul formel avant d'être retenue.
4. **Contrôle des prérequis.** L'app ordonne les notions et ajoute les prérequis absents : « Les dérivées demandent d'avoir vu les limites. »
5. **Ajustement par l'utilisateur.** Il retire ce qu'il maîtrise, à la main ou par un test de positionnement propre au parcours, et réordonne s'il le souhaite.

**Une bibliothèque qui s'enrichit.** Chaque notion générée rejoint la bibliothèque commune : le prochain utilisateur qui vise le même programme obtient son parcours presque instantanément, et les notions les plus demandées sont relues en priorité.

**Un statut de contenu toujours visible.** Chaque notion affiche RELUE (validée par un humain) ou GÉNÉRÉE (réponses vérifiées par calcul, explications non relues). L'utilisateur sait à quel niveau de confiance il se fie.

**Limite assumée.** Les exercices à réponse non calculable, comme prouver qu'une suite converge, sont fréquents en prépa et en licence. Tant qu'aucune vérification fiable n'existe, ils sont proposés en auto-correction guidée : l'utilisateur compare sa démarche à une solution détaillée.

| Vague | Ce qui est livré |
| --- | --- |
| 1 | Un parcours unique, construit par le développeur avec la même chaîne, au format parcours / notions |
| 2 | Générateur de parcours pour n'importe quelle cible, avec génération des notions manquantes |
| 3 | Relecture communautaire des notions générées et partage des parcours entre utilisateurs |

## Lien YouTube

Chaque notion propose un bouton YOUTUBE qui ouvre une vidéo dans un nouvel onglet : pas de lecteur intégré, pas d'API, rien à héberger.

- Si une vidéo a été choisie pour la notion, le bouton ouvre directement son lien.
- Sinon, il ouvre une recherche YouTube préremplie avec le nom de la notion, par exemple « addition de fractions cours ».
- Pour un parcours généré, le générateur ne fournit que la recherche préremplie : il n'invente jamais d'adresse de vidéo.

## Clé API Claude personnelle et choix du modèle

Chaque utilisateur peut connecter sa propre clé API Claude et choisir le modèle utilisé. Les fonctions d'IA (tuteur, analyse d'erreurs, générateur de parcours) tournent alors avec sa clé : il paie directement Anthropic selon sa consommation, et l'app ne coûte rien à exploiter. Livré en vague 2, avec le tuteur IA.

**Connexion de la clé :**

1. Dans RÉGLAGES → IA, l'utilisateur colle sa clé, créée depuis la console Anthropic.
2. L'app la teste par un appel minimal et affiche le résultat : « Clé valide », « Clé refusée » ou « Crédit insuffisant ».
3. Il choisit de la mémoriser sur cet appareil, ou seulement pour la séance en cours.
4. Un bouton SUPPRIMER LA CLÉ l'efface immédiatement.

**La clé ne quitte jamais l'appareil.** Elle est stockée dans le navigateur uniquement, jamais envoyée au serveur de l'app ni dans Supabase. Les appels partent directement du navigateur vers l'API Claude, ce que l'API autorise grâce à un en-tête prévu pour l'accès depuis un navigateur (`anthropic-dangerous-direct-browser-access`).

**Choix du modèle.** La liste des modèles disponibles est lue en direct via l'API (point d'accès Models), pour rester à jour sans modifier l'app. L'utilisateur choisit un modèle par usage :

| Usage | Besoin | Modèle conseillé par défaut |
| --- | --- | --- |
| Tuteur (indices) | Réponses rapides, appels fréquents | Le plus rapide et économique de la gamme (famille Haiku) |
| Analyse d'erreurs | Raisonnement court et précis | Un modèle intermédiaire (famille Sonnet) |
| Agent de compréhension (onglet CHAT) | Dialogue, explications claires et patientes | Un modèle intermédiaire (famille Sonnet) |
| Générateur de parcours | Lecture de longs programmes, rédaction rigoureuse | Le plus capable (famille Opus) |

**Transparence sur le coût.** Avant de générer un parcours, l'app affiche une estimation du nombre de jetons (tokens) et du coût selon le modèle choisi ; un compteur montre la consommation du mois. L'app invite l'utilisateur à fixer un plafond de dépense dans la console Anthropic.

**Sans clé.** L'app reste utilisable pour les exercices, la vérification et les explications déjà rédigées. Seuls les boutons qui appellent l'IA sont désactivés, avec un message qui explique comment connecter une clé.

## Onglet CHAT : l'agent de compréhension

Un onglet CHAT permet de poser librement des questions pour comprendre l'exercice en cours. Il est géré par un agent dédié à cette seule tâche : aider à comprendre, sans jamais résoudre à la place de l'utilisateur. Livré en vague 2.

**Dans l'interface :**

- Deux onglets en haut de l'écran de séance : EXERCICE et CHAT. Sur ordinateur, le chat peut aussi s'ouvrir en panneau latéral, à côté du tableau.
- Le chat suit les règles Tableau Pixel : bulles à contour 2px, sans arrondi ; messages de l'utilisateur en noir inversé.
- Les formules sont rendues avec KaTeX et saisies avec MathLive.
- Les réponses s'affichent au fil de l'eau (streaming), pour ne pas faire attendre.
- Des questions de départ sont proposées : « Que veut dire ce mot ? », « Par où je commence ? », « Pourquoi cette règle ? ».

**Ce que l'agent sait :** l'énoncé et l'étape en cours, la notion et ses explications SIMPLE et POURQUOI, les réponses déjà tentées et les indices déjà donnés par le tuteur. Il ne contredit donc pas le tuteur et part de là où en est l'utilisateur.

**Ce que l'agent fait :** reformuler l'énoncé, expliquer un mot ou une notation, rappeler une définition, répondre aux « pourquoi », faire un exemple analogue avec d'autres nombres.

**Ce que l'agent ne fait pas :** donner la réponse finale, valider ou invalider une réponse (c'est le rôle du calcul formel), sortir du sujet. Une question hors mathématiques est ramenée poliment à l'exercice.

**Garde-fou technique contre la réponse donnée.** La réponse attendue n'est pas transmise à l'agent. Avant d'afficher chaque message, le moteur mathématique vérifie qu'il ne contient pas la réponse attendue ; si c'est le cas, le message est régénéré avec une consigne renforcée.

**Pourquoi un agent séparé.** Chaque agent de l'app a ses propres consignes, son propre modèle et une seule mission. Un rôle étroit rend son comportement plus prévisible, plus facile à tester et à améliorer sans casser les autres.

| Agent | Mission unique | Déclenché par |
| --- | --- | --- |
| Tuteur | Donner un indice gradué | Bouton INDICE |
| Analyse d'erreurs | Expliquer une réponse fausse | Réponse jugée fausse par le calcul formel |
| Agent de compréhension | Répondre aux questions sur l'exercice | Onglet CHAT |
| Générateur de parcours | Construire un parcours et ses notions manquantes | Création d'un parcours |

**Maîtrise du coût.** L'historique envoyé à l'agent est limité aux derniers échanges, et le contexte de l'exercice est mis en cache côté API (prompt caching) pour ne pas être refacturé à chaque message. La conversation est propre à chaque exercice et se vide quand on passe au suivant, sauf si l'utilisateur l'épingle.

## Sources de contenu et stratégie de rigueur

La rigueur repose sur trois garde-fous complémentaires : un calcul formel pour les réponses, une relecture humaine pour les explications, des sources citées pour la couche avancée.

| Besoin | Solution retenue | Pourquoi |
| --- | --- | --- |
| Rédiger les exercices et explications | Génération par IA ; relecture humaine en priorité pour les notions les plus demandées | Pas de source libre et exploitable équivalente à Khan Academy ; l'IA accélère, l'humain garantit |
| Vérifier qu'une réponse est juste | Moteur mathématique Rust, exécuté dans le navigateur | Déterministe et fiable ; une IA peut se tromper sur un calcul |
| Vérifier la solution de référence d'un exercice | Même moteur, lancé à la création de l'exercice | Aucun exercice publié avec une solution fausse |
| Couche POURQUOI | Démonstrations rédigées, relues, avec référence à un manuel ou cours libre | La rigueur se lit, elle ne s'automatise pas encore |
| Pour aller plus loin | API zbMATH Open (métadonnées, classification MSC) | Relie une notion à la littérature de recherche |

**Ressources ouvertes utilisables comme référence** (vérifier la licence de chacune avant réutilisation) : les cours de Wikiversité, les manuels de la collection Sésamath, OpenStax.

**Format d'un exercice.** Chaque exercice est un fichier JSON versionné dans le dépôt Git : énoncé, étapes, réponse attendue, erreurs fréquentes, textes SIMPLE et POURQUOI. Cela permet de relire le contenu comme du code, avant publication.

## Architecture et stack technique

Trois contraintes s'imposent : publication sur Netlify, technologies web uniquement, et un framework Rust pour la rapidité d'exécution. Rust est compilé en WebAssembly (WASM), un format que tous les navigateurs récents exécutent à une vitesse proche du natif.

**Où Rust fait vraiment la différence.** Le gain se mesure sur le calcul : vérification des réponses, comparaison d'expressions, dessin du tableau pixel, filtre anti-réponse du chat. Les appels à l'IA, eux, restent limités par le réseau et le temps de réponse du modèle, quelle que soit la stack.

### Stack retenue : Leptos en rendu côté client, publié sur Netlify

L'app est un site statique : Netlify sert les fichiers, et tout s'exécute dans le navigateur, y compris les appels à l'API Claude avec la clé personnelle.

```
NAVIGATEUR (WebAssembly)        NETLIFY                      SERVICES EXTERNES
┌──────────────────────────┐ sert ┌──────────────────┐
│ Interface Leptos         │ ◀─── │ Site statique    │
│ (composants Tableau Pixel)│      │ HTML, CSS, WASM  │
│                          │      └──────────────────┘
│ Agents IA                │ ── requêtes directes ──────────▶ ┌──────────────┐
│ (4 modules Rust)         │                                  │ API Claude   │
│ Moteur mathématique      │ ── progression ────────────────▶ ┌──────────────┐
│ (Rust, fractions exactes)│                                  │ Supabase     │
│ KaTeX, MathLive          │ ── liens ──────────────────────▶ ┌──────────────┐
│ (via wasm-bindgen)       │                                  │ zbMATH Open  │
└──────────────────────────┘                                  └──────────────┘
```

| Brique | Choix | Raison |
| --- | --- | --- |
| Framework d'interface | Leptos, en rendu côté client (CSR) | Réactivité fine sans DOM virtuel : seuls les éléments modifiés sont mis à jour ; parmi les paquets WASM les plus légers |
| Outil de build | Trunk | Compile Rust en WASM et sert l'app en local avec rechargement ; méthode documentée par Leptos pour Netlify |
| Composants Tableau Pixel | Réécrits en composants Leptos ; `tokens.css` et `bundle.css` repris tels quels | Le style est du CSS pur, réutilisable sans changement ; seule la logique passe en Rust |
| Tableau blanc | Canvas piloté en Rust (crate web-sys) | Dessin pixel rapide, lecture de la grille pour les exercices de géométrie |
| Moteur mathématique | Module Rust maison : analyseur d'expressions, fractions exactes (crate num-rational), test d'équivalence par évaluation en points aléatoires, règles de forme simplifiée | L'écosystème Rust n'a pas encore de calcul formel libre aussi complet que math.js, mais le périmètre du MVP (fractions, puissances, équations du 1er degré) se couvre bien ainsi |
| Rendu des formules | KaTeX, appelé depuis Rust (wasm-bindgen) ; piste 100 % Rust : conversion LaTeX vers MathML | KaTeX est éprouvé ; le MathML est affiché nativement par les navigateurs récents |
| Saisie mathématique | MathLive, appelé depuis Rust | Pas d'équivalent Rust ; c'est un composant web standard |
| Agents IA et API Claude | 4 modules Rust ; requêtes HTTP depuis le navigateur (crate reqwest ou gloo-net) | Réponses en streaming, sans serveur, avec la clé personnelle |
| Comptes et données (vague 2) | Supabase, via son API REST appelée depuis Rust | Pas de SDK Rust officiel, mais l'API REST et l'authentification s'appellent directement |
| Hébergement | Netlify, site statique, déploiement à chaque `git push` | Offre gratuite ; Netlify sert les fichiers WASM comme n'importe quel fichier statique |
| Fonctions serveur (seulement si clé partagée) | Netlify Functions en TypeScript, avec au besoin du Rust compilé en WASM | Netlify accepte encore les fonctions Rust, mais leurs modèles ont été retirés de son outil en ligne de commande en 2026 : TypeScript est la voie la plus sûre |
| Qualité | `cargo test`, `cargo clippy`, `cargo fmt` | Tests rapides du moteur mathématique et code homogène |

L'IA est répartie en quatre agents spécialisés (tuteur, analyse d'erreurs, agent de compréhension, générateur de parcours). Chacun est un module Rust avec ses propres consignes système et son propre modèle ; ils partagent le contexte de l'exercice, jamais leur rôle. Le générateur tourne lui aussi dans le navigateur, et le moteur mathématique y vérifie chaque réponse générée avant son enregistrement.

Les liens YouTube s'ouvrent dans un nouvel onglet : l'app n'intègre ni n'héberge aucune vidéo.

**Déploiement sur Netlify.** Un fichier `netlify.toml` à la racine du dépôt, sur le modèle documenté par Leptos, suffit à compiler et publier l'app à chaque `git push` :

```toml
[build]
command = "rustup target add wasm32-unknown-unknown && cargo install trunk --locked && trunk build --release"
publish = "dist"

[build.environment]
RUST_VERSION = "stable"

[[redirects]]
from = "/*"
to = "/index.html"
status = 200
```

La redirection renvoie toutes les adresses vers l'app, qui gère elle-même ses pages. Compiler Trunk à chaque build est lent : télécharger sa version précompilée accélère nettement les déploiements.

### Autres stacks envisagées

| Stack | Points forts | Limites | Pour qui |
| --- | --- | --- | --- |
| Leptos CSR + Trunk (retenue) | Framework Rust web parmi les plus rapides, paquet léger, déploiement Netlify documenté | Tout Rust à apprendre ; passerelle vers JavaScript pour KaTeX et MathLive | Qui veut une interface 100 % Rust pour le web |
| Dioxus (web) | Syntaxe proche de React, communauté la plus large, même code pour une future app bureau ou mobile | DOM virtuel, un peu plus lourd sur le web | Qui envisage une app mobile plus tard |
| Yew + Trunk | Le plus ancien, beaucoup d'exemples et de composants tiers | DOM virtuel, évolution plus lente | Qui veut un maximum de tutoriels |
| Hybride : interface Vite + TypeScript, moteur mathématique Rust en WASM (wasm-pack) | Composants Tableau Pixel réutilisés tels quels ; Rust là où la vitesse compte ; apprentissage progressif | Deux langages dans le projet | Un débutant qui veut livrer vite |

Le mode rendu côté serveur (SSR) de Leptos n'est pas retenu : il demande un serveur Rust permanent, alors que Netlify héberge des sites statiques et des fonctions ponctuelles.

**Porte de sortie.** Le moteur mathématique est un module Rust indépendant de l'interface. Si l'apprentissage de Leptos s'avère trop lent, passer à la stack hybride conserve ce moteur et l'essentiel du gain de vitesse.

## Modèle de données

Le modèle tient en six objets : un parcours contient des notions, une notion contient des exercices, chaque tentative et chaque conversation de l'utilisateur sont enregistrées, et ses réglages IA restent sur son appareil.

| Objet | Champs principaux | Stockage |
| --- | --- | --- |
| Parcours | id, titre, cible demandée, source fournie (intitulé, texte, lien ou PDF), auteur, chapitres, liste ordonnée de notions | JSON dans le dépôt (vague 1), Supabase dès la vague 2 |
| Notion | id, titre, prérequis, explication SIMPLE, explication POURQUOI, lien YouTube (facultatif), passages de programme couverts, statut (RELUE ou GÉNÉRÉE) | JSON dans le dépôt (vague 1), bibliothèque Supabase dès la vague 2 |
| Exercice | id, notion, énoncé en étapes, réponse attendue, tolérance (forme simplifiée exigée ou non), erreurs fréquentes, indices | JSON dans le dépôt (vague 1), bibliothèque Supabase dès la vague 2 |
| Tentative | exercice, date, réponse saisie, résultat (juste / à simplifier / faux), indices utilisés | Navigateur (vague 1), Supabase (vague 2) |
| Conversation | exercice, messages (auteur, texte, date), épinglée ou non | Navigateur uniquement (vague 2) |
| Réglages IA | clé API (ou aucune si non mémorisée), modèle du tuteur, de l'analyse d'erreurs, de l'agent de compréhension et du générateur, consommation du mois | Navigateur uniquement, jamais Supabase |

Exemple de fichier d'exercice :

```json
{
  "id": "frac-add-03",
  "notion": "fractions-addition",
  "etapes": [
    { "title": "Consigne", "text": "Calcule 1/4 + 2/3." }
  ],
  "reponse": "11/12",
  "exigerFormeSimplifiee": true,
  "erreursFrequentes": [
    { "reponse": "3/7", "message": "Tu as additionné les numérateurs et les dénominateurs. Il faut d'abord un dénominateur commun." }
  ],
  "indices": [
    "Peut-on additionner des quarts et des tiers directement ?",
    "Cherche un dénominateur commun à 4 et 3.",
    "1/4 = 3/12. Que vaut 2/3 en douzièmes ?"
  ]
}
```

Les étapes reprennent le format `{title, text}` de ConsigneCard, pour brancher un exercice sur le composant sans conversion.

## Exigences non fonctionnelles

| Domaine | Exigence |
| --- | --- |
| Technologies | Uniquement des technologies web standard : HTML, CSS, WebAssembly compilé depuis Rust, et JavaScript seulement pour KaTeX et MathLive |
| Hébergement | Publication sur Netlify, déploiement automatique à chaque `git push` sur la branche principale |
| Appareils | Ordinateur et tablette en priorité ; téléphone utilisable dès 360px de large (le tableau y sert moins) |
| Performance | Écran de séance affiché en moins de 2 s sur une connexion 4G ; vérification d'une réponse en moins de 50 ms ; fichier WASM compressé sous 500 Ko |
| Accessibilité | Conserver les acquis de Tableau Pixel : contraste ≥ 4.5:1, navigation clavier, `prefers-reduced-motion` ; formules lisibles par lecteur d'écran (MathML) |
| Langue | Français ; textes rassemblés dans un fichier pour une traduction future |
| Données personnelles | Vague 1 : aucune donnée envoyée à un serveur. Vague 2 : RGPD, suppression de compte en un clic, pas de revente ni de publicité. La clé API personnelle reste sur l'appareil |
| Sécurité | Politique de sécurité du contenu (CSP) stricte ; aucun script chargé depuis un domaine non maîtrisé ; clé API jamais écrite dans les journaux ni dans les messages d'erreur |
| Coût | 0 € en vague 1 ; en vague 2, l'IA est payée par chaque utilisateur via sa clé ; plafond de dépense mensuel si l'app propose une clé partagée |
| Qualité du code | Dépôt Git sur GitHub ; `cargo clippy` sans avertissement ; un test automatique par exercice qui vérifie sa réponse de référence |
| Style | Respect strict des principes Tableau Pixel : pas d'arrondis, noir et blanc, grille de 4px |

## Planning et jalons

Le MVP est atteignable en 10 semaines, dont 3 pour apprendre Rust et Leptos, sur une base de 5 à 8 heures de travail par semaine. Chaque phase se termine par un jalon vérifiable ; on ne passe à la suivante qu'une fois le jalon atteint.

| Phase | Période | Contenu | Jalon de sortie |
| --- | --- | --- | --- |
| Apprendre Rust | Semaines 1 à 3 | Bases du langage, tutoriel Leptos, déploiement Netlify | Page Leptos en ligne |
| Séance d'exercice | Semaines 4 à 7 | Composants en Leptos, moteur mathématique, KaTeX et MathLive | Un exercice jouable |
| Contenu et MVP | Semaines 8 à 10 | 30 exercices relus, explications à 2 niveaux, progression locale | Testé par 3 personnes |
| Vagues 2 et 3 | À partir de la semaine 11 | Comptes, agents IA, puis géométrie et zbMATH | — |

Le jalon « testé par 3 personnes » est le plus important : trois adultes de l'entourage font le parcours sans aide, et leurs remarques décident du contenu de la vague 2.

- [ ] Semaines 1 à 3 : suivre les chapitres de base du Rust Book et le tutoriel officiel de Leptos ; publier une première page Leptos sur Netlify
- [ ] Semaines 4 à 7 : transposer les composants Tableau Pixel en Leptos, écrire le moteur mathématique et ses tests, brancher KaTeX et MathLive, rendre un exercice jouable
- [ ] Semaines 8 à 10 : rédiger et relire les 30 exercices, ajouter la carte du parcours et la progression locale
- [ ] Semaine 10 : faire tester le parcours par 3 personnes et noter leurs retours

## Risques et questions ouvertes

Le risque principal n'est pas technique : c'est la production d'un contenu juste et bien expliqué, qui prendra plus de temps que le code.

| Risque | Conséquence | Parade |
| --- | --- | --- |
| Rédaction du contenu du MVP trop longue | Le MVP ne sort pas | Limiter à 30 exercices ; faire rédiger les brouillons par l'IA, puis relire |
| Courbe d'apprentissage de Rust et de Leptos | MVP retardé, découragement | 3 semaines d'apprentissage prévues ; repli possible vers la stack hybride sans perdre le moteur mathématique |
| Moteur mathématique maison moins complet que math.js | Réponses justes refusées, ou l'inverse | Périmètre limité aux notions du MVP ; un test par exercice ; élargir notion par notion |
| Poids du fichier WASM | Premier chargement lent | Compilation optimisée en taille (`opt-level = "z"`, wasm-opt) ; compression servie par Netlify |
| Passerelle Rust / JavaScript pour KaTeX et MathLive | Bugs à la frontière entre les deux langages | Isoler ces appels dans un seul module Rust, testé à part |
| Programme mal lu ou inventé par l'IA | Parcours décalé du programme réel | Privilégier une source fournie (texte, lien, PDF) ; chaque notion cite le passage du programme dont elle vient |
| Exercice ou explication générés erronés | Perte de confiance de l'utilisateur | Réponses vérifiées par le moteur mathématique ; statut GÉNÉRÉE affiché ; bouton SIGNALER ; relecture des notions les plus demandées |
| Coût de génération d'un gros programme (prépa) | Facture élevée pour un seul parcours | Générer chapitre par chapitre, au fil de la progression ; réutiliser la bibliothèque ; estimation du coût affichée avant génération |
| Vol de la clé API personnelle par un script malveillant | Dépenses frauduleuses sur le compte de l'utilisateur | CSP stricte ; option « ne pas mémoriser » ; conseil de créer une clé dédiée à l'app, avec un plafond de dépense |
| Modèle retiré ou renommé par Anthropic | Fonctions IA en erreur | Liste des modèles lue en direct ; repli automatique sur le modèle conseillé de la même famille |
| Le tuteur ou l'agent de compréhension donne la réponse ou se trompe | L'apprentissage perd son sens | Consignes dédiées à chaque agent ; réponse attendue jamais transmise au chat ; filtre du moteur mathématique avant affichage ; la justesse reste vérifiée par calcul, jamais par l'IA |
| Longues conversations dans le chat | Coût qui grimpe sans qu'on le voie | Historique limité aux derniers échanges ; mise en cache du contexte ; consommation visible dans les réglages |
| Coût d'une éventuelle clé partagée | Facture imprévue pour le développeur | Plafond de dépense, limites par jour et par utilisateur |
| Débordement du périmètre | Projet abandonné en cours de route | S'en tenir aux vagues ; toute nouvelle idée va dans une liste « plus tard » |
| Rupture de style entre polices pixel et formules | Interface incohérente | Prototyper tôt un écran avec formules, dès la semaine 4 |

**Questions ouvertes :**

- [ ] Quel parcours pour le MVP : « Reprendre les bases », ou directement un premier chapitre du programme de CM2 ?
- [ ] Le tableau reste-t-il un simple brouillon, ou devient-il un moyen de répondre dès la vague 1 ?
- [ ] Faut-il une couleur d'accent pour le juste/faux, ou tenir le noir et blanc strict ?
- [ ] L'app propose-t-elle aussi une clé partagée pour essayer l'IA sans compte Anthropic, ou uniquement la clé personnelle ?
- [ ] Quel nom pour l'application ?
