# Normes internationales

> **Fichier socle. Ne pas le modifier dans un projet.** Distribué et mis à jour depuis le
> dépôt socle ; `/socle check` signale toute modification locale. Le *Guide de contribution*
> ci-dessous s'applique **dans le dépôt socle** : une norme découverte en travaillant sur un
> projet s'ajoute là-bas, puis redescend par `/socle update`.
>
> **À quoi ça sert** : `R-130` et `R-131` rendent ces normes opposables — un champ dont le
> domaine est couvert ici porte le format de la norme, ou fournit un convertisseur.
> `/standards` liste celles qui s'appliquent à un projet et contrôle les écarts.

Liste de référence des principales normes et conventions à connaître dans le cadre d'un projet (développement logiciel, data, produit, international). Cette liste n'est pas exhaustive mais couvre les standards qui reviennent le plus souvent. Chaque table sépare le **nom** de la norme/réglementation/registre de son **type** (norme ISO, réglementation UE, registre officiel, référentiel privé, etc. — voir le guide de contribution ci-dessous), pour éviter de mélanger des dispositifs de nature très différente sous une même appellation générique « norme ». La colonne « Exemple en base de données » indique un usage concret (nom de colonne/table, type, valeur) ou **N/A** quand la norme ne se traduit pas directement en modèle de données. La colonne « Source » pointe vers une page officielle expliquant la norme (organisme de normalisation, agence internationale de référence, ou administration compétente) ; quand la norme ISO est payante et n'a pas de résumé public détaillé, le lien pointe vers la fiche catalogue officielle iso.org.

> **Note sur la fiabilité des sources** : les liens des sections 1, 2, 3, 4, 5 (partiellement), 7, 8, 9 (dont 9.1), 10, 11, 12, 14, 17 et 18 (majoritairement) ont été vérifiés en direct (recherche web ou récupération de page). Pour certaines pages administratives très spécifiques par pays (section 13) et quelques réglementations internationales ou normes EN (sections 15, 16, une partie de la 17, et certains points des sections 19 et 20 — ex: décrets français sur le pain, page CEN pour EN 16931/EN 13432), l'outil de recherche web a rencontré des interruptions ou blocages techniques pendant la compilation : ces liens pointent vers le site officiel de l'organisme compétent mais n'ont pas tous pu être vérifiés individuellement page par page. Vérifie-les avant tout usage réglementaire ou de conformité, ces pages pouvant changer d'adresse.
>
> **Ajouts du 2026-08-24** (sections 1, 4 et 14.2) : `RFC 7946` (GeoJSON), `RFC 6350` (vCard), `ISO 2709` (MARC), `ISO 15836` (Dublin Core) — repérés par `/standards check` comme désignés « format canonique » par le registre d'interopérabilité sans figurer ici. Les deux liens RFC suivent le motif stable de rfc-editor.org ; le lien Dublin Core pointe la page de spécification de DCMI ; **le lien ISO 2709 utilise la page de recherche officielle**, son numéro de fiche catalogue n'ayant pas été confirmé (règle 5). **Aucun des quatre n'a été vérifié en direct** — outil de recherche non sollicité lors de cet ajout.

**Sommaire par grande partie :**

- **Partie I — Normes universelles de référence** : géographie (1), dates/heures (2), unités et mesures (3), identité et contact (4), monnaies et finance (5)
- **Partie II — Entreprises et classification sectorielle** : identifiants d'entreprises (6)
- **Partie III — Informatique, données et développement** : encodage (7), sécurité/conformité (8), documents et facturation électronique (9), développement logiciel (10), accessibilité (11)
- **Partie IV — Gestion de projet** (12)
- **Partie V — Spécificités locales par pays** (13)
- **Partie VI — Normes sectorielles et métiers** : édition/livres (14), matières dangereuses (15), logistique/entrepôt/manutention (16), produits frais et agroalimentaire (17), économie circulaire et écocontribution (18), articles de sport (19), commerces alimentaires de proximité (20)

---

## Guide de contribution (à lire avant d'alimenter ce fichier)

Ce fichier est alimenté par plusieurs personnes, chacune via sa propre session Claude. Pour que le document reste cohérent et exploitable, toute session Claude qui ajoute ou modifie du contenu ici doit respecter les règles suivantes.

**1. Structure générale.** Le document est organisé en grandes « Parties » (chiffres romains, ## niveau 2) qui regroupent des sections numérotées en continu de 1 à N (### niveau 3, ex: « ### 6. Identifiants d'entreprises »). Une section peut se décomposer en sous-sections `#### N.M` (ex: `#### 13.2 Numéros de TVA...`) quand elle couvre plusieurs sous-thèmes ou une déclinaison par pays. Ne jamais recommencer la numérotation à 1 dans une nouvelle partie : elle continue celle de la partie précédente.

**2. Où ajouter une norme.** Identifier d'abord si elle rentre dans une section existante (relire les titres de section et leur contenu avant d'en créer une nouvelle). Si un thème métier entièrement nouveau est demandé (ex: santé, automobile, énergie), créer une nouvelle section à la fin de la Partie VI (Normes sectorielles et métiers), ou une nouvelle Partie si le thème ne rentre dans aucune des six parties existantes. Mettre à jour le sommaire en tête de fichier (« Sommaire par grande partie ») pour refléter tout ajout de section.

