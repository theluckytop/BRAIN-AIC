# Application de maths — Parcours v2a : programme dans la modale, onglet Cours, énoncés Haiku (CM2 à Terminale)

- **Priorité** : haute
- **Autonomie accordée** : faire approuver
- **Échéance** : aucune

## Objectif
Dans `projet/maths/app/` : choisir un niveau (CM2 à Terminale) dans la modale ☰ → Parcours
affiche **tout le programme du niveau dans cette même modale** (plus dans le bandeau des énoncés) ; choisir
un chapitre déverrouille l'onglet « Cours » ; chaque énoncé est **généré par Haiku** ; chaque source mène à un
cours ou, pour le supérieur, à des sujets d'examen (partiels).

## Contexte
- Part du commit `9d683f1` de `projet/maths` (rapport `maths_parcours` encore à approuver).
- Découpe décidée par l'humain (2026-09-30, réponse A) : v2a = l'app ; v2b = corpus L1 Math-info. **Aucun réseau** dans v2a.
- Accord : `validations.md`, ligne « maths_parcours_v2a.md » (API Claude à l'exécution, clé saisie par l'utilisateur).
- Décision : chapitres sans cours marqués « cours manquant », aucun contenu inventé. Le format du corpus doit accepter
  un niveau supérieur et des sujets d'examen (champ prévu, rempli par v2b).
- Priorité fonctionnelle, application locale : pas de /pentest sur cette tâche.

## Critères d'acceptation
- [ ] Modale en deux niveaux : liste des niveaux → programme du niveau (chapitres) dans la même fenêtre ;
      retour, clavier, Échap, focus rendu, utilisable sur téléphone
- [ ] Onglet « Cours » verrouillé sans chapitre choisi, disponible dès qu'un chapitre l'est ; il montre l'extrait,
      le statut (GÉNÉRÉE / RELUE / DOUTEUX), le lien de la source, ou « cours manquant »
- [ ] Énoncés générés par Haiku pour le chapitre choisi, cours du chapitre dans le prompt ; `source_citee_valide` branchée
- [ ] Chaque source mène à un cours ; le schéma du corpus accepte des sujets d'examen (aucun réseau ici)
- [ ] `trunk build --release`, tests, clippy `-D warnings`, fmt, `csp.mjs --verifier` propres ; app observée en local
      sous la CSP réelle

## Hors périmètre
Corpus L1 Math-info (v2b), autres niveaux du supérieur, comptes utilisateurs, déploiement, push, correction automatique des énoncés générés
par le moteur, rédaction de fiches de cours par l'agent.
