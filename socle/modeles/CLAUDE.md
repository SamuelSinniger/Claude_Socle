# CLAUDE.md — ⟨Nom du projet⟩

Index de travail. La doc détaillée est dans [`docs/`](docs/), le socle commun dans
[`socle/`](socle/). Voir aussi `README.md` (spec fonctionnelle).

## Projet

⟨Une à trois phrases : ce que fait l'application, pour qui.⟩ **⟨Langage/framework
principal⟩** + ⟨briques notables⟩ + ⟨base de données⟩. ⟨Organisation : n projets /
packages et leur rôle.⟩

## ⚙️ Socle commun (s'applique intégralement, ne pas recopier ici)

- [socle/regles-communes.md](socle/regles-communes.md) — **les règles impératives `R-###`** :
  commentaires, vérification, langue, qualité, interopérabilité, documentation, suivi,
  décisions, i18n, styles. À lire avant de coder.
- [socle/suivi-contrat.md](socle/suivi-contrat.md) — le **pipeline des points** et ses
  quatre listes ([docs/suivi/](docs/suivi/)), les portes (feu vert, conformité) et le format
  d'un point.
- [socle/guide-doc.md](socle/guide-doc.md) — règles du dossier `docs/` : quel changement va
  dans quel fichier.
- [socle/normes-format.md](socle/normes-format.md) — comment s'écrit une règle **opposable**.
- Les agents : [`chef-de-projet`](.claude/agents/chef-de-projet.md) (cadre et dispatche, ne
  code pas) · [`developpeur`](.claude/agents/developpeur.md) · [`normes`](.claude/agents/normes.md)
  (conformité avant test) · [`testeur`](.claude/agents/testeur.md) (valide et commite) ·
  [`doc-updater`](.claude/agents/doc-updater.md). Commandes : `/point`, `/detail`,
  `/update-docs`, `/socle`, `/interop`, `/standards`, `/explique`, `/recap`.
- Registre d'interopérabilité partagé (`interop.md` du dépôt socle) : le **lexique des
  concepts** `C-XXX` et ce que chaque projet sait exporter/importer. `/interop check` dit si
  un autre projet exporte déjà une donnée qu'on saisit à la main ici.

Version du socle installée : voir [`socle/socle.json`](socle/socle.json). État de synchro :
`/socle check`.

## 🔶 Dérogations au socle

<!-- La SEULE façon licite de s'écarter d'une règle du socle. Modifier un fichier de
     socle/ est interdit : /socle check le signalera et /socle update l'écrasera. -->

| Règle | Ce qu'on fait ici à la place | Pourquoi | Depuis |
|---|---|---|---|
| ⟨`R-###`⟩ | ⟨la pratique retenue⟩ | ⟨la raison — technique, contrainte externe, coût⟩ | ⟨AAAA-MM-JJ⟩ |

*(aucune dérogation pour l'instant)*

## 📚 Documentation du projet (lire le doc concerné avant de modifier un domaine)

- [docs/architecture.md](docs/architecture.md) — stack, organisation des dossiers, points d'entrée.
- [docs/dependencies.md](docs/dependencies.md) — **modules / composants / extensions** et leur utilité.
- [docs/data-model.md](docs/data-model.md) — entités, champs, relations, règles de persistance.
- [docs/api.md](docs/api.md) — endpoints, contrats, protection des mutations.
- [docs/conventions.md](docs/conventions.md) — conventions **propres au projet** + concrétisation des règles du socle.
- [docs/commands-and-data.md](docs/commands-and-data.md) — commandes, config, secrets, données, import/export.
- [docs/normes/_index.md](docs/normes/_index.md) — **table de routage** des normes fournies.
- ⟨docs/<domaine>.md⟩ — ⟨un fichier par domaine métier : ajouter la ligne ici.⟩
- [docs/bugs.md](docs/bugs.md) — **post-mortem** des bugs corrigés (cause + correctif).
- [docs/decisions-prises.md](docs/decisions-prises.md) / [docs/decisions-rejetees.md](docs/decisions-rejetees.md) — décisions actées / écartées.

## ⭐ Règles propres à ce projet

<!-- Uniquement ce qui n'a de sens QUE dans ce projet. Une règle qui vaudrait pour
     n'importe quel projet monte dans le socle : `/socle promote "<la règle>"`. -->

- **Sécurité** : ⟨règle d'autorisation des mutations⟩ ; filtrage des données non publiques
  **côté serveur**, jamais uniquement côté client. Cf. [api](docs/api.md).
- ⟨Règle propre au projet⟩ — ⟨une ligne, avec le lien vers le doc de référence.⟩
