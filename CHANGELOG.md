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
