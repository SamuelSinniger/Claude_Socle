#!/bin/sh
# Créer un SECOND socle, pour un ensemble de projets distinct.
#
# Un socle porte son identité à neuf endroits, dont deux fichiers DISTRIBUÉS
# (`socle/commandes/socle.md` et `interop.md`) : un socle recopié à la main sans les
# corriger déploie dans ses projets des commandes qui pointent vers le dépôt d'origine.
# C'est la seule vraie difficulté de la manœuvre, et ce script la fait en entier.
#
#   sh socle/outils/nouveau-socle.sh <chemin-du-nouveau-socle> <url-du-dépôt> --jumeau|--vierge
#
# Le mode n'a pas de valeur par défaut — c'est la décision de départ, elle se prend :
#
#   --jumeau   reprend les règles du socle courant. Les deux corpus partagent une
#              ascendance puis divergent : une règle promue ici n'ira PAS là-bas.
#   --vierge   garde la machinerie (agents, commandes, pipeline, modèles, format des
#              normes) et part sans aucune règle. Le corpus se construit depuis les
#              projets, par /socle adopt et /socle promote.
#
# À la place de l'URL, `--local` crée un socle sans dépôt distant : le manifeste part
# sans champ `depot`, les URL sont remplacées par le placeholder ⟨url-du-dépôt⟩ — que
# `grep -rn '⟨'` retrouve le jour de la publication — et l'amorceur localise le socle par
# son chemin au lieu de savoir le cloner.
#
# Options :
#   --nom <NomDuClone>   nom du dossier de clone cherché par l'amorceur
#                        (défaut : le nom du dépôt déduit de l'URL, ou du dossier cible)
#   --date <AAAA-MM-JJ>  date de la version 1.0.0 (défaut : aujourd'hui)

set -eu

CIBLE=${1:-}
URL=${2:-}
if [ "$URL" = "--local" ]; then URL=''; LOCAL=oui; shift 1; else LOCAL=non; [ $# -ge 2 ] && shift 2; fi

MODE=''
NOM=''
DATE=$(date +%F)

while [ $# -gt 0 ]; do
    case "$1" in
        --jumeau|--vierge) MODE=$1; shift ;;
        --local) LOCAL=oui; shift ;;
        --nom)  NOM=${2:-};  shift 2 ;;
        --date) DATE=${2:-}; shift 2 ;;
        *) echo "option inconnue : $1" >&2; exit 2 ;;
    esac
done

usage() {
    echo "usage: sh socle/outils/nouveau-socle.sh <chemin> <url-du-dépôt> --jumeau|--vierge" >&2
    echo "  --jumeau  reprend les règles du socle courant (les deux corpus divergeront ensuite)" >&2
    echo "  --vierge  garde la machinerie, part sans aucune règle" >&2
}

[ -n "$CIBLE" ] || { usage; exit 2; }
[ -n "$URL" ] || [ "$LOCAL" = oui ] || { usage; exit 2; }
[ -n "$MODE" ] || { echo "Choisis un mode : --jumeau ou --vierge." >&2; usage; exit 2; }
[ -d socle ] && [ -f socle/socle.json ] || { echo "à lancer depuis la racine d'un dépôt socle" >&2; exit 2; }
if [ -e "$CIBLE" ] && [ -n "$(ls -A "$CIBLE" 2>/dev/null)" ]; then
    echo "$CIBLE existe et n'est pas vide — refuse d'écrire dedans." >&2
    exit 2
fi

SOURCE=$(pwd -W 2>/dev/null || pwd)
VERSION_SOURCE=$(sed -n 's/.*"version": "\([^"]*\)".*/\1/p' socle/socle.json | head -1)

# --- identités, ancienne et nouvelle --------------------------------------------

# L'ancienne est celle inscrite dans le manifeste : c'est elle qui a été écrite partout.
ANCIENNE_URL=$(sed -n 's/.*"depot": "\([^"]*\)".*/\1/p' socle/socle.json | head -1)
[ -n "$ANCIENNE_URL" ] || { echo "le manifeste n'a pas de champ depot : identité introuvable" >&2; exit 2; }

