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
| **Hermes harness** | Primary agent runtime + thin always-on | gist `63515b95…` → `~/.hermes` machine kit; product hub = this file |

No project `.agents/`, slash-command ceremony trees, or second always-on OS file beyond the always-on card (same text as `ALWAYS_ON.md` / Hermes `SOUL` supplements).

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
| `63515b95a07195d149e3308998d18f77` | Hermes machine kit (auth/runtime glue) |
| `63515b95a07195d149e3308998d18f77` | Hermes machine kit (**legacy**) |
| `a81a271401b3cba04ef6f700dfc8d225` | Legal/business advisory (not OS) |
| `f1c2ab293cf8996b787eedf94ec60029` | Product-ops status JSON (not OS) |

**Pollution rule:** OS + machine kits stay **portfolio-agnostic**. Product repos, orgs, board numbers live only in **This Project** / product docs / `.github/agent-project.yml`.

**Local kit trees are not second SoTs.** Promote universal harness/OS changes to the correct gist same session. Standing machine packs are listed in `CATALOG.md` with install paths.

---

# PROTOCOL ENFORCEMENT (ALWAYS-ON — non-skippable)

**Canonical always-on SoT** for Architect↔Agent OS (root `AGENTS.md` & `ALWAYS_ON.md (product hub + Hermes SOUL)`).
Full contract: gist `saadev0/5828479245f786c80993b67a6f669aee` segments & skills.
You operate under **Architect↔Agent OS**. These protocols override convenience.

## Always-on card (every turn — keep this short)

**Load order:** this card → task skill → segment / skill only on demand (never re-read full OS).
**Context load:** this card + task skill + **This Project** + relevant docs. No full segments.
**Solo operator:** finish end-to-end this session. HOLD only if externally blocked.
**Health blockers are this-turn work:** dispose open PRs, remote orphans, red CI, local WIP ahead, unconfigured Project V2 (`project_number: 0`) in the same turn. No inventory without disposition.
**Standing authorization:** All agent actions (non-release PRs, merges, issues, boards, migrations, config, secrets, technical/taste/scope decisions) are pre-approved without approval pauses. ONLY initiating/executing production release/deployment or creating/pushing its release tag requires explicit Architect approval. ASK only for missing indispensable facts or external blockers, never permission for non-release work.

| When | Do |
|------|-----|
| Open/re-ground | **`session-start`**: preflight (exit 2 = dispose blockers) → **clean `main`** → Issue + **feature branch** → smoke |
| Non-trivial ask | **Proactive OpenSpec**: Explore (`openspec-explore`) → Propose (`openspec-propose`) → Apply (`openspec-apply-change`) → Archive |
| Multi-step/heavy | **Subagent-first**: Spawn tasks; orchestrate + synthesize. Primary never solo-monoliths |
| Writing code | **Feature branch only** (hooks refuse main) · approved tasks → `openspec-apply-change` |
| JS/TS/CSS/HTML | **Biome** — `format.sh --changed` · `check.sh` |
| Any change | Verify · same-branch memory (`openspec/`/INDEX/lessons) · local commit · never bypass hooks |
| Ship / end | **`session-end`**: ship-unit (PR+labels+Project status) → close Issues → prune orphans → **return-to-main exit 0** |
| Third-party/UI | Live docs MCP (**Context7** or equiv.) · UI evidence via browser tools |
| Non-trivial ship | Writer ≠ reviewer (fresh subagent / independent pass) |
| Repeated mistake | Sensors ratchet: lesson → AGENTS line → hook/lint |

### Context Budget & Delegation Policy
- **Primary:** Orchestrates decisions, safety, validation, and synthesis.
- **Workers:** Delegate non-trivial tool-heavy discovery, browser, test, and GitOps runs. Prefer repo scripts and batched commands. Workers write digests <=25 lines or 2KB. No raw DOM, build, test, or log dumps in primary.
- **Phases:** Compress closed phases in memory.

### Closeout Templates (fill briefly, no code blocks)
- **Turn-end closeout:** Summary, Status, Evidence, Git (branch, hash, uncommitted), Health (clear/disposed), Memory (yes/no), Next.
- **Session-end closeout:** Summary, Status, Evidence, PRs/Issues/Milestones, Project V2, Health, Main (clean/ff origin?), Branches pruned (local+remote), Next session.

### Hard rules & Pointers (every turn)
1. **Never commit or push on `main`** — feature branch only.
2. **Standing authorization & Gating:** Non-release PRs/merges/issues/boards/migrations/config/secrets/scope pre-approved. ONLY production release/deploy/tag execution is gated. ASK only for missing indispensable facts/blockers.
3. **GitOps:** Session Start → health clear → clean main → branch. Session End → ship-unit → prune → return-to-main.
4. **Project V2:** `.github/agent-project.yml` has real `project_owner`/`project_number` (never `0`).
5. **Local hooks = CI:** Release Tag Deploy only. No PR Actions.
6. **Memory same change:** `openspec/` · INDEX · This Project · lessons.
7. **Evidence before done:** "Seems right" is not done.
8. **Gist hygiene:** clone → edit → commit → push. First line of hub must be `# Architect…`.
9. **Project Isolation:** OS/kit stay portfolio-agnostic. No product names in gist.
10. **Skill Routing:** Start (`session-start`), End (`session-end`), Bootstrap (`agent-os-bootstrap`), Router (`using-openspec`).
11. **Project Map:** Root `AGENTS.md` (thin hub), `openspec/` (SoT), `docs/INDEX.md`, `tasks/lessons.md` (lessons), `scripts/github/*`.

