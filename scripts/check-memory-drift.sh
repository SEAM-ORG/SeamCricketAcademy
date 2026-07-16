#!/usr/bin/env bash
# check-memory-drift.sh — pre-commit memory gate (Architect↔Agent OS gold standard)
# Blocks commits that change product reality without updating durable memory surfaces.
# Portable: copy or invoke from any product repo.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$REPO_ROOT" ]] || exit 0
cd "$REPO_ROOT"

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true)
if [[ -z "${STAGED_FILES//[$'\n' ]/}" ]]; then
  exit 0
fi

# Memory / durable-doc surfaces (any one counts as "memory updated")
is_memory_path() {
  local f="$1"
  case "$f" in
    AGENTS.md|DEVELOPMENT.md|CHANGELOG.md|README.md|PRD.md|PROJECT_CONTEXT.md|DESIGN_SYSTEM.md|DEPLOYMENT.md|SETUP.md|roadmap.md)
      return 0 ;;
    docs/*|tasks/*|.github/ai-context/*)
      return 0 ;;
  esac
  return 1
}

# Pure tooling / tests / self — do not alone require memory
is_exempt_path() {
  local f="$1"
  case "$f" in
    scripts/check-memory-drift.sh|.githooks/*|scripts/local-ci-pre-commit.sh|scripts/prepare-commit.sh|scripts/install-githooks.sh)
      return 0 ;;
    *test*|*_test.dart|*.test.ts|*.test.js|*.spec.ts|*.spec.js)
      return 0 ;;
    test/*|tests/*|**/test/**|**/tests/**)
      return 0 ;;
    *.lock|package-lock.json|pubspec.lock|yarn.lock|pnpm-lock.yaml)
      return 0 ;;
    *.md)
      # Doc-only commits are memory by definition
      return 0 ;;
  esac
  return 1
}

# Structural / stack config — always need memory
is_structural() {
  local f="$1"
  local base
  base="$(basename "$f")"
  case "$base" in
    package.json|package-lock.json|pubspec.yaml|pubspec.lock|Cargo.toml|go.mod|Gemfile|Podfile|build.gradle|settings.gradle|astro.config.*|vite.config.*|tsconfig*.json|tailwind.config.*|firebase.json|firestore.rules|firestore.indexes.json|storage.rules|trigger.yaml|shorebird.yaml|.env.example|CNAME)
      return 0 ;;
  esac
  case "$f" in
    firebase/*|ios/Podfile*|android/app/build.gradle*|functions/package.json|functions/src/index.ts)
      return 0 ;;
  esac
  return 1
}

# Product source — behavior that should not silently diverge from docs
is_source() {
  local f="$1"
  case "$f" in
    src/*|lib/*|app/*|pages/*|components/*|functions/src/*|firebase/functions/src/*|web/*)
      return 0 ;;
  esac
  # Dart under lib already covered; feature code in packages
  case "$f" in
    *.dart|*.astro|*.tsx|*.ts|*.jsx|*.js|*.vue|*.svelte)
      case "$f" in
        scripts/*|test/*|tests/*|*.test.*|*.spec.*|*_test.dart) return 1 ;;
        *) return 0 ;;
      esac
      ;;
  esac
  return 1
}

MEMORY=0
STRUCTURAL=""
SOURCE=""
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  if is_memory_path "$f"; then
    MEMORY=1
  fi
  if is_exempt_path "$f"; then
    continue
  fi
  if is_structural "$f"; then
    STRUCTURAL="${STRUCTURAL}${f}"$'\n'
  elif is_source "$f"; then
    SOURCE="${SOURCE}${f}"$'\n'
  fi
done <<< "$STAGED_FILES"

# Doc-only or memory-only commits: ok
if [[ -z "$STRUCTURAL" && -z "$SOURCE" ]]; then
  exit 0
fi

if [[ "$MEMORY" -eq 1 ]]; then
  exit 0
fi

echo "================================================================="
echo "MEMORY DRIFT: product reality changed without durable memory."
echo
if [[ -n "$STRUCTURAL" ]]; then
  echo "Structural / stack files staged:"
  printf '%s' "$STRUCTURAL" | sed 's/^/  - /'
fi
if [[ -n "$SOURCE" ]]; then
  echo "Product source staged (sample):"
  printf '%s' "$SOURCE" | head -15 | sed 's/^/  - /'
  COUNT=$(printf '%s' "$SOURCE" | grep -c . || true)
  if [[ "${COUNT:-0}" -gt 15 ]]; then
    echo "  ... +$((COUNT - 15) more"
  fi
fi
echo
echo "Stage at least one memory surface in the same commit:"
echo "  AGENTS.md (This Project) · docs/** · docs/INDEX.md · tasks/todo.md ·"
echo "  tasks/lessons.md · CHANGELOG.md · DEVELOPMENT.md · .github/ai-context/**"
echo
echo "Agent OS: continuous maintain — no silent doc drift. Never bypass git hooks."
echo "================================================================="
exit 1
