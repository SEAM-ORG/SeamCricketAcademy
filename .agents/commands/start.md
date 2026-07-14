---
description: Session Start Protocol — Decision Gate before edits (use /boot for quick status only)
---

Run **Session Start** from root `AGENTS.md` (Agent OS). Mandatory before any edit.

1. Read root `AGENTS.md` in full (re-read after compaction).
2. Whole-repo: `git status --short --branch` · `git log --oneline -5` · all dirty/WIP.
3. **Session Start Decision Gate** — never ignore orphan untracked work or open handoff branches.
4. Review `tasks/lessons.md` + `tasks/todo.md`.
5. Open durable work under `docs/plans/`, `docs/specs/` (continue incomplete before net-new).
6. If remote exists: `bash scripts/github/session-preflight.sh` (open PRs/Issues + Project V2 when configured).
7. Local hooks: `bash scripts/install-githooks.sh` if missing.
8. Summarize status + recommended next step (5–10 lines). No invented product work without Architect intent.
