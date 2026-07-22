# OpenCode project surfaces

Runtime config, plugins, MCP, and skills are **global only**:

| Path | Role |
| ---- | ---- |
| `~/.config/opencode/opencode.jsonc` | Models, plugins (`opencode-antigravity-auth`, DCP), MCP, LSP (OpenCode kit gist `025f6984…`) |
| `~/.config/opencode/AGENT_OS_ENFORCEMENT.md` | Always-on protocol (matches Agent OS `ALWAYS_ON.md`) |
| `~/.config/opencode/dcp.jsonc` | Dynamic Context Pruning config |
| `~/.agents/skills/` | OS (`session-*`, `agent-os-bootstrap`) + OpenSpec (`openspec-*`, `using-openspec`) + SWE skills |

**Do not** create project-local `.agents/`, `.agent/`, skill vendor trees, slash-command trees, or
`opencode.json(c)`. Product instructions live in root **`AGENTS.md`** (**This Project** = product SoT).  
SDD product memory lives in **`openspec/`** only.

**Harness default:** OpenCode desktop/CLI for product work in this repo. Grok Build from `~/Projects` for Agent OS / machine changes. Google IDE optional for light IDE assist. **Hermes retired.**

This directory may exist for OpenCode cache/state only (gitignored except this README). Do not reintroduce skill/command symlinks or local `node_modules` / `package.json` here — they can deep-merge and override the global kit.

