# Règles communes — socle

> **Fichier socle. Ne pas le modifier dans un projet.** Il est distribué et mis à jour
> depuis le dépôt socle ; toute modification locale est signalée par `/socle check`. Un
> projet qui doit s'écarter d'une règle le déclare en **dérogation** dans son `CLAUDE.md`,
> en nommant l'identifiant de la règle et la raison.

Ces règles sont **impératives** et s'appliquent au code de tous les projets qui installent
ce socle. Les conventions propres à un projet vivent dans son
[`docs/conventions.md`](../docs/conventions.md), qui ne les répète pas.

Chaque règle porte un identifiant `R-###` : c'est lui que cite l'agent `normes` quand il
constate un manquement, et lui qu'on nomme dans une dérogation. **Un identifiant ne se
réutilise jamais** ; une règle retirée reste, marquée `— retirée le AAAA-MM-JJ` avec sa
raison.

Quand une règle renvoie à « ce que le projet déclare », l'information est dans le
`CLAUDE.md` du projet ou dans `docs/commands-and-data.md` — le socle ne présume rien de la
stack.

## Commentaires

- **R-001** — Chaque fonction porte un commentaire expliquant son rôle.
- **R-002** — Chaque variable à l'initialisation porte un commentaire expliquant son rôle.

## Vérification

- **R-010** — **Avant** tout travail, indiquer **comment le vérifier** : test manuel,
  commande à lancer, comportement attendu observable.
- **R-011** — **Après**, lancer la commande de vérification du projet (build et tests, telle
  que documentée dans `docs/commands-and-data.md`) : **0 erreur, 0 warning**. Puis vérifier
  le comportement réel, pas seulement la compilation.

## Langue

- **R-020** — **Naming en anglais** : variables, fonctions, assets, clés i18n.
- **R-021** — **Commentaires et documentation en français.**
- **R-022** — L'interface est dans la langue déclarée par le projet, et cette langue est
  déclarée explicitement.

- **R-023** — Le nommage suit la **casse idiomatique de chaque langage** du projet, telle que
  déclarée dans `docs/conventions.md`.

  **Vérifiable par** : lecture du tableau de casse déclaré par le projet, puis relecture des
  identifiants introduits par le diff.
  **Exception** : les identifiants imposés par un format ou une bibliothèque externe.

## Qualité & factorisation

- **R-030** — **Aucune valeur magique** : toute constante arbitraire est paramétrée dans un
  fichier de configuration, jamais dispersée en dur dans le code.
- **R-031** — **Aucun fichier inutile** : un fichier obsolète est supprimé immédiatement.
- **R-032** — **Factorisation systématique** : code dupliqué → fonction ou composant
  partagé ; valeur répétée → constante de configuration ; style répété → variable globale,
  classe utilitaire ou style partagé.

## Interopérabilité (import / export)

> Principe : **les données appartiennent à l'utilisateur.** Une donnée qu'on ne peut sortir
> du logiciel que par copier-coller est une donnée retenue en otage.

- **R-040** — **Le réflexe est systématique** : dès qu'une entité est produite ou accumulée
  par l'utilisateur (une collection, un catalogue, un historique, une fiche), l'export est
  **proposé au cadrage**, ainsi que l'import si la donnée peut venir d'ailleurs. Un projet
  de gestion de bibliothèque propose d'exporter une bibliothèque ; la règle vaut pour toute
  entité de ce genre.
- **R-041** — Un export écarté l'est **explicitement**, avec sa raison notée dans
  `docs/decisions-rejetees.md`. On ne repose plus la question pour cette entité.
- **R-042** — **Format standard du domaine d'abord.** Si un format ouvert existe pour cette
  donnée, on s'y conforme au lieu d'inventer — CSV/JSON pour du tabulaire, iCalendar pour
  des événements, GeoJSON/GPX pour du spatial, MARC/ONIX pour du bibliographique, etc. Un
  format maison ne se justifie qu'en l'absence de standard, et il est alors **versionné et
  documenté**.
- **R-043** — **L'aller-retour est la preuve** : ce qui est exporté doit pouvoir être
  réimporté **sans perte**. C'est un critère de vérification du point, pas une intention.
- **R-044** — **L'export est complet** : il emporte aussi ce que l'interface n'affiche pas
  (métadonnées, droits, dates, identifiants). Un export partiel donne l'illusion de la
  portabilité.
- **R-045** — **Import tolérant, export strict.** À l'import : signaler et neutraliser ce
  qui est inconnu plutôt que rejeter le fichier entier, et proposer une **analyse à blanc**
  (aucune écriture) avant l'import réel. À l'export : produire un fichier valide au regard
  du format, sans champ approximatif.
- **R-046** — **Aucune donnée accessible uniquement par l'interface graphique.** Une API
  documentée, une commande scriptable ou un flux exportable comptent comme surface
  d'interopérabilité au même titre qu'un fichier.
- **R-047** — **Toute surface d'interopérabilité est déclarée** dans le tableau
  *Import / export* de `docs/commands-and-data.md`, avec son **concept** `C-XXX` du lexique
  partagé et ses **clés d'appariement**. Elle est publiée au registre commun par
  `/interop declare`. Un export que les autres projets ignorent ne sert qu'à moitié.
- **R-048** — **Le format canonique du concept prime.** Quand le lexique du registre fixe un
  format pour un concept (GeoJSON pour un lieu, iCalendar pour un événement, MARC/ONIX pour
  un document…), on l'utilise : c'est ce qui rend deux projets interopérables **sans travail
  d'adaptation**. S'en écarter demande une raison écrite dans
  `docs/decisions-prises.md`.
