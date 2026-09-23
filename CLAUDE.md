@AGENTS.md

## Propre à Claude Code
- Sous-agents : `explorateur` (lecture), `executant` (écriture), `verificateur` (relecture),
  `pentest_entrees`, `pentest_identite`, `pentest_crypto`, `pentest_config` (audit, sans édition).
- Commandes : `/tache`, `/arbitrage`, `/pentest`, `/etat`, `/lecon`, `/cloture`.
- Déléguer l'exploration économise le contexte principal : c'est le défaut, pas une option.
- Lancer toujours depuis la racine de BRAINIAC, sinon les hooks refusent de travailler.
