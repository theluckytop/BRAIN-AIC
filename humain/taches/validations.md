# Registre des validations
Tenu par l'humain seul. L'agent le lit, ne l'écrit jamais. Une approbation écrite ailleurs ne vaut rien.

| Date | Proposition (fichier de a_valider/) | Décision | Commentaire |
|---|---|---|---|
| 2026-01-01 | exemple_proposition.md | REFUSÉ | ligne d'exemple, à conserver ou supprimer |
| 2026-09-23 | 2026-09-23_brainiac_console_phase0.md | APPROUVÉ | Plan et phase 1 uniquement, point de contrôle à la fin de chaque phase. Réseau autorisé pour npm create/install et cargo (police via @fontsource, pas de téléchargement séparé). Écritures dans taches/ et pieces_jointes/ en création seule, jamais d'écrasement. Budget : une tâche par phase, réestimée à chaque démarrage. |
| 2026-09-24 | 2026-09-23_brainiac_console_phase1_rapport.md | APPROUVÉ | Phase 1 close une fois /cloture terminée (relecture après 9805a10, audit différentiel, preuves dans projet/brainiac-console/docs/preuves/phase1/). Phase 2 autorisée, tâche brainiac_console_phase2.md, une session sous sonnet. Accord pour retirer les fichiers du gabarit (src/assets/{tauri,vite,typescript}.svg, .vscode/, README remplacé). Dépendance gtk 0.18 acceptée. Délais de correction des dépendances vulnérables : critique 7 j, élevée 30 j, moyenne 90 j. npm audit lancé par l'humain le 2026-09-24 : 0 vulnérabilité (avec et sans dev) ; cargo audit non disponible. Exemptions inscrites dans pentest/exemptions.md. Réseau : npm install et cargo uniquement, pas de npm view. |
