#!/usr/bin/env bash
# Gold standard: pre-commit = quality (fast) + memory (no silent doc drift)
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
echo "Local CI quality (pre-commit)..."

if [ -x "$HOME/.config/agent-quality/check.sh" ]; then
  bash "$HOME/.config/agent-quality/check.sh" --staged
else
  echo "NOTE: ~/.config/agent-quality not installed — quality tool gap."
  if command -v npx >/dev/null 2>&1 && [ -x node_modules/.bin/prettier ]; then
    STAGED=$(git diff --cached --name-only --diff-filter=ACMR -- '*.astro' '*.ts' '*.js' '*.css' '*.json' '*.md' 2>/dev/null || true)
    if [ -n "$STAGED" ]; then
      echo "$STAGED" | tr '\n' '\0' | xargs -0 npx prettier --check --ignore-unknown || {
        echo "Prettier check failed. Run: bash ~/.config/agent-quality/format.sh --staged"
        exit 1
      }
    fi
  fi
fi

echo "Running memory drift check..."
bash scripts/check-memory-drift.sh

echo "Quality gate passed."
