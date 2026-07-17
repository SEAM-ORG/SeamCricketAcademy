#!/usr/bin/env bash
# Run on /end after ship. Health gate: open PRs / remote orphans / failures are BLOCKERS.
# Usage: session-end-hygiene.sh [--close-stale-os-prs] [--force-prune-orphans]
#   --close-stale-os-prs   close superseded OS-init PRs; delete MERGED remote orphans
#   --force-prune-orphans  also delete UNMERGED remote orphans (only after agent verified supersession)
# Exit 0 = clean/return-main ok; Exit 2 = open blockers remain; Exit 1 = return-main failed.
#
# Canonical: ~/.agents/scripts/github/session-end-hygiene.sh
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
CLOSE=0
FORCE_PRUNE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --close-stale-os-prs) CLOSE=1; shift ;;
    --force-prune-orphans) FORCE_PRUNE=1; shift ;;
    *) die "unknown arg $1" ;;
  esac
done
BLOCKERS=0
blocker() { BLOCKERS=$((BLOCKERS + 1)); echo "BLOCKER: $*"; }

info "Session-end GitHub hygiene for $REPO (not advisory)"
echo "=== open PRs remaining ==="
OPEN_PRS=0
while read -r line; do
  [[ -z "$line" ]] && continue
  OPEN_PRS=$((OPEN_PRS + 1))
  echo "  $line"
done < <(gh pr list -R "$REPO" --state open --limit 30 2>/dev/null || true)
if [[ "$OPEN_PRS" -eq 0 ]]; then
  echo "  (none)"
else
  blocker "$OPEN_PRS open PR(s) — dispose before claiming complete (merge/rehome+close/fix; HOLD+recovery only if externally blocked)"
fi
echo
echo "=== open Issues remaining ==="
gh issue list -R "$REPO" --state open --limit 30 2>/dev/null || true

if git show "origin/$(cfg protected_branch 2>/dev/null || echo main):AGENTS.md" >/dev/null 2>&1 \
   || git show "origin/main:AGENTS.md" >/dev/null 2>&1; then
  info "main has AGENTS.md — scanning for superseded OS-init PRs"
  while read -r num title; do
    [[ -z "${num:-}" ]] && continue
    case "$title" in
      "chore: initialize Architect"*|"chore: install Architect"*|"chore: Agent OS"*)
        echo "STALE_CANDIDATE PR #$num — $title"
        if [[ "$CLOSE" -eq 1 ]]; then
          gh pr close -R "$REPO" "$num" --comment "Superseded: Agent OS is on protected branch. Closing obsolete init PR." 2>&1 || true
          echo "  closed #$num"
        fi
        ;;
    esac
  done < <(gh pr list -R "$REPO" --state open --json number,title --jq '.[] | "\(.number) \(.title)"')
fi

BASE="$(cfg protected_branch 2>/dev/null || echo main)"; BASE="${BASE:-main}"
git fetch origin --prune 2>/dev/null || true

echo
echo "=== Remote branches (orphans = no open PR) ==="
ORPHAN_BLOCK=0
while read -r br; do
  [[ -z "$br" || "$br" == "$BASE" || "$br" == "master" || "$br" == "gh-pages" ]] && continue
  PR_EXISTS="$(gh pr list -R "$REPO" --head "$br" --state open --limit 1 --json number --jq '.[0].number // empty' 2>/dev/null || true)"
  if [[ -n "$PR_EXISTS" ]]; then
    echo "  keep origin/$br (open PR #$PR_EXISTS)"
    continue
  fi

  MERGED=0
  if git show-ref --verify --quiet "refs/remotes/origin/$br" 2>/dev/null \
     && git merge-base --is-ancestor "origin/$br" "origin/$BASE" 2>/dev/null; then
    MERGED=1
  fi

  if [[ "$MERGED" -eq 1 ]]; then
    echo "  MERGED orphan: origin/$br"
    if [[ "$CLOSE" -eq 1 || "$FORCE_PRUNE" -eq 1 ]]; then
      git push origin --delete "$br" 2>/dev/null && echo "    → deleted origin/$br" || echo "    → delete failed (check perms)"
    else
      blocker "merged remote orphan origin/$br — run with --close-stale-os-prs to delete"
      ORPHAN_BLOCK=$((ORPHAN_BLOCK + 1))
    fi
  else
    ahead="?"
    tip="?"
    if git show-ref --verify --quiet "refs/remotes/origin/$br" 2>/dev/null; then
      ahead=$(git rev-list --count "origin/$BASE..origin/$br" 2>/dev/null || echo "?")
      tip=$(git log -1 --format='%h %s' "origin/$br" 2>/dev/null || echo "?")
    fi
    echo "  UNMERGED orphan: origin/$br +$ahead  $tip"
    if [[ "$FORCE_PRUNE" -eq 1 ]]; then
      git push origin --delete "$br" 2>/dev/null && echo "    → force-pruned origin/$br (agent asserted supersession)" || echo "    → delete failed"
    else
      blocker "unmerged remote orphan origin/$br (+$ahead) — ship/rehome value OR prove supersession then --force-prune-orphans"
      ORPHAN_BLOCK=$((ORPHAN_BLOCK + 1))
    fi
  fi
