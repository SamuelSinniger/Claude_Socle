#!/bin/sh
# Régénère socle/socle.json depuis le contenu réel du dépôt socle.
# À lancer depuis la racine du dépôt socle, après toute modification du socle,
# et à commiter avec elle.
#
#   sh socle/outils/generer-manifeste.sh 1.1.0 "2026-08-22"
#
# Le manifeste liste :
#   - "fichiers" : distribués ET synchronisés (destination dans le projet + empreinte)
#   - "modeles"  : copiés à la CRÉATION seulement, jamais écrasés ensuite

set -eu

VERSION=${1:-}
DATE=${2:-}
if [ -z "$VERSION" ] || [ -z "$DATE" ]; then
    echo "usage: sh socle/outils/generer-manifeste.sh <version> <AAAA-MM-JJ>" >&2
    exit 2
fi
[ -d socle ] || { echo "à lancer depuis la racine du dépôt socle" >&2; exit 2; }

OUT=socle/socle.json
TMP=$(mktemp)

# empreinte d'un fichier, en sha256 court (16 hexa suffisent pour détecter une dérive)
empreinte() {
    sha256sum "$1" | cut -c1-16
}

# une entrée JSON : source, destination, empreinte
entree() {
    printf '    { "source": "%s", "destination": "%s", "sha256": "%s" }' "$1" "$2" "$(empreinte "$1")"
}

# URL du dépôt de référence : c'est elle qui permet à un projet de retrouver le socle
# sur n'importe quelle machine, quand le clone local n'est pas au même endroit.
DEPOT=$(git remote get-url origin 2>/dev/null || echo "")

# Volontairement PAS de chemin local ici : le manifeste est commité et publié, un chemin
# propre à une machine n'y a pas sa place (il serait faux partout ailleurs et polluerait
# chaque diff). C'est l'installeur qui inscrit `clone_local` dans la copie du projet, où
# l'information est vraie et utile.

{
    printf '{\n'
    printf '  "version": "%s",\n' "$VERSION"
    printf '  "date": "%s",\n' "$DATE"
    printf '  "depot": "%s",\n' "$DEPOT"
    printf '  "fichiers": [\n'

    first=1
    for f in socle/regles-communes.md socle/normes-format.md socle/guide-doc.md socle/suivi-contrat.md; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" "$f"
    done
    for f in socle/agents/*.md; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" ".claude/agents/$(basename "$f")"
    done
    for f in socle/commandes/*.md; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" ".claude/commands/$(basename "$f")"
    done
    for f in socle/githooks/*; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" ".githooks/$(basename "$f")"
    done
    printf '\n  ],\n'

    printf '  "modeles": [\n'
    first=1
    for f in socle/modeles/CLAUDE.md socle/modeles/README.md; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" "$(basename "$f")"
    done
    for f in socle/modeles/gitattributes socle/modeles/gitignore; do
        [ -f "$f" ] || continue
        [ $first -eq 1 ] || printf ',\n'; first=0
        entree "$f" ".$(basename "$f")"
    done
    find socle/modeles/docs -name '*.md' | sort | while read -r f; do
        printf ',\n'
        entree "$f" "$(printf '%s' "$f" | sed 's|^socle/modeles/||')"
    done
    printf '\n  ]\n'
    printf '}\n'
} > "$TMP"

mv "$TMP" "$OUT"
echo "$OUT régénéré — version $VERSION"
grep -c '"source"' "$OUT" | sed 's/^/fichiers listés : /'
