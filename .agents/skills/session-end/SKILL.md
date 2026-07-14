---
name: session-end
description: Session End Protocol for Architect↔Agent OS. Use on /end, end session, or ship it. Enforces clean tree or tracked PARK debt, verification evidence, and GitOps only when green.
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
- [ ] Push feature branch + PR when unit ready
- [ ] gh pr create/merge only after clean tree (harness blocks if dirty)
- [ ] CI green before squash merge (unless Architect exception)
- [ ] Leave on protected branch after merge, or justify open PR
- [ ] Closeout brief with evidence / PR URLs
```

## Forbidden

- Ending with untracked half-done scope
- Lazy-close PRs without --comment
- Merge without green checks (unless Architect waives)
- Gist overwrite without clone + head verify
- Postponing cleanup “to later” without debt fields
