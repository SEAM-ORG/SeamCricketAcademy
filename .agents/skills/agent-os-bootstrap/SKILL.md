---
name: agent-os-bootstrap
description: Install or repair Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee. Use when the Architect asks to install Agent OS, when AGENTS.md is missing/stale, or when OS surfaces fail the health checklist.
---

# Agent OS Bootstrap Skill

## Trigger

Architect says install/init Agent OS, pastes gist `saadev0/5828479245f786c80993b67a6f669aee`, or agent finds no usable `AGENTS.md` contract.

## Do this yourself — never ask the Architect to copy files

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Detect greenfield vs brownfield (git + source present?).
3. Off protected branch: `chore/agent-os-init` (or continue existing chore branch).
4. Materialize surfaces:
   - Root `AGENTS.md` = full OS + filled **This Project**
   - `.github/ai-context/AGENT_PRINCIPLES.md`
   - `.github/ai-context/AGENT_WORKFLOW.md`
   - `.github/ai-context/PROJECT_KNOWLEDGE_GRAPH.md` (real paths)
   - `.github/ai-context/dev-journal.md`
   - `.agents/skills/agent-os-bootstrap/SKILL.md` (this file)
   - `CLAUDE.md` → `AGENTS.md` symlink
   - `tasks/lessons.md` (+ `tasks/todo.md` if multi-step objective active)
5. Environment Discovery (toolchains, version managers, CLIs).
6. Gap analysis:
   - **Local CI** = git hooks (pre-commit quality, pre-push correctness). Create if missing.
   - **GitHub** = deploy/release/environment workflows only when deploy target known. Do **not** create PR lint/test/build Actions that duplicate hooks.
   - Remove redundant GitHub PR CI when hooks already cover the same gates (cost + drift). Dependabot/Jules are fine.
7. Verify health checklist in `AGENTS.md`.
8. Commit without AI authorship language. Closeout to Architect.

## Rules

- Behavior only in OS sections; stack facts only in **This Project** + knowledge graph.
- Do not copy another product's scripts/hooks into a different stack.
- Prefer existing hook frameworks (husky, lefthook, shell).
- Never pin models/providers in tracked agent config.
