# Agent Workflow

## Roles

| Role | Does |
|------|------|
| Implementer (default) | End-to-end objective |
| Planner/Reviewer | Continuity, handoffs, review — not silent feature pivots |
| Architect | Vision and decisions only |

## Checklists

**Start:** status · log · branch off protected · review `tasks/lessons.md` · plan/handoff · knowledge graph → files · live probes · execute same turn.

**Complete:** verify evidence · intentional git · durable memory · product docs if needed · update `tasks/todo.md` · closeout footer.

## GitOps behavior

Branch → push → PR → squash merge. Link issues on product PRs when they exist. Prefer `gh`. After landing, leave workspace on protected branch when the workstream is done.

## Verification

Discover gates from package.json / Makefile / CI / README — never invent a foreign stack. UI claims need runtime exercise. Integrations: mock vs live.

## Docs & memory

| Change | Update |
|--------|--------|
| User-visible | Product docs / CHANGELOG |
| Architecture | Knowledge graph + eng notes |
| Taught agent behavior | AGENTS / principles / workflow |
| Mistake / correction | `tasks/lessons.md` |
| Internal outcome | dev-journal |
| Unfixed finding | Issue or technical-debt doc |

## Error recovery

Stop-the-line → preserve evidence → diagnose → root cause → fix → re-verify. Safe default + clear error. Reversible branches. If a fix breaks something else, do not ship — investigate further.

## Bugfix triage

Reproduce → Localize → Reduce to minimal case → Fix at root cause → Add guard (test/hook) → Verify fix + no regression.

## Autonomy matrix

| Agent-owned | Architect-owned |
|-------------|-----------------|
| Discovery, implementation, tests, docs | Priorities, taste |
| Branch/commit/PR/issue hygiene | Release timing / prod deploy approval |
| Tooling repair, OS drift fix | Irreversible data/business calls |
| Live probes | Credentials agent cannot get |
| Subagent orchestration & parallel work | Defining the core business logic / requirements |
| Relentless debugging & error recovery | Approving major architectural pivots |
| Local hooks (CI) + deploy-workflow maintenance | N/A |
| Environment setup and version management | `sudo` / system-level installs requiring credentials |
| Proactive health improvements (deps, tests, docs, patterns) | Budget/timeline tradeoffs for large improvements |
| Modernizing code touched during work | Full-project rewrites or stack migrations |

## Templates

**Closeout:** Summary · Status · Evidence · Next  
**Bug:** Repro · Expected/actual · Root cause · Fix · Guard added · Verification · Risk  
**Handoff:** Branch/issue/PR · files to read · ledger · in/out scope · STOP · gates · report-back

---

### Local CI gold standard (all projects)

| Hook | Role | Typical commands |
|------|------|------------------|
| pre-commit | Quality (fast) | lint, format, analyze |
| pre-push | Correctness | test + build |

Do not put full test suites on pre-commit. Record missing lint/test tools under This Project instead of overloading commit hooks.
