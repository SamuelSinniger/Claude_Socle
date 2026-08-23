# Socle Claude — base commune de documentation et d'agents

Dépôt de référence du **socle** partagé par tous les projets : les règles impératives, les
agents du pipeline de travail, les commandes, les hooks, et le squelette de documentation
d'un projet neuf.

Ce dépôt n'est pas un projet. Il **produit** ce qui est copié dans les projets.

```bash
git clone https://github.com/SamuelSinniger/Claude_Socle.git
```

> **Pour démarrer un projet, va directement à [DEMARRER.md](DEMARRER.md)** — la marche à
> suivre pas à pas, l'ordre dans lequel remplir le squelette, et les erreurs classiques.
> Ce README-ci décrit la mécanique du socle.

## Ce qu'il contient

```
socle/
├── socle.json            manifeste : chaque fichier distribué, sa destination, son empreinte
├── regles-communes.md    les règles impératives R-### (le cœur)
├── suivi-contrat.md      le pipeline des points : 4 listes, portes, format d'un point
├── guide-doc.md          règles du dossier docs/ et frontière socle / projet
├── normes-format.md      comment s'écrit une règle opposable
├── agents/               les 5 agents           → .claude/agents/ dans un projet
├── commandes/            les 4 commandes        → .claude/commands/
├── githooks/             post-commit + notice   → .githooks/
├── modeles/              squelette d'un projet neuf (copié à l'installation SEULEMENT)
└── outils/               amorceur (à déposer dans un projet), installeurs, générateur de manifeste
CHANGELOG.md              versions du socle + impact rétroactif de chaque règle
projets.md                registre des projets installés et de leur version
interop.md                lexique des concepts partagés + ce que chaque projet exporte/importe
```

## Les deux règles qui font tout tenir

1. **Un fichier est soit entièrement socle, soit entièrement projet.** Jamais les deux. C'est
   ce qui permet de mettre à jour sans jamais fusionner à la main. Les fichiers distribués
   (`socle/`, `.claude/agents/`, `.claude/commands/`, `.githooks/`) ne se modifient **pas**
   dans un projet ; le reste (`CLAUDE.md`, `README.md`, `docs/`) n'est **jamais** touché par
   une mise à jour.
2. **Pour s'écarter d'une règle : une dérogation déclarée**, dans le `CLAUDE.md` du projet
   (règle, pratique retenue, raison, date). Jamais une modification locale — `/socle check`
   la signalerait, `/socle update` l'écraserait.

## Usage, depuis un projet

L'amorçage tient en **un fichier à déposer dans le dossier du projet** —
[`socle/outils/amorcer.ps1`](socle/outils/amorcer.ps1) (Windows) ou
[`amorcer.sh`](socle/outils/amorcer.sh) (POSIX) — et à lancer sans argument. Il trouve ce
dépôt sur la machine (ou le clone à côté du projet s'il est absent), le met à jour, puis
appelle l'installeur. Rien d'autre n'est à installer au préalable.

Le manifeste retient les deux chemins d'accès au socle : `depot` (l'URL, valable sur
n'importe quelle machine) et `clone_local` (le chemin du clone, inscrit à l'installation).
Les commandes essaient le clone local, puis clonent depuis l'URL s'il est absent.

| Commande | Effet |
|---|---|
| `.\amorcer.ps1` (PowerShell)<br>`sh amorcer.sh` (POSIX) | **Amorçage depuis le projet** — le fichier déposé dans le dossier du projet. Localise ou clone le dépôt socle, `git init` si besoin, puis passe la main à l'installeur |
| `socle/outils/installer.ps1 -Projet <projet>` (PowerShell)<br>`sh socle/outils/installer.sh <projet>` (POSIX) | **Amorçage depuis ce dépôt** — la copie mécanique selon le manifeste, quand le clone est déjà là. C'est la seule étape qui ne passe pas par une commande, puisque `/socle` est lui-même distribué par le socle. Détecte projet vierge (socle + modèles) ou projet ayant ses propres règles (socle seul) |
| `/socle install <chemin-de-ce-dépôt>` | Compléter l'installation d'un projet **neuf**. Sur un projet qui a ses propres règles, bascule de lui-même en `adopt` |
| `/socle adopt <chemin-de-ce-dépôt>` | Faire entrer un projet **existant qui a déjà ses règles** : classement de chaque règle (déjà couverte / à promouvoir / plus stricte / spécifique / en contradiction), validation par l'utilisateur, puis installation |
| `/socle check` | Version installée, retard éventuel, fichiers socle modifiés localement, dérogations mortes |
| `/socle update` | Appliquer la version disponible **et créer les points de mise en conformité** que les nouvelles règles impliquent |
| `/socle promote "<la règle>"` | Faire monter ici une règle découverte en travaillant sur un projet, puis lister les projets à mettre à jour |
| `/interop declare` | Publier au registre ce que ce projet sait exporter / importer |
| `/interop check` | Repérer qu'un autre projet du socle exporte déjà une donnée saisie à la main ici — et en faire des points |
| `/interop concept "<nom>"` | Consulter ou enrichir le lexique des concepts partagés |

## Publier une version du socle

1. Modifier le ou les fichiers de `socle/`.
2. Ajouter l'entrée au [CHANGELOG](CHANGELOG.md) — avec, pour chaque règle, son **impact
   rétroactif** (« aucun » est une réponse ; l'omettre, non).
3. Régénérer le manifeste :

```bash
sh socle/outils/generer-manifeste.sh 1.1.0 2026-08-22
```

4. Commiter, puis `/socle update` dans les projets listés dans [projets.md](projets.md).

## Note pour l'agent

Les liens des fichiers de `socle/agents/`, `socle/commandes/` et `socle/modeles/` sont
relatifs à leur **destination dans un projet**, pas à leur emplacement ici : ils paraissent
cassés dans ce dépôt et sont corrects une fois déployés. Ne pas les « réparer ».