done < <(git ls-remote --heads origin 2>/dev/null | awk '{print $2}' | sed 's|refs/heads/||')
if [[ "$ORPHAN_BLOCK" -eq 0 ]]; then
  echo "  (no orphan blockers — or all pruned)"
fi

echo
echo "=== Project V2 config ==="
OWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
if [[ -z "$OWNER" || "$OWNER" == "REPLACE_ORG" || -z "$PNUM" || "$PNUM" == "0" ]]; then
  blocker "Project V2 not configured (project_owner/project_number) — board will not receive Issues/PRs"
else
  echo "  $OWNER / project #$PNUM"
  if require_project_scopes 2>/dev/null; then
    echo "=== Project items (sample) ==="
    gh project item-list "$PNUM" --owner "$OWNER" --limit 20 2>&1 | head -40 || true
  fi
fi

echo
echo "=== Failed Actions on protected (active only — superseded by later green = clear) ==="
FAIL=0
while read -r line; do
  [[ -z "$line" ]] && continue
  FAIL=$((FAIL + 1))
  echo "  ACTIVE FAIL: $line"
done < <(
  gh run list -R "$REPO" --branch "$BASE" --limit 50 \
    --json databaseId,conclusion,name,createdAt,displayTitle,url,workflowName 2>/dev/null \
    | jq -r '
        map(. + {key: (if (.workflowName // "") != "" then .workflowName else .name end)})
        | group_by(.key)
        | map(sort_by(.createdAt) | reverse | .[0])
        | map(select(.conclusion == "failure"))
        | .[]
        | "\(.key)\t\(.createdAt)\t\(.displayTitle // "")\t\(.url // "")"
      ' 2>/dev/null || true
)
if [[ "$FAIL" -eq 0 ]]; then
  echo "  (none — failures superseded by later green, or no failures)"
else
  blocker "$FAIL active failed workflow(s) on $BASE — fix root cause or re-run until latest is green"
fi

echo
echo "=== Dependabot / bot open PRs ==="
gh pr list -R "$REPO" --state open --limit 20 --json number,title,author \
  --jq '.[] | select(.author.login|test("dependabot|renovate|app/"; "i") or (.title|test("dependabot|Bump |deps"; "i"))) | "#\(.number) \(.title)"' 2>/dev/null || true

if [[ -f "$(cd "$(dirname "$0")" && pwd)/../../scripts/stop-dev.sh" ]]; then
  echo
  info "Stopping dev server..."
  bash "$(cd "$(dirname "$0")" && pwd)/../../scripts/stop-dev.sh" || true
fi

echo
info "Session End return-to-main gate"
bash "$(cd "$(dirname "$0")" && pwd)/session-end-return-main.sh" || {
  echo "ERROR: return-to-main failed — ship unmerged work first (ship-unit.sh) or clean/park dirty tree." >&2
  exit 1
}

if [[ "$BLOCKERS" -gt 0 ]]; then
  echo "================================================================="
  echo "HEALTH GATE: $BLOCKERS blocker class(es) still open after return-to-main."
  echo "Session End is NOT complete until each is disposed (merge/close/prune/PARK+4 fields)."
  echo "Forbidden closeout: 'pre-existing', 'later', 'not this ship', report-only, lost work."
  echo "================================================================="
  exit 2
fi

info "Hygiene CLEAR — no open-PR/orphan/project/main-CI blockers; on protected branch."
exit 0
