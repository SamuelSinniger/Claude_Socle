# CHANGELOG du socle

Journal des versions du socle commun. C'est le fichier que lit `/socle update` pour dire à
un projet **ce que la mise à jour implique chez lui** — la liste des fichiers copiés
n'intéresse personne, l'impact rétroactif si.

**Versionnage** : `MAJEURE.MINEURE.CORRECTIF`

| Incrément | Quand | Conséquence pour les projets |
|---|---|---|
| **MAJEURE** | une règle existante **devient plus stricte**, ou une règle est retirée | du code déjà livré peut devenir non conforme → `update` crée des points de mise en conformité |
| **MINEURE** | **nouvelle** règle, nouvel agent, nouvelle commande | idem si la règle s'applique à l'existant |
| **CORRECTIF** | reformulation, correction de lien, précision sans changement de fond | aucun impact rétroactif |

**Chaque entrée de règle porte son impact rétroactif.** Sans lui, `update` ne peut pas
décider s'il faut créer un point : écrire « aucun » est une réponse valable, l'omettre non.

---

## 1.4.0 — 2026-08-23

L'amorçage tient désormais en **un fichier déposé dans le dossier du projet**. Et l'agent
**commite ce qu'il produit** — c'est l'utilisateur qui pousse.

### Ajouté

- **R-064** — Un changement produit par un agent ou une commande est **commité par son
  auteur** ; le `push` appartient à l'utilisateur. Exception : dans le pipeline
  `docs/suivi/`, le commit d'un point reste au `testeur` et à lui seul — un point validé
  donne un commit, et un seul, qui atteste qu'il est *testé*.
  *Impact rétroactif : aucun sur le code livré. C'est le comportement des commandes et des
  agents qui change, pas une exigence sur le projet. Concrètement, `/socle install|update|
  promote|adopt`, `/interop declare|concept` et `doc-updater` ne laissent plus leur travail
  dans le dossier de travail : ils le commitent. La relecture ne disparaît pas, elle se
  déplace après coup — `git show HEAD`, et `git reset --soft HEAD~1` si le compte n'y est
  pas. Rien n'est poussé, donc rien n'est irréversible.*

- **R-065** — Un agent ne stage **que les fichiers qu'il a lui-même écrits**
  (`git add <chemins>`, jamais `-A` ni `.`) ; ce qui appartient à un autre auteur reste dans
  le dossier de travail et est signalé dans son rapport.
  *Impact rétroactif : aucun. C'est le garde-fou de R-064 : `doc-updater` tourne en
  arrière-plan juste après un commit, pendant que l'humain travaille — un `git add -A`
  emporterait ses modifications en cours.*

- **R-066** — Un agent ne fait jamais de `--amend`, de `--no-verify`, ni de réécriture
  d'historique : il ajoute un commit.
  *Impact rétroactif : aucun — le `testeur` s'y tenait déjà, la règle l'étend à tous.*

- **R-067** — Une question posée à l'utilisateur lui présente des **options** (2 à 4), avec
  la conséquence de chacune et la recommandée en premier (`AskUserQuestion` sous Claude
  Code). Exception : les réponses qui ne s'énumèrent pas — cadrage d'un besoin, « pourquoi »,
  valeur à saisir. Énumérer les possibles est le travail de l'agent, qui vient de lire le
  code ; une question ouverte le renvoie à l'utilisateur.
  *Impact rétroactif : aucun sur le code livré — c'est la conduite du dialogue qui change.
  Nouvelle section « Dialogue avec l'utilisateur » dans les règles communes : le socle
  n'avait jusqu'ici aucune règle sur la façon de poser une question.*

- **R-068** — Une décision **répétée sur une série** se présente comme un tableau déjà rempli
  de la proposition de l'agent, à amender — pas comme N questions successives.
  *Impact rétroactif : aucun. C'est `/socle adopt` qui en avait le plus besoin : un projet
  qui arrive avec vingt règles se voyait poser vingt questions, et l'attention était épuisée
  avant la ligne qui comptait. Le classement se valide désormais en bloc, et seuls deux cas
  gardent leur question propre — une règle en contradiction avec le socle, une règle plus
  stricte —, regroupés par cas et non par règle.*

