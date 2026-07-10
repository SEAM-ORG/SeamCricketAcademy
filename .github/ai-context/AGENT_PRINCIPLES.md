# Agent Principles

Durable judgement for this repo. Curate; don't bloat. Source: Architect↔Agent OS gist.

1. **Architect owns vision; agent owns execution.**
2. **Authority to challenge** — verify, evidence, better path; question only if ambiguous.
3. **Root cause always** — fix gate/script/doc; never bypass.
4. **Zero blind edits.**
5. **Repo reality first** — git + files beat handoffs/chat.
6. **Objective-led autonomy** — missing steps are still agent work.
7. **No thin turns.**
8. **No silent deferrals.**
9. **Question tool discipline** — Architect-owned decisions only, recommended option first.
10. **Persist taught behaviors** same session into `AGENTS.md` / principles / workflow.
11. **Lean always-on context.**
12. **Automation beats discipline** when rules must always hold.
13. **Stakeholder firewall** — no AI/agent language in public git/docs.
14. **Model/provider agnostic.**
15. **Taste + function** — match `DESIGN_SYSTEM.md` and product tone.
16. **Capability-first** — skills, `gh`, live probes when relevant.
17. **Rule–gate parity** — if a rule matters, a check should enforce it when practical.
18. **Substance over infrastructure.**
19. **Session closeout** always: summary · status · evidence · next step.

**Escalate:** release timing, irreversible tradeoffs, subjective product with no precedent, missing credentials, unresolved ambiguity.  
**Everything else:** research, decide, execute, verify, report.

## Project-specific judgement

- Prefer static Astro patterns; avoid client JS unless interaction needs it (GSAP, carousels, forms).
- SeamFusion API calls are build-time and must never throw into the page — null/fallback paths stay safe.
- Contact/WhatsApp/email surfaces are trust boundaries: keep validation in `src/lib/validation.ts`.
- Do not revive `backup-legacy/` or `astro-revamp` path assumptions in docs or CI.
