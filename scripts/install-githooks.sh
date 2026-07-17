#!/bin/bash
# Install tracked git hooks from .githooks/ via core.hooksPath (no copy drift).
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

HOOKS_SOURCE="$REPO_ROOT/.githooks"
[ -d "$REPO_ROOT/.git" ] || { echo "Not a git repo"; exit 1; }
[ -d "$HOOKS_SOURCE" ] || { echo "Missing .githooks"; exit 1; }

# Clear husky residue if present
if git config --local --get core.hooksPath >/dev/null 2>&1; then
  hp="$(git config --local --get core.hooksPath)"
  case "$hp" in
    .husky|.husky/*|*/.husky|*/.husky/*)
      git config --local --unset-all core.hooksPath || true
      echo "  cleared stale core.hooksPath=$hp (husky residue)"
      ;;
  esac
fi

installed=0
for name in pre-commit pre-push commit-msg; do
  src="$HOOKS_SOURCE/$name"
  if [ -f "$src" ]; then
    chmod +x "$src"
    installed=$((installed + 1))
    echo "  ready $name"
  fi
done

if [ "$installed" -eq 0 ]; then
  echo "No hook files found in .githooks/"
  exit 1
fi

# Tracked path — agents never miss hooks after clone when this script is run
git config --local core.hooksPath .githooks
echo "Hooks active: core.hooksPath=.githooks ($installed files). Re-run after clone: bash scripts/install-githooks.sh"
