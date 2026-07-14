#!/usr/bin/env bash
# Gold standard: pre-commit = quality (fast)
# Uses machine-global agent-quality (language-aware) + optional project overrides.
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
echo "Local CI quality (pre-commit)..."

if [ -x "$HOME/.config/agent-quality/check.sh" ]; then
  bash "$HOME/.config/agent-quality/check.sh" --staged
else
  echo "NOTE: ~/.config/agent-quality not installed — quality tool gap."
  echo "      Install kit or run: see Agent OS Local CI docs."
  # Fallback: project-local prettier if present
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

echo "Quality gate passed."
