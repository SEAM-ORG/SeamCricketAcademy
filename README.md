# Seam Cricket Academy 🏏

> **Train Hard. Play Smart. Rise Higher.**

Official website for Seam Cricket Academy — Bengaluru cricket coaching marketing & lead generation (`www.seamcricketacademy.com`).

![Astro](https://img.shields.io/badge/Astro-7-BC52EE?style=flat&logo=astro&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4-38B2AC?style=flat&logo=tailwind-css&logoColor=white)
![Node](https://img.shields.io/badge/Node-24-339933?style=flat&logo=node.js&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red)

**Live:** https://www.seamcricketacademy.com  
**Repo:** [SEAM-ORG/SeamCricketAcademy](https://github.com/SEAM-ORG/SeamCricketAcademy)

## Features

- Dark glassmorphism “Weightless/Kinetic” aesthetic with neon accents
- Responsive marketing home (programs, coaches, gallery, contact)
- GSAP scroll-triggered reveals
- WhatsApp deep links + contact form (Web3Forms dual-submit path)
- Build-time SeamFusion public API with static data fallback

## Tech stack

| Technology | Purpose |
| ---------- | ------- |
| [Astro 7](https://astro.build) | Static site generator |
| [Tailwind CSS 4](https://tailwindcss.com) | Utility-first styling |
| [GSAP](https://greensock.com/gsap/) | Animation library |
| [Biome](https://biomejs.dev) | Format + lint |
| [Web3Forms](https://web3forms.com) | Form submission |

## Project structure

```
SeamCricketAcademy/          # repo root = active Astro app
├── src/
│   ├── components/          # Hero, Programs, Coaches, Gallery, Contact, …
│   ├── layouts/
│   ├── pages/               # index.astro
│   ├── styles/
│   ├── data/                # academy.json, programs.ts
│   └── lib/                 # seamfusion-api, validation
├── public/
├── openspec/                # SDD memory (sole methodology tree)
├── docs/                    # INDEX, ROADMAP, HISTORY, ops
├── .github/workflows/       # Release Tag Deploy + rebuild-site
└── CNAME
```

## Getting started

### Prerequisites

- Node.js **24** (see `.nvmrc`)
- npm

### Install & develop

```bash
git clone https://github.com/SEAM-ORG/SeamCricketAcademy.git
cd SeamCricketAcademy
npm ci
npm run dev
```

Dev server: http://localhost:4321

### Build, test, quality

```bash
npm test
npm run build
npm run lint
npm run format
npm run smoke
```

## Deploy

GitHub Pages via **Release Tag Deploy** (versioned) or **rebuild-site** (data refresh).  
See [`DEPLOYMENT.md`](DEPLOYMENT.md) and [`docs/GITHUB_ACTIONS.md`](docs/GITHUB_ACTIONS.md).

## Key components

| Component | Description |
| --------- | ----------- |
| `Hero.astro` | Full-screen hero + CTA |
| `Programs.astro` | Coaching programs grid |
| `Coaches.astro` | Coach profiles |
| `Gallery.astro` | Media carousel |
| `ContactForm.astro` | Lead form (Web3Forms) |
| `FloatingWhatsApp.astro` | WhatsApp entry |

## Design system

Non-negotiable visual rules: [`DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md).

| Token | Value | Usage |
| ----- | ----- | ----- |
| `void` | `#030305` | Background |
| `depth` | `#0A0A0F` | Cards/surfaces |
| `neon` | `#4285F4` | Accent/CTAs |
| `surface` | `rgba(255,255,255,0.03)` | Glass panels |

## Docs map

| Doc | Role |
| --- | ---- |
| [`PROJECT_CONTEXT.md`](PROJECT_CONTEXT.md) | Product brief |
| [`docs/INDEX.md`](docs/INDEX.md) | Master doc index |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Phase table |
| [`docs/HISTORY.md`](docs/HISTORY.md) | Session journal |
| [`AGENTS.md`](AGENTS.md) | Agent OS + This Project |
| [`openspec/`](openspec/) | Spec-driven memory (SoT) |

## Contact

- **Website:** [seamcricketacademy.com](https://www.seamcricketacademy.com)
- **WhatsApp:** +91 89511 91375
- **Email:** seamcricketacademy@gmail.com
- **Location:** Bengaluru, Karnataka

---

© 2026 Seam Cricket Academy. All rights reserved.
