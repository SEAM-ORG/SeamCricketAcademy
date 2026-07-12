#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

REPO="$(remote_repo)"
BASE="$(cfg protected_branch)"; BASE="${BASE:-main}"

info "GitHub session preflight for $REPO"
echo "=== git ==="
git status --short --branch
git log --oneline -5
echo
echo "=== open PRs ==="
gh pr list -R "$REPO" --state open --limit 20
echo
echo "=== open Issues ==="
gh issue list -R "$REPO" --state open --limit 20
echo
echo "=== local vs origin/$BASE ==="
git fetch origin "$BASE" --quiet 2>/dev/null || true
git rev-list --left-right --count "HEAD...origin/$BASE" 2>/dev/null || true

OWNER="$(cfg project_owner)"
PNUM="$(cfg project_number)"
if [[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" && -n "$PNUM" && "$PNUM" != "0" ]]; then
  if require_project_scopes 2>/dev/null; then
    echo
    echo "=== Project V2 #$PNUM owner=$OWNER (first 30 items) ==="
    gh project item-list "$PNUM" --owner "$OWNER" --limit 30 2>&1 || true
  else
    echo
    echo "=== Project V2: skipped (run scripts/github/ensure-scopes.sh) ==="
  fi
else
  echo
  echo "=== Project V2: not configured (.github/agent-project.yml) ==="
fi

echo
info "Preflight complete. Resume open PR/branch work before inventing parallel streams."
