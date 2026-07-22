# Development commands (Seam Cricket Academy)

**Runtime:** Node **24** Active LTS (`.nvmrc`). Install via Homebrew `node@24` (linked) or nvm/fnm matching `.nvmrc`.


```bash
npm ci
bash scripts/install-githooks.sh
npm run dev
npm run build
npm test
npm run local-ci:quality
npm run local-ci:correctness
```

Deploy: GitOps only — **Release Tag Deploy** (`.github/workflows/release-tag-deploy.yml`) for versioned releases; **rebuild-site** for non-release data refresh. See `DEPLOYMENT.md` · `docs/GITHUB_ACTIONS.md`.

## Session smoke

After Session Start health clear: `bash scripts/smoke.sh` (or `npm run smoke` when defined). Fast known-good — not full pre-push.
