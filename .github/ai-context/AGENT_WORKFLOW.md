# Agent Workflow

Procedures for this repo. Source: Architect↔Agent OS gist.

## Roles

| Role | Does |
|------|------|
| Implementer (default) | End-to-end objective |
| Planner/Reviewer | Continuity, handoffs, review — not silent feature pivots |
| Architect | Vision and decisions only |

## Session start

1. `git status --short --branch` · `git log --oneline -5`
2. If on `main` → `git checkout -b <type>/<slug>` before edits
3. Read `AGENTS.md` + knowledge graph for the objective
4. Product docs as needed: `README.md`, `PROJECT_CONTEXT.md`, `DESIGN_SYSTEM.md`
5. Execute next safe step same turn

## Core loop

Research → Plan → Implement → Verify → Docs/memory → GitOps as needed → Closeout

**Investigation ledger** (non-trivial): inventory · current vs intended · root cause · local vs live · verification commands.

## Verification gates

Discover from `package.json` / CI — do not invent foreign stacks.

| Gate | Command |
|------|---------|
| Install | `npm ci` |
| Unit tests | `npm test` |
| Production build | `npm run build` |
| Local preview | `npm run preview` |
| Dev server | `npm run dev` (http://localhost:4321) |

UI claims: exercise in browser when layout/interaction changed.  
Integrations: SeamFusion is build-time; mock vs live depends on `PUBLIC_*` env.

## GitOps

- `main` = release-only (deploys GitHub Pages via `.github/workflows/deploy.yml`)
- Product branches: `feat|fix|perf|security|release/<issue>-<slug>`
- Internal: `chore|ops|ci|docs|refactor|test|build/<slug>`
- Path: branch → commit → push → PR → squash merge
- No stash; no force-push protected; no history rewrite without approval
- Prefer `gh` for issues/PRs/checks

## Docs & memory

| Change | Update |
|--------|--------|
| User-visible product | `README.md` / `CHANGELOG.md` / `src/data/*` as appropriate |
| Design rules | `DESIGN_SYSTEM.md` |
| Architecture / map | `PROJECT_KNOWLEDGE_GRAPH.md` |
| Taught agent behavior | `AGENTS.md` / principles / this file |
| Internal outcome | `dev-journal.md` |
| Unfixed finding | GitHub issue or note in journal |

## Error recovery

Stop-the-line → diagnose → root cause → fix → re-verify. Safe default + clear error. Reversible branches.

## Autonomy matrix

| Agent-owned | Architect-owned |
|-------------|-----------------|
| Discovery, implementation, tests, docs | Priorities, taste |
| Branch/commit/PR/issue hygiene | Release timing / prod deploy approval |
| Tooling repair, OS drift fix | Irreversible data/business calls |
| Live probes | Credentials agent cannot get |

## Templates

**Closeout:** Summary · Status · Evidence · Next  
**Bug:** Repro · Expected/actual · Root cause · Fix · Verification · Risk  
**Handoff:** Branch/issue/PR · files to read · ledger · in/out scope · STOP · gates · report-back
