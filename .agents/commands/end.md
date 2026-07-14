---
description: Session End Protocol — ship GitOps + Project V2 + leave on main
---

Run **Session End Protocol** from root `AGENTS.md`. Triggered by `/end`, "end session", or "ship it".

1. Verify + consolidate; durable memory (`tasks/`, docs) lands with the work.
2. Prefer `bash scripts/github/ship-unit.sh` (or push → PR with labels → squash merge).
3. Project V2: board Status **In Review** → merge → **Done** when `agent-project.yml` is configured and `gh` has project scopes.
4. `bash scripts/github/session-end-hygiene.sh` (add `--close-stale-os-prs` when obsolete OS-init PRs remain).
5. **Hard gate:** `bash scripts/github/session-end-return-main.sh` exits 0 — clean tree on protected branch, ready for next session.
6. Closeout: summary · status · evidence · PR/issue links · board · next step.
