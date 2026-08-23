# Projets installés

Registre des projets qui utilisent ce socle. Tenu à jour par `/socle install` et
`/socle update`. C'est ce qui rend « mettre à jour partout » actionnable : sans registre,
« partout » est un souvenir.

| Projet | Chemin | Version du socle | Dernière synchro | Dérogations |
|---|---|---|---|---|
| Argonaute | `F:/Dossiers/Documents/GitHub/Argonaute` | 1.3.0 | 2026-08-22 | — |

*(Argonaute : adopté le 2026-08-22 — six règles remontées au socle à cette occasion, cf. CHANGELOG 1.3.0.)*

## Après une nouvelle version du socle

1. `/socle promote` a écrit la règle, l'entrée de CHANGELOG et régénéré le manifeste.
2. Dans chaque projet du tableau : `/socle update`. La commande lit le CHANGELOG entre les
   deux versions et crée les points de **mise en conformité** là où c'est nécessaire.
3. Un projet peut **rester en arrière** volontairement (livraison en cours, gel avant mise en
   production) : noter la raison et la date prévue dans la colonne *Dernière synchro*. Un
   retard assumé et daté n'est pas une dette.

## Colonne dérogations

Un projet qui accumule les dérogations dit quelque chose sur le socle, pas sur le projet :
trois projets qui dérogent à la même règle signifient que la règle est mauvaise ou trop
générale. Elle se corrige alors dans le socle plutôt que d'être contournée trois fois.
