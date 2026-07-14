# OpenCode project surfaces

Runtime config is **global only:** `~/.config/opencode/opencode.jsonc`  
(models, plugins, MCP, LSP — not per-repo JSON).

This directory only holds discovery surfaces:

| Path                                  | Purpose                              |
| ------------------------------------- | ------------------------------------ |
| `command` → `.agents/commands`        | Slash commands (`/start`, `/end`, …) |
| `skill` / `skills` → `.agents/skills` | Optional skill discovery             |

Do not add `opencode.json(c)` here or at the repo root.
