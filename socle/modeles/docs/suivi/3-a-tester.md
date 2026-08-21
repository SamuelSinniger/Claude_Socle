# 3 — À tester

Points développés, en attente de validation. Le code est écrit et compile ; **personne n'a
encore confirmé** ni qu'il est conforme, ni que le besoin est satisfait.

> Format des points et règles de transition : [socle/suivi-contrat.md](../../socle/suivi-contrat.md).
> **Entrée** : `developpeur` (depuis [2-en-cours.md](2-en-cours.md)).
> **Sortie** : `testeur` → [4-termine.md](4-termine.md) si tous les critères passent,
> retour en [2-en-cours.md](2-en-cours.md) § *À corriger* sinon.

**Deux temps, dans cet ordre** :

1. **Contrôle de conformité** — l'agent `normes` confronte le diff aux normes et conventions
   écrites. Résultat : `Conformité : ✅ OK` sur le point, ou retour en *À corriger* avec les
   **Non-conformités** citées.
2. **Test fonctionnel** — le `testeur` n'intervient **qu'après** le tampon de conformité.

Chaque point porte **Livré** (ce qui a été fait, fichiers réellement touchés) et
**Comment tester** (la manipulation exacte). Sans ces deux champs, le point repart au
`developpeur` sans être ni contrôlé ni testé.

*(aucun point)*

<!-- Modèle :
### P-001 — Titre
- **Type** : Amélioration
- **Importance** : 🟡 · **Effort** : ⚡
- **Créé** : AAAA-MM-JJ · **Maj** : AAAA-MM-JJ
- **Besoin** : ⟨…⟩
- **Périmètre** : ⟨…⟩ ; **hors périmètre** : ⟨…⟩
- **Critères de vérification** :
  - [ ] ⟨critère observable⟩
- **Livré** : ⟨ce qui a été fait⟩ — fichiers touchés : `⟨a⟩`, `⟨b⟩`
- **Comment tester** : ⟨commande à lancer / parcours exact / ce qu'on doit voir⟩
- **Conformité** : ✅ OK — AAAA-MM-JJ *(normes)* ⟨+ remarques éventuelles⟩
- **Questions ouvertes** : aucune
- **Journal** :
  - AAAA-MM-JJ — cadrage complet → prêt à démarrer *(chef-de-projet)*
  - AAAA-MM-JJ — feu vert utilisateur → en cours *(chef-de-projet)*
  - AAAA-MM-JJ — développé → à tester *(developpeur)*
  - AAAA-MM-JJ — conformité vérifiée (⟨normes appliquées⟩) *(normes)*
-->
