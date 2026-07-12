#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
TITLE="$(cfg infra_milestone)"
TITLE="${TITLE:-Agent OS & Tooling}"
info "Ensuring milestone '$TITLE' on $REPO"
EXISTING="$(gh api "repos/$REPO/milestones?state=open" --jq ".[] | select(.title==\"$TITLE\") | .number" 2>/dev/null | head -1 || true)"
if [[ -n "$EXISTING" ]]; then
  echo "  milestone #$EXISTING exists"
  echo "$EXISTING"
  exit 0
fi
NUM="$(gh api -X POST "repos/$REPO/milestones" -f title="$TITLE" -f description="Agent OS / tooling / hooks work" --jq .number)"
echo "  created milestone #$NUM"
echo "$NUM"
