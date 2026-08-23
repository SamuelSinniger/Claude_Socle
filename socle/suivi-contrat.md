# Suivi — le pipeline des points

> **Fichier socle. Ne pas le modifier dans un projet.** Distribué et mis à jour depuis le
> dépôt socle ; `/socle check` signale toute modification locale.

Ce dossier remplace l'ancienne todo list unique. Un **point** (unité de travail) traverse
quatre fichiers, et **un seul à la fois** : le fichier où il se trouve *est* son état.

> Ce fichier est le **contrat** entre les trois agents du pipeline. Il est la référence :
> en cas de doute sur un format ou une transition, c'est lui qui tranche.

## Le pipeline

```
                              [2-en-cours]
                     ┌──────────────────────────────┐
  [1-backlog] ──────>│ Prêt à démarrer  ──feu vert──┼──> En cours ──développé──> [3-a-tester] ──test OK──> [4-termine]
   cadrage complet   │        ^                     │       ^                    (normes puis testeur)
                     └────────┼─────────────────────┘       |
                              └── non conforme / test échoué ┘
```

Deux portes distinctes à ne pas confondre :

- **cadrage complet** → le point quitte le backlog. C'est un jugement sur la *matière* :
  périmètre écrit, critères observables, aucune question ouverte.
- **feu vert** → le développement peut commencer. C'est une décision de l'**utilisateur**,
  datée. Un point peut rester « prêt à démarrer » indéfiniment, et c'est un état sain.

`3-a-tester` se traverse en **deux temps** : contrôle de conformité (`normes`) puis test
fonctionnel (`testeur`). Le contrôle passe **d'abord** — inutile de tester du code qui va
être réécrit.

| Fichier | Contenu | Qui écrit |
| --- | --- | --- |
| [1-backlog.md](../docs/suivi/1-backlog.md) | Futurs points, triés par **type**. Demandent encore de la réflexion. | `chef-de-projet` |
| [2-en-cours.md](../docs/suivi/2-en-cours.md) | Points entièrement cadrés, en trois sections : **À corriger** · **En cours** · **Prêt à démarrer** (en attente du feu vert). | `chef-de-projet` (entrée + feu vert), `developpeur` (sortie), `normes` / `testeur` (retour) |
| [3-a-tester.md](../docs/suivi/3-a-tester.md) | Points développés : en attente de **contrôle de conformité** puis de **test**. | `developpeur` (entrée), `normes` (tampon), `testeur` (sortie) |
| [4-termine.md](../docs/suivi/4-termine.md) | Points validés et commités. | `testeur` |

## Les quatre agents

| Agent | Rôle | Ne fait jamais |
| --- | --- | --- |
| [`chef-de-projet`](../.claude/agents/chef-de-projet.md) | Parle à l'utilisateur, cadre les points, alimente le backlog, décide ce qui démarre, réveille les autres agents, vérifie leur travail. | **Ne code pas.** Ne teste pas. |
| [`developpeur`](../.claude/agents/developpeur.md) | Implémente les points de `2-en-cours`, les passe en `3-a-tester`. | Ne cadre pas. Ne valide pas son propre travail. Ne commite pas. |
| [`normes`](../.claude/agents/normes.md) | Contrôle le diff d'un point de `3-a-tester` contre les normes et conventions écrites : tampon `Conformité` ou retour en « à corriger ». | Ne corrige pas le code. Ne teste pas le fonctionnel. N'invente aucune norme. |
| [`testeur`](../.claude/agents/testeur.md) | Teste les points **conformes** de `3-a-tester`, les passe en `4-termine` (+ commit) ou les renvoie en « à corriger ». | Ne corrige pas le code. Ne parle pas directement à l'utilisateur. |

Le `chef-de-projet` est le **seul** en contact avec l'utilisateur. Les deux autres lui
remontent leurs questions ; il relaie.

