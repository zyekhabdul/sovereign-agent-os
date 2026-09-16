#!/usr/bin/env bash
# ==============================================================================
# INSTALL-RAG-HOOKS: Multi-Repo Git Post-Commit Auto-Sync Installer
# Spec: RFC-RAG-003 with Canonical Namespace Resolution
# ==============================================================================
set -euo pipefail

VAULT_MEMORY="${VAULT_MEMORY:-$HOME/Documents/Obsidian Vault/00-AGY-Memory}"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"

echo "[ RAG-HOOKS ] Installing post-commit auto-sync hooks with namespace resolution..."

HOOK_CONTENT='#!/usr/bin/env bash
# Autonomous RAG State Sync Hook (RFC-RAG-003)
# Execute synchronously to guarantee git hash parity without race condition (< 50ms)
{
    REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    # Boundary Guard: Reject temporary or out-of-boundary directories
    if [[ "$REPO_DIR" =~ ^/tmp|^/var/tmp ]] || [[ "$REPO_DIR" != "${HOME}"* ]]; then
        exit 0
    fi
    REPO_NAME="$(basename "$REPO_DIR")"
    if [[ "$REPO_NAME" =~ ^tmp\. || "$REPO_NAME" == "tmp" ]]; then
        exit 0
    fi
    MEMORY_BASE="${HOME}/Documents/Obsidian Vault/00-AGY-Memory"
    
    # Try exact match, dot-to-dash match, or theme alias
    TARGET_DIR="${MEMORY_BASE}/${REPO_NAME}"
    if [ ! -d "$TARGET_DIR" ]; then
        DASH_NAME="${REPO_NAME//./-}"
        if [ -d "${MEMORY_BASE}/${DASH_NAME}" ]; then
            TARGET_DIR="${MEMORY_BASE}/${DASH_NAME}"
        fi
    fi
    
    HASH="$(git rev-parse HEAD 2>/dev/null || echo "unknown")"
    BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")"
    TIMESTAMP="$(date +"%Y-%m-%d %H:%M:%S")"
    
    # Auto-scaffold complete 4-file set if namespace directory or files are missing
    mkdir -p "$TARGET_DIR"
    
    # 1. INDEX.md
    if [ ! -f "${TARGET_DIR}/INDEX.md" ]; then
        cat << EOF > "${TARGET_DIR}/INDEX.md"
# PROJECT INDEX — ${REPO_NAME}

- **Project Name**: \`${REPO_NAME}\`
- **Repository Path**: \`${REPO_DIR}\`
- **Git Commit Hash**: \`${HASH}\`
- **Active Branch**: \`${BRANCH}\`
- **Last Memory Sync**: ${TIMESTAMP}
EOF
    fi

    # 2. CONTEXT.md
    if [ ! -f "${TARGET_DIR}/CONTEXT.md" ]; then
        cat << EOF > "${TARGET_DIR}/CONTEXT.md"
# PROJECT CONTEXT — ${REPO_NAME}

## Technical Overview
- **Repository**: \`${REPO_DIR}\`
- **Active Branch**: \`${BRANCH}\`
- **Architectural Constraints**: Minimalist code generation, Ponytail / YAGNI, 4-file RAG schema compliant.
EOF
    fi

    # 3. STATE.md
    MEMORY_FILE="${TARGET_DIR}/STATE.md"
    if [ ! -f "$MEMORY_FILE" ]; then
        cat << EOF > "$MEMORY_FILE"
# ACTIVE STATE — ${REPO_NAME}

- **Last Session Timestamp**: ${TIMESTAMP}
- **Git Commit Hash**: "${HASH}"
- **Active Branch**: \`${BRANCH}\`
- **Active Task Phase**: Active Development
- **Pending Deliverables**:
  - [ ] Implement features per PLAN.md chunks.
  - [ ] Maintain deterministic test and verification gates.
EOF
    else
        # Fast non-blocking update of header hash
        if grep -qi "git_commit_hash" "$MEMORY_FILE" 2>/dev/null; then
            sed -i -E "s/(git_commit_hash:).*/\1 \"$HASH\"/I" "$MEMORY_FILE" 2>/dev/null || true
            sed -i -E "s/(last_updated:).*/\1 \"$TIMESTAMP\"/I" "$MEMORY_FILE" 2>/dev/null || true
        fi
        if grep -qi "Git Commit" "$MEMORY_FILE" 2>/dev/null; then
            sed -i -E "s/(- \*\*Git Commit(\s*Hash)?\*\*:\s*).*/\1\`$HASH\`/I" "$MEMORY_FILE" 2>/dev/null || true
            sed -i -E "s/(- \*\*Last Checkpoint\*\*:\s*).*/\1$TIMESTAMP/I" "$MEMORY_FILE" 2>/dev/null || true
            sed -i -E "s/(- \*\*Last Session Timestamp\*\*:\s*).*/\1$TIMESTAMP/I" "$MEMORY_FILE" 2>/dev/null || true
        fi
    fi
    if [ -f "${TARGET_DIR}/INDEX.md" ]; then
        sed -i -E "s/(- \*\*(Latest )?Git Commit Hash\*\*:\s*).*/\1\`$HASH\`/I" "${TARGET_DIR}/INDEX.md" 2>/dev/null || true
        sed -i -E "s/(- \*\*Last Memory Sync\*\*:\s*).*/\1$TIMESTAMP/I" "${TARGET_DIR}/INDEX.md" 2>/dev/null || true
    fi

    # 4. DECISIONS.md
    if [ ! -f "${TARGET_DIR}/DECISIONS.md" ]; then
        cat << EOF > "${TARGET_DIR}/DECISIONS.md"
# ARCHITECTURAL DECISIONS (ADR) — ${REPO_NAME}

## Standard Laws
- **Law 1**: Ponytail / YAGNI - Minimalist code generation, zero unsolicited refactoring.
- **Law 2**: Empirical Verification - Always verify build/test before concluding task.
- **Law 3**: Git Push Guard - Remote push forbidden without explicit human command.
EOF
    fi
} 2>/dev/null || true
'

INSTALLED=0

for repo in "${PROJECTS_DIR}"/*; do
    [ -L "$repo" ] && continue
    if [ -d "${repo}/.git" ]; then
        HOOK_FILE="${repo}/.git/hooks/post-commit"
        echo "$HOOK_CONTENT" > "$HOOK_FILE"
        chmod +x "$HOOK_FILE"
        INSTALLED=$((INSTALLED + 1))
    fi
done

echo "[ PASS ] Successfully installed post-commit hooks in ${INSTALLED} repositories."
exit 0
