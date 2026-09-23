# Décisions
Ajout uniquement. Format :

```
## AAAA-MM-JJ — décision en une ligne
- Contexte :
- Alternatives rejetées et pourquoi :
- Conséquences :
```
---

## 2026-09-23 — BRAINIAC Console sur Tauri 2.11 (pas 3.0)
- Contexte : phase 0 ; crates.io donne 2.11.6 stable et 3.0.0-alpha.2 en préversion.
- Alternatives rejetées et pourquoi : Tauri 3 alpha, API instable et sans documentation arrêtée.
- Conséquences : pile Tauri 2.11 + Vite 8 + TS + Svelte ; plan approuvé le 2026-09-23 (plan et phase 1 seulement).

## 2026-09-23 — Autorisations de session routées par un outil MCP, repli sans contournement
- Contexte : question 4.3 du cahier ; `--permission-prompt-tool` est documentée mais absente en entrée propre de `claude --help`.
- Alternatives rejetées et pourquoi : parler en Rust le canal de contrôle stdio de l'Agent SDK (non documenté comme protocole public) ; embarquer Node et l'Agent SDK (dépendance d'exécution lourde).
- Conséquences : démonstration en session réelle en tête de phase 4 ; à défaut, `--permission-prompts none` et renvoi vers l'onglet Suivi.

## 2026-09-23 — Une tâche BRAINIAC par phase de BRAINIAC Console
- Contexte : condition de l'approbation humaine ; l'estimateur mesure `projet/` et sous-estime une construction à partir de rien.
- Alternatives rejetées et pourquoi : une seule tâche pour les 7 phases (plafonds de durée, d'actions et de 5 USD intenables).
- Conséquences : chaque phase a son fichier de tâche, son estimation au démarrage, son rapport et un point de contrôle humain.

## 2026-09-23 — Mode d'écriture imposé par la zone, jamais choisi par l'appelant
- Contexte : test 5 et condition d'approbation « création seule dans taches/ et pieces_jointes/ ».
- Alternatives rejetées et pourquoi : un paramètre `mode` passé par l'appelant, qui permettrait à une commande future de demander un écrasement.
- Conséquences : `ecriture::Zones::ecrire` déduit le mode du chemin canonique ; `create_new` pour les tâches, `append` sur fichier existant pour validations/questions, renommage atomique pour la configuration.

## 2026-09-23 — Palette ajustée au contraste AA mesuré
- Contexte : cahier §7, valeurs « indicatives » ; `scripts/contraste.mjs` mesure le pire cas (fenêtre translucide sur fond blanc).
- Alternatives rejetées et pourquoi : garder 82 % et `#8A9A8C` (4,2 : sous le seuil AA) ; employer `#E8323C` comme couleur de texte (3,4).
- Conséquences : fond à 86 %, `--texte-2: #9AAA9C`, `--alerte-texte: #FF8088` ; `#E8323C` réservé aux aplats.
