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

## Protected protocols (never strip)

When installing or syncing from the Gist, **preserve** these OS contracts — refine wording if needed, but do not delete or "slim" them without Architect-approved explicit diff:

- **Session Start Protocol** (decision gate / handoff ownership)
- **Local vs GitOps** (local-first per turn; push/PR only on `/end` / ship or exceptions)
- **Per-turn completion + Session End Protocol**
- Hooks / local CI gold standard + deploy-only GitHub Actions policy
- Harness scope (Grok Build + Antigravity only)
- Gist Sync Protocol (including Protected OS sections)

Verify after sync: `rg -n 'Local vs GitOps|Session Start Protocol|Session End Protocol|verified locally' AGENTS.md`

## Autonomy

Non-trivial work → Research → Plan → Implement → Verify under Agent OS (local-first commits; GitOps on `/end` / ship). Persist optional plans/specs under `docs/` for multi-session work. **Intent before invention** — no skill-driven redesigns without Architect objective.
