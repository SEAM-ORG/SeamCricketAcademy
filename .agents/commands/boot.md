---
description: Whole-repo status for Architect↔Agent work (not full OS install)
---

Run **project boot** status (not Gist install). Brief; then wait for Architect intent unless mid-handoff.

1. Read root `AGENTS.md` (+ `.github/ai-context/*` if needed).
2. Whole-repo: `git status --short --branch` · `git log --oneline -5` · all dirty/WIP.
3. `tasks/lessons.md`, `tasks/todo.md` if present.
4. Open plans/specs under `docs/plans/`, `docs/specs/` — note incomplete work.
5. Confirm skills layout if relevant: `.agents/skills`, submodule `.agents/vendor/agent-skills`, `.opencode` symlinks.
6. If remote exists: `bash scripts/github/session-preflight.sh` when available.
7. Summarize status + recommended next step (5–10 lines). No invented product work without Architect intent.
