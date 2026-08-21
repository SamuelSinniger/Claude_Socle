# Modules, composants & extensions

Inventaire des dépendances, des composants et des services, **avec leur utilité**.
Une dépendance dont on ne sait pas dire à quoi elle sert est une dépendance à retirer.

> Mettre à jour à **chaque** ajout, retrait ou montée de version.

## Frameworks & SDK

| | Rôle |
|---|---|
| **⟨SDK / runtime⟩** | ⟨cible, version.⟩ |
| **⟨Framework⟩** | ⟨ce qu'il fournit.⟩ |

## Packages — ⟨projet / partie A⟩

| Package | Version | Utilité |
|---|---|---|
| `⟨package⟩` | ⟨x.y.z⟩ | ⟨à quoi il sert ici, concrètement.⟩ |

## Packages — ⟨projet / partie B⟩

| Package | Version | Utilité |
|---|---|---|
| `⟨package⟩` | ⟨x.y.z⟩ | ⟨…⟩ |

⟨Note sur les références entre projets : qui dépend de qui.⟩

## Bibliothèques front (⟨CDN / bundler⟩)

| Bibliothèque | Version | Utilité |
|---|---|---|
| `⟨lib⟩` | ⟨x.y.z⟩ | ⟨…⟩ |

⟨Où elles sont déclarées (fichier), et le piège de cache éventuel : un asset non versionné
par empreinte exige un rechargement dur après déploiement.⟩

## Composants ⟨réutilisables⟩

| Composant | Rôle |
|---|---|
| `⟨Composant⟩` | ⟨ce qu'il affiche / encapsule, et où il est utilisé.⟩ |

## Services

| Service | Rôle |
|---|---|
| `⟨Service⟩` | ⟨responsabilité unique, état exposé, événements.⟩ |

## Outils de développement

| Outil | Utilité |
|---|---|
| `⟨outil⟩` | ⟨quand on s'en sert — cf. [commands-and-data.md](commands-and-data.md).⟩ |
