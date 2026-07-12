#!/usr/bin/env bash
# Create a product/infra Issue, label it, optional milestone, add to Project V2 as In Progress.
# Usage: open-unit.sh --title "..." [--body "..."] [--label chore] [--infra]
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"

TITLE=""; BODY=""; LABELS=(); INFRA=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --body) BODY="$2"; shift 2 ;;
    --label) LABELS+=("$2"); shift 2 ;;
    --infra) INFRA=1; LABELS+=("agent-infra" "chore"); shift ;;
    *) die "unknown arg $1" ;;
  esac
done
[[ -n "$TITLE" ]] || die "--title required"
bash "$(dirname "$0")/ensure-labels.sh" >/dev/null

ARGS=(issue create -R "$REPO" --title "$TITLE")
[[ -n "$BODY" ]] && ARGS+=(--body "$BODY")
if [[ ${#LABELS[@]} -gt 0 ]]; then
  # unique
  LABELS=($(printf '%s\n' "${LABELS[@]}" | sort -u))
  for L in "${LABELS[@]}"; do ARGS+=(--label "$L"); done
fi
if [[ "$INFRA" -eq 1 ]]; then
  MNUM="$(bash "$(dirname "$0")/ensure-milestone.sh" | tail -1)"
  [[ -n "$MNUM" ]] && ARGS+=(--milestone "$MNUM")
fi

URL="$(gh "${ARGS[@]}")"
info "Created $URL"
if [[ -f "$CONFIG_FILE" ]] && [[ "$(cfg project_number)" != "0" ]]; then
  bash "$(dirname "$0")/project-sync.sh" add "$URL" || true
  bash "$(dirname "$0")/project-sync.sh" status "$URL" in_progress || true
fi
echo "$URL"
