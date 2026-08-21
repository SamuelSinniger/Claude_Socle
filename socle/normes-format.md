# Format d'une norme — socle

> **Fichier socle. Ne pas le modifier dans un projet.** Distribué et mis à jour depuis le
> dépôt socle.

Comment s'écrit une règle pour être **opposable** — c'est-à-dire citable par l'agent
[`normes`](../.claude/agents/normes.md) comme constat bloquant. Vaut pour les normes
fournies (`docs/normes/`), pour les conventions du projet (`docs/conventions.md`) et pour
les [règles communes](regles-communes.md) elles-mêmes.

## Anatomie

```markdown
### N-CSS-03 — Pas de couleur littérale hors des variables

Toute couleur est déclarée en variable globale et référencée par son nom. Une valeur
hexadécimale ou `rgb()` dans une règle de style est un manquement.

**Vérifiable par** : recherche de `#` suivi de 3 ou 6 hexadécimaux hors du fichier de
variables.
**Exception** : ⟨cas explicitement admis, ou « aucune »⟩.
```

## Les six exigences

1. **Un identifiant, une règle.** Une règle qui contient « et » cache souvent deux règles :
   on ne peut pas la valider à moitié, donc on ne peut pas la citer proprement.
2. **Un identifiant stable, jamais réutilisé.** Une règle abandonnée reste, marquée
   `— retirée le AAAA-MM-JJ` avec sa raison : c'est ce qui évite de la réintroduire.
3. **Formulée au constat**, pas à l'intention : « toute fonction porte un commentaire »
   plutôt que « il faut bien commenter ». Une intention ne se constate pas.
4. **`Vérifiable par`** dit comment on constate le manquement : motif de recherche,
   commande, observation. Une règle sans moyen de constat produira des interprétations et
   des faux positifs — l'agent `normes` la traitera en *remarque*, jamais en bloquant.
5. **`Exception`** est explicite, ou vaut « aucune ». Une exception non écrite n'existe pas.
6. **Pas de règle sans propriétaire** : socle (`R-###`, commun à tous les projets), norme
   fournie (`N-XXX-##`, référentiel externe ou d'entreprise), ou convention de projet. Une
   règle qui n'a rien de spécifique au projet monte dans le socle (`/socle promote`) plutôt
   que d'être recopiée dans chaque dépôt.

## Conflit entre deux règles

Deux règles qui se contredisent bloqueront un point au pire moment. L'arbitrage se fait
**au moment où le conflit est vu**, pas quand il gêne : décision datée dans
`docs/decisions-prises.md`, option écartée dans `docs/decisions-rejetees.md`. Si le conflit
oppose une norme fournie au socle, c'est le socle qui plie — via une **dérogation déclarée**
dans le `CLAUDE.md` du projet, jamais par modification locale d'un fichier socle.
