---
name: agent-os-bootstrap
description: Install, repair, or sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee for Grok CLI and OpenCode. Use on install, drift, /agent-os-bootstrap, or missing AGENTS.md.
---

# Agent OS Bootstrap / Sync

## Harness

**Grok Build + OpenCode.** Same root `AGENTS.md`. OpenCode auth: `opencode-antigravity-auth`.

## Project skill/command layout (source of truth)

| Path                              | Role                                                    |
| --------------------------------- | ------------------------------------------------------- |
| `.agents/skills/`                 | Project-specific skills (this folder)                   |
| `.agents/commands/`               | Workflow command templates (git-tracked)                |
| `.agents/vendor/agent-skills/`    | Shared craft pack (**git submodule**)                   |
| `.opencode/skills`                | Symlink → `.agents/skills`                              |
| `.opencode/command`               | Symlink → `.agents/commands`                            |
| `opencode.jsonc` → `skills.paths` | `.agents/skills` + `.agents/vendor/agent-skills/skills` |

Craft pack is **not** copied into `skills/`. Update with `git submodule update --remote .agents/vendor/agent-skills` when needed.

## Steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Materialize `AGENTS.md` + ai-context + tasks (preserve **This Project**).
3. Durable docs: `docs/{specs,plans,archive}/`, `docs/INDEX.md` as needed.
4. Local CI: `.githooks/` + install script.
5. Ensure layout above: symlinks, submodule init, `opencode.jsonc` skills.paths.
6. Project commands under `.agents/commands/` (lifecycle thin templates).
7. GitHub hygiene scripts when the product uses Projects.
8. Verify: `opencode debug skill` shows project + vendor skills; hooks installed.
9. Local commit; GitOps on `/end` / ship.

## Submodule repair

```bash
git submodule update --init --recursive .agents/vendor/agent-skills
# optional: track upstream updates
# git submodule update --remote .agents/vendor/agent-skills
```

## Autonomy

Research → Plan → Implement → Verify under Agent OS composed with craft skills from the vendored pack + project skills. End-to-end by default; deferred work tracked with status/priority.
