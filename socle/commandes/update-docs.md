---
description: Met à jour la documentation à partir des changements de code récents (agent doc-updater)
argument-hint: "[plage git — ex: HEAD~3..HEAD, main..HEAD, <sha>] (défaut: file d'attente ou HEAD~1..HEAD)"
---

Lance le sous-agent `doc-updater` pour synchroniser la documentation avec le code.

Plage demandée : $ARGUMENTS

Procédure :

1. Si une plage est fournie ci-dessus, utilise-la.
2. Sinon, si `.claude/doc-updates-pending.log` existe et n'est pas vide, lis-le :
   chaque ligne est un commit détecté comme « gros changement » par le hook post-commit
   (format : `<sha> <raison> <sujet>`). Prends le plus ancien SHA de la file et
   analyse `<sha>~1..HEAD`.
3. Sinon, utilise `HEAD~1..HEAD`.

Délègue ensuite au sous-agent `doc-updater` avec cette plage.

Quand il a terminé :
- vide `.claude/doc-updates-pending.log` si tu as traité la file,
- affiche son rapport,
- **commite sa mise à jour** (R-064) — sujet préfixé `docs:`, ce qui empêche le hook
  `post-commit` de relancer `doc-updater` sur son propre commit —, en ne stageant que les
  fichiers de doc qu'il a écrits (R-065). S'il n'a rien touché, pas de commit vide,
- rappelle à l'utilisateur de relire (`git show HEAD`) : c'est lui qui pousse.
