#!/usr/bin/env bash
# Gold standard: pre-commit = quality (fast) + memory (no silent doc drift)
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
echo "Local CI quality (pre-commit)..."

if [ -x "$HOME/.config/agent-quality/check.sh" ]; then
  bash "$HOME/.config/agent-quality/check.sh" --staged
else
  echo "NOTE: ~/.config/agent-quality not installed — using project Biome fallback."
  if [ -x node_modules/.bin/biome ] || command -v biome >/dev/null 2>&1; then
    BBIN="biome"
    [ -x node_modules/.bin/biome ] && BBIN="node_modules/.bin/biome"
    STAGED=$(git diff --cached --name-only --diff-filter=ACMR -- \
      '*.astro' '*.ts' '*.tsx' '*.js' '*.jsx' '*.mjs' '*.cjs' '*.css' '*.json' '*.jsonc' 2>/dev/null || true)
    if [ -n "$STAGED" ]; then
      # shellcheck disable=SC2086
      echo "$STAGED" | tr '\n' '\0' | xargs -0 $BBIN check --no-errors-on-unmatched || {
        echo "Biome check failed. Fix: bash ~/.config/agent-quality/format.sh --staged"
        exit 1
      }
    fi
  fi
fi

echo "Running memory drift check..."
bash scripts/check-memory-drift.sh

echo "Quality gate passed."
