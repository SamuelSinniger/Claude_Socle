#!/bin/sh
# Amorçage du socle depuis le projet — le fichier à déposer dans le dossier du projet.
#
# Différence avec installer.sh : celui-ci se lance DEPUIS le projet et n'a besoin de
# rien d'autre que lui-même. Il trouve le dépôt socle sur la machine, le clone s'il est
# absent, le met à jour, puis passe la main à installer.sh — qui reste la seule
# mécanique de copie (une seule source de vérité, toujours celle du socle publié).
#
#   sh amorcer.sh                     depuis le dossier du projet
#   sh amorcer.sh --projet <chemin>   depuis ailleurs
#
# Une fois l'installation faite, il **s'efface** : déposé dans le projet, il n'a rien à y
# faire ensuite — ni en fichier non suivi qui traîne, ni commité par mégarde.
#
# Options :
#   --socle <chemin>   forcer l'emplacement du dépôt socle (sinon : recherche puis clone)
#   --complet | --socle-seul   forcer ce que pose l'installeur (sinon : détection)
#   --oui              ne rien demander (clone, git init) : répondre oui à tout
#   --garder           ne pas s'effacer à la fin (pour amorcer plusieurs projets de suite)

set -eu

DEPOT='https://github.com/SamuelSinniger/Claude_Socle.git'
NOM_DU_CLONE='Claude_Socle'

PROJET=''
SOCLE=''
MODE=auto
OUI=non
GARDER=non

while [ $# -gt 0 ]; do
    case "$1" in
        --projet) PROJET=${2:-}; shift 2 ;;
        --socle)  SOCLE=${2:-};  shift 2 ;;
        --complet|--socle-seul) MODE=$1; shift ;;
        --oui|-y) OUI=oui; shift ;;
        --garder) GARDER=oui; shift ;;
        *) echo "option inconnue : $1" >&2; exit 2 ;;
    esac
done

demander() {
    [ "$OUI" = oui ] && return 0
    printf '%s [O/n] ' "$1" >&2
    read -r reponse </dev/tty || return 1
    case "$reponse" in ''|o|O|y|Y|oui|yes) return 0 ;; *) return 1 ;; esac
}

# Un dossier est un dépôt socle s'il porte le manifeste.
est_socle() { [ -n "${1:-}" ] && [ -f "$1/socle/socle.json" ]; }

# …et c'est le NÔTRE si ce manifeste porte le dépôt de cet amorceur. Plusieurs socles
# peuvent cohabiter sur une machine — jeux de projets distincts, corpus distincts : un
# clone voisin qui n'est pas le nôtre ne doit pas être retenu, même s'il est au bon
# endroit et porte le bon nom. Un manifeste sans dépôt (socle purement local) est accepté :
# on ne peut rien conclure, et le refuser bloquerait un cas légitime.
est_mon_socle() {
    est_socle "${1:-}" || return 1
    depot=$(sed -n 's/.*"depot": "\([^"]*\)".*/\1/p' "$1/socle/socle.json" | head -1)
    [ -z "$depot" ] || [ "$depot" = "$DEPOT" ]
}

# Chemin natif (sous Git Bash, `pwd` seul renvoie /f/… que les outils Windows ne savent
# pas résoudre — et c'est ce chemin qu'on affiche à l'utilisateur).
natif() { ( cd "$1" && { pwd -W 2>/dev/null || pwd; } ); }

# --- 1. le projet ---------------------------------------------------------------

# Sans --projet : le dossier où se trouve ce fichier (le cas « déposé dans le projet »).
if [ -z "$PROJET" ]; then
    PROJET=$(dirname "$0")
fi
[ -d "$PROJET" ] || { echo "projet introuvable : $PROJET" >&2; exit 2; }
PROJET=$(natif "$PROJET")

# Garde-fou : lancé depuis socle/outils/ du dépôt socle lui-même, il installerait le
# socle dans le socle.
if est_socle "$PROJET/../.."; then
    echo "Tu es dans le dépôt socle. Depuis ici, utilise :" >&2
    echo "  sh socle/outils/installer.sh <projet>" >&2
    echo "amorcer.sh, lui, se dépose dans le projet." >&2
    exit 2
fi

echo "[i] Projet : $PROJET"

# --- 2. le dépôt socle ----------------------------------------------------------

