#!/bin/bash
# Install tracked git hook templates from .githooks/ into .git/hooks.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

HOOKS_SOURCE="$REPO_ROOT/.githooks"
HOOKS_TARGET="$REPO_ROOT/.git/hooks"

[ -d "$REPO_ROOT/.git" ] || { echo "Not a git repo"; exit 1; }
[ -d "$HOOKS_SOURCE" ] || { echo "Missing .githooks"; exit 1; }
mkdir -p "$HOOKS_TARGET"

installed=0
for name in pre-commit pre-push commit-msg; do
  src="$HOOKS_SOURCE/$name"
  if [ -f "$src" ]; then
    chmod +x "$src"
    cp "$src" "$HOOKS_TARGET/$name"
    chmod +x "$HOOKS_TARGET/$name"
    echo "  installed $name"
    installed=$((installed + 1))
  fi
done

if [ "$installed" -eq 0 ]; then
  echo "No hook files found in .githooks/"
  exit 1
fi

echo "Hooks active from .githooks/ ($installed installed). Re-run after clone: bash scripts/install-githooks.sh"
