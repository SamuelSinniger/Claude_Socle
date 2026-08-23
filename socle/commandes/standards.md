---
description: Normes internationales applicables à ce projet — lister celles qui concernent ses champs, contrôler que les formats les respectent, et transformer chaque écart en point de mise en conformité après validation.
argument-hint: "list | check [domaine ou fichier] | (vide = list)"
---

Verbe demandé : $ARGUMENTS  *(vide = `list`)*

Le catalogue est [`socle/normes-internationales.md`](../../socle/normes-internationales.md) :
codes pays, dates et fuseaux, unités, monnaies, identifiants d'entreprise, encodages, formats
d'échange, accessibilité, et des normes sectorielles (édition, logistique, agroalimentaire,
matières dangereuses…). Il est distribué par le socle et **ne se modifie pas dans un projet**.

Ce que les règles en font :

- **`R-130`** — un champ dont le domaine est couvert par une norme porte **le format de cette
  norme**, en base, dans les échanges et dans l'interface.
- **`R-131`** — un format maison qui s'en écarte est accompagné d'un **convertisseur
  bidirectionnel** documenté, et la raison de l'écart est consignée.

Tu ne juges donc **jamais** un champ « non conforme » parce qu'il est maison : tu le juges
non conforme s'il est maison **et** qu'aucun convertisseur ne l'accompagne.

---

## `list` — les normes qui concernent ce projet

Le catalogue fait plusieurs centaines de lignes. **Le recracher n'aide personne** : ce qu'on
veut, c'est la vingtaine qui touche *ce* projet.

