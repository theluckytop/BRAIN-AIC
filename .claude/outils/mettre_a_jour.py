#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""BRAINIAC — mise à jour de l'espace, et retour en arrière.

    python3 .claude/outils/mettre_a_jour.py --etat
    python3 .claude/outils/mettre_a_jour.py [versions/update/X.zip] --je-confirme
    python3 .claude/outils/mettre_a_jour.py --restaurer versions/historique/Y.zip --je-confirme

Réservé à l'humain. L'agent ne lance jamais cet outil : il mettrait à jour ses propres garde-fous.
Rien n'est appliqué sans --je-confirme. Avant toute modification, l'état courant est archivé,
et si l'autotest échoue après mise à jour, le retour en arrière est automatique.
"""
import hashlib
import os
import shutil
import subprocess
import sys
import tempfile
import zipfile
from datetime import datetime

RACINE = os.environ.get("CLAUDE_PROJECT_DIR") or os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..")
)
UPDATE = os.path.join(RACINE, "versions", "update")
HISTORIQUE = os.path.join(RACINE, "versions", "historique")

# Ce qu'une mise à jour remplace : la mécanique, jamais le vécu.
SYSTEME_DOSSIERS = (".claude", ".codex", "pentest/referentiels")
SYSTEME_FICHIERS = (
    "AGENTS.md", "CLAUDE.md", "DEPLOIEMENT.md", "install.sh", "VERSION",
    "MANIFESTE.sha256", ".gitignore",
    "humain/taches/_MODELE.md", "humain/a_valider/_MODELE.md",
    "projet/README.md", "quarantaine/README.md",
    "versions/update/README.md", "versions/historique/README.md",
)
# Jamais touché : memoire/, journal/, humain/ (hors modèles), travail/, projet/ (hors README),
# livrables/, quarantaine/ (hors README), pentest/rapports/, pentest/exemptions.md, versions/.
CONFIG = ("ressources/budget.yaml", "ressources/arbitrage.yaml",
          "ressources/pentest.yaml", "ressources/priorites.yaml", "ressources/versions.yaml")


def empreinte(chemin):
    h = hashlib.sha256()
    with open(chemin, "rb") as f:
        for bloc in iter(lambda: f.read(65536), b""):
            h.update(bloc)
    return h.hexdigest()


def lire_conf(chemin, cle, defaut):
    try:
        for ligne in open(chemin, encoding="utf-8"):
            ligne = ligne.split("#", 1)[0].strip()
            if ligne.startswith(cle + ":"):
                return ligne.split(":", 1)[1].strip()
    except OSError:
        pass
    return defaut


def version_courante():
    c = os.path.join(RACINE, "VERSION")
    return open(c, encoding="utf-8").read().strip() if os.path.exists(c) else "inconnue"


def horodatage():
    return datetime.now().strftime("%Y-%m-%d_%H%M%S")


def est_systeme(rel):
    if rel in SYSTEME_FICHIERS or rel in CONFIG:
        return True
    return any(rel == d or rel.startswith(d + "/") for d in SYSTEME_DOSSIERS)


def archiver(destination, motif):
    """Archive l'état courant, avec un manifeste recalculé au moment de l'archivage.

    Recalculer est indispensable : le manifeste présent sur le disque date de la livraison
    et ne décrit plus l'espace tel qu'il est aujourd'hui."""
    exclus_prefixes = ("versions/historique/", "projet/", ".git/")
    empreintes = []
    with zipfile.ZipFile(destination, "w", zipfile.ZIP_DEFLATED) as z:
        for dossier, sous, noms in sorted(os.walk(RACINE)):
            sous[:] = [d for d in sous if d != "__pycache__"]
            for nom in sorted(noms):
                plein = os.path.join(dossier, nom)
                rel = os.path.relpath(plein, RACINE).replace(os.sep, "/")
                if rel.startswith(exclus_prefixes) or rel.endswith(".pyc"):
                    continue
                if rel.startswith("projet/") and rel != "projet/README.md":
                    continue
                if rel == "MANIFESTE.sha256":
                    continue
                z.write(plein, "BRAINIAC/" + rel)
                empreintes.append("%s  ./%s" % (empreinte(plein), rel))
        z.writestr("BRAINIAC/MANIFESTE.sha256", "\n".join(empreintes) + "\n")
    return destination


