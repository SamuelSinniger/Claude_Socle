---
description: Gérer le socle commun de ce projet — état de synchro, mise à jour, promotion d'une règle, installation dans un projet neuf ou adoption d'un projet qui a déjà ses règles
argument-hint: "check | update | promote \"<la règle>\" | install [chemin] | adopt [chemin]"
---

Verbe demandé : $ARGUMENTS  *(vide = `check`)*

Le **socle** est le corps de règles, d'agents et de commandes partagé par tous les projets.
Il vit dans son propre dépôt — **https://github.com/SamuelSinniger/Claude_Socle** — et se
**copie** dans chaque projet. Son manifeste [`socle/socle.json`](../../socle/socle.json) dit,
pour chaque fichier distribué, sa **destination** dans le projet et son **empreinte**.

**Localiser le dépôt socle**, dans cet ordre :

1. le chemin passé en argument, s'il y en a un ;
2. le champ `clone_local` du manifeste, si ce dossier existe sur cette machine ;
3. sinon, cloner depuis le champ `depot` :

   ```bash
   git clone https://github.com/SamuelSinniger/Claude_Socle.git
   ```

   Cloner **à côté du projet**, jamais dedans. Demande à l'utilisateur où le poser plutôt
   que de choisir seul.

Quand le clone local existe, **récupère l'amont avant de comparer** (`git -C <clone> fetch`
puis `git -C <clone> status`) : comparer à un clone en retard de trois versions donnerait un
« à jour » faux. Si le clone a des modifications non commitées, dis-le — la version annoncée
n'est peut-être pas celle qui est publiée.

**Règle absolue** : un fichier du socle ne se modifie **jamais** dans un projet. Pour
s'écarter d'une règle, on déclare une **dérogation** dans le `CLAUDE.md` du projet (règle,
pratique retenue, raison, date).

---

## `check` — où en est ce projet

1. Lire `socle/socle.json` local (version installée) et celui du dépôt socle (version
   disponible).
2. Pour **chaque** entrée de `fichiers`, recalculer l'empreinte de la **destination** dans
   ce projet (`sha256sum <destination> | cut -c1-16`) et la comparer :

   | Constat | Sens | Quoi faire |
   |---|---|---|
   | empreinte identique au manifeste local | à jour | rien |
   | empreinte ≠ manifeste local | **fichier socle modifié localement — interdit** | proposer de convertir en dérogation, puis de restaurer |
   | destination absente | socle incomplet | à réinstaller (`update`) |
   | manifeste amont ≠ manifeste local | version en retard | `update` |

3. Vérifier aussi l'inverse : une **dérogation** déclarée dans `CLAUDE.md` qui cite une règle
   `R-###` **inexistante** dans `socle/regles-communes.md` (règle retirée ou renumérotée) est
   une dérogation morte — la signaler.

Rapport : version locale → version disponible, la liste des écarts, et **une seule** action
recommandée. Rien n'est modifié par `check`.

## `update` — appliquer la version disponible

1. Faire un `check` d'abord. **S'il existe un fichier socle modifié localement, s'arrêter**
   et demander : convertir en dérogation, ou écraser en assumant la perte ? Ne jamais
   écraser en silence.
2. Lire le `CHANGELOG.md` du dépôt socle **entre la version locale et la version
   disponible**. C'est le cœur de l'opération : ce que ça implique ici compte plus que la
   copie des fichiers.
3. Copier les entrées de `fichiers` vers leurs destinations, plus `socle/socle.json`.
   **Ne jamais toucher aux `modeles`** : `CLAUDE.md`, `README.md` et `docs/**` appartiennent
   au projet et ne sont copiés qu'à l'installation.
4. **Traiter la dette rétroactive.** Une règle ajoutée ou durcie rend potentiellement non
   conforme du code déjà livré. Pour chaque règle nouvelle ou modifiée du CHANGELOG :
   - estimer si ce projet est concerné (`Grep` sur le motif de la règle) ;
   - si oui, créer un point **Tâche technique** dans
     [`docs/suivi/2-en-cours.md`](../../docs/suivi/2-en-cours.md) § *Prêt à démarrer*
     (`Feu vert : ⏳ en attente`), intitulé « Mise en conformité `R-###` », avec dans le
     `Besoin` l'identifiant et le texte de la règle, et dans les
     `Critères de vérification` le constat attendu ;
   - si non, le dire dans le rapport plutôt que de créer un point vide.

   Une mise à jour de socle qui ne produit aucun point alors qu'une règle a changé est
   suspecte : dis-le.