### Contract failures
Skip closeout · skip Session Start · skip health gate · no evidence · doc drift · hook bypass · commit on main · leave branch at end · remote orphans · `project_number: 0` · open PR inventory without disposition · invent PR CI Actions · solo-monolith multi-step · dump OS monolith into product root · product names in portfolio-agnostic OS/kit · asking approval for pre-approved non-release work.

---
## Harness routing (Architect default)

| Work | Where | Agent behavior |
|------|-------|----------------|
| **Product work** | **Hermes** desktop/CLI, cwd = product repo | Session Start → ship; this hub + **This Project** |
| **IDE-native coding assist** | Google IDE (desktop), same repo | Optional worker surface; does not replace Session Start/End |
| **Agent OS / machine / portfolio** | **Hermes** from `~/Projects` or home | OS/machine kits; gists; multi-repo sync |

## Intent over literalism

Enhance short prompts with repo evidence. Maximum effort end-to-end. Proactive autonomy on docs/OS/hooks. Taste, release timing, irreversible pivots stay with the Architect.

## Extend existing first

Find → extend → create only if no home. No duplicate OS skills, no mirror skill trees into harness-private folders, no product skill trees.

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

- **Product:** Seam Cricket Academy — Bengaluru cricket coaching marketing & lead-generation site (`www.seamcricketacademy.com`). Showcases programs/batches, coaches, gallery; converts via contact form + WhatsApp.
- **Users:** Prospective players/parents discovering programs; academy staff receiving leads.
- **Repo:** `SEAM-ORG/SeamCricketAcademy` · package name `seam-cricket-academy` · **source of truth = repo root** (not nested `astro-revamp/`)
- **Stack:** Astro `^7.0.9` · Tailwind CSS 4 (`tailwindcss` + `@tailwindcss/vite`) · GSAP `^3.15` · TypeScript `^6` · Node **22** · Biome **2.5.4**
- **Deployment:** GitHub Pages · `CNAME` → `www.seamcricketacademy.com` · **Release Tag Deploy** (`.github/workflows/release-tag-deploy.yml`: `workflow_dispatch` / tags `v*.*.*`) · non-release rebuild (`.github/workflows/rebuild-site.yml`: dispatch / weekly cron / manual)
- **Environment:** Node 22 (`.nvmrc` + CI `node-version: 22`) · local Homebrew OK
- **GitHub Project V2:** `SEAM-ORG` **#8** (`SeamFusionProject`) — shared board with SeamFusionServices · `.github/agent-project.yml` · `scripts/github/*` only (no Actions card-movers)
- **SeamFusionServices:** **Shared board only** + **API consumer** (`PUBLIC_API_URL`, `PUBLIC_ACADEMY_ID`) for build-time public academy data · **no shared app code**
- **Product truth:** `PROJECT_CONTEXT.md` · `docs/ROADMAP.md` · `docs/HISTORY.md` · `DESIGN_SYSTEM.md` · `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md` · `src/data/academy.json` · `src/data/programs.ts` · `docs/INDEX.md`
- **SDD SoT:** **`openspec/`** only (`config.yaml`, `specs/`, `changes/`) · capabilities: `academy-marketing-ux` · `program-catalog` · `coach-profiles` · `lead-generation` · `seamfusion-api-sync` · no `.kiro/`
- **Canonical commands:**
  - Install: `npm ci` then `bash scripts/install-githooks.sh` (`prepare` also installs hooks)
  - Dev: `npm run dev` → http://localhost:4321
  - Build / test / smoke: `npm run build` · `npm test` · `bash scripts/smoke.sh`
  - Lint/format: `npm run format` / `npm run lint` (**Biome**)
  - Local CI: `npm run local-ci:quality` · `npm run local-ci:correctness`
  - Deploy: GitOps only — Release Tag Deploy or rebuild-site (never direct `main` push-as-release)
- **Code map:** `src/pages/index.astro` · `src/layouts/Layout.astro` · `src/components/*` (Hero, Programs, Coaches, ContactForm, FloatingWhatsApp, Gallery, …) · `src/data/*` · `src/lib/seamfusion-api.ts` · `src/lib/validation.ts` · `src/styles/{global,base}.css`
- **Hooks (local CI):** `.githooks/` + `scripts/install-githooks.sh` · pre-commit → Biome + `scripts/check-memory-drift.sh` · pre-push → `npm test && npm run build`
- **GitHub Actions:** deploy/release only (`release-tag-deploy.yml`, `rebuild-site.yml`) · no PR lint/test Actions · Dependabot OK
- **External services:** SeamFusion Cloud Functions · Web3Forms (contact dual-submit) · WhatsApp (`wa.me` / `api.whatsapp.com`)
- **Harnesses:** **Hermes** desktop/CLI (primary product + OS work) · Google IDE (Antigravity) design-only · skills machine-global only (`~/.agents/skills`)
- **Durable docs:** `docs/INDEX.md` · `docs/specs/` · `docs/plans/` · `docs/archive/` · **`openspec/`** · thin GitHub Wiki (product index only; repo docs remain SoT)
- **Invariants:**
  - Dark glassmorphism + neon “Weightless/Kinetic” (`DESIGN_SYSTEM.md`) — non-negotiable
  - Feature icons: 3D emoji / transparent PNG, `w-16 h-16 object-contain`
  - Do not edit `backup-legacy/` · do not commit media ≳50–90MB
  - Validate dynamic email/WhatsApp/URL links (`src/lib/validation.ts`)
  - Deploy workflows run from **repo root**
  - SeamFusion API **fail soft** → static `academy.json` / `programs.ts`
  - Public git/docs = product voice (no AI/agent ceremony language)
  - No project `.agents/`, second SDD tree, or `project_number: 0`