sans_git()  { printf '%s' "$1" | sed 's/\.git$//'; }
chemin_de() { printf '%s' "$1" | sed 's|.*://[^/]*/||; s|\.git$||'; }   # « compte/dépôt »
nom_de()    { printf '%s' "$1" | sed 's|.*/||; s|\.git$||'; }

ANCIENNE_BASE=$(sans_git "$ANCIENNE_URL")
ANCIEN_CHEMIN=$(chemin_de "$ANCIENNE_URL")
ANCIEN_NOM=$(nom_de "$ANCIENNE_URL")

if [ "$LOCAL" = oui ]; then
    # Pas de dépôt : on écrit le placeholder maison, celui que `grep -rn '⟨'` retrouve.
    # Une URL inventée serait pire que pas d'URL — elle serait crue.
    NOUVELLE_BASE="⟨url-du-dépôt⟩"
    NOUVEAU_CHEMIN='⟨url-du-dépôt⟩'
    [ -n "$NOM" ] || NOM=$(basename "$CIBLE")
else
    NOUVELLE_BASE=$(sans_git "$URL")
    NOUVEAU_CHEMIN=$(chemin_de "$URL")
    [ -n "$NOM" ] || NOM=$(nom_de "$URL")
fi

echo "[i] Source  : $SOURCE — socle $VERSION_SOURCE, $ANCIENNE_URL"
echo "[i] Nouveau : $CIBLE"
if [ "$LOCAL" = oui ]; then
    echo "[i] Dépôt   : aucun pour l'instant   (dossier de clone cherché par l'amorceur : $NOM)"
else
    echo "[i] Dépôt   : $URL   (dossier de clone cherché par l'amorceur : $NOM)"
fi
echo "[i] Mode    : $MODE"
echo

# --- copie ----------------------------------------------------------------------

mkdir -p "$CIBLE"
# La machinerie et les textes ; ni .git, ni le manifeste (régénéré), ni le CHANGELOG (réécrit).
COPIES='socle .gitattributes README.md DEMARRER.md interop.md projets.md'
# PRESENTATION.md décrit un corpus de 45 règles : vrai pour un jumeau, faux pour un socle
# vierge. On ne recopie pas une présentation qui mentirait dès la première ligne.
[ "$MODE" = --jumeau ] && COPIES="$COPIES PRESENTATION.md"
for f in $COPIES; do
    [ -e "$f" ] || continue
    cp -R "$f" "$CIBLE/"
done
rm -f "$CIBLE/socle/socle.json"
echo "  copié   socle/ — règles, agents, commandes, hooks, modèles, outils"
echo "  copié   README.md, DEMARRER.md, .gitattributes, les registres (vidés plus bas)"

# --- identité : les neuf points -------------------------------------------------

# En mode local, l'URL entière part d'abord : sinon le chemin « compte/dépôt » serait
# remplacé seul, laissant un « https://github.com/⟨url-du-dépôt⟩ » qui ment sur l'hébergeur.
if [ "$LOCAL" = oui ]; then
    find "$CIBLE" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.ps1' \) -exec sed -i \
        -e "s|https://raw.githubusercontent.com/$ANCIEN_CHEMIN/main/|$NOUVELLE_BASE/|g" \
        -e "s|$ANCIENNE_URL|$NOUVELLE_BASE|g" \
        -e "s|$ANCIENNE_BASE|$NOUVELLE_BASE|g" \
        {} +
fi

# Ordre imposé : le chemin « compte/dépôt » d'abord — il couvre github.com ET
# raw.githubusercontent.com d'un coup —, le nom nu ensuite, sinon le second mange le premier.
find "$CIBLE" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.ps1' \) -exec sed -i \
    -e "s|$ANCIEN_CHEMIN|$NOUVEAU_CHEMIN|g" \
    -e "s|$ANCIENNE_BASE|$NOUVELLE_BASE|g" \
    -e "s|\\b$ANCIEN_NOM\\b|$NOM|g" \
    {} +
RESTES=$(grep -rl "$ANCIEN_CHEMIN\|\\b$ANCIEN_NOM\\b" "$CIBLE" 2>/dev/null | wc -l | tr -d ' ')
echo "  réécrit l'identité dans tous les .md/.sh/.ps1 — fichiers portant encore l'ancienne : $RESTES"
case "$URL" in
    *github.com*) ;;
    *) echo "  [!] dépôt non-GitHub : vérifie à la main les deux formes 'irm'/'curl' de DEMARRER.md" ;;