- [`socle/outils/amorcer.ps1`](socle/outils/amorcer.ps1) et
  [`amorcer.sh`](socle/outils/amorcer.sh) : l'amorceur se dépose à la racine du projet et se
  lance **sans argument**. Il localise le dépôt socle (option, `CLAUDE_SOCLE`, voisin
  `Claude_Socle` du projet, dossier personnel), le **clone à côté du projet** s'il est absent,
  **récupère l'amont** s'il est présent — installer depuis un clone en retard de trois
  versions installerait un socle périmé —, propose `git init -b main` si le projet n'est pas
  un dépôt, puis passe la main à `installer.ps1`/`installer.sh`.
  L'amorceur ne copie rien lui-même : la mécanique reste dans l'installeur, qui lit le
  manifeste. Une seule source de vérité, et un amorceur qui ne vieillit pas avec le socle.
  **Il s'efface une fois l'installation faite** — il n'a de raison d'être qu'une fois, et un
  fichier d'amorçage qui reste finit non suivi dans un coin, ou commité dans le projet (c'est
  arrivé sur Quizzeur). Il ne s'efface pas s'il a été lancé depuis ailleurs (`--projet`), ni
  si git le suit déjà : dans ce dernier cas il le dit, plutôt que de fabriquer une suppression
  à commiter. `--garder` / `-Garder` pour amorcer plusieurs projets avec le même fichier.
  *Impact rétroactif : aucun — les installeurs sont inchangés, un projet déjà amorcé n'a rien
  à faire. Le prérequis « cloner le socle une fois par machine » disparaît de la marche à
  suivre : le fichier déposé s'en charge.*
- `DEMARRER.md` : étape 1 réécrite autour du fichier déposé, avec les deux formes sans dépôt
  préalable (`irm | scriptblock` en PowerShell, `curl | sh` en POSIX) et le rappel que
  l'amorceur se supprime une fois qu'il a tourné — il n'a pas à être commité dans le projet.

- [`socle/outils/nouveau-socle.sh`](socle/outils/nouveau-socle.sh) : créer un **second
  socle**, pour un ensemble de projets distinct. L'identité d'un socle est écrite à neuf
  endroits, dont **deux fichiers distribués** (`socle/commandes/socle.md`, `interop.md`) : un
  dépôt recopié à la main sans les corriger déploie chez ses projets des commandes qui
  pointent vers le dépôt d'origine, et le premier `/socle update` les resynchronise sur le
  mauvais socle. L'outil réécrit les neuf, remet les registres à zéro, réécrit le CHANGELOG
  en `1.0.0` avec la provenance, initialise le dépôt et génère le manifeste.
  Deux modes, sans valeur par défaut — c'est la décision de départ, elle se prend :
  `--jumeau` (la machinerie et les 45 règles) ou `--vierge` (la machinerie seule, corpus
  vide, à construire depuis les projets).
  *Impact rétroactif : aucun. À savoir avant de s'en servir : les deux corpus divergent
  dès la création — une règle promue dans l'un n'ira pas dans l'autre, et un même `R-###`
  pourra désigner deux règles différentes. Une dérogation déclarée suffit souvent ; deux
  socles se justifient quand les projets n'ont ni le même domaine ni les mêmes lecteurs.*

### Modifié

- `/socle`, `/interop`, `/update-docs` et l'agent `doc-updater` : les « ne rien commiter »
  deviennent des commits nommés — `socle: installation <version>`, `socle: mise à jour
  <version>`, `socle <version> — <règle>`, `interop: <projet> — <ce qui change>`, `docs: …`.
  Aucun ne pousse. Deux points d'arrêt restent sans écriture donc sans commit : le classement
  des règles d'`adopt`, et un fichier socle modifié localement vu par `update`.
