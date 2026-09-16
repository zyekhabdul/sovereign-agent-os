#!/usr/bin/env bash
set -euo pipefail

# clone-workspace.sh — Universal Git Org/User Workspace Cloner & Manager
# Usage:
#   clone-workspace list <org-or-user>
#   clone-workspace clone <org-or-user> <repo-name> [target-dir]
#   clone-workspace clone-all <org-or-user> [target-dir]

ACTION="${1:-help}"
ORG="${2:-}"
GIT_SSH_HOST="${GIT_SSH_HOST:-github.com}"

show_help() {
  echo "======================================================"
  echo "         UNIVERSAL WORKSPACE CLONE HELPER            "
  echo "======================================================"
  echo "Usage:"
  echo "  clone-workspace list <org-or-user>"
  echo "  clone-workspace clone <org-or-user> <repo-name> [target-dir]"
  echo "  clone-workspace clone-all <org-or-user> [target-dir]"
  echo ""
  echo "Environment variables:"
  echo "  GIT_SSH_HOST  SSH host alias (default: github.com)"
  echo "======================================================"
}

if [ "$ACTION" == "help" ] || [ -z "$ORG" ]; then
  show_help
  exit 0
fi

if [ "$ACTION" == "list" ]; then
  echo "======================================================"
  echo "       REPOSITORIES AVAILABLE UNDER: $ORG            "
  echo "======================================================"
  curl -s "https://api.github.com/users/${ORG}/repos?per_page=100" | jq -r '.[].name' | sort | nl
  echo "======================================================"
  echo "To clone a repo, run: clone-workspace clone $ORG <repo-name>"
  exit 0
fi

if [ "$ACTION" == "clone" ]; then
  REPO_NAME="${3:-}"
  if [ -z "$REPO_NAME" ]; then
    echo "[ ERROR ] Please specify repository name. Example: clone-workspace clone $ORG my-app"
    exit 1
  fi
  
  TARGET_DIR="${4:-$HOME/Projects/$ORG}"
  mkdir -p "$TARGET_DIR"
  DEST="$TARGET_DIR/$REPO_NAME"

  if [ -d "$DEST" ]; then
    echo "[ WARN ] Directory $DEST already exists. Pulling latest..."
    git -C "$DEST" pull origin main 2>/dev/null || git -C "$DEST" pull origin master 2>/dev/null || true
  else
    echo "Cloning git@${GIT_SSH_HOST}:${ORG}/${REPO_NAME}.git to $DEST..."
    git clone "git@${GIT_SSH_HOST}:${ORG}/${REPO_NAME}.git" "$DEST"
  fi
  echo "[ SUCCESS ] Repository ready at: $DEST"
  exit 0
fi

if [ "$ACTION" == "clone-all" ]; then
  TARGET_DIR="${3:-$HOME/Projects/$ORG}"
  mkdir -p "$TARGET_DIR"

  echo "Cloning ALL repositories under ${ORG} into $TARGET_DIR..."
  REPOS=$(curl -s "https://api.github.com/users/${ORG}/repos?per_page=100" | jq -r '.[].name')
  for r in $REPOS; do
    echo -e "\n>>> Cloning $r..."
    git clone "git@${GIT_SSH_HOST}:${ORG}/${r}.git" "$TARGET_DIR/$r" 2>/dev/null || echo "Skipping $r (already cloned or error)"
  done
  echo -e "\n[ SUCCESS ] All repos cloned into $TARGET_DIR"
  exit 0
fi

show_help
exit 1
