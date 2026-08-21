# ⟨Nom du projet⟩

⟨Une phrase : ce que l'application permet de faire, pour qui, avec le bénéfice principal
en gras.⟩

> Documentation détaillée : [`CLAUDE.md`](CLAUDE.md) (index) + dossier [`docs/`](docs/).

---

## 1. Vue d'ensemble

⟨Un paragraphe : le parcours typique, du visiteur anonyme à l'utilisateur avancé /
administrateur. Ce que chaque profil peut faire.⟩

**Stack** : ⟨langage / framework⟩ · ⟨briques notables⟩ · ⟨base de données⟩.
⟨Organisation en n projets ou packages et rôle de chacun.⟩

---

## 2. Fonctionnalités

<!-- Une sous-section par grand écran / domaine fonctionnel. Décrire le comportement
     observable, pas l'implémentation : le lecteur doit pouvoir vérifier chaque phrase
     en utilisant l'application. Renvoyer vers docs/<domaine>.md pour les détails. -->

### 2.1 ⟨Écran ou domaine principal⟩
- ⟨Comportement observable, en gras les éléments qui portent l'information.⟩
- ⟨Cas particulier / variante notable.⟩

### 2.2 ⟨Second domaine⟩
- ⟨…⟩

### 2.3 Comptes & rôles
- ⟨Mécanisme d'authentification, rôles existants et ce qu'ils débloquent.⟩

### 2.4 ⟨Back-office / administration⟩
- ⟨Ce que l'administrateur peut gérer.⟩

### 2.5 Import / export
- ⟨Ce que l'utilisateur peut **sortir** du logiciel : quelle entité, dans quel format
  standard, depuis où.⟩
- ⟨Ce qu'il peut **faire entrer** : formats acceptés, analyse à blanc avant import.⟩
- Détail des formats : [`docs/commands-and-data.md`](docs/commands-and-data.md).

---

## 3. Pages / points d'entrée principaux

| Route ou commande | Description |
|---|---|
| `⟨/⟩` | ⟨…⟩ |
| `⟨/…⟩` | ⟨…⟩ |

---

## 4. Modèle de données (résumé)

Détail complet : [`docs/data-model.md`](docs/data-model.md).

- **⟨Entité⟩** : ⟨champs porteurs de sens, en `code`, avec les contraintes notables.⟩
- **⟨Entité⟩** : ⟨…⟩
- ⟨Relation notable et sa raison d'être.⟩

---

## 5. Persistance

- ⟨Ce qui est la **source de vérité**, et ce qui n'est qu'un cache ou un bootstrap.⟩
- ⟨Stratégie de sauvegarde / restauration.⟩

Voir [`docs/commands-and-data.md`](docs/commands-and-data.md).

---

## 6. Choix techniques

- **⟨Choix⟩** : ⟨la raison, en une ligne.⟩
- **⟨Choix⟩** : ⟨…⟩

> Conventions de code et commandes : [`docs/conventions.md`](docs/conventions.md),
> [`docs/commands-and-data.md`](docs/commands-and-data.md).
> Historique des arbitrages : [`docs/decisions-prises.md`](docs/decisions-prises.md).

---

## 7. État & suite

Livré : ⟨liste courte des fonctionnalités effectivement en place.⟩

Backlog et priorités : [`docs/suivi/`](docs/suivi/) (contrat : [`socle/suivi-contrat.md`](socle/suivi-contrat.md)). Post-mortem des bugs : [`docs/bugs.md`](docs/bugs.md).
