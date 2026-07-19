# Project Knowledge Graph

Agent context routing for SeamCricketAcademy. Load the relevant domain only.  
**Last aligned:** 2026-07-19 · Repo root is app SoT · Live: https://www.seamcricketacademy.com

### Marketing site

`src/pages/index.astro` · `src/layouts/Layout.astro` · `src/components/*` (Hero, Navbar, Programs, Gallery, ContactForm, FloatingWhatsApp, Coaches, SummerCampPromo, …)

### Design system

`DESIGN_SYSTEM.md` · `src/styles/global.css` · `src/styles/base.css` · GSAP scroll reveals (`ScrollReveal.astro`)

### Data & integrations

`src/data/academy.json` · `src/data/programs.ts` · `src/lib/seamfusion-api.ts` · `src/lib/validation.ts` · `.env.example`

### Deploy

`.github/workflows/release-tag-deploy.yml` · `.github/workflows/rebuild-site.yml` · `CNAME` · `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md` · Node **22** (`.nvmrc`)

### Legacy (do not edit)

`backup-legacy/` · root `assets/` if present (legacy)

### Agent OS + OpenSpec

`AGENTS.md` (This Project) · `openspec/` (sole SDD SoT — five capabilities) · `.github/ai-context/*` · `docs/INDEX.md` · `docs/ROADMAP.md` · `docs/HISTORY.md` · `tasks/*`  
Skills are **machine-global only** (`~/.agents/skills`) — no project `.agents/`.  
`.opencode/README.md` is a pointer only; runtime config is `~/.config/opencode/`.

### Quality

Gold standard: pre-commit=quality, pre-push=test+build. `.githooks/*` · `npm test` · `npm run build` · `bash scripts/smoke.sh` · Local CI only (no GitHub PR CI)

### Durable docs

`docs/specs/` · `docs/plans/` · `docs/archive/` · **`openspec/specs/`** (capability requirements)

### Agent harness

**OpenCode** (product) · **Grok Build** (OS/machine). Single OS: `AGENTS.md`. Methodology: OpenSpec (`openspec-*` / `using-openspec`).