- Les deux amorceurs n'acceptent plus **que le clone de leur propre socle** : le manifeste
  d'un candidat doit porter le dépôt de l'amorceur, sinon il est ignoré pendant la recherche,
  et refusé avec les deux URL en clair s'il a été désigné par `--socle`. Sans cette
  vérification, deux socles sur une machine se confondaient — le voisin trouvé le premier
  gagnait, quel que soit le socle auquel le projet appartenait. Un manifeste sans dépôt
  (socle purement local) reste accepté : on ne peut rien en conclure.
  *Impact rétroactif : aucun tant qu'il n'y a qu'un socle sur la machine.*
- `.githooks/post-commit` : la consigne passée au CLI demande désormais le commit (sujet
  `docs:`, staging nommé) et autorise explicitement `git add`/`git commit` — sans quoi, en
  mode `-p`, le commit serait refusé sans question posée. Le préfixe `docs:` est déjà un
  garde-fou du hook : il sort quand il se redéclenche sur le commit de `doc-updater`.
  *Impact rétroactif : aucun. En cas d'échec du commit (index verrouillé, `rebase` en cours,
  permission refusée), l'agent laisse tout dans le dossier de travail et le dit — c'est-à-dire
  exactement le comportement d'avant.*

### Corrigé

- **`/socle install` n'était pas une étape.** La marche à suivre ne le nommait que dans une
  colonne *Suite* d'un tableau : on pouvait lire `DEMARRER.md` en entier et croire qu'après
  le script, il n'y avait plus qu'à remplir les modèles. Sur un projet **existant**, c'est
  l'erreur qui coûte le plus cher : le script pose le socle sans toucher au `CLAUDE.md`, donc
  rien n'y mentionne le socle, donc aucun agent ne le lit — le socle est installé et
  **inerte**. Sur un projet neuf, elle laisse le projet hors du registre `projets.md` et les
  dossiers posés non suivis. `DEMARRER.md` a désormais une étape 3 dédiée, entre la relance
  de session et le remplissage du squelette.
- Les deux installeurs ne disaient pas mieux : leur dernière ligne annonçait « Fait » puis
  proposait `/socle check` (projet neuf) ou `/socle adopt` (projet existant), sans dire que
  l'installation n'était pas terminée. Ils affichent maintenant les trois étapes qui
  restent — relancer la session, `/socle install`, remplir — et ce qui se perd à les sauter.
  *Impact rétroactif : à vérifier dans les projets déjà installés — si `CLAUDE.md` ne porte
  pas la section `⚙️ Socle commun`, le socle y est inerte : lancer `/socle install`.*

Les quatre suivants viennent d'un audit des deux projets installés (Argonaute, Quizzeur) :
chacun est un défaut que l'installation réelle a révélé et que rien n'aurait signalé.

- **`check` pouvait répondre « à jour » à tort.** Il comparait les fichiers du projet à son
  manifeste **local**, puis les deux **numéros** de version. Même numéro + contenu différent
  — une version modifiée après avoir été installée quelque part — passait entre les deux
  mailles. Les empreintes sont désormais comparées **aussi au manifeste amont**, et le cas a
  sa ligne dans le tableau des constats : le numéro ment, c'est une anomalie de publication,
  pas un retard. Corollaire : **une version déjà installée quelque part ne se modifie plus.**
  *Impact rétroactif : relancer `/socle check` dans les projets installés — un « à jour »
  d'avant cette correction ne prouvait rien sur le contenu.*
- **Les lignes `.gitignore` du socle n'arrivaient jamais dans un projet existant.** Le modèle
  ignore `.claude/doc-updater.log` et `.claude/doc-updates-pending.log`, mais les modèles ne
  sont copiés que là où le fichier est **absent** — or tout projet existant a déjà un
  `.gitignore`. `install` **insère** maintenant les lignes manquantes, comme il le fait déjà
  pour le `CLAUDE.md`.
  *Impact rétroactif : les deux projets installés n'avaient pas ces lignes et voyaient la
  file d'attente de `doc-updater` traîner en non suivi.*
