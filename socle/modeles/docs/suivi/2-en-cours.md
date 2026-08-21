# 2 — En cours

Les points **entièrement cadrés** : plus rien à réfléchir, il ne manque que le feu vert ou
le travail lui-même. Plus les points **à corriger**, renvoyés par une barrière.

> Format des points et règles de transition : [socle/suivi-contrat.md](../../socle/suivi-contrat.md).
> **Entrée** : `chef-de-projet` (depuis [1-backlog.md](1-backlog.md), dès que le cadrage
> est complet — **pas** au feu vert), `normes` ou `testeur` (retour d'une barrière).
> **Sortie** : `developpeur` → [3-a-tester.md](3-a-tester.md).

**Le feu vert de l'utilisateur est un acte distinct du cadrage.** Un point peut avoir toutes
ses informations et attendre indéfiniment : c'est la section *Prêt à démarrer*. Le
`developpeur` ne touche **jamais** un point sans `Feu vert : ✅`.

**Priorité de traitement** : **À corriger** → **En cours** → **Prêt à démarrer**. On répare
l'existant avant de finir ce qui est commencé, et on finit avant de commencer autre chose. À
l'intérieur d'une section, tri par importance (🔴 → 🟡 → 🟢).

## À corriger

Points déjà développés renvoyés par une barrière :

- par l'agent `normes` → champ **Non-conformités** (règles citées, `fichier:ligne`) ;
- par le `testeur` → champ **Échec constaté** (ce qui ne marche pas, comment le reproduire,
  ce qui était attendu).

Ces champs sont le point de départ du travail : ils ne s'effacent pas, ils se traitent.

*(aucun point)*

<!-- Modèle — un point revenu du test :
### P-001 — Titre
- **Type** : Nouvelle fonctionnalité
- **Importance** : 🟡 · **Effort** : ⚡
- **Créé** : AAAA-MM-JJ · **Maj** : AAAA-MM-JJ
- **Besoin** : ⟨…⟩
- **Périmètre** : ⟨…⟩ ; **hors périmètre** : ⟨…⟩
- **Fichiers pressentis** : `⟨…⟩`
- **Critères de vérification** :
  - [x] ⟨critère validé⟩
  - [ ] ⟨critère en échec⟩
- **Livré** : ⟨ce qui avait été fait⟩
- **Comment tester** : ⟨…⟩
- **Feu vert** : ✅ AAAA-MM-JJ
- **Non-conformités** :
  - 🚫 `⟨fichier:ligne⟩` — `⟨N-XXX-01⟩` « ⟨la règle, recopiée⟩ » : ⟨ce qui est écrit à la place⟩
- **Échec constaté** : ⟨ce qui ne marche pas, comment le reproduire, ce qui était attendu⟩
- **Questions ouvertes** : aucune
- **Journal** :
  - AAAA-MM-JJ — cadrage complet → prêt à démarrer *(chef-de-projet)*
  - AAAA-MM-JJ — feu vert utilisateur → en cours *(chef-de-projet)*
  - AAAA-MM-JJ — développé → à tester *(developpeur)*
  - AAAA-MM-JJ — ⟨n⟩ non-conformité(s) → à corriger *(normes)*
  - AAAA-MM-JJ — test échoué sur ⟨critère⟩ → à corriger *(testeur)*
-->

## En cours

Points **autorisés** (`Feu vert : ✅`) sur lesquels le `developpeur` a la main, ou qu'il doit
reprendre. Un point revenu d'une barrière garde son feu vert : réparer ce qui est déjà lancé
ne demande pas une nouvelle autorisation.

*(aucun point)*

## Prêt à démarrer

Cadrage terminé — `Périmètre`, `Critères de vérification`, aucune question ouverte — mais
**pas de feu vert**. Rien ne bouge ici sans décision de l'utilisateur, aussi longtemps qu'il
le faut. C'est la vue « qu'est-ce qui peut partir tout de suite ».

Chaque point porte `- **Feu vert** : ⏳ en attente`. Le `chef-de-projet` le passe à
`✅ AAAA-MM-JJ` et déplace le point en *En cours* le jour où l'utilisateur le décide.

*(aucun point)*
