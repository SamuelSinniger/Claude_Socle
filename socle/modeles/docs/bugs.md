# Bugs — post-mortem

Journal des bugs **corrigés** : le symptôme, la **cause réelle**, le **correctif**, et la
règle à en retenir. C'est ce qui se relit ; le reste vit ailleurs.

> **Ce fichier n'est pas une inbox.** Un bug constaté entre directement dans le pipeline
> comme point de type `Correction` : [`suivi/1-backlog.md`](suivi/1-backlog.md) s'il
> demande du cadrage, [`suivi/2-en-cours.md`](suivi/2-en-cours.md) § *À corriger* s'il est
> clair et prioritaire. Voir [socle/suivi-contrat.md](../socle/suivi-contrat.md).
>
> Quand la cause d'un bug se formule en règle réutilisable (« toujours… », « ne jamais… »),
> **elle se recopie** dans [conventions.md](conventions.md) ou dans le doc de son domaine :
> personne ne relit un journal avant de coder.

## ⟨Session du JJ/MM⟩

- **⟨Symptôme observable, tel que l'utilisateur le voit⟩** ⟨(contexte : où, quand, ce qui
  le fait disparaître — les circonstances qui *évitent* le bug sont souvent l'indice
  décisif).⟩
  → cause : ⟨le mécanisme réel, pas la supposition — avec les mesures si on en a.⟩
  Correctif (`⟨fichier⟩`) : ⟨ce qui a été changé.⟩ **Vérifié** : ⟨comment on a constaté
  que c'était réglé.⟩ **Règle retenue** : ⟨la règle, recopiée dans ⟨fichier⟩⟩.
  Point : `⟨P-###⟩`.