esac

if [ "$MODE" = --jumeau ]; then
    # La présentation renvoyait à une page publiée qui appartient au socle d'origine,
    # et annonçait son état : les deux redeviennent faux ici.
    sed -i \
        -e '/^> Version partageable/d' \
        -e '\|claude\.ai/code/artifact|d' \
        -e "s|^\*État au .*\*$|*État au $DATE — socle 1.0.0.*|" \
        "$CIBLE/PRESENTATION.md"
    echo "  ajusté  PRESENTATION.md — lien de page publiée retiré, état remis à 1.0.0"
fi

# --- registres : ils sont propres à un socle ------------------------------------

# projets.md : on garde l'en-tête du tableau et les explications, on retire les lignes.
awk '
    /^\| Projet \| Chemin \|/ { entete = 1 }
    entete && /^\| [A-Za-z]/ && !/^\| Projet \|/ { next }
    /^\*\(/ { next }
    { print }
' "$CIBLE/projets.md" > "$CIBLE/projets.tmp" && mv "$CIBLE/projets.tmp" "$CIBLE/projets.md"

# interop.md : le lexique des concepts est du vocabulaire partagé, il se garde ; les
# déclarations et les correspondances sont les données des projets de l'autre socle.
# Les paragraphes « Lecture : … » commentent ces lignes-là : ils partent avec elles,
# sans quoi le nouveau registre explique un tableau qui n'existe plus.
awk '
    /^## 2\. Déclarations des projets/ { section = 2 }
    /^## 3\. Correspondances/          { section = 3 }
    (section == 2 || section == 3) && /^Lecture ?:/ { lecture = 1; next }
    lecture && /^$/ { lecture = 0; next }
    lecture { next }
    (section == 2 || section == 3) && /^\| [A-Za-zÀ-ÿ0-9]/ && !/⟨/ && !/^\| Projet \|/ && !/^\| Date \|/ { next }
    { print }
' "$CIBLE/interop.md" > "$CIBLE/interop.tmp" && mv "$CIBLE/interop.tmp" "$CIBLE/interop.md"

# Les projets de l'autre socle sont encore nommés dans les exemples en prose. Un exemple
# qui cite un projet inexistant ici se lit comme une donnée : on le rend générique.
if [ -f projets.md ]; then
    grep -o '^| [A-Za-zÀ-ÿ0-9_-]* |' projets.md | sed 's/^| //; s/ |$//' | while read -r p; do
        [ "$p" = "Projet" ] && continue
        sed -i "s|\\b$p\\b|⟨un projet⟩|g" "$CIBLE/interop.md"
    done
fi
echo "  vidé    projets.md et les déclarations d'interop.md — le lexique des concepts reste"

# --- le corpus de règles --------------------------------------------------------

if [ "$MODE" = --vierge ]; then
    # On garde le préambule et les intitulés de section : ils disent où ranger la
    # première règle. Ce qui part, ce sont les règles — et leurs lignes de continuation.
    awk '
        /^- \*\*R-/     { retrait = 1; next }
        retrait && /^  / { next }
        { retrait = 0; print }
    ' "$CIBLE/socle/regles-communes.md" | cat -s > "$CIBLE/socle/rc.tmp"
    mv "$CIBLE/socle/rc.tmp" "$CIBLE/socle/regles-communes.md"
    cat >> "$CIBLE/socle/regles-communes.md" <<'FIN'

---

> **Corpus vide au départ.** Les sections ci-dessus sont des rangements, pas des promesses.
> La première règle viendra d'un projet — par `/socle adopt`, qui classe les règles qu'il a
> déjà, ou par `/socle promote`, quand un manquement constaté vaut leçon. Une règle qui ne
> vient pas d'un constat est une intuition : elle attendra.
FIN
    REGLES=0
    RESUME="machinerie seule, corpus vide"
else
    REGLES=$(grep -c '^- \*\*R-' "$CIBLE/socle/regles-communes.md")
    RESUME="corpus repris de $ANCIEN_NOM $VERSION_SOURCE, $REGLES règles"
fi
echo "  corpus  $RESUME"

# --- CHANGELOG : l'histoire recommence ------------------------------------------

# L'en-tête (à quoi sert ce fichier, le tableau du versionnage) est de la machinerie :
# il se garde. Les versions, elles, sont l'histoire de l'autre socle.
{
    sed -n '1,17p' CHANGELOG.md
    printf '\n---\n\n## 1.0.0 — %s\n\n' "$DATE"
    if [ "$MODE" = --jumeau ]; then
        cat <<FIN
Socle créé à partir de **$ANCIEN_NOM $VERSION_SOURCE**, pour un ensemble de projets
distinct. Les $REGLES règles sont reprises telles quelles ; les registres — projets
installés, déclarations d'interopérabilité — repartent vides.

**Les deux corpus divergent à partir d'ici.** Une règle promue dans l'un n'ira pas dans
l'autre, et un même identifiant \`R-###\` pourra désigner deux règles différentes : chaque
\`regles-communes.md\` fait autorité pour ses seuls projets. Si une règle doit valoir des
deux côtés, il faut la promouvoir deux fois — c'est le prix d'avoir deux socles.

*Impact rétroactif : aucun — aucun projet n'est encore installé.*
FIN
    else
        cat <<FIN
Socle créé à partir de la machinerie de **$ANCIEN_NOM $VERSION_SOURCE** : les cinq agents,
les cinq commandes, le contrat du pipeline, le format des normes, les modèles de
documentation et les outils. **Aucune règle.**

Le corpus se construira depuis les projets : \`/socle adopt\` classera les règles que le
premier projet a déjà, \`/socle promote\` fera monter celles qu'on découvrira en codant.
Un socle qui commence par un corpus recopié commence par des règles que personne n'a
constatées.

*Impact rétroactif : aucun — aucun projet n'est encore installé.*
FIN
    fi
} > "$CIBLE/CHANGELOG.md"
echo "  écrit   CHANGELOG.md — version 1.0.0 du $DATE"

# --- dépôt et manifeste ---------------------------------------------------------

echo
git -C "$CIBLE" init -q -b main
# Sans remote, generer-manifeste.sh laisse `depot` vide : c'est exact, et les amorceurs
# acceptent un manifeste sans dépôt (ils ne peuvent rien en conclure).
[ "$LOCAL" = oui ] || git -C "$CIBLE" remote add origin "$URL"
# generer-manifeste.sh lit `git remote get-url origin` : le champ depot du nouveau
# manifeste est juste dès la première génération.
( cd "$CIBLE" && sh socle/outils/generer-manifeste.sh 1.0.0 "$DATE" )

# --- suite ----------------------------------------------------------------------

echo
echo "Fait. Ensuite :"
if [ "$LOCAL" = oui ]; then
    echo "  1. relis (git -C \"$CIBLE\" status), puis commite :"
    echo "       git -C \"$CIBLE\" add -A"
    echo "       git -C \"$CIBLE\" commit -m \"Socle 1.0.0 — $RESUME\""
    echo "  2. le jour de la publication : crée le dépôt, ajoute le remote, puis"
    echo "       grep -rn '⟨url-du-dépôt⟩' \"$CIBLE\"    → les endroits à compléter"
    echo "       sh socle/outils/generer-manifeste.sh 1.0.1 <date>   → depot renseigné"
else
    echo "  1. crée le dépôt vide chez ton hébergeur : $URL"
    echo "  2. relis (git -C \"$CIBLE\" status), puis :"
    echo "       git -C \"$CIBLE\" add -A"
    echo "       git -C \"$CIBLE\" commit -m \"Socle 1.0.0 — $RESUME\""
    echo "       git -C \"$CIBLE\" push -u origin main"
fi
echo "  3. amorce un projet avec CE socle : dépose"
echo "       $CIBLE/socle/outils/amorcer.sh   (ou amorcer.ps1)"
echo "     à la racine du projet, et lance-le."
echo
echo "  Les deux socles cohabitent sans se mélanger : chaque amorceur n'accepte qu'un clone"
echo "  dont le manifeste porte SON dépôt, et un projet ne connaît que le sien."
