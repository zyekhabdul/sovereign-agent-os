#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# AI AGENT STANDARDS & GOVERNANCE — ONE-SHOT UNIVERSAL INSTALLER
# ==============================================================================
# This script configures any Linux/macOS machine to be 100% compliant with
# the Sovereign AI Agent Governance Standard (agy-guard, 9 formal rules,
# Obsidian RAG, Git Push Interceptor, and Lean Skills Context).
#
# Usage:
#   bash install.sh
# ==============================================================================

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "======================================================"
echo "   SOVEREIGN AI AGENT GOVERNANCE — SYSTEM INSTALLER   "
echo "======================================================"

# 1. Ensure Local Binaries Directory Exists & in PATH
mkdir -p "$HOME/.local/bin"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# 2. Install agy-guard CLI Tool (v5.0)
echo "[ 1/7 ] Installing agy-guard CLI to ~/.local/bin/agy-guard..."
cp "$SCRIPT_DIR/bin/agy-guard" "$HOME/.local/bin/agy-guard"
chmod +x "$HOME/.local/bin/agy-guard"

# 3. Create Core AI Directory Trees
echo "[ 2/7 ] Initializing AI agent directory structure..."
mkdir -p "$HOME/.gemini/config/rules"
mkdir -p "$HOME/.gemini/config/plugins"
mkdir -p "$HOME/.agents/skills"
mkdir -p "$HOME/.agents/skills_archive"
mkdir -p "$HOME/Projects"
mkdir -p "$HOME/Documents/Obsidian Vault/00-AGY-Memory"
mkdir -p "$HOME/Documents/Obsidian Vault/09-Panduan-Projek"

# 4. Deploy 15 Formal Rule Specifications, Guides & Helper Scripts
echo "[ 3/7 ] Deploying 15 formal binding rule files, project guides & scripts..."
cp -v "$SCRIPT_DIR/rules/"*.md "$HOME/.gemini/config/rules/"
cp -v "$SCRIPT_DIR/docs/"*.md "$HOME/Documents/Obsidian Vault/09-Panduan-Projek/"
mkdir -p "$HOME/scripts"
cp -v "$SCRIPT_DIR/scripts/"*.sh "$HOME/scripts/" 2>/dev/null || true
chmod +x "$HOME/scripts/"*.sh 2>/dev/null || true

# 5. Synchronize All 4 Physical GEMINI.md Files Byte-for-Byte
echo "[ 4/7 ] Synchronizing GEMINI.md rules across all active endpoints..."
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.gemini/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.gemini/config/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.agents/GEMINI.md"

# Cross-agent configuration parity (Claude Code, OpenCode, Codex)
bash "$SCRIPT_DIR/scripts/sync-agents.sh" || true

# 6. Deploy 12 Plugins & Config
echo "[ 5/7 ] Deploying plugins to ~/.gemini/config/plugins/..."
cp -r "$SCRIPT_DIR/plugins/"* "$HOME/.gemini/config/plugins/" 2>/dev/null || true

# 7. Configure Global Git Templates & Install Hooks Across Projects
echo "[ 6/7 ] Configuring global Git hook templates & batch installing guards..."
agy-guard set-global-git-templates
agy-guard install-hooks-all || true
agy-guard scaffold-all-projects || true

# 8. Run Verification Audit
echo "[ 7/7 ] Running empirical system status audit..."
agy-guard status

echo "======================================================"
echo "[ SUCCESS ] AI Agent Governance System Fully Installed!"
echo "All AI coding agents on this device are now governed."
echo "======================================================"
