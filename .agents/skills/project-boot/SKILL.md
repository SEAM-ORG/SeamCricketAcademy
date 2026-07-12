---
name: project-boot
description: >
  Boot a product project for Architect↔Agent work under Grok CLI or OpenCode.
  Use when opening a project folder, starting a session in a repo, or when the agent needs
  whole-repo status before planning. Trigger phrases: "boot the project", "session start",
  "where are we", /project-boot.
---

# Project boot (Grok CLI + OpenCode)

## Harness

**Supported:** Grok Build (CLI/TUI), OpenCode.  
**Not supported:** Antigravity IDE/CLI. Keep `opencode-antigravity-auth` (OpenCode Google auth only).  
**Methodology:** Agent OS (`AGENTS.md` / Gist) + global **agent-skills** pack — Research → Plan → Implement → Verify. **No Superpowers. No OpenSpec.**

## Checklist

1. Read root `AGENTS.md` (+ lazy-load ai-context as needed).
2. Whole-repo status: `git status --short --branch` · `git log --oneline -5` · all dirty/WIP.
3. `tasks/lessons.md`, `tasks/todo.md` if present.
4. Open durable work: list `docs/plans/`, `docs/specs/`, or legacy `docs/superpowers/{plans,specs}/` — **continue incomplete plans** before net-new.
5. Local CI: `bash scripts/install-githooks.sh` if hooks missing.
6. Environment from **This Project**.
7. If agent-skills pack looks missing globally, repair per Gist **Agent Skills Pack** (do not block product boot for long).
8. Summarize status + recommended next step (5–10 lines).
9. For non-trivial objectives: plan/implement/verify under Agent OS + applicable agent-skills; optional durable docs under `docs/`; **intent before invention** (no skill-driven redesigns). Local-first commits.

## OpenSpec

Do not use. If `openspec/` appears, remove or ignore unless Architect revives it.
