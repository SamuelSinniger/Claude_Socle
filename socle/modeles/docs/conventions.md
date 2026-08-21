# Conventions de code — ⟨projet⟩

> **Les [règles communes du socle](../socle/regles-communes.md) s'appliquent intégralement**
> (`R-###`) et ne sont **pas** répétées ici. Ce fichier ne contient que ce qui est propre à
> ce projet. Les dérogations au socle se déclarent dans [`../CLAUDE.md`](../CLAUDE.md).

## Concrétisation des règles du socle

Le socle ne présume rien de la stack : il renvoie au projet pour les valeurs concrètes.
Ce tableau les fixe, une fois pour toutes.

| Règle | Ce que ça vaut ici |
|---|---|
| `R-011` vérification | `⟨commande de build⟩` puis `⟨commande de tests⟩` — 0 erreur, 0 warning |
| `R-022` langue d'interface | ⟨langue⟩ |
| `R-030` configuration | ⟨fichier(s) où vivent les constantes⟩ |
| `R-080` i18n | ⟨mécanisme : service, fonction, fichiers de ressources⟩ |
| `R-090` styles | ⟨fichier centralisé⟩, préfixe ⟨`.xx-`⟩ ; exceptions : ⟨…⟩ |
| `R-051` formats exposés | ⟨où ils sont documentés⟩ |

## Nommage

- ⟨PascalCase pour…, camelCase pour…, kebab-case pour…⟩

## Conventions spécifiques

<!-- C'est ici que vit la valeur accumulée : chaque piège rencontré devient une règle.
     Format : une puce, le nom réel du composant/service en `code`, et — quand c'est un
     piège vécu — la conséquence entre parenthèses.
     Une règle qui n'a RIEN de spécifique à ce projet n'a pas sa place ici : elle monte
     dans le socle via `/socle promote`. -->

- **⟨Couche d'accès / interop⟩** : centraliser ⟨les appels à X⟩ dans ⟨service dédié⟩ ;
  aucun appel brut dispersé dans les composants.
- **⟨État partagé⟩** : ⟨service injecté, événement de rafraîchissement.⟩
- **⟨Règle née d'un bug⟩** : ⟨la règle⟩. *(Piège vécu : ⟨ce qui a cassé⟩.)*

## Limites connues

- ⟨Endroits où une règle du socle ne peut pas s'appliquer complètement, et pourquoi. Si
  c'est durable, ça devient une dérogation déclarée dans `CLAUDE.md`.⟩
