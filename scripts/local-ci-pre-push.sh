#!/bin/bash
# Gold standard: pre-push = test + build
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"
echo "Local CI correctness (pre-push)..."
npm test
npm run build
echo "Correctness gate passed."
