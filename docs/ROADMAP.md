# Seam Cricket Academy — Roadmap

> **Master phase plan** for the academy marketing & lead-generation site.  
> **Last aligned:** 2026-07-24 · **Session journal:** `docs/HISTORY.md` · **Product context:** `PROJECT_CONTEXT.md`

## Current status

| Metric | Value |
| ------ | ----- |
| **Live site** | https://www.seamcricketacademy.com |
| **Stack** | Astro 7 · Tailwind CSS 4 · TypeScript · Biome · Node 24 |
| **Release model** | Release Tag Deploy + non-release Pages rebuild |
| **Current phase** | Phase 6 — content & conversion continuous improvement |
| **Latest tag** | v2.4.0 (see GitHub Releases / `CHANGELOG.md`) |
| **Tracking** | GitHub Issues + PRs (no Projects board) |

## Phase table

| Phase | Name | Status |
| :---: | :--- | :----- |
| 1 | Static brand presence | ✅ Complete |
| 2 | Astro revamp & design system | ✅ Complete |
| 3 | SeamFusion data + lead pipeline | ✅ Complete |
| 4 | Conversion UX (Summer Camp, forms, hardening) | ✅ Complete |
| 5 | Agent OS, OpenSpec, release hygiene | ✅ Complete (maintain) |
| 6 | Content & conversion continuous improvement | 🔵 Active |

---

### Phase 1: Static brand presence ✅

Initial academy website and domain presence for Bengaluru cricket coaching brand.

### Phase 2: Astro revamp & design system ✅

- Marketing site rebuilt on Astro at **repo root** (nested legacy revamp removed).
- Non-negotiable dark glassmorphism / neon “weightless” aesthetic (`DESIGN_SYSTEM.md`).
- Programs, coaches, gallery, contact, WhatsApp entry points.

### Phase 3: SeamFusion data + lead pipeline ✅

- Build-time public academy data from SeamFusion Cloud Functions with static fallback.
- Contact dual-submit / CRM-oriented lead path; phone and link validation hardening.

### Phase 4: Conversion UX ✅

- Summer Camp emphasis and program catalog expansions.
- Form spam controls, layout polish, admissions-season content updates.

### Phase 5: Agent OS, OpenSpec, release hygiene ✅ (maintain)

- Portable Architect↔Agent OS; local Biome gates; Issues/PRs for tracking (no Projects board).
- OpenSpec living capabilities for marketing UX, catalog, coaches, leads, API sync.
- Release Tag Deploy standard; session journal + thin Wiki as continuous surfaces.

### Phase 6: Content & conversion continuous improvement 🔵 ACTIVE

- Program/batch/season content updates as academy operations dictate.
- Optional UX polish and a11y/perf improvements without redesigning the brand system.
- Keep OpenSpec specs honest when capabilities change; no parallel methodology trees.

## Success metrics (product)

- Leads reach academy staff reliably (form + WhatsApp).
- Site stays on-brand per design system.
- Build fails soft when SeamFusion API is unavailable (static fallback).
- Public git/docs remain product voice (no agent ceremony language).
