# Project Knowledge Graph

Agent context routing for SeamCricketAcademy. Load the relevant domain only.

### Marketing site
`src/pages/index.astro` · `src/layouts/Layout.astro` · `src/components/*` (Hero, Navbar, Programs, Gallery, ContactForm, …)

### Design system
`DESIGN_SYSTEM.md` · `src/styles/global.css` · `src/styles/base.css` · GSAP scroll reveals (`ScrollReveal.astro`)

### Data & integrations
`src/data/academy.json` · `src/data/programs.ts` · `src/lib/seamfusion-api.ts` · `src/lib/validation.ts` · `.env.example`

### Deploy
`.github/workflows/deploy.yml` · `CNAME` · `DEPLOYMENT.md`

### Legacy (do not edit)
`backup-legacy/` · root `assets/` (legacy)

### Agent OS
`AGENTS.md` · `.github/ai-context/*` · `.agents/skills/`

### Quality
`.husky/pre-commit` · `.husky/pre-push` · `npm test` · `npm run build` · Local CI: hooks (no GitHub PR CI)
