# Le socle, expliqué à quelqu'un qui ne l'utilise pas

À quoi sert ce système, comment il marche pour de vrai, et ce qu'il coûte. À faire lire à
un collègue qui envisage de l'adopter sur son projet.

> Version partageable de cette page, mise en forme :
> https://claude.ai/code/artifact/3a0e5637-e9a7-4e7f-8ad9-34671f1f8aec
> Pour installer, c'est [DEMARRER.md](DEMARRER.md) ; pour la mécanique interne,
> [README.md](README.md).

## Le problème

Un agent qui a bien travaillé hier recommence à zéro aujourd'hui. Les garde-fous qu'on lui
donne vivent dans un `CLAUDE.md` par projet — recopié d'un dépôt à l'autre, divergent au bout
de trois semaines, et que plus personne ne relit. Quand on corrige une bêtise dans un projet,
les autres continuent de la faire.

Le socle est ce corpus-là, sorti des projets et mis dans un dépôt à part : **45 règles
numérotées, 5 agents, 5 commandes, un squelette de documentation**. Il se copie dans chaque
projet et se met à jour par commande. Ce qu'on y corrige une fois, tous les projets le
reçoivent — avec, pour chaque règle, ce que la mise à jour implique chez eux.

## Ce qui est copié, et comment on sait qu'il n'a pas bougé

Le dépôt socle ne contient aucun code applicatif : il **produit** ce qui est déposé dans les
projets.

| Ce qui est posé | Où | Quand |
|---|---|---|
| règles communes, contrat du pipeline, guide doc, format des normes | `socle/` | à l'installation **et à chaque mise à jour** |
| les 5 agents | `.claude/agents/` | idem |
| les 5 commandes | `.claude/commands/` | idem |
| le hook de documentation | `.githooks/` | idem |
| 19 **modèles** — `CLAUDE.md`, `README.md`, `docs/**` | racine du projet | **à la création seulement**, et uniquement là où le fichier est absent |

Seize fichiers synchronisés, toujours les mêmes. Un manifeste — `socle/socle.json` — liste
pour chacun sa destination et son **empreinte sha256**. C'est ce détail qui sépare « on a
copié des fichiers » de « on sait exactement ce que ce projet a » : `/socle check` recalcule
les seize empreintes et dit lesquelles ont dérivé.

### Les deux règles qui font tout tenir

1. **Un fichier est soit entièrement socle, soit entièrement projet.** Jamais les deux. C'est
   ce qui permet de mettre à jour sans jamais fusionner à la main : le socle écrase ses
   propres fichiers et ne lit même pas les vôtres.
2. **Pour s'écarter d'une règle : une dérogation déclarée** dans le `CLAUDE.md` du projet
   (règle, pratique retenue, raison, date). Jamais une modification locale — `/socle check`
   la signalerait, `/socle update` l'écraserait.

## La boucle qui rend le système intéressant

Une règle ne s'invente pas dans un dépôt de règles : elle se découvre en codant. Le socle est
fait pour que le chemin de remontée soit **plus court que le contournement** — sinon personne
ne remonte rien et le corpus meurt.

```
   dépôt socle ──── /socle install · /socle update ────>  projet A   (1.4.0)
        ^                    16 fichiers + manifeste       projet B   (1.4.0)
        │                                                  projet C   (1.3.0, retard assumé)
        └──────────── /socle promote ─────────────────────────┘
                      une règle découverte en codant
```

`promote` écrit la règle au format imposé, l'entrée de CHANGELOG **avec son impact
rétroactif**, et régénère le manifeste. Chaque `update` lit le CHANGELOG entre les deux
versions et crée dans le projet les **points de mise en conformité** que les nouvelles règles
impliquent.

**Chaque règle publiée porte son impact rétroactif.** Une règle ajoutée rend potentiellement
non conforme du code déjà livré : le CHANGELOG dit lequel, et pour qui. Écrire « aucun » est
une réponse valable ; l'omettre, non — sans cette ligne, la mise à jour ne sait pas si elle
doit créer du travail.

## Ce que ça change dans une journée de travail