def ouvrir_archive(chemin):
    """Retourne (zipfile, préfixe) après contrôle d'intégrité et de manifeste."""
    if not os.path.exists(chemin):
        sortir("Archive introuvable : %s" % chemin)
    z = zipfile.ZipFile(chemin)
    if z.testzip() is not None:
        sortir("Archive corrompue : %s" % chemin)
    noms = z.namelist()
    prefixe = ""
    for n in noms:
        if n.endswith("AGENTS.md") and n.count("/") <= 1:
            prefixe = n[: -len("AGENTS.md")]
            break
    else:
        sortir("Archive invalide : AGENTS.md introuvable.")
    for attendu in (".claude/settings.json", ".claude/hooks/garde_fou.sh"):
        if prefixe + attendu not in noms:
            sortir("Archive invalide : %s manquant." % attendu)
    manifeste = prefixe + "MANIFESTE.sha256"
    if manifeste in noms:
        erreurs = 0
        lignes = z.read(manifeste).decode("utf-8", "replace").splitlines()
        for ligne in lignes:
            if not ligne.strip():
                continue
            somme, _, rel = ligne.partition("  ")
            rel = rel.strip().lstrip("./")
            interne = prefixe + rel
            if interne in noms:
                if hashlib.sha256(z.read(interne)).hexdigest() != somme.strip():
                    erreurs += 1
        if erreurs:
            sortir("Archive altérée : %d fichier(s) ne correspondent pas à son manifeste." % erreurs)
        print("  Manifeste de l'archive : %d fichiers conformes." % len(lignes))
    else:
        print("  Archive sans manifeste : contrôle d'intégrité partiel.")
    return z, prefixe


def sortir(message, code=1):
    print("\n" + message, file=sys.stderr)
    sys.exit(code)


def journaliser(texte):
    chemin = os.path.join(HISTORIQUE, "JOURNAL.md")
    nouveau = not os.path.exists(chemin)
    with open(chemin, "a", encoding="utf-8") as f:
        if nouveau:
            f.write("# Journal des versions\nAjout uniquement, du plus ancien au plus récent.\n\n")
        f.write(texte + "\n")


def elaguer():
    maxi = int(lire_conf(os.path.join(RACINE, "ressources", "versions.yaml"), "historique_max", "10"))
    archives = sorted(
        (f for f in os.listdir(HISTORIQUE) if f.endswith(".zip")),
        key=lambda f: os.path.getmtime(os.path.join(HISTORIQUE, f)),
    )
    for vieille in archives[:-maxi] if len(archives) > maxi else []:
        os.remove(os.path.join(HISTORIQUE, vieille))
        print("  Élagage : %s supprimée (au-delà de %d conservées)." % (vieille, maxi))