if [ -n "$SOCLE" ]; then
    est_socle "$SOCLE" || { echo "pas de socle/socle.json dans : $SOCLE" >&2; exit 2; }
    est_mon_socle "$SOCLE" || {
        echo "$SOCLE est un socle, mais pas celui-ci :" >&2
        echo "  son dépôt   $(sed -n 's/.*"depot": "\([^"]*\)".*/\1/p' "$SOCLE/socle/socle.json" | head -1)" >&2
        echo "  le mien     $DEPOT" >&2
        echo "Prends l'amorceur de CE socle-là, ou corrige --socle." >&2
        exit 2
    }
    SOCLE=$(natif "$SOCLE")
else
    # Emplacements plausibles, du plus proche au plus général. Le premier qui porte
    # notre manifeste gagne — un clone d'un autre socle est ignoré, pas retenu.
    for piste in \
        "${CLAUDE_SOCLE:-}" \
        "$(dirname "$PROJET")/$NOM_DU_CLONE" \
        "$HOME/$NOM_DU_CLONE" \
        "$HOME/GitHub/$NOM_DU_CLONE" \
        "$HOME/Documents/GitHub/$NOM_DU_CLONE"
    do
        if est_mon_socle "$piste"; then SOCLE=$(natif "$piste"); break; fi
    done
fi

if [ -z "$SOCLE" ]; then
    # Absent de la machine : on le clone à côté du projet, jamais dedans.
    CIBLE="$(dirname "$PROJET")/$NOM_DU_CLONE"
    echo "[i] Dépôt socle introuvable sur cette machine."
    echo "    À cloner depuis $DEPOT"
    echo "    vers $CIBLE"
    demander "    Cloner maintenant ?" || {
        echo "Interrompu. Relance avec --socle <chemin-du-dépôt-socle> si tu l'as ailleurs." >&2
        exit 1
    }
    git clone "$DEPOT" "$CIBLE"
    est_socle "$CIBLE" || { echo "clone terminé mais socle/socle.json est absent de $CIBLE" >&2; exit 1; }
    SOCLE=$(natif "$CIBLE")
elif [ -d "$SOCLE/.git" ]; then
    # Présent : on récupère l'amont avant d'installer. Comparer à un clone en retard
    # de trois versions donnerait un « à jour » faux.
    echo "[i] Dépôt socle : $SOCLE"
    git -C "$SOCLE" fetch --quiet || echo "[!] fetch impossible : je continue avec l'état local."
    if [ -n "$(git -C "$SOCLE" status --porcelain)" ]; then
        echo "[!] Le clone a des modifications non commitées : je n'y touche pas."
        echo "    La version installée sera celle de ce clone, pas forcément celle publiée."
    else
        git -C "$SOCLE" pull --ff-only --quiet || echo "[!] Mise à jour du clone impossible (pas d'amont ?) : je continue avec l'état local."
    fi
else
    echo "[i] Dépôt socle : $SOCLE (pas un dépôt git : pas de mise à jour)"
fi

# --- 3. le dépôt du projet ------------------------------------------------------

# Un dépôt git n'est pas facultatif : le hook de documentation, le contrôle de
# conformité (qui lit le diff d'un point) et le commit du testeur en dépendent.
if [ ! -d "$PROJET/.git" ]; then
    echo
    echo "[!] $PROJET n'est pas un dépôt git."
    echo "    Le pipeline en a besoin : hook de doc, diff de conformité, commit du testeur."
    if demander "    Faire git init -b main ici ?"; then
        git -C "$PROJET" init -b main
    fi
fi

# --- 4. l'installation ----------------------------------------------------------

INSTALLEUR="$SOCLE/socle/outils/installer.sh"
[ -f "$INSTALLEUR" ] || {
    echo "installeur introuvable : $INSTALLEUR (clone incomplet ou version de socle trop ancienne)" >&2
    exit 1
}

echo
if [ "$MODE" = auto ]; then
    sh "$INSTALLEUR" "$PROJET"
else
    sh "$INSTALLEUR" "$PROJET" "$MODE"
fi

# --- 5. la suite ----------------------------------------------------------------

# L'amorceur se retire du projet : il n'a de raison d'être qu'une fois. Supprimer un
# script pendant qu'il tourne est sans danger — le shell garde son descripteur ouvert
# jusqu'à la fin. Deux réserves : on ne s'efface que depuis le projet où l'on a été
# déposé (pas depuis une boîte à outils lancée avec --projet), et jamais un fichier que
# git suit déjà, sous peine de fabriquer une suppression à commiter.
if [ "$GARDER" = non ] && [ -f "$0" ] && [ "$(natif "$(dirname "$0")")" = "$PROJET" ]; then
    MOI=$(basename "$0")
    echo
    if git -C "$PROJET" ls-files --error-unmatch "$MOI" >/dev/null 2>&1; then
        echo "[!] $MOI est suivi par git dans ce projet : je ne le supprime pas."
        echo "    Retire-le toi-même (git rm --cached $MOI) — il n'a rien à faire dans"
        echo "    l'historique du projet."
    else
        rm -f "$0" && echo "  $MOI s'est effacé : il avait fait son travail."
    fi
fi