**3. Format de table obligatoire.** Chaque table de normes utilise ces colonnes, dans cet ordre : `Nom | Type | Domaine | Exemple | Exemple en base de données | Source`. `Nom` contient uniquement le nom/numéro de la norme, réglementation, registre ou référentiel (sans qualificatif). `Type` classe sa nature exacte, pour ne pas mélanger normes de jure, réglementations et dispositifs privés dans une même colonne — piocher dans le vocabulaire ci-dessous (créer une nouvelle valeur seulement si aucune ne convient, en gardant le même style « Catégorie (organisme précisé) ») :
   - Normes de jure (organismes de normalisation officiels) : `Norme ISO`, `Norme ISO/CEI`, `Norme ISO/CEI/IEEE`, `Norme CEI (IEC)`, `Norme CEN (EN)`, `Norme IETF (RFC)`, `Norme IETF (BCP)`, `Norme W3C`, `Norme OASIS`, `Norme UN/CEFACT`, `Recommandation UIT-T`.
   - Cadres intergouvernementaux non issus d'un organisme de normalisation : `Norme intergouvernementale (organisme)`, `Accord international (organisme)`, `Code international (organisme)`, `Norme militaire (OTAN)`, `Norme gouvernementale (pays)`.
   - Droit positif : `Réglementation (UE)`, `Loi / Décret (France)` (adapter le pays si besoin).
   - Registres, codes et nomenclatures officiels tenus par une administration ou une agence : `Registre / code officiel (organisme)`, `Nomenclature officielle (organisme/zone)`, `Qualification réglementée (pays)`, `Marquage réglementaire (pays)`.
   - Dispositifs d'origine privée ou communautaire : `Norme sectorielle privée (organisme)` (définit un format/identifiant technique, ex: GS1, EPAL), `Référentiel privé (organisme)` (méthodologie/corpus, ex: PMBOK, OWASP), `Certification privée (organisme)` (schéma d'audit, ex: IFS, BRCGS), `Norme de consortium (organisme)`, `Spécification de fait (organisme)` (jamais ratifiée par un organisme de normalisation), `Identifiant propriétaire (organisme)`, `Convention communautaire`.
   - Cas particuliers déjà utilisés : `Licence (Creative Commons)`, `Marque de statut (Creative Commons)`, `Label / signe officiel (organisme)`, `Comité technique (ISO)`, `Organisme / réseau (organisme)`, `Système propriétaire non normalisé` (à réserver aux dispositifs explicitement non reconnus par un organisme de normalisation, ex: ColorADD).
   
   Pour les tables de déclinaison par pays (comme la section 13), la première colonne reste `Pays` (pas de colonne `Type`, l'axe de la table étant déjà le pays) et les colonnes suivantes s'adaptent, mais `Source` reste toujours la dernière colonne.

**3bis. Colonne « Type MIME ».** Toute norme qui définit — même indirectement — un format de fichier ou un contenu transmissible (document, message, export de données) a potentiellement un type MIME correspondant, enregistré ou non à l'IANA. Ne pas se limiter aux sections évidentes comme « Formats de fichier » ou « Documents » : par exemple RFC 5545 (calendrier, section 2) ou RFC 5322 (email, section 4) en ont aussi un, alors qu'ils sont classés ailleurs par thème. Avant d'ajouter une nouvelle norme n'importe où dans le fichier, vérifier systématiquement si elle correspond à un format de fichier/message, et si oui :
   - Ajouter (ou compléter, si elle existe déjà) une colonne `Type MIME` dans la table concernée, positionnée juste avant `Source`.
   - Vérifier le type exact sur le registre officiel IANA (https://www.iana.org/assignments/media-types/) plutôt que de le deviner — plusieurs formats récents (TOML, Protocol Buffers, MessagePack) n'ont été officiellement enregistrés que récemment, et certains types « historiques » qu'on croit standards (ex: `application/x-yaml`) sont en réalité des alias non officiels.
   - Renseigner **N/A** avec une courte raison pour les lignes sans correspondance (identifiant, code de classification, réglementation, méthodologie), ou pour un type non enregistré officiellement à l'IANA (le préciser, ex: OpenAPI en section 10).
   - Si une table entière ne contient aucune norme correspondant à un format de fichier (ex: section 12, Gestion de projet), ne pas ajouter la colonne.

**4. Contenu de la colonne « Exemple en base de données ».** Toujours donner un exemple concret et actionnable : nom de colonne avec son type SQL (`snake_case TYPE(taille)`), nom de table plausible, et une valeur d'exemple si utile. Si la norme ne se traduit pas directement en modèle de données (norme organisationnelle, méthodologie, format d'échange de fichier, certification), écrire **N/A** suivi entre parenthèses d'une courte raison (ex: « N/A (certification organisationnelle) »).

**5. Contenu de la colonne « Source ».** Toujours un lien officiel : site de l'organisme de normalisation (iso.org, ietf.org/rfc-editor.org, w3.org...), de l'agence internationale de référence pour la norme (ex: gleif.org pour le LEI, isbn-international.org pour l'ISBN), ou de l'administration compétente (ex: insee.fr, irs.gov). **Ne jamais deviner une URL profonde et la présenter comme fiable** (numéros de catalogue ISO en particulier — ils sont impossibles à deviner correctement). Avant d'ajouter un lien :
   - Vérifier la page en direct avec un outil de recherche/fetch web quand disponible.
   - Si la norme ISO est payante sans résumé public, utiliser la fiche catalogue officielle (`https://www.iso.org/standard/XXXXX.html`) seulement si son numéro a été confirmé ; sinon utiliser `https://www.iso.org/search.html?q=NUMÉRO` (page de recherche officielle, toujours valide même sans connaître le numéro de fiche exact).
   - Si l'outil de recherche est indisponible ou qu'aucune page précise n'a pu être vérifiée, utiliser la page d'accueil de l'organisme compétent plutôt qu'une URL profonde devinée, et le signaler dans la note de fiabilité (règle 6).
   - Pour les tables « par pays » (section 13 et assimilées), un lien vers la page d'accueil de l'administration/opérateur national concerné est acceptable si la page précise n'est pas vérifiable.

**6. Note de fiabilité en tête de fichier.** Après chaque ajout, mettre à jour la ligne « Note sur la fiabilité des sources » en tête du document pour indiquer quelles sections viennent d'être vérifiées en direct et lesquelles reposent sur une connaissance non re-vérifiée en direct (et pourquoi, ex: interruption de l'outil de recherche).

**7. Ton et style.** Rédiger en français, de façon factuelle et concise (une ligne de description par norme dans la colonne Domaine). Pas de sur-formatage : uniquement des tables et, quand utile, une courte phrase d'introduction en prose au-dessus d'une section ou sous-section. Éviter les doublons : si une norme existe déjà ailleurs dans le fichier (ex: le LEI en section 5), y référer plutôt que de la recopier (« voir section X »).

---

## Partie I — Normes universelles de référence

### 1. Géographie et localisation

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 3166-1 | Norme ISO | Codes pays (alpha-2, alpha-3, numérique) | FR / FRA / 250 | Colonne `country_code CHAR(2)` dans une table `addresses`, avec clé étrangère vers une table de référence `countries` | [iso.org](https://www.iso.org/standard/72482.html) |
| ISO 3166-2 | Norme ISO | Subdivisions de pays (régions, états, provinces) | FR-IDF (Île-de-France) | Colonne `region_code VARCHAR(6)` dans `addresses`, ex: 'FR-IDF' | [iso.org](https://www.iso.org/standard/72483.html) |
| ISO 639-1 / -2 / -3 | Norme ISO | Codes langues (2 lettres, 3 lettres) | fr / fre-fra / fra | Colonne `language_code CHAR(2)` dans une table `content_translations` | [iso.org](https://www.iso.org/iso-639-language-codes.html) |
| BCP 47 | Norme IETF (BCP) | Identifiants de locale (langue + région) | fr-FR, en-US, pt-BR | Colonne `locale VARCHAR(10)` dans `user_preferences`, ex: 'fr-FR' | [rfc-editor.org](https://www.rfc-editor.org/info/bcp47) |
| UN M49 | Nomenclature officielle (ONU) | Codes régions géographiques et zones économiques de l'ONU | 150 = Europe | Colonne `un_region_code SMALLINT` dans une table de reporting `sales_by_region` | [unstats.un.org](https://unstats.un.org/unsd/methodology/m49/) |
| ISO 6709 | Norme ISO | Représentation des coordonnées géographiques | ±DD.DDDD±DDD.DDDD | Colonnes `latitude DECIMAL(9,6)` / `longitude DECIMAL(9,6)`, ou type `GEOGRAPHY(POINT)` dans `locations` | [iso.org](https://www.iso.org/standard/39242.html) |
| STANAG 1059 | Norme militaire (OTAN) | Codes pays de l'OTAN (trigraphes), utilisés dans les contextes militaires et interopérabilité de défense | FRA, USA, GBR | Colonne `nato_country_code CHAR(3)` dans une table `entities`, utilisée pour l'interopérabilité avec des systèmes de défense/OTAN | [nso.nato.int](https://nso.nato.int/nso/nsdd/main/standards) |
| GENC | Norme gouvernementale (États-Unis) | Standard gouvernemental américain (NGA/NIST) de codes pays et entités géopolitiques, très proche d'ISO 3166 mais avec des extensions | US, FR (éd. 3 update) | Colonne `genc_code CHAR(2)` dans `countries` | [nsgreg.nga.mil](https://nsgreg.nga.mil/genc/discovery) |
| RFC 7946 (GeoJSON) | Norme IETF (RFC) | Format d'échange de données géospatiales (points, lignes, polygones) en JSON ; ordre imposé longitude-latitude, référentiel WGS 84 | `{"type":"Point","coordinates":[2.35,48.85]}` | Colonne `geometry JSONB` dans `locations`, ou type `GEOGRAPHY` (PostGIS) exporté en GeoJSON | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc7946) |

### 2. Dates, heures et fuseaux horaires

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| ISO 8601 | Norme ISO | Format de date, heure, date+heure, durées et intervalles | 2026-08-19T14:30:00+02:00 | Colonne `created_at TIMESTAMP WITH TIME ZONE` stockée/affichée au format ISO 8601 | N/A (format de valeur, pas un type de fichier) | [iso.org](https://www.iso.org/iso-8601-date-and-time-format.html) |
| RFC 3339 | Norme IETF (RFC) | Profil internet d'ISO 8601, plus strict, utilisé massivement dans les API web, JSON et logs | 2026-08-19T14:30:00Z | Même colonne `created_at`, sérialisée au format RFC 3339 dans les réponses JSON | N/A (format de valeur, pas un type de fichier) | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc3339) |
| IANA Time Zone Database (tz database) | Registre / code officiel (IANA) | Fuseaux horaires avec règles historiques et changements d'heure | Europe/Paris | Colonne `timezone VARCHAR(64)` dans `user_profiles`, ex: 'Europe/Paris' | N/A (base de données de règles, pas un format de fichier) | [iana.org](https://www.iana.org/time-zones) |
| RFC 5545 (iCalendar) | Norme IETF (RFC) | Format d'échange d'événements calendaires | fichiers .ics | N/A (format de fichier d'export) | `text/calendar` | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc5545) |
| ISO 8601 (durées) | Norme ISO | Notation des durées | P3Y6M4DT12H30M5S | Colonne `duration INTERVAL` (type natif PostgreSQL) | N/A (format de valeur, pas un type de fichier) | [iso.org](https://www.iso.org/iso-8601-date-and-time-format.html) |

### 3. Unités et mesures

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Système International (SI) | Norme intergouvernementale (BIPM) | Unités de base (longueur, masse, temps...) | mètre, kilogramme, seconde | Colonnes `value DECIMAL` + `unit VARCHAR(10)` dans `measurements` | [bipm.org](https://www.bipm.org/en/measurement-units) |
| ISO 80000 | Norme ISO | Grandeurs et unités, notation scientifique | définitions formelles des unités | N/A (norme de définition) | [iso.org](https://www.iso.org/standard/30669.html) |
| ISO 216 | Norme ISO | Formats de papier | A4, A3, A5 | Colonne `paper_format VARCHAR(5)` dans `print_settings` | [iso.org](https://www.iso.org/standard/36631.html) |

### 4. Identité et contact

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| E.164 (UIT-T) | Recommandation UIT-T | Format international des numéros de téléphone | +33612345678 | Colonne `phone_number VARCHAR(16)` dans `contacts` | N/A (format de valeur, pas un type de fichier) | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| RFC 5322 | Norme IETF (RFC) | Format des adresses email (et, par extension, du message email complet) | nom@domaine.fr | Colonne `email VARCHAR(254)` avec contrainte de validation dans `users` | `message/rfc822` (pour un message email complet exporté en fichier .eml) | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc5322) |
| UPU S42 | Norme intergouvernementale (UPU) | Format international des adresses postales | référence utilisée par les services postaux | N/A directement, mais inspire la décomposition en colonnes `street`, `city`, `postal_code`, `country_code` | N/A (norme de structuration, pas un format de fichier) | [upu.int](https://www.upu.int/) |
| ISO 5218 | Norme ISO | Codes de représentation du sexe pour l'échange d'informations | 0=inconnu, 1=masculin, 2=féminin, 9=non spécifié | Colonne `gender_code TINYINT` dans `users`, valeurs 0/1/2/9 | N/A (code de valeur, pas un type de fichier) | [iso.org](https://www.iso.org/standard/36266.html) |
| RFC 6350 (vCard 4.0) | Norme IETF (RFC) | Format d'échange de fiches de contact — nom, téléphone, adresse, organisation | fichiers .vcf | N/A (format d'échange ; les champs qu'il porte vivent dans `contacts`) | `text/vcard` | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc6350) |

### 5. Monnaies et finance

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 4217 | Norme ISO | Codes devises | EUR, USD, CHF | Colonne `currency_code CHAR(3)` dans une table `transactions` | [iso.org](https://www.iso.org/iso-4217-currency-codes.html) |
| ISO 13616 | Norme ISO | IBAN (numéro de compte bancaire international) | FR76 3000... | Colonne `iban VARCHAR(34)` dans `bank_accounts` | [swift.com](https://www.swift.com/standards/data-standards/iban) |
| ISO 9362 | Norme ISO | Code BIC/SWIFT des banques | BNPAFRPPXXX | Colonne `bic VARCHAR(11)` dans `bank_accounts` | [swift.com](https://www.swift.com/standards/data-standards/bic-business-identifier-code) |
| ISO 20022 | Norme ISO | Messagerie financière standardisée (virements, paiements) | format XML | N/A (format de message interbancaire) | [iso20022.org](https://www.iso20022.org/) |
| ISO 17442 | Norme ISO | LEI (Legal Entity Identifier), identifiant unique d'entité légale | 20 caractères alphanumériques | Colonne `lei_code CHAR(20)` dans une table `companies` | [gleif.org](https://www.gleif.org/en/about-lei/iso-17442-the-lei-code-structure) |
| ISO 24165 | Norme ISO | DTI (Digital Token Identifier), identifiant unique d'un actif numérique/crypto-actif | 9 caractères alphanumériques, ex: 4H95J0R2X (Bitcoin) | Colonne `dti_code CHAR(9)` dans `digital_assets` | [dtif.org](https://dtif.org/) |

---

## Partie II — Entreprises et classification sectorielle

### 6. Identifiants d'entreprises et classification sectorielle

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 6523 | Norme ISO | Structure des identifiants d'organisations | schéma générique international | Colonnes `id_scheme VARCHAR(20)` + `id_value VARCHAR(50)` dans `organization_identifiers` | [iso.org](https://www.iso.org/search.html?q=6523) |
| LEI (ISO 17442) | Norme ISO | Identifiant unique d'entité légale au niveau mondial | voir section finance | Voir section 5 (`lei_code`) | voir section 5 |
| NACE | Nomenclature officielle (Union européenne) | Classification des activités économiques (Union Européenne) | ex: 62.01 (programmation informatique) | Colonne `nace_code VARCHAR(6)` dans `companies` | [ec.europa.eu/eurostat](https://ec.europa.eu/eurostat/web/nace) |
| NAICS | Nomenclature officielle (États-Unis/Canada) | Classification des activités économiques (Amérique du Nord) | équivalent nord-américain de la NACE | Colonne `naics_code CHAR(6)` dans `companies` | [census.gov](https://www.census.gov/naics/) |
| SIC | Nomenclature officielle (États-Unis) | Ancienne classification sectorielle (toujours utilisée, notamment aux US) | plus ancienne que NAICS | Colonne `sic_code CHAR(4)` dans `companies` | [osha.gov](https://www.osha.gov/data/sic-manual) |
| DUNS Number | Identifiant propriétaire (Dun & Bradstreet) | Identifiant d'entreprise propriétaire (Dun & Bradstreet) | 9 chiffres | Colonne `duns_number CHAR(9)` dans `companies` | [dnb.com](https://www.dnb.com/duns-number.html) |

#### 6.1 Référentiels et codes INSEE (France)

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| SIRET / SIREN | Registre / code officiel (INSEE, France) | Identifiants d'entreprises et d'établissements en France, attribués par l'INSEE | 14 / 9 chiffres | Colonnes `siret CHAR(14)` / `siren CHAR(9)` dans `companies` | [insee.fr](https://www.insee.fr/fr/metadonnees/definition/c1841) |
| NAF (Nomenclature d'Activités Française) | Nomenclature officielle (France, INSEE) | Déclinaison française de la NACE, classification de l'activité principale d'une entreprise, attribuée par l'INSEE | 62.01Z (programmation informatique) | Colonne `naf_code VARCHAR(6)` dans `companies` | [insee.fr](https://www.insee.fr/fr/information/2120875) |
| COG (Code Officiel Géographique) | Registre / code officiel (INSEE, France) | Référentiel INSEE des codes géographiques français : communes, cantons, arrondissements, départements, régions et pays étrangers | 75056 (code commune de Paris) | Colonne `insee_commune_code CHAR(5)` dans `addresses` | [insee.fr](https://www.insee.fr/fr/information/2560452) |
| RNIPP (Répertoire National d'Identification des Personnes Physiques) | Registre / code officiel (INSEE, France) | Registre national tenu par l'INSEE qui inscrit toute personne née en France et lui attribue son NIR | registre administratif | N/A directement (registre) ; c'est l'organisme d'attribution du NIR ci-dessous | [insee.fr](https://www.insee.fr/fr/metadonnees/definition/c1409) |
| NIR (Numéro d'Inscription au Répertoire) | Registre / code officiel (INSEE, France) | Identifiant unique de 13 chiffres + clé attribué par le RNIPP à chaque personne (sexe, année/mois de naissance, lieu, ordre), couramment appelé « numéro de sécurité sociale » | 2 85 07 75 108 157 42 | Colonne `national_id VARCHAR(15)`, chiffrée (voir aussi section 13.3) | [insee.fr](https://www.insee.fr/fr/metadonnees/definition/c1409) |

---

## Partie III — Informatique, données et développement

### 7. Encodage et formats de données

#### 7.1 Jeux de caractères

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Unicode / UTF-8 | Norme de consortium (Unicode Consortium) | Encodage universel des caractères | standard de fait sur le web | Configuration du charset/collation de la base | [unicode.org](https://www.unicode.org/standard/standard.html) |
| ISO/IEC 8859 | Norme ISO/CEI | Anciens jeux de caractères régionaux (avant Unicode) | ISO-8859-1 (Latin-1) | N/A (encodage historique) | [iso.org](https://www.iso.org/standard/28245.html) |
| ISO/IEC 646 | Norme ISO/CEI | Jeu de caractères codés sur 7 bits, base historique de l'ASCII | 128 caractères (lettres, chiffres, symboles) | N/A (encodage historique, encore utilisé pour valider des identifiants « ASCII only ») | [iso.org](https://www.iso.org/standard/4777.html) |
| UTF-16 | Norme de consortium (Unicode Consortium) | Encodage Unicode sur 16 bits (paires de substituts pour les caractères hors plan de base) | utilisé en interne par Java, Windows, JavaScript | Encodage interne de certains moteurs applicatifs ; rarement le choix de stockage en base (préférer UTF-8) | [unicode.org](https://unicode.org/faq/utf_bom.html) |

#### 7.2 Formats de fichier

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| RFC 8259 | Norme IETF (RFC) | Format JSON | {"clé": "valeur"} | Colonne de type `JSON`/`JSONB` dans `events` | `application/json` | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc8259) |
| RFC 4180 | Norme IETF (RFC) | Format CSV | valeurs séparées par virgules | N/A (format d'export/import de fichiers) | `text/csv` | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc4180) |
| RFC 6838 | Norme IETF (RFC) | Types MIME (identification des formats de fichiers) | application/json, image/png | Colonne `mime_type VARCHAR(100)` dans `attachments` | N/A (cette norme définit le mécanisme des types MIME lui-même) | [rfc-editor.org](https://www.rfc-editor.org/rfc/rfc6838) |
| XML (W3C) | Norme W3C | Format de données structurées | balises \<tag\>valeur\</tag\> | Colonne de type `XML` dans `documents` | `application/xml` (ou `text/xml`) | [w3.org](https://www.w3.org/TR/xml/) |
| YAML | Spécification de fait (communauté YAML) | Format de données structurées lisible par un humain, très utilisé pour les fichiers de configuration | fichiers `.yml`/`.yaml` (docker-compose, CI/CD) | N/A (fichier de configuration, pas un type de stockage en base) | `application/yaml` (RFC 9512) | [yaml.org](https://yaml.org/spec/1.2.2/) |
| TOML | Spécification de fait (communauté TOML) | Format de fichier de configuration minimaliste | fichiers `.toml` (ex: `pyproject.toml`, `Cargo.toml`) | N/A (fichier de configuration) | `application/toml` (enregistré à l'IANA en 2024) | [toml.io](https://toml.io/en/) |
| Protocol Buffers (protobuf) | Spécification de fait (Google) | Format de sérialisation binaire structuré et typé, indépendant du langage (Google) | fichiers `.proto` définissant un schéma de message | N/A directement ; les messages décodés alimentent les colonnes correspondantes des tables applicatives | `application/protobuf` | [protobuf.dev](https://protobuf.dev/overview/) |
| MessagePack | Spécification de fait (communauté MessagePack) | Format de sérialisation binaire compact, équivalent performant de JSON | encodage binaire d'une structure JSON | Colonne de type `BLOB`/`BYTEA` dans `cache_entries` quand la compacité prime sur la lisibilité | `application/vnd.msgpack` | [msgpack.org](https://msgpack.org/) |

#### 7.3 Formats d'image (matriciel et vectoriel)

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| ISO/IEC 10918 (JPEG / JFIF) | Norme ISO/CEI | Format de compression avec perte des images photographiques, le plus répandu au monde | fichiers .jpg/.jpeg | Colonne `mime_type` = 'image/jpeg' dans `media_files` | `image/jpeg` | [iso.org](https://www.iso.org/standard/54989.html) |
| PNG (ISO/IEC 15948 / W3C) | Norme ISO/CEI | Format d'image matricielle sans perte, avec canal alpha (transparence) | fichiers .png | Colonne `mime_type` = 'image/png' dans `media_files` | `image/png` | [w3.org](https://www.w3.org/TR/png/) |
| GIF (spécification CompuServe 89a) | Spécification de fait (CompuServe, non ratifiée) | Format d'image matricielle indexée (256 couleurs max), animable ; jamais repris par un organisme de normalisation officiel | fichiers .gif | Colonne `mime_type` = 'image/gif' dans `media_files` | `image/gif` | [w3.org](https://www.w3.org/Graphics/GIF/spec-gif89a.txt) |
| TIFF (spécification Adobe, Revision 6.0) | Spécification de fait (Adobe) | Format d'image matricielle sans perte, très utilisé en impression, archivage et imagerie géospatiale | fichiers .tif/.tiff | Colonne `mime_type` = 'image/tiff' dans `media_files` | `image/tiff` | [loc.gov](https://www.loc.gov/preservation/digital/formats/fdd/fdd000022.shtml) |
| ISO/IEC 15444 (JPEG 2000) | Norme ISO/CEI | Format de compression d'image par ondelettes, meilleure qualité que JPEG à taux de compression égal | fichiers .jp2 | Colonne `mime_type` = 'image/jp2' dans `media_files` | `image/jp2` | [iso.org](https://www.iso.org/standard/78321.html) |
| ISO/IEC 23008-12 (HEIF / HEIC) | Norme ISO/CEI | Format de conteneur d'image haute efficacité (codec HEVC), utilisé par défaut sur iOS | fichiers .heic | Colonne `mime_type` = 'image/heic' dans `media_files` | `image/heic` | [iso.org](https://www.iso.org/standard/83650.html) |
| AVIF (Alliance for Open Media) | Spécification de fait (Alliance for Open Media) | Format d'image basé sur le codec vidéo AV1, très compact, gagne du terrain sur le web | fichiers .avif | Colonne `mime_type` = 'image/avif' dans `media_files` | `image/avif` | [aomediacodec.github.io](https://aomediacodec.github.io/av1-avif/) |
| WebP (Google) | Spécification de fait (Google) | Format d'image matricielle compact pour le web, avec transparence et animation | fichiers .webp | Colonne `mime_type` = 'image/webp' dans `media_files` | `image/webp` | [developers.google.com](https://developers.google.com/speed/webp) |
| ISO/IEC 18181 (JPEG XL) | Norme ISO/CEI | Format d'image nouvelle génération, successeur potentiel du JPEG, transcodage sans perte depuis un .jpg existant | fichiers .jxl | Colonne `mime_type` = 'image/jxl' dans `media_files` | `image/jxl` | [jpeg.org](https://jpeg.org/jpegxl/) |
| SVG (W3C) | Norme W3C | Format d'image vectorielle basé sur XML, redimensionnable sans perte de qualité | fichiers .svg | Colonne `mime_type` = 'image/svg+xml' dans `media_files` | `image/svg+xml` | [w3.org](https://www.w3.org/TR/SVG2/) |

#### 7.4 Métadonnées et gestion de la couleur des images

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| Exif (CIPA DC-008) | Norme sectorielle privée (CIPA) | Métadonnées techniques intégrées à un fichier image (appareil, date de prise de vue, GPS, exposition) | tags EXIF dans un JPEG ou TIFF | Colonne `exif_data JSON` dans `media_files` | N/A (métadonnées encapsulées dans le fichier hôte, pas un type MIME propre) | [cipa.jp](https://www.cipa.jp/) |
| IPTC Photo Metadata | Norme sectorielle privée (IPTC) | Métadonnées descriptives et de droits d'auteur d'une image (légende, mots-clés, crédit, licence) | champs IPTC intégrés au fichier | Colonnes `caption`, `keywords TEXT[]`, `copyright_notice` dans `media_files` | N/A (métadonnées encapsulées dans le fichier hôte) | [iptc.org](https://iptc.org/standards/photo-metadata/) |
| ISO 16684-1 (XMP) | Norme ISO | Plateforme de métadonnées extensible en XML, encapsulée dans le fichier (Adobe) | bloc XMP dans un JPEG, TIFF ou PDF | Colonne `xmp_metadata XML` dans `media_files` | N/A (métadonnées encapsulées dans le fichier hôte) | [iso.org](https://www.iso.org/standard/75163.html) |
| ISO 15076-1 (profil ICC) | Norme ISO | Profil de gestion de la couleur associé à une image, assure une restitution fidèle entre appareils | profil .icc/.icm intégré ou externe | Colonne `icc_profile BYTEA` dans `media_files` | `application/vnd.iccprofile` | [color.org](https://www.color.org/icc_specs2.xalter) |
| sRGB (IEC 61966-2-1) | Norme CEI (IEC) | Espace colorimétrique standard par défaut pour le web et la majorité des écrans grand public | espace couleur RVB de référence | Colonne `color_space VARCHAR(20)` = 'sRGB' dans `media_files` | N/A (espace colorimétrique, pas un format de fichier) | [w3.org](https://www.w3.org/Graphics/Color/sRGB) |

#### 7.5 Licences de contenu créatif (Creative Commons)

Les licences Creative Commons ne portent pas sur un format de fichier mais sur les droits d'usage d'une œuvre (image, texte, musique, vidéo, jeu de données...). Chacune dispose d'un identifiant standardisé, repris tel quel dans la liste officielle des licences SPDX (voir aussi section 10), ce qui permet de les stocker de la même façon qu'une licence logicielle. On les retrouve aussi couramment dans les métadonnées XMP (`dc:rights`) d'un fichier image, en complément des sections 7.3 et 7.4.

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| CC0 1.0 (Public Domain Dedication) | Licence (Creative Commons) | Renonciation volontaire et totale aux droits d'auteur ; l'œuvre est traitée comme si elle était dans le domaine public | identifiant SPDX `CC0-1.0` | Colonne `license VARCHAR(20)` = 'CC0-1.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/publicdomain/zero/1.0/) |
| CC BY 4.0 | Licence (Creative Commons) | Attribution seule requise ; la plus permissive des licences avec obligation d'attribution | identifiant SPDX `CC-BY-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by/4.0/) |
| CC BY-SA 4.0 | Licence (Creative Commons) | Attribution + partage dans les mêmes conditions (licence « copyleft », comme sur Wikipédia) | identifiant SPDX `CC-BY-SA-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-SA-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by-sa/4.0/) |
| CC BY-NC 4.0 | Licence (Creative Commons) | Attribution + interdiction d'usage commercial | identifiant SPDX `CC-BY-NC-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-NC-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by-nc/4.0/) |
| CC BY-NC-SA 4.0 | Licence (Creative Commons) | Attribution + non commercial + partage dans les mêmes conditions | identifiant SPDX `CC-BY-NC-SA-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-NC-SA-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by-nc-sa/4.0/) |
| CC BY-ND 4.0 | Licence (Creative Commons) | Attribution + pas de modification (aucune œuvre dérivée autorisée) | identifiant SPDX `CC-BY-ND-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-ND-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by-nd/4.0/) |
| CC BY-NC-ND 4.0 | Licence (Creative Commons) | Attribution + non commercial + pas de modification ; la plus restrictive des licences Creative Commons | identifiant SPDX `CC-BY-NC-ND-4.0` | Colonne `license VARCHAR(20)` = 'CC-BY-NC-ND-4.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/licenses/by-nc-nd/4.0/) |
| Public Domain Mark (PDM) 1.0 | Marque de statut (Creative Commons) | Marque indiquant qu'une œuvre est déjà dans le domaine public (à la différence de CC0, qui est un acte actif de renonciation) | identifiant `PDM-1.0` | Colonne `license VARCHAR(20)` = 'PDM-1.0' dans `media_assets` | [creativecommons.org](https://creativecommons.org/publicdomain/mark/1.0/) |

### 8. Sécurité, qualité et conformité

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 9001 | Norme ISO | Système de management de la qualité | certification d'organisation | N/A (certification organisationnelle) | [iso.org](https://www.iso.org/standard/62085.html) |
| ISO/IEC 27001 | Norme ISO/CEI | Sécurité de l'information | gestion des risques SI | N/A directement, motive des tables comme `audit_logs` | [iso.org](https://www.iso.org/standard/27001) |
| ISO/IEC 27701 | Norme ISO/CEI | Extension protection des données personnelles (complète 27001) | utile pour conformité RGPD | N/A directement, voir ligne RGPD | [iso.org](https://www.iso.org/standard/71670.html) |
| ISO/IEC 25010 | Norme ISO/CEI | Qualité logicielle (fiabilité, performance, sécurité, maintenabilité) | modèle SQuaRE | N/A (modèle de qualité) | [iso.org](https://www.iso.org/standard/35733.html) |
| RGPD (UE) | Réglementation (UE) | Réglementation européenne sur la protection des données | pas une norme ISO, mais incontournable en Europe | Colonnes `consent_given BOOLEAN`, `consent_date TIMESTAMP` dans `users` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/FR/TXT/?uri=CELEX%3A32016R0679) |
| OWASP Top 10 | Référentiel privé (OWASP) | Référentiel des principales vulnérabilités applicatives web | pas une norme officielle, mais référence de facto | Colonne `password_hash VARCHAR(255)` dans `users` | [owasp.org](https://owasp.org/www-project-top-ten/) |
| NIST Cybersecurity Framework | Norme gouvernementale (États-Unis, NIST) | Cadre de gestion des risques cyber | identifier / protéger / détecter / répondre / rétablir | N/A (cadre organisationnel) | [nist.gov](https://www.nist.gov/cyberframework) |

### 9. Documents et formats d'échange

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| ISO 32000 | Norme ISO | Format PDF | .pdf | Colonne `mime_type` = 'application/pdf' dans `documents` | `application/pdf` | [iso.org](https://www.iso.org/standard/75839.html) |
| ISO 19005 | Norme ISO | PDF/A, format PDF pour l'archivage à long terme | .pdf conforme archivage | Colonne `format_version VARCHAR(10)` = 'PDF/A-2b' dans `archived_documents` | `application/pdf` (profil du PDF standard, pas de sous-type MIME distinct) | [iso.org](https://www.iso.org/standard/38920.html) |
| ISO/IEC 29500 | Norme ISO/CEI | Format Office Open XML (OOXML) | .docx, .xlsx, .pptx | Colonne `mime_type` OOXML dans `attachments` | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` (.docx) ; `...spreadsheetml.sheet` (.xlsx) ; `...presentationml.presentation` (.pptx) | [iso.org](https://www.iso.org/standard/71691.html) |
| ISO/IEC 26300 | Norme ISO/CEI | Format OpenDocument (ODF) | .odt, .ods, .odp | Colonne `mime_type` ODF dans `attachments` | `application/vnd.oasis.opendocument.text` (.odt) ; `.spreadsheet` (.ods) ; `.presentation` (.odp) | [iso.org](https://www.iso.org/standard/66363.html) |

#### 9.1 Facturation électronique et documents commerciaux structurés

La facturation électronique est encadrée par un modèle sémantique européen commun (EN 16931), qui se concrétise via plusieurs formats de fichier concurrents ou complémentaires. En France, la réforme de la facturation électronique obligatoire entre entreprises s'appuie sur ces mêmes formats, échangés via des plateformes agréées (PDP) et un portail public (PPF).

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| Directive 2014/55/UE | Réglementation (UE) | Impose la norme européenne de facturation électronique dans les marchés publics | transposition dans chaque État membre de l'UE | N/A (directive réglementaire) | N/A | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014L0055) |
| EN 16931 | Norme CEN (EN) | Norme européenne (CEN) définissant le modèle sémantique de données d'une facture électronique (champs obligatoires, règles de validation) | modèle sémantique interopérable dans l'UE | N/A directement ; motive les colonnes obligatoires d'une table `invoices` (émetteur, destinataire, TVA, montants, référence) | N/A (norme de modèle de données, pas un format de fichier en soi) | [cencenelec.eu](https://www.cencenelec.eu/) |
| Factur-X / ZUGFeRD | Norme sectorielle privée (FNFE-MPE / FeRD) | Format hybride PDF+XML franco-allemand implémentant EN 16931 ; format obligatoire pour la réforme française | fichier PDF/A-3 embarquant un XML CII | Colonne `invoice_pdf BYTEA` (PDF/A-3) dans `invoices`, le XML étant une pièce jointe interne au PDF | `application/pdf` (le flux XML est une pièce jointe embarquée dans le PDF/A-3, sans type MIME propre) | [fnfe-mpe.org](https://fnfe-mpe.org/factur-x/) |
| UBL (Universal Business Language) | Norme OASIS | Format XML générique (OASIS) pour documents commerciaux : factures, commandes, bons de livraison, catalogues | fichier `Invoice-2.3.xml` | Colonne `invoice_xml XML` dans `invoices` | `application/xml` (pas de sous-type MIME dédié enregistré à l'IANA) | [docs.oasis-open.org](https://docs.oasis-open.org/ubl/UBL-2.3.html) |
| UN/CEFACT CII (Cross Industry Invoice) | Norme UN/CEFACT | Format XML porté par l'ONU (UN/CEFACT) pour l'échange de factures, alternative à UBL, utilisé comme socle de Factur-X | fichier XML `CrossIndustryInvoice` | Colonne `invoice_xml XML` dans `invoices` | `application/xml` | [unece.org](https://unece.org/trade/uncefact) |
| PEPPOL (réseau + BIS Billing) | Organisme / réseau (OpenPeppol) | Réseau européen d'échange de documents commerciaux entre plateformes certifiées (Access Points) ; le format BIS Billing est basé sur UBL et conforme à EN 16931 | identifiant d'entreprise sur le réseau (Peppol ID) | Colonne `peppol_id VARCHAR(50)` dans `companies` | N/A (réseau d'échange ; les fichiers transmis sont en UBL/XML) | [peppol.org](https://peppol.org/) |

### 10. Développement logiciel

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| Semantic Versioning (SemVer) | Convention communautaire | Numérotation des versions logicielles | MAJOR.MINOR.PATCH (ex: 2.4.1) | Colonne `version VARCHAR(20)` dans `releases` | N/A | [semver.org](https://semver.org) |
| Keep a Changelog | Convention communautaire | Convention de rédaction des changelogs | format standardisé par version | Table `changelog_entries` | N/A | [keepachangelog.com](https://keepachangelog.com/en/1.1.0/) |
| Conventional Commits | Convention communautaire | Convention de messages de commit Git | feat:, fix:, chore:... | Colonne `commit_type ENUM(...)` dans une table d'analytics | N/A | [conventionalcommits.org](https://www.conventionalcommits.org/en/v1.0.0/) |
| RFC 2119 / RFC 8174 | Norme IETF (RFC) | Vocabulaire normatif des spécifications techniques | MUST, SHOULD, MAY | N/A (convention rédactionnelle) | N/A | [datatracker.ietf.org](https://datatracker.ietf.org/doc/html/rfc2119) |
| SPDX | Norme de consortium (SPDX / Linux Foundation) | Identifiants standardisés de licences open source (et, plus largement, de toute licence reprise dans sa liste, dont les licences Creative Commons — voir section 7.5) | MIT, Apache-2.0, GPL-3.0 | Colonne `license_spdx_id VARCHAR(50)` dans `dependencies` | N/A (identifiant, pas un format de fichier) | [spdx.dev](https://spdx.dev/) |
| ISO/IEC/IEEE 12207 | Norme ISO/CEI/IEEE | Cycle de vie des logiciels | processus de développement logiciel | N/A (norme de processus) | N/A | [iso.org](https://www.iso.org/standard/63712.html) |
| OpenAPI (ex-Swagger) | Spécification de fait (OpenAPI Initiative) | Description standardisée des API REST | fichier openapi.yaml | N/A (fichier de spécification) | non enregistré officiellement à l'IANA ; servi en `application/json` ou `application/yaml` selon le format d'export | [openapis.org](https://www.openapis.org/) |

### 11. Accessibilité

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| WCAG (W3C) | Norme W3C | Règles d'accessibilité des contenus web | niveaux A, AA, AAA | Colonne `alt_text VARCHAR(255)` dans `images` | [w3.org](https://www.w3.org/WAI/standards-guidelines/wcag/) |
| ISO/IEC 40500 | Norme ISO/CEI | Norme ISO reprenant les WCAG 2.0 | équivalence officielle internationale | Même exemple que WCAG ci-dessus | [iso.org](https://www.iso.org/standard/58625.html) |
| EN 301 549 | Norme CEN (EN) | Norme européenne d'accessibilité numérique (secteur public) | référence légale dans l'UE | N/A (norme réglementaire) | [etsi.org](https://www.etsi.org/deliver/etsi_en/301500_301599/301549/) |

#### 11.1 Systèmes propriétaires non normalisés (à utiliser avec prudence)

Les éléments ci-dessous sont parfois rencontrés dans des projets liés à l'accessibilité, mais **ne sont pas des normes** (aucune reconnaissance ISO ni par un organisme de normalisation national ou international). Ce sont des systèmes propriétaires, protégés par droit d'auteur et/ou marque déposée, dont l'usage est généralement soumis à licence.

| Nom | Type | Domaine | Statut | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ColorADD | Système propriétaire non normalisé | Code de pictogrammes (formes géométriques) aidant les personnes daltoniennes à identifier les couleurs | **Non normalisé** — système propriétaire créé par Miguel Neiva (Portugal), protégé par droit d'auteur et marque déposée ; licence commerciale requise auprès de Miguel Neiva & Associados (modèle pro-bono pour écoles/universités via l'ONG ColorADD.Social) ; reconnu par le prix Vodafone Foundation "Mobile For Good Europe Awards" 2013, mais sans désignation ISO ou nationale | N/A (pas d'identifiant standardisé en base ; si utilisé, prévoir un champ propre à l'implémentation, ex. `color_code VARCHAR(10)`) | [coloradd.net](https://www.coloradd.net/) |

---

## Partie IV — Gestion de projet

### 12. Gestion de projet

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 21500 / ISO 21502 | Norme ISO | Lignes directrices sur le management de projet | cadre générique international | N/A (méthodologie) | [iso.org](https://www.iso.org/standard/74947.html) |
| PMBOK (PMI) | Référentiel privé (PMI) | Corpus de connaissances en gestion de projet | référence nord-américaine | N/A | [pmi.org](https://www.pmi.org/standards/pmbok) |
| PRINCE2 | Référentiel privé (Axelos/PeopleCert) | Méthode de gestion de projet structurée | référence européenne, notamment UK | N/A | [peoplecert.org](https://www.peoplecert.org/prince2) |
| ISO 10006 | Norme ISO | Management de la qualité appliqué aux projets | complète ISO 9001 | N/A | [iso.org](https://www.iso.org/standard/70376.html) |

---

## Partie V — Spécificités locales par pays

### 13. Normes et formats locaux par pays

Contrairement aux normes ISO/RFC précédentes qui sont mondiales, les éléments ci-dessous sont définis pays par pays (par l'administration postale, fiscale ou sociale locale). Il n'existe pas toujours de norme ISO unique : chaque pays fixe son propre format.

#### 13.1 Formats de codes postaux par pays

| Pays | Format | Longueur | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| France (FR) | 5 chiffres | 5 | 75001 | `postal_code CHAR(5)` | [laposte.fr](https://www.laposte.fr/particulier/outils/trouver-un-code-postal) |
| Belgique (BE) | 4 chiffres | 4 | 1000 | `postal_code CHAR(4)` | [bpost.be](https://www.bpost.be/fr/trouver-un-code-postal) |
| Suisse (CH) | 4 chiffres | 4 | 8001 | `postal_code CHAR(4)` | [post.ch](https://www.post.ch/) |
| Allemagne (DE) | 5 chiffres | 5 | 10115 | `postal_code CHAR(5)` | [deutschepost.de](https://www.deutschepost.de/de/p/plz-suche.html) |
| Espagne (ES) | 5 chiffres | 5 | 28001 | `postal_code CHAR(5)` | [correos.es](https://www.correos.es/es/es/herramientas/codigos-postales) |
| Italie (IT) | 5 chiffres | 5 | 00100 | `postal_code CHAR(5)` | [poste.it](https://www.poste.it/cerca/index.html#/cap) |
| Portugal (PT) | NNNN-NNN | 7 (avec tiret) | 1000-001 | `postal_code VARCHAR(8)` | [ctt.pt](https://www.ctt.pt/particulares/codigo-postal) |
| Pays-Bas (NL) | 4 chiffres + 2 lettres | 6 | 1012 AB | `postal_code VARCHAR(7)` | [postnl.nl](https://www.postnl.nl/en/mail-and-parcels/mail/postal-code-check/) |
| Royaume-Uni (GB) | Alphanumérique variable | 5 à 7 | SW1A 1AA | `postal_code VARCHAR(8)` | [royalmail.com](https://www.royalmail.com/find-a-postcode) |
| Irlande (IE) | Eircode alphanumérique | 7 | D02 AF30 | `postal_code VARCHAR(8)` | [eircode.ie](https://www.eircode.ie/) |
| États-Unis (US) | ZIP ou ZIP+4 | 5 ou 10 | 90210 / 90210-1234 | `postal_code VARCHAR(10)` | [usps.com](https://tools.usps.com/zip-code-lookup.htm) |
| Canada (CA) | Lettre-chiffre alterné | 6 (+ espace) | K1A 0B1 | `postal_code VARCHAR(7)` | [canadapost-postescanada.ca](https://www.canadapost-postescanada.ca/scp/en/tools/find-a-postal-code.page) |
| Brésil (BR) | CEP, NNNNN-NNN | 8 (avec tiret) | 01310-100 | `postal_code VARCHAR(9)` | [correios.com.br](https://www.correios.com.br/) |
| Japon (JP) | NNN-NNNN | 7 (avec tiret) | 100-0001 | `postal_code VARCHAR(8)` | [post.japanpost.jp](https://www.post.japanpost.jp/zipcode/) |
| Chine (CN) | 6 chiffres | 6 | 100000 | `postal_code CHAR(6)` | [chinapost.com.cn](http://english.chinapost.com.cn/) |
| Inde (IN) | PIN code, 6 chiffres | 6 | 110001 | `postal_code CHAR(6)` | [indiapost.gov.in](https://www.indiapost.gov.in/vas/pages/findpincode.aspx) |
| Australie (AU) | 4 chiffres | 4 | 2000 | `postal_code CHAR(4)` | [auspost.com.au](https://auspost.com.au/postcode) |
| Pologne (PL) | NN-NNN | 6 (avec tiret) | 00-001 | `postal_code VARCHAR(6)` | [poczta-polska.pl](https://kody.poczta-polska.pl/) |
| Suède (SE) | NNN NN | 5 (+ espace) | 111 22 | `postal_code VARCHAR(6)` | [postnord.se](https://www.postnord.se/verktyg/sok-postnummer) |
| Danemark (DK) | 4 chiffres | 4 | 1050 | `postal_code CHAR(4)` | [postnord.dk](https://www.postnord.dk/find-postnummer) |
| Autriche (AT) | 4 chiffres | 4 | 1010 | `postal_code CHAR(4)` | [post.at](https://www.post.at/plz-verzeichnis) |
| Corée du Sud (KR) | 5 chiffres (nouveau système depuis 2015) | 5 | 03187 | `postal_code CHAR(5)` | [epost.go.kr](https://www.epost.go.kr/) |

Bonne pratique en base : stocker le code postal en `VARCHAR` (jamais en entier, à cause des zéros non significatifs comme en France ou en Belgique) accompagné systématiquement d'un `country_code CHAR(2)` (ISO 3166-1) pour appliquer la bonne règle de validation selon le pays.

#### 13.2 Numéros de TVA et identifiants fiscaux d'entreprise par pays

**Union Européenne (numéro de TVA intracommunautaire) :**

| Pays | Préfixe + format | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|
| France | FR + 11 caractères (2 clé + 9 SIREN) | FR32123456789 | `vat_number VARCHAR(15)` dans `companies` | [impots.gouv.fr](https://www.impots.gouv.fr/professionnel/tva) |
| Belgique | BE + 10 chiffres | BE0123456789 | idem | [finances.belgium.be](https://finances.belgium.be/fr/entreprises/tva) |
| Allemagne | DE + 9 chiffres | DE123456789 | idem | [bzst.de](https://www.bzst.de/DE/Unternehmen/Identifikationsnummern/USt_IdNr/ust_idnr_node.html) |
| Espagne | ES + 9 caractères | ESX1234567X | idem | [agenciatributaria.gob.es](https://sede.agenciatributaria.gob.es/) |
| Italie | IT + 11 chiffres | IT12345678901 | idem | [agenziaentrate.gov.it](https://www.agenziaentrate.gov.it/) |
| Pays-Bas | NL + 12 caractères | NL123456789B01 | idem | [belastingdienst.nl](https://www.belastingdienst.nl/) |
| Luxembourg | LU + 8 chiffres | LU12345678 | idem | [impotsdirects.public.lu](https://impotsdirects.public.lu/) |
| Portugal | PT + 9 chiffres | PT123456789 | idem | [portaldasfinancas.gov.pt](https://www.portaldasfinancas.gov.pt/) |
| Irlande | IE + 7 chiffres + 1-2 lettres | IE1234567FA | idem | [revenue.ie](https://www.revenue.ie/) |
| Autriche | ATU + 8 chiffres | ATU12345678 | idem | [bmf.gv.at](https://www.bmf.gv.at/) |
| Danemark | DK + 8 chiffres | DK12345678 | idem | [skat.dk](https://skat.dk/) |

**Hors Union Européenne (identifiant fiscal ou d'entreprise équivalent) :**

| Pays | Identifiant | Format | Exemple en base de données | Source |
|---|---|---|---|---|
| Royaume-Uni | VAT Registration Number (post-Brexit) | GB + 9 ou 12 chiffres | `vat_number VARCHAR(15)` | [gov.uk](https://www.gov.uk/vat-registration) |
| États-Unis | EIN (Employer Identification Number) | NN-NNNNNNN | `ein VARCHAR(10)` | [irs.gov](https://www.irs.gov/businesses/employer-identification-number) |
| Japon | Numéro d'enregistrement à la taxe sur la consommation | T + 13 chiffres | `jp_tax_registration_number VARCHAR(14)` | [nta.go.jp](https://www.nta.go.jp/english/taxes/consumption_tax/index.htm) |
| Corée du Sud | Numéro d'enregistrement d'entreprise | 10 chiffres (XXX-XX-XXXXX) | `br_number VARCHAR(12)` | [nts.go.kr](https://www.nts.go.kr/english/) |
| Chine | Code de crédit social unifié | 18 caractères alphanumériques | `unified_social_credit_code CHAR(18)` | [gsxt.gov.cn](http://www.gsxt.gov.cn/) |
| Australie | ABN (Australian Business Number) | 11 chiffres | `abn CHAR(11)` | [abr.gov.au](https://www.abr.gov.au/business-super-funds-charities/applying-abn) |
| Canada | Numéro de TPS/TVH (GST/HST) | 9 chiffres + suffixe | `gst_hst_number VARCHAR(15)` | [canada.ca](https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/gst-hst-businesses.html) |

#### 13.3 Identifiants nationaux de personnes physiques

| Pays | Identifiant | Format | Exemple en base de données | Source |
|---|---|---|---|---|
| France | NIR (numéro de sécurité sociale, voir aussi section 6.1) | 13 chiffres + clé | `national_id VARCHAR(15)`, chiffré | [insee.fr](https://www.insee.fr/fr/metadonnees/definition/c1409) |
| Belgique | Numéro de registre national | 11 chiffres | `national_id CHAR(11)`, chiffré | [ibz.rrn.fgov.be](https://www.ibz.rrn.fgov.be/) |
| Allemagne | Steuerliche Identifikationsnummer (Steuer-ID) | 11 chiffres | `tax_id CHAR(11)`, chiffré | [bzst.de](https://www.bzst.de/DE/Privatpersonen/SteuerlicheIdentifikationsnummer/steuerliche_identifikationsnummer_node.html) |
| Espagne | DNI / NIF | 8 chiffres + 1 lettre | `national_id VARCHAR(9)`, chiffré | [policia.es](https://www.policia.es/_es/tramites_dni.php) |
| Italie | Codice Fiscale | 16 caractères alphanumériques | `codice_fiscale CHAR(16)`, chiffré | [agenziaentrate.gov.it](https://www.agenziaentrate.gov.it/) |
| Royaume-Uni | National Insurance Number | 2 lettres + 6 chiffres + 1 lettre | `national_insurance_number VARCHAR(9)`, chiffré | [gov.uk](https://www.gov.uk/national-insurance) |
| États-Unis | Social Security Number (SSN) | NNN-NN-NNNN | `ssn VARCHAR(11)`, chiffré | [ssa.gov](https://www.ssa.gov/number-card) |
| Canada | Numéro d'assurance sociale (NAS) | 9 chiffres | `sin VARCHAR(9)`, chiffré | [canada.ca](https://www.canada.ca/en/employment-social-development/services/sin.html) |
| Suisse | Numéro AVS | 13 chiffres | `avs_number CHAR(13)`, chiffré | [zas.admin.ch](https://www.zas.admin.ch/) |
| Portugal | NIF (Número de Identificação Fiscal) | 9 chiffres | `nif VARCHAR(9)`, chiffré | [portaldasfinancas.gov.pt](https://www.portaldasfinancas.gov.pt/) |
| Pays-Bas | BSN (Burgerservicenummer) | 9 chiffres | `bsn CHAR(9)`, chiffré | [rijksoverheid.nl](https://www.rijksoverheid.nl/onderwerpen/burgerservicenummer-bsn) |
| Irlande | PPS Number | 7 chiffres + 1-2 lettres | `pps_number VARCHAR(9)`, chiffré | [gov.ie](https://www.gov.ie/en/publication/eb228-personal-public-service-pps-number/) |
| Danemark | CPR-nummer | DDMMYY-XXXX (10 chiffres) | `cpr_number VARCHAR(11)`, chiffré | [cpr.dk](https://cpr.dk/) |
| Autriche | Sozialversicherungsnummer | 10 chiffres | `svnr CHAR(10)`, chiffré | [sozialversicherung.at](https://www.sozialversicherung.at/) |
| Australie | TFN (Tax File Number) | 8-9 chiffres | `tfn VARCHAR(9)`, chiffré | [ato.gov.au](https://www.ato.gov.au/individuals-and-families/tax-file-number) |
| Japon | Numéro individuel (My Number) | 12 chiffres | `my_number CHAR(12)`, chiffré | [kojinbango-card.go.jp](https://www.kojinbango-card.go.jp/) |
| Corée du Sud | RRN (Resident Registration Number) | YYMMDD-XXXXXXX (13 chiffres) | `rrn VARCHAR(14)`, chiffré | [mois.go.kr](https://www.mois.go.kr/) |
| Chine | Numéro de carte d'identité de résident | 18 caractères alphanumériques | `resident_id_number CHAR(18)`, chiffré | [mps.gov.cn](https://www.mps.gov.cn/) |

Ces identifiants sont des données à caractère personnel sensibles : en base, ils doivent être chiffrés au repos, jamais loggés en clair, et leur traitement doit être documenté dans le registre RGPD (voir section 8).

#### 13.4 Indicatifs téléphoniques internationaux (complément à E.164, section 4)

| Pays | Indicatif | Exemple E.164 | Source |
|---|---|---|---|
| France | +33 | +33612345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Belgique | +32 | +32470123456 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Suisse | +41 | +41791234567 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Allemagne | +49 | +4915112345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Espagne | +34 | +34612345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Italie | +39 | +393331234567 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Royaume-Uni | +44 | +447911123456 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| États-Unis / Canada | +1 | +12025550123 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Japon | +81 | +819012345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Irlande | +353 | +353871234567 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Portugal | +351 | +351912345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Pays-Bas | +31 | +31612345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Danemark | +45 | +4512345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Australie | +61 | +61412345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Autriche | +43 | +436641234567 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Corée du Sud | +82 | +821012345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |
| Chine | +86 | +8613812345678 | [itu.int](https://www.itu.int/rec/T-REC-E.164/) |

Exemple en base de données : ne pas stocker l'indicatif séparément par défaut — privilégier une colonne unique `phone_number VARCHAR(16)` au format E.164 complet.

#### 13.5 Ordre des éléments d'adresse par pays

L'ordre des champs d'une adresse postale varie fortement d'un pays à l'autre. Il n'existe pas de norme unique codifiant cet ordre pays par pays (l'UPU ne fournit qu'un cadre général) — la colonne Source est donc marquée N/A ici.

| Pays | Ordre typique | Exemple | Source |
|---|---|---|---|
| France | N° + rue, code postal + ville, pays | 12 rue de Rivoli, 75004 Paris, France | N/A |
| États-Unis | N° + rue, ville, abréviation état + ZIP | 350 Fifth Avenue, New York, NY 10118 | N/A |
| Royaume-Uni | N° + rue, ville, code postal | 10 Downing Street, London, SW1A 2AA | N/A |
| Japon | Ordre inversé : pays, préfecture, ville, quartier, N° | 〒100-0001 東京都千代田区... | N/A |
| Allemagne | Rue + N°, code postal + ville | Unter den Linden 1, 10117 Berlin | N/A |
| Belgique | Rue + N°, code postal + ville | Rue de la Loi 16, 1000 Bruxelles | N/A |
| Irlande | N° + rue, ville, comté/Eircode | 10 O'Connell Street, Dublin, D01 F5P2 | N/A |
| Portugal | Rue + N°, code postal + ville | Rua Augusta 100, 1100-053 Lisboa | N/A |
| Pays-Bas | Rue + N°, code postal + ville | Damrak 1, 1012 LG Amsterdam | N/A |
| Italie | Rue + N°, code postal + ville + province | Via Roma 10, 00100 Roma RM | N/A |
| Espagne | Rue + N°, code postal + ville | Calle Mayor 10, 28013 Madrid | N/A |
| Danemark | Rue + N°, code postal + ville | Rådhuspladsen 1, 1550 København | N/A |
| Australie | N° + rue, ville, abréviation état + code postal | 1 Martin Place, Sydney NSW 2000 | N/A |
| Autriche | Rue + N°, code postal + ville | Stephansplatz 1, 1010 Wien | N/A |
| Corée du Sud | Ordre inversé : province/ville, district, rue + N° | 서울특별시 종로구 세종대로 1 | N/A |
| Chine | Ordre inversé : pays, province, ville, district, rue | 北京市东城区... | N/A |
| Canada | N° + rue, ville, abréviation province + code postal | 1 Yonge Street, Toronto ON M5E 1E5 | N/A |

Exemple en base de données : modéliser une table `addresses` avec des colonnes génériques (`line1`, `line2`, `city`, `region`, `postal_code`, `country_code`) plutôt que des colonnes rigides du type `street_number`/`street_name`.

---

## Partie VI — Normes sectorielles et métiers

### 14. Normes pour les produits éditoriaux (livres, périodiques, œuvres)

Cette famille de normes est portée par le comité technique ISO/TC 46. Les sources ci-dessous pointent vers l'agence internationale officielle de chaque standard (plus stable et détaillée que la fiche catalogue ISO, souvent payante).

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 2108 | Norme ISO | ISBN — identifie une édition/un format précis d'un livre | 13 chiffres, ex: 978-2-07-036822-8 | Colonne `isbn CHAR(13)` dans `books` | [isbn-international.org](https://www.isbn-international.org/) |
| ISO 3297 | Norme ISO | ISSN — identifie une publication en série | 8 chiffres, ex: 2049-3630 | Colonne `issn CHAR(9)` dans `periodicals` | [issn.org](https://www.issn.org/) |
| ISO 10957 | Norme ISO | ISMN — identifie une partition musicale imprimée | 13 caractères, préfixe 979-0 | Colonne `ismn CHAR(13)` dans `sheet_music` | [ismn-international.org](https://www.ismn-international.org/) |
| ISO 21047 | Norme ISO | ISTC — identifie l'œuvre textuelle abstraite | 16 caractères | Colonne `istc CHAR(16)` dans `works` | [istc-international.org](https://www.istc-international.org/) *(norme retirée par l'ISO en 2021, agence internationale non active depuis 2017 ; site conservé à titre de référence historique)* |
| ISO 27729 | Norme ISO | ISNI — identifie l'identité publique d'un contributeur | 16 chiffres | Colonne `isni CHAR(16)` dans `authors` | [isni.org](https://isni.org/) |
| ISO 26324 | Norme ISO | DOI — identifie un objet numérique | préfixe/suffixe, ex: 10.1000/182 | Colonne `doi VARCHAR(100)` dans `publications` | [doi.org](https://www.doi.org/) |
| ISO 3901 | Norme ISO | ISRC — identifie un enregistrement sonore ou audiovisuel | 12 caractères | Colonne `isrc CHAR(12)` dans `audiobooks` | [isrc.ifpi.org](https://isrc.ifpi.org/) |

#### 14.1 Encodage code-barres du commerce du livre

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| EAN-13 / GS1 « Bookland » | Norme sectorielle privée (GS1) | Encodage de l'ISBN en code-barres scannable | Code-barres 978-2-07-036822-8 | Colonne `ean13 CHAR(13)` dans `books` | [gs1.org](https://www.gs1.org/standards/id-keys/company-prefix) |

#### 14.2 Métadonnées et classification du secteur du livre

| Nom | Type | Domaine | Exemple | Exemple en base de données | Type MIME | Source |
|---|---|---|---|---|---|---|
| ONIX for Books (EDItEUR) | Norme sectorielle privée (EDItEUR) | Format XML d'échange de métadonnées de livres | fichier XML par titre | Colonne `onix_record XML`/`JSON` dans `book_feeds` | `application/xml` (pas de sous-type ONIX enregistré séparément) | [editeur.org](https://www.editeur.org/8/ONIX/) |
| BISAC Subject Headings | Nomenclature officielle (BISG, États-Unis) | Classification thématique des livres (US) | ex: FIC031000 | Colonne `bisac_code VARCHAR(10)` dans `books` | N/A (code de classification) | [bisg.org](https://www.bisg.org/complete-bisac-subject-headings-list) |
| Thema | Nomenclature officielle (EDItEUR) | Classification thématique internationale du livre | ex: FBA | Colonne `thema_code VARCHAR(10)` dans `books` | N/A (code de classification) | [editeur.org](https://www.editeur.org/151/Thema/) |
| Classification Décimale Dewey (CDD) | Nomenclature officielle (OCLC) | Classification bibliothéconomique généraliste | ex: 823 | Colonne `dewey_code VARCHAR(10)` dans `library_catalog` | N/A (code de classification) | [oclc.org](https://www.oclc.org/en/dewey.html) |
| ISO 2709 (MARC) | Norme ISO | Format d'échange d'enregistrements bibliographiques ; support des déclinaisons MARC 21 et UNIMARC | enregistrement de notice de bibliothèque | Colonne `marc_record TEXT` dans `bibliographic_records`, ou stockage du fichier avec `mime_type` = 'application/marc' | `application/marc` | [iso.org](https://www.iso.org/search.html?q=2709) |
| ISO 15836 (Dublin Core) | Norme ISO | Jeu d'éléments de métadonnées descriptives, 15 champs (titre, créateur, sujet, date, droits…) | `dc:title`, `dc:creator`, `dc:rights` | Colonnes `dc_title`, `dc_creator`, `dc_rights` dans `resources`, ou table `resource_metadata (element, value)` | N/A (vocabulaire de métadonnées, pas un type de fichier) | [dublincore.org](https://www.dublincore.org/specifications/dublin-core/dces/) |
| Library of Congress Classification (LCC) | Nomenclature officielle (Library of Congress) | Classification bibliothéconomique nord-américaine | ex: PS3557 | Colonne `lcc_code VARCHAR(15)` dans `library_catalog` | N/A (code de classification) | [loc.gov](https://www.loc.gov/catdir/cpso/lcco/) |
| CDU (Classification Décimale Universelle) | Nomenclature officielle (UDC Consortium) | Classification bibliothéconomique internationale | ex: 821.111 | Colonne `udc_code VARCHAR(15)` dans `library_catalog` | N/A (code de classification) | [udcc.org](https://www.udcc.org/) |

### 15. Normes et identifiants pour les matières dangereuses

Ce domaine combine des réglementations de transport (ONU, Europe) et des réglementations de mise sur le marché des produits chimiques.

#### 15.1 Identification et classification

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Numéro ONU / UN Number | Registre / code officiel (ONU) | Identifiant à 4 chiffres, défini par les Recommandations ONU (Orange Book) | UN1203 (essence) | Colonne `un_number CHAR(4)` dans `hazardous_materials` | [unece.org](https://unece.org/transport/dangerous-goods) |
| Classes de danger ONU (1 à 9) | Nomenclature officielle (ONU) | Classification par type de danger | Classe 3 = liquides inflammables | Colonne `un_hazard_class VARCHAR(4)` | [unece.org](https://unece.org/transport/dangerous-goods) |
| Groupe d'emballage (Packing Group) | Nomenclature officielle (ONU) | Niveau de danger au sein d'une classe | I, II, III | Colonne `packing_group CHAR(3)` | [unece.org](https://unece.org/transport/dangerous-goods) |
| Code Kemler (Hazard Identification Number) | Nomenclature officielle (UNECE) | Code de danger affiché sur les panneaux orange (transport routier européen) | 33/1203 | Colonne `kemler_code VARCHAR(4)` | [unece.org](https://unece.org/transport/dangerous-goods) |
| Numéro CAS (Chemical Abstracts Service) | Registre / code officiel (CAS) | Identifiant unique et universel d'une substance chimique | 64-17-5 (éthanol) | Colonne `cas_number VARCHAR(12)` dans `chemical_substances` | [cas.org](https://www.cas.org/cas-data/cas-registry) |
| Numéro CE / EINECS | Registre / code officiel (Union européenne, ECHA) | Identifiant européen des substances chimiques commercialisées dans l'UE | 200-578-6 (éthanol) | Colonne `ec_number VARCHAR(10)` dans `chemical_substances` | [echa.europa.eu](https://echa.europa.eu/information-on-chemicals/ec-inventory) |

#### 15.2 Réglementations de transport par mode

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ADR | Accord international (ONU/UNECE) | Transport routier international des marchandises dangereuses (Europe) | classification, emballage, étiquetage routier | Colonnes `adr_compliant BOOLEAN` + `adr_class VARCHAR(4)` dans `shipments` | [unece.org](https://unece.org/transport/dangerous-goods) |
| RID | Accord international (OTIF) | Transport ferroviaire international des marchandises dangereuses | équivalent ferroviaire de l'ADR | Colonne `rid_class VARCHAR(4)` dans `shipments` | [otif.org](https://otif.org/en/) |
| IMDG Code | Code international (OMI) | Transport maritime international des marchandises dangereuses (OMI) | classification et arrimage en conteneur | Colonne `imdg_class VARCHAR(4)` dans `shipments` | [imo.org](https://www.imo.org/en/OurWork/Safety/Pages/DangerousGoods-default.aspx) |
| IATA DGR / Instructions Techniques OACI | Référentiel privé (IATA) ; Norme intergouvernementale (OACI) | Transport aérien des marchandises dangereuses | limites de quantité selon le type d'aéronef | Colonne `iata_dgr_class VARCHAR(4)` dans `shipments` | [iata.org](https://www.iata.org/en/publications/dgr/) / [icao.int](https://www.icao.int/safety/dangerousgoods/pages/technical-instructions.aspx) |
| ADN | Accord international (ONU/UNECE) | Transport par voies navigables intérieures des marchandises dangereuses (Europe) | équivalent fluvial de l'ADR | Colonne `adn_class VARCHAR(4)` dans `shipments` | [unece.org](https://unece.org/transport/dangerous-goods) |

#### 15.3 Étiquetage et communication du danger

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| SGH / GHS (Système Général Harmonisé) | Norme intergouvernementale (ONU) | Système ONU de classification et d'étiquetage des produits chimiques | 9 pictogrammes de danger | Colonne `ghs_pictogram_codes VARCHAR(50)` dans `chemical_substances` | [unece.org](https://unece.org/transport/dangerous-goods) |
| Règlement CLP (UE) n°1272/2008 | Réglementation (UE) | Transposition européenne du SGH | mentions de danger (H), conseils de prudence (P) | Colonnes `h_phrases TEXT[]`, `p_phrases TEXT[]` | [echa.europa.eu](https://echa.europa.eu/regulations/clp/understanding-clp) |
| NFPA 704 | Norme sectorielle privée (NFPA, États-Unis) | Système américain du « losange du feu » | losange à 4 couleurs, échelle 0-4 | Colonnes `nfpa_health TINYINT`, `nfpa_flammability TINYINT` | [nfpa.org](https://www.nfpa.org/codes-and-standards/nfpa-704-standard-development/704) |
| ISO 11014 | Norme ISO | Structure normalisée des fiches de données de sécurité (FDS/SDS) en 16 rubriques | FDS au format PDF en 16 sections | Colonne `sds_document_id` (FK vers `documents`) | [iso.org](https://www.iso.org/search.html?q=11014) |

#### 15.4 Réglementations chimiques

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| REACH (UE) n°1907/2006 | Réglementation (UE) | Enregistrement, évaluation et autorisation des substances chimiques dans l'UE | numéro d'enregistrement REACH | Colonne `reach_registration_number VARCHAR(20)` | [echa.europa.eu](https://echa.europa.eu/regulations/reach/registration) |
| IUCLID | Outil / format officiel (ECHA) | Format/base de données standardisé pour la documentation des substances chimiques | fichier d'export IUCLID (i6z) | N/A (format d'échange de dossier réglementaire) | [iuclid6.echa.europa.eu](https://iuclid6.echa.europa.eu/) |

#### 15.5 Déchets dangereux

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Code déchet européen (LoW / EWC) | Réglementation (UE) | Classification européenne des déchets, déchets dangereux marqués d'un astérisque | 13 02 05* (huiles moteur usagées) | Colonne `waste_code VARCHAR(10)` dans `waste_records` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02000D0532-20150601) |

### 16. Logistique, entrepôt et manutention (convoyeurs, dépôts, articles)

Ce domaine couvre l'identification des articles et unités logistiques, les équipements de manutention (convoyeurs, rayonnages), les échanges de documents et les unités de mesure du commerce. La plupart des identifiants du quotidien (code-barres d'un article, code d'une palette, code d'un site logistique) viennent du système GS1, une organisation privée à but non lucratif dont les standards sont devenus la référence de facto mondiale (bien au-delà des seules normes ISO).

#### 16.1 Identification GS1 des articles et unités logistiques

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| GTIN (Global Trade Item Number) | Norme sectorielle privée (GS1) | Identifiant unique d'un article/produit (le « code-barres » d'un SKU) | 14 chiffres, encodé en EAN-13/UPC selon la longueur | Colonne `gtin CHAR(14)` dans une table `articles` | [gs1.org](https://www.gs1.org/standards) |
| SSCC (Serial Shipping Container Code) | Norme sectorielle privée (GS1) | Identifiant unique d'une unité logistique (palette, colis d'expédition) | 18 chiffres | Colonne `sscc CHAR(18)` dans une table `logistic_units` | [gs1.org](https://www.gs1.org/standards/id-keys/sscc) |
| GLN (Global Location Number) | Norme sectorielle privée (GS1) | Identifiant unique d'un lieu physique ou légal (dépôt, quai, site client) | 13 chiffres | Colonne `gln CHAR(13)` dans une table `locations` | [gs1.org](https://www.gs1.org/standards) |
| GS1-128 | Norme sectorielle privée (GS1) | Code-barres encodant des informations logistiques variables (lot, DLC, poids, quantité) via des identifiants de données (AI) | (01)GTIN(10)LOT(17)DLC | N/A directement (symbologie) ; les données encodées vont dans `batch_number`, `expiry_date DATE`, `net_weight DECIMAL` sur `logistic_units` | [gs1.org](https://www.gs1.org/standards) |
| EPC (Electronic Product Code) / RFID | Norme sectorielle privée (GS1/EPCglobal) | Identification par radiofréquence des articles ou unités logistiques (norme GS1/EPCglobal) | code encodé sur puce RFID | Colonne `epc_code VARCHAR(24)` dans `articles` ou `rfid_tags` | [gs1.org](https://www.gs1.org/standards) |
| GPC (Global Product Classification) | Norme sectorielle privée (GS1) | Classification hiérarchique des articles par catégorie de produit | code « brick » à 8 chiffres | Colonne `gpc_brick_code CHAR(8)` dans `articles` | [gs1.org](https://www.gs1.org/standards/gpc) |

#### 16.2 Classification des articles pour les achats

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| UNSPSC (United Nations Standard Products and Services Code) | Nomenclature officielle (UNGM/GS1 US) | Classification internationale des produits et services, très utilisée en achats/procurement | code à 8 chiffres | Colonne `unspsc_code CHAR(8)` dans `articles` | [ungm.org](https://www.ungm.org/Public/UNSPSC) |

#### 16.3 Codes-barres et symbologies

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO/IEC 15417 | Norme ISO/CEI | Symbologie du code-barres Code 128 | code-barres linéaire haute densité | N/A (symbologie ; le contenu encodé va dans `gtin`/`sscc`) | [iso.org](https://www.iso.org/search.html?q=15417) |
| ISO/IEC 16388 | Norme ISO/CEI | Symbologie du code-barres Code 39 | code-barres linéaire alphanumérique | N/A (symbologie) | [iso.org](https://www.iso.org/search.html?q=16388) |
| ISO/IEC 16022 | Norme ISO/CEI | Symbologie du code matriciel Data Matrix | souvent utilisé sur petits articles (dispositifs médicaux) | N/A (symbologie) | [iso.org](https://www.iso.org/search.html?q=16022) |
| ISO/IEC 18004 | Norme ISO/CEI | Symbologie du QR Code | peut encoder une URL de traçabilité article | Colonne `traceability_url VARCHAR(255)` dans `articles`, encodée en QR Code sur l'étiquette | [iso.org](https://www.iso.org/search.html?q=18004) |
| ISO/IEC 18000 | Norme ISO/CEI | Communication RFID pour la gestion d'objets (item management) | fréquences et protocoles RFID (dont EPC Gen2) | N/A (norme de communication radio) | [iso.org](https://www.iso.org/search.html?q=18000) |

#### 16.4 Palettes et unités de charge

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 6780 | Norme ISO | Dimensions et tolérances des palettes plates pour la manutention | palette 1200x1000mm, 1200x800mm | Colonne `pallet_type VARCHAR(20)` dans `logistic_units` | [iso.org](https://www.iso.org/search.html?q=6780) |
| EPAL / EUR-pallet | Norme sectorielle privée (EPAL) | Norme européenne de la palette EUR (échangeable, poolée), gérée par l'association EPAL | palette 800x1200mm | Colonnes `pallet_type` = 'EUR' + `epal_license_number VARCHAR(20)` dans `logistic_units` | [epal-pallets.org](https://www.epal-pallets.org/) |
| ISO 3676 | Norme ISO | Dimensions des colis rectangulaires rigides pour le transport | dimensions normalisées de colis | Colonne `package_dimensions VARCHAR(20)` (L x l x H) dans `packages` | [iso.org](https://www.iso.org/search.html?q=3676) |

#### 16.5 Sécurité des convoyeurs et équipements de manutention continue

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| EN 619 | Norme CEN (EN) | Sécurité des convoyeurs et équipements associés pour charges unitaires (colis, palettes) | dispositifs d'arrêt d'urgence, protections | N/A directement ; motive une table `equipment_inspections` (`equipment_id`, `standard_reference`, `inspection_date`, `compliant BOOLEAN`) | [cencenelec.eu](https://www.cencenelec.eu/) |
| EN 620 | Norme CEN (EN) | Sécurité des convoyeurs à bande fixes pour produits en vrac | convoyeurs de vrac (céréales, minerais) | N/A directement, voir `equipment_inspections` | [cencenelec.eu](https://www.cencenelec.eu/) |
| EN 618 | Norme CEN (EN) | Prescriptions de sécurité pour équipements de manutention mécanique continue de produits en vrac (hors convoyeurs à bande) | godets, vis sans fin | N/A directement, voir `equipment_inspections` | [cencenelec.eu](https://www.cencenelec.eu/) |
| ISO 5048 | Norme ISO | Convoyeurs à bande — calcul de la puissance motrice et des tensions | dimensionnement technique | N/A (norme de calcul technique) | [iso.org](https://www.iso.org/search.html?q=5048) |
| ISO 1819 | Norme ISO | Code de sécurité pour les équipements de manutention mécanique continue | recommandations générales de sécurité | N/A (norme de sécurité) | [iso.org](https://www.iso.org/search.html?q=1819) |
| ISO 12100 | Norme ISO | Sécurité des machines — principes généraux de conception (appréciation et réduction du risque) | analyse de risque machine | N/A directement, motive un registre `risk_assessments` | [iso.org](https://www.iso.org/search.html?q=12100) |

#### 16.6 Systèmes de stockage et rayonnages

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| EN 15512 | Norme CEN (EN) | Rayonnages métalliques statiques — palettiers réglables, principes de conception structurelle | calcul de charge admissible d'un palettier | N/A (norme de conception structurelle) | [cencenelec.eu](https://www.cencenelec.eu/) |
| EN 15635 | Norme CEN (EN) | Rayonnages métalliques statiques — utilisation et maintenance (inspections de sécurité) | inspection annuelle des racks, fiches de dommages | Table `racking_inspections` (`rack_id`, `inspection_date`, `damage_level`, `standard_reference` = 'EN 15635') | [cencenelec.eu](https://www.cencenelec.eu/) |
| FEM 9.831 et série FEM 9.xxx | Référentiel privé (FEM) | Recommandations techniques de la Fédération Européenne de la Manutention pour le stockage et la manutention | recommandations de conception et d'exploitation | N/A directement | [fem-eur.com](https://www.fem-eur.com/) |

#### 16.7 Échanges de documents logistiques (EDI)

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| UN/EDIFACT | Norme UN/CEFACT | Format normalisé d'échange électronique de documents commerciaux et logistiques | messages DESADV (avis d'expédition), ORDERS (commande), INVOIC (facture) | N/A (format de message EDI) ; le contenu alimente `shipments`, `purchase_orders`, `invoices` | [unece.org](https://unece.org/trade/uncefact) |

#### 16.8 Unités de mesure et incoterms du commerce international

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| UN/CEFACT Recommandation 20 | Norme UN/CEFACT | Codes à 3 caractères pour les unités de mesure utilisées dans le commerce international | KGM (kilogramme), EA (unité), MTR (mètre) | Colonne `unit_of_measure_code CHAR(3)` dans `articles` ou `order_lines` | [unece.org](https://unece.org/trade/uncefact/cl-recommendations) |
| Incoterms (ICC) | Référentiel privé (Chambre de Commerce Internationale) | Règles internationales définissant la répartition des coûts et risques de transport entre vendeur et acheteur | EXW, FOB, CIF, DAP | Colonne `incoterm CHAR(3)` dans `shipments` ou `purchase_orders` | [iccwbo.org](https://www.iccwbo.org/business-solutions/incoterms-rules/) |

#### 16.9 Marquage et vocabulaire de l'emballage

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 780 | Norme ISO | Pictogrammes de manutention des marchandises apposés sur l'emballage | fragile, haut/bas, craint l'humidité | N/A (marquage physique de l'emballage) | [iso.org](https://www.iso.org/search.html?q=780) |
| ISO 21067 | Norme ISO | Vocabulaire normalisé de l'emballage et de la logistique associée | définitions communes (unité de vente, unité logistique...) | N/A (norme de vocabulaire) | [iso.org](https://www.iso.org/search.html?q=21067) |

### 17. Produits frais, agroalimentaire et sécurité sanitaire des aliments

Ce domaine combine des systèmes de management de la sécurité alimentaire, des obligations réglementaires d'étiquetage et de traçabilité, et des standards spécifiques à la chaîne du froid et aux produits frais (fruits, légumes, produits d'origine animale).

#### 17.1 Systèmes de management de la sécurité alimentaire

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO 22000 | Norme ISO | Système de management de la sécurité des denrées alimentaires, applicable à toute la chaîne alimentaire | certification d'un site de production | N/A directement (système de management) ; motive une table `food_safety_certifications` (`site_id`, `certification`, `valid_until`) | [iso.org](https://www.iso.org/standard/65464.html) |
| HACCP (Codex Alimentarius, CXC 1-1969) | Norme intergouvernementale (Codex Alimentarius, FAO/OMS) | Méthode d'analyse des dangers et maîtrise des points critiques, base réglementaire mondiale de l'hygiène alimentaire | 7 principes HACCP | N/A directement ; motive une table `haccp_control_points` (`process_step`, `hazard_type`, `critical_limit`, `monitoring_frequency`) | [fao.org](https://www.fao.org/fao-who-codexalimentarius/en/) |
| IFS Food | Certification privée (IFS) | Référentiel privé d'audit de sécurité alimentaire pour les fournisseurs de la distribution (surtout Europe) | certification de site fournisseur | Colonnes `certification_scheme VARCHAR(20)`, `certificate_number`, `expiry_date DATE` dans `supplier_certifications` | [ifs-certification.com](https://www.ifs-certification.com/) |
| BRCGS (British Retail Consortium Global Standards) | Certification privée (BRC Global Standards) | Référentiel privé d'audit de sécurité alimentaire, très utilisé au Royaume-Uni et à l'international | certification de site fournisseur | Voir `supplier_certifications` ci-dessus | [brcgs.com](https://www.brcgs.com/) |
| FSSC 22000 | Certification privée (FSSC/GFSI) | Certification combinant ISO 22000 et des exigences sectorielles complémentaires, reconnue par la Global Food Safety Initiative (GFSI) | certification de site fournisseur | Voir `supplier_certifications` ci-dessus | [fssc.com](https://www.fssc.com/) |

#### 17.2 Étiquetage et information du consommateur

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Règlement (UE) n°1169/2011 (FIC) | Réglementation (UE) | Information du consommateur sur les denrées alimentaires : ingrédients, valeurs nutritionnelles, allergènes | étiquette nutritionnelle obligatoire | Colonnes `nutrition_facts JSON`, `allergens TEXT[]` dans `articles` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011R1169-20180101) |
| Liste des 14 allergènes majeurs (Annexe II du règlement 1169/2011) | Réglementation (UE) | Allergènes à déclaration obligatoire | gluten, crustacés, œufs, poissons, arachides, soja, lait, fruits à coque, céleri, moutarde, sésame, sulfites, lupin, mollusques | Colonne `allergens TEXT[]` (valeurs contrôlées) dans `articles` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011R1169-20180101) |
| DLC / DDM | Réglementation (UE) | Date Limite de Consommation (denrées périssables, sécurité) vs Date de Durabilité Minimale (qualité, ex-DLUO) | « à consommer jusqu'au » vs « à consommer de préférence avant le » | Colonnes `use_by_date DATE` (DLC) et `best_before_date DATE` (DDM) dans `batches` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02011R1169-20180101) |
| Nutri-Score | Label / signe officiel (France/Europe, facultatif) | Logo nutritionnel facultatif à 5 niveaux (A à E), apposé en face avant d'emballage | lettre + couleur de A (vert) à E (rouge) | Colonne `nutriscore CHAR(1)` dans `articles` | [nutriscore.blog](https://www.nutriscore.blog/) |

#### 17.3 Traçabilité et échange de données produits

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Règlement (CE) n°178/2002 (General Food Law) | Réglementation (UE) | Cadre général de la législation alimentaire européenne, impose la traçabilité « un cran amont / un cran aval » | obligation de retrait/rappel en cas de danger | N/A directement (cadre réglementaire) ; motive une table `batch_traceability` (`batch_id`, `supplier_batch_id`, `received_from`, `shipped_to`) | [food.ec.europa.eu](https://food.ec.europa.eu/horizontal-topics/general-food-law_en) |
| GDSN (Global Data Synchronisation Network, GS1) | Organisme / réseau (GS1) | Réseau mondial de synchronisation des fiches produits entre fournisseurs et distributeurs | fiche produit (poids, dimensions, allergènes) partagée automatiquement | N/A directement (réseau d'échange) ; alimente `articles` via des colonnes `source_gln`, `gdsn_last_sync TIMESTAMP` | [gs1.org](https://www.gs1.org/standards/gdsn) |

#### 17.4 Chaîne du froid et transport de denrées périssables

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ATP (Accord relatif aux transports internationaux de denrées périssables) | Accord international (ONU/UNECE) | Classification des engins de transport frigorifique et conditions de température pour le transport international | classes FRC, FNA, FRA, FRB, RRC... | Colonne `atp_equipment_class VARCHAR(4)` dans `vehicles` ou `logistic_units` | [unece.org](https://unece.org/transport) |
| Règlement (CE) n°853/2004 | Réglementation (UE) | Règles d'hygiène pour les denrées d'origine animale, dont l'estampille sanitaire (marque de salubrité) | marque ovale sur les produits carnés/laitiers/poissons | Colonne `health_mark_number VARCHAR(20)` dans `establishments` | [food.ec.europa.eu](https://food.ec.europa.eu/food-safety/biological-safety/food-hygiene_en) |
| EN 12830 | Norme CEN (EN) | Enregistreurs de température pour le transport, l'entreposage et la distribution de denrées réfrigérées, congelées, surgelées | sonde de température embarquée sur camion frigorifique | N/A directement ; motive une table `temperature_logs` (`sensor_id`, `recorded_at`, `temperature_celsius`) | [cencenelec.eu](https://www.cencenelec.eu/) |

#### 17.5 Codes produits frais (fruits et légumes)

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| PLU Codes (IFPS) | Norme sectorielle privée (IFPS) | Codes à 4-5 chiffres apposés sur les étiquettes de fruits et légumes vendus en vrac | 4011 (banane conventionnelle), 94011 (banane bio) | Colonne `plu_code VARCHAR(5)` dans `articles` | [ifpsglobal.com](https://ifpsglobal.com/plu-codes/) |

#### 17.6 Signes de qualité et origine

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| AOC / AOP, IGP, STG, Label Rouge (France, gérés par l'INAO) | Label / signe officiel (France, INAO) | Signes officiels de la qualité et de l'origine, protègent une dénomination liée à un terroir ou un savoir-faire | Comté AOP, volaille de Bresse AOP, Label Rouge | Colonnes `quality_label VARCHAR(20)`, `label_registration_number VARCHAR(30)` dans `articles` | [inao.gouv.fr](https://www.inao.gouv.fr/) |
| Label bio européen (Eurofeuille) + label AB (France) | Label / signe officiel (UE/France) | Certification agriculture biologique | logo feuille étoilée UE, logo « AB » français | Colonne `quality_label` = 'AB' ou 'EU-BIO' dans `articles` | [agriculture.gouv.fr](https://agriculture.gouv.fr/quest-ce-que-lagriculture-biologique) |
| Registre eAmbrosia (Commission européenne) | Registre / code officiel (Commission européenne) | Registre officiel des indications géographiques et appellations protégées au niveau UE | recherche d'une AOP/IGP par pays ou produit | Colonne `eu_gi_register_id VARCHAR(20)` dans `articles` | [ec.europa.eu](https://ec.europa.eu/agriculture/eambrosia/geographical-indications-register/) |

### 18. Économie circulaire et responsabilité élargie du producteur (REP, écocontribution)

L'écocontribution ne repose pas sur une norme ISO/CEN mais sur un dispositif **réglementaire** européen et national (directives/règlements UE transposés en droit français), complété par quelques normes techniques ponctuelles (ex: EN 13432 pour la compostabilité).

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Directive-cadre 2008/98/CE (déchets), art. 8 | Réglementation (UE) | Fondement européen de la responsabilité élargie du producteur (REP) | oblige les producteurs à prendre en charge le cycle de vie de leurs produits | N/A (directive-cadre) | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32008L0098) |
| Code de l'environnement, art. L541-10 (France) | Loi / Décret (France) | Transposition française de la REP, liste les filières soumises à écocontribution | plus de 20 filières : emballages, DEEE, textiles, meubles, piles, pneus, médicaments... | N/A (cadre légal) ; motive une colonne `rep_channel VARCHAR(30)` dans `products` (ex: 'emballages', 'DEEE') | [ecologie.gouv.fr](https://www.ecologie.gouv.fr/) |
| Éco-organismes agréés (Citeo, Ecologic, Ecomaison, Corepile...) | Organisme / réseau (agréé par l'État) | Organismes privés à but non lucratif, financés par l'écocontribution, chargés de la collecte/recyclage pour le compte des producteurs | Citeo (emballages et papiers) | Colonne `eco_contribution_amount DECIMAL(10,2)` dans `products`, calculée selon le barème publié par l'éco-organisme concerné | [citeo.com](https://www.citeo.com/) |
| Logo Triman | Marquage réglementaire (France) | Pictogramme obligatoire en France signalant qu'un produit relève d'une consigne de tri | apposé sur l'emballage, l'étiquette, ou à défaut sur le point de vente/dématérialisé | Colonne `triman_required BOOLEAN` dans `products` | [triman.ecologie.gouv.fr](https://triman.ecologie.gouv.fr/) |
| Directive 2012/19/UE (WEEE / DEEE) | Réglementation (UE) | Filière REP des déchets d'équipements électriques et électroniques | 6 catégories d'équipements (écrans, gros électroménager, petit électroménager...) | Colonne `weee_category TINYINT` dans `products` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32012L0019) |
| Règlement (UE) 2025/40 (PPWR — emballages et déchets d'emballages) | Réglementation (UE) | Remplace la directive 94/62/CE ; exigences de recyclabilité et de taux de matière recyclée des emballages, applicable dans toute l'UE depuis le 12 août 2026 | taux minimal de matière recyclée incorporée, obligation de recyclabilité à l'horizon 2030 | Colonne `packaging_recyclability_pct DECIMAL(5,2)` dans `products` | [eur-lex.europa.eu](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32025R0040) |
| EN 13432 | Norme CEN (EN) | Norme européenne (CEN) définissant les critères de compostabilité des emballages (désintégration, biodégradation, écotoxicité) | mention « compostable » ou « OK compost » sur un emballage | Colonne `packaging_compostable BOOLEAN` dans `products` | [cencenelec.eu](https://www.cencenelec.eu/) |

### 19. Articles de sport et équipements sportifs

La plupart des équipements sportifs relèvent d'un comité technique ISO dédié, complété par des normes européennes de sécurité et, pour les équipements de protection, par un règlement européen transversal. Certains référentiels rencontrés dans le secteur (ex: FIFA Quality Programme pour les ballons) sont des **certifications privées**, pas des normes officielles — à signaler comme tel si utilisées dans un projet.

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| ISO/TC 83 (comité technique) | Comité technique (ISO) | Comité ISO « Sports and other recreational facilities and equipment », chapeaute la plupart des normes ISO d'équipements sportifs et de loisirs | normes ISO 5355, ISO 9523, etc. (voir lignes ci-dessous) | N/A (comité technique, pas une norme en soi) | [iso.org](https://www.iso.org/search.html?q=ISO%2FTC%2083) |
| ISO 5355 | Norme ISO | Chaussures de ski alpin — exigences dimensionnelles et de sécurité pour l'interface avec la fixation | pointure et géométrie de semelle normalisées | Colonne `boot_sole_standard VARCHAR(10)` = 'ISO 5355' dans `articles` (catégorie ski) | [iso.org](https://www.iso.org/search.html?q=ISO+5355) |
| ISO 9523 | Norme ISO | Chaussures de ski de randonnée/tourisme — exigences dimensionnelles pour l'interface avec la fixation | pivot situé à l'interface chaussure/fixation | Colonne `boot_sole_standard VARCHAR(10)` = 'ISO 9523' dans `articles` | [iso.org](https://www.iso.org/search.html?q=ISO+9523) |
| EN 1078 / EN 1080 | Norme CEN (EN) | Casques pour cyclistes et utilisateurs de patins/planches à roulettes (EN 1078), casques pour enfants en bas âge (EN 1080) | casque de vélo homologué CE | Colonne `safety_standard VARCHAR(20)` = 'EN 1078' dans `articles` | [cencenelec.eu](https://www.cencenelec.eu/) |
| EN 1176 / EN 1177 | Norme CEN (EN) | Équipements d'aires de jeux (EN 1176) et surfaces d'amortissement associées (EN 1177) — relèvent aussi d'ISO/TC 83 | structures de jeux, sols amortissants | N/A directement ; motive une table `equipment_inspections` (voir section 16.5) | [cencenelec.eu](https://www.cencenelec.eu/) |
| Règlement (UE) 2016/425 (EPI / PPE) | Réglementation (UE) | Cadre européen des équipements de protection individuelle, applicable aux protections sportives (casques, protège-tibias homologués...) | catégories de risque I, II, III selon la gravité du risque couvert | Colonne `ppe_category VARCHAR(5)` dans `articles` | [single-market-economy.ec.europa.eu](https://single-market-economy.ec.europa.eu/sectors/mechanical-engineering/personal-protective-equipment_en) |
| Laws of the Game (IFAB) / FIFA Quality Programme | Système propriétaire non normalisé | **Non normatif** — spécifications privées du ballon de football (circonférence 68-70 cm, masse 410-450 g) et certification qualité FIFA pour les compétitions officielles | ballon labellisé « FIFA Quality Pro » | N/A (spécification/certification privée, pas une norme ISO/CEN) | [theifab.com](https://www.theifab.com/) |

### 20. Commerces alimentaires de proximité (boulangerie, boucherie, artisanat alimentaire)

Ce type de commerce combine des obligations d'hygiène alimentaire déjà couvertes en section 17, une classification d'activité déjà couverte en section 6.1, et quelques dispositifs réglementaires propres au commerce artisanal de détail (appellations protégées, qualification professionnelle, codes-barres à usage interne).

| Nom | Type | Domaine | Exemple | Exemple en base de données | Source |
|---|---|---|---|---|---|
| Code de la consommation, art. L122-18 (ex-décrets de 1993 et 1997 sur le pain) | Loi / Décret (France) | Réserve l'appellation « boulangerie »/« boulanger » aux professionnels qui sélectionnent leurs farines, pétrissent et cuisent leurs pains sur le lieu de vente ; définit le « pain de tradition française » | enseigne « Boulangerie » vs. simple point de vente de pain surgelé recuit | Colonne `trade_appellation VARCHAR(30)` = 'boulangerie' dans `establishments`, avec justificatif | [legifrance.gouv.fr](https://www.legifrance.gouv.fr/) |
| Répertoire des Métiers (RM) | Registre / code officiel (Chambres de Métiers et de l'Artisanat, France) | Immatriculation obligatoire des artisans (production, transformation, réparation, service) auprès de la Chambre de Métiers et de l'Artisanat | boulanger, boucher, charcutier, pâtissier inscrits au RM | Colonne `rm_number VARCHAR(20)` dans `establishments` | [artisanat.fr](https://www.artisanat.fr/) |
| Titre de « Maître Artisan » | Qualification réglementée (France) | Qualification supérieure délivrée par la Chambre de Métiers et de l'Artisanat (brevet de maîtrise ou ancienneté) | « Maître Artisan Boucher » affiché en vitrine | Colonne `professional_title VARCHAR(30)` dans `establishments` | [artisanat.fr](https://www.artisanat.fr/) |
| Titre d'« artisan » réglementé | Qualification réglementée (France) | Réservé aux détenteurs d'un diplôme de niveau 3 dans le métier ou de 3 ans d'expérience professionnelle ; usage abusif sanctionné (amende) | mention « Artisan Boulanger » sur l'enseigne | N/A (titre réglementé, pas un identifiant en base) | [artisanat.fr](https://www.artisanat.fr/) |
| Règlements (CE) 852/2004 et 853/2004, HACCP | Réglementation (UE) | Hygiène alimentaire générale et spécifique aux produits carnés/laitiers (boucherie, charcuterie) — voir aussi section 17.1 et 17.4 | plan de maîtrise sanitaire, marque de salubrité | Voir section 17 pour le détail des colonnes | voir section 17 |
| Codes EAN-13 à usage interne (préfixes GS1 020-029) | Norme sectorielle privée (GS1) | Codes-barres à circulation restreinte pour les produits pesés en magasin (pain, viande, pâtisserie), encodant prix ou poids | étiquette-balance générant un EAN-13 commençant par « 02 » | Colonne `internal_barcode VARCHAR(13)` dans `articles`, distincte du GTIN GS1 standard (voir section 16.1) | [gs1.org](https://www.gs1.org/standards) |
| PLU codes (IFPS) | Norme sectorielle privée (IFPS) | Pour les fruits et légumes vendus en boulangerie/épicerie de proximité — voir section 17.5 | 4011 (banane conventionnelle) | Voir section 17.5 | voir section 17.5 |

---

*Cette liste couvre les standards les plus fréquemment rencontrés dans des projets logiciels, data et internationaux. Selon le secteur (santé, finance, industrie...), des normes sectorielles supplémentaires peuvent s'appliquer (ex: HL7/FHIR pour la santé, ISO 20022 déjà cité pour la finance, ISO 26262 pour l'automobile). Les formats locaux par pays (section 13) et certaines réglementations de matières dangereuses (section 15) doivent être vérifiés auprès de la source officielle avant mise en production, ces formats et ces pages pouvant évoluer.*
