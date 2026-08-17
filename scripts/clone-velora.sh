#!/usr/bin/env bash
set -euo pipefail

# clone-velora.sh — Quick Clone & Workspace Helper for velora-1d repositories
# Usage:
#   clone-velora list                 -> List all repositories under velora-1d
#   clone-velora clone <repo-name>    -> Clone repository to ~/Projects/velora/<repo-name>
#   clone-velora clone-all            -> Clone all repositories under velora-1d

TARGET_DIR="${VELORA_WORKSPACE:-$HOME/Projects/velora}"
mkdir -p "$TARGET_DIR"

ACTION="${1:-list}"

if [ "$ACTION" == "list" ]; then
  echo "======================================================"
  echo "       REPOSITORIES AVAILABLE UNDER VELORA-1D         "
  echo "======================================================"
  curl -s "https://api.github.com/users/velora-1d/repos?per_page=100" | jq -r '.[].name' | sort | nl
  echo "======================================================"
  echo "To clone a repo, run: clone-velora clone <repo-name>"
  exit 0
fi

if [ "$ACTION" == "clone" ]; then
  REPO_NAME="${2:-}"
  if [ -z "$REPO_NAME" ]; then
    echo "[ ERROR ] Please specify repository name. Example: clone-velora clone chat.zyekh.com"
    exit 1
  fi
  
  DEST="$TARGET_DIR/$REPO_NAME"
  if [ -d "$DEST" ]; then
    echo "[ WARN ] Directory $DEST already exists. Pulling latest..."
    git -C "$DEST" pull origin main || git -C "$DEST" pull origin master || true
  else
    echo "Cloning https://github.com/velora-1d/$REPO_NAME.git to $DEST..."
    git clone "https://github.com/velora-1d/$REPO_NAME.git" "$DEST"
  fi
  echo "[ SUCCESS ] Repository ready at: $DEST"
  exit 0
fi

if [ "$ACTION" == "clone-all" ]; then
  echo "Cloning ALL repositories under velora-1d into $TARGET_DIR..."
  REPOS=$(curl -s "https://api.github.com/users/velora-1d/repos?per_page=100" | jq -r '.[].name')
  for r in $REPOS; do
    echo "\n>>> Cloning $r..."
    git clone "https://github.com/velora-1d/$r.git" "$TARGET_DIR/$r" 2>/dev/null || echo "Skipping $r (already cloned or error)"
  done
  echo "\n[ SUCCESS ] All repos cloned into $TARGET_DIR"
  exit 0
fi

echo "Invalid command. Usage: clone-velora [list | clone <repo> | clone-all]"
exit 1