1. **Inventorier les champs du projet.** Dans l'ordre de fiabilité décroissante :
   [`docs/data-model.md`](../../docs/data-model.md) (entités et champs), les migrations ou le
   schéma s'ils existent, le tableau *Import / export* de
   [`docs/commands-and-data.md`](../../docs/commands-and-data.md), puis les types du code
   (`Grep` sur les définitions d'entités, de DTO, de formulaires).
   Un projet sans modèle de données écrit : dis-le, et travaille sur ce que le code expose.

2. **Rattacher chaque champ à un domaine** du catalogue — pays, langue, locale, date, durée,
   fuseau, devise, montant, unité, adresse, téléphone, e-mail, identifiant d'entreprise,
   code-barres, ISBN, coordonnées géographiques, encodage, couleur, accessibilité…
   Le rattachement se fait sur **ce que le champ signifie**, pas sur son nom : un
   `pays VARCHAR(50)` qui contient « France » relève d'`ISO 3166-1` même s'il ne s'appelle pas
   `country_code`.

3. **Rendre le tableau**, une ligne par norme applicable :

   | Norme | Domaine | Champ(s) concerné(s) | Format attendu | État |
   |---|---|---|---|---|
   | `ISO 3166-1` | codes pays | `addresses.pays` | `CHAR(2)`, alpha-2 majuscule | ⚠️ format libre |
   | `ISO 8601` | dates | `created_at` | horodatage avec fuseau | ✅ conforme |

   États possibles : **✅ conforme** · **⚠️ écart sans convertisseur** · **🔁 écart avec
   convertisseur** (conforme au sens de `R-131`) · **❓ à vérifier** (le format n'est pas
   lisible depuis la doc ni le code).

4. **Signale les normes que le projet *devrait* rencontrer et ne rencontre pas encore** —
   un projet qui manipule des prix sans devise (`ISO 4217`), des documents sans langue
   (`ISO 639`), des adresses sans pays. C'est souvent là que se trouve le vrai manque.

Rien n'est modifié par `list`.

## `check [domaine ou fichier]` — contrôler, puis créer les points

`check` fait le `list`, puis **confronte les valeurs réelles**. Sans argument, il contrôle
tout ; avec un argument, il se limite à un domaine (`dates`, `pays`, `devises`…) ou à un
fichier.

1. **Constater, pas supposer.** Pour chaque champ rattaché à une norme, va chercher la preuve :
   le type déclaré (schéma, migration, définition d'entité), et **un échantillon de valeurs**
   quand c'est lisible sans exécuter le projet (données de test, fixtures, exemples de la doc,
   valeurs par défaut). Ce que tu n'as pas pu constater reste **❓ à vérifier** — pas
   « conforme », pas « non conforme ».

2. **Chercher le convertisseur avant de conclure.** Un écart n'est un manquement que si rien
   ne convertit. Cherche : une fonction de conversion nommée d'après la norme, une table de
   correspondance, une route d'export au format standard, une mention dans le tableau
   *Import / export*. Si tu en trouves un, vérifie qu'il est **bidirectionnel** et
   **documenté** — un export sans import ne satisfait pas `R-131`.

3. **Classer chaque écart.**

   | Niveau | Quand |
   |---|---|
   | 🚫 **Manquement** | une norme couvre le domaine, le format s'en écarte, **et** aucun convertisseur n'existe |
   | ⚠️ **Remarque** | convertisseur présent mais unidirectionnel ou non documenté ; norme applicable mais champ absent ; doute sur le rattachement |
   | ❓ **Angle mort** | format non constatable depuis la doc et le code |

   **Aucun manquement sans citation** : la norme, son numéro, le champ, et le format qu'elle
   impose. Si tu ne peux pas citer la ligne du catalogue, c'est une remarque.

4. **Proposer les corrections — en une fois, pas champ par champ** (`R-068`). Présente un
   tableau déjà rempli de ta proposition, une ligne par manquement :

   | # | Champ | Norme | Correction proposée | Effort | Ce que ça casse |
   |---|---|---|---|---|---|
   | 1 | `addresses.pays` | `ISO 3166-1` | migrer vers `CHAR(2)` + table de référence, convertir l'existant | ⏳ | les écrans qui affichent le libellé brut |
   | 2 | `invoices.montant` | `ISO 4217` | ajouter `currency CHAR(3)`, refuser un montant sans devise | ⚡ | les imports qui n'envoient pas de devise |

   Pour chaque manquement, la correction se choisit entre **trois voies**, et c'est
   l'utilisateur qui tranche :

   - **adopter le format normalisé** — le champ change, les données sont converties ;
   - **garder le format maison et écrire le convertisseur** (`R-131`) — moins invasif,
     satisfait la règle, laisse la dette de conversion ;
   - **écarter la norme** — elle ne s'applique pas vraiment à ce projet. La raison va dans
     `docs/decisions-rejetees.md` : on ne repose plus la question.

   Puis **une seule question** à options (`R-067`) : appliquer la proposition telle quelle
   *(recommandé)* · en corriger certaines lignes, nommées · tout écarter pour l'instant.
   **Ne crée aucun point avant la réponse.**

5. **Créer les points**, une fois validés. Un point **par norme**, pas par champ — trois
   colonnes à passer en `ISO 3166-1` font un seul point, sinon le backlog se remplit de
   miettes qui se marchent dessus. Chacun dans
   [`docs/suivi/2-en-cours.md`](../../docs/suivi/2-en-cours.md) § *Prêt à démarrer*, avec
   `Feu vert : ⏳ en attente` :

   - **Titre** : « Mise en conformité `<norme>` — `<domaine>` »
   - **Type** : Tâche technique · **Importance** : 🟡 par défaut, 🔴 si la donnée est échangée
     avec l'extérieur ou si un correctif ultérieur exigerait une migration de données
   - **Besoin** : le nom de la norme, ce qu'elle impose, les champs concernés, et **la voie
     retenue** (format normalisé / convertisseur / écart assumé)
   - **Critères de vérification** : le constat attendu, observable — « `country_code` est en
     `CHAR(2)`, les 1 240 lignes existantes sont converties, un export contient `FR` et non
     `France` ». Pour un convertisseur : **l'aller-retour** (`R-043`).
   - **Périmètre** : ce qui n'est pas dans ce point, en particulier les autres normes.

6. **Commiter** ce que tu as écrit (`R-064`), en ne stageant que `docs/suivi/**` et
   `docs/decisions-rejetees.md` si tu l'as complété (`R-065`). Message :
   `chore: mise en conformité aux normes internationales`. Pas de `push`.

---

## Règles

- **Lecture seule sauf `docs/suivi/**` et les journaux de décision.** Tu ne modifies **aucun**
  champ, aucune migration, aucun code : `check` mesure et planifie, il ne corrige pas. La
  correction passe par le pipeline, comme le reste.
- **Le catalogue ne se modifie pas ici.** Une norme qui manque s'ajoute **dans le dépôt
  socle** — guide de contribution en tête de
  [`socle/normes-internationales.md`](../../socle/normes-internationales.md) — puis redescend
  par `/socle update`. Signale-le, ne l'écris pas dans le projet.
- **Une norme applicable n'est pas une norme obligatoire.** Le catalogue couvre des domaines
  très larges ; un projet interne sans facturation n'a que faire d'`EN 16931`. Un rattachement
  douteux se présente en **remarque**, jamais en manquement.
- **Ne propose pas de migration de données sans le dire.** Si la correction implique de
  convertir des lignes existantes, la ligne « Ce que ça casse » du tableau le porte, et le
  point le porte aussi. Une mise en conformité silencieuse qui réécrit des données est un
  incident, pas une amélioration.
