#!/usr/bin/env bash
# One-shot: labels, milestone, scope check, optional project link.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/_lib.sh"
info "GitHub bootstrap for $(remote_repo)"
bash "$DIR/ensure-labels.sh"
bash "$DIR/ensure-milestone.sh" >/dev/null || true
if require_project_scopes 2>/dev/null; then
  OWNER="$(cfg project_owner)"; PNUM="$(cfg project_number)"
  if [[ -n "$OWNER" && "$OWNER" != "REPLACE_ORG" && "$PNUM" != "0" ]]; then
    info "Linking repo to project $OWNER/$PNUM (if not linked)"
    # gh project link
    gh project link "$PNUM" --owner "$OWNER" --repo "$(remote_repo)" 2>&1 || true
  else
    info "Configure project_owner + project_number in .github/agent-project.yml then re-run"
  fi
else
  info "Add scopes: gh auth refresh -s project,read:project -h github.com"
fi
info "Bootstrap complete"
