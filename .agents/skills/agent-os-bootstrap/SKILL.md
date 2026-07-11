---
name: agent-os-bootstrap
description: >
  Install, repair, or sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee.
  Use when the Architect asks to install/sync Agent OS, when AGENTS.md is missing/stale vs the Gist,
  when OS surfaces fail the health checklist, or when running /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync Skill

## Scope reminder

- Non-project chat ≠ a project.
- Gist OS changes: update Gist, then **default sync into known product repos**.
- Product feature work: single-repo unless more are named.

## Local CI gold standard (always wire this)

| Hook | Role | Runs |
|------|------|------|
| **pre-commit** | Quality (fast) | lint, format, quick analyze/typecheck |
| **pre-push** | Correctness | **test + build** |

- Framework: `.githooks/` + `scripts/install-githooks.sh` (not husky).
- Prefer `scripts/local-ci-pre-commit.sh` and `scripts/local-ci-pre-push.sh`.
- Missing lint/test tools → document gap in **This Project**; do **not** put full build on every commit to compensate.
- No GitHub PR CI that duplicates these gates.

## Bootstrap steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Greenfield vs brownfield; branch `chore/agent-os-sync`.
3. Materialize AGENTS.md + `.github/ai-context/*` + this skill + CLAUDE.md + tasks/.
4. Wire gold-standard local CI; migrate husky; remove redundant PR CI workflows.
5. Verify checklist; commit; closeout.
