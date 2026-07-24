# Deployment — Seam Cricket Academy

> **Last aligned:** 2026-07-24 · Workflow inventory: `docs/GITHUB_ACTIONS.md` · Product context: `PROJECT_CONTEXT.md`

## Repository & live site

| Item | Value |
| ---- | ----- |
| **GitHub** | [`SEAM-ORG/SeamCricketAcademy`](https://github.com/SEAM-ORG/SeamCricketAcademy) |
| **Live** | https://www.seamcricketacademy.com |
| **Hosting** | GitHub Pages |
| **Domain** | Root `CNAME` → `www.seamcricketacademy.com` (copied into `dist/` at build) |
| **Source of truth** | **Repo root** (Astro app lives here — not a nested `astro-revamp/` folder) |

## Layout (active)

```
SeamCricketAcademy/                 # repo root = active source
├── .github/workflows/
│   ├── release-tag-deploy.yml      # versioned release → Pages
│   └── rebuild-site.yml            # non-release data refresh
├── src/                            # Astro pages, components, data, lib
├── public/                         # static assets
├── CNAME                           # custom domain
├── package.json
├── astro.config.mjs
└── dist/                           # build output (gitignored; produced by CI/local)
```

## Deploy model

**Local gates = CI** (`npm run lint` · `npm test` · `npm run build`). GitHub Actions are **deploy/release only**. No tracked git hooks in this repo.

| Workflow | When | Role |
| -------- | ---- | ---- |
| **Release Tag Deploy** | `workflow_dispatch` (tag/ref) · push tags `v*.*.*` | Authorized versioned release → build → GitHub Pages + Release |
| **Rebuild Site** | `repository_dispatch` (`rebuild-site`) · weekly cron · manual | Data/gallery refresh **without** cutting a release |

Both workflows use **Node 24** and build from the **repo root** (`npm ci` · `npm run build`).

**Do not** reintroduce a `deploy.yml` that ships every `main` push as a “release.”

### How to cut a release (Architect-approved)

```bash
# Ensure CHANGELOG has ## [X.Y.Z] and package.json version is coherent, then:
gh workflow run "Release Tag Deploy" -R SEAM-ORG/SeamCricketAcademy \
  -f tag=vX.Y.Z -f ref=main
# or: git tag vX.Y.Z && git push origin vX.Y.Z
gh run list -R SEAM-ORG/SeamCricketAcademy --workflow "Release Tag Deploy" --limit 3
```

### Non-release rebuild

```bash
gh api repos/SEAM-ORG/SeamCricketAcademy/dispatches -f event_type=rebuild-site
```

## Local build check

```bash
npm ci
npm test
npm run build
# optional: cp CNAME dist/ when previewing Pages layout locally
```

## Pre-deploy checklist

- [ ] `npm run build` succeeds locally
- [ ] Visual check via `npm run dev` when UI changed
- [ ] No media ≳50–90MB committed
- [ ] Root `CNAME` present and correct
- [ ] SeamFusion env optional — build must fail soft to static data

## Critical notes

- **Root is SoT** — never treat nested legacy paths as the app.
- **Do not** manually upload to `gh-pages`; let Actions deploy.
- **Do not** commit secrets (`.env` is gitignored; see `.env.example`).
- Full workflow jobs/triggers: `docs/GITHUB_ACTIONS.md`.
