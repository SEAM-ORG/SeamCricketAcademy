# Lessons

Persistent learnings. Review at session start. Append after corrections, postmortems, or patterns that prevent future mistakes.

Format: `### [YYYY-MM-DD]: [title]` + short description and prevention rule.

### 2026-07-11: Local CI only — no GitHub PR CI
Quality gates live in git hooks. GitHub Actions are deploy/release/environment only. Dependabot and Jules cover GitHub essentials. Do not re-add PR lint/test/build workflows.

### 2026-07-11: Local CI uses .githooks not husky
Default is tracked `.githooks/` + `scripts/install-githooks.sh`. Do not reintroduce husky.
