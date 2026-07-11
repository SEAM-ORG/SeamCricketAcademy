---
name: agent-os-bootstrap
description: >
  Install, repair, or sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee.
  Use when the Architect asks to install/sync Agent OS, when AGENTS.md is missing/stale vs the Gist,
  when OS surfaces fail the health checklist, or when running /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync Skill

## Scope reminder

- Non-project chat ≠ a project (do not invent a product from home/).
- Gist OS changes are portable: update the Gist, then **by default sync into known product repos**.
- Product feature work stays single-repo unless more are named.

## Trigger

Architect says install/init/sync Agent OS, pastes gist `saadev0/5828479245f786c80993b67a6f669aee`, OS drift vs Gist, or health checklist fails.

## Do this yourself — never ask the Architect to copy files

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Detect greenfield vs brownfield (git + source present?).
3. For each target product repo (default: all known under Architect projects when OS sync): off protected branch `chore/agent-os-sync` (or continue existing chore branch).
4. Materialize surfaces (preserve filled **This Project** on sync):
   - Root `AGENTS.md` = full OS from Gist + existing/filled **This Project**
   - `.github/ai-context/AGENT_PRINCIPLES.md` (Gist principles; append project-specific only if already present)
   - `.github/ai-context/AGENT_WORKFLOW.md` (Gist workflow; keep project gate tables if present)
   - `.github/ai-context/PROJECT_KNOWLEDGE_GRAPH.md` (real paths — do not wipe domain map on sync)
   - `.github/ai-context/dev-journal.md` (append sync entry; do not delete history)
   - `.agents/skills/agent-os-bootstrap/SKILL.md` (this skill)
   - `CLAUDE.md` → `AGENTS.md` symlink
   - `tasks/lessons.md` if missing
5. Environment Discovery when bootstrapping or env drift suspected.
6. Gap analysis:
   - **Local CI** = git hooks (pre-commit quality, pre-push correctness). Create if missing.
   - **GitHub** = deploy/release/environment only when deploy target known. **Do not** create PR lint/test/build Actions that duplicate hooks.
   - Remove redundant GitHub PR CI when hooks cover the same gates. Dependabot/Jules are fine.
7. Verify health checklist in `AGENTS.md`.
8. Commit without AI authorship language. Closeout: which repos synced, Gist sha/date, residual gaps.

## Rules

- Behavior only in OS sections; stack facts only in **This Project** + knowledge graph.
- Do not copy another product's scripts/hooks into a different stack.
- Prefer existing hook frameworks (husky, lefthook, shell).
- Never pin models/providers in tracked agent config.
