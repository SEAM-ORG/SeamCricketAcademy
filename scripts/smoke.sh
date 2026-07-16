#!/usr/bin/env bash
# Session smoke — fast known-good (not full pre-push). Agent OS Session Start.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "==> smoke: SeamCricketAcademy"
if [[ -f biome.json ]]; then
  bash "${HOME}/.config/agent-quality/check.sh" --changed 2>/dev/null \
    || npx biome check --files-ignore-unknown=true src 2>/dev/null \
    || npx biome check .
fi
if node -e "const p=require('./package.json'); process.exit(p.scripts&&p.scripts.test?0:1)" 2>/dev/null; then
  npm test
fi
echo "==> smoke OK"
