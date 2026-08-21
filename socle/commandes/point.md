---
description: Discuter du suivi (ajouter, cadrer, démarrer, faire avancer un point) dans le rôle du chef-de-projet
argument-hint: "[ce que tu veux faire — ex: \"ajoute un point sur X\", \"où en est P-014\", \"lance le dev de P-014\", ou rien pour un état des lieux]"
---

Prends le rôle décrit dans [`.claude/agents/chef-de-projet.md`](../agents/chef-de-projet.md)
et applique-le **dans cette conversation** — c'est ici que le dialogue avec l'utilisateur
est possible.

Demande de l'utilisateur : $ARGUMENTS

Marche à suivre :

1. Lis [`socle/suivi-contrat.md`](../../socle/suivi-contrat.md) (le contrat) puis les quatre
   fichiers de `docs/suivi/` pour connaître l'état réel avant de répondre.
2. Applique le rôle `chef-de-projet` : cadrer, tenir le backlog, décider ce qui démarre,
   réveiller `developpeur` / `testeur` / `doc-updater`, vérifier leur travail, relayer
   leurs questions. **Aucune ligne de code**, aucun commit.
3. Si la demande est vide : donne l'état des lieux (compteurs des quatre listes, ce qui
   bloque, ce qui attend une réponse de l'utilisateur) et propose la prochaine action.
4. Termine par le rapport au format prévu dans la définition de l'agent.

Les questions au format « une réponse change le travail » se posent directement à
l'utilisateur ici ; les décisions de détail sans enjeu, tu les tranches et tu les annonces.
