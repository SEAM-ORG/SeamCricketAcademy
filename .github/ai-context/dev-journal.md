# Dev Journal

Outcomes and session notes (not rules).

### 2026-07-11: Architect↔Agent OS bootstrap

Installed portable Agent OS from gist `saadev0/5828479245f786c80993b67a6f669aee`. Surfaces: root `AGENTS.md`, `.github/ai-context/*`, bootstrap skill, `tasks/lessons.md`, `CLAUDE.md` → `AGENTS.md`. Hooks/CI aligned per stack gap analysis.

### 2026-07-11: Local CI policy (gist sync)

Gist updated: quality gates = local git hooks only. GitHub Actions reserved for deploy/release/environment. Removed redundant PR CI workflows where added during bootstrap. Dependabot/Jules cover GitHub-side essentials.

### 2026-07-11: Gist OS sync (scope + local CI)

Synced always-on OS from gist `saadev0/5828479245f786c80993b67a6f669aee`: local CI policy, non-project chat scope, default multi-repo OS install/sync. Preserved This Project + knowledge graph.

### 2026-07-11: Migrate local CI to .githooks

Default local CI is tracked `.githooks/` + `scripts/install-githooks.sh`. Removed husky where present.
