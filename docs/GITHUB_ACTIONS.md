# GitHub Actions inventory — Seam Cricket Academy

**Policy (Agent OS):** Local hooks = CI. GitHub Actions = **deploy/release** only.

## Tracked workflows

| Workflow | Path | Triggers | Verdict |
|----------|------|----------|---------|
| **Release Tag Deploy** | `.github/workflows/release-tag-deploy.yml` | `workflow_dispatch` (tag/ref) · `push` tags `v*.*.*` | **Keep** — authorized versioned release (SFS Universal Release Pattern) |
| **Rebuild Site (non-release)** | `.github/workflows/rebuild-site.yml` | `repository_dispatch` (`rebuild-site`), weekly cron, manual | **Keep** — data/gallery refresh without cutting a release |

## Universal Release Pattern (aligned with SeamFusionServices)

```
resolve → deploy-web (GitHub Pages + Deployments API env "Web") → finalize
  (create tag if missing · GitHub Release + CHANGELOG notes · Platform Status table)
```

| Job | Role |
|-----|------|
| `resolve` | Tag `vX.Y.Z` from input, package.json, or latest CHANGELOG; resolve SHA |
| `deploy-web` | Build Astro · Pages artifact · `deploy-pages` · Deployment status |
| `finalize` | Tag push · `gh release` · platform status markers |

**Not PR CI.** Local pre-push already runs `npm test` + `npm run build`.

## How to release (Architect-approved)

```bash
# 1. Ensure CHANGELOG has ## [X.Y.Z] and package.json version is coherent
# 2. From Actions → Release Tag Deploy → Run workflow
#    (or: git tag vX.Y.Z && git push origin vX.Y.Z)
gh workflow run "Release Tag Deploy" -R SEAM-ORG/SeamCricketAcademy \
  -f tag=v2.3.0 -f ref=main
gh run list -R SEAM-ORG/SeamCricketAcademy --workflow "Release Tag Deploy" --limit 3
```

## Non-release rebuild

Used when CMS/gallery data changes without a product version:

```bash
# From SeamFusion or manual:
gh api repos/SEAM-ORG/SeamCricketAcademy/dispatches \
  -f event_type=rebuild-site
```

## Platform / dynamic (not under workflows/)

| Name | Verdict |
|------|---------|
| pages-build-deployment | Platform Pages helper |
| CodeQL / Dependabot / Copilot | Security/deps — not product CI |

## Agent duty

1. Session Start: preflight failed Actions + bot PRs.
2. After Architect release approval: run/monitor **Release Tag Deploy**; never claim ship without run evidence.
3. Do **not** reintroduce `deploy.yml` that ships every `main` push as a “release.”
4. Do **not** add PR lint/test Actions that duplicate hooks.
