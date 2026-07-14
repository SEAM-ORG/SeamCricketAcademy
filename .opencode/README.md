# OpenCode project surfaces

Runtime config, plugins, MCP, and skills are **global only**:

| Path                                | Role                                                           |
| ----------------------------------- | -------------------------------------------------------------- |
| `~/.config/opencode/opencode.jsonc` | Models, plugins (incl. **Superpowers**), MCP, LSP              |
| `~/.config/opencode/command/`       | Global slash commands (`/start`, `/end`, …)                    |
| `~/.agents/skills/`                 | Global Agent OS + agent-skills pack                            |
| Superpowers plugin                  | Methodology skills (brainstorming, TDD, …) via OpenCode plugin |

**Do not** create project-local `.agents/`, `.agent/`, skill vendor trees, or
`opencode.json(c)`. Product instructions live in root **`AGENTS.md`**.

This directory may exist for OpenCode cache/state only (gitignored). Keep this
README if useful; do not reintroduce skill/command symlinks into the repo.
