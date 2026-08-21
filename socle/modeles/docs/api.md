# API ⟨(type d'API, préfixe `/api`)⟩

**Sécurité** (voir ⟨[authentication.md](authentication.md)⟩) : les **mutations** exigent
⟨rôle / autorisation⟩. Les **lectures publiques filtrent** ⟨les données non publiées⟩
**côté serveur** ⟨mécanisme : rôle lu via …⟩. Un échec d'autorisation renvoie
**401/403** ⟨et non une redirection⟩.

> Convention de notation : 🔒 = mutation protégée ; *(en italique)* = comportement
> conditionnel selon le rôle de l'appelant.

## ⟨Domaine A⟩ (`⟨fichier source⟩`)

- `GET ⟨/api/…⟩` — ⟨ce que ça renvoie⟩ — *⟨restriction éventuelle⟩*
- `GET ⟨/api/…/{id}⟩` — ⟨…⟩ (*⟨404 dans quel cas⟩*)
- `POST ⟨/api/…⟩` 🔒 — ⟨création : corps attendu, champs validés, effets.⟩
- `PUT ⟨/api/…/{id}⟩` 🔒 — ⟨édition : ce qui est modifiable, ce qui ne l'est **jamais**.⟩
- `DELETE ⟨/api/…/{id}⟩` 🔒 — ⟨suppression : ce qui est supprimé, ce qui est **conservé**.⟩

## ⟨Domaine B⟩ (`⟨fichier source⟩`)

- ⟨…⟩

## Contrats

- ⟨DTO d'entrée / de sortie notable et où il est défini.⟩
- ⟨Règle de sérialisation à respecter — ex. enums exposés en chaîne : documenter
  l'attribut/option requis **et** la panne qu'il évite.⟩

## Codes de retour

| Code | Quand |
|---|---|
| `400` | ⟨validation : quels cas.⟩ |
| `401` / `403` | ⟨non authentifié / non autorisé.⟩ |
| `404` | ⟨ressource absente **ou** non visible pour l'appelant.⟩ |
