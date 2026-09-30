# Application de maths — Parcours v2 : programme dans la modale, onglet Cours, énoncés Haiku, L1 Math-info

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/` : choisir un niveau (CM2 à Terminale, puis L1 Math-info) dans la modale ☰ → Parcours
affiche **tout le programme du niveau dans cette même modale** (plus dans le bandeau des énoncés) ; choisir
un chapitre déverrouille l'onglet « Cours » ; chaque énoncé est **généré par Haiku** ; chaque source mène à un
cours ou, pour le supérieur, à des sujets d'examen (partiels).

## Contexte
- Part du commit `9d683f1` de `projet/maths` (rapport `maths_parcours` encore à approuver).
- Accords : `validations.md`, ligne du 2026-09-30 « maths_parcours_v2.md » (API Claude à l'exécution, clé saisie par
  l'utilisateur ; réseau en lecture seule pour le corpus L1 Math-info, 300 requêtes, cache relu avant tout appel).
- Décisions : chapitres sans cours marqués « cours manquant », aucun contenu inventé ; L1 Math-info : l'agent
  cherche les sources universitaires françaises publiques et consigne chaque hôte et sa licence dans le corpus.
- Priorité fonctionnelle, application locale : pas de /pentest sur cette tâche.

## Critères d'acceptation
- [ ] Modale en deux niveaux : liste des niveaux → programme du niveau (chapitres) dans la même fenêtre ;
      retour, clavier, Échap, focus rendu, utilisable sur téléphone
- [ ] Onglet « Cours » verrouillé sans chapitre choisi, disponible dès qu'un chapitre l'est ; il montre l'extrait,
      le statut (GÉNÉRÉE / RELUE / DOUTEUX), le lien de la source, ou « cours manquant »
- [ ] Énoncés générés par Haiku pour le chapitre choisi, cours du chapitre dans le prompt ; `source_citee_valide` branchée
- [ ] Chaque source mène à un cours ; pour L1, à des sujets d'examen aussi ; hôte et licence consignés
- [ ] Corpus L1 Math-info (programme, cours, partiels) construit dans le plafond de 300 requêtes, cache relu d'abord
- [ ] `trunk build --release`, tests, clippy `-D warnings`, fmt, `csp.mjs --verifier` propres ; app observée en local
      sous la CSP réelle

## Hors périmètre
Autres niveaux du supérieur, comptes utilisateurs, déploiement, push, correction automatique des énoncés générés
par le moteur, rédaction de fiches de cours par l'agent.
