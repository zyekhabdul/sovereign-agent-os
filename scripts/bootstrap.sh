#!/usr/bin/env bash
set -euo pipefail

# bootstrap.sh — Universal Machine & Environment Bootstrap for Developer & AI Agents
# Usage: ./bootstrap.sh [--no-pkg]

NO_PKG=false
if [[ "${1:-}" == "--no-pkg" ]]; then
  NO_PKG=true
fi

echo "======================================================"
echo "    AI & DEVELOPER UNIVERSAL BOOTSTRAP INITIALIZER    "
echo "======================================================"

# 1. Detect Package Manager and Install Essential CLI Tools
if [ "$NO_PKG" = false ]; then
  echo "[ 1/5 ] Detecting OS and verifying core packages..."
  if command -v pacman >/dev/null 2>&1; then
    echo "OS: Arch Linux detected (pacman)"
    sudo pacman -Sy --needed --noconfirm git ripgrep jq python nodejs npm openssh curl || true
  elif command -v apt-get >/dev/null 2>&1; then
    echo "OS: Debian/Ubuntu detected (apt-get)"
    sudo apt-get update -y
    sudo apt-get install -y git ripgrep jq python3 python3-pip nodejs npm openssh-client curl || true
  else
    echo "Package manager not auto-configured, skipping package installation."
  fi
else
  echo "[ 1/5 ] Skipping package manager installation (--no-pkg)."
fi

# 2. Setup Base Directory Structures
echo "[ 2/5 ] Creating standardized AI & Workspace directory tree..."
mkdir -p "$HOME/.gemini/config/rules"
mkdir -p "$HOME/.agents/skills"
mkdir -p "$HOME/Projects"
mkdir -p "$HOME/Documents/Obsidian Vault/00-AGY-Memory"
mkdir -p "$HOME/Documents/Obsidian Vault/01-Dokumen"
mkdir -p "$HOME/Documents/Obsidian Vault/09-Panduan-Projek"

# 3. Deploy Global Rules
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

echo "[ 3/5 ] Deploying Global Binding Rules to ~/.gemini/..."
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$HOME/.gemini/GEMINI.md"
cp -v "$REPO_ROOT/rules/"*.md "$HOME/.gemini/config/rules/"

if [ ! -f "$HOME/.agents/GEMINI.md" ]; then
  mkdir -p "$HOME/.agents"
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$HOME/.agents/GEMINI.md"
fi

# 4. Deploy Sanitized MCP Configurations (if not already present)
echo "[ 4/5 ] Checking MCP configurations..."
if [ ! -f "$HOME/.gemini/config/mcp_config.json" ]; then
  echo "Initializing ~/.gemini/config/mcp_config.json from template..."
  cp "$REPO_ROOT/templates/mcp/mcp_config.template.json" "$HOME/.gemini/config/mcp_config.json"
fi

if [ ! -f "$HOME/.gemini/config/mcp_config_extended.json" ]; then
  echo "Initializing ~/.gemini/config/mcp_config_extended.json from template..."
  cp "$REPO_ROOT/templates/mcp/mcp_config_extended.template.json" "$HOME/.gemini/config/mcp_config_extended.json"
fi

# 5. Install MCP Packages
echo "[ 5/5 ] Installing global MCP packages..."
if [ -f "$SCRIPT_DIR/install-mcps.sh" ]; then
  bash "$SCRIPT_DIR/install-mcps.sh"
fi

echo "======================================================"
echo "[ SUCCESS ] Universal Bootstrap Completed!"
echo "AI coding agents are now fully governed and equipped."
echo "======================================================"
