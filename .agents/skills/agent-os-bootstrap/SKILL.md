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
   - `.github/ai-context/*` (principles, workflow, knowledge graph, dev-journal)
   - `.agents/skills/agent-os-bootstrap/SKILL.md` (this skill)
   - `CLAUDE.md` → `AGENTS.md` symlink
   - `tasks/lessons.md` if missing
5. Environment Discovery when bootstrapping or env drift suspected.
6. Gap analysis — **local CI default = `.githooks/` + `scripts/install-githooks.sh`**:
   - Create `.githooks/pre-commit` (quality) and `.githooks/pre-push` (correctness) if missing.
   - Create/run `bash scripts/install-githooks.sh` (installs into `.git/hooks`).
   - **Do not** introduce husky/lefthook for new wiring. If husky is present, migrate to `.githooks` and remove husky.
   - **GitHub** = deploy/release/environment only. No PR lint/test/build Actions that duplicate hooks.
7. Verify health checklist in `AGENTS.md`.
8. Commit without AI authorship language. Closeout: which repos synced, residual gaps.

## Rules

- Behavior only in OS sections; stack facts only in **This Project** + knowledge graph.
- Do not copy another product's scripts/hooks into a different stack.
- Prefer `.githooks` + install script for all stacks.
- Never pin models/providers in tracked agent config.
