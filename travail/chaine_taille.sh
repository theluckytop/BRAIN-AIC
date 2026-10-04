#!/bin/bash
# usage: chaine_taille.sh <nom-rejeu> <nom-mesure> <titre>   (depuis la racine de BRAINIAC)
R=/home/aouadon/BRAIN-AIC/BRAINIAC/projet/maths; D=docs/preuves/parcours_v3b/taille
cd $R
mkdir -p $D/captures
{ echo "# Rejeu final ($3) $(date -Iseconds)"
run(){ echo; echo "\$ $*"; "$@" 2>&1 | tail -${N:-8}; echo "[code ${PIPESTATUS[0]}]"; }
N=3 run cargo test --manifest-path app/Cargo.toml
N=3 run cargo test --manifest-path moteur/Cargo.toml
N=4 run cargo fmt --all --check
N=3 run cargo clippy --manifest-path app/Cargo.toml --all-targets -- -D warnings
N=3 run cargo clippy --manifest-path moteur/Cargo.toml --all-targets -- -D warnings
N=3 run cargo clippy --manifest-path app/Cargo.toml --target wasm32-unknown-unknown -- -D warnings
N=4 run trunk build --release --config app/Trunk.toml
N=4 run node app/scripts/csp.mjs --ecrire
N=4 run node app/scripts/csp.mjs --verifier
N=2 run node app/scripts/contraste.mjs
} > $D/$1.txt 2>&1
grep -E "^\\$|code|result|RÉSULTAT" $D/$1.txt | cut -c1-110 | paste -sd' '
{ echo "commande : python3 $D/outils/observer_taille.py . $D ($3)"; date -Iseconds; timeout 500 python3 $D/outils/observer_taille.py . $D 2>&1; } > $D/$2.txt
python3 - $D/$2.txt <<'PY'
import json,sys
for l in open(sys.argv[1],encoding='utf-8'):
    if l.startswith('MESURE'):
        h,_,j=l.partition(' : '); d=json.loads(j)
        print(h,[(v['w'],v['h'],v['texte_min_px']) for v in d['svgs']],'tab',d['tab']['w'],d['tab']['h'],'large',list(d['tab_large'].values()),'bulle',d['bulle_w'],d['debord_bulle'],d['debord_page'],any(v['debord'] for v in d['svgs']))
    elif l.startswith(('ECART','RÉSULTAT','EXC')): print(l[:300])
PY
pgrep -af "geckodriver|headless|observer_taille|trunk|http.server" | grep -v "bash -c" | cut -c1-100; echo pgrep-fin
