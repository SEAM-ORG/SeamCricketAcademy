---
name: agent-os-bootstrap
description: >
  Install/repair/sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee
  for Grok Build and Antigravity (agy) only. Use on install, drift, or /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync

## Harness scope

Grok Build + Antigravity only. Superpowers via global plugins. **No OpenSpec / OpenCode / Claude / Cursor setups.**

## Steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Materialize `AGENTS.md` + `.github/ai-context/*` + skills + `tasks/`.
3. Ensure `docs/superpowers/{specs,plans,archive}/` exists.
4. Local CI: `.githooks/` + install script (gold standard).
5. Remove `openspec/`, `opencode.json`, multi-harness forks if present.
6. Confirm Superpowers available (Grok plugin; `agy plugin list` / install if needed).
7. Verify checklist; commit; closeout.

## Superpowers autonomy

Non-trivial work → agents run Superpowers and write durable specs/plans under `docs/superpowers/` without Architect slash commands.
