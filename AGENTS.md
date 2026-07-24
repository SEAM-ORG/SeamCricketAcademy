# Architect ↔ Agent Operating System (Agent OS)

> **Canonical master Gist (full contract):** https://gist.github.com/saadev0/5828479245f786c80993b67a6f669aee  
> **Raw:** https://gist.githubusercontent.com/saadev0/5828479245f786c80993b67a6f669aee/raw/AGENTS.md  
> This file is the **product hub**: always-on pointers + **This Project**. Full GitOps E2E = Gist **§2b**. Load the gist for full OS protocol.

## Always-on (product repo)

- **Feature branch only** — never commit/push on `main`. Branches: `feat|fix|chore|docs|refactor|test|perf|security/<issue-or-topic>-<slug>`.
- **Standing auth:** non-release PRs, merges, issues, refactors, deps, technical scope pre-approved. **Only** production release/deploy/tag needs Architect approval.
- **GitOps E2E (Gist §2b):** open PRs are this-turn work → review → **squash-merge** or close+rehome. One concern → one PR. Merge ≠ deploy.
- **Session re-ground:** `git status -sb` · `git fetch origin --prune` · `gh pr list --state open` → dispose blockers → sync `main` → feature branch.
- **Ship path:** feature branch → Issue (non-trivial) → implement + verify → `git push -u origin HEAD` → `gh pr create` with `Fixes #N` → squash-merge → delete branch → return clean `main`.
- **Local-first:** verify + commit on feature branch; push/PR when slice ready (or session end). Use `gh` + `git` directly (no `scripts/github/*` helpers in this repo).
- **Verify before done:** Biome → test → build (and `openspec validate --all` when specs change). Evidence, not vibes. Never `--no-verify` to skip real gates.
- **Biome** is sole JS/TS/CSS/JSON lint+format gate (`biome.json`).
- **OpenSpec** for non-trivial work: `/opsx-explore` → `/opsx-propose` → `/opsx-apply` → `/opsx-archive` (delivery: `commands`).
- **Stakeholder firewall:** no AI/agent/LLM language in commits, PR titles/bodies, public issues, or `CHANGELOG.md`.
- **Session closeout:** SHA · PR URL · branch · summary · status (`Completed` / `Blocked` / `Handoff-Only`) · next step. Open PRs disposed; no release/tag without Architect approval.
- **Skills:** machine-global only (`~/.agents/skills`). Do not vendor Agent OS skill trees into this repo.
- **Hosts:** OpenSpec adapters for **gemini · opencode · antigravity** only. Runtime config stays global (`~/.config/opencode/`).

---

# This Project

## Quick Facts

- **Product:** Seam Cricket Academy — Bengaluru cricket coaching marketing & lead-gen (`www.seamcricketacademy.com`)
- **Repo / package:** `SEAM-ORG/SeamCricketAcademy` · `seam-cricket-academy` · **app SoT = repo root** (not nested revamp paths)
- **Stack:** Astro 7 · Tailwind CSS 4 (`@tailwindcss/vite`) · GSAP · TypeScript · Biome 2.5.5
- **Runtime:** Node **24** (`.nvmrc` · `engines: >=24 <25` · CI `node-version: 24`)
- **Deploy:** GitHub Pages · root `CNAME` → `www.seamcricketacademy.com`
- **Release:** **Release Tag Deploy** (tag/`workflow_dispatch`) · non-release **Rebuild Site** (dispatch/cron/manual) — see `DEPLOYMENT.md`
- **Integrations:** SeamFusion public API (build-time) · Web3Forms · WhatsApp deep links
- **Board:** SEAM-ORG Project V2 **#8** (shared with SeamFusionServices) — API consumer + shared board only; **no shared app code**

## Canonical Commands

```bash
npm ci
npm run dev          # http://localhost:4321
npm test             # node:test — src/**/*.test.ts
npm run build        # astro build → dist/
npm run lint         # biome lint .
npm run format       # biome check --write .
npm run format:check # biome check .
npm run biome:ci     # biome ci .
npm run smoke        # bash scripts/smoke.sh (fast known-good)
openspec validate --all
openspec list --specs
# GitOps hygiene (dispose same turn):
gh pr list --state open
git fetch origin --prune
```

**PR ship:** feature branch → `gh pr create` with `Fixes #N` (+ Summary + Test plan) → squash-merge → delete remote branch → clean `main`.

**PR body minimum:**

```markdown
## Summary
- <what changed and why>

## Test plan
- [ ] <commands / evidence>

Fixes #<issue>
```

**Release (Architect-approved only):**

```bash
gh workflow run "Release Tag Deploy" -R SEAM-ORG/SeamCricketAcademy -f tag=vX.Y.Z -f ref=main
gh run list -R SEAM-ORG/SeamCricketAcademy --workflow "Release Tag Deploy" --limit 3
# non-release data refresh:
gh api repos/SEAM-ORG/SeamCricketAcademy/dispatches -f event_type=rebuild-site
```

**Optional env** (`.env` from `.env.example`): `PUBLIC_ACADEMY_ID`, `PUBLIC_API_URL` — build **fails soft** to static data if unset/down.

## Codebase Map

| Path | Role |
| ---- | ---- |
| `src/pages/index.astro` | Marketing home |
| `src/layouts/Layout.astro` | Shell |
| `src/components/*` | Hero, Programs, Coaches, Gallery, ContactForm, FloatingWhatsApp, … |
| `src/data/academy.json` · `programs.ts` | Static content + API fallback |
| `src/lib/seamfusion-api.ts` | Build-time SeamFusion client (never throws) |
| `src/lib/validation.ts` | Email / WhatsApp / URL safety |
| `src/styles/{global,base}.css` | Theme tokens |
| `openspec/` | SDD memory SoT (`config.yaml`, `specs/`, `changes/`) |
| `docs/INDEX.md` | Doc map · `PROJECT_CONTEXT.md` product brief · `DESIGN_SYSTEM.md` visual rules |
| `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md` | Release / deploy GitOps entrypoints |

**OpenSpec capabilities:** `academy-marketing-ux` · `program-catalog` · `coach-profiles` · `lead-generation` · `seamfusion-api-sync`

**Host adapters (commands delivery):** `.opencode/commands/opsx-*.md` · `.gemini/commands/opsx/` · `.agent/workflows/opsx-*.md` — refresh via `openspec update`.

## Invariants

1. **Design:** Weightless/Kinetic dark glassmorphism + neon — `DESIGN_SYSTEM.md` non-negotiable. Feature icons: 3D/transparent PNG, `w-16 h-16 object-contain`.
2. **SeamFusion fail-soft:** API down/missing env → static `academy.json` / `programs.ts`; never break the static site.
3. **Link safety:** Validate dynamic email/WhatsApp/URL via `src/lib/validation.ts` before emit.
4. **Root is SoT:** Do not treat nested legacy / `backup-legacy/` as active source. Do not commit media ≳50–90MB or secrets.
5. **Local gates = CI:** run `npm run lint` · `npm test` · `npm run build` before ship. No PR lint/test Actions. GHA = deploy/release only (`release-tag-deploy.yml`, `rebuild-site.yml`).
6. **GitOps E2E (Gist §2b):** feature branch only; open PRs this-turn; squash-merge; merge ≠ deploy; production release/tag only with Architect approval.
7. **No freestyle prod deploy:** No manual `gh-pages` upload; follow `DEPLOYMENT.md` / Release Tag Deploy only.
8. **Public voice:** Product language only in git/docs facing stakeholders.
9. **No second skill/SDD tree:** No project `.agents/` skill dumps; SDD lives only under `openspec/`.
