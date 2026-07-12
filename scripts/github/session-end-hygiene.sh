#!/usr/bin/env bash
# Run on /end after ship. Lists remaining open PRs/issues; flags stale agent-os init PRs.
# Usage: session-end-hygiene.sh [--close-stale-os-prs]
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
CLOSE=0
[[ "${1:-}" == "--close-stale-os-prs" ]] && CLOSE=1

info "Session-end GitHub hygiene for $REPO"
echo "=== open PRs remaining ==="
gh pr list -R "$REPO" --state open --limit 30
echo
echo "=== open Issues remaining ==="
gh issue list -R "$REPO" --state open --limit 30

# Detect superseded OS init PRs (title heuristics + AGENTS.md already on main)
if git show "origin/$(cfg protected_branch 2>/dev/null || echo main):AGENTS.md" >/dev/null 2>&1 \
   || git show "origin/main:AGENTS.md" >/dev/null 2>&1; then
  info "main has AGENTS.md — scanning for superseded OS-init PRs"
  while read -r num title; do
    [[ -z "${num:-}" ]] && continue
    case "$title" in
      "chore: initialize Architect"*|"chore: install Architect"*|"chore: Agent OS"*)
        echo "STALE_CANDIDATE PR #$num — $title"
        if [[ "$CLOSE" -eq 1 ]]; then
          gh pr close -R "$REPO" "$num" --comment "Superseded: Agent OS is on protected branch (later merges). Closing obsolete init PR. Agent-owned hygiene — no Actions." 2>&1 || true
          echo "  closed #$num"
        fi
        ;;
    esac
  done < <(gh pr list -R "$REPO" --state open --json number,title --jq '.[] | "\(.number) \(.title)"')
fi

OWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
if [[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" && "$PNUM" != "0" ]] && require_project_scopes 2>/dev/null; then
  echo
  echo "=== Project items still In Progress (review manually) ==="
  gh project item-list "$PNUM" --owner "$OWNER" --limit 50 2>&1 | head -40 || true
fi
info "Hygiene report done."
