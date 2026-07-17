#!/usr/bin/env bash
# Refuse commits (and agent commit attempts) on the protected branch.
# Product work lands via feature branch → PR → squash merge only.
# Exit 0 = allowed; exit 1 = blocked.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$REPO_ROOT" ]] || exit 0
cd "$REPO_ROOT"

BASE="main"
if [[ -f "$REPO_ROOT/scripts/github/_lib.sh" ]]; then
  # shellcheck source=/dev/null
  source "$REPO_ROOT/scripts/github/_lib.sh" 2>/dev/null || true
  BASE="$(cfg protected_branch 2>/dev/null || true)"
  BASE="${BASE:-main}"
elif [[ -f "$REPO_ROOT/.github/agent-project.yml" ]]; then
  BASE="$(python3 - "$REPO_ROOT/.github/agent-project.yml" <<'PY' 2>/dev/null || echo main
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
m = re.search(r"^protected_branch:\s*(.+)$", text, re.M)
print(m.group(1).strip().strip('"').strip("'") if m else "main")
PY
)"
fi
BASE="${BASE:-main}"

BRANCH="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo DETACHED)"

# Allow merge commits completing a PR land (rare local merge) only if MERGE_HEAD present
if [[ -f "$REPO_ROOT/.git/MERGE_HEAD" ]]; then
  exit 0
fi

case "$BRANCH" in
  "$BASE"|master)
    echo "BLOCKED: refuse commit on protected branch '$BRANCH'." >&2
    echo "  Agent OS: never work on main. Create a feature branch first:" >&2
    echo "    git checkout -b feat/<issue>-<slug>   # or chore|fix|docs/..." >&2
    echo "    # optional: bash scripts/github/open-unit.sh --title '...' --label ..." >&2
    echo "  Ship via: bash scripts/github/ship-unit.sh  (PR → squash → return to $BASE)" >&2
    exit 1
    ;;
esac
exit 0
