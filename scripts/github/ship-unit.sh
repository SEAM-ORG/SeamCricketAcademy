#!/usr/bin/env bash
# After code is ready on a feature branch:
#   ship-unit.sh [--title T] [--body B] [--label L] [--milestone M] [--infra] [--no-merge]
# Creates/updates PR with labels + milestone, adds to Project V2 (In Review → Done on merge),
# squash-merges, deletes remote branch, checks out protected main.
#
# Canonical: ~/.agents/scripts/github/ship-unit.sh
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
BASE="$(cfg protected_branch)"; BASE="${BASE:-main}"
BRANCH="$(git symbolic-ref --quiet --short HEAD)"
[[ "$BRANCH" != "$BASE" ]] || die "refuse to ship from protected branch $BASE"

TITLE=""; BODY=""; LABELS=(); INFRA=0; NO_MERGE=0; MILESTONE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --body) BODY="$2"; shift 2 ;;
    --label) LABELS+=("$2"); shift 2 ;;
    --milestone) MILESTONE="$2"; shift 2 ;;
    --infra) INFRA=1; LABELS+=("agent-infra" "chore"); shift ;;
    --no-merge) NO_MERGE=1; shift ;;
    *) die "unknown $1" ;;
  esac
done
[[ -n "$TITLE" ]] || TITLE="chore: ship $BRANCH"
[[ -n "$BODY" ]] || BODY="## Summary
Agent-shipped unit from \`$BRANCH\`.

## Test plan
- [x] Local verify + hooks
"

if [[ "$INFRA" -eq 1 && -z "$MILESTONE" ]]; then
  MILESTONE="$(cfg infra_milestone)"
  MILESTONE="${MILESTONE:-Agent OS & Tooling}"
fi

# Default label if none provided
if [[ ${#LABELS[@]} -eq 0 ]]; then
  LABELS+=("chore")
fi

bash "$(dirname "$0")/ensure-labels.sh" >/dev/null

info "Push $BRANCH"
git push -u origin "$BRANCH"

# Ensure milestone exists
MNUM=""
if [[ -n "$MILESTONE" ]]; then
  info "Ensuring milestone '$MILESTONE'"
  MNUM="$(gh api "repos/$REPO/milestones?state=open" --jq ".[] | select(.title==\"$MILESTONE\") | .number" 2>/dev/null | head -1 || true)"
  if [[ -z "$MNUM" ]]; then
    MNUM="$(gh api -X POST "repos/$REPO/milestones" -f title="$MILESTONE" -f description="Auto-created milestone" --jq .number)"
  fi
fi

EXISTING="$(gh pr list -R "$REPO" --head "$BRANCH" --state open --json number --jq '.[0].number // empty')"
if [[ -n "$EXISTING" ]]; then
  PR_NUM="$EXISTING"
  info "Using open PR #$PR_NUM"
else
  ARGS=(pr create -R "$REPO" --base "$BASE" --head "$BRANCH" --title "$TITLE" --body "$BODY")
  LABELS=($(printf '%s\n' "${LABELS[@]}" | sort -u))
  for L in "${LABELS[@]}"; do ARGS+=(--label "$L"); done
  if [[ -n "$MNUM" ]]; then
    ARGS+=(--milestone "$MILESTONE")
  fi
  URL="$(gh "${ARGS[@]}")"
  PR_NUM="$(echo "$URL" | rg -o '[0-9]+$')"
  info "Created PR #$PR_NUM $URL"
fi

PR_URL="$(gh pr view -R "$REPO" "$PR_NUM" --json url --jq .url)"
for L in "${LABELS[@]}"; do gh pr edit -R "$REPO" "$PR_NUM" --add-label "$L" 2>/dev/null || true; done
if [[ -n "$MNUM" ]]; then
  gh pr edit -R "$REPO" "$PR_NUM" --milestone "$MILESTONE" 2>/dev/null || true
fi

# Project V2 — hard requirement when configured
POWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
if [[ -z "$POWNER" || "$POWNER" == "REPLACE_ORG" || -z "$PNUM" || "$PNUM" == "0" ]]; then
  echo "ERROR: Project V2 not configured in .github/agent-project.yml (project_owner + project_number)." >&2
  echo "  Issues/PRs will not appear on the board. Fix config then re-run ship-unit." >&2
  die "refusing to ship without Project V2 wiring"
fi

info "Project V2: add + status in_review"
if ! bash "$(dirname "$0")/project-sync.sh" add "$PR_URL"; then
  echo "WARN: project-sync add failed for $PR_URL — retrying status path" >&2
fi
if ! bash "$(dirname "$0")/project-sync.sh" status "$PR_URL" in_review; then
  echo "WARN: project-sync status in_review failed — agent must fix board mapping (status_map)" >&2
fi
# Optional Work Type from --infra
if [[ "$INFRA" -eq 1 ]]; then
  bash "$(dirname "$0")/project-sync.sh" type "$PR_URL" infra 2>/dev/null || true
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

bash "$(dirname "$0")/project-sync.sh" status "$PR_URL" done 2>/dev/null \
  || echo "WARN: project-sync done failed for $PR_URL" >&2

git fetch origin --prune
git checkout "$BASE"
git pull --ff-only origin "$BASE" || git reset --hard "origin/$BASE"
git branch -d "$BRANCH" 2>/dev/null || true
# Ensure remote feature branch is gone (merge --delete-branch should, but verify)
if git ls-remote --heads origin "$BRANCH" | rg -q .; then
  git push origin --delete "$BRANCH" 2>/dev/null || true
fi
info "Shipped. On $BASE @ $(git rev-parse --short HEAD)"
echo "$PR_URL"
