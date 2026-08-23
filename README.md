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
>
> **À faire lire à quelqu'un qui ne l'utilise pas encore : [PRESENTATION.md](PRESENTATION.md)**
> — à quoi ça sert, ce que ça change au quotidien, et le bilan honnête (ce que ça donne *et*
> ce que ça coûte).

## Ce qu'il contient

```
socle/
├── socle.json            manifeste : chaque fichier distribué, sa destination, son empreinte
├── regles-communes.md    les règles impératives R-### (le cœur)
├── suivi-contrat.md      le pipeline des points : 4 listes, portes, format d'un point
├── guide-doc.md          règles du dossier docs/ et frontière socle / projet
├── normes-format.md      comment s'écrit une règle opposable
├── agents/               les 5 agents           → .claude/agents/ dans un projet
├── commandes/            les 7 commandes        → .claude/commands/
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

## Créer un **second** socle, pour un autre ensemble de projets

Un socle porte son identité — l'URL de son dépôt, le nom de son dossier de clone — à **neuf
endroits**, dont deux fichiers **distribués** (`socle/commandes/socle.md`, `interop.md`).
Recopier le dépôt à la main sans les corriger produit un socle qui déploie, dans ses propres
projets, des commandes pointant vers le dépôt d'origine. D'où l'outil :

```bash
sh socle/outils/nouveau-socle.sh <chemin-du-nouveau-socle> <url-du-dépôt> --jumeau
# ou, sans dépôt distant pour l’instant :
sh socle/outils/nouveau-socle.sh <chemin-du-nouveau-socle> --local --jumeau
```

Le mode n'a pas de défaut, parce que c'est la décision de départ :

| Mode | Ce qu'il produit | Pour qui |
|---|---|---|
| `--jumeau` | la machinerie **et** les règles actuelles | un ensemble de projets qui ressemble au premier : on part d'un corpus éprouvé |
| `--vierge` | la machinerie seule — agents, commandes, pipeline, modèles, format des normes — et **aucune règle** | un domaine différent : le corpus se construira depuis les projets, par `/socle adopt` puis `/socle promote` |

Dans les deux cas : registres remis à zéro (`projets.md`, déclarations d'`interop.md`),
`CHANGELOG` réécrit en `1.0.0` avec la provenance, dépôt git initialisé, manifeste généré.

**Les deux corpus divergent à partir de là.** Une règle promue dans l'un n'ira pas dans
l'autre, et un même `R-###` pourra désigner deux règles différentes : chaque
`regles-communes.md` fait autorité pour ses seuls projets. C'est le prix de la séparation —
avant de le payer, vérifier qu'une **dérogation** déclarée dans un projet ne suffisait pas.

Les socles cohabitent sans se mélanger sur une même machine : chaque amorceur n'accepte qu'un
clone dont le manifeste porte **son** dépôt, et refuse les autres en le disant.

## Note pour l'agent

Les liens des fichiers de `socle/agents/`, `socle/commandes/` et `socle/modeles/` sont
relatifs à leur **destination dans un projet**, pas à leur emplacement ici : ils paraissent
cassés dans ce dépôt et sont corrects une fois déployés. Ne pas les « réparer ».
