---
name: agent-os-bootstrap
description: >
  Install/repair/sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee
  for Grok Build and Antigravity (agy) only. Use on install, drift, or /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync

## Harness scope

**Supported:** Grok Build, Antigravity (`agy`).  
**Do not** set up OpenCode, Claude Code, Cursor, Copilot agent, etc.

## Steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Branch `chore/agent-os-sync`; materialize `AGENTS.md` + `.github/ai-context/*` + this skill + `tasks/`.
3. **No** `CLAUDE.md` / multi-harness instruction forks.
4. Local CI: `.githooks/` + `scripts/install-githooks.sh` (gold standard).
5. OpenSpec (product repos): `openspec init --tools antigravity` or `openspec update` + ensure `--tools antigravity` on init — never `--tools all`.
6. Remove foreign harness files if found (`opencode.json`, etc.).
7. Verify checklist; commit; closeout.
