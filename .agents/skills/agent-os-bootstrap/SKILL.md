---
name: agent-os-bootstrap
description: >
  Install/repair/sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee
  for Grok Build and Antigravity (agy) only. Use on install, drift, or /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync

## Harness scope

Grok Build + Antigravity only. **No Superpowers methodology. No OpenSpec / OpenCode / Claude / Cursor setups.**

## Steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Materialize `AGENTS.md` + `.github/ai-context/*` + skills + `tasks/`.
3. Ensure durable docs dirs exist: prefer `docs/{specs,plans,archive}/`; keep legacy `docs/superpowers/*` if present.
4. Local CI: `.githooks/` + install script (gold standard).
5. Remove `openspec/`, `opencode.json`, multi-harness forks if present.
6. Do **not** install Superpowers unless Architect explicitly asks.
7. Verify checklist; commit; closeout.

## Autonomy

Non-trivial work → Research → Plan → Implement → Verify under Agent OS. Persist optional plans/specs under `docs/` for multi-session work. **Intent before invention** — no skill-driven redesigns without Architect objective.