5. Mettre à jour la ligne de ce projet dans le `projets.md` du dépôt socle (version, date).
6. Ne **rien commiter** : laisser le tout dans le dossier de travail et lister à l'utilisateur
   ce qu'il doit relire (`git diff`).

## `promote "<la règle>"` — faire monter une règle dans le socle

Le chemin de remontée doit être plus court que le contournement : c'est en travaillant sur un
projet qu'on découvre les règles manquantes.

1. **Vérifier que la règle n'a rien de spécifique au projet.** Si elle nomme une techno, un
   composant ou un domaine propre à ce dépôt, elle ne monte pas : elle va dans
   `docs/conventions.md`. Dis-le et arrête-toi là.
2. **Chercher un doublon** dans `socle/regles-communes.md` : une règle existante qui couvre
   déjà le cas se **précise**, elle ne se duplique pas.
3. Écrire la règle dans le dépôt socle, dans la section thématique adéquate de
   `regles-communes.md`, au format imposé par
   [`socle/normes-format.md`](../../socle/normes-format.md) : identifiant `R-###` neuf
   (jamais réutilisé), formulée **au constat**, avec son moyen de constat et son exception
   explicite ou « aucune ».
4. Ajouter l'entrée au `CHANGELOG.md` du dépôt socle sous une nouvelle version (`mineure`
   pour un ajout, `majeure` si une règle existante devient plus stricte), avec **l'impact
   rétroactif attendu** — c'est ce que liront les `update` des autres projets.
5. Régénérer le manifeste : `sh socle/outils/generer-manifeste.sh <version> <AAAA-MM-JJ>`.
6. Lister, depuis `projets.md`, les projets à mettre à jour — et rappeler que ce projet-ci
   doit lui aussi faire `/socle update` pour recevoir sa propre règle.
7. Ne rien commiter, ni dans le socle ni ici.

## `adopt [chemin]` — faire entrer dans le socle un projet qui a déjà ses règles

Pour un projet **existant** qui possède ses propres règles Claude. `install` seul ne les
regarderait pas : il poserait le socle à côté, laissant deux corps de règles qui s'ignorent.
`adopt` réconcilie d'abord, installe ensuite. **Aucune règle n'est déplacée sans ton accord.**

1. **Inventorier les règles existantes du projet.** Chercher partout où elles se cachent :
   `CLAUDE.md`, `AGENTS.md`, `.cursorrules` et équivalents, `.claude/**`, `CONTRIBUTING*`,
   `docs/**`, les sections « conventions » d'un `README`, les commentaires d'en-tête qui
   énoncent une règle. Extraire **une règle par ligne**, dans les termes du projet.

2. **Classer chaque règle** dans exactement une des cinq catégories :

   | Catégorie | Critère | Destination |
   |---|---|---|
   | **Déjà couverte** | une règle `R-###` du socle dit la même chose | rien — mais la lister, pour que l'utilisateur voie la couverture |
   | **Générique, absente du socle** | vraie pour n'importe quel projet | candidate à `promote` |
   | **Plus stricte que le socle** | même intention, exigence supérieure | proposer de **durcir le socle** (bump MAJEURE) *ou* de garder la version stricte en règle de projet |
   | **Spécifique au projet** | nomme une techno, un composant, un domaine propre au dépôt | `docs/conventions.md` du projet |
   | **En contradiction** | incompatible avec une règle du socle | **décision requise** : dérogation déclarée, ou correction du socle si la règle du projet est la bonne |

   Deux pièges à éviter dans ce classement : ranger en « spécifique » une règle simplement
   *formulée* avec le vocabulaire du projet alors que son fond est général (elle est
   générique — reformule-la) ; et déclarer « déjà couverte » une règle qui dit *presque* la
   même chose (une nuance dans une règle est souvent tout son intérêt — c'est du « plus
   strict »).

