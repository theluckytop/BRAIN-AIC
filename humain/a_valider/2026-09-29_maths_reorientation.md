# Proposition — 2026-09-29_maths_reorientation

## Action proposée
Remplacer la phase 4 prévue (KaTeX + MathLive, exercice à champ de saisie) par un nouveau cap, fidèle à ta demande du 2026-09-29. Rien ne commence sans ta décision sur les 6 points ci-dessous ; les points 1, 3 et 5 relèvent de ton accord (réseau, API, coût).

## Ce que tu demandes (reformulé, à corriger si faux)
- **Écran unique de séance** : AppShell conservé ; **ConsigneCard** (énoncé) au-dessus ; **Whiteboard = l'entrée principale** ; plus de champ de saisie ni de bloc « Exercices (moteur relié) ».
- **Soumettre** : le dessin part à Claude Haiku, qui dit si c'est juste ou faux et pourquoi.
- **Second onglet rattaché au whiteboard = chatbot** : la réponse de Haiku y détaille la démarche, et tu peux y poser des questions.
- **Sources** : programmes officiels (Éducation nationale, universitaires) ; Haiku s'appuie sur une source réelle qu'il vulgarise, et la cite.
- Composants à faire évoluer : ExplainPanel (devient l'onglet chat), Verdict, Whiteboard ; `MenuButton` et `Button` restent des briques.

## Décisions reçues de l'humain (2026-09-29, en session)
- **Point 1 (clé API)** : reporté. Pour l'instant : l'app **tourne en local** et l'humain **saisit sa clé à la main** pour utiliser Haiku. Pas de déploiement, pas de fonction serveur.
- **Comportement de la soumission** : Haiku (a) **recopie d'abord ce qu'il a compris** comme réponse apportée, (b) puis donne les éléments de réponse (juste ou faux et pourquoi) dans l'onglet chatbot ; (c) si la réponse est **impertinente** (ex. un dessin de voiture), il le dit explicitement, sans la noter comme une faute de maths.
- **Point 3 (corpus)** : s'appuyer sur des **API** pour récupérer les cours. Quelles API, et quand les appeler : **en attente** (question du 2026-09-29, ci-dessous).
- Points 2, 4, 5, 6 : sans réponse ; hypothèses de travail = mes recommandations, à confirmer.

## Conséquences techniques à valider
- Saisie de la clé : champ dans un réglage, gardée **en mémoire de l'onglet** (ou `sessionStorage`), jamais dans le code ni le dépôt ; effacée à la fermeture par défaut.
- Appel direct depuis le navigateur vers l'API Anthropic (en-tête `anthropic-dangerous-direct-browser-access`) : acceptable en local pour ta propre clé, **inacceptable en ligne** (point 1 rouvert avant tout déploiement). La CSP devra autoriser `connect-src` vers cette seule origine.
- Le retour de Haiku est affiché en **texte seul** (jamais `inner_html`), y compris dans le chat.
- Format de réponse imposé à Haiku (structure fixe : « ce que j'ai compris » / « pertinence » / « éléments de réponse » / « source ») pour l'afficher et le tester.

## Ce qui change par rapport au cahier et au plan approuvé
Le cahier place la lecture manuscrite par vision en **vague 3**, la vérification par **moteur de calcul formel** (vague 1) et l'IA (tuteur, chat, clé API personnelle) en **vague 2**. Ta demande les fait passer en tête. Le plan de 16 phases (2026-09-28_maths_phase0.md) est à refaire ; les phases 1 à 3 (socle, moteur, composants) restent utilisables.

## Décisions bloquantes (mes recommandations en premier)
1. **Où vit la clé API ?** Une app WASM statique sur Netlify ne peut pas garder une clé secrète : elle serait lisible par tout visiteur. Options : **A** fonction Netlify serveur qui porte ta clé et relaie les appels (recommandée, mais à toi les coûts et il faut limiter le débit) ; **B** chaque utilisateur saisit sa propre clé, stockée dans son navigateur (déjà prévu au cahier, vague 2) ; **C** usage strictement personnel en local, sans déploiement. Dans tous les cas : accord séparé pour l'API Claude et Netlify (validation du 2026-09-28), et la CSP `connect-src 'self'` doit être ouverte vers ce point d'accès.
2. **Qui tranche « juste / faux » ?** Un LLM qui lit un dessin à la main peut se tromper, ce que le cahier voulait éviter (« jamais de sanction à tort »). Recommandé : Haiku lit et explique, mais **le verdict s'affiche comme un avis**, avec l'énoncé et la réponse attendue vérifiée par calcul pour les exercices calculables (moteur, phase 2). À toi de dire si l'avis de Haiku suffit seul.
3. **Corpus « officiel »** : quelles sources exactement (programmes Éduscol / Bulletin officiel, maquettes universitaires ?), et sous quelle licence je peux les intégrer. Recommandé : un petit corpus versionné et cité, en commençant par un seul niveau, plutôt qu'une recherche libre sur le web. Il me faut aussi ton accord pour les télécharger (réseau).
4. **Le moteur (phase 2)** : le garder pour vérifier les réponses attendues ou l'abandonner ? Recommandé : le garder en garde-fou, sans l'exposer à l'écran.
5. **Coût et confidentialité** : chaque soumission envoie une image de ton dessin à Anthropic ; à valider, plus un plafond d'appels par jour.
6. **Modèle** : Haiku 4.5 (`claude-haiku-4-5-20251001`) supporte les images ; à confirmer que c'est bien lui, y compris pour le chat.

## Plan corrigé proposé (à estimer avant exécution)
| # | Étape | Critère de réussite |
|---|---|---|
| A | Écran de séance : AppShell + ConsigneCard + Whiteboard + bouton VALIDER ; suppression du bloc exercices | rendu conforme à ta description, clavier utilisable |
| B | Export du dessin en image, appel de l'API (selon décision 1), affichage du retour dans l'onglet | un dessin envoyé, une réponse affichée, échec réseau géré sans page blanche |
| C | Onglet chatbot rattaché au whiteboard (conversation, texte seul) | question posée, réponse affichée, jamais `inner_html` |
| D | Corpus officiel minimal + citation de la source dans la réponse | chaque réponse nomme sa source |
| E | Audit sécurité (clé, CSP, injection dans le chat, vie privée) + relecture | 0 critique |

## Risques et réversibilité
- Grand changement de périmètre : on ne réutilise que le socle, les composants et le moteur ; on perd la promesse d'un verdict certain.
- Réversible : aucun code n'est touché, aucun appel réseau n'est fait, tout est en brouillon.

## Pour approuver
Réponds aux 6 points dans `humain/questions.md` (ou ici), puis ajoute une ligne dans `humain/taches/validations.md`, et dépose la nouvelle tâche dans `humain/taches/`. C'est le seul endroit qui fait foi.
