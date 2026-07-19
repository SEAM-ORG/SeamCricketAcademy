# Setup — Seam Cricket Academy

> Get the marketing site running locally. **Last aligned:** 2026-07-19  
> Product brief: `PROJECT_CONTEXT.md` · Deploy: `DEPLOYMENT.md` · Agent contract: `AGENTS.md`

## Prerequisites

- **Node.js 22** (see `.nvmrc`) — Homebrew `brew install node@22` or [nodejs.org](https://nodejs.org/)
- **npm** (bundled with Node)
- **Git**

## Install

```bash
git clone https://github.com/SEAM-ORG/SeamCricketAcademy.git
cd SeamCricketAcademy
npm ci
bash scripts/install-githooks.sh
```

Optional env (SeamFusion build-time public data): copy `.env.example` → `.env`.  
Build **fails soft** to static `src/data/*` when the API is unavailable.

## Develop

```bash
npm run dev
# → http://localhost:4321
```

## Verify

```bash
npm test
npm run build
npm run lint
bash scripts/smoke.sh
```

| Action | Command |
| ------ | ------- |
| Format | `npm run format` |
| Local CI quality | `npm run local-ci:quality` |
| Local CI correctness | `npm run local-ci:correctness` |

## Deploy

Do **not** treat every `main` push as a release. Use GitOps:

- **Release Tag Deploy** — versioned Pages release
- **rebuild-site** — non-release data refresh

Details: `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md`.

## Agent configuration

Agent configuration is **not** vendored into this repository.

| Surface | Where |
| ------- | ----- |
| Always-on contract | root `AGENTS.md` (thin hub + **This Project**) |
| Skills | machine-global only — `~/.agents/skills/` |
| OpenCode runtime | `~/.config/opencode/` |
| SDD memory | `openspec/` only |

**Do not** create project `.agents/`, `.agent/`, `opencode.json(c)`, or a second SDD tree.
