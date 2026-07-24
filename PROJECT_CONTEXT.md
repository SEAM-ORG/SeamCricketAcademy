# Project Context — Seam Cricket Academy

> Product truth brief for the marketing & lead-generation site.  
> **Last aligned:** 2026-07-19 (memory honesty) · **Roadmap:** `docs/ROADMAP.md` · **Session journal:** `docs/HISTORY.md` · **Repo:** `SEAM-ORG/SeamCricketAcademy`

## 1. Product

**Seam Cricket Academy** — Bengaluru cricket coaching marketing site (`www.seamcricketacademy.com`).  
Showcases programs/batches, coaches, gallery; converts visitors via contact form and WhatsApp.

| Audience | Need |
| -------- | ---- |
| Prospective players / parents | Discover programs, trust brand, inquire |
| Academy staff | Receive leads and inquiries |

## 2. Stack & deploy

| Layer | Choice |
| ----- | ------ |
| Framework | Astro **7** · Tailwind CSS **4** · TypeScript · GSAP |
| Quality | Biome **2.5.5** · Node **24** (`.nvmrc` · engines `>=24 <25`) · local Biome/test/build gates |
| Hosting | GitHub Pages · CNAME → `www.seamcricketacademy.com` |
| Release | **Release Tag Deploy** + non-release `rebuild-site` (see `DEPLOYMENT.md`) |
| Integrations | Public academy API (build-time) · Web3Forms · WhatsApp deep links |
| Package | `seam-cricket-academy` · app at **repo root** |

## 3. Mandates (non-negotiable)

- **Value-first UX** within the **weightless / kinetic** dark glassmorphism design (`DESIGN_SYSTEM.md`).
- Feature icons: 3D emoji / transparent PNG, `w-16 h-16 object-contain`.
- **Repo root** is the source of truth — do not edit retired `backup-legacy/` or nested revamp paths.
- Validate dynamic email / WhatsApp / URL links before emit.
- Public academy API must **fail soft** → static `academy.json` / `programs.ts` fallback.
- Public git and docs = **product voice** (no agent ceremony language).

## 4. Key surfaces

| Path | Role |
| ---- | ---- |
| `src/pages/index.astro` | Marketing home |
| `src/components/*` | Hero, Programs, Coaches, Gallery, Contact, WhatsApp, … |
| `src/data/academy.json` · `programs.ts` | Static content + API fallback |
| `src/lib/seamfusion-api.ts` · `validation.ts` | API client · link safety |
| `openspec/` | Sole SDD memory |
| `docs/INDEX.md` | Doc map |
| `docs/ROADMAP.md` · `docs/HISTORY.md` | Phases · session journal |
| GitHub Project V2 | SEAM-ORG **#8** (issue tracking only) |

## 5. Canonical commands

| Action | Command |
| ------ | ------- |
| Install | `npm ci` |
| Dev | `npm run dev` → http://localhost:4321 |
| Build / test / smoke | `npm run build` · `npm test` · `npm run smoke` |
| Lint / format | `npm run lint` · `npm run format` (Biome) |

## 6. External data (optional)

- Build-time fetch of public academy content via `PUBLIC_API_URL` + `PUBLIC_ACADEMY_ID` (`src/lib/seamfusion-api.ts`).
- **Standalone product:** no shared app code or deploy pipeline with other repos. API down → static `src/data/*` fallback.
