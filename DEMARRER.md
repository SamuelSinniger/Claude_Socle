# Démarrer un projet sur le socle

Marche à suivre pour un projet **neuf**. Pour un projet **existant qui a déjà ses règles**,
c'est le même point de départ : `/socle install` détecte les règles préexistantes et bascule
de lui-même en `adopt` (réconciliation des règles avant installation).

## 1. Amorcer — un fichier déposé dans le dossier du projet

⚠️ **La commande `/socle` est distribuée *par* le socle** : elle n'existe pas encore dans un
projet où le socle n'est pas installé. L'amorçage passe donc par un script, une fois.

Un seul fichier à récupérer et à déposer **à la racine du projet** — neuf ou existant :

| Système | Fichier | Lancement |
|---|---|---|
| Windows | [`amorcer.ps1`](socle/outils/amorcer.ps1) | `.\amorcer.ps1` |
| macOS, Linux, Git Bash | [`amorcer.sh`](socle/outils/amorcer.sh) | `sh amorcer.sh` |

Sans argument : il se sait dans le projet. Ce qu'il fait, dans l'ordre —

1. **trouve le dépôt socle** sur la machine (`-Socle`/`--socle` s'il est ailleurs, la
   variable `CLAUDE_SOCLE`, le voisin `Claude_Socle` du projet, le dossier personnel) ;
2. **le clone à côté du projet** s'il ne le trouve pas, jamais dedans, après confirmation ;
   sinon **récupère l'amont** — installer depuis un clone en retard de trois versions
   installerait un socle périmé ;
3. `git init -b main` si le projet n'est pas encore un dépôt (il le propose) ;
4. **passe la main à l'installeur** du socle, qui fait la copie selon le manifeste.

Il ne demande rien avec `-Oui` / `--oui`. Et **il s'efface tout seul** une fois l'installation
faite : il n'a de raison d'être qu'une fois, et n'a rien à faire dans l'historique du projet.
Deux réserves — il ne s'efface pas s'il a été lancé depuis ailleurs (`-Projet` / `--projet`),
et pas non plus si git le suit déjà : il le dit alors plutôt que de fabriquer une suppression
à commiter. `-Garder` / `--garder` pour amorcer plusieurs projets avec le même fichier.

**Si PowerShell refuse d'exécuter le fichier** (« l'exécution de scripts est désactivée sur ce
système ») — c'est la stratégie d'exécution par défaut de Windows. Contourne-la **pour ce
seul appel**, sans rien changer sur la machine :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\amorcer.ps1
```

**Sans même déposer de fichier**, si le dépôt est accessible depuis la machine — depuis le
dossier du projet :

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/SamuelSinniger/Claude_Socle/main/socle/outils/amorcer.ps1)))
```

```bash
curl -fsSL https://raw.githubusercontent.com/SamuelSinniger/Claude_Socle/main/socle/outils/amorcer.sh | sh
```

**Si le clone du socle est déjà là**, l'amorceur ne sert à rien : appelle directement
l'installeur, qui fait le même travail à partir du dépôt.

```powershell
& <socle>\socle\outils\installer.ps1 -Projet <projet>
```

```bash
sh <socle>/socle/outils/installer.sh <projet>
```

Optionnel mais recommandé, une fois par machine — le CLI Claude Code, sans lequel le hook
`post-commit` ne peut pas réveiller `doc-updater` tout seul (il note alors les commits en
attente, à traiter avec `/update-docs`) :

```bash
npm install -g @anthropic-ai/claude-code
```

## 2. Ce que l'amorçage pose

