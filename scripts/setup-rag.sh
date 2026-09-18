#!/usr/bin/env bash
set -euo pipefail

# setup-rag.sh — Scaffolds 4-file Obsidian RAG memory schema for a project namespace
# Usage: ./setup-rag.sh <project-namespace> [repo-path]
#        ./setup-rag.sh --all

OBSIDIAN_VAULT="${OBSIDIAN_VAULT_PATH:-${VAULT_DIR:-$HOME/Documents/Obsidian Vault}}"
MEMORY_BASE="$OBSIDIAN_VAULT/00-AGY-Memory"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"

scaffold_single() {
  local NAMESPACE="$1"
  local REPO_PATH="${2:-$PROJECTS_DIR/$NAMESPACE}"
  local MEMORY_DIR="$MEMORY_BASE/$NAMESPACE"

  echo "=== Scaffolding Obsidian RAG Namespace: $NAMESPACE ==="
  mkdir -p "$MEMORY_DIR"

  local TIMESTAMP
  TIMESTAMP=$(date -Iseconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z")
  local GIT_HASH="initial"
  if [ -d "$REPO_PATH/.git" ]; then
    GIT_HASH=$(git -C "$REPO_PATH" rev-parse HEAD 2>/dev/null || echo "initial")
  fi

  # 1. INDEX.md
  if [ ! -f "$MEMORY_DIR/INDEX.md" ]; then
    cat << EOF > "$MEMORY_DIR/INDEX.md"
# INDEX.md — $NAMESPACE

- **Project Name**: \`$NAMESPACE\`
- **Repository Path**: \`$REPO_PATH\`
- **Latest Git Commit Hash**: \`$GIT_HASH\`
- **Last Memory Sync**: $TIMESTAMP
EOF
    echo "[ CREATED ] $MEMORY_DIR/INDEX.md"
  fi

  # 2. CONTEXT.md
  if [ ! -f "$MEMORY_DIR/CONTEXT.md" ]; then
    cat << EOF > "$MEMORY_DIR/CONTEXT.md"
# CONTEXT.md — $NAMESPACE

## High-Density Technical Overview
- **Repository**: \`$REPO_PATH\`
- **Stack & Runtime**: [Specify core runtime, framework, and database]
- **Architectural Constraints**: Zero over-engineering, minimalist code generation, strict security.
EOF
    echo "[ CREATED ] $MEMORY_DIR/CONTEXT.md"
  fi

  # 3. STATE.md
  if [ ! -f "$MEMORY_DIR/STATE.md" ]; then
    cat << EOF > "$MEMORY_DIR/STATE.md"
# STATE.md — $NAMESPACE

- **Last Session Timestamp**: $TIMESTAMP
- **Git Commit Hash**: \`$GIT_HASH\`
- **Active Task Phase**: Initial Scaffolding
- **Pending Deliverables**:
  - [ ] Initialize baseline architecture & PRD.
  - [ ] Implement core features per PLAN.md chunks.
EOF
    echo "[ CREATED ] $MEMORY_DIR/STATE.md"
  fi

  # 4. DECISIONS.md
  if [ ! -f "$MEMORY_DIR/DECISIONS.md" ]; then
    cat << EOF > "$MEMORY_DIR/DECISIONS.md"
# DECISIONS.md — $NAMESPACE

## ADR-001: [ACTIVE] Project Architecture Initialization
- **Date**: $(date +"%Y-%m-%d")
- **Context**: Project namespace memory initialized.
- **Decision**: Adhere to 4-file memory schema and strict namespace isolation.
EOF
    echo "[ CREATED ] $MEMORY_DIR/DECISIONS.md"
  fi

  echo "[ SUCCESS ] RAG Namespace '$NAMESPACE' ready at: $MEMORY_DIR"
}

if [ $# -lt 1 ]; then
  echo "Usage: $0 <project-namespace> [repo-path]"
  echo "       $0 --all"
  echo "Example: $0 shop.zyekh.com \$HOME/Projects/shop.zyekh.com"
  exit 1
fi

if [ "$1" = "--all" ]; then
  echo "[ RAG-SCAFFOLD ] Batch scaffolding all projects in $PROJECTS_DIR..."
  COUNT=0
  for repo in "$PROJECTS_DIR"/*; do
    [ -d "$repo" ] || continue
    repo_name="$(basename "$repo")"
    [[ "$repo_name" =~ ^(\.|_archive) ]] && continue
    scaffold_single "$repo_name" "$repo"
    COUNT=$((COUNT + 1))
  done
  echo "[ PASS ] Scaffolding verified across $COUNT projects."
  exit 0
fi

scaffold_single "$1" "${2:-$PROJECTS_DIR/$1}"
