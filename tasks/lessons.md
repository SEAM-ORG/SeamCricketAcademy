# Lessons

Persistent learnings. Review at session start. Append after corrections, postmortems, or patterns that prevent future mistakes.

Format: `### [YYYY-MM-DD]: [title]` + short description and prevention rule.

### 2026-07-11: Local CI only — no GitHub PR CI
Quality gates live in git hooks. GitHub Actions are deploy/release/environment only. Dependabot and Jules cover GitHub essentials. Do not re-add PR lint/test/build workflows.

### 2026-07-11: Local CI uses .githooks not husky
Default is tracked `.githooks/` + `scripts/install-githooks.sh`. Do not reintroduce husky.

### 2026-07-11: Gold-standard local CI split
pre-commit = quality only (fast). pre-push = test + build. Never put full suite on every commit; never skip push correctness because commit was green.

### 2026-07-11: Whole-project ownership
Do not limit awareness to staged files or this session's edits. Status-check the whole repo before plan/implement; continue prior WIP or track it.

### 2026-07-11: OpenSpec autonomy
Non-trivial work → agent creates/continues `openspec/changes/*` without being told. Missing Architect slash command ≠ skip OpenSpec.

### 2026-07-11: Superpowers not OpenSpec
Non-trivial work uses Superpowers + docs/superpowers/* for durability. Do not wait for slash commands. Do not reintroduce OpenSpec.
