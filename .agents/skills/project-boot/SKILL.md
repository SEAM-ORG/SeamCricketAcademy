---
name: project-boot
description: Boot a product project for Architect↔Agent work. Use when opening a project folder, session start, whole-repo status, "where are we", or /boot /project-boot.
---

# Project boot

## Checklist

1. Read root `AGENTS.md` (+ ai-context as needed).
2. Whole-repo status: `git status --short --branch` · `git log --oneline -5` · all dirty/WIP.
3. `tasks/lessons.md`, `tasks/todo.md` if present.
4. Open durable work under `docs/plans/`, `docs/specs/` — continue incomplete plans first.
5. Local CI: install hooks if missing.
6. Confirm skills layout: `.agents/skills`, submodule vendor pack, `.opencode` symlinks.
7. Summarize status + next step (5–10 lines).
8. Non-trivial work: plan/implement/verify under Agent OS + applicable skills; end-to-end; local-first commits.
