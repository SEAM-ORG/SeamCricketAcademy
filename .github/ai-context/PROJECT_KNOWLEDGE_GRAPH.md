# Project Knowledge Graph

Seam Cricket Academy marketing site. Maps real entry points for agents.

## Product

- **What:** Official website for Seam Cricket Academy (Bengaluru cricket coaching).
- **Live:** https://www.seamcricketacademy.com
- **Hosting:** GitHub Pages via Actions (push to `main`, schedule, `repository_dispatch`, release).

## Stack

| Layer | Choice |
|-------|--------|
| Framework | Astro 6 (static) |
| CSS | Tailwind CSS 4 via `@tailwindcss/vite` |
| Animation | GSAP |
| Language | TypeScript |
| Tests | Node native `node --test` + `--experimental-strip-types` |
| CI Node | 22 |
| Forms | Web3Forms (contact) |
| Remote data | SeamFusion API at **build time** (`src/lib/seamfusion-api.ts`) |

## Directory map

```
/
├── AGENTS.md                 # Always-on Architect↔Agent OS
├── .github/
│   ├── ai-context/           # Principles, workflow, graph, journal
│   └── workflows/deploy.yml  # Pages build + deploy
├── .agents/skills/           # Optional domain skills
├── src/
│   ├── pages/index.astro     # Single landing page (route /)
│   ├── layouts/Layout.astro  # Shell, fonts, global CSS
│   ├── components/           # Section UI (*.astro)
│   ├── data/
│   │   ├── academy.json      # Static copy: hero, about, coaches, contact…
│   │   └── programs.ts       # Program cards data
│   ├── lib/
│   │   ├── seamfusion-api.ts # Build-time fetch (never throws)
│   │   └── validation.ts     # Email/WhatsApp link safety
│   └── styles/
│       ├── global.css
│       └── base.css
├── public/assets/            # Static images/icons
├── backup-legacy/            # DEPRECATED — do not edit
├── package.json
├── astro.config.mjs
├── DESIGN_SYSTEM.md
├── PROJECT_CONTEXT.md
└── CNAME                     # Custom domain for Pages
```

## Page composition (`src/pages/index.astro`)

Order of sections (approx):

1. `Navbar`
2. `Hero` (`#home`)
3. `Programs` (`#programs`)
4. `Coaches` (`#trainers`)
5. `AboutSection` (`#about`)
6. `WhyChooseUs`
7. `PlayerOfMonth`
8. `Gallery` (`#gallery`)
9. `Testimonials`
10. `ContactForm` (contact)
11. `Footer`
12. Supporting: `ScrollReveal`, `FloatingWhatsApp`, promo bars as used

## Key components

| File | Role |
|------|------|
| `Navbar.astro` | Top nav, scroll hide |
| `Hero.astro` | Full-screen CTA |
| `Programs.astro` | Coaching programs grid |
| `Coaches.astro` / `CoachesCarousel.astro` | Coach profiles |
| `Gallery.astro` | Media carousel |
| `ContactForm.astro` | Registration / contact |
| `FloatingWhatsApp.astro` | WhatsApp CTA |
| `GlassCard.astro` | Shared glass card shell |
| `ScrollReveal.astro` | GSAP reveal wiring |

## Data & integrations

| Source | Use |
|--------|-----|
| `src/data/academy.json` | Fallback/static marketing content |
| `src/data/programs.ts` | Programs list |
| `src/lib/seamfusion-api.ts` | Optional live academy data at build (`PUBLIC_API_URL`, `PUBLIC_ACADEMY_ID`) |
| `src/lib/validation.ts` | Sanitize dynamic `mailto:` / `wa.me` links |
| Web3Forms | Contact form submit (client) |

## Commands

| Intent | Command |
|--------|---------|
| Dev | `npm run dev` |
| Build | `npm run build` |
| Test | `npm test` |
| Preview | `npm run preview` |

## Deploy path

1. Merge to `main` (or schedule / dispatch / release)
2. `npm ci` → `npm run build` with repo vars
3. Copy `CNAME` → `dist/`
4. Upload Pages artifact → deploy

## Invariants

- Root is source of truth; ignore `backup-legacy/` and old `astro-revamp` docs paths.
- Design: dark glass + neon; icons `w-16 h-16 object-contain` transparent assets.
- Never commit secrets; env via GitHub vars / local `.env` (see `.env.example`).
- Stakeholder firewall on public git surfaces.
