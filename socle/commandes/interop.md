---
description: Interopérabilité entre projets du socle — déclarer ce que ce projet exporte/importe, ou chercher les correspondances avec les autres projets
argument-hint: "check | declare | concept \"<nom d'entité ou de notion>\""
---

Verbe demandé : $ARGUMENTS  *(vide = `check`)*

Le **registre d'interopérabilité** est le fichier `interop.md` à la racine du dépôt socle
(**https://github.com/SamuelSinniger/Claude_Socle**). Il contient un **lexique de concepts**
`C-XXX` et les **déclarations** de chaque projet. L'appariement se fait sur le concept, jamais
sur le nom d'entité : `Place`, `Lieu`, `POI` et `Spot` sont le même `C-LIEU`.

Pour localiser le dépôt socle, suis la procédure de [`/socle`](socle.md) (argument →
`clone_local` du manifeste → clone depuis `depot`), et **récupère l'amont** avant de lire le
registre : un clone en retard donnerait des correspondances périmées. Ne rien commiter, ni
ici ni dans le socle.

---

## `check` — chercher les correspondances utiles à ce projet

1. **Inventorier ce que ce projet manipule.** Lire `docs/data-model.md` (entités) et le
   tableau *Import / export* de `docs/commands-and-data.md`. Rattacher chaque entité à un
   concept du lexique — en t'appuyant sur la colonne **Aussi appelé**, pas sur une intuition
   de nommage. Une entité qui ne correspond à aucun concept est signalée : soit c'est
   spécifique au projet (normal), soit le lexique est incomplet (`concept` pour l'ajouter).
2. **Croiser avec les déclarations des autres projets.** Une correspondance vaut la peine
   d'être signalée quand **les trois** conditions tiennent :
   - même concept `C-XXX` ;
   - **sens opposé** : un autre projet **exporte** ce que celui-ci pourrait importer, ou
     l'inverse ;
   - le format est le **format canonique** du concept, ou un format que ce projet lit déjà.
     Sinon, dis ce qu'il manque (une conversion) plutôt que de promettre une compatibilité.
3. **Filtrer ce qui a déjà été tranché.** Une correspondance présente dans § *Correspondances
   signalées* avec une décision ne se repropose pas. Vérifier aussi le
   `docs/decisions-rejetees.md` du projet.
4. **Vérifier l'appariement, pas seulement le format.** Deux projets peuvent partager le
   concept et le format et rester inintégrables si les **clés d'appariement** ne se
   recoupent pas (des identifiants internes ne valent que si le référentiel est commun).
   Quand c'est le cas, la correspondance se signale **avec sa réserve** : « appariement par
   nom + ville seulement, risque de doublons ».
5. **Rapporter, et transformer en points.** Chaque correspondance retenue par l'utilisateur
   devient un point dans [`docs/suivi/1-backlog.md`](../../docs/suivi/1-backlog.md)
   (*Nouvelle fonctionnalité* ou *Amélioration*), avec dans le `Besoin` le concept, le projet
   source, le format et la réserve d'appariement s'il y en a une. Puis inscris la ligne dans
   § *Correspondances signalées* du registre. Déclinée : la raison va dans le
   `decisions-rejetees.md` du projet **et** dans le registre.

## `declare` — publier ce que ce projet sait faire

1. Lire le tableau *Import / export* de `docs/commands-and-data.md` : c'est la **source de
   vérité**, le registre n'en est que la projection. Si le tableau est vide alors que le
   projet a manifestement des exports, c'est ce tableau qu'il faut remplir d'abord.
2. Pour chaque ligne, déterminer le **concept**. Ambigu ou absent du lexique → demander à
   l'utilisateur plutôt que d'inventer un concept : un concept mal choisi produit de fausses
   correspondances pendant des années.
3. Écrire ou mettre à jour les lignes de ce projet dans § *Déclarations des projets*, avec
   sens, format, portée, point d'accès, **clés d'appariement** et état de l'aller-retour
   (`R-043`).
4. Signaler ce qui affaiblit la déclaration, sans le maquiller : un export sans clé
   d'appariement, un aller-retour non vérifié, un format maison là où un format canonique
   existe (`R-042`). Chacun de ces constats mérite un point, pas une note de bas de page.
5. Puis lancer un `check` : ce que ce projet vient de déclarer crée peut-être une
   correspondance **pour les autres**. Les lister dans le rapport pour que l'utilisateur
   sache où aller.

## `concept "<nom>"` — consulter ou enrichir le lexique

- Chercher d'abord dans le lexique, **synonymes compris**. Le plus souvent le concept existe
  sous un autre nom : c'est exactement ce que le lexique sert à éviter.
- S'il manque vraiment : le proposer à l'utilisateur avec définition en une ligne, synonymes
  attendus, **format canonique** (le standard du domaine, ou « aucun standard, format maison
  versionné ») et clés d'appariement. L'écrire dans le lexique après validation.
- Attention au grain : un concept trop large n'apparie rien, trop étroit rate les
  correspondances. Le bon niveau est celui où deux logiciels différents diraient « oui, c'est
  la même chose ».
- Un format canonique ne se change pas à la légère : les projets déjà déclarés dessus
  deviendraient non conformes. Un changement passe par une décision datée dans le socle et
  une entrée de CHANGELOG avec son impact.
