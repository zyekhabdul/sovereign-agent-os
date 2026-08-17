#!/usr/bin/env bash
set -euo pipefail

# setup-tri-push.sh — Configures unified multi-forge remote ('all') for GitHub + GitLab + Codeberg
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
      echo "Configures 'all' git remote pointing to GitHub, GitLab, and Codeberg."
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

GITHUB_URL="git@github.com:zyekhabdul/${REPO_NAME}.git"
GITLAB_URL="git@gitlab.com:aomiqaza/${REPO_NAME}.git"
CODEBERG_URL="git@codeberg.org:aomiqaza/${REPO_NAME}.git"

echo "=== Tri-Forge Git Remote Setup ==="
echo "Repository Path : $REPO_PATH"
echo "Repository Name : $REPO_NAME"
echo "GitHub Remote   : $GITHUB_URL"
echo "GitLab Remote   : $GITLAB_URL"
echo "Codeberg Remote : $CODEBERG_URL"
echo "=================================="

if [ "$DRY_RUN" = true ]; then
  echo "[ DRY-RUN ] Commands to be executed:"
  echo "  git -C \"$REPO_PATH\" remote remove all 2>/dev/null || true"
  echo "  git -C \"$REPO_PATH\" remote add all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITLAB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$CODEBERG_URL\""
  exit 0
fi

# Execute git remote configuration
git -C "$REPO_PATH" remote remove all 2>/dev/null || true
git -C "$REPO_PATH" remote add all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITLAB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$CODEBERG_URL"

echo "[ SUCCESS ] Remote 'all' successfully configured!"
echo "To push to all 3 platforms simultaneously, run:"
echo "  git push all <branch>"
