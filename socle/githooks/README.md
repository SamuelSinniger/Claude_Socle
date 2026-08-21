# Git hooks du projet

Ces hooks sont versionnés (contrairement à `.git/hooks/`). Ils ne sont pas actifs
tant qu'on ne pointe pas git dessus — à faire une fois par clone :

```bash
git config core.hooksPath .githooks
```

## post-commit

Après chaque commit, mesure l'ampleur du changement. Si c'est un « gros changement »,
il déclenche l'agent [`doc-updater`](../.claude/agents/doc-updater.md) qui met à jour
la documentation. Les modifications sont laissées dans le working tree : rien n'est
commité automatiquement, on relit avec `git diff`.

### Ce qui compte comme « gros changement »

Au moins une de ces conditions :

| Condition | Seuil par défaut | Réglage |
| --- | --- | --- |
| Lignes ajoutées + supprimées | 80 | `git config docupdater.lines 120` |
| Fichiers de code modifiés | 5 | `git config docupdater.files 3` |
| Un fichier structurel touché | — | `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Dockerfile`, `docker-compose.yml`, `.env.example`, `Makefile`, `openapi.yaml`, `schema.sql`/`.prisma`/`.graphql`, lockfiles… |

Le hook s'abstient quand : le commit ne touche que de la documentation, c'est un merge,
le sujet commence par `docs:`, ou le message contient `[skip-docs]`.

### Réglages

```bash
git config docupdater.lines 120
```

```bash
git config docupdater.files 3
```

```bash
git config docupdater.cli /chemin/vers/claude
```

```bash
git config docupdater.model sonnet
```

Couper temporairement pour un commit :

```bash
DOC_UPDATER=off git commit -m "wip"
```

### Prérequis

Le hook appelle le **CLI Claude Code** en mode headless (`claude -p … --permission-mode
acceptEdits`). S'il ne trouve pas de binaire `claude`, il ne bloque rien : il note le
commit dans `.claude/doc-updates-pending.log`, et il suffit de lancer `/update-docs`
dans Claude Code pour traiter la file.

Installer le CLI :

```bash
npm install -g @anthropic-ai/claude-code
```

### Journal

- `.claude/doc-updater.log` — sortie des exécutions
- `.claude/doc-updates-pending.log` — commits en attente de traitement manuel
