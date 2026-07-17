#!/usr/bin/env bash
# project-backfill.sh — wrapper around GraphQL paginated backfill.
# Usage: bash scripts/github/project-backfill.sh [--dry-run] [--skip-content] [--max N] [--limit N]
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) ARGS+=(--dry-run); shift ;;
    --skip-content) ARGS+=(--skip-content); shift ;;
    --max|--limit) ARGS+=(--max "$2"); shift 2 ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) die "unknown $1" ;;
  esac
done

OWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
[[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" && -n "$PNUM" && "$PNUM" != "0" ]] || die "project not configured"
require_project_scopes || exit 1

export BF_OWNER="$OWNER" BF_PNUM="$PNUM" BF_REPO="$(remote_repo)"
_tf="$(cfg type_field)"; export BF_TYPE_FIELD="${_tf:-Work Type}"
_pf="$(cfg priority_field)"; export BF_PRIO_FIELD="${_pf:-Priority Level}"
_ms="$(cfg infra_milestone)"; export BF_INFRA_MS="${_ms:-Agent OS & Tooling}"

DIR="$(cd "$(dirname "$0")" && pwd)"
PY="$DIR/project-backfill.py"
[[ -f "$PY" ]] || PY="${HOME}/.agents/scripts/github/project-backfill.py"
info "GraphQL backfill $OWNER #$PNUM via $PY"
if [[ ${#ARGS[@]} -gt 0 ]]; then
  exec python3 "$PY" "${ARGS[@]}"
else
  exec python3 "$PY"
fi
