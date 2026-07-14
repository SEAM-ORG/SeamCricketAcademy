---
name: session-end
description: Session End Protocol for Architect↔Agent OS. Use on /end, end session, or ship it. Enforces clean tree or tracked PARK debt, verification evidence, GitOps ship, and hard return to protected branch (main) ready for next session.
---

# Session End Protocol

Trigger: `/end`, “end session”, “ship it”, or Architect closeout.

## Effort mandate

Full end-to-end closeout. **No lazy end.** Incomplete work must be **committed** or **PARKed** with status + priority + justification + done-when.

## Checklist

```
Session End:
- [ ] All claimed work has verification evidence
- [ ] Dirty tree: commit remaining finished work OR PARK in todo.md (4 debt fields)
- [ ] No silent dirty tree at “done”
- [ ] No AGENTS.md / Gist pollution (first line # Architect…)
- [ ] Docs/INDEX/This Project updated when surfaces changed
- [ ] Push feature branch + PR when unit ready (prefer scripts/github/ship-unit.sh)
- [ ] gh pr create/merge only after clean tree (harness blocks if dirty)
- [ ] CI green before squash merge (unless Architect exception)
- [ ] HARD: bash scripts/github/session-end-return-main.sh exits 0
- [ ] Leave on protected branch (main), clean, ff to origin — ready for next session
- [ ] bash scripts/github/session-end-hygiene.sh [--close-stale-os-prs]
- [ ] Closeout brief with evidence / PR URLs
```

## Hard gate (do not skip)

```bash
# After ship (or when already merged):
bash scripts/github/session-end-hygiene.sh --close-stale-os-prs
# hygiene ends with:
bash scripts/github/session-end-return-main.sh
```

If return-main fails:

- Dirty → commit or PARK
- Feature branch unmerged → `bash scripts/github/ship-unit.sh`
- On main ahead of origin → rehome to `chore/…` branch then ship (never strand unpushed protected commits)

Portfolio (all ~/Projects):

```bash
bash ~/.grok/skills/session-end-gitops/scripts/portfolio-session-end.sh
```

Skill: `session-end-gitops` / `/session-end-gitops`

## Forbidden

- Ending with untracked half-done scope
- Ending on a feature branch without open PR + justification
- Lazy-close PRs without --comment
- Merge without green checks (unless Architect waives)
- Gist overwrite without clone + head verify
- Postponing cleanup “to later” without debt fields
