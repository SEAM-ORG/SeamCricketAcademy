#!/bin/bash
# scripts/create-pr.sh — thin portable wrapper around gh pr create
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

base_branch="main"
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -lt 2 ]] && { echo "--base requires a value"; exit 1; }
      base_branch="$2"
      args+=("$1" "$2")
      shift 2
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done

# Prefer repo default branch if main missing
if ! git show-ref --verify --quiet "refs/heads/${base_branch}" \
  && ! git show-ref --verify --quiet "refs/remotes/origin/${base_branch}"; then
  if git show-ref --verify --quiet refs/heads/master || git show-ref --verify --quiet refs/remotes/origin/master; then
    base_branch="master"
  fi
fi

current_branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
[[ -n "$current_branch" ]] || { echo "Detached HEAD — checkout a branch first"; exit 1; }

existing=$(gh pr list --head "$current_branch" --state open --json number --jq '.[0].number // ""' 2>/dev/null || true)
if [[ -n "$existing" ]]; then
  echo "Branch '$current_branch' already has open PR #$existing"
  exit 0
fi

# Ensure --base present
if [[ ! " ${args[*]-} " =~ " --base " ]]; then
  args+=(--base "$base_branch")
fi

if ! gh pr create "${args[@]}"; then
  if git ls-remote --exit-code --heads origin "$current_branch" >/dev/null 2>&1; then
    echo "PR create failed; deleting orphaned remote branch origin/$current_branch"
    git push origin --delete "$current_branch" || true
  fi
  exit 1
fi
