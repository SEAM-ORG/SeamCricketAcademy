#!/usr/bin/env bash
# session-preflight.sh — Session Start health gate (Architect↔Agent OS)
# Lists repo reality AND exits non-zero when blockers remain.
# Exit 0 = clear for net-new (after agent disposed prior blockers).
# Exit 2 = BLOCKERS present — agent MUST dispose before net-new product work.
# Exit 1 = tooling error.
#
# Install: copy into product scripts/github/session-preflight.sh (or source from here).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Prefer product _lib when installed under scripts/github/
if [[ -f "$SCRIPT_DIR/_lib.sh" ]]; then
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/_lib.sh"
  REPO="$(remote_repo 2>/dev/null || true)"
  BASE="$(cfg protected_branch 2>/dev/null || true)"; BASE="${BASE:-main}"
else
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  BASE="main"
  info() { echo "→ $*"; }
fi

REPO="${REPO:-unknown}"
BLOCKERS=0
blocker() {
  BLOCKERS=$((BLOCKERS + 1))
  echo "BLOCKER: $*"
}

info "GitHub session preflight for $REPO (health gate — not advisory)"
echo "=== git ==="
git status --short --branch
git log --oneline -5
echo

echo "=== open PRs (each is a BLOCKER until disposed) ==="
OPEN_PRS=0
while read -r line; do
  [[ -z "$line" ]] && continue
  OPEN_PRS=$((OPEN_PRS + 1))
  echo "  $line"
done < <(gh pr list -R "$REPO" --state open --limit 30 2>/dev/null || true)
if [[ "$OPEN_PRS" -eq 0 ]]; then
  echo "  (none)"
else
  blocker "$OPEN_PRS open PR(s) — fix-and-merge, rebase+merge, or close with comment+reason (no lazy leave-open)"
fi
echo

echo "=== open Issues (P0/bug/security = BLOCKER; others dispose or PARK with 4 fields) ==="
gh issue list -R "$REPO" --state open --limit 20 2>/dev/null || echo "  (none or no access)"
echo

echo "=== local vs origin/$BASE ==="
git fetch origin "$BASE" --quiet 2>/dev/null || true
git rev-list --left-right --count "HEAD...origin/$BASE" 2>/dev/null || true
echo

echo "=== local branches ahead of origin/$BASE (multi-agent WIP) ==="
found_wip=0
while read -r branch; do
  [[ -z "$branch" || "$branch" == "$BASE" ]] && continue
  ahead=$(git rev-list --count "origin/$BASE..$branch" 2>/dev/null || echo 0)
  if [[ "${ahead:-0}" -gt 0 ]]; then
    found_wip=1
    tip=$(git log -1 --format='%h %s' "$branch" 2>/dev/null || echo "?")
    echo "  $branch  +$ahead  $tip"
  fi
done < <(git for-each-ref --format='%(refname:short)' refs/heads/)
if [[ "$found_wip" -eq 0 ]]; then
  echo "  (none)"
else
  blocker "local branch(es) ahead of origin/$BASE — resume/ship/park before net-new from main"
fi
echo

echo "=== Failed Actions on $BASE (last 8) — still failing on protected = BLOCKER ==="
FAIL_MAIN=0
while read -r line; do
  [[ -z "$line" ]] && continue
  FAIL_MAIN=$((FAIL_MAIN + 1))
  echo "  $line"
done < <(gh run list -R "$REPO" --branch "$BASE" --status failure --limit 8 2>/dev/null || true)
if [[ "$FAIL_MAIN" -eq 0 ]]; then
  echo "  (none on $BASE)"
else
  blocker "$FAIL_MAIN failed Action run(s) on $BASE — reproduce/fix or document supersession with evidence (not 'old noise')"
fi
echo

echo "=== Dependabot / bot open PRs ==="
BOT=0
while read -r line; do
  [[ -z "$line" ]] && continue
  BOT=$((BOT + 1))
  echo "  $line"
done < <(gh pr list -R "$REPO" --state open --limit 30 --json number,title,author \
  --jq '.[] | select(.author.login|test("dependabot|renovate|app/"; "i") or (.title|test("dependabot|Bump |deps|chore\\(deps\\)"; "i"))) | "#\(.number) \(.title)"' 2>/dev/null || true)
if [[ "$BOT" -eq 0 ]]; then
  echo "  (none)"
else
  echo "  → $BOT bot PR(s) included in open-PR blockers — value-first triage same session"
fi
echo

if [[ "$BLOCKERS" -gt 0 ]]; then
  echo "================================================================="
  echo "HEALTH GATE FAILED: $BLOCKERS blocker class(es)."
  echo "Agent MUST dispose every BLOCKER before net-new product work."
  echo "Disposition: fix-and-merge | rehome value then close+reason | ship | HOLD+recovery (external block only). Never lose work."
  echo "Forbidden: 'pre-existing', 'later', 'not this session', report-only, delete without rehome."
  echo "================================================================="
  exit 2
fi

info "Preflight CLEAR — no open-PR / main-CI / local-WIP blockers. Proceed with Decision Gate."
exit 0
