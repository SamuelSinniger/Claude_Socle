---
description: Gérer le socle commun de ce projet — état de synchro, mise à jour, promotion d'une règle, installation
argument-hint: "check | update | promote \"<la règle>\" | install [chemin-du-dépôt-socle]"
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

## `install [chemin]` — poser le socle dans un projet neuf

1. Localiser le dépôt socle (argument, ou champ `source` d'un `socle.json` existant, ou
   demander).
2. Copier **toutes** les entrées de `fichiers` vers leurs destinations, plus
   `socle/socle.json`.
3. Copier les `modeles` **uniquement vers les destinations qui n'existent pas encore**. Un
   `CLAUDE.md` ou un `docs/api.md` déjà présent n'est jamais écrasé : le signaler.
4. Activer le hook : `git config core.hooksPath .githooks`.
5. Inscrire le projet dans le `projets.md` du dépôt socle.
6. Dire à l'utilisateur ce qui reste à remplir : les `⟨…⟩` des modèles
   (`grep -rn '⟨' CLAUDE.md README.md docs/`), en commençant par `CLAUDE.md` § *Projet* et
   le tableau de concrétisation de `docs/conventions.md`.

---

## Règles communes aux quatre verbes

- **Aucun commit, aucun push**, ni dans ce projet ni dans le dépôt socle. Tu prépares, tu
  rapportes ; l'utilisateur relit et commite.
- **Aucune modification d'un fichier socle dans un projet**, dans aucun verbe. La seule
  écriture licite côté projet, hors copie : le `CLAUDE.md` (dérogations) et
  `docs/suivi/**` (points de mise en conformité).
- **Le manifeste est la vérité.** Ne devine pas la liste des fichiers du socle : lis-la.
- Si le dépôt socle est introuvable ou dans un état incohérent (manifeste absent, empreintes
  qui ne correspondent pas à son propre contenu), **arrête-toi et dis-le** plutôt que de
  synchroniser depuis une source douteuse.
