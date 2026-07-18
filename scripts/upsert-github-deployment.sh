#!/bin/bash
# scripts/upsert-github-deployment.sh
# Create or update a GitHub Deployment environment record and optionally post a status.
set -euo pipefail

ENVIRONMENT=""
REF=""
TAG=""
DEPLOYMENT_DESCRIPTION=""
STATUS_DESCRIPTION=""
STATE=""
LOG_URL=""
PRODUCTION="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --environment) ENVIRONMENT="$2"; shift 2 ;;
        --ref) REF="$2"; shift 2 ;;
        --tag) TAG="$2"; shift 2 ;;
        --deployment-description) DEPLOYMENT_DESCRIPTION="$2"; shift 2 ;;
        --status-description) STATUS_DESCRIPTION="$2"; shift 2 ;;
        --state) STATE="$2"; shift 2 ;;
        --log-url) LOG_URL="$2"; shift 2 ;;
        --production) PRODUCTION="$2"; shift 2 ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$ENVIRONMENT" || -z "$REF" || -z "$DEPLOYMENT_DESCRIPTION" ]]; then
    echo "Usage: $0 --environment <name> --ref <sha> --deployment-description <text> [--tag <tag>] [--state <state>] [--status-description <text>] [--log-url <url>] [--production true|false]" >&2
    exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
    echo "GitHub CLI (gh) is required." >&2
    exit 1
fi

if [[ -z "${GH_TOKEN:-}" ]] && ! gh api /user >/dev/null 2>&1; then
    echo "GitHub CLI is not authenticated. Run 'gh auth login' first." >&2
    exit 1
fi

REPO_FULL="${GITHUB_REPOSITORY:-$(gh repo view --json nameWithOwner --jq '.nameWithOwner')}"

DEPLOYMENT_ID="$(gh api "repos/$REPO_FULL/deployments?environment=$ENVIRONMENT&per_page=100" -q ".[] | select(.ref == \"$REF\") | .id" 2>/dev/null | head -n 1 || true)"

if [[ -z "$DEPLOYMENT_ID" ]]; then
    DEPLOYMENT_ID="$(ENVIRONMENT="$ENVIRONMENT" REF="$REF" DEPLOYMENT_DESCRIPTION="$DEPLOYMENT_DESCRIPTION" PRODUCTION="$PRODUCTION" python3 - <<'PY' | gh api --method POST -H 'Accept: application/vnd.github+json' "repos/$REPO_FULL/deployments" --input - --jq '.id'
import json
import os

print(
    json.dumps(
        {
            "ref": os.environ["REF"],
            "environment": os.environ["ENVIRONMENT"],
            "description": os.environ["DEPLOYMENT_DESCRIPTION"],
            "auto_merge": False,
            "required_contexts": [],
            "transient_environment": False,
            "production_environment": os.environ["PRODUCTION"].lower() == "true",
        }
    )
)
PY
    )"
fi

if [[ -n "$STATE" ]]; then
    LATEST_STATE="$(gh api "repos/$REPO_FULL/deployments/$DEPLOYMENT_ID/statuses?per_page=1" --jq '.[0].state // empty' 2>/dev/null || true)"

    if [[ "$STATE" == "pending" || "$STATE" == "queued" ]] && [[ "$LATEST_STATE" =~ ^(success|failure|error|inactive)$ ]]; then
        echo "$DEPLOYMENT_ID"
        exit 0
    fi

    STATUS_ARGS=(api --method POST -H 'Accept: application/vnd.github+json' "repos/$REPO_FULL/deployments/$DEPLOYMENT_ID/statuses" -f state="$STATE")

    if [[ -n "$STATUS_DESCRIPTION" ]]; then
        STATUS_ARGS+=(-f description="$STATUS_DESCRIPTION")
    fi

    if [[ -n "$LOG_URL" ]]; then
        STATUS_ARGS+=(-f log_url="$LOG_URL")
    fi

    gh "${STATUS_ARGS[@]}" >/dev/null
fi

echo "$DEPLOYMENT_ID"
