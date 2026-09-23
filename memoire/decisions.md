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
