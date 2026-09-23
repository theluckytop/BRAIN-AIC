#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""BRAINIAC — estimation du coût d'une tâche et choix du palier de modèle.

Strictement en lecture : n'écrit aucun fichier.
Usage :
    python3 .claude/outils/estimer.py humain/taches/ma_tache.md [--perimetre projet/src] [--json]
Codes de sortie : 0 une option tient dans le budget, 1 refus ou dépassement.
"""
import json
import os
import re
import sys
import unicodedata
from datetime import date, datetime

RACINE = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..")
)
PALIERS = ("petit", "moyen", "grand")


def lire_plat(chemin):
    """Analyseur maison : `clé: valeur`, une profondeur, commentaires `#`.
    Évite toute dépendance à pyyaml, absent par défaut sur Debian."""
    conf = {}
    if not os.path.exists(chemin):
        return conf
    with open(chemin, encoding="utf-8") as f:
        for ligne in f:
            ligne = ligne.split("#", 1)[0].strip()
            if not ligne or ":" not in ligne:
                continue
            cle, _, val = ligne.partition(":")
            conf[cle.strip()] = val.strip()
    return conf


def nombre(conf, cle, defaut=0.0):
    try:
        return float(str(conf.get(cle, defaut)).replace(",", "."))
    except (TypeError, ValueError):
        return float(defaut)


def liste(conf, cle):
    return [x.strip() for x in str(conf.get(cle, "")).split(",") if x.strip()]


def sans_accent(texte):
    return "".join(
        c for c in unicodedata.normalize("NFD", texte.lower())
        if unicodedata.category(c) != "Mn"
    )


def mesurer(racine, chemin, exclusions):
    """Octets et nombre de fichiers du périmètre, exclusions comprises."""
    cible = os.path.join(racine, chemin) if not os.path.isabs(chemin) else chemin
    octets = fichiers = 0
    if os.path.isfile(cible):
        return os.path.getsize(cible), 1
    for dossier, sous, noms in os.walk(cible):
        sous[:] = [d for d in sous if d not in exclusions and not d.startswith(".")]
        for nom in noms:
            if nom.startswith("."):
                continue
            plein = os.path.join(dossier, nom)
            try:
                taille = os.path.getsize(plein)
            except OSError:
                continue
            if taille > 2_000_000:       # binaire ou données : hors périmètre de lecture
                continue
            octets += taille
            fichiers += 1
    return octets, fichiers


def classer(texte, conf):
    """Retourne (palier, motif). Le doute penche vers le palier supérieur."""
    t = sans_accent(texte)
    criteres = []
    for palier in ("grand", "moyen", "petit"):
        for mot in liste(conf, "mots_" + palier):
            if re.search(r"\b" + re.escape(sans_accent(mot)), t):
                criteres.append((palier, "mot-clé « %s »" % mot))
                break
    vérifiable = bool(re.search(r"crit[eè]re|acceptation|doit|v[eé]rifi", t))
    if not vérifiable:
        return "grand", "aucun critère d'acceptation vérifiable : tâche ambiguë"
    for palier in ("grand", "moyen", "petit"):
        for p, motif in criteres:
            if p == palier:
                return palier, motif
    return "moyen", "aucun mot-clé reconnu, palier médian par défaut"


def main():
    args = [a for a in sys.argv[1:]]
    en_json = "--json" in args
    args = [a for a in args if a != "--json"]
    perimetre = None
    if "--perimetre" in args:
        i = args.index("--perimetre")
        try:
            perimetre = args[i + 1]
        except IndexError:
            print("--perimetre attend un chemin.", file=sys.stderr)
            return 1
        del args[i:i + 2]
    if not args:
        print(__doc__.strip(), file=sys.stderr)
        return 1
    tache = args[0]

    chemin_tache = tache if os.path.isabs(tache) else os.path.join(RACINE, tache)
    if not os.path.isfile(chemin_tache):
        print("Fichier de tâche introuvable : %s" % tache, file=sys.stderr)
        return 1
    with open(chemin_tache, encoding="utf-8", errors="replace") as f:
        texte = f.read()

    arb = lire_plat(os.path.join(RACINE, "ressources", "arbitrage.yaml"))
    bud = lire_plat(os.path.join(RACINE, "ressources", "budget.yaml"))
    if not arb:
        print("ressources/arbitrage.yaml illisible.", file=sys.stderr)
        return 1

    tarifs = {}
    for p in PALIERS:
        tarifs[p] = {
            "nom": arb.get(p + "_nom", p),
            "entree": nombre(arb, p + "_prix_entree"),
            "sortie": nombre(arb, p + "_prix_sortie"),
        }
    if all(t["entree"] <= 0 and t["sortie"] <= 0 for t in tarifs.values()):
        print(
            "Tarifs non renseignés dans ressources/arbitrage.yaml.\n"
            "Relève-les sur la page officielle, inscris-les et mets à jour tarifs_verifies_le.\n"
            "Aucune estimation ne sera inventée.",
            file=sys.stderr,
        )
        return 1

    avertissements = []
    try:
        vu = datetime.strptime(str(arb.get("tarifs_verifies_le", "")), "%Y-%m-%d").date()
        age = (date.today() - vu).days
        if age > 90:
            avertissements.append("tarifs vérifiés il y a %d jours : à confirmer" % age)
    except ValueError:
        avertissements.append("tarifs_verifies_le absent ou mal formé")

    palier, motif = classer(texte, arb)
    exclusions = set(liste(arb, "exclusions"))
    cible = perimetre or "projet"
    octets, fichiers = mesurer(RACINE, cible, exclusions)

    tpo = nombre(arb, "tokens_par_octet", 0.25)
    relecture = nombre(arb, "facteur_relecture", 2.5)
    ratio = nombre(arb, "ratio_sortie", 0.35)
    basse = nombre(arb, "marge_basse", 0.6)
    haute = nombre(arb, "marge_haute", 1.8)
    calib = nombre(arb, "calibration", 1.0)

    tokens_entree = (octets * tpo + len(texte) * tpo) * relecture * calib
    tokens_sortie = tokens_entree * ratio

    options = []
    for p in PALIERS:
        cout = (tokens_entree / 1e6) * tarifs[p]["entree"] + (tokens_sortie / 1e6) * tarifs[p]["sortie"]
        rang = PALIERS.index(p) - PALIERS.index(palier)
        adequation = "adapté" if rang == 0 else ("inadapté" if rang < 0 else "surdimensionné")
        options.append({
            "palier": p,
            "modele": tarifs[p]["nom"],
            "cout_bas": round(cout * basse, 4),
            "cout_haut": round(cout * haute, 4),
            "adequation": adequation,
        })

    plafond = nombre(bud, "credits_max_par_tache", 0)
    devise = bud.get("devise", "")
    recommande = next(o for o in options if o["palier"] == palier)
    tient = plafond <= 0 or recommande["cout_haut"] <= plafond

    decoupe = None
    if palier != "petit":
        explo = next(o for o in options if o["palier"] == "petit")
        decoupe = ("exploration au palier petit (%s), puis exécution au palier %s sur la synthèse : "
                   "compte environ %.2f à %.2f %s au lieu de %.2f à %.2f %s"
                   % (explo["modele"], palier,
                      explo["cout_bas"] + recommande["cout_bas"] * 0.45,
                      explo["cout_haut"] + recommande["cout_haut"] * 0.6, devise,
                      recommande["cout_bas"], recommande["cout_haut"], devise))

    resultat = {
        "tache": tache,
        "perimetre": cible,
        "fichiers": fichiers,
        "octets": octets,
        "tokens_entree_estimes": int(tokens_entree),
        "tokens_sortie_estimes": int(tokens_sortie),
        "palier_recommande": palier,
        "motif": motif,
        "options": options,
        "plafond_par_tache": plafond,
        "devise": devise,
        "tient_dans_le_budget": tient,
        "decoupe_conseillee": decoupe,
        "avertissements": avertissements,
        "horodatage": datetime.now().replace(microsecond=0).isoformat(),
    }

    if en_json:
        print(json.dumps(resultat, ensure_ascii=False, indent=2))
    else:
        print("Tâche       : %s" % tache)
        print("Périmètre   : %s  (%d fichiers, %d ko)" % (cible, fichiers, octets // 1024))
        print("Classement  : palier %s — %s" % (palier, motif))
        print()
        print("%-8s %-12s %12s %12s  %s" % ("palier", "modèle", "coût bas", "coût haut", "adéquation"))
        for o in options:
            print("%-8s %-12s %12.3f %12.3f  %s"
                  % (o["palier"], o["modele"], o["cout_bas"], o["cout_haut"], o["adequation"]))
        print()
        if decoupe:
            print("Découpe conseillée : %s" % decoupe)
        if plafond > 0:
            print("Plafond par tâche  : %.2f %s — %s"
                  % (plafond, devise, "tient" if tient else "DÉPASSÉ, découpe la tâche"))
        for a in avertissements:
            print("Avertissement : %s" % a)
        print("Estimation indicative : fourchette, non contractuelle.")

    return 0 if tient else 1


if __name__ == "__main__":
    sys.exit(main())
