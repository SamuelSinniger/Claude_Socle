# Registre d'interopérabilité

Ce que chaque projet sait **sortir** et **faire entrer**, exprimé dans un vocabulaire
commun. C'est ce qui permet de dire à un projet : *« Argonaute exporte déjà des lieux en
GeoJSON — tu peux proposer l'import plutôt que la saisie manuelle. »*

Tenu par [`/interop`](socle/commandes/interop.md). Lu au **cadrage** de tout point qui
manipule une donnée (réflexe `R-040`) et à chaque `/interop check`.

---

## 1. Lexique des concepts

**Le cœur du dispositif.** Deux projets ne se reconnaîtront jamais en comparant les noms de
leurs entités : `Place`, `Lieu`, `POI`, `Spot` désignent la même chose. Chaque entité est donc
rattachée à un **concept canonique** `C-XXX`, et c'est le concept qui sert d'appariement.

| Concept | Définition | Aussi appelé | Format canonique | Clés d'appariement |
|---|---|---|---|---|
| `C-LIEU` | Un point ou une zone situé géographiquement | place, POI, spot, adresse | **GeoJSON** (`RFC 7946`) ; GPX accepté en entrée, *spécification de fait* | coordonnées, nom + code pays/ville |
| `C-COLLECTION` | Un regroupement ordonné ou non d'éléments, curaté par un humain | liste, playlist, itinéraire, dossier | JSON + manifeste, CSV si à plat | titre, identifiant stable |
| `C-PERSONNE` | Un individu, réel ou moral, référencé comme auteur ou acteur | auteur, artiste, contact, créateur | vCard, sinon JSON | nom + date, identifiant d'autorité |
| `C-OEUVRE` | Une production culturelle identifiable | artwork, morceau, film, tableau | JSON, Dublin Core si disponible | titre + auteur + année |
| `C-DOCUMENT` | Une publication référencée par un identifiant normalisé | livre, article, revue | **MARC** (`ISO 2709`) ou **ONIX**, métadonnées en **Dublin Core** (`ISO 15836`) ; BibTeX / CSL-JSON en repli, *spécifications de fait* | ISBN, ISSN, DOI |
| `C-EVENEMENT` | Quelque chose qui a lieu à une date | rendez-vous, séance, créneau | **iCalendar** | date + intitulé + lieu |
| `C-ETIQUETTE` | Un classement libre appliqué par l'utilisateur | tag, catégorie, mot-clé | CSV ou JSON à plat | nom normalisé |
| `C-ETAT-UTILISATEUR` | Le rapport d'un utilisateur à un élément | favori, visité, lu, vu, prévu, note | JSON `{ élément, état, date }` | identifiant de l'élément + compte |
| `C-JOURNAL` | Une suite d'événements horodatés propres à un utilisateur | historique, timeline, activité | **CSV** (`RFC 4180`) ; JSON Lines accepté, *spécification de fait* | horodatage + type |

**Format canonique** = le format à utiliser **par défaut** pour ce concept, dans tous les
projets. C'est la mise en œuvre concrète de `R-042` : le choix du standard est tranché **une
fois ici**, pas à chaque projet. Deux projets qui suivent le format canonique d'un concept
sont interopérables sans travail d'adaptation.

**Clés d'appariement** = ce qui permet de reconnaître deux fois le même élément lors d'un
import. Un export qui ne porte aucune clé d'appariement n'est pas importable sans créer des
doublons : c'est un défaut à signaler, pas une fatalité à subir.

### Ajouter un concept

Un concept manquant s'ajoute ici **avant** d'être utilisé dans une déclaration. Exigences :
une définition qui tienne en une ligne, les synonymes qu'on rencontrera (c'est eux qui
feront le rapprochement), et un format canonique — s'il n'existe aucun standard, écrire
« aucun standard, format maison versionné » plutôt que de laisser vide. Un concept trop large
(`C-DONNEE`) n'apparie rien ; un concept trop étroit (`C-LIEU-TOURISTIQUE`) rate les
correspondances. Viser le niveau où deux logiciels différents diraient « oui, c'est la même
chose ».

---

## 2. Déclarations des projets

Une ligne par surface d'interopérabilité. **Généré depuis** le tableau *Import / export* de
`docs/commands-and-data.md` de chaque projet (`/interop declare`) : la vérité reste dans le
projet, ce registre en est la projection.

| Projet | Concept | Entité locale | Sens | Format | Portée | Où | Clés | Aller-retour |
|---|---|---|---|---|---|---|---|---|
| ⟨nom⟩ | `⟨C-XXX⟩` | `⟨Entité⟩` | export / import / les deux | ⟨format + version⟩ | ⟨une liste, un catalogue, un élément⟩ | ⟨route, commande, endpoint⟩ | ⟨clés portées par l'export⟩ | ⟨oui le ⟨date⟩ / non⟩ |

*(aucune déclaration pour l'instant)*

<details>
<summary>Exemple de ce à quoi ça ressemble une fois rempli</summary>

| Projet | Concept | Entité locale | Sens | Format | Portée | Où | Clés | Aller-retour |
|---|---|---|---|---|---|---|---|---|
| Argonaute | `C-LIEU` | `Place` | les deux | GeoJSON, GPX (entrée) | catalogue complet | `/moderation/import`, `GET /api/places` | coordonnées, `CountryCode`/`CityCode` | oui, le 2026-08-20 |
| Argonaute | `C-ETAT-UTILISATEUR` | `Favorites`/`Visited`/`Planned` | export | GeoJSON + états | les lieux d'un compte | `/my-places` | id de lieu | non |
| Argonaute | `C-COLLECTION` | `Collection` | export | JSON + manifeste | une collection | `/collections/{id}` | slug | non |

Lecture : un second projet qui manipule `C-LIEU` peut **importer** depuis Argonaute sans
adaptation, puisque les deux utilisent le format canonique du concept. S'il manipule
`C-ETAT-UTILISATEUR`, l'appariement se fera par id de lieu — donc seulement si les deux
projets partagent le référentiel de lieux, ce qui est une **question à poser**, pas une
évidence.

</details>

---

## 3. Correspondances signalées

Ce qui a été proposé à l'utilisateur, et ce qu'il en a décidé. **Une correspondance déclinée
ne se repropose pas** — c'est ce qui empêche le dispositif de devenir du bruit.

| Date | Projet concerné | Correspondance | Décision |
|---|---|---|---|
| ⟨AAAA-MM-JJ⟩ | ⟨projet⟩ | ⟨`C-XXX` exporté par ⟨autre projet⟩ → import proposé ici⟩ | ⟨point `P-###` créé / décliné : raison⟩ |

*(aucune correspondance signalée pour l'instant)*

Une correspondance retenue devient un **point** dans le backlog du projet concerné, jamais un
simple message : ce qui n'entre pas dans le pipeline est oublié. Une correspondance déclinée
part dans le `docs/decisions-rejetees.md` du projet, avec sa raison.