3. **Présenter le classement à l'utilisateur** sous forme de tableau, et **s'arrêter là**.
   Une règle qui monte dans le socle s'imposera à tous les autres projets : ce n'est pas une
   décision d'agent. Pour chaque candidate, proposer l'identifiant `R-###` et la formulation
   au format du socle, pour qu'il n'ait qu'à valider ou corriger.

4. **Appliquer ce qui a été validé**, dans cet ordre :
   - les promotions et durcissements, via la procédure `promote` (règle, entrée de CHANGELOG
     avec impact rétroactif, manifeste régénéré) ;
   - `install` pour poser le socle ;
   - les règles spécifiques retenues dans `docs/conventions.md`, réécrites au format du socle ;
   - les contradictions arbitrées en dérogations, dans le tableau du `CLAUDE.md`.

5. **Rendre l'adoption vérifiable.** Une fois le socle posé, lancer un `check`, puis créer les
   points de **mise en conformité** pour les règles du socle que ce projet ne respecte pas
   encore (même logique que `update`, cf. l'impact rétroactif du CHANGELOG). Un projet adopté
   n'est pas un projet conforme : il est *mesuré*.

6. Inscrire le projet dans `projets.md`, colonne dérogations remplie.

## `install [chemin]` — poser le socle dans un projet neuf

1. **Détecter si le projet est réellement neuf**, avant toute copie. Chercher des règles
   préexistantes : `CLAUDE.md`, `AGENTS.md`, `.cursorrules` et équivalents, `.claude/**`,
   `CONTRIBUTING*`, sections « conventions » d'un `README`.
   - Aucun de ces fichiers, ou seulement des fichiers **issus du socle** (ils portent la
     section `⚙️ Socle commun`, ou un `socle/socle.json` est présent) → projet neuf,
     continuer.
   - Des règles **étrangères au socle** → **basculer en `adopt`** et le dire :
     « ce projet a déjà ses règles, je passe par l'adoption ». Pas de question préalable :
     `adopt` fait tout ce que fait `install`, en réconciliant d'abord, et il s'arrête de
     toute façon pour te faire valider le classement avant d'écrire quoi que ce soit.

2. Localiser le dépôt socle (argument, ou champs `clone_local` / `depot` du manifeste, ou
   demander).
3. Copier **toutes** les entrées de `fichiers` vers leurs destinations, plus
   `socle/socle.json`.
4. Copier les `modeles` **uniquement vers les destinations qui n'existent pas encore**. Un
   `CLAUDE.md` ou un `docs/api.md` déjà présent n'est jamais écrasé : le signaler.
   **Exception nécessaire — le `CLAUDE.md` existant** : ne pas l'écraser, mais y **insérer**
   les sections `⚙️ Socle commun` et `🔶 Dérogations au socle` si elles manquent (contenu pris
   du modèle, placé après la section *Projet*). Sans ça, l'index du projet ne mentionne pas le
   socle, et les agents ne le liront jamais : le socle serait installé et inerte.
5. Activer le hook : `git config core.hooksPath .githooks`.
6. Inscrire le projet dans le `projets.md` du dépôt socle.
7. Dire à l'utilisateur ce qui reste à remplir : les `⟨…⟩` des modèles
   (`grep -rn '⟨' CLAUDE.md README.md docs/`), en commençant par `CLAUDE.md` § *Projet* et
   le tableau de concrétisation de `docs/conventions.md`.

---

## Règles communes à tous les verbes

- **Aucun commit, aucun push**, ni dans ce projet ni dans le dépôt socle. Tu prépares, tu
  rapportes ; l'utilisateur relit et commite.
- **Aucune modification d'un fichier socle dans un projet**, dans aucun verbe. La seule
  écriture licite côté projet, hors copie : le `CLAUDE.md` (dérogations) et
  `docs/suivi/**` (points de mise en conformité).
- **Le manifeste est la vérité.** Ne devine pas la liste des fichiers du socle : lis-la.
- Si le dépôt socle est introuvable ou dans un état incohérent (manifeste absent, empreintes
  qui ne correspondent pas à son propre contenu), **arrête-toi et dis-le** plutôt que de
  synchroniser depuis une source douteuse.
