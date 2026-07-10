---
description: Ends the current session cleanly following Architect↔Agent OS protocol.
---

Please end the current session.

Before responding, you must execute the OS Session Completion protocol:
1. Ensure all code changes are verified and intentional.
2. If on a feature branch with uncommitted changes, commit them with a standard message.
3. Push the branch to origin.
4. If a PR does not exist for this branch, open one using `gh pr create`.
5. Run `git checkout main` to leave the workspace clean for the next session.
6. Print the closeout summary: Summary, Status, Evidence, Next step.
