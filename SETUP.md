# Setup — Seam Cricket Academy

> Get the marketing site running locally.  
> Product brief: `PROJECT_CONTEXT.md` · Deploy: `DEPLOYMENT.md` · Agent contract: `AGENTS.md`

## Prerequisites

- **Node.js 24** (see `.nvmrc` · `package.json` engines `>=24 <25`)
- **npm** (bundled with Node)
- **Git**

## Install

```bash
git clone https://github.com/SEAM-ORG/SeamCricketAcademy.git
cd SeamCricketAcademy
npm ci
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
npm run smoke
```

| Action | Command |
| ------ | ------- |
| Format | `npm run format` |
| Format check | `npm run format:check` |
| Biome CI gate | `npm run biome:ci` |
| OpenSpec | `openspec validate --all` |

## Deploy

Do **not** treat every `main` push as a release. Use GitOps:

- **Release Tag Deploy** — versioned Pages release
- **rebuild-site** — non-release data refresh

Details: `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md`.

## Agent configuration

| Surface | Where |
| ------- | ----- |
| Always-on contract | root `AGENTS.md` (thin hub + **This Project**) · full OS = master Gist |
| Skills | machine-global only — `~/.agents/skills/` |
| OpenCode runtime | `~/.config/opencode/` |
| SDD memory | `openspec/` only |
| Host adapters | `.opencode/commands/opsx-*` · `.gemini/commands/opsx/` · `.agent/workflows/opsx-*` |

**Do not** vendor portable Agent OS skill bodies into this repo or invent a second SDD tree outside `openspec/`.
