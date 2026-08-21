# Guide de la documentation

> **Fichier socle. Ne pas le modifier dans un projet.** Distribué et mis à jour depuis le
> dépôt socle ; `/socle check` signale toute modification locale.

Règles de fonctionnement du dossier `docs/`. À lire une fois, puis à respecter à chaque
changement. Ce fichier reste tel quel dans tous les projets — c'est le mode d'emploi,
pas de la doc de projet.

## Socle et projet : la frontière

**Règle absolue : un fichier est soit entièrement socle, soit entièrement projet.** Jamais
les deux. C'est ce qui rend la mise à jour du socle possible sans fusion manuelle.

- **`socle/`** et les fichiers distribués (`.claude/agents/`, `.claude/commands/`,
  `.githooks/`) viennent du dépôt socle. **On ne les modifie pas dans un projet** :
  `/socle check` le signale, `/socle update` l'écraserait.
- **`CLAUDE.md`, `README.md`, `docs/`** appartiennent au projet. Le socle ne les touche
  jamais après la création : ils partent d'un modèle (`socle/modeles/`) et vivent leur vie.
- Pour s'écarter d'une règle du socle : une **dérogation déclarée** dans le `CLAUDE.md` du
  projet (règle, pratique retenue, raison, date). Jamais une modification locale.
- Une règle qui n'a **rien de spécifique** au projet ne s'écrit pas dans `docs/` : elle monte
  dans le socle via `/socle promote`, et tous les projets en bénéficient.

## Principe

La documentation est **découpée par domaine**, pas monolithique :

- **[`../CLAUDE.md`](../CLAUDE.md)** — index de travail : une ligne par fichier `docs/`, le
  renvoi au socle et les **dérogations**. C'est la porte d'entrée de l'agent.
- **[`../README.md`](../README.md)** — spécification fonctionnelle : ce que fait le produit,
  pour un humain qui découvre le projet.
- **`docs/*.md`** — un fichier par domaine. Chaque fichier est autonome : on le lit
  **avant** de modifier son domaine.

Règle d'or : **un domaine = un fichier**. Si une section d'un fichier dépasse ~40 lignes
et traite d'un sujet distinct, elle sort dans son propre fichier + une ligne dans l'index.

## Les familles de fichiers

| Famille | Fichiers | Nature |
| --- | --- | --- |
| **Socle** | `socle/**` | Commun à tous les projets. **Lecture seule ici.** Mis à jour par `/socle update`. |
| **Référence** | `architecture`, `conventions`, `dependencies`, `data-model`, `api`, `commands-and-data`, + un fichier par domaine métier | Décrit l'**état actuel**. Se met à jour *en place* (pas d'historique). |
| **Suivi** | `suivi/1-backlog` → `suivi/2-en-cours` → `suivi/3-a-tester` → `suivi/4-termine` | **Pipeline** : un point vit dans un seul fichier, qui *est* son état. Tenu par les agents du pipeline, pas à la main. Contrat : [suivi-contrat.md](suivi-contrat.md). |
| **Post-mortem** | `bugs` | Bugs corrigés : cause, correctif, règle à en retenir. |
| **Normes** | `normes/**` | Référentiels **fournis** (externes ou d'entreprise), règles identifiées et opposables. Routées par [normes/_index.md](../docs/normes/_index.md). À distinguer de `conventions.md` (règles propres au projet). |
| **Décisions** | `decisions-prises`, `decisions-rejetees` | Journal **append-only**, daté. On n'efface jamais une décision : on en ajoute une nouvelle qui la remplace. |

## Quand mettre à jour quoi

| Le changement touche… | Fichiers à mettre à jour |
| --- | --- |
| La stack, l'organisation des dossiers, un render mode | `architecture.md` |
| Une dépendance ajoutée / retirée / montée de version | `dependencies.md` |
| Une entité, un champ, une migration | `data-model.md` |
| Un endpoint, un contrat d'entrée/sortie, une autorisation | `api.md` |
| Une règle de code, de style, de nommage, d'i18n | `conventions.md` + les **règles essentielles** de `CLAUDE.md` |
| Une norme fournie ajoutée / modifiée | le fichier dans `normes/` **et** la table de routage [normes/_index.md](../docs/normes/_index.md) — une norme hors routage ne s'applique jamais |
| Une commande, un script, une variable d'environnement | `commands-and-data.md` |
| Une fonctionnalité visible par l'utilisateur | `../README.md` + le fichier de domaine |
| Un choix structurant tranché | `decisions-prises.md` (+ `decisions-rejetees.md` pour l'option écartée) |
| Un bug corrigé dont la cause vaut leçon | `bugs.md` (+ la règle dans `conventions.md` ou le doc du domaine) |
| Une tâche identifiée, démarrée, testée, terminée | `suivi/` — voir [suivi-contrat.md](suivi-contrat.md) |

Un nouveau domaine → copier [`_TEMPLATE-domaine.md`](../docs/_TEMPLATE-domaine.md), le remplir,
**ajouter sa ligne dans l'index `CLAUDE.md`**. Un fichier absent de l'index n'existe pas.

## Comment écrire

- **Français**, phrases courtes, présent de l'indicatif.
- **Gras** sur les termes qui portent l'information (noms de fichiers, de classes, de
  règles) — l'agent comme l'humain lisent en diagonale.
- **Liens relatifs** entre fichiers dès qu'un sujet est traité ailleurs. Pas de duplication :
  une information vit dans **un seul** fichier, les autres y renvoient.
- **Chemins et identifiants réels**, en `code`. Jamais de nom approximatif.
- **Les pièges valent l'or** : quand un bug a coûté du temps, la cause s'écrit dans le
  fichier du domaine sous forme de règle (« toujours… », « ne jamais… »), pas seulement
  dans `bugs.md`.
- **Pas de futur vague.** Ce qui n'existe pas encore va dans
  [`suivi/1-backlog.md`](../docs/suivi/1-backlog.md), pas dans une section « à venir » d'un
  fichier de référence.
- **Court avant exhaustif.** Une doc fausse est pire qu'une doc absente.

## Ce qu'on n'écrit pas

- L'historique des commits (git le fait mieux).
- Du code recopié en volume : un extrait de 3 lignes ou un nom de fichier suffisent.
- Des sections vides « en attente de contenu » : supprimer le fichier jusqu'à ce qu'il
  ait quelque chose à dire.
