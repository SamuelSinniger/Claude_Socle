---
description: Explique un concept, une commande ou un bout de code de façon synthétique, sous forme de tableau.
argument-hint: <sujet ou @fichier>
---
Explique de façon **synthétique et pédagogique** : $ARGUMENTS

Consignes :
- Réponds **en français**.
- Structure l'explication en **tableau(x)** quand c'est pertinent (ex. `concept | rôle | exemple`, ou `étape | commande | effet`).
- Donne un **exemple concret minimal**.
- Termine par les **pièges courants** ou le « quand l'utiliser / quand l'éviter ».
- Reste concis : pas de remplissage.

---

**Ce n'est pas `/detail`.** `/explique` porte sur ce qui existe **hors de ce dépôt** — une
notion, une commande, une bibliothèque, un mécanisme de langage — et se termine par « voilà
ce que c'est ». Dès que la question porte sur **ce projet-ci** (« comment marche notre
authentification ? », « qu'est-ce que ça coûterait de changer X ? »), c'est `/detail` :
il va lire le code, chiffre les options et **recommande**.
