# Architect ↔ Agent Operating System (Agent OS)

**Thin always-on hub** — not the full contract dump. Full OS lives in gist segments (progressive disclosure).
**Gist:** `saadev0/5828479245f786c80993b67a6f669aee` · **Catalog:** gist file `CATALOG.md`.

> **⚠️ AGENTS: UPDATE SAFETY**
> - clone the gist repo, edit files, verify head, commit, then push (never one-shot remote overwrite).
> - **Never** put product **This Project** facts in the gist. **Never** prepend gist description into this file.
> - First non-empty line must remain `# Architect…`.
> - Bootstrap/sync: `bash sync-product-agents.sh <repo>` (from gist clone) or skill `agent-os-bootstrap` — preserves **This Project**, installs **thin** hub only.

## Skill stack (machine-global only)

| Layer | What | Where |
|-------|------|-------|
| **Architect↔Agent OS** | Session Start/End, GitOps, Decision Gate, bootstrap | this hub + `session-start` · `session-end` · `agent-os-bootstrap` |
| **OpenSpec (SDD)** | Spec-driven product work | `openspec-*` · `using-openspec` · product **`openspec/`** |
| **SWE Discipline** | Domain craft (load one at a time) | `~/.agents/skills/` |
| **References / Personas** | Checklists · specialist prompts | `~/.agents/references/` · `~/.agents/personas/` |
| **OpenCode harness** | Runtime + thin enforcement | gist `fa4d874…` → `~/.config/opencode/` |

No project `.agents/`, slash-command ceremony trees, or second always-on OS file beyond OpenCode’s enforcement pointer (same card text as `ALWAYS_ON.md`).

## Progressive load (anti-bloat)

| Layer | When | Source |
|-------|------|--------|
| **Always-on card** (below) | Every turn | This file · SoT `ALWAYS_ON.md` in gist |
| **This Project** | Every product turn | Bottom of this file only |
| **session-start / session-end** | Open product · ship | `~/.agents/skills/` |
| **SEGMENT_session.md** | Health fight, Decision Gate detail | gist |
| **SEGMENT_gitops.md** | PR/board/hooks/deploy | gist |
| **SEGMENT_bootstrap.md** | Install / repair OS | gist |
| **SEGMENT_orchestration.md** | Autonomy, subagents, principles | gist |
| **SEGMENT_docs.md** | INDEX / memory / stewardship | gist |
| **SEGMENT_architect.md** | How Architect prompts / teaches | gist |
| **SEGMENT_harness.md** | OpenSpec, MCP, Gist Sync | gist |
| **One openspec skill** | Current SDD phase only | `using-openspec` map |

**Do not** re-ingest every segment every message.

### Portfolio gists (do not confuse)

| Gist | Role |
|------|------|
| `5828479245f786c80993b67a6f669aee` | Portable OS (this hub + segments) |
| `fa4d874490158f7252ca2441227d3343` | OpenCode machine kit |
| `a81a271401b3cba04ef6f700dfc8d225` | Legal/business advisory (not OS) |
| `f1c2ab293cf8996b787eedf94ec60029` | Product-ops status JSON (not OS) |

**Pollution rule:** OS + OpenCode kit stay **portfolio-agnostic**. Product repos, orgs, board numbers live only in **This Project** / product docs / `.github/agent-project.yml`.

**Local kit trees are not second SoTs.** Promote universal harness/OS changes to the correct gist same session. Standing machine packs are listed in `CATALOG.md` with install paths.

---

# PROTOCOL ENFORCEMENT (ALWAYS-ON — non-skippable)

**Canonical always-on SoT** for Architect↔Agent OS.
Product root `AGENTS.md` embeds this card. OpenCode `AGENT_OS_ENFORCEMENT.md` **must match this file** — not a forked rulebook.
Full contract (on demand): gist `saadev0/5828479245f786c80993b67a6f669aee` segments · skills `session-start` / `session-end` / `agent-os-bootstrap` / `using-openspec`.

You operate under **Architect↔Agent OS**. These protocols override convenience, speed, and "quick one-liner" instincts. **Ignoring them is a contract failure.**

## Always-on card (every turn — keep this short)

**Load order:** this card → skill for the task → segment / skill only when needed (session start, health, ship, bootstrap, unsure). Do **not** re-read the entire OS every message.

