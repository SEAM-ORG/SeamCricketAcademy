#!/usr/bin/env bash
# session-end-return-main.sh
#
# Hard Session End gate: leave the workspace on the protected branch (main),
# clean tree, and (when a remote exists) fast-forwarded to origin.
#
# Usage (from a product repo root, or via scripts/github/session-end-return-main.sh):
#   bash session-end-return-main.sh [--allow-dirty] [--no-fetch]
#
# Exit codes:
#   0  on protected branch, clean (or --allow-dirty), ready for next session
#   1  dirty tree / unmerged feature branch / missing protected branch
set -euo pipefail

ALLOW_DIRTY=0
NO_FETCH=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --allow-dirty) ALLOW_DIRTY=1; shift ;;
    --no-fetch) NO_FETCH=1; shift ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
    *) echo "ERROR: unknown arg: $1" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$REPO_ROOT" ]] || { echo "ERROR: not inside a git repo" >&2; exit 1; }
cd "$REPO_ROOT"

die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "→ $*"; }

# Prefer project config when present
BASE="main"
if [[ -f "$REPO_ROOT/scripts/github/_lib.sh" ]]; then
  # shellcheck disable=SC1091
  source "$REPO_ROOT/scripts/github/_lib.sh"
  BASE="$(cfg protected_branch 2>/dev/null || true)"
  BASE="${BASE:-main}"
elif [[ -f "$REPO_ROOT/.github/agent-project.yml" ]]; then
  BASE="$(python3 - "$REPO_ROOT/.github/agent-project.yml" <<'PY'
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
m = re.search(r'^protected_branch:\s*(.+)$', text, re.M)
print(m.group(1).strip().strip('"').strip("'") if m else "main")
PY
)"
fi
BASE="${BASE:-main}"

if [[ -n "$(git status --porcelain)" ]]; then
  if [[ "$ALLOW_DIRTY" -eq 1 ]]; then
    info "WARNING: dirty tree (--allow-dirty); still returning to $BASE"
  else
    die "dirty tree on $(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo DETACHED). Commit or PARK before Session End return-to-main."
  fi
fi

BRANCH="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo DETACHED)"
HAS_REMOTE=0
if git remote get-url origin >/dev/null 2>&1; then
  HAS_REMOTE=1
fi

if [[ "$HAS_REMOTE" -eq 1 && "$NO_FETCH" -eq 0 ]]; then
  git fetch origin --prune 2>/dev/null || true
fi

return_to_base() {
  if git show-ref --verify --quiet "refs/heads/$BASE"; then
    git checkout "$BASE"
  elif [[ "$HAS_REMOTE" -eq 1 ]] && git show-ref --verify --quiet "refs/remotes/origin/$BASE"; then
    git checkout -B "$BASE" "origin/$BASE"
  else
    die "protected branch '$BASE' not found locally or on origin"
  fi

  if [[ "$HAS_REMOTE" -eq 1 ]]; then
    if git show-ref --verify --quiet "refs/remotes/origin/$BASE"; then
      git pull --ff-only origin "$BASE" 2>/dev/null \
        || git reset --hard "origin/$BASE"
    fi
  fi
}

# Already on protected branch
if [[ "$BRANCH" == "$BASE" ]]; then
  if [[ "$HAS_REMOTE" -eq 1 ]] && git show-ref --verify --quiet "refs/remotes/origin/$BASE"; then
    LOCAL="$(git rev-parse HEAD)"
    REMOTE="$(git rev-parse "origin/$BASE")"
    if [[ "$LOCAL" != "$REMOTE" ]]; then
      AHEAD="$(git rev-list --count "origin/$BASE"..HEAD 2>/dev/null || echo 0)"
      BEHIND="$(git rev-list --count HEAD.."origin/$BASE" 2>/dev/null || echo 0)"
      if [[ "${AHEAD:-0}" -gt 0 ]]; then
        die "on $BASE but ahead of origin/$BASE by $AHEAD commit(s). Rehome to a feature branch + ship-unit.sh (never leave unpushed work stranded on protected without ship)."
      fi
      if [[ "${BEHIND:-0}" -gt 0 ]]; then
        info "on $BASE behind origin by $BEHIND — fast-forwarding"
        git pull --ff-only origin "$BASE" || git reset --hard "origin/$BASE"
      fi
    fi
  fi
  info "READY on $BASE @ $(git rev-parse --short HEAD) (clean slate for next session)"
  git status -sb
  exit 0
fi

# Feature / other branch
if [[ "$BRANCH" == "DETACHED" ]]; then
  die "detached HEAD — checkout a branch and ship, or return to $BASE intentionally"
fi

if [[ "$HAS_REMOTE" -eq 0 ]]; then
  info "No origin remote — merging '$BRANCH' into local $BASE for clean slate"
  return_to_base
  if git merge-base --is-ancestor "$BRANCH" HEAD 2>/dev/null; then
    info "Branch $BRANCH already contained in $BASE"
  else
    git merge --no-ff "$BRANCH" -m "chore(session-end): merge $BRANCH into $BASE (local-only repo)"
  fi
  git branch -d "$BRANCH" 2>/dev/null || git branch -D "$BRANCH" 2>/dev/null || true
  info "READY on $BASE @ $(git rev-parse --short HEAD) (local-only repo)"
  git status -sb
  exit 0
fi

# Remote exists: only return if branch is fully merged into origin/BASE
if git merge-base --is-ancestor HEAD "origin/$BASE" 2>/dev/null; then
  info "Branch $BRANCH is merged into origin/$BASE — checking out protected"
  MERGED_BRANCH="$BRANCH"
  return_to_base
  git branch -d "$MERGED_BRANCH" 2>/dev/null || true
  info "READY on $BASE @ $(git rev-parse --short HEAD)"
  git status -sb
  exit 0
fi

# Unmerged commits remain
COUNT="$(git rev-list --count "origin/$BASE"..HEAD 2>/dev/null || echo '?')"
die "branch '$BRANCH' has $COUNT unmerged commit(s) vs origin/$BASE. Run: bash scripts/github/ship-unit.sh  (then re-run this script). Do not leave Architect on a feature branch at Session End."
