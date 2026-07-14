---
name: session-start
description: Session Start Protocol for Architect↔Agent OS. Use at the beginning of every session and after compaction. Re-grounds git status, Decision Gate, lessons/todo, and skills mapping before any product edit.
---

# Session Start Protocol

**Mandatory** before product edits. Do not wait for `/start`.

## Checklist

```
Session Start:
- [ ] Read root AGENTS.md (or re-read after compaction) — especially PROTOCOL ENFORCEMENT
- [ ] Reality check: git status --short --branch (+ recent log)
- [ ] Decision Gate stated: CONTINUE | FINISH+COMMIT | PROMOTE | PARK | ASK
- [ ] No unexplained dirty tree / no silent branch switch
- [ ] lessons.md + todo.md + open plans reviewed; resume before net-new
- [ ] using-agent-skills mapped for non-trivial objective
- [ ] Local CI hooks present (or install); never --no-verify
- [ ] 2–5 line brief: status, handoff decision, next step
```

## Evidence

Prefer harness hook output when present:

- `~/.grok/hooks/logs/last-session-start-evidence.txt`
- `~/.grok/hooks/logs/pending-session-warnings.txt`

## Local-first

Verify + commit locally each unit. Push/PR only on Session End / ship.

## Related

- Full OS: root `AGENTS.md`
- Always-on gate: `~/.config/opencode/AGENT_OS_ENFORCEMENT.md`
- End of session: `session-end` skill / `/end`
