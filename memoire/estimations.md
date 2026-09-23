# Estimations : estimé contre réel
Ajout uniquement. Sert à recalibrer `ressources/arbitrage.yaml`, par proposition à l'humain.

| Date | Tâche | Catégorie | Palier | Estimé bas | Estimé haut | Réel | Écart | Cause |
|---|---|---|---|---|---|---|---|---|
| 2026-09-23 | brainiac_console (phase 0) | planification + vérification | grand | 0.017 | 0.052 | non relevé (≈ 45 actions, 3 sous-agents, 6 lectures web) | inexploitable | réel non disponible depuis l'agent ; estimation fondée sur un `projet/` vide |
| 2026-09-23 | brainiac_console_phase1 | création d'application | moyen (exécuté en grand) | 0.010 | 0.031 | non relevé (≈ 80 actions, 3 sous-agents d'audit et de relecture, 2 compilations Rust) | inexploitable | l'estimateur mesure `projet/` avant création : il ne voit pas le code à écrire |