Un dépôt git n'est pas facultatif : le hook de documentation, le contrôle de conformité
(qui lit le **diff** d'un point) et le commit du `testeur` en dépendent. L'amorceur le crée
si besoin.

L'installeur détecte le type de projet et adapte ce qu'il pose :

| Projet | Ce qui est copié | Suite |
|---|---|---|
| **vierge** | les 18 fichiers distribués **+ les modèles** là où le fichier est absent | `/socle install` (étape 3), puis remplir le squelette |
| **existant, avec ses propres règles** | **uniquement** les 18 fichiers distribués — aucun modèle, `CLAUDE.md` et `docs/` intacts | `/socle install` (étape 3), qui bascule en `adopt` et réconcilie les règles avec ta validation |

Il active aussi le hook (`core.hooksPath`) et t'affiche la marche à suivre. Si la détection
se trompe, force-la : `-Mode complet` / `-Mode socle-seul` en PowerShell, `--complet` /
`--socle-seul` en POSIX — les deux amorceurs passent l'option à l'installeur.

À partir de là, `/socle` et les sept commandes existent dans le projet : tout le reste passe
par elles — à commencer par `/socle install`, qui **termine** l'installation (étape 3).

Ce que l'installation pose :

- copie les **18 fichiers synchronisés** — `socle/` (règles communes, contrat de suivi, guide
  doc, format des normes), `.claude/agents/` (les 5 agents), `.claude/commands/` (les 7
  commandes), `.githooks/` ;
- copie les **19 modèles** — `CLAUDE.md`, `README.md`, `docs/**` — **uniquement là où le
  fichier n'existe pas déjà**, et seulement en mode complet ;
- pose `socle/socle.json`, qui dit au projet quelle version il a — et où trouver le socle sur
  cette machine (`clone_local`, inscrit à l'installation ; le manifeste publié, lui, ne
  contient aucun chemin local).

Si le hook n'a pas pu être activé (projet sans dépôt git au moment de l'amorçage) :

```bash
git config core.hooksPath .githooks
```

### ⚠️ Relancer la session Claude Code

**Les commandes et les agents sont découverts au démarrage de la session.** Une session
ouverte *avant* l'amorçage ne verra ni `/socle`, ni `/point`, ni les cinq agents — et
répondra que la commande n'existe pas alors que les fichiers sont bien là.

Ferme et rouvre la session dans le projet après l'amorçage. Et note que ces commandes
n'existent **que dans un projet** : le dépôt socle lui-même n'a pas de `.claude/`, ses
commandes vivent dans `socle/commandes/`, d'où elles sont distribuées.

## 3. Terminer l'installation — `/socle install`

**L'amorçage ne suffit pas.** Le script fait la copie ; il ne sait rien faire qui demande du
jugement. Première commande de la session que tu viens de rouvrir :

```
/socle install
```

Elle se route toute seule selon ce que le script a trouvé :

| Projet | Ce que `/socle install` fait de plus | Sans quoi |
|---|---|---|
| **vierge** | inscrit le projet dans le `projets.md` du socle, commite ce qui a été posé, liste ce qui reste à remplir | le projet n'est dans aucun registre — « mettre à jour partout » ne le connaît pas — et les dossiers posés, non suivis, disparaissent au prochain clone |
| **existant, avec ses propres règles** | **bascule de lui-même en `adopt`** : inventorie tes règles, les classe en cinq catégories, te fait valider, puis insère les sections *Socle commun* et *Dérogations* dans **ton** `CLAUDE.md` et crée les points de mise en conformité | le socle est posé mais **inerte** : rien dans `CLAUDE.md` ne le mentionne, donc aucun agent ne le lit. Le pire des états — installé et sans effet |

C'est la seule étape où on te demande de trancher quelque chose (le classement des règles) :
`adopt` s'arrête sur le tableau et n'écrit rien avant ta validation.

## 4. Remplir le squelette — dans cet ordre

Les modèles sont truffés de `⟨placeholders⟩`. Pour les lister à tout moment :

```bash
grep -rn '⟨' CLAUDE.md README.md docs/
```

**Ne remplis pas tout d'un coup.** L'ordre compte, parce que les deux premiers fichiers
conditionnent le travail des agents :

1. **`CLAUDE.md` § Projet** — trois phrases : ce que fait l'application, pour qui, avec quoi.
   C'est ce que lit chaque agent avant toute chose.
2. **`docs/conventions.md` § Concrétisation** — le tableau qui donne une valeur concrète aux
   règles du socle : quelle commande de build pour `R-011`, quel mécanisme i18n pour `R-080`,
   quel fichier de styles pour `R-090`. Sans lui, la moitié des règles ne sont pas
   applicables : le socle ne présume rien de ta stack, c'est ici qu'on la déclare.
3. **`docs/commands-and-data.md`** — comment on lance le projet, et son tableau
   *Import / export*.
4. **`docs/architecture.md`** dès que l'arborescence existe vraiment.
5. Le reste **quand il a quelque chose à dire**. `docs/api.md` sans API, `docs/data-model.md`
   sans entité : laisse-les tels quels ou supprime-les. Un fichier de doc à moitié rempli est
   pire qu'un fichier absent — il donne l'illusion d'être une référence.

