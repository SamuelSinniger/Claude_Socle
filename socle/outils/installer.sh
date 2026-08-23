#!/bin/sh
# Amorçage du socle dans un projet.
#
# À lancer AVANT toute utilisation de /socle : la commande /socle est elle-même
# distribuée par le socle, elle n'existe donc pas encore dans un projet vierge.
# Ce script fait la partie mécanique (copie selon le manifeste) ; la partie qui
# demande du jugement (réconcilier les règles d'un projet existant) reste à
# /socle adopt, disponible dès que ce script a tourné.
#
#   sh <socle>/socle/outils/installer.sh <chemin-du-projet> [--socle-seul|--complet]
#
# Modes :
#   (défaut)       détecte : projet vierge -> complet, projet avec ses propres règles -> socle seul
#   --socle-seul   uniquement les fichiers distribués (socle/, .claude/, .githooks/)
#   --complet      + les modèles (CLAUDE.md, README.md, docs/**) là où le fichier est absent

set -eu

# Chemin du socle, en forme native (sous Git Bash, `pwd` seul renvoie /f/... que les
# outils Windows ne savent pas résoudre — et c'est ce chemin qu'on affiche à l'utilisateur).
SOCLE=$(cd "$(dirname "$0")/../.." && { pwd -W 2>/dev/null || pwd; })
MANIFESTE="$SOCLE/socle/socle.json"

PROJET=${1:-}
MODE=${2:-auto}

if [ -z "$PROJET" ]; then
    echo "usage: sh $0 <chemin-du-projet> [--socle-seul|--complet]" >&2
    exit 2
fi
[ -d "$PROJET" ] || { echo "projet introuvable : $PROJET" >&2; exit 2; }
[ -f "$MANIFESTE" ] || { echo "manifeste introuvable : $MANIFESTE" >&2; exit 2; }

VERSION=$(sed -n 's/.*"version": "\([^"]*\)".*/\1/p' "$MANIFESTE" | head -1)

# --- détection du type de projet ------------------------------------------------

# Le projet porte-t-il déjà des règles qui ne viennent pas du socle ?
regles_etrangeres() {
    if [ -f "$PROJET/socle/socle.json" ]; then return 1; fi          # socle déjà installé
    for f in CLAUDE.md AGENTS.md .cursorrules CONTRIBUTING.md; do
        if [ -f "$PROJET/$f" ]; then
            grep -q 'Socle commun' "$PROJET/$f" 2>/dev/null && continue
            return 0
        fi
    done
    [ -d "$PROJET/.claude" ] && return 0
    return 1
}

case "$MODE" in
    --socle-seul) COPIER_MODELES=non ;;
    --complet)    COPIER_MODELES=oui ;;
    auto)
        if regles_etrangeres; then
            COPIER_MODELES=non
            echo "[i] Ce projet a déjà ses propres règles : je ne pose que le socle."
            echo "    Les modèles (CLAUDE.md, docs/**) ne sont PAS copiés — c'est /socle adopt"
            echo "    qui décidera quoi faire des règles existantes, avec ta validation."
        else
            COPIER_MODELES=oui
            echo "[i] Projet vierge : socle + modèles."
        fi
        ;;
    *) echo "mode inconnu : $MODE" >&2; exit 2 ;;
esac

echo "[i] Socle $VERSION depuis $SOCLE"
echo "[i] Vers $PROJET"
echo

# --- copie ---------------------------------------------------------------------

# Extrait "source|destination" d'une des deux listes du manifeste ("fichiers" ou "modeles").
entrees() {
    awk -v liste="$1" '
        $0 ~ "\"" liste "\": \\[" { dedans = 1; next }
        dedans && /^  \]/         { dedans = 0 }
        dedans && /"source":/ {
            src = $0; sub(/.*"source": "/, "", src); sub(/".*/, "", src)
            dst = $0; sub(/.*"destination": "/, "", dst); sub(/".*/, "", dst)
            print src "|" dst
        }
    ' "$MANIFESTE"
}

poses=0; ignores=0

entrees fichiers | while IFS='|' read -r src dst; do
    mkdir -p "$PROJET/$(dirname "$dst")"
    cp "$SOCLE/$src" "$PROJET/$dst"
    echo "  posé     $dst"
done

# Le manifeste : c'est lui qui dit au projet quelle version il a. On y inscrit au passage
# `clone_local`, le chemin du socle sur CETTE machine — information vraie ici, et qui n'a
# rien à faire dans le manifeste publié.
mkdir -p "$PROJET/socle"
sed "s|^  \"depot\": \(.*\)$|  \"depot\": \1\n  \"clone_local\": \"$SOCLE\",|" \
    "$MANIFESTE" > "$PROJET/socle/socle.json"
echo "  posé     socle/socle.json (clone_local = $SOCLE)"

if [ "$COPIER_MODELES" = oui ]; then
    echo
    entrees modeles | while IFS='|' read -r src dst; do
        if [ -e "$PROJET/$dst" ]; then
            echo "  ignoré   $dst (existe déjà)"
        else
            mkdir -p "$PROJET/$(dirname "$dst")"
            cp "$SOCLE/$src" "$PROJET/$dst"
            echo "  modèle   $dst"
        fi
    done
fi

# --- hook ----------------------------------------------------------------------

echo
if [ -d "$PROJET/.git" ]; then
    git -C "$PROJET" config core.hooksPath .githooks
    echo "[i] hook activé : core.hooksPath = .githooks"
else
    echo "[!] $PROJET n'est pas un dépôt git : hook non activé."
    echo "    Le pipeline en a besoin (diff de conformité, commit du testeur)."
fi

# --- suite ---------------------------------------------------------------------

echo
echo "Fait — la copie, seulement. L'installation n'est PAS terminée."
echo
echo "  1. RELANCE la session Claude Code dans ce projet."
echo "     Les commandes et les agents sont découverts au démarrage : une session"
echo "     ouverte avant cette copie ne verra pas /socle."
echo
echo "  2. /socle install"
if [ "$COPIER_MODELES" = non ]; then
    echo "     Ce projet a ses propres règles : la commande bascule d'elle-même en"
    echo "     adopt — elle les classe et te fait valider avant d'écrire quoi que ce"
    echo "     soit, puis inscrit le socle dans TON CLAUDE.md. Sans cette étape, le"
    echo "     socle est posé mais inerte : aucun agent ne le lit."
else
    echo "     Elle inscrit le projet dans $SOCLE/projets.md, commite ce qui vient"
    echo "     d'être posé (sinon le socle disparaît au prochain clone) et liste ce"
    echo "     qui reste à remplir."
fi
echo
echo "  3. remplir CLAUDE.md § Projet puis docs/conventions.md § Concrétisation"
echo "     (grep -rn '⟨' CLAUDE.md docs/)"
