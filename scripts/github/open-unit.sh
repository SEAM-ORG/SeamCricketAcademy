#!/usr/bin/env bash
# Create a product/infra Issue, label it, optional milestone, add to Project V2 as In Progress.
# Usage: open-unit.sh --title "..." [--body "..."] [--label chore] [--milestone M] [--type feature|bug|chore|infra|security] [--priority p0|p1|p2|p3] [--infra]
#
# Canonical: ~/.agents/scripts/github/open-unit.sh
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"

TITLE=""; BODY=""; LABELS=(); INFRA=0; MILESTONE=""; WORK_TYPE=""; PRIORITY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --body) BODY="$2"; shift 2 ;;
    --label) LABELS+=("$2"); shift 2 ;;
    --milestone) MILESTONE="$2"; shift 2 ;;
    --type) WORK_TYPE="$2"; shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --infra) INFRA=1; LABELS+=("agent-infra" "chore"); WORK_TYPE="${WORK_TYPE:-infra}"; shift ;;
    *) die "unknown arg $1" ;;
  esac
done
[[ -n "$TITLE" ]] || die "--title required"
bash "$(dirname "$0")/ensure-labels.sh" >/dev/null

if [[ ${#LABELS[@]} -eq 0 ]]; then
  LABELS+=("chore")
fi

if [[ "$INFRA" -eq 1 && -z "$MILESTONE" ]]; then
  MILESTONE="$(cfg infra_milestone)"
  MILESTONE="${MILESTONE:-Agent OS & Tooling}"
fi

ARGS=(issue create -R "$REPO" --title "$TITLE")
[[ -n "$BODY" ]] && ARGS+=(--body "$BODY")
LABELS=($(printf '%s\n' "${LABELS[@]}" | sort -u))
for L in "${LABELS[@]}"; do ARGS+=(--label "$L"); done

if [[ -n "$MILESTONE" ]]; then
  MNUM="$(bash "$(dirname "$0")/ensure-milestone.sh" 2>/dev/null | tail -1 || true)"
  # ensure-milestone uses infra title; if custom milestone, create/find it
  if [[ "$MILESTONE" != "$(cfg infra_milestone 2>/dev/null || echo 'Agent OS & Tooling')" ]]; then
    MNUM="$(gh api "repos/$REPO/milestones?state=open" --jq ".[] | select(.title==\"$MILESTONE\") | .number" 2>/dev/null | head -1 || true)"
    if [[ -z "$MNUM" ]]; then
      MNUM="$(gh api -X POST "repos/$REPO/milestones" -f title="$MILESTONE" -f description="Session arc" --jq .number)"
    fi
  else
    MNUM="$(bash "$(dirname "$0")/ensure-milestone.sh" | tail -1)"
  fi
  [[ -n "$MNUM" ]] && ARGS+=(--milestone "$MILESTONE")
fi

URL="$(gh "${ARGS[@]}")"
info "Created $URL"

POWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
if [[ -z "$POWNER" || "$POWNER" == "REPLACE_ORG" || -z "$PNUM" || "$PNUM" == "0" ]]; then
  echo "ERROR: Project V2 not configured — issue created but NOT on board." >&2
  echo "  Set project_owner + project_number in .github/agent-project.yml" >&2
  die "Project V2 required for open-unit"
fi

bash "$(dirname "$0")/project-sync.sh" add "$URL" || die "project-sync add failed"
bash "$(dirname "$0")/project-sync.sh" status "$URL" in_progress || echo "WARN: status in_progress failed" >&2
if [[ -n "$WORK_TYPE" ]]; then
  bash "$(dirname "$0")/project-sync.sh" type "$URL" "$WORK_TYPE" 2>/dev/null || true
fi
if [[ -n "$PRIORITY" ]]; then
  bash "$(dirname "$0")/project-sync.sh" priority "$URL" "$PRIORITY" 2>/dev/null || true
fi

echo "$URL"
