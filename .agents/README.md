# Agent surfaces (project source of truth)

| Path                   | Role                                                                                            |
| ---------------------- | ----------------------------------------------------------------------------------------------- |
| `commands/`            | Slash workflows (`/boot`, `/start`, `/agent-os-bootstrap`, `/spec`, …) — **invoke these**       |
| `skills/`              | Optional **project-only** skills (product-specific). Do **not** mirror lifecycle commands here. |
| `vendor/agent-skills/` | Shared craft pack (git submodule)                                                               |

OpenCode:

- `.opencode/command` → `commands/`
- `.opencode/skills` → `skills/`
- `opencode.jsonc` `skills.paths` → `skills/` + `vendor/agent-skills/skills`

Lifecycle actions are **commands only** (one picker entry each). Craft skills live in the vendor submodule.
