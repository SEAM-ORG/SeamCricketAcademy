# Development commands (Seam Cricket Academy)

```bash
npm ci
bash scripts/install-githooks.sh
npm run dev
npm run build
npm test
npm run local-ci:quality
npm run local-ci:correctness
```

Deploy: merge to `main` → `.github/workflows/deploy.yml` (GitHub Pages). See `DEPLOYMENT.md`.
