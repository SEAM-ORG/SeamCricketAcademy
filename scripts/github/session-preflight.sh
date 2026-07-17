#!/usr/bin/env bash
# session-preflight.sh — Session Start health gate (Architect↔Agent OS)
# Lists repo reality AND exits non-zero when blockers remain.
# Exit 0 = clear for net-new (after agent disposed prior blockers).
# Exit 2 = BLOCKERS present — agent MUST dispose before net-new product work.
# Exit 1 = tooling error.
#
# Canonical: ~/.agents/scripts/github/session-preflight.sh
# Products: scripts/github/session-preflight.sh (keep in sync via agent-os-bootstrap)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ -f "$SCRIPT_DIR/_lib.sh" ]]; then
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/_lib.sh"
  REPO="$(remote_repo 2>/dev/null || true)"
  BASE="$(cfg protected_branch 2>/dev/null || true)"; BASE="${BASE:-main}"
else
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  BASE="main"
  info() { echo "→ $*"; }
  cfg() { return 0; }
  CONFIG_FILE=""
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

echo "=== remote orphan branches (no open PR — GitOps residue) ==="
git fetch origin --prune --quiet 2>/dev/null || true
ORPHANS=0
while read -r br; do
  [[ -z "$br" || "$br" == "$BASE" || "$br" == "master" || "$br" == "gh-pages" ]] && continue
  pr_exists="$(gh pr list -R "$REPO" --head "$br" --state open --limit 1 --json number --jq '.[0].number // empty' 2>/dev/null || true)"
  if [[ -n "$pr_exists" ]]; then
    continue
  fi
  # Classify merged vs unmerged tip
  if git show-ref --verify --quiet "refs/remotes/origin/$br" 2>/dev/null; then
    if git merge-base --is-ancestor "origin/$br" "origin/$BASE" 2>/dev/null; then
      echo "  MERGED orphan: origin/$br (safe to delete — no open PR)"
    else
      ahead=$(git rev-list --count "origin/$BASE..origin/$br" 2>/dev/null || echo "?")
      tip=$(git log -1 --format='%h %s' "origin/$br" 2>/dev/null || echo "?")
      echo "  UNMERGED orphan: origin/$br +$ahead  $tip"
    fi
  else
    echo "  orphan: $br (no local remote-tracking ref — still on origin, no open PR)"
  fi
  ORPHANS=$((ORPHANS + 1))
done < <(git ls-remote --heads origin 2>/dev/null | awk '{print $2}' | sed 's|refs/heads/||')
if [[ "$ORPHANS" -eq 0 ]]; then
  echo "  (none)"
else
  blocker "$ORPHANS remote branch(es) without open PR — delete merged (git push origin --delete <br>) or rehome/ship/supersede+delete unmerged. Session End: session-end-hygiene.sh --close-stale-os-prs"
fi
echo

echo "=== Project V2 config (.github/agent-project.yml) ==="
POWNER="$(cfg project_owner 2>/dev/null || true)"
PNUM="$(cfg project_number 2>/dev/null || true)"
PTITLE="$(cfg project_title 2>/dev/null || true)"
echo "  project_owner=${POWNER:-'(unset)'}"
echo "  project_number=${PNUM:-'(unset)'}"
echo "  project_title=${PTITLE:-'(unset)'}"
if [[ -z "${POWNER:-}" || "$POWNER" == "REPLACE_ORG" ]]; then
  blocker "project_owner unset/REPLACE_ORG — set real org/user that owns Project V2 in .github/agent-project.yml"
fi
if [[ -z "${PNUM:-}" || "$PNUM" == "0" ]]; then
  blocker "project_number is 0/unset — Project V2 board not wired; Issues/PRs will not populate the board. Set project_number from: gh project list --owner <org>"
fi
if [[ -n "${POWNER:-}" && "$POWNER" != "REPLACE_ORG" && -n "${PNUM:-}" && "$PNUM" != "0" ]]; then
  if command -v require_project_scopes >/dev/null 2>&1 && require_project_scopes 2>/dev/null; then
    echo "  board: https://github.com/orgs/${POWNER}/projects/${PNUM} (or /users/…)"
  else
    echo "  (scopes ok or check: gh auth refresh -s project,read:project)"
  fi
fi
echo

echo "=== Failed Actions on $BASE (active only — later green supersedes) ==="
FAIL_MAIN=0
while read -r line; do
  [[ -z "$line" ]] && continue
  FAIL_MAIN=$((FAIL_MAIN + 1))
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
if [[ "$FAIL_MAIN" -eq 0 ]]; then
  echo "  (none on $BASE — historical failures superseded by later green)"
else
  blocker "$FAIL_MAIN active failed workflow(s) on $BASE — fix or re-run until latest of that workflow is green"
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
  echo "Disposition: fix-and-merge | rehome value then close+reason | ship | delete merged orphans |"
  echo "  HOLD+recovery (external block only). Never lose work."
  echo "Forbidden: 'pre-existing', 'later', 'not this session', report-only, delete without rehome."
  echo "================================================================="
  exit 2
fi

info "Preflight CLEAR — no open-PR / remote-orphan / project-config / main-CI / local-WIP blockers. Proceed with Decision Gate."
exit 0
