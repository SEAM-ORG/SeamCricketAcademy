# GitHub Actions inventory — Seam Cricket Academy

**Policy (Agent OS):** Local hooks = CI. GitHub Actions = **deploy/release** only.

## Tracked workflow (repo file)

| Workflow                         | Path                           | Triggers                                                                        | Verdict                                                         |
| -------------------------------- | ------------------------------ | ------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **Deploy Astro to GitHub Pages** | `.github/workflows/deploy.yml` | `push` main, release, `repository_dispatch` (rebuild-site), weekly cron, manual | **Keep** — real **deploy** to Pages (build+publish). Not PR CI. |

Build inside this job is **for the deploy artifact**, not a PR quality gate. Local hooks already run `npm test` + `npm run build` on pre-push.

## Platform / dynamic (not under `.github/workflows/`)

| Name                                   | Why it appears         | Verdict                                                                                     |
| -------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------- |
| **pages-build-deployment**             | GitHub Pages platform  | Usually tracks deployment events; do not add a second competing Pages source without intent |
| **CodeQL**                             | GitHub code scanning   | **Keep** — security, not PR lint/test mirror of hooks                                       |
| **Dependabot Updates**                 | Dependabot             | **Keep** — agent triages PRs value-first (rebase/fix/merge or close with evidence)          |
| **Copilot code review / coding agent** | GitHub Copilot product | Optional platform; not Agent OS CI                                                          |

## Agent duty

1. Session Start preflight lists open Dependabot PRs + failed Actions.
2. After merge to `main`, expect **Deploy Astro** run — if it fails, fix root cause same session when related to your change (or open Issue + board).
3. **Do not** add `.github/workflows/ci.yml` that re-runs lint/test/build already on hooks.
4. Open Dependabot PRs (#34, #35, #37 as of audit) need stewardship: update, verify locally, merge or close with reason — do not ignore forever.