def controler():
    """Autotest puis diagnostic. Retourne True si l'espace est sain."""
    for outil in ("autotest.sh", "verifier.sh"):
        chemin = os.path.join(RACINE, ".claude", "outils", outil)
        r = subprocess.run(["bash", chemin], cwd=RACINE,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        if r.returncode != 0:
            print("  %s en échec :" % outil)
            for ligne in r.stdout.splitlines():
                if "ÉCHEC" in ligne:
                    print("    " + ligne.strip())
            return False
        print("  %s : passé." % outil)
    return True


def appliquer(z, prefixe):
    ecrits, configs, orphelins = [], [], []
    for nom in z.namelist():
        if nom.endswith("/") or not nom.startswith(prefixe):
            continue
        rel = nom[len(prefixe):]
        if not est_systeme(rel):
            orphelins.append(rel)
            continue
        cible = os.path.join(RACINE, rel)
        contenu = z.read(nom)
        if rel in CONFIG and os.path.exists(cible):
            if empreinte(cible) == hashlib.sha256(contenu).hexdigest():
                continue
            with open(cible + ".nouveau", "wb") as f:
                f.write(contenu)
            configs.append(rel)
            continue
        os.makedirs(os.path.dirname(cible) or RACINE, exist_ok=True)
        with open(cible, "wb") as f:
            f.write(contenu)
        if rel.endswith((".sh", ".py")):
            os.chmod(cible, 0o755)
        ecrits.append(rel)
    return ecrits, configs, orphelins


def restaurer(archive):
    z, prefixe = ouvrir_archive(archive)
    ecrits, configs, _ = appliquer(z, prefixe)
    for rel in configs:                       # en restauration, la config revient telle quelle
        cible = os.path.join(RACINE, rel)
        shutil.move(cible + ".nouveau", cible)
        ecrits.append(rel)
    return ecrits


def etat():
    print("BRAINIAC version %s" % version_courante())
    attentes = sorted(f for f in os.listdir(UPDATE) if f.endswith(".zip")) if os.path.isdir(UPDATE) else []
    print("\nEn attente dans versions/update/ : %s" % (", ".join(attentes) if attentes else "rien"))
    archives = sorted(f for f in os.listdir(HISTORIQUE) if f.endswith(".zip")) if os.path.isdir(HISTORIQUE) else []
    print("Historique (%d) : %s" % (len(archives), ", ".join(archives[-5:]) if archives else "vide"))
    if attentes:
        print("\nPour appliquer :")
        print("  python3 .claude/outils/mettre_a_jour.py versions/update/%s --je-confirme" % attentes[-1])
    return 0


def main():
    args = sys.argv[1:]
    if "--etat" in args or not args:
        return etat()

    confirme = "--je-confirme" in args
    args = [a for a in args if a != "--je-confirme"]
    mode_restauration = "--restaurer" in args
    if mode_restauration:
        i = args.index("--restaurer")
        args = args[:i] + args[i + 1:]

    if args:
        archive = args[0] if os.path.isabs(args[0]) else os.path.join(RACINE, args[0])
    elif mode_restauration:
        candidates = sorted((os.path.join(HISTORIQUE, f) for f in os.listdir(HISTORIQUE)
                             if f.endswith(".zip")), key=os.path.getmtime)
        if not candidates:
            sortir("Aucune archive dans versions/historique/.")
        archive = candidates[-1]
    else:
        candidates = sorted((os.path.join(UPDATE, f) for f in os.listdir(UPDATE)
                             if f.endswith(".zip")), key=os.path.getmtime) if os.path.isdir(UPDATE) else []
        if not candidates:
            sortir("Aucune archive dans versions/update/. Dépose-la d'abord.")
        archive = candidates[-1]

    action = "Restauration" if mode_restauration else "Mise à jour"
    print("%s de BRAINIAC" % action)
    print("  Version courante : %s" % version_courante())
    print("  Archive          : %s" % os.path.relpath(archive, RACINE))

    z, prefixe = ouvrir_archive(archive)
    nouvelle = "inconnue"
    if prefixe + "VERSION" in z.namelist():
        nouvelle = z.read(prefixe + "VERSION").decode("utf-8").strip()
    print("  Version de l'archive : %s" % nouvelle)

    if not confirme:
        print("\nRien n'a été modifié. Cette opération touche aux règles qui encadrent l'agent :")
        print("elle demande une décision humaine explicite. Relance avec --je-confirme.")
        return 0

    ancienne = version_courante()
    os.makedirs(HISTORIQUE, exist_ok=True)
    sauvegarde = os.path.join(HISTORIQUE, "BRAINIAC_%s_avant-%s_%s.zip"
                              % (ancienne, "restauration" if mode_restauration else "maj",
                                 horodatage()))
    print("\n  Archivage de l'état courant…")
    archiver(sauvegarde, action)
    print("  Sauvegarde : %s" % os.path.relpath(sauvegarde, RACINE))

    print("\n  Application…")
    if mode_restauration:
        ecrits, configs, orphelins = restaurer(archive), [], []
    else:
        ecrits, configs, orphelins = appliquer(z, prefixe)
    print("  %d fichier(s) remplacé(s)." % len(ecrits))
    for rel in configs:
        print("  Configuration conservée, nouvelle version déposée à côté : %s.nouveau" % rel)
    if orphelins:
        print("  %d fichier(s) de l'archive hors périmètre système, ignorés." % len(orphelins))

    print("\n  Contrôle…")
    if not controler():
        print("\n  Espace en échec après %s : retour en arrière automatique." % action.lower())
        restaurer(sauvegarde)
        ok = controler()
        journaliser("- %s — %s ÉCHOUÉE depuis %s, retour à %s (%s)"
                    % (horodatage(), action, os.path.basename(archive), ancienne,
                       "espace sain" if ok else "ESPACE INSTABLE, intervention requise"))
        sortir("Retour en arrière effectué. L'archive proposée est refusée.", 1)

    elaguer()
    journaliser("- %s — %s : %s → %s, %d fichiers, sauvegarde %s"
                % (horodatage(), action, ancienne, version_courante(),
                   len(ecrits), os.path.basename(sauvegarde)))
    print("\n%s terminée. Version : %s" % (action, version_courante()))
    if configs:
        print("Reporte tes réglages dans les fichiers .nouveau, puis supprime-les.")
    print("Redémarre Claude Code : hooks et permissions sont lus au démarrage.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
