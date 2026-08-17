#!/usr/bin/env bash
set -euo pipefail

# sync-all-repos.sh — Scans ~/Projects/*, ensures Tri-Forge remotes ('all'), and optional batch push
# Usage: ./sync-all-repos.sh [--push] [--dry-run]

PROJECTS_DIR="${1:-$HOME/Projects}"
PUSH_MODE=false
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --push) PUSH_MODE=true ;;
    --dry-run) DRY_RUN=true ;;
  esac
done

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "======================================================"
echo "    TRI-FORGE MULTI-REPOSITORY REPOSITORY SYNCER      "
echo "======================================================"
echo "Projects Directory : $PROJECTS_DIR"
echo "Push Mode Enabled  : $PUSH_MODE"
echo "Dry Run Mode       : $DRY_RUN"
echo "======================================================"

for repo in "$PROJECTS_DIR"/*; do
  if [ -d "$repo/.git" ]; then
    REPO_NAME=$(basename "$repo")
    echo "\n>>> Processing: $REPO_NAME"
    
    if [ "$DRY_RUN" = true ]; then
      "$SCRIPT_DIR/setup-tri-push.sh" --dry-run "$repo" "$REPO_NAME"
    else
      "$SCRIPT_DIR/setup-tri-push.sh" "$repo" "$REPO_NAME"
      if [ "$PUSH_MODE" = true ]; then
        BRANCH=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
        echo "Pushing $REPO_NAME ($BRANCH) to all 3 platforms..."
        git -C "$repo" push all "$BRANCH" || echo "[ WARN ] Push failed for $REPO_NAME"
      fi
    fi
  fi
done

echo "\n======================================================"
echo "[ SUCCESS ] All repositories processed."
echo "======================================================"
