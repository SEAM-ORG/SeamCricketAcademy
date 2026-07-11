#!/bin/bash
# Gold standard: pre-commit = quality (fast)
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
echo "Local CI quality (pre-commit)..."
# Prefer prettier if available on staged files; avoid full astro check (noisy/slow on this repo).
if command -v npx >/dev/null 2>&1 && [ -x node_modules/.bin/prettier ]; then
  STAGED=$(git diff --cached --name-only --diff-filter=ACMR -- '*.astro' '*.ts' '*.js' '*.css' '*.json' '*.md' 2>/dev/null || true)
  if [ -n "$STAGED" ]; then
    echo "$STAGED" | tr '\n' '\0' | xargs -0 npx prettier --check --ignore-unknown 2>/dev/null || {
      echo "Prettier check failed. Run: npx prettier --write <files>"
      exit 1
    }
  else
    echo "No staged style-able files."
  fi
else
  echo "NOTE: prettier not available — quality tool gap."
fi
echo "Quality gate passed."