Un modèle qui ne s'appliquera **jamais** à ce projet (pas d'API, pas de base de données) se
supprime, **avec sa ligne dans l'index `CLAUDE.md`**. Rien n'oblige un projet à porter les
vingt fichiers.

## 5. Avant d'écrire du code : regarder ce qui existe ailleurs

```
/interop check
```

À faire **tôt**, pas après avoir codé : la commande dit si un autre projet du socle exporte
déjà une donnée que tu t'apprêtes à saisir à la main (un catalogue de lieux, une liste
d'événements…). Ça peut changer ce que tu construis — importer plutôt que ressaisir.

Et dès que ce projet produit son premier export :

```
/interop declare
```

## 6. Le premier point

Tout travail passe par le pipeline. On ne code pas « en dehors ».

```
/point ajoute un point pour <ce que tu veux faire>
```

Le `chef-de-projet` te fait préciser le besoin, le périmètre et surtout les **critères de
vérification** — la question « comment sauras-tu que c'est fait ? » est le cœur du cadrage.
Puis le trajet :

```
1-backlog  →  2-en-cours § Prêt à démarrer  →(ton feu vert)→  § En cours
           →  3-a-tester  →(normes)→ conforme →(testeur)→  4-termine + commit
```

Deux portes ne s'ouvrent que par une décision : le **feu vert** (toi, et personne d'autre) et
la **conformité** (l'agent `normes`, citation à l'appui). Besoin du dessous des cartes avant
de trancher ? `/detail P-00X`.

## 7. Vérifier que l'installation tient

```
/socle check
```

Attendu : version installée = version disponible, aucun fichier socle modifié localement,
aucune dérogation morte.

Si `/socle check` répond que la commande n'existe pas, ce n'est pas l'amorçage qui a échoué :
**relance la session** (voir l'avertissement de l'étape 2), et assure-toi d'être dans le
projet, pas dans le dépôt socle.

Les quatre signes d'un amorçage réussi, vérifiables à la main :

| Signe | Commande |
|---|---|
| Le manifeste est là, avec sa version | `cat socle/socle.json` (5 premières lignes) |
| Les 5 agents et les 7 commandes | `ls .claude/agents .claude/commands` |
| Le hook est branché | `git config --get core.hooksPath` → `.githooks` |
| **La doc du projet est intacte** | `git status --short` → uniquement `.claude/`, `.githooks/`, `socle/` en non suivis, **aucun** fichier suivi modifié |

Attention au faux positif sur le dernier point : tester la simple *présence* de `CLAUDE.md`
ou `docs/api.md` ne prouve rien sur un projet existant — ce sont ses propres fichiers. La
preuve qu'aucun modèle n'a été copié, c'est que les modèles qu'il ne possédait **pas**
(`docs/suivi/*`, `docs/normes/_index.md`) sont toujours absents, et que `git diff` sur la doc
ne renvoie rien.

Enfin, les dossiers posés sont **non suivis** : pense à les commiter, sinon le socle disparaît
au prochain clone.

## Les cinq erreurs classiques

| Erreur | Conséquence | À faire à la place |
|---|---|---|
| Modifier un fichier de `socle/` pour l'adapter au projet | `/socle check` le signale, `/socle update` l'écrase | Déclarer une **dérogation** dans `CLAUDE.md` (règle, pratique retenue, raison, date) |
| Oublier `core.hooksPath .githooks` | La doc ne se met plus à jour toute seule | La commande de l'étape 2, une fois par clone |
| Remplir les vingt modèles le premier jour | Vingt fichiers faux à maintenir | `CLAUDE.md` + `conventions.md`, le reste au fil de l'eau |
| Laisser des `⟨placeholders⟩` dans `CLAUDE.md` | Les agents travaillent sur une description vide | `grep -rn '⟨' CLAUDE.md` avant le premier point |
| Écrire une règle générale dans `docs/conventions.md` | Elle reste enfermée dans ce projet | `/socle promote "<la règle>"` — tous les projets en bénéficient |

## Ensuite

- Une règle manquante découverte en codant → `/socle promote`.
- Le socle a une nouvelle version → `/socle update` (il lit le CHANGELOG et crée les points de
  **mise en conformité** que les nouvelles règles impliquent).
- Détail des commandes et de la mécanique : [README.md](README.md).
