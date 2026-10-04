# Proposition — 2026-10-04_maths_parcours_v3c2

## Action proposée
Relire et commiter dans `projet/maths` le parcours v3c2 (outil `figure` à `input_schema` dans l'appel à l'API Claude, style sobre des tableaux et schémas du chat), puis ajouter une ligne `validations.md` si tu l'approuves.

## Pourquoi
v3c1 a rendu le validateur tolérant ; v3c2 demande à Haiku des figures conformes par construction (outil de sortie structurée) et donne aux tableaux et schémas du chat un style lisible hors du thème pixel. Sans commit, le code reste non versionné.

## Ce qui a été fait (relecture `verificateur` : CONFORME, critères 1 à 8 ; critère 9 = ton essai réel)
- `figure.rs` : `schema_outil()` (fonction pure) dérivé du vocabulaire fermé (`TYPES`, `Couleur::NOMS`, `STYLES`, fonctions de courbe, bornes `MAX_*`), tolérant (pas d'`additionalProperties:false`) ; test d'alignement avec `valider`.
- `api.rs` : outil `figure` et `tool_choice: auto` dans les deux requêtes du chat (pas dans celle de l'énoncé) ; `extraire_texte` remet chaque `tool_use` de nom exact `figure` à sa place sous forme de bloc ```figure, donc toujours validé par `valider` ; 3 outils au plus ; autre nom ignoré ; ``` ou saut de ligne dans le JSON → « contenu non conforme » ; troncature `max_tokens` → « réponse tronquée » ; `SYSTEME` demande l'outil, bloc ```figure en repli, jusqu'à trois figures.
- `chat-couleurs.css` : +23 lignes, toutes sous `.px-chat` : police système, filets fins, en-tête distinct (graisse et filet, pas la couleur seule). `contraste.mjs` : paire `ink/paper` ajoutée.
- `index.html`, `netlify.toml` : nouveau hash CSP du script d'amorçage.
- Rejoué par moi et le `verificateur` : 165 + 55 tests, fmt, clippy natif et wasm32, `contraste.mjs` 0 échec, `csp.mjs --verifier`, `inner_html` 0 (un commentaire), `Cargo.*` et `tokens.css` inchangés.
- Observé (Firefox headless, CSP réelle, 1280 et 420 px, clair et sombre, réponses API simulées avec blocs `tool_use`) : tableau f(x)=2x+3, triangle ABC, schéma, texte seul, autre nom ignoré, troncature ; requête avec `tools` et sans clé hors `x-api-key` ; style calculé hors chat identique avant et après ; bandeau sans figure, en police pixel. Preuves : `projet/maths/docs/preuves/parcours_v3c2/`.

## À trancher ou à savoir
1. **Essai réel avec ta clé** (critère 9) : seul moyen de vérifier que l'API accepte le schéma (`exclusiveMinimum`, `pattern`, etc.) et que Haiku appelle l'outil. Si l'API refuse le schéma, l'appel du chat échouera entièrement : dis-le-moi, le correctif est local à `schema_outil`.
2. **Style sobre « chat seulement »** : hypothèse retenue, question dans `questions.md`.
3. **Mineurs** : `1e999` littéral dans un `tool_use` rend toute la réponse illisible (« Réponse illisible », pas de fuite) ; un bloc texte terminé par un ```figure non fermé peut absorber l'outil suivant ; `tool_use` sans `input` ignoré en silence ; légende de tableau étroit sur 2 lignes (critère de v3c) ; étiquettes serrées (« poser », « 90 ») héritées de v3b ; test de référence octet à octet de la requête réécrit pour inclure `tools`.
4. `trunk build --release --offline` échoue (wasm-bindgen introuvable hors ligne) ; réussit sans `--offline` depuis le cache, rien téléchargé.

## Contenu exact
```
git -C projet/maths add app/src app/public/chat-couleurs.css app/scripts/contraste.mjs app/index.html netlify.toml docs/preuves/parcours_v3c2
git -C projet/maths commit -m "Parcours v3c2 : outil figure à input_schema, style sobre des tableaux et schémas du chat, CSP rejouée"
```

## Risques et réversibilité
- Risque : schéma refusé par l'API (appel du chat en erreur) ; Haiku qui n'appelle pas l'outil (repli sur le bloc ```figure du texte).
- Réversible : oui, `git revert` du commit.

## Pour approuver
Ajoute une ligne à `humain/taches/validations.md`. C'est le seul endroit qui fait foi.
