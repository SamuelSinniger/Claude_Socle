# Normes — table de routage

Ce dossier accueille les **normes fournies** : référentiels externes, standards d'entreprise,
règles d'accessibilité, socle de sécurité, guides de style d'un langage.

Trois niveaux de règles cohabitent, sans se recopier :

| Niveau | Où | Identifiants |
|---|---|---|
| Règles communes à tous les projets | [`../../socle/regles-communes.md`](../../socle/regles-communes.md) | `R-###` |
| Normes fournies | ce dossier | `N-XXX-##` |
| Conventions propres au projet | [`../conventions.md`](../conventions.md) | — |

Le **format** d'une règle opposable (identifiant, `Vérifiable par`, `Exception`) est fixé
par le socle : [`../../socle/normes-format.md`](../../socle/normes-format.md). Le respecter
est ce qui rend un constat citable, donc bloquant.

Ce fichier-ci est lu par l'agent [`normes`](../../.claude/agents/normes.md) **avant** tout
contrôle. Il n'y a pas de lecture du corpus entier : le diff d'un point détermine, via les
tables ci-dessous, les seules normes à ouvrir. Un corpus volumineux ne se contrôle qu'à
cette condition.

## Routage par type de fichier

| Motif de chemin / extension | Normes applicables |
| --- | --- |
| *(tout fichier de code)* | [`../../socle/regles-communes.md`](../../socle/regles-communes.md), [`../conventions.md`](../conventions.md) |
| `⟨*.ts, *.js⟩` | ⟨`nom-de-la-norme.md` § ⟨section⟩⟩ |
| `⟨*.css, *.scss⟩` | ⟨…⟩ |
| `⟨*.sql, migrations/**⟩` | ⟨…⟩ |
| `⟨tests/**⟩` | ⟨…⟩ |

## Routage par domaine

| Domaine touché | Normes applicables |
| --- | --- |
| ⟨Interface / composants⟩ | ⟨norme d'accessibilité § …⟩, [`../⟨domaine⟩.md`](../⟨domaine⟩.md) § *Règles* |
| ⟨API / endpoints⟩ | ⟨socle de sécurité § …⟩, [`../api.md`](../api.md) |
| ⟨Données / persistance⟩ | ⟨…⟩, [`../data-model.md`](../data-model.md) |

## Corpus

| Fichier | Origine | Portée | Préfixe d'id |
| --- | --- | --- | --- |
| `⟨nom.md⟩` | ⟨interne / référentiel externe + version⟩ | ⟨ce qu'il couvre⟩ | `⟨N-XXX⟩` |

## Ajouter une norme

1. Déposer le fichier dans `docs/normes/`, règles identifiées au format du socle.
2. L'inscrire dans **Corpus** avec son préfixe d'id.
3. L'inscrire dans **le routage** — par type de fichier, par domaine, ou les deux.
   **Une norme absente du routage ne sera jamais appliquée.**
4. Si elle contredit une règle existante, trancher **maintenant** (cf.
   [normes-format.md](../../socle/normes-format.md) § *Conflit entre deux règles*).