- **L'installation du socle réveillait `doc-updater` sur elle-même.** `socle: installation
  1.4.0` comptait pour un « gros changement » (2 471 lignes ; `.gitattributes`,
  `.githooks/post-commit` et `socle/socle.json` comptés comme du code) et mettait en file une
  mise à jour de doc qui n'avait rien à dire du projet. Le hook s'abstient désormais sur les
  sujets `socle:`, comme il le fait déjà sur `docs:`.
  *Impact rétroactif : aucun — vider la file (`.claude/doc-updates-pending.log`) si elle ne
  contient que des commits de socle.*
- **`installer.ps1` écrivait `socle/socle.json` avec un BOM** (`Set-Content -Encoding utf8`
  en PowerShell 5.1 en ajoute un), là où `installer.sh` n'en met pas : deux projets installés
  depuis la même version n'avaient pas le même manifeste, octet pour octet. Écriture par
  `UTF8Encoding($false)` ; les deux installeurs produisent maintenant exactement le même
  fichier — vérifié par `cmp`.
  *Impact rétroactif : Quizzeur porte ce BOM ; il disparaît à la prochaine copie du
  manifeste.*

---

## 1.3.0 — 2026-08-22

Six règles remontées de l'adoption d'**Argonaute** : sécurité serveur, droits des médias,
sérialisation des énumérés, casse de nommage. Trois sections nouvelles — le socle n'avait
jusqu'ici **aucune règle de sécurité**.

### Ajouté

- **R-023** — Le nommage suit la casse idiomatique de chaque langage du projet, telle que
  déclarée dans `docs/conventions.md`.
  *Impact rétroactif : un projet dont `docs/conventions.md` ne déclare pas de tableau de
  casse est non conforme → point de mise en conformité. Le code existant est rarement en
  cause ; c'est la **déclaration** qui manque.*

- **R-100** — Toute mutation exposée par une interface distante exige une autorisation
  vérifiée côté serveur.
  *Impact rétroactif : **à auditer dans tout projet exposant une API**. Une route de mutation
  sans autorisation est une faille ouverte, pas une dette de style → point de mise en
  conformité en importance 🔴.*

- **R-101** — Le filtrage de visibilité (brouillon/publié, privé/public) est appliqué côté
  serveur ; un filtre client n'est qu'un confort d'affichage.
  *Impact rétroactif : **à auditer**. Le cas typique est un endpoint public qui renvoie tout
  et une interface qui masque — la donnée fuite pour qui appelle l'API directement.*

- **R-110** — Tout média tiers porte crédit, licence et URL de source ; la licence est
  obligatoire, le crédit peut manquer si l'auteur est inconnu.
  *Impact rétroactif : un projet affichant des médias tiers sans champs de droits est non
  conforme → point de mise en conformité, avec reprise du corpus existant (le plus coûteux :
  l'information manquante est souvent introuvable a posteriori).*

- **R-111** — L'attribution d'un média est visible là où le média apparaît.
  *Impact rétroactif : à vérifier surface par surface. Un projet conforme à R-110 peut très
  bien stocker les droits sans jamais les afficher — c'est le manquement le plus fréquent.*

- **R-120** — Un type énuméré traversant une frontière de sérialisation est sérialisé par nom
  textuel stable, la conversion étant portée par le type lui-même.
  *Impact rétroactif : à auditer sur les enums déjà exposés. Le manquement ne se voit pas au
  build — il casse un consommateur qui utilise ses propres options de sérialisation. Leçon
  d'un bug réel (catalogue de tags cassé → carte vide).*

### Note de format

Les six règles portent leurs champs `Vérifiable par` et `Exception`, comme l'exige
[`normes-format.md`](socle/normes-format.md). Les **34 règles antérieures ne les portent
pas** : l'agent `normes` ne peut donc les traiter qu'en remarque, jamais en constat bloquant.
Mise à niveau à prévoir dans une version ultérieure.

---

## 1.2.1 — 2026-08-22

### Corrigé

- Le manifeste publié ne contient **plus de chemin local** : `clone_local` pointait sur la
  machine de génération (`F:/Claude-Socle`), donc faux sur tout autre poste et bruyant dans
  chaque diff. `depot` (l'URL) appartient au dépôt, `clone_local` appartient à
  l'installation : ce sont désormais les installeurs qui l'inscrivent dans la copie du
  projet, où l'information est vraie.
  *Impact rétroactif : aucun — un projet déjà amorcé garde un `clone_local` valide.*
- `DEMARRER.md` : exemples de commandes en `<socle>` / `<projet>` au lieu d'un chemin de
  machine, et ajout des trois obstacles rencontrés à l'amorçage — `sh` absent du `PATH`
  PowerShell, stratégie d'exécution qui bloque les `.ps1`, et **session à relancer** pour que
  les commandes et les agents soient découverts.

---

## 1.2.0 — 2026-08-22

Adoption d'un projet qui a **déjà** ses propres règles.

### Ajouté

- `/socle adopt` : inventorie les règles existantes d'un projet (`CLAUDE.md`, `AGENTS.md`,
  `.cursorrules`, `docs/`, `CONTRIBUTING`…), les classe en cinq catégories — **déjà
  couverte** · **générique à promouvoir** · **plus stricte que le socle** · **spécifique au
  projet** · **en contradiction** — présente le tableau, et n'applique que ce que
  l'utilisateur valide. Une règle qui monte dans le socle s'imposant à tous les projets,
  aucune promotion n'est automatique.
- [`DEMARRER.md`](DEMARRER.md) : marche à suivre pour démarrer un projet sur le socle —
  prérequis, installation, **ordre** dans lequel remplir le squelette, premier point dans le
  pipeline, et les cinq erreurs classiques.
- L'adoption se termine par un `check` et la création des **points de mise en conformité** :
  un projet adopté n'est pas un projet conforme, il est mesuré.

### Corrigé

- **Amorçage impossible** : `/socle install` était censé installer le socle, mais la commande
  `/socle` est elle-même **distribuée par le socle** — elle n'existe donc pas dans un projet
  où le socle n'est pas encore installé. Ajout de
  [`socle/outils/installer.ps1`](socle/outils/installer.ps1) (PowerShell) et
  [`installer.sh`](socle/outils/installer.sh) (POSIX) — `sh` n'étant pas dans le `PATH` de
  PowerShell, la version `.ps1` est nécessaire sous Windows. Ils font la copie mécanique selon  le manifeste, détectent si le projet a déjà ses propres règles (auquel cas ils ne posent **que**
  les fichiers distribués, sans toucher aux `CLAUDE.md`/`docs/` existants) et activent le hook.
  La réconciliation des règles reste à `/socle adopt`, disponible dès que le script a tourné.
  *Impact rétroactif : aucun.*
- `install` sur un projet ayant déjà un `CLAUDE.md` laissait le socle **inerte** : le fichier
  n'étant pas écrasé, l'index du projet ne mentionnait pas le socle et aucun agent ne le
  lisait. `install` **insère** désormais les sections *Socle commun* et *Dérogations* dans le
  `CLAUDE.md` existant. Et il **détecte** les règles préexistantes : dans ce cas il bascule
  de lui-même en `adopt` au lieu de renvoyer l'utilisateur vers une autre commande — `adopt`
  s'arrêtant de toute façon sur le classement à valider, l'aller-retour ne protégeait rien.
  *Impact rétroactif : aucun (aucun projet installé à ce jour).*

---

## 1.1.0 — 2026-08-22

Interopérabilité **entre les projets du socle**, et plus seulement avec l'extérieur.

### Ajouté — registre partagé

- [`interop.md`](interop.md) à la racine du dépôt socle : un **lexique de concepts** `C-XXX`
  (définition, synonymes, **format canonique**, **clés d'appariement**) et les
  **déclarations** de chaque projet. L'appariement se fait sur le concept, jamais sur le nom
  d'entité — `Place`, `Lieu`, `POI` et `Spot` sont le même `C-LIEU`.
- Commande `/interop` : `declare` (publier ce que ce projet sait faire), `check` (trouver les
  correspondances et les transformer en points), `concept` (consulter ou enrichir le lexique).
- Le `chef-de-projet` consulte le registre **au cadrage** : si un autre projet exporte déjà
  le concept en jeu, il propose l'import au lieu de la saisie manuelle.

### Ajouté — règles

| Règles | Sujet | Impact rétroactif |
|---|---|---|
| `R-047` | Toute surface d'interopérabilité est déclarée (concept + clés) dans `docs/commands-and-data.md` et publiée au registre | **Moyen** : recenser les exports existants et les déclarer |
| `R-048` | Le **format canonique** du concept prime ; s'en écarter demande une décision écrite | **Moyen** : un export existant dans un format maison là où un standard existe devient non conforme |
| `R-049` | Un export porte des **clés d'appariement** — sinon il produit des doublons à l'import | **Moyen** : vérifier les exports existants |

### Modifié

- Le tableau *Import / export* de `docs/commands-and-data.md` gagne les colonnes **Concept**
  et **Clés d'appariement**. Il reste la **source de vérité** ; le registre n'en est que la
  projection.

---

## 1.0.0 — 2026-08-22

Première version du socle.

### Ajouté — règles communes (`socle/regles-communes.md`)

| Règles | Sujet | Impact rétroactif |
|---|---|---|
| `R-001` `R-002` | Commentaire obligatoire sur chaque fonction et chaque variable à l'initialisation | **Fort** sur un projet existant : audit à prévoir |
| `R-010` `R-011` | Dire comment vérifier avant de coder ; build et tests à 0 erreur / 0 warning après | Aucun sur le code, change la méthode de travail |
| `R-020` → `R-022` | Naming anglais, commentaires et doc en français, langue d'interface déclarée | **Fort** si le projet mélange les langues |
| `R-030` → `R-032` | Aucune valeur magique, aucun fichier inutile, factorisation systématique | **Moyen** : dette existante à recenser |
| `R-040` → `R-046` | Interopérabilité : export proposé systématiquement, format standard du domaine, aller-retour sans perte, export complet, import tolérant, aucune donnée prisonnière de l'interface | **Moyen** : recenser les entités sans export |
| `R-050` `R-051` | Doc à jour après chaque changement structurant ; format d'import/export documenté | Faible |
| `R-060` → `R-063` | Pipeline de suivi, importance et effort, règle d'importance, critères de vérification obligatoires | Aucun sur le code |
| `R-070` → `R-072` | Décisions datées, options écartées motivées, bug corrigé qui laisse une règle | Aucun sur le code |
| `R-080` → `R-082` | i18n : aucun texte d'interface en dur, clés en anglais, limites documentées | **Fort** si le projet a des textes en dur |
| `R-090` `R-091` | Styles centralisés et préfixés, valeurs répétées en variables | **Moyen** |

### Ajouté — agents et commandes

- Agents : `chef-de-projet` (cadre, dispatche, seul en contact avec l'utilisateur),
  `developpeur`, `normes` (conformité avant test), `testeur` (valide et commite),
  `doc-updater` (documentation).
- Commandes : `/point`, `/detail`, `/update-docs`, `/socle`.
- Hook `post-commit` : réveille `doc-updater` sur les commits structurants.

### Ajouté — cadres documentaires

- `guide-doc.md` — familles de fichiers, frontière socle / projet, quel changement va où.
- `suivi-contrat.md` — pipeline en quatre listes, portes *feu vert* et *conformité*, format
  d'un point.
- `normes-format.md` — comment s'écrit une règle opposable (identifiant, moyen de constat,
  exception).
- `modeles/` — squelette de projet : `CLAUDE.md`, `README.md`, `docs/**`.
