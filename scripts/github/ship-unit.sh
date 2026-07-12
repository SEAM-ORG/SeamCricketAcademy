#!/usr/bin/env bash
# After code is ready on a feature branch:
#   ship-unit.sh [--title T] [--body B] [--label L] [--infra] [--no-merge]
# Creates/updates PR with labels, adds to Project V2 (In Review → Done on merge), squash-merges.
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
BASE="$(cfg protected_branch)"; BASE="${BASE:-main}"
BRANCH="$(git symbolic-ref --quiet --short HEAD)"
[[ "$BRANCH" != "$BASE" ]] || die "refuse to ship from protected branch $BASE"

TITLE=""; BODY=""; LABELS=(); INFRA=0; NO_MERGE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --body) BODY="$2"; shift 2 ;;
    --label) LABELS+=("$2"); shift 2 ;;
    --infra) INFRA=1; LABELS+=("agent-infra" "chore"); shift ;;
    --no-merge) NO_MERGE=1; shift ;;
    *) die "unknown $1" ;;
  esac
done
[[ -n "$TITLE" ]] || TITLE="chore: ship $BRANCH"
[[ -n "$BODY" ]] || BODY="## Summary\nAgent-shipped unit from \`$BRANCH\`.\n\n## Test plan\n- [x] Local verify + hooks\n"

bash "$(dirname "$0")/ensure-labels.sh" >/dev/null

info "Push $BRANCH"
git push -u origin "$BRANCH"

EXISTING="$(gh pr list -R "$REPO" --head "$BRANCH" --state open --json number --jq '.[0].number // empty')"
if [[ -n "$EXISTING" ]]; then
  PR_NUM="$EXISTING"
  info "Using open PR #$PR_NUM"
else
  ARGS=(pr create -R "$REPO" --base "$BASE" --head "$BRANCH" --title "$TITLE" --body "$BODY")
  if [[ ${#LABELS[@]} -gt 0 ]]; then
    LABELS=($(printf '%s\n' "${LABELS[@]}" | sort -u))
    for L in "${LABELS[@]}"; do ARGS+=(--label "$L"); done
  fi
  if [[ "$INFRA" -eq 1 ]]; then
    MNUM="$(bash "$(dirname "$0")/ensure-milestone.sh" | tail -1)"
    # milestones on PRs via edit after create if needed
  fi
  URL="$(gh "${ARGS[@]}")"
  PR_NUM="$(echo "$URL" | rg -o '[0-9]+$')"
  info "Created PR #$PR_NUM $URL"
fi

PR_URL="$(gh pr view -R "$REPO" "$PR_NUM" --json url --jq .url)"
# labels on existing
if [[ ${#LABELS[@]} -gt 0 ]]; then
  for L in "${LABELS[@]}"; do gh pr edit -R "$REPO" "$PR_NUM" --add-label "$L" 2>/dev/null || true; done
fi

if [[ "$(cfg project_number)" != "0" ]] && [[ "$(cfg project_owner)" != "REPLACE_ORG" ]]; then
  bash "$(dirname "$0")/project-sync.sh" add "$PR_URL" || true
  bash "$(dirname "$0")/project-sync.sh" status "$PR_URL" in_review || true
fi

if [[ "$NO_MERGE" -eq 1 ]]; then
  echo "$PR_URL"
  exit 0
fi

info "Squash-merging PR #$PR_NUM"
if [[ -x "$REPO_ROOT/scripts/finalize-pr.sh" ]]; then
  bash "$REPO_ROOT/scripts/finalize-pr.sh" "$PR_NUM" \
    || gh pr merge -R "$REPO" "$PR_NUM" --squash --delete-branch --admin \
    || gh pr merge -R "$REPO" "$PR_NUM" --squash --delete-branch
else
  gh pr merge -R "$REPO" "$PR_NUM" --squash --delete-branch --admin \
    || gh pr merge -R "$REPO" "$PR_NUM" --squash --delete-branch
fi

if [[ "$(cfg project_number)" != "0" ]]; then
  bash "$(dirname "$0")/project-sync.sh" status "$PR_URL" done || true
fi

git fetch origin
git checkout "$BASE"
git pull --ff-only origin "$BASE" || git reset --hard "origin/$BASE"
git branch -d "$BRANCH" 2>/dev/null || true
info "Shipped. On $BASE @ $(git rev-parse --short HEAD)"
echo "$PR_URL"