| When | Do |
|------|-----|
| Product open / re-ground | **`session-start`**: preflight (exit 2 = dispose blockers) → **clean `main`** → Issue + **feature branch** for this session → smoke |
| Non-trivial ask | **Proactive OpenSpec** (do not wait to be told): Explore → `openspec-explore` · Propose → `openspec-propose` · Apply → **`openspec-apply-change`** · Archive → `openspec-archive-change` |
| Multi-step / multi-file / research-heavy | **Subagent-first** — Task/`task`/`spawn_subagent`; orchestrate + synthesize |
| Writing code | On **feature branch only** (hooks refuse commits on `main`) · approved tasks → `openspec-apply-change` · trivial Path B with evidence |
| JS/TS/JSON/CSS/HTML/Astro/Vue | **Biome** — `bash ~/.config/agent-quality/format.sh --changed` · `check.sh` |
| Any change | Verify · same-branch memory (`openspec/`/docs/lessons) · local commit on feature branch · never bypass hooks |
| Ship / end session | **`session-end`**: ship-unit (PR+labels+milestone+Project Status/Type) → close Issues → prune **local+remote** orphans → **return-to-main exit 0** |
| Third-party APIs | **Context7** · UI evidence → **Chrome DevTools** |
| Non-trivial ship | Writer ≠ reviewer (fresh subagent / independent pass) |
| Repeated mistake (2×) | Sensors ratchet: lesson → AGENTS line → hook/lint |

**Context load:** always-on card + skill + **This Project** + relevant docs only. Full segments on session start, health fight, ship, bootstrap, or when unsure — **not** every message. Progressive disclosure: map, not dump.

**Solo operator:** finish end-to-end this session. No "later." HOLD only if externally blocked, with **recovery** branch/PR/path. Remove only after rehome/replace with equal-or-better + justification.

**Health blockers are this-turn work.** If preflight shows open PRs, **remote orphan branches** (no open PR), red protected CI, local WIP ahead of main, or **Project V2 unconfigured** (`project_number: 0`), **dispose in the same turn**. **Forbidden:** inventory without disposition.

### Turn-end closeout (required template — fill briefly)

```
## Closeout
- **Summary:** <1–3 lines what changed for the user/product>
- **Status:** done | in-progress | blocked
- **Evidence:** <test/build/runtime/read-back command or result>
- **Git:** <branch · commit hash or "clean" · uncommitted if any>
- **Health:** clear | blockers disposed: <PR#/action + disposition> | HOLD+recovery: <path>
- **Memory:** INDEX/This Project/lessons/docs updated? yes/n/a
- **Next:** <product next step — never "dispose health later">
```

### Session-end closeout (when `/end` / ship)

```
## Session End
- **Summary:** …
- **Status:** shipped | partial+HOLD
- **Evidence:** …
- **PRs / Issues / milestones:** merged/closed/updated …
- **Project V2:** item Status/Type/Priority set; board not empty of this unit
- **Health:** each open PR/CI/orphan disposed or HOLD+recovery
- **Main:** on protected, clean, ff origin? yes/no
- **Branches pruned:** local merged + remote orphans? yes/no
- **Next session:** first step from clean main
```

## Hard rules (every turn)

1. **Never commit or push on `main`** — feature branch only.
2. **GitOps:** Session Start → dispose health → clean main → Issue + feature branch. Session End → ship-unit → prune → return-to-main exit 0.
3. **Project V2:** `.github/agent-project.yml` has real `project_owner` + `project_number` (never `0`). Discover via `gh project list` — never invent; never hardcode product boards in portable OS.
4. **Local hooks = CI.** GitHub Actions = **Release Tag Deploy** only. No PR lint/test Actions.
5. **Subagent-first** for multi-step / multi-file / research-heavy work.
6. **Memory same change** — `openspec/` · INDEX · This Project · lessons.
7. **Evidence before done.** "Seems right" is never done.
8. **Gist hygiene:** clone → edit → commit → push. Never one-shot overwrite. Never prepend gist description into file bodies. First non-empty line of product hub is `# Architect…`.

## Proactive skill routing (do not wait)