Tout travail passe par un **point**, qui vit dans un seul fichier — et ce fichier *est* son
état. Pas de champ « statut » à tenir : on déplace le point, ou il n'a pas avancé.

```
1-backlog  ──cadrage complet──>  2-en-cours  ──feu vert──>  en cours
                                      ^                        │
                                      │                        v
   4-termine  <──test OK──  3-a-tester  <────────────  développé
                    (normes, puis testeur)
```

- **Deux portes ne s'ouvrent que par une décision** : le *feu vert* est le vôtre — un point
  cadré peut attendre indéfiniment, c'est un état sain ; la *conformité* est un constat cité
  par un agent (« `R-100`, ligne 42 »), pas un avis.
- **Aucun point ne démarre sans critères de vérification observables.** « Comment saura-t-on
  que c'est fait ? » est la question de cadrage la plus utile ; elle devient le cahier des
  charges du test.
- **Le commit atteste que le point est testé** — c'est l'agent qui teste qui commite. Rien
  n'est poussé : le `push` reste à vous.
- **La doc suit le code** : après un gros commit, un hook réveille un agent qui met à jour la
  documentation et la commite sous un sujet `docs:`.
- **Avant de saisir un catalogue à la main**, `/interop check` dit si un projet voisin
  l'exporte déjà.

## L'adopter sur un projet existant

Compter dix minutes. Le point délicat n'est pas la copie : c'est la rencontre entre le socle
et les règles que le projet a déjà.

1. **Déposer un fichier à la racine du projet et le lancer** — `amorcer.ps1` sous Windows,
   `amorcer.sh` ailleurs. Il trouve le dépôt socle sur la machine (ou le clone à côté du
   projet), propose `git init` si besoin, pose les seize fichiers, branche le hook, puis
   **s'efface**.
2. **Relancer la session Claude Code.** Les agents et les commandes sont découverts au
   démarrage : une session ouverte avant l'amorçage jurera que `/socle` n'existe pas.
3. **`/socle install`** — c'est là que ça se joue. Sur un projet qui a déjà ses règles, la
   commande bascule d'elle-même en **adoption** : elle inventorie vos règles (`CLAUDE.md`,
   `AGENTS.md`, `.cursorrules`, `CONTRIBUTING`, sections conventions du README) et les classe
   en cinq catégories — *déjà couverte · générique à promouvoir · plus stricte que le socle ·
   spécifique au projet · en contradiction*. Puis elle **s'arrête** sur le tableau. Une règle
   qui monte dans le socle s'imposera à tous les autres projets : ce n'est pas une décision
   d'agent. Rien n'est écrit avant votre validation.

## Le bilan

Le socle exige que chaque règle publiée annonce son coût. Appliquons-lui sa propre règle.

