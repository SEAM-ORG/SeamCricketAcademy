#!/usr/bin/env bash
# Usage:
#   project-sync.sh add <issue-or-pr-url>
#   project-sync.sh status <issue-or-pr-url> <backlog|ready|in_progress|in_review|done>
#   project-sync.sh done <issue-or-pr-url>
#   project-sync.sh type <issue-or-pr-url> <feature|bug|chore|infra|security>
#   project-sync.sh priority <issue-or-pr-url> <p0|p1|p2|p3>
#
# Canonical: ~/.agents/scripts/github/project-sync.sh
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

OWNER="$(cfg project_owner)"
PNUM="$(cfg project_number)"
[[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" ]] || die "set project_owner in .github/agent-project.yml"
[[ -n "$PNUM" && "$PNUM" != "0" ]] || die "set project_number in .github/agent-project.yml (not 0)"
require_project_scopes || exit 1

STATUS_FIELD_NAME="$(cfg status_field)"; STATUS_FIELD_NAME="${STATUS_FIELD_NAME:-Status}"
TYPE_FIELD_NAME="$(cfg type_field)"; TYPE_FIELD_NAME="${TYPE_FIELD_NAME:-Work Type}"
PRIORITY_FIELD_NAME="$(cfg priority_field)"; PRIORITY_FIELD_NAME="${PRIORITY_FIELD_NAME:-Priority Level}"

cmd="${1:-}"
shift || true

project_id() {
  gh project view "$PNUM" --owner "$OWNER" --format json --jq .id
}

# Generic single-select option resolver
# Args: field_name stage_key map_prefix (status_map | type_map | priority_map)
option_id_for() {
  local field_name="$1" stage="$2" map_key="$3"
  local wanted
  wanted="$(python3 - "$CONFIG_FILE" "$map_key" "$stage" <<'PY'
import sys, re
path, map_key, stage = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    text = open(path, encoding="utf-8").read()
except FileNotFoundError:
    sys.exit(0)
m = re.search(rf'^{re.escape(map_key)}:\n((?:[ \t]+.+\n)+)', text, re.M)
if not m:
    # fallback: use stage as literal option name
    print(stage)
    sys.exit(0)
for line in m.group(1).splitlines():
    mm = re.match(r'\s+([A-Za-z0-9_]+):\s*(.+)$', line)
    if not mm:
        continue
    k, v = mm.group(1), mm.group(2).strip().strip('"').strip("'")
    v = re.split(r'\s+#', v, 1)[0].strip().strip('"').strip("'")
    if k == stage:
        print(v)
        sys.exit(0)
print(stage)
PY
)"
  [[ -n "$wanted" ]] || die "no $map_key entry for stage=$stage"
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
    names=[o.get("name") for o in opts]
    print("", file=sys.stderr)
    print(f"Option {wanted!r} not found on field {field_name!r}. Available: {names}", file=sys.stderr)
    sys.exit(2)
print(f"Field {field_name!r} not found", file=sys.stderr)
sys.exit(2)
' "$wanted" "$field_name"
}

field_id_for() {
  local field_name="$1"
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
' "$field_name"
}

find_item_id_for_url() {
  local url="$1"
  gh project item-list "$PNUM" --owner "$OWNER" --limit 200 --format json \
    | python3 -c '
import json,sys
url=sys.argv[1].rstrip("/")
data=json.load(sys.stdin)
items=data if isinstance(data,list) else data.get("items",[])
for it in items:
    c=it.get("content") or {}
    u=(c.get("url") or "")
    if isinstance(u,str) and u.rstrip("/")==url:
        print(it.get("id") or "")
        sys.exit(0)
sys.exit(1)
' "$url" 2>/dev/null || true
}

ensure_item() {
  local url="$1"
  local item_id add_json
  # Prefer id from item-add JSON (avoids item-list lag / pagination misses)
  add_json="$(gh project item-add "$PNUM" --owner "$OWNER" --url "$url" --format json 2>/dev/null || true)"
  if [[ -n "$add_json" ]]; then
    item_id="$(python3 -c 'import json,sys; d=json.loads(sys.argv[1]); print(d.get("id") or "")' "$add_json" 2>/dev/null || true)"
  fi
  if [[ -z "$item_id" ]]; then
    item_id="$(find_item_id_for_url "$url")"
  fi
  if [[ -z "$item_id" ]]; then
    sleep 2
    gh project item-add "$PNUM" --owner "$OWNER" --url "$url" --format json >/dev/null 2>&1 || true
    item_id="$(find_item_id_for_url "$url")"
  fi
  # GraphQL fallback by content url (paginate)
  if [[ -z "$item_id" ]]; then
    item_id="$(gh project item-list "$PNUM" --owner "$OWNER" --limit 500 --format json 2>/dev/null \
      | python3 -c '
import json,sys
url=sys.argv[1].rstrip("/")
data=json.load(sys.stdin)
items=data if isinstance(data,list) else data.get("items",[])
for it in items:
    c=it.get("content") or {}
    u=(c.get("url") or "").rstrip("/")
    if u==url:
        print(it.get("id") or "")
        sys.exit(0)
sys.exit(1)
' "$url" 2>/dev/null || true)"
  fi
  [[ -n "$item_id" ]] || die "could not resolve project item id for $url — is the repo linked to the project? (gh project link)"
  echo "$item_id"
}

set_single_select() {
  local url="$1" field_name="$2" stage="$3" map_key="$4"
  local item_id pid fid oid
  item_id="$(ensure_item "$url")"
  pid="$(project_id)"
  fid="$(field_id_for "$field_name")"
  oid="$(option_id_for "$field_name" "$stage" "$map_key")"
  gh project item-edit --project-id "$pid" --id "$item_id" --field-id "$fid" --single-select-option-id "$oid"
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
    set_single_select "$URL" "$STATUS_FIELD_NAME" "$STAGE" "status_map"
    echo "status updated → $STAGE"
    ;;
  type)
    URL="${1:-}"; STAGE="${2:-}"
    [[ -n "$URL" && -n "$STAGE" ]] || die "usage: project-sync.sh type <url> <feature|bug|chore|infra|security>"
    info "Set Work Type=$STAGE for $URL"
    set_single_select "$URL" "$TYPE_FIELD_NAME" "$STAGE" "type_map"
    echo "type updated → $STAGE"
    ;;
  priority)
    URL="${1:-}"; STAGE="${2:-}"
    [[ -n "$URL" && -n "$STAGE" ]] || die "usage: project-sync.sh priority <url> <p0|p1|p2|p3>"
    info "Set Priority=$STAGE for $URL"
    set_single_select "$URL" "$PRIORITY_FIELD_NAME" "$STAGE" "priority_map"
    echo "priority updated → $STAGE"
    ;;
  *)
    die "usage: project-sync.sh {add|status|done|type|priority} ..."
    ;;
esac