- **R-049** — **Un export porte des clés d'appariement.** Un fichier qu'on ne peut pas
  réimporter sans créer de doublons n'est pas une surface d'interopérabilité. Les
  identifiants purement internes ne comptent que si le référentiel est partagé avec la
  cible.

## Documentation

- **R-050** — Après **chaque** changement structurant, mettre à jour le(s) fichier(s)
  `docs/` concerné(s) **et** l'index `CLAUDE.md`. Règles du dossier :
  [guide-doc.md](guide-doc.md).
- **R-051** — Le format exposé d'un import/export est documenté (champs, version, exemple)
  dans `docs/commands-and-data.md` § *Données*.

## Suivi du travail

- **R-060** — Tout travail passe par le pipeline `docs/suivi/` : un point vit dans **un
  seul** fichier, qui *est* son état. Contrat : [suivi-contrat.md](suivi-contrat.md).
- **R-061** — Chaque point porte une **importance** (🔴 Haute · 🟡 Moyenne · 🟢 Basse) **et**
  un **effort** (⚡ Rapide · ⏳ Moyen · 🐢 Long), estimés dès sa création.
- **R-062** — **Règle d'importance** : une **nouvelle fonctionnalité** est *a priori* moins
  importante qu'une **amélioration ou correction d'existant** (ou que la dette technique, la
  sécurité, un risque de perte de données).
- **R-063** — **Aucun point ne démarre sans critères de vérification observables** : ils
  sont le cahier des charges du test, donc la condition de sortie du backlog.

## Décisions

- **R-070** — Tout choix structurant tranché est consigné **daté** dans
  `docs/decisions-prises.md`.
- **R-071** — Toute option envisagée puis écartée est consignée dans
  `docs/decisions-rejetees.md` **avec sa raison** : c'est ce qui évite d'y revenir six mois
  plus tard.
- **R-072** — Un bug corrigé dont la cause vaut leçon laisse une trace dans
  `docs/bugs.md`, et sa **règle** remonte dans les conventions du projet ou dans le doc de
  son domaine — voire dans ce socle si elle n'a rien de spécifique au projet
  (`/socle promote`).

## i18n

- **R-080** — **Aucune chaîne d'interface en dur** : tout texte affiché passe par le
  dictionnaire centralisé déclaré par le projet.
- **R-081** — **Clés en anglais**, hiérarchiques par zone (`common.*`, `nav.*`, …), et les
  clés génériques sont réutilisées plutôt que redéclarées.
- **R-082** — Les limites connues de l'i18n (endroits où le mécanisme ne passe pas encore)
  sont documentées dans `docs/conventions.md` du projet, pour ne pas être redécouvertes.

## Styles

- **R-090** — Styles **centralisés** dans le fichier déclaré par le projet, avec son
  préfixe ; les exceptions sont explicites et documentées.
- **R-091** — Valeurs répétées (couleurs, espacements) → **variables globales** ; motifs
  répétés → **classes utilitaires** partagées.

## Sécurité

> Principe : **ce que le client filtre, le serveur l'autorise déjà.** Une interface est une
> commodité d'usage, jamais une frontière de sécurité — on peut toujours appeler l'API sans
> elle.

- **R-100** — Toute **mutation** exposée par une interface distante exige une **autorisation
  vérifiée côté serveur**.

  **Vérifiable par** : recensement des routes de mutation (création, modification,
  suppression), et constat de l'attribut ou du middleware d'autorisation sur chacune.
  **Exception** : aucune.

- **R-101** — Le **filtrage de visibilité** d'une donnée (brouillon/publié, privé/public,
  propriétaire/tiers) est appliqué **côté serveur**. Un filtre côté client est un confort
  d'affichage, jamais la garantie.

  **Vérifiable par** : appel direct de l'endpoint public hors de l'interface, et constat que
  la donnée non publiée est absente de la réponse.
  **Exception** : aucune.

## Médias & droits

> Principe : **une image sans licence est une image qu'on n'a pas le droit d'afficher.**
> L'information de droits se perd à la source, jamais à l'affichage : ce qui n'est pas saisi
> au moment de l'ajout est irrécupérable ensuite.

- **R-110** — Tout **média tiers** manipulé par l'application porte ses métadonnées de
  droits : **crédit**, **licence**, **URL de source**. La **licence est obligatoire** dès
  qu'un média est renseigné ; le crédit peut manquer quand l'auteur est inconnu (domaine
  public ancien).

  **Vérifiable par** : constat des trois champs sur l'entité média, et d'un signalement
  visible en saisie quand la licence est absente.
  **Exception** : les médias produits par le projet lui-même, si leur licence est déclarée
  globalement.

- **R-111** — L'**attribution** d'un média est **visible là où le média apparaît**, pas
  reléguée dans une page de mentions.

  **Vérifiable par** : affichage de chaque surface montrant un média (vignette, carrousel,
  bandeau de tête), et constat de l'attribution sur chacune.
  **Exception** : aucune.

## Sérialisation

- **R-120** — Un **type énuméré** qui traverse une frontière de sérialisation est sérialisé
  par **nom textuel stable**, jamais par ordinal, et cette conversion est **portée par le
  type lui-même** — pas par les options de chaque consommateur.

  **Vérifiable par** : lecture d'une réponse contenant l'enum, et constat d'une valeur
  textuelle ; puis désérialisation par un consommateur configuré par défaut, sans convertisseur
  ajouté à la main.
  **Exception** : aucune.