| Ce que ça donne | Ce que ça coûte |
|---|---|
| **Des règles opposables, pas des intentions.** Identifiant stable, formulation au constat, moyen de constat. L'agent qui bloque cite `R-100` : on discute d'un texte, pas d'une humeur. | **Il faut savoir les écrire.** Une règle floue produit des faux positifs, et un contrôle qui crie au loup finit ignoré — pire que pas de contrôle. Le socle impose un format ; le format ne pense pas à votre place. |
| **Une correction profite à tous les projets.** Un bug dont la cause vaut leçon devient une règle, la règle monte, tous les projets la reçoivent avec leurs points de mise en conformité. | **Une mauvaise règle se propage aussi.** Le coût d'une erreur est multiplié par le nombre de projets. D'où le garde-fou : trois projets qui dérogent à la même règle disent que la règle est mauvaise, pas les projets. |
| **La dérive est détectable.** Seize empreintes recalculées à la demande ; un fichier modifié en douce est visible en une commande. | **Le registre des projets est tenu à la main.** Un projet absent du registre échappe à « mettre à jour partout ». Et un numéro de version peut mentir si l'on modifie une version déjà installée — c'est arrivé, et il a fallu comparer les empreintes, pas les numéros. |
| **Rien ne se livre sans critères ni test.** Le point ne démarre pas sans critères observables, le commit n'existe qu'après leur vérification. | **C'est lourd pour une correction de deux lignes.** Quatre listes, deux portes, deux agents : sur un correctif évident, la cérémonie coûte plus que le correctif. Le gain est ailleurs — sur ce qu'on croyait évident et qui ne l'était pas. |
| **Distribution par copie : rien à installer.** Pas de gestionnaire de paquets, pas de service, pas de compte. Du Markdown lisible, versionné avec votre dépôt, qui marche hors ligne. | **N copies à synchroniser.** Une mise à jour n'est pas un `npm update` : c'est une commande à lancer dans chaque projet, au moment choisi par chacun. |
| **Le socle ne présume rien de votre stack.** Aucune règle ne nomme un framework ; le même corpus tient pour un site, un service de données ou un outil interne. | **La moitié des règles est inerte tant que vous ne les concrétisez pas.** Un tableau dans `docs/conventions.md` doit dire quelle commande de build, quel mécanisme d'i18n, quel fichier de styles. Sans lui, la règle existe et ne s'applique à rien. |
| **Les agents commitent leur travail.** Chaque intervention laisse un commit nommé : on relit après coup au lieu de fouiller un dossier de travail. Rien n'est poussé, donc rien n'est irréversible. | **Ça surprend au début.** On accepte que l'agent écrive dans l'historique local. Le filet est simple — `git reset --soft HEAD~1` — mais il faut y consentir. |
| **Les règles survivent à l'outil.** Le corpus est du Markdown : il se lit et se discute sans rien lancer, même pour qui n'utilise pas d'agent. | **L'automatisme, lui, est lié à Claude Code** — agents, commandes, hook. Changer d'outil, c'est garder les règles et réécrire la mécanique. |

## Quand ne pas l'adopter

- **Un script de deux cents lignes, un prototype jetable.** Le pipeline coûte plus qu'il ne
  rapporte. Prenez les règles si elles vous plaisent, laissez le reste.
- **La veille d'une livraison.** Un projet adopté n'est pas un projet conforme : il est
  *mesuré*, et l'adoption produit une liste de mises en conformité. Bon moment pour
  l'apprendre, mauvais pour le découvrir.
- **Si personne ne veut tenir le corpus.** Un ensemble de règles sans jardinier pourrit : les
  règles mortes restent, les nouvelles ne montent pas, et au bout de six mois on ne les lit
  plus.
- **Si vous êtes le seul projet.** Le bénéfice vient du *nombre de projets*, pas du nombre de
  personnes. À partir de deux, la boucle de remontée commence à payer.

## En sortir prend une minute

C'est l'argument qui devrait emporter l'essai : il n'y a rien à désinstaller.

```bash
rm -rf .claude socle .githooks
git config --unset core.hooksPath
```

Votre documentation reste — elle n'a jamais appartenu au socle. Les points déjà écrits aussi :
ce sont des fichiers Markdown dans `docs/suivi/`, lisibles sans rien d'autre.

## Les objections qu'on entend

**« J'ai déjà tout ça dans mon `CLAUDE.md`. »** Tant mieux, c'est le cas prévu. L'adoption les
inventorie et les classe, et vos règles ont autant de chances de **monter** dans le socle que
d'y être remplacées : les six règles de sécurité et de droits des médias du socle viennent
d'un projet qui les avait déjà.

**« Vos règles vont écraser mes conventions. »** Aucun fichier de projet n'est écrasé, jamais :
ni `CLAUDE.md`, ni `README`, ni `docs/`. Une contradiction se règle par une dérogation
déclarée — ou par une correction du socle, si c'est votre règle qui a raison.

**« Combien de temps pour la mise à jour ? »** Une commande, quand *vous* le décidez. Un projet
peut rester en arrière volontairement — livraison en cours, gel avant production — à condition
de noter la raison et la date. Un retard assumé et daté n'est pas une dette.

**« Qui arbitre ce qui devient une règle commune ? »** Un humain, toujours. L'agent prépare la
formulation, l'identifiant et l'impact rétroactif, puis s'arrête. Promouvoir une règle engage
tous les projets : la décision ne lui appartient pas.

---

*État au 23 août 2026 — socle 1.4.0, 45 règles, 16 fichiers synchronisés, 19 modèles.*
