#!/bin/bash
# scripts/finalize-pr.sh — squash-merge and delete branch
set -euo pipefail
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
PR_NUMBER=${1:-}
if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <pr-number>"
  exit 1
fi
gh pr merge "$PR_NUMBER" --squash --delete-branch
