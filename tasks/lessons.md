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

### 2026-07-12: Agent OS only — no Superpowers methodology
Superpowers is not the default work layer. Agents follow the Gist / root `AGENTS.md` (Research → Plan → Implement → Verify). Do not reinstall Superpowers or invent design systems from plugin skills. Intent before invention.

### 2026-07-12: Protected Gist session + Local-vs-GitOps protocols
Agents previously slimmed the portable Agent OS Gist and lost local-first / session start-end protocols. **Prevention:** Session Start, Local vs GitOps (verified+committed locally by default; push/PR on `/end` or exception), Session End, Hooks/CI, and harness scope are protected. Do not delete or collapse them when editing the Gist or syncing `AGENTS.md`. Propose diffs; never unilaterally slim.

### 2026-07-12: Grok CLI + OpenCode only; agent-skills global
Supported harnesses are **Grok CLI** and **OpenCode** only — no Antigravity IDE/CLI. Keep `opencode-antigravity-auth` (OpenCode Google auth). Global **addyosmani/agent-skills** is required; agents use skills/hooks/commands autonomously. On bootstrap, repair global install and fill project gaps.