**Le commit d'un point appartient au `testeur`**, et à lui seul : c'est l'exception que
[R-064](regles-communes.md) réserve au pipeline. Ailleurs — mise à jour de doc, installation
ou mise à jour du socle, déclaration d'interop — l'agent qui écrit commite ce qu'il a écrit.
Ici non : un point donne **un** commit, celui qui atteste qu'il est validé. Un `developpeur`
qui commiterait son travail livrerait du code non testé sous couvert d'un commit. Personne ne
pousse, jamais : le `push` appartient à l'utilisateur.

### Commandes

| Commande | Usage |
| --- | --- |
| `/point [demande]` | Parler au `chef-de-projet` dans la conversation : ajouter, cadrer, démarrer, faire avancer un point. Sans argument : état des lieux. |
| `/detail [P-### ou question]` | **Dossier technique** avant de trancher : état du code, options avec effort/risque/réversibilité, point de non-retour, recommandation. Lecture seule. |
| `/update-docs [plage git]` | Réveiller `doc-updater` à la main. |
| `/standards [list \| check]` | Les **normes internationales** applicables à ce projet (`R-130`, `R-131`) : lesquelles concernent ses champs, où les formats s'en écartent, et les points de mise en conformité qui en découlent. |
| `/explique <sujet ou @fichier>` | Comprendre un concept, une commande, un bout de code : tableau, exemple minimal, pièges courants. Lecture seule, hors pipeline. |
| `/recap` | Récapitulatif de la **session** : ce qui est fait, ce qui reste en suspens, les prochaines étapes. À ne pas confondre avec `/point` sans argument, qui donne l'état du **pipeline**. |

## Règles de transition

1. **Un point vit dans un seul fichier.** Une transition = **déplacer le bloc entier**
   (couper/coller), jamais le recopier. Deux copies d'un même `id` = incident à signaler.
2. **Toute transition ajoute une ligne au `Journal`** du point : `AAAA-MM-JJ — <ce qui
   s'est passé> → <nouvel état>`, signée de l'agent.
3. **Aucun point ne saute une étape ni une porte.** Rien ne va de `1-backlog` à
   `3-a-tester`. Un point sans **critères de vérification** ne quitte pas `1-backlog`. Un
   point sans **`Feu vert : ✅`** n'est pas développé : le `developpeur` le laisse en *Prêt à
   démarrer*. Un point sans **`Conformité : ✅ OK`** n'est pas testé : le `testeur` le laisse
   au `normes`. Chaque porte a son gardien, et aucun gardien ne l'ouvre pour un autre.
4. **Un point bloqué reste où il est**, marqué `⏸️ En attente` avec sa question dans
   `Questions ouvertes`. Il ne recule pas et n'avance pas tant que la réponse manque.
5. **Ordre des sections préservé.** À l'intérieur d'une section, les points sont triés par
   importance (🔴 puis 🟡 puis 🟢).

## Format d'un point

Identique dans les quatre fichiers — c'est ce qui rend le déplacement mécanique.

```markdown
### P-014 — Titre court à l'infinitif
- **Type** : Nouvelle fonctionnalité <!-- ou Amélioration | Tâche technique | Correction -->
- **Importance** : 🟡 · **Effort** : ⏳
- **Créé** : 2026-08-21 · **Maj** : 2026-08-21
- **Besoin** : le problème à résoudre, du point de vue de l'utilisateur. Pas la solution.
- **Périmètre** : ce qui est inclus ; **hors périmètre** : ce qui est explicitement exclu.
- **Fichiers pressentis** : `src/a.ts`, `src/b.ts`
- **Critères de vérification** :
  - [ ] un comportement observable, vérifiable par un tiers sans lire le code
  - [ ] un second critère
- **Questions ouvertes** : aucune
- **Journal** :
  - 2026-08-21 — cadrage complet → prêt à démarrer *(chef-de-projet)*
  - 2026-08-22 — feu vert utilisateur → en cours *(chef-de-projet)*
```

### Champs

