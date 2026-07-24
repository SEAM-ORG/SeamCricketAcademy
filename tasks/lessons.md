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

Non-trivial work uses Superpowers + docs/superpowers/\* for durability. Do not wait for slash commands. Do not reintroduce OpenSpec.

### 2026-07-12: Agent OS only — no Superpowers methodology

Superpowers is not the default work layer. Agents follow the Gist / root `AGENTS.md` (Research → Plan → Implement → Verify). Do not reinstall Superpowers or invent design systems from plugin skills. Intent before invention.

### 2026-07-12: Protected Gist session + Local-vs-GitOps protocols

Agents previously slimmed the portable Agent OS Gist and lost local-first / session start-end protocols. **Prevention:** Session Start, Local vs GitOps (verified+committed locally by default; push/PR on `/end` or exception), Session End, Hooks/CI, and harness scope are protected. Do not delete or collapse them when editing the Gist or syncing `AGENTS.md`. Propose diffs; never unilaterally slim.

### 2026-07-12: Grok CLI + OpenCode only; agent-skills global

Supported harnesses are **Grok CLI** and **OpenCode** only — no Antigravity IDE/CLI. Keep `opencode-antigravity-auth` (OpenCode Google auth). Global **addyosmani/agent-skills** is required; agents use skills/hooks/commands autonomously. On bootstrap, repair global install and fill project gaps.

## 2026-07-12 — Agent OS slash surfaces (Architect repair)

- **Lesson:** "Boot complete" ≠ slash commands installed. OpenCode needs `~/.config/opencode/command/*.md` for `/start` `/end` etc.; skills alone are intent-driven.
- **Lesson:** Stale **This Project** harness lines ("Antigravity only / no OpenCode") contradict OS body and confuse agents — keep harness = Grok + OpenCode.
- **Lesson:** Grok `plugins.enabled` must not list removed plugins (e.g. superpowers) or agents/harness drift.
- **Fix applied:** global OpenCode commands + AGENTS harness/header cleanup + Gist Advanced Controls.

## 2026-07-12 — Solo autonomy + GitHub hygiene restored

- **Standing rule:** Only Architect + agent. Never assume another human finishes steps.
- **Restored:** GitHub Issues/PRs/labels/milestones/status duties + portable `create-pr.sh` / `finalize-pr.sh`.
- **Husky:** removed; gold `.githooks` + install script clears stale `core.hooksPath`.

## 2026-07-12 — GitHub Project V2 + open-PR hygiene is agent CLI work

- Session Start: `bash scripts/github/session-preflight.sh`
- Ship: `bash scripts/github/ship-unit.sh` (labels + board Status + merge)
- Session End: `bash scripts/github/session-end-hygiene.sh [--close-stale-os-prs]`
- Requires once: `gh auth refresh -s project,read:project`
- Never use GitHub Actions to move Project cards as a substitute for agent duty.

### 2026-07-15: Harness routing + intent over literalism + Superpowers+OS only

- **Product work:** OpenCode desktop inside the product repo.
- **Agent OS / machine / multi-repo OS:** Grok Build from `~/Projects`.
- Agents **enhance** Architect intent; full effort; proactive project + OS maintenance.
- Methodology = **Superpowers** (plugin) + OS skills. **No** OpenSpec work layer. **No** addy agent-skills. Ignore older lessons that say "OpenSpec autonomy" or "Agent OS only — no Superpowers."
- Product SoT = root `AGENTS.md` **This Project** + `docs/INDEX.md`. Portable OS SoT = gist `5828479245f786c80993b67a6f669aee` (no product facts in gist).

### 2026-07-15: Extend existing first — no parallel skills/docs

Before creating skills, docs, hooks, or workflows: update AGENTS.md, INDEX-linked docs, or an existing skill. Product boot is **session-start** (project-boot is a deprecated alias). OS skills only under `~/.agents/skills` (no Grok mirror). Methodology = Superpowers. Durable plans = `docs/{specs,plans,archive}/` only; `docs/superpowers/` is redirect-only. ai-context principles/workflow are thin stubs linking to AGENTS.

### 2026-07-15: No silent ignore of unfinished work

Agents must inventory and dispose dirty trees, local branches ahead of protected, unpushed commits, open plans/todos, open PRs, portfolio loose files under ~/Projects, and machine OS drift. Clean main is not idle. Re-ground mid-session. Superseded chore branches may be deleted after classification; unique product commits must be recovered or PARKED — never silent drop.

