#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_lib.sh"
REPO="$(remote_repo)"
info "Ensuring labels on $REPO"
while IFS='=' read -r name color; do
  [[ -z "${name:-}" ]] && continue
  if gh label list -R "$REPO" --json name --jq '.[].name' | rg -qx "$name"; then
    echo "  label exists: $name"
  else
    gh label create "$name" -R "$REPO" --color "$color" --description "agent-managed" 2>/dev/null \
      || gh label create "$name" -R "$REPO" --color "$color" || true
    echo "  created label: $name"
  fi
done < <(cfg_labels)