| Champ | Obligatoire dès | Notes |
| --- | --- | --- |
| `id` (`P-###`) | création | Séquentiel, **jamais réutilisé**. Prochain id = plus grand id des **quatre** fichiers + 1. |
| `Type` | création | `Nouvelle fonctionnalité` · `Amélioration` · `Tâche technique` · `Correction`. Détermine la section dans `1-backlog`. |
| `Importance` | création | 🔴 Haute · 🟡 Moyenne · 🟢 Basse. **Règle** : une nouvelle fonctionnalité est *a priori* moins importante qu'une amélioration ou une correction d'existant (ou que la dette technique, la sécurité, un risque de perte de données). |
| `Effort` | création | ⚡ Rapide (≲ ½ j) · ⏳ Moyen (≈ 1–2 j) · 🐢 Long (> 2 j ou incertain). **Indépendant** de l'importance : on privilégie ce qui est important **et** rapide. |
| `Besoin` | création | Le *pourquoi*. Une ligne suffit au départ. |
| `Périmètre` | sortie de `1-backlog` | Inclut **et** exclut. C'est la garantie contre le dérapage. |
| `Critères de vérification` | sortie de `1-backlog` | Observables, au futur vérifiable. C'est le cahier des charges du `testeur`. |
| `Fichiers pressentis` | sortie de `1-backlog` | Indicatif, le `developpeur` peut en toucher d'autres — il le note alors dans le journal. |
| `Questions ouvertes` | — | `aucune` quand il n'y en a pas. Non vide ⇒ le point est `⏸️ En attente`. |
| `Journal` | création | Append-only. On n'efface **jamais** une ligne de journal. |

### Champs ajoutés en cours de route

- En `2-en-cours`, sur **tout** point : `- **Feu vert** : ⏳ en attente` puis
  `✅ AAAA-MM-JJ` — écrit par le `chef-de-projet`, sur décision de l'utilisateur et de lui
  seul. Un feu vert retiré (l'utilisateur change d'avis) repasse à
  `⏳ retiré le AAAA-MM-JJ`, le point retourne en *Prêt à démarrer*, et la ligne de journal
  dit pourquoi.
- En `2-en-cours` (section **À corriger**) :
  - `- **Échec constaté** : <ce qui ne marche pas, comment le reproduire, ce qui était
    attendu>` — écrit par le `testeur` ;
  - `- **Non-conformités** :` puis une puce par manquement, au format
    `🚫 fichier:ligne — <id de règle> « <règle citée> » : <le constat>` — écrit par
    l'agent `normes`.
- En `3-a-tester` : `- **Livré** : <ce qui a été fait, fichiers réellement touchés>` et
  `- **Comment tester** : <la manipulation exacte, commande ou parcours>` — écrits par le
  `developpeur` ; puis `- **Conformité** : ✅ OK — AAAA-MM-JJ *(normes)*` — écrit par
  l'agent `normes`, et exigé par le `testeur` avant tout test.
- En `4-termine` : `- **Commit** : <sha> <message>` et `- **Terminé** : AAAA-MM-JJ`.

## Rapport avec le reste de la doc

- Les **normes** fournies vivent dans [`../normes/`](../docs/normes/_index.md), dont la table de
  routage dit quelles règles s'appliquent à quel type de fichier. Les conventions **propres
  au projet** restent dans [`../conventions.md`](../docs/conventions.md). Les deux sont opposables
  par l'agent `normes`.
- La **documentation** (`docs/*.md`, `README.md`, `CLAUDE.md`) est mise à jour par l'agent
  [`doc-updater`](../.claude/agents/doc-updater.md), pas par les agents du pipeline.
  Réciproquement, `doc-updater` **ne touche pas** à `docs/suivi/`.
- [`../bugs.md`](../docs/bugs.md) n'est **plus** une inbox : un bug constaté entre directement
  dans le pipeline (`Type: Correction`). `bugs.md` garde le **post-mortem** des bugs
  corrigés — cause, correctif, règle à en retenir — parce que ça, ça se relit.
- Les arbitrages structurants restent dans [`../decisions-prises.md`](../docs/decisions-prises.md)
  et [`../decisions-rejetees.md`](../docs/decisions-rejetees.md).