| Need | Skill |
|------|-------|
| Session open / re-ground | `session-start` |
| Ship / end | `session-end` |
| OS install / repair / multi-repo sync | `agent-os-bootstrap` |
| Vague / options | `openspec-explore` |
| New work propose | `openspec-propose` |
| Implement approved change | `openspec-apply-change` |
| Land change | `openspec-sync-specs` / `openspec-archive-change` |
| Intent → skill map | `using-openspec` |
| Domain craft | matching SWE skill under `~/.agents/skills/` (one at a time) |

**References** (on demand): `~/.agents/references/*.md`
**Personas** (subagent prompts): `~/.agents/personas/*.md`

## Project map (always-on memory)

| Path | Role |
|------|------|
| Root `AGENTS.md` | **Thin hub** = always-on card + progressive map + **This Project** |
| Gist segments | Full OS contract on demand (session/GitOps/bootstrap/…) |
| `openspec/` | SDD product memory |
| `docs/INDEX.md` | Doc index |
| `tasks/lessons.md` · `tasks/todo.md` | Lessons · mid-flight |
| `.github/agent-project.yml` | Project V2 (never `project_number: 0`) |
| `scripts/github/*` | preflight · open-unit · ship-unit · hygiene · return-main |
| `~/.agents/skills/` | OS + OpenSpec + SWE (machine-global only) |

## Contract failures

Skip closeout · skip Session Start · skip health gate · claim done without evidence · silent doc drift · hook bypass · commit on main · leave feature branch at session end · leave remote orphans · `project_number: 0` · open PR inventory without disposition · invent PR CI Actions · solo-monolith multi-step when subagents exist · wait for Architect to request skills/subagents · dump full OS monolith into product always-on · product names in portfolio-agnostic OS/kit gists.

---
## Harness routing (Architect default)

| Work | Where | Agent behavior |
|------|-------|----------------|
| **Product work** | OpenCode desktop, cwd = product repo | Session Start → ship; this hub + **This Project** |
| **Agent OS / machine / portfolio** | Grok Build from `~/Projects` | OS/machine only unless Architect names a product |

## Intent over literalism

Enhance short prompts with repo evidence. Maximum effort end-to-end. Proactive autonomy on docs/OS/hooks. Taste, release timing, irreversible pivots stay with the Architect.

## Extend existing first

Find → extend → create only if no home. No duplicate OS skills, no mirror into `~/.grok/skills/`, no product skill trees.

## Gist & hub hygiene (hard)

1. Never put gist **description** into file bodies.
2. Clone the gist repo, edit files, verify head, commit, then push (never one-shot remote overwrite).
3. Product sync preserves **This Project**; OS body stays the **thin hub** (not monolith).

## On-demand segment index

Load from local clone `~/.agents/gists/agent-os/` or gist raw when needed:

| Segment | Covers |
|---------|--------|
| `SEGMENT_session.md` | Unfinished work · solo E2E · health blockers · Session Start Protocol · Session End |
| `SEGMENT_gitops.md` | Local vs GitOps · Project V2 · hooks/CI · deploy · GitHub Issues/PRs |
| `SEGMENT_bootstrap.md` | Greenfield/brownfield · Environment Discovery · Verify healthy · portable install |
| `SEGMENT_orchestration.md` | For Agents relationship · subagent-first · effort · principles · workflow · autonomy |
| `SEGMENT_docs.md` | OS Structure & Index · one-time vs continuous · Documentation System · durable memory · stewardship |
| `SEGMENT_architect.md` | For Humans · How to work with this Architect |
| `SEGMENT_harness.md` | OpenSpec · harness MCP/DCP/smoke · Gist Sync · supported harnesses |

Protected contracts (must remain available on demand — do not delete from gist): Session Start/End, Local vs GitOps, health blockers, solo E2E, subagent-first, Documentation System, Gist Sync, OpenSpec, progressive disclosure, no local-only standing capability (catalog honesty).

---

# This Project

## This Project (quick facts)

