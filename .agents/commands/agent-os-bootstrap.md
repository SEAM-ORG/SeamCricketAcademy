---
description: Install/repair/sync Architect↔Agent OS from Gist (preserve This Project)
---

Install or repair **Agent OS** for this repo (not a daily status check — use `/boot` or `/start` for that).

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Materialize/sync root `AGENTS.md` OS body; **preserve This Project**.
3. Durable docs: `docs/INDEX.md`, `docs/{specs,plans,archive}/` as needed.
4. Project surfaces (single source of truth):
   - `.agents/commands/` (workflows) + `.opencode/command` → symlink
   - `.agents/skills/` (project-only skills if any) + `.opencode/skills` → symlink
   - `.agents/vendor/agent-skills` git submodule + `opencode.jsonc` `skills.paths`
5. Local CI: `.githooks/` + `bash scripts/install-githooks.sh`
6. GitHub hygiene: `scripts/github/*` + `.github/agent-project.yml` when the product uses Projects
7. Verify: hooks installed; `opencode debug skill` sees vendor craft skills; no tracked-but-ignored ignore bugs
8. Local commit; GitOps only on `/end` / ship
