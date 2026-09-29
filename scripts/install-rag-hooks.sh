#!/usr/bin/env bash
# ==============================================================================
# INSTALL-RAG-HOOKS: Multi-Repo Git Post-Commit Auto-Sync Installer
# Canonical post-commit behavior lives in `agy-guard checkpoint` (single
# writer for 00-AGY-Memory 4-file schema). This script is a thin dispatcher:
# same repo loop + third-party skip as before, install via agy-guard.
# Spec: RFC-RAG-003 with Canonical Namespace Resolution
# ==============================================================================
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Projects}"
AGY_GUARD="${AGY_GUARD:-$(command -v agy-guard 2>/dev/null || echo "$SCRIPT_DIR/../bin/agy-guard")}"

echo "[ RAG-HOOKS ] Installing post-commit auto-sync hooks via agy-guard..."

if [ ! -x "$AGY_GUARD" ] && ! command -v "$AGY_GUARD" >/dev/null 2>&1; then
  echo "[ ERROR ] agy-guard not found at $AGY_GUARD. Run install.sh first." >&2
  exit 1
fi

INSTALLED=0
SKIPPED=0

for repo in "${PROJECTS_DIR}"/*; do
    [ -L "$repo" ] && continue
    if [ -d "${repo}/.git" ]; then
        _RAG_ORIGIN="$(git -C "$repo" config --get remote.origin.url 2>/dev/null || true)"
        if [ -n "$_RAG_ORIGIN" ] && ! echo "$_RAG_ORIGIN" | grep -Eq 'zyekhabdul|aomiqaza'; then
            echo "[ SKIP ] $(basename "$repo") (third-party upstream, RAG hook withheld)"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
        if ( cd "$repo" && "$AGY_GUARD" install-hook >/dev/null 2>&1 ); then
            INSTALLED=$((INSTALLED + 1))
        else
            echo "[ WARN ] Failed to install hook in $(basename "$repo")" >&2
        fi
    fi
done

echo "[ PASS ] Successfully installed post-commit hooks in ${INSTALLED} repositories (${SKIPPED} third-party skipped)."
exit 0
