#!/usr/bin/env bash
# Shared helpers for agent GitHub hygiene (sourced by other scripts).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}"

CONFIG_FILE="${REPO_ROOT}/.github/agent-project.yml"

die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "→ $*"; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

need_cmd gh
need_cmd git
need_cmd python3

# Parse simple YAML keys we care about (no full YAML dep)
cfg() {
  local key="$1"
  python3 - "$CONFIG_FILE" "$key" <<'PY'
import sys, re
path, key = sys.argv[1], sys.argv[2]
try:
    text = open(path, encoding="utf-8").read()
except FileNotFoundError:
    sys.exit(0)
# top-level scalar: key: value
m = re.search(rf'^{re.escape(key)}:\s*(.+)$', text, re.M)
if not m:
    sys.exit(0)
val = m.group(1).strip().strip('"').strip("'")
if val.startswith("#") or val == "":
    sys.exit(0)
# strip inline comment
val = re.split(r'\s+#', val, 1)[0].strip().strip('"').strip("'")
print(val)
PY
}

cfg_map() {
  # print status_map as lines: key=value
  python3 - "$CONFIG_FILE" <<'PY'
import sys, re
path = sys.argv[1]
try:
    text = open(path, encoding="utf-8").read()
except FileNotFoundError:
    sys.exit(0)
# extract status_map block
m = re.search(r'^status_map:\n((?:[ \t]+.+\n)+)', text, re.M)
if not m:
    sys.exit(0)
for line in m.group(1).splitlines():
    mm = re.match(r'\s+([a-z_]+):\s*(.+)$', line)
    if not mm:
        continue
    k, v = mm.group(1), mm.group(2).strip().strip('"').strip("'")
    v = re.split(r'\s+#', v, 1)[0].strip().strip('"').strip("'")
    print(f"{k}={v}")
PY
}

cfg_labels() {
  python3 - "$CONFIG_FILE" <<'PY'
import sys, re
path = sys.argv[1]
try:
    text = open(path, encoding="utf-8").read()
except FileNotFoundError:
    # defaults
    for k,v in [("bug","d73a4a"),("enhancement","a2eeef"),("chore","ededed"),("agent-infra","5319e7"),("security","b60205")]:
        print(f"{k}={v}")
    sys.exit(0)
m = re.search(r'^labels:\n((?:[ \t]+.+\n)+)', text, re.M)
if not m:
    sys.exit(0)
for line in m.group(1).splitlines():
    mm = re.match(r'\s+([A-Za-z0-9_.-]+):\s*([0-9a-fA-F]+)', line)
    if mm:
        print(f"{mm.group(1)}={mm.group(2)}")
PY
}

repo_slug() {
  local url
  url="$(git remote get-url origin 2>/dev/null || true)"
  [[ -n "$url" ]] || die "no git remote origin — cannot run GitHub hygiene"
  # git@github.com:org/repo.git or https://github.com/org/repo.git
  python3 - "$url" <<'PY'
import sys,re
u=sys.argv[1]
u=u.replace('git@github.com:','').replace('https://github.com/','').replace('http://github.com/','').removesuffix('.git')
print(u)
PY
}

has_scope() {
  # gh auth status text includes Token scopes
  gh auth status -t 2>&1 | tr ',' '\n' | rg -q "$1" && return 0
  gh auth status 2>&1 | rg -q "'$1'" && return 0
  return 1
}

require_project_scopes() {
  if ! has_scope 'project' && ! has_scope 'read:project'; then
    cat >&2 <<'MSG'
ERROR: gh token missing Project scopes (project / read:project).
Architect or agent must run once on this machine:
  gh auth refresh -s project,read:project -h github.com
Then re-run this script. (No GitHub Actions — agents use gh CLI only.)
MSG
    return 1
  fi
  return 0
}

remote_repo() { repo_slug; }

protected_branch() { cfg protected_branch; echo "${protected_branch:-main}"; }
