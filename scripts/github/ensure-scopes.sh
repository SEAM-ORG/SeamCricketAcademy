#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
info "Checking gh auth scopes for Project V2..."
if require_project_scopes; then
  info "Project scopes OK"
  gh auth status 2>&1 | rg -i 'scopes|Logged' || true
  exit 0
fi
exit 1
