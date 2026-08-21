# Commandes & données

## Démarrage — mode par défaut

⟨Prérequis : ce qui doit tourner (base, conteneur, service) et où c'est décrit.⟩

```bash
⟨commande de démarrage des dépendances⟩
```

```bash
⟨commande de lancement de l'application⟩
```

⟨Ce qui se passe au démarrage : migrations, seed, comptes initiaux.⟩

## Développement courant

```bash
⟨build⟩
```

```bash
⟨tests⟩
```

```bash
⟨migration / génération de code⟩
```

⟨Pièges : verrous de fichiers, ordre d'exécution, cache navigateur à vider après un
changement client.⟩

## Configuration & secrets

Hiérarchie : ⟨variables d'environnement > secrets locaux > fichier d'env > fichier par
défaut⟩.

- **Dev** : ⟨ce qui est committé et pourquoi c'est sans risque (creds jetables).⟩
- **Prod** : **ne jamais** s'appuyer sur les valeurs committées. Variables à surcharger :

| Variable | Rôle |
|---|---|
| `⟨VAR⟩` | ⟨ce qu'elle configure ; valeur par défaut = dev only.⟩ |

## Données

- **Source de vérité** : ⟨où vivent les données de production.⟩
- **Bootstrap / seed** : ⟨ce qui n'est utilisé qu'au premier lancement — à ne pas confondre
  avec une sauvegarde.⟩
- **Sauvegarde / restauration** :

```bash
⟨commande de dump⟩
```

```bash
⟨commande de restauration⟩
```

### Import / export

⟨Surfaces d'interopérabilité du projet — cf. [conventions.md § Interopérabilité](conventions.md).⟩

| Entité | Concept | Export | Import | Format | Clés d'appariement | Aller-retour vérifié |
|---|---|---|---|---|---|---|
| `⟨Entité⟩` | `⟨C-XXX⟩` | ⟨où / comment⟩ | ⟨où / comment⟩ | ⟨format + version, ou « maison, documenté ici »⟩ | ⟨ce qui permet de reconnaître un élément déjà connu⟩ | ⟨oui, le ⟨date⟩ / non⟩ |

> **Ce tableau est la source de vérité** du registre d'interopérabilité partagé entre les
> projets du socle : `/interop declare` le projette dans `interop.md` du dépôt socle, et
> `/interop check` s'en sert pour repérer qu'un autre projet exporte déjà ce qu'on saisit à
> la main ici. La colonne **Concept** reprend un identifiant `C-XXX` du lexique — c'est lui
> qui apparie, pas le nom de l'entité.

- ⟨Champs exportés, y compris ceux non affichés dans l'interface.⟩
- ⟨Comportement à l'import sur donnée inconnue : signalée et neutralisée, jamais rejet en
  bloc. Mode « analyse à blanc » disponible ?⟩
- ⟨Entités volontairement **sans** export, et la raison — cf.
  [decisions-rejetees.md](decisions-rejetees.md).⟩

## Mode de repli

⟨Mode dégradé permettant de lancer l'app sans dépendance lourde (base en mémoire, mocks) —
et ses limites.⟩
