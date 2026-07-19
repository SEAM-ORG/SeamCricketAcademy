# Documentation Index

> Master directory for Seam Cricket Academy docs. **Last updated:** 2026-07-19 (memory honesty)

## Product truth (repo root + phases)

| Document                                    | Description                                                    |
| ------------------------------------------- | -------------------------------------------------------------- |
| [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md) | Product context (current stack & mandates)                     |
| [ROADMAP.md](ROADMAP.md)                    | Phase table — vision & progress SoT                            |
| [HISTORY.md](HISTORY.md)                    | **Session journal** — inception → now, newest first; Session End append |
| [DESIGN_SYSTEM.md](../DESIGN_SYSTEM.md)     | Visual system (non-negotiable)                                 |
| [DEPLOYMENT.md](../DEPLOYMENT.md)           | Deploy / Pages                                                 |
| [SETUP.md](../SETUP.md)                     | Setup notes                                                    |
| [README.md](../README.md)                   | Overview                                                       |
| [CHANGELOG.md](../CHANGELOG.md)             | Changelog                                                      |
| [AGENTS.md](../AGENTS.md)                   | Agent OS + This Project                                        |

**Wiki (GitHub):** thin human product surface only. Repo docs above are SoT — do not dual-write full manuals or Agent OS into the Wiki.

## Data & code entry points

| Path                        | Purpose               |
| --------------------------- | --------------------- |
| `src/data/academy.json`     | Academy content data  |
| `src/data/programs.ts`      | Programs              |
| `src/pages/index.astro`     | Home                  |
| `src/lib/seamfusion-api.ts` | SeamFusion API client |
| `src/lib/validation.ts`     | Email / WhatsApp / URL safety |

## Spec-Driven Development (OpenSpec)

| Path | Purpose |
| ---- | ------- |
| [`openspec/config.yaml`](../openspec/config.yaml) | Project context + agent rules |
| [`openspec/specs/`](../openspec/specs/) | Living capability requirements (SoT) |
| [`openspec/changes/`](../openspec/changes/) | Active change proposals |
| [`openspec/changes/archive/`](../openspec/changes/archive/) | Completed changes |

**Capabilities:** `academy-marketing-ux` · `program-catalog` · `coach-profiles` · `lead-generation` · `seamfusion-api-sync`

Machine skills: global `openspec-*` / `using-openspec` under `~/.agents/skills`. **No `.kiro/`** (removed 2026-07-18).

## Durable plans & human design notes

| Path                 | Purpose              |
| -------------------- | -------------------- |
| [specs/](specs/)     | Design notes (human) |
| [plans/](plans/)     | Implementation plans |
| [archive/](archive/) | Finished work        |

## Ops

| Document                               | Description                     |
| -------------------------------------- | ------------------------------- |
| [GITHUB_ACTIONS.md](GITHUB_ACTIONS.md) | Deploy/release workflow inventory |

## Agent context

| Path                                          | Purpose                              |
| --------------------------------------------- | ------------------------------------ |
| [.github/ai-context/](../.github/ai-context/) | Knowledge graph, principles, journal |
| [tasks/lessons.md](../tasks/lessons.md)       | Corrections                          |
| [tasks/todo.md](../tasks/todo.md)             | Active checklist                     |
