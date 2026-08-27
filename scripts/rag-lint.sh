#!/usr/bin/env bash
# ==============================================================================
# RAG-LINT: Deterministic Obsidian RAG & Memory Governance Health Checker
# Spec: RFC-RAG-003 (5-Gate Validation Standard)
# ==============================================================================
set -euo pipefail

VAULT_DIR="/home/fuckadmin/Documents/Obsidian Vault"
MEMORY_DIR="${VAULT_DIR}/00-AGY-Memory"
MASTER_INDEX="${MEMORY_DIR}/00-MASTER-INDEX.md"

ERRORS=0
WARNINGS=0

echo "[ RAG-LINT ] Starting 5-Gate Vault Integrity Verification..."

# --- GATE 1: Scaffolding Completeness ---
echo "-> Checking Gate 1: 4-File Core Scaffolding..."
for dir in "${MEMORY_DIR}"/*/; do
    [ -d "$dir" ] || continue
    ns=$(basename "$dir")
    [[ "$ns" =~ ^(_|global|system|pgp|Projects|velora-account-backup) ]] && continue
    for file in "INDEX.md" "CONTEXT.md" "STATE.md" "DECISIONS.md"; do
        if [ ! -f "${dir}${file}" ]; then
            echo "[ ERROR ] [Gate 1] Missing ${file} in namespace: ${ns}"
            ERRORS=$((ERRORS + 1))
        fi
    done
done

# --- GATE 2: Master Index Hub Existence ---
echo "-> Checking Gate 2: Master Index Hub Existence..."
if [ ! -f "${MASTER_INDEX}" ]; then
    echo "[ ERROR ] [Gate 2] Master Hub ${MASTER_INDEX} not found"
    ERRORS=$((ERRORS + 1))
fi

# --- GATE 3: Anti-Knot Decoupling Invariant ---
echo "-> Checking Gate 3: Anti-Knot Solar System Linking..."
find "${MEMORY_DIR}" -type f -name "*.md" ! -name "INDEX.md" ! -name "00-MASTER-INDEX.md" ! -path "*/_archive/*" -print0 | while IFS= read -r -d '' file; do
    if grep -q "00-MASTER-INDEX.md" "$file" 2>/dev/null; then
        echo "[ WARN ] [Gate 3] Direct master link found in child note: $(basename "$file")"
    fi
done

# --- GATE 4: Token Capacity & Line Cap (<= 200 lines) ---
echo "-> Checking Gate 4: Line Cap Enforcement (Max 200 lines)..."
find "${MEMORY_DIR}" -type f -name "*.md" ! -path "*/_archive/*" -print0 | while IFS= read -r -d '' file; do
    lines=$(wc -l < "$file")
    if [ "$lines" -gt 200 ]; then
        echo "[ WARN ] [Gate 4] File exceeds 200 lines (${lines} lines): $(basename "$file")"
    fi
done

# --- GATE 5: Git Hash Parity Check ---
echo "-> Checking Gate 5: Git Hash Parity..."
if [ -d ".git" ]; then
    CURRENT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "")
    if [ -n "$CURRENT_HASH" ]; then
        CWD_NAME=$(basename "$(pwd)")
        STATE_FILE="${MEMORY_DIR}/${CWD_NAME}/STATE.md"
        if [ -f "$STATE_FILE" ]; then
            if ! grep -q "$CURRENT_HASH" "$STATE_FILE" 2>/dev/null; then
                echo "[ INFO ] [Gate 5] Current branch HEAD (${CURRENT_HASH:0:7}) not yet synced to ${CWD_NAME}/STATE.md"
            fi
        fi
    fi
fi

echo "--------------------------------------------------------"
if [ "$ERRORS" -gt 0 ]; then
    echo "[ FAIL ] RAG Lint encountered ${ERRORS} error(s)."
    exit 1
else
    echo "[ PASS ] RAG Lint completed successfully (0 errors)."
    exit 0
fi
