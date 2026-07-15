# OpenCode project surfaces

Runtime config, plugins, MCP, and skills are **global only**:

| Path                                         | Role                                                                       |
| -------------------------------------------- | -------------------------------------------------------------------------- |
| `~/.config/opencode/opencode.jsonc`          | Models, plugins (**Superpowers**), MCP, LSP                                |
| `~/.config/opencode/AGENT_OS_ENFORCEMENT.md` | Always-on protocol (from OpenCode kit gist)                                |
| `~/.agents/skills/`                          | Global Agent OS skills only (session-\*, bootstrap, project-boot, hygiene) |
| Superpowers plugin                           | Methodology skills via OpenCode plugin manager                             |

**Do not** create project-local `.agents/`, `.agent/`, skill vendor trees, slash-command trees, or
`opencode.json(c)`. Product instructions live in root **`AGENTS.md`** (**This Project** = product SoT).

**Harness default:** OpenCode desktop for product work in this repo. Grok Build from `~/Projects` for Agent OS / machine changes.

This directory may exist for OpenCode cache/state only (gitignored). Keep this README if useful; do not reintroduce skill/command symlinks into the repo.
