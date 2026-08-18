#!/usr/bin/env bash
set -euo pipefail

# setup-tri-push.sh — Configures multi-forge remote ('all') for active platforms (GitHub + GitLab)
# Note: Codeberg & Gitea are frozen/optional due to quota limits; Bitbucket is removed.
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
      echo "Configures 'all' git remote pointing to active platforms (GitHub + GitLab)."
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

GITHUB_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
GITLAB_URL="git@gitlab.com:${GITLAB_USER}/${REPO_NAME}.git"
CODEBERG_URL="git@codeberg.org:${CODEBERG_USER}/${REPO_NAME}.git"
GITEA_URL="git@${GITEA_HOST}:${GITEA_USER}/${REPO_NAME}.git"

ENABLE_CODEBERG="${ENABLE_CODEBERG:-false}"
ENABLE_GITEA="${ENABLE_GITEA:-false}"

echo "=== Multi-Forge Git Remote Setup ==="
echo "Repository Path  : $REPO_PATH"
echo "Repository Name  : $REPO_NAME"
echo "GitHub (Active)  : $GITHUB_URL"
echo "GitLab (Active)  : $GITLAB_URL"
echo "Codeberg (Freeze): $CODEBERG_URL"
echo "Gitea (Freeze)   : $GITEA_URL"
echo "===================================="

if [ "$DRY_RUN" = true ]; then
  echo "[ DRY-RUN ] Commands to be executed:"
  echo "  git -C \"$REPO_PATH\" remote remove all 2>/dev/null || true"
  echo "  git -C \"$REPO_PATH\" remote add all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITLAB_URL\""
  if [ "$ENABLE_CODEBERG" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$CODEBERG_URL\""
  fi
  if [ "$ENABLE_GITEA" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITEA_URL\""
  fi
  exit 0
fi

# Execute git remote configuration
git -C "$REPO_PATH" remote remove all 2>/dev/null || true
git -C "$REPO_PATH" remote add all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITLAB_URL"

if [ "$ENABLE_CODEBERG" = "true" ]; then
  git -C "$REPO_PATH" remote set-url --add --push all "$CODEBERG_URL"
fi
if [ "$ENABLE_GITEA" = "true" ]; then
  git -C "$REPO_PATH" remote set-url --add --push all "$GITEA_URL"
fi

# Also ensure standalone remotes exist for selective individual pushes
git -C "$REPO_PATH" remote remove github 2>/dev/null || true
git -C "$REPO_PATH" remote add github "$GITHUB_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove gitlab 2>/dev/null || true
git -C "$REPO_PATH" remote add gitlab "$GITLAB_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove codeberg 2>/dev/null || true
git -C "$REPO_PATH" remote add codeberg "$CODEBERG_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove gitea 2>/dev/null || true
git -C "$REPO_PATH" remote add gitea "$GITEA_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove bitbucket 2>/dev/null || true

echo "[ SUCCESS ] Remote 'all' successfully configured (Active: GitHub + GitLab)!"
echo "To push to active platforms simultaneously, run:"
echo "  git push all <branch>"
