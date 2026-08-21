# Architecture

⟨Une à deux phrases : ce que fait l'application et avec quoi elle est bâtie.⟩

## Stack

- **⟨Framework⟩** (⟨version⟩) — ⟨rôle exact dans le projet.⟩
- **⟨Brique front / UI⟩** — ⟨comment elle est pilotée.⟩
- **Backend** : ⟨type d'API⟩, ⟨ORM / accès données⟩. ⟨Qui est la source de vérité.⟩
- **⟨Code partagé⟩** : ⟨où vivent les contrats / DTOs communs.⟩

## Organisation

<!-- Arborescence commentée : uniquement les dossiers qui portent du sens, avec ce qu'on
     y trouve. Pas de listing exhaustif — il périme en une semaine. -->

```
⟨racine⟩/
├── ⟨projet-a⟩/              # ⟨rôle⟩
│   ├── ⟨dossier⟩/           # ⟨ce qu'on y trouve⟩
│   └── ⟨config⟩             # ⟨clés notables⟩
├── ⟨projet-b⟩/              # ⟨rôle⟩
└── ⟨projet-partagé⟩/        # ⟨contrats communs⟩
```

## Points d'entrée

- ⟨Démarrage de l'application : fichier, ce qui s'y enchaîne (migrations, seed, DI…).⟩
- ⟨Point d'entrée des requêtes / des commandes.⟩

## ⟨Modes de rendu / d'exécution⟩

<!-- Section à garder si le framework en a (SSR/CSR, workers, jobs). À supprimer sinon. -->

- ⟨Quelle partie tourne où, et **pourquoi** — c'est la question qui revient le plus.⟩

## Domaines traités ailleurs

- ⟨Domaine⟩ : les règles et pièges sont regroupés dans [⟨domaine⟩.md](⟨domaine⟩.md).
