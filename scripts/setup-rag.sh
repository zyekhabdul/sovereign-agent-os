#!/usr/bin/env bash
set -euo pipefail

# setup-rag.sh — Thin dispatcher for 4-file Obsidian RAG memory scaffolding.
# Canonical writer is `agy-guard checkpoint` (single schema for
# 00-AGY-Memory namespaces). This script preserves the legacy CLI surface:
# Usage: ./setup-rag.sh <project-namespace> [repo-path]
#        ./setup-rag.sh --all

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"
AGY_GUARD="${AGY_GUARD:-$(command -v agy-guard 2>/dev/null || echo "$SCRIPT_DIR/../bin/agy-guard")}"

if [ ! -x "$AGY_GUARD" ] && ! command -v "$AGY_GUARD" >/dev/null 2>&1; then
  echo "[ ERROR ] agy-guard not found at $AGY_GUARD. Run install.sh first." >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 <project-namespace> [repo-path]"
  echo "       $0 --all"
  echo "Example: $0 shop.zyekh.com \$HOME/Projects/shop.zyekh.com"
  exit 1
fi

if [ "$1" = "--all" ]; then
  exec "$AGY_GUARD" scaffold-all-projects
fi

NAMESPACE="$1"
REPO_PATH="${2:-$PROJECTS_DIR/$1}"

if [ -d "$REPO_PATH" ]; then
  ( cd "$REPO_PATH" && exec "$AGY_GUARD" checkpoint -n "$NAMESPACE" --msg "Namespace initialized via setup-rag.sh" )
else
  echo "[ NOTE ] $REPO_PATH not found; scaffolding namespace from \$HOME."
  ( cd "$HOME" && exec "$AGY_GUARD" checkpoint -n "$NAMESPACE" --msg "Namespace initialized via setup-rag.sh" )
fi
