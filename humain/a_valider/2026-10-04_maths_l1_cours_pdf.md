# Proposition — 2026-10-04_maths_l1_cours_pdf

## Action proposée
Ajouter au parcours un niveau **L1** construit **uniquement** à partir des trois PDF de `humain/Cours/` (Exo7 Algèbre 1, Analyse 1, Formules), avec dans l'onglet « Cours » des **captures de schémas** extraites de ces PDF et un **lien vers le PDF** à la page du chapitre.

## Pourquoi
Le corpus actuel s'arrête à la Terminale (8 niveaux, 166 notions, aucun L1 ; `sujets_examen` vide). v2b prévoyait un L1 par recherche réseau ; tes PDF le remplacent : aucune recherche, aucune source hors dossier. Sans cette tâche, le niveau L1 reste absent.

## Sources (les seules utilisées)
| Fichier | Pages PDF | Licence |
|---|---|---|
| `Cours/(L1 - Math Sup): Algèbre/livre-algebre-1.pdf` | 246 | Exo7, CC BY-NC-SA 4.0 (à confirmer à la page de garde ; le formulaire l'annonce) |
| `Cours/(L1 - Math Sup):Analyse/livre-analyse-1.pdf` | 207 | idem, à confirmer |
| `Cours/(L1 - Math Sup):Formules/formules.pdf` | 52 | CC BY-NC-SA 4.0 (annoncé dans le document) |

Pagination : la page imprimée 1 est la page **PDF 8** dans les deux livres, soit `page PDF = page imprimée + 7` (vérifié sur les deux). Les numéros ci-dessous sont les numéros imprimés (sommaires lus par moi).

## Parcours proposés (programme = chapitres des livres, ordre et prérequis internes)

**Parcours A — Fondations** (algèbre) : Logique (1-10) → Ensembles et applications (11-30) → Nombres complexes (31-44) → Arithmétique (45-58) → Polynômes (59-70) → Groupes (71-86).

**Parcours B — Analyse** : Nombres réels (1-14) → Suites (15-36) → Limites et continuité (37-58) → Fonctions usuelles (59-68) → Dérivée (69-84) → Intégrales (85-108) → Développements limités (109-126) → Courbes paramétrées (127-164) → Équations différentielles (165-184).

**Parcours C — Algèbre linéaire** : Systèmes linéaires (87-98) → Matrices (99-122) → ℝⁿ (123-136) → Espaces vectoriels (137-166) → Dimension finie (167-186) → Matrices et applications linéaires (187-210) → Déterminants (211-231).

**Parcours D — Boîte à outils** (Formules) : trigonométrie, dérivées, primitives, DL, utilisés en B ; section « Formulaires » (p. 45-47 du document Formules) et chapitre 10 « Leçons de choses » d'Analyse (185-196).

Chaque chapitre devient une notion du niveau L1 : `titre`, sections (celles du sommaire), page de début et de fin, prérequis (ex. Polynômes ← Arithmétique ← Ensembles ; Déterminants ← Matrices ← Systèmes). **Les extraits de cours sont recopiés ou résumés depuis le PDF avec numéro de page ; rien n'est rédigé hors source.** Un chapitre non lu en détail est marqué « sommaire seul ».

Réserve : les sections détaillées des chapitres 4, 9, 10, 12 et 13 d'Algèbre n'ont été lues que par leur titre. Ce plan ne dit rien de leur contenu.

## Captures de schémas
- **Méthode** : les figures des livres sont vectorielles (une seule image raster repérée, p. 204 d'Analyse). Rendu par `pdftoppm -r 150 -f N -l N -png` (déjà installé), puis recadrage de la figure (coordonnées notées par figure), PNG sans perte.
- **Où** : `projet/maths/app/public/cours/l1/…png`, un fichier par figure ; table `figures` dans le corpus : chapitre, page PDF, rectangle de recadrage, légende, source, licence.
- **Affichage** : dans l'onglet « Cours », sous l'extrait, avec légende « Source : Exo7, <livre>, p. N, CC BY-NC-SA 4.0 ». Texte alternatif obligatoire. CSP déjà compatible (`img-src 'self' data:`).
- **Couleur** : le noir et blanc strict vaut hors chat. Choix demandé (question 2).
- **Volume** : plafond proposé de ~60 figures et 3 Mo au total (à confirmer). Les figures ne se choisissent pas à l'aveugle : chacune est ouverte et vérifiée avant ajout (pas de figure tronquée).

## Lien vers les PDF
- Copie des 3 PDF dans `projet/maths/app/public/cours/pdf/` (3,8 Mo), avec leur licence.
- Lien `<a href="cours/pdf/livre-analyse-1.pdf#page=N" target="_blank" rel="noopener">` par chapitre (N = page imprimée + 7), « Ouvrir le chapitre dans le PDF d'origine ». Le PDF s'ouvre dans le visionneur du navigateur, pas dans la page (`object-src 'none'` conservé).
- Test : chaque lien est vérifié (la page ciblée affiche bien le titre du chapitre) ; le lien ne doit pas casser si le PDF manque.

## Hors périmètre
Énoncés générés par Haiku pour le L1 (déjà prévu dans l'app, il suffira que les notions L1 existent), exercices et corrigés (liens Exo7 : accord réseau séparé), autres sources, push et déploiement, Algèbre 2 / Analyse 2.

## Risques et réversibilité
- **Licence NC (non commercial)** : si l'app est publiée sur Netlify, un usage public hors cadre non commercial est à ta décision. Attribution (auteurs, livre, page, licence) incluse ; SA : la partie L1 serait elle aussi redistribuée en CC BY-NC-SA, distincte de l'AGPL de Coopmaths.
- Poids : +3,8 Mo de PDF et les PNG ; le build embarque ces fichiers.
- Mes plans de chapitres viennent de sous-agents et de sommaires ; les extraits se vérifient sur le PDF.
- Réversible : oui (suppression de `cours/l1/`, `cours/pdf/` et de la table, commit isolé).

## Estimation et palier
`estimer.py` surévaluera (périmètre `projet/` entier). Ma fourchette : 2 à 4 USD au palier sonnet, plafond 5 USD. Si la borne haute le dépasse, découper : (1) niveau L1 + liens PDF, (2) captures de figures.

## Questions pour toi (aussi dans `questions.md`)
1. **Licence/diffusion** : l'app reste-t-elle locale ou non commerciale ? (condition de la clause NC).
2. **Couleur des captures** : A conversion en niveaux de gris (recommandé, noir et blanc strict) / B couleurs d'origine, avec une ligne `validations.md` (assouplit la règle du 2026-09-28 pour l'onglet Cours).
3. **PDF dans le dépôt** : A copie des 3 PDF dans l'app (recommandé) / B liens vers exo7.emath.fr (accord réseau à l'exécution, rien téléchargé).
4. **Découpe** : en une tâche ou (1) puis (2) ?

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md` et copie la tâche (à rédiger après tes réponses) dans `humain/taches/`. C'est le seul endroit qui fait foi.
