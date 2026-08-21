# Modèle de données

Entités, champs, relations et règles de persistance. Résumé lisible dans
[`../README.md`](../README.md) § 4 ; ici, la vérité complète.

## Entités

### `⟨Entité⟩`
| Champ | Type | Rôle / contrainte |
|---|---|---|
| `Id` | ⟨type⟩ | ⟨format de l'identifiant, stable ou dérivé.⟩ |
| `⟨Champ⟩` | ⟨type⟩ | ⟨rôle ; nullable ? valeur par défaut ? pourquoi.⟩ |

⟨Règle propre à l'entité : invariant, validation, effet de bord à la suppression.⟩

### `⟨Entité⟩`
⟨…⟩

## Relations

- ⟨A⟩ ↔ ⟨B⟩ : ⟨cardinalité⟩ via ⟨table de jointure / clé étrangère⟩,
  ⟨donnée éventuellement portée par la relation.⟩
- **Effet d'une suppression** : ⟨ce qui est supprimé en cascade, ce qui est **préservé**.
  Écrire explicitement ce qu'on ne supprime **jamais** — c'est la règle qu'on oublie.⟩

## ⟨Énumérations / statuts⟩

- `⟨Enum⟩` : ⟨valeurs et sens de chacune.⟩
- ⟨Comment l'enum est stockée (nom ou entier) et l'impact sur les migrations.⟩

## Règles de publication / visibilité

- ⟨État qui rend une donnée publique, et qui voit quoi.⟩
- Le filtrage est fait **côté serveur** ; le filtre client n'est qu'une règle d'affichage.
  Cf. [api.md](api.md).

## Migrations

- ⟨Outil et commande — cf. [commands-and-data.md](commands-and-data.md).⟩
- Historique utile : ⟨migrations notables et ce qu'elles ont changé.⟩
- ⟨Piège connu : ex. arrêter l'application avant de générer une migration
  (fichiers verrouillés).⟩
