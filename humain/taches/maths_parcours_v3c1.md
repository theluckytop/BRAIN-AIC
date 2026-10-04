# Maths — Parcours v3c1 : figures tolérantes, motif du refus, prompt strict, tableau Markdown
- **Priorité** : haute (retours d'usage réel avec Haiku)
- **Autonomie accordée** : signaler
- **Échéance** : aucune

## Objectif
Faire que ce que Haiku produit dans le chat (triangle dans un repère, tableau de valeurs, formule de Pythagore) s'affiche correctement au lieu d'être refusé ou rendu en texte brut.

## Contexte
Suite de v3b (commit `ac3d45a`). Essais réels de l'humain : (1) tableau de f(x)=2x+3 en texte brut, sans bloc ```figure ; (2) triangle ABC dans un repère refusé : « [Figure non affichée : repere : clé non autorisée.] » ; (3) Pythagore affiché « 32+42 =9+16 =5 » (formule non écrite en LaTeX). Code : `app/src/figure.rs`, `composants/figure_svg.rs`, `tableau_chat.rs`, `texte_math.rs`, `notation.rs`, `api.rs` (`SYSTEME`). Choix A+B de l'humain : v3c1 = B (validation tolérante) + prompt + motif du refus + tableau Markdown ; A (outil à `input_schema`) et style sobre = v3c2.

## Critères d'acceptation
- [ ] Une clé inconnue dans un bloc ```figure est ignorée (jamais lue), sans refuser le bloc ; refus conservé pour type inconnu, bornes dépassées, nombres non finis, couleur hors liste (tests, dont cas hostiles).
- [ ] Un `repere` accepte aussi polygones, segments, angles (dont angle droit) et étiquettes ; le triangle ABC de l'essai (A(1,1), B(5,1), C(1,4), angle droit en A) est rendu (observé à 1280 et 420 px, clair et sombre).
- [ ] Un refus affiche le motif exact avec la clé ou la valeur fautive, sans recopier le JSON entier (nœuds texte, longueur bornée).
- [ ] Le prompt Haiku exige le bloc ```figure pour tout tableau, schéma ou repère, avec un exemple, et l'écriture en `$…$` de toute formule ; test sur le texte du prompt.
- [ ] Un tableau Markdown (`| a | b |` + ligne `---`) dans une réponse est rendu en vrai `<table>` par le chemin des tableaux de figure (nœuds texte, bornes) ; un texte sans séparateur reste du texte. Le tableau de f(x)=2x+3 est rejoué (réponse simulée).
- [ ] `Figures::Refusees` inchangé : le bandeau d'énoncé ne dessine jamais de figure ; couleur dans le chat seulement.
- [ ] Tests, fmt, clippy natif et wasm32, `contraste.mjs`, `csp.mjs --ecrire`/`--verifier` verts ; `tokens.css`, `Cargo.toml`, `Cargo.lock` inchangés ; 0 `inner_html` ; relecture `verificateur` CONFORME.
- [ ] Essai réel avec la clé de l'humain : le rapport dit ce que l'agent n'a pas pu observer.

## Hors périmètre
Outil à `input_schema` et style sobre (v3c2), mise en page du chat et accessibilité clavier (v3c), audit du tuteur, v2b, push, déploiement.
