---
name: agent-os-bootstrap
description: >
  Install/repair/sync Architect↔Agent OS from gist saadev0/5828479245f786c80993b67a6f669aee
  for Grok CLI and OpenCode. Use on install, drift, or /agent-os-bootstrap.
---

# Agent OS Bootstrap / Sync

## Harness scope

**Grok Build (CLI/TUI) + OpenCode only.** Same root `AGENTS.md` for both.  
**No Antigravity IDE/CLI.** **No Superpowers methodology. No OpenSpec.**  
Keep OpenCode's `opencode-antigravity-auth` plugin (Google/Gemini auth) — that is not Antigravity IDE.

## Steps

1. Fetch gist: `gh gist view 5828479245f786c80993b67a6f669aee --raw`
2. Materialize `AGENTS.md` + `.github/ai-context/*` + skills + `tasks/`.
3. Ensure durable docs dirs exist: prefer `docs/{specs,plans,archive}/`; keep legacy `docs/superpowers/*` if present.
4. Local CI: `.githooks/` + install script (gold standard).
5. **Agent Skills pack (global):** ensure [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) is installed for Grok + OpenCode; repair if missing (see Gist **Agent Skills Pack**). Fill project gaps (tests, local CI, docs, commands).
6. Do **not** install Superpowers/OpenSpec as the work layer unless Architect explicitly asks.
7. Do **not** install Antigravity IDE/CLI. Do **not** strip `~/.config/opencode/` or `opencode-antigravity-auth`.
8. Verify checklist; **local commit**; closeout (GitOps only on `/end` / ship).

### Agent Skills repair commands

```bash
grok plugin install addyosmani/agent-skills --trust
# ensure ~/.grok/config.toml [plugins].enabled includes "agent-skills"
npx skills add addyosmani/agent-skills -g -a opencode --skill '*' -y
```

Verify: `grok inspect` shows pack skills; `opencode debug skill` lists ~24 pack skills; `ls ~/.agents/skills | wc -l` ≈ 24.

## Protected protocols (never strip)

When installing or syncing from the Gist, **preserve** these OS contracts — refine wording if needed, but do not delete or "slim" them without Architect-approved explicit diff:

- **Session Start Protocol** (decision gate / handoff ownership)
- **Local vs GitOps** (local-first per turn; push/PR only on `/end` / ship or exceptions)
- **Per-turn completion + Session End Protocol**
- Hooks / local CI gold standard + deploy-only GitHub Actions policy
- **Agent Skills Pack** (global install + autonomous use + bootstrap gaps)
- Harness scope (**Grok CLI + OpenCode** only)
- Gist Sync Protocol (including Protected OS sections)

Verify after sync: `rg -n 'Local vs GitOps|Session Start Protocol|Session End Protocol|Agent Skills Pack|verified locally' AGENTS.md`

## Autonomy

Non-trivial work → Research → Plan → Implement → Verify under Agent OS **composed with agent-skills** (invoke applicable skills without waiting for slash names). Local-first commits; GitOps on `/end` / ship. Persist optional plans/specs under `docs/`. **Intent before invention** — skills never authorize product redesign without Architect objective.
