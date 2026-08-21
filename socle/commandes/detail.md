---
description: Dossier technique sur un point ou une question, pour décider en connaissance de cause (lecture seule)
argument-hint: "[P-### | une question | rien = la question en cours de discussion]"
---

L'utilisateur veut le **dessous des cartes** avant de trancher. Sujet : $ARGUMENTS

Tu produis un **dossier de décision**, pas un cours. L'objectif est qu'à la fin de ta
réponse l'utilisateur puisse dire « on part sur B » sans avoir à te relancer.

## Ce que tu fais d'abord

1. **Identifier la question réelle.** Si l'argument est un id `P-###`, lis le point dans
   `docs/suivi/` (les quatre fichiers). Si c'est une question libre, prends-la telle quelle.
   Si c'est vide, reprends la dernière question posée ou l'arbitrage annoncé dans la
   conversation. Si tu ne vois pas de quoi il s'agit, demande — une seule question.
2. **Aller voir le code.** `Grep`/`Glob`/`Read` sur ce qui est réellement concerné. Tout
   fait avancé s'appuie sur un fichier que tu as ouvert. Pour un balayage large, délègue à
   un agent `Explore` en lecture seule plutôt que d'ouvrir vingt fichiers.
3. **Lire la doc du domaine** (`docs/`) et les décisions déjà prises
   (`docs/decisions-prises.md`, `docs/decisions-rejetees.md`) : une option déjà écartée se
   signale comme telle, avec la raison de l'époque.

## Le format de sortie

```
## La question
<une phrase : ce qui doit être tranché, et pourquoi ça se pose maintenant>

## État actuel
<ce que fait le code aujourd'hui, avec les références cliquables `fichier.ts:42`>

## Options

| | Ce que ça implique | Effort | Risque | Réversible ? |
|---|---|---|---|---|
| **A — <nom>** | <conséquence concrète> | ⚡/⏳/🐢 | <ce qui peut mal tourner> | oui / non : <pourquoi> |
| **B — <nom>** | … | | | |

<Pour chaque option, 2–4 lignes en dessous du tableau : le mécanisme, ce qu'elle coûte
plus tard, ce qu'elle interdit.>

## Ce que ça touche
- Code : <fichiers / modules>
- Données : <migration ? perte possible ? rétrocompatibilité ?>
- Doc : <fichiers docs/ à reprendre>
- Autres points du pipeline : <ids impactés>

## Le point de non-retour
<ce qui sera coûteux ou impossible à défaire — s'il n'y a rien, dis-le>

## Ma recommandation
<l'option, en une phrase, avec la raison décisive — pas trois raisons tièdes.>
**Ce qui me ferait changer d'avis** : <la condition>

## Ce que je ne sais pas
<les inconnues qui restent, et comment on les lèverait (mesure, essai, question métier)>
```

Adapte : si la question n'a qu'une seule option raisonnable, dis-le et supprime le tableau.
Si elle est purement factuelle (« comment marche X aujourd'hui ? »), garde **État actuel**,
**Ce que ça touche** et **Ce que je ne sais pas**.

## Règles

- **Lecture seule.** Tu ne modifies aucun fichier, tu ne déplaces aucun point, tu ne
  lances aucun agent qui écrit. La décision prise sera enregistrée ensuite par `/point`
  (et, si elle est structurante, dans `docs/decisions-prises.md`).
- **Rien d'inventé.** Chaque affirmation sur le code renvoie à un fichier que tu as lu.
  Ce que tu n'as pas vérifié va dans **Ce que je ne sais pas** — c'est la section la plus
  utile du dossier, pas un aveu de faiblesse.
- **Pas de neutralité de façade.** Tu recommandes. Un dossier qui liste trois options sans
  trancher renvoie la charge à l'utilisateur, ce qui est exactement ce qu'il voulait éviter.
- **Le jargon se paie.** Un terme technique nécessaire est suivi de ce qu'il implique
  concrètement pour l'application ou pour l'utilisateur.
- **Court.** Une page. Ce qui ne sert pas à trancher n'y est pas.
