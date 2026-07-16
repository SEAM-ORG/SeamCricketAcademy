#!/usr/bin/env bash
# Run on /end after ship. Health gate: open PRs/failures are BLOCKERS unless disposed.
# Usage: session-end-hygiene.sh [--close-stale-os-prs]
# Exit 0 = clean/return-main ok; Exit 2 = open blockers remain (closeout must dispose or fail claim).
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
CLOSE=0
[[ "${1:-}" == "--close-stale-os-prs" ]] && CLOSE=1
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
  blocker "$OPEN_PRS open PR(s) — dispose before claiming session complete (merge/close/PARK with 4 fields after attempt)"
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

OWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
if [[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" && "$PNUM" != "0" ]] && require_project_scopes 2>/dev/null; then
  echo
  echo "=== Project items still In Progress ==="
  gh project item-list "$PNUM" --owner "$OWNER" --limit 50 2>&1 | head -40 || true
fi

echo
echo "=== Failed Actions on protected (last 5) ==="
BASE="$(cfg protected_branch)"; BASE="${BASE:-main}"
FAIL=0
while read -r line; do
  [[ -z "$line" ]] && continue
  FAIL=$((FAIL + 1))
  echo "  $line"
done < <(gh run list -R "$REPO" --branch "$BASE" --status failure --limit 5 2>/dev/null || true)
if [[ "$FAIL" -gt 0 ]]; then
  blocker "$FAIL failed Action(s) on $BASE — fix or evidence of supersession required"
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
  echo "Session End is NOT complete until each is disposed (merge/close/PARK+4 fields)."
  echo "Forbidden closeout: 'pre-existing', 'not this ship', report-only hygiene."
  echo "================================================================="
  exit 2
fi

info "Hygiene CLEAR — no open-PR/main-CI blockers; on protected branch."
exit 0
