#!/usr/bin/env bash
set -euo pipefail

# setup-tri-push.sh / setup-penta-push.sh — Configures unified multi-forge remote ('all') for 5 platforms
# Supported platforms: GitHub + GitLab + Codeberg + Gitea + Bitbucket
# Usage: ./setup-tri-push.sh [--dry-run] [REPO_PATH] [REPO_NAME]

DRY_RUN=false
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [REPO_PATH] [REPO_NAME]"
      echo "Configures 'all' git remote pointing to 5 platforms (GitHub, GitLab, Codeberg, Gitea, Bitbucket)."
      exit 0
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

REPO_PATH="${POSITIONAL[0]:-.}"
REPO_NAME="${POSITIONAL[1]:-}"

REPO_PATH=$(cd "$REPO_PATH" && pwd)
if [ ! -d "$REPO_PATH/.git" ]; then
  echo "[ ERROR ] Target path is not a valid git repository: $REPO_PATH"
  exit 1
fi

if [ -z "$REPO_NAME" ]; then
  REPO_NAME=$(basename "$REPO_PATH")
fi

GITHUB_USER="${GITHUB_USER:-zyekhabdul}"
GITLAB_USER="${GITLAB_USER:-aomiqaza}"
CODEBERG_USER="${CODEBERG_USER:-aomiqaza}"
GITEA_HOST="${GITEA_HOST:-gitea.com}"
GITEA_USER="${GITEA_USER:-aomiqaza}"
BITBUCKET_USER="${BITBUCKET_USER:-aomiqaza}"

GITHUB_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
GITLAB_URL="git@gitlab.com:${GITLAB_USER}/${REPO_NAME}.git"
CODEBERG_URL="git@codeberg.org:${CODEBERG_USER}/${REPO_NAME}.git"
GITEA_URL="git@${GITEA_HOST}:${GITEA_USER}/${REPO_NAME}.git"
BITBUCKET_URL="git@bitbucket.org:${BITBUCKET_USER}/${REPO_NAME}.git"

echo "=== Penta-Forge (5 Platforms) Git Remote Setup ==="
echo "Repository Path  : $REPO_PATH"
echo "Repository Name  : $REPO_NAME"
echo "GitHub Remote    : $GITHUB_URL"
echo "GitLab Remote    : $GITLAB_URL"
echo "Codeberg Remote  : $CODEBERG_URL"
echo "Gitea Remote     : $GITEA_URL"
echo "Bitbucket Remote : $BITBUCKET_URL"
echo "=================================================="

if [ "$DRY_RUN" = true ]; then
  echo "[ DRY-RUN ] Commands to be executed:"
  echo "  git -C \"$REPO_PATH\" remote remove all 2>/dev/null || true"
  echo "  git -C \"$REPO_PATH\" remote add all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITLAB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$CODEBERG_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITEA_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$BITBUCKET_URL\""
  exit 0
fi

# Execute git remote configuration
git -C "$REPO_PATH" remote remove all 2>/dev/null || true
git -C "$REPO_PATH" remote add all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITLAB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$CODEBERG_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITEA_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$BITBUCKET_URL"

echo "[ SUCCESS ] Remote 'all' successfully configured for 5 platforms!"
echo "To push to all 5 platforms simultaneously, run:"
echo "  git push all <branch>"
