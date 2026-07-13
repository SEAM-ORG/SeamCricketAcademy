# Agent surfaces (project source of truth)

| Path                   | Role                                                        |
| ---------------------- | ----------------------------------------------------------- |
| `skills/`              | Project-specific skills (`SKILL.md` each)                   |
| `commands/`            | Workflow slash-command templates                            |
| `vendor/agent-skills/` | Shared craft pack (git submodule → addyosmani/agent-skills) |

OpenCode discovers via:

- `.opencode/skills` → symlink to `skills/`
- `.opencode/command` → symlink to `commands/`
- `opencode.jsonc` → `skills.paths` includes `skills/` + `vendor/agent-skills/skills`

Do not copy the craft pack into `skills/`; update the submodule instead.
