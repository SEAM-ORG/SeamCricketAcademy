# Development commands (Seam Cricket Academy)

**Runtime:** Node **24** (`.nvmrc` · `engines: >=24 <25`). Homebrew `node@24` or nvm/fnm matching `.nvmrc`.

```bash
npm ci
npm run dev
npm run build
npm test
npm run lint
npm run format
npm run smoke
```

Deploy: GitOps only — **Release Tag Deploy** (`.github/workflows/release-tag-deploy.yml`) for versioned releases; **rebuild-site** for non-release data refresh. See `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md`.

## Session smoke

`npm run smoke` (or `bash scripts/smoke.sh`). Fast known-good — not a full release gate.