- **Product:** Seam Cricket Academy — Bengaluru cricket coaching marketing & lead-generation site (`www.seamcricketacademy.com`). Showcases programs/batches, coaches, gallery, and converts visitors via contact form + WhatsApp.
- **Users:** Prospective players/parents discovering academy programs; academy staff receiving leads.
- **Stack:** Astro `^7` · Tailwind CSS 4 (`@tailwindcss/vite`) · GSAP · TypeScript · Node 22 · Biome 2.5.4
- **Deployment target:** GitHub Pages (`CNAME` → `www.seamcricketacademy.com`) · versioned **Release Tag Deploy** (`.github/workflows/release-tag-deploy.yml`) · non-release rebuild (`.github/workflows/rebuild-site.yml`)
- **Environment:** Node 22 (local Homebrew + CI) · no `.nvmrc` yet
- **GitHub Project V2:** `SEAM-ORG` project **#8** (`SeamFusionProject`) — shared board with SeamFusionServices · `.github/agent-project.yml` · agents use `scripts/github/*` (no Actions card-movers)
- **Relationship to SeamFusionServices:** **Shared board only** (SEAM-ORG/8) + **API consumer** of SeamFusion Cloud Functions (`PUBLIC_API_URL`, `PUBLIC_ACADEMY_ID`) for build-time public academy data. **No shared application code** — SCA is a standalone Astro marketing site.
- **Product truth:** `PROJECT_CONTEXT.md` · `docs/ROADMAP.md` · `docs/HISTORY.md` · `DESIGN_SYSTEM.md` · `DEPLOYMENT.md` · `src/data/academy.json` · `src/data/programs.ts` · `docs/INDEX.md`
- **SDD SoT:** **`openspec/`** only (`openspec/config.yaml`, `openspec/specs/`, `openspec/changes/`) · legacy `.kiro/` removed (migrated 2026-07-18)
- **Canonical commands:**
  - Install: `npm ci` then `bash scripts/install-githooks.sh`
  - Dev: `npm run dev`
  - Build: `npm run build`
  - Test: `npm test`
  - Smoke: `bash scripts/smoke.sh` (Session Start after health clear)
  - Lint/format: `npm run format` / `npm run lint` (**Biome**) · pre-commit via `~/.config/agent-quality`
  - Local CI quality: `npm run local-ci:quality`
  - Local CI correctness: `npm run local-ci:correctness`
  - Deploy: GitOps — Release Tag Deploy (`workflow_dispatch` / tag `v*.*.*`) or rebuild-site for data refresh
- **Code map:** `src/pages/index.astro` · `src/layouts/Layout.astro` · `src/components/*` (Hero, Programs, Coaches, ContactForm, FloatingWhatsApp, Gallery, …) · `src/data/academy.json` · `src/data/programs.ts` · `src/lib/seamfusion-api.ts` · `src/lib/validation.ts` · `src/styles/`
- **Hooks (local CI):** `.githooks/` + `scripts/install-githooks.sh` · gold standard · pre-commit → Biome + `scripts/check-memory-drift.sh` · pre-push → `npm test && npm run build`
- **GitHub:** `.github/workflows/release-tag-deploy.yml` + `rebuild-site.yml` (deploy/release only) · no PR lint/test Actions · Dependabot OK
- **External services:** SeamFusion Cloud Functions API (`PUBLIC_API_URL`, `PUBLIC_ACADEMY_ID`) · Web3Forms (contact dual-submit) · WhatsApp deep links (`wa.me` / `api.whatsapp.com`)
- **Harnesses:** **OpenCode desktop** (default product work) · **Grok Build** from `~/Projects` (Agent OS / machine) · same root `AGENTS.md` + global OpenSpec skills (`openspec-*` / `using-openspec`)
- **Durable docs:** `docs/INDEX.md` · `docs/specs/` · `docs/plans/` · `docs/archive/` · **`openspec/`**
- **Invariants:**
  - Dark glassmorphism + neon “Weightless/Kinetic” design (`DESIGN_SYSTEM.md`) — non-negotiable aesthetic
  - Feature icons: 3D emoji / transparent PNG, `w-16 h-16 object-contain`
  - Do not edit `backup-legacy/`
  - Do not commit video / media over ~50–90MB
  - Validate dynamic email/WhatsApp/URL links (`src/lib/validation.ts`)
  - Deploy workflows run from **repo root** (not a nested astro folder)
  - Build-time SeamFusion API must fail soft → static `academy.json` / `programs.ts` fallback
  - Public git/docs = product voice (no AI/agent language)
