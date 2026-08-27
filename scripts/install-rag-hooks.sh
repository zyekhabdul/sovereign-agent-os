#!/usr/bin/env bash
# ==============================================================================
# INSTALL-RAG-HOOKS: Multi-Repo Git Post-Commit Auto-Sync Installer
# Spec: RFC-RAG-003 with Canonical Namespace Resolution
# ==============================================================================
set -euo pipefail

VAULT_MEMORY="/home/fuckadmin/Documents/Obsidian Vault/00-AGY-Memory"
PROJECTS_DIR="/home/fuckadmin/Projects"

echo "[ RAG-HOOKS ] Installing post-commit auto-sync hooks with namespace resolution..."

HOOK_CONTENT='#!/usr/bin/env bash
# Autonomous RAG State Sync Hook (RFC-RAG-003)
(
    REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    REPO_NAME="$(basename "$REPO_DIR")"
    MEMORY_BASE="/home/fuckadmin/Documents/Obsidian Vault/00-AGY-Memory"
    
    # Try exact match, dot-to-dash match, or theme alias
    TARGET_DIR="${MEMORY_BASE}/${REPO_NAME}"
    if [ ! -d "$TARGET_DIR" ]; then
        DASH_NAME="${REPO_NAME//./-}"
        if [ -d "${MEMORY_BASE}/${DASH_NAME}" ]; then
            TARGET_DIR="${MEMORY_BASE}/${DASH_NAME}"
        fi
    fi
    
    MEMORY_FILE="${TARGET_DIR}/STATE.md"
    
    if [ -f "$MEMORY_FILE" ]; then
        HASH="$(git rev-parse HEAD 2>/dev/null || echo "unknown")"
        BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")"
        TIMESTAMP="$(date +"%Y-%m-%d %H:%M:%S")"
        
        # Fast non-blocking update of header hash
        if grep -q "git_commit_hash:" "$MEMORY_FILE"; then
            sed -i "s/git_commit_hash:.*/git_commit_hash: \"$HASH\"/" "$MEMORY_FILE" 2>/dev/null || true
            sed -i "s/last_updated:.*/last_updated: \"$TIMESTAMP\"/" "$MEMORY_FILE" 2>/dev/null || true
        fi
    fi
) &>/dev/null &
'

INSTALLED=0

for repo in "${PROJECTS_DIR}"/*; do
    if [ -d "${repo}/.git" ]; then
        HOOK_FILE="${repo}/.git/hooks/post-commit"
        echo "$HOOK_CONTENT" > "$HOOK_FILE"
        chmod +x "$HOOK_FILE"
        INSTALLED=$((INSTALLED + 1))
    fi
done

echo "[ PASS ] Successfully installed post-commit hooks in ${INSTALLED} repositories."
exit 0