## 2026-07-16 — Dependabot #37 rehome

- astro 7 + @tailwindcss/vite 4.3.2; pin typescript ^6 for @astrojs/check peer (TS 7 rejected).
- Closed broken #37; new Dependabot #55 may supersede further — triage same turn.

## 2026-07-16 — astro 7.0.9

- Bumped to ^7.0.9 (Dependabot #55 rehome).

## 2026-07-16 — anti later health handoff

- Health blockers (open PRs/red protected CI) are this-turn dispose; inventory-only closeout is forbidden.

## 2026-07-16 — Subagent-first (OS)

- Universal OS: primary models must fan out via harness Task/task/spawn_subagent for multi-step/multi-file work. Soft “use subagents” was model-biased toward Opus; hard mandate is model-agnostic.

## 2026-07-16 — Biome format/lint

- JS/TS/JSON/CSS/HTML/Astro use **Biome** (not Prettier/ESLint). Machine gate: `~/.config/agent-quality/`. Dart stays `fvm dart format`.

## 2026-07-16 — Biome tighten + Actions supersession

- a11y + noUnused* elevated to **error** (Astro unused vars overridden — Biome cannot see template uses).
- Hygiene/preflight: failed Actions only block when **latest run of that workflowName** is still red.

- Fix: Biome unsafe unused renames break Astro templates — never autofix Astro frontmatter without build verify.

## 2026-07-17 — GitOps hygiene + Project V2 enforcement
- **Symptom:** Multiple remote branches/orphans; Issues/PRs not landing on Projects; `project_number: 0` silently skipped board sync.
- **Rule:** Session Start preflight exit 2 on open PRs, remote orphans, and Project V2 misconfig. Session End must prune remotes + return-to-main. `ship-unit`/`open-unit` refuse if board unwired.
- **Boards:** SEAM-ORG #8 SeamFusionProject · Tanti-ORG #1 Tanti Project. Status: Todo / In Progress / Done. Fields: Work Type, Priority Level.
- **Canonical scripts:** `~/.agents/scripts/github/*` → product `scripts/github/`.

## 2026-07-17 — Project V2 field completeness
- **Rule:** Every board item needs Status + Work Type + Priority Level; every Issue/PR needs ≥1 label; infra needs Agent OS & Tooling milestone when no product phase.
- **Repair:** `bash scripts/github/project-backfill.sh` (GraphQL paginated). ship-unit always sets Type+Priority.

### 2026-07-18: OpenSpec sole SDD — .kiro removed

Migrated methodology from kiro/cc-sdd stubs to **OpenSpec** (`openspec/specs`, `openspec/config.yaml`). Capability specs folded from product truth (design system, programs, coaches, lead-gen, SeamFusion API). **Prevention:** never reintroduce `.kiro/` or dual SDD trees; use global `openspec-*` / `using-openspec` only.

### 2026-07-18: Release Tag Deploy YAML — no raw multiline Markdown in run:|

Multiline Markdown tables inside `run: |` (especially lines starting with `|`) break GitHub Actions YAML parse → 0s failed runs with no jobs. **Prevention:** use single-line `\n` escapes for release notes sections (see AGENTS Release Tag Deploy warning).

### 2026-07-19: Product memory honesty — code/deploy beat docs

README still advertised nested `astro-revamp/`, Astro 5.8 badge, and a non-SEAM-ORG clone path; DEPLOYMENT still had Windows paths, old org names, and a push-to-main deploy sample with Node 20. ROADMAP “current phase” disagreed with the phase table. **Prevention:** on memory refresh, verify package.json, workflows (Node pin + triggers), remote `SEAM-ORG/…`, and root layout before trusting human docs. Keep This Project concise; put long manuals in linked docs only.

### 2026-07-24: Local gates without tracked githooks

Tracked `.githooks/` and `scripts/github/*` ship helpers were removed. **Local gates = CI** means agents run `npm run lint` · `npm test` · `npm run build` before ship — not that hooks auto-run. GitOps E2E lives in master Gist **§2b**; product hub `AGENTS.md` carries ship path + product release cmds only. **Prevention:** do not reintroduce husky/hooks or claim “pre-push already ran tests” unless automation is restored.
