#!/usr/bin/env bash
set -euo pipefail

# sync-all-repos.sh — Scans ~/Projects/*, ensures 5-Platform remotes ('all'), and optional batch push
# Usage: ./sync-all-repos.sh [--push] [--dry-run]

PROJECTS_DIR="$HOME/Projects"
PUSH_MODE=false
DRY_RUN=false
PENTA_MODE=false
POSITIONAL=()

for arg in "$@"; do
  case "$arg" in
    --push) PUSH_MODE=true ;;
    --dry-run) DRY_RUN=true ;;
    --penta|--all-forges) PENTA_MODE=true ;;
    *) POSITIONAL+=("$arg") ;;
  esac
done

if [ ${#POSITIONAL[@]} -gt 0 ]; then
  PROJECTS_DIR="${POSITIONAL[0]}"
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "======================================================"
echo "      MULTI-FORGE REPOSITORY SYNCER (ACTIVE FORGES)   "
echo "======================================================"
echo "Projects Directory : $PROJECTS_DIR"
echo "Push Mode Enabled  : $PUSH_MODE"
echo "Penta Mode Enabled : $PENTA_MODE"
echo "Dry Run Mode       : $DRY_RUN"
echo "======================================================"

for repo in "$PROJECTS_DIR"/*; do
  [ -L "$repo" ] && continue
  if [ -d "$repo/.git" ]; then
    REPO_NAME=$(basename "$repo")
    echo -e "\n>>> Processing: $REPO_NAME"
    
    SETUP_ARGS=()
    [ "$DRY_RUN" = true ] && SETUP_ARGS+=("--dry-run")
    [ "$PENTA_MODE" = true ] && SETUP_ARGS+=("--penta")
    SETUP_ARGS+=("$repo")
    
    "$SCRIPT_DIR/setup-tri-push.sh" "${SETUP_ARGS[@]}"
    if [ "$PUSH_MODE" = true ] && [ "$DRY_RUN" = false ]; then
      BRANCH=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
      echo "Pushing $REPO_NAME ($BRANCH) to active platforms..."
      ALLOW_GIT_PUSH=1 git -C "$repo" push all "$BRANCH" || echo "[ WARN ] Push failed for $REPO_NAME"
    fi
  fi
done

echo -e "\n======================================================"
echo "[ SUCCESS ] All repositories processed successfully."
echo "======================================================"
