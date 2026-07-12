#!/usr/bin/env bash
# Usage:
#   project-sync.sh add <issue-or-pr-url>
#   project-sync.sh status <issue-or-pr-url> <backlog|ready|in_progress|in_review|done>
#   project-sync.sh done <issue-or-pr-url>     # shortcut → status done
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

OWNER="$(cfg project_owner)"
PNUM="$(cfg project_number)"
[[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" ]] || die "set project_owner in .github/agent-project.yml"
[[ -n "$PNUM" && "$PNUM" != "0" ]] || die "set project_number in .github/agent-project.yml"
require_project_scopes || exit 1

STATUS_FIELD_NAME="$(cfg status_field)"; STATUS_FIELD_NAME="${STATUS_FIELD_NAME:-Status}"

cmd="${1:-}"
shift || true

project_id() {
  gh project view "$PNUM" --owner "$OWNER" --format json --jq .id
}

status_option_id() {
  local stage="$1" wanted
  wanted="$(cfg_map | awk -F= -v k="$stage" '$1==k{print $2; exit}')"
  [[ -n "$wanted" ]] || die "no status_map entry for stage=$stage in agent-project.yml"
  # list fields, find Status single-select options
  gh project field-list "$PNUM" --owner "$OWNER" --format json \
    | python3 -c '
import json,sys
wanted=sys.argv[1]; field_name=sys.argv[2]
data=json.load(sys.stdin)
fields=data if isinstance(data,list) else data.get("fields",data.get("items",[]))
for f in fields:
    name=f.get("name") or ""
    if name.lower()!=field_name.lower():
        continue
    opts=f.get("options") or []
    for o in opts:
        if (o.get("name") or "").lower()==wanted.lower():
            print(o.get("id") or "")
            sys.exit(0)
    # print available for error
    names=[o.get("name") for o in opts]
    print("", file=sys.stderr)
    print(f"Status option {wanted!r} not found. Available: {names}", file=sys.stderr)
    sys.exit(2)
print(f"Field {field_name!r} not found", file=sys.stderr)
sys.exit(2)
' "$wanted" "$STATUS_FIELD_NAME"
}

status_field_id() {
  gh project field-list "$PNUM" --owner "$OWNER" --format json \
    | python3 -c '
import json,sys
field_name=sys.argv[1]
data=json.load(sys.stdin)
fields=data if isinstance(data,list) else data.get("fields",data.get("items",[]))
for f in fields:
    if (f.get("name") or "").lower()==field_name.lower():
        print(f.get("id") or "")
        sys.exit(0)
sys.exit(2)
' "$STATUS_FIELD_NAME"
}

find_item_id_for_url() {
  local url="$1"
  # item-list JSON includes content.url
  gh project item-list "$PNUM" --owner "$OWNER" --limit 200 --format json \
    | python3 -c '
import json,sys
url=sys.argv[1].rstrip("/")
data=json.load(sys.stdin)
items=data if isinstance(data,list) else data.get("items",[])
for it in items:
    c=it.get("content") or {}
    u=(c.get("url") or c.get("repository") or "")
    if isinstance(u,str) and u.rstrip("/")==url:
        print(it.get("id") or "")
        sys.exit(0)
    # also match number in title path
sys.exit(1)
' "$url" 2>/dev/null || true
}

case "$cmd" in
  add)
    URL="${1:-}"; [[ -n "$URL" ]] || die "usage: project-sync.sh add <url>"
    info "Adding $URL to project $OWNER/$PNUM"
    gh project item-add "$PNUM" --owner "$OWNER" --url "$URL" --format json 2>/dev/null || \
      gh project item-add "$PNUM" --owner "$OWNER" --url "$URL" || true
    echo "added (or already present)"
    ;;
  status|done)
    if [[ "$cmd" == "done" ]]; then
      URL="${1:-}"; STAGE="done"
    else
      URL="${1:-}"; STAGE="${2:-}"
    fi
    [[ -n "$URL" && -n "$STAGE" ]] || die "usage: project-sync.sh status <url> <stage>"
    info "Set status=$STAGE for $URL"
    # ensure on board
    gh project item-add "$PNUM" --owner "$OWNER" --url "$URL" >/dev/null 2>&1 || true
    ITEM_ID="$(find_item_id_for_url "$URL")"
    if [[ -z "$ITEM_ID" ]]; then
      # re-add and list again
      gh project item-add "$PNUM" --owner "$OWNER" --url "$URL" --format json >/dev/null 2>&1 || true
      sleep 1
      ITEM_ID="$(find_item_id_for_url "$URL")"
    fi
    [[ -n "$ITEM_ID" ]] || die "could not resolve project item id for $URL — is it on the board?"
    PID="$(project_id)"
    FID="$(status_field_id)"
    OID="$(status_option_id "$STAGE")"
    gh project item-edit --project-id "$PID" --id "$ITEM_ID" --field-id "$FID" --single-select-option-id "$OID"
    echo "status updated → $STAGE"
    ;;
  *)
    die "usage: project-sync.sh {add|status|done} ..."
    ;;
esac
