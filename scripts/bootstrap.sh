#!/usr/bin/env bash
set -euo pipefail

# bootstrap.sh — Universal Machine & Environment Bootstrap for Developer & AI Agents
# Usage: ./bootstrap.sh [--no-pkg]

NO_PKG=false
if [[ "${1:-}" == "--no-pkg" ]]; then
  NO_PKG=true
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

echo "======================================================"
echo "    AI & DEVELOPER UNIVERSAL BOOTSTRAP INITIALIZER    "
echo "======================================================"

# 1. Detect Package Manager and Install Essential CLI Tools
if [ "$NO_PKG" = false ]; then
  echo "[ 1/3 ] Detecting OS and verifying core packages..."
  if command -v pacman >/dev/null 2>&1; then
    echo "OS: Arch Linux detected (pacman)"
    sudo pacman -Sy --needed --noconfirm git ripgrep jq python nodejs npm openssh curl || true
  elif command -v apt-get >/dev/null 2>&1; then
    echo "OS: Debian/Ubuntu detected (apt-get)"
    sudo apt-get update -y
    sudo apt-get install -y git ripgrep fd-find jq python3 python3-pip python3-venv build-essential nodejs npm openssh-client curl tmux fzf tree || true
  else
    echo "Package manager not auto-configured, skipping package installation."
  fi
  
  # Ensure local bin & fd alias for Debian/Ubuntu (fdfind)
  mkdir -p "$HOME/.local/bin"
  if command -v fdfind >/dev/null 2>&1 && [ ! -e "$HOME/.local/bin/fd" ]; then
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  fi
else
  echo "[ 1/3 ] Skipping package manager installation (--no-pkg)."
fi

# Ensure npm global directory and PATH
mkdir -p "$HOME/.npm-global" "$HOME/.local/bin"
npm config set prefix "$HOME/.npm-global" 2>/dev/null || true
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# 2. Run Master AI Governance Installer
echo "[ 2/3 ] Executing Master AI Governance Installer (install.sh)..."
bash "$REPO_ROOT/install.sh"

# 3. Deploy MCP Configuration & Run Diagnostic
echo "[ 3/3 ] Checking MCP server configurations..."
mkdir -p "$HOME/.gemini/config"
if [ ! -f "$HOME/.gemini/config/mcp_config.json" ]; then
  echo "Initializing ~/.gemini/config/mcp_config.json from template..."
  sed "s|__HOME__|$HOME|g; s|/home/fuckadmin|$HOME|g" "$REPO_ROOT/templates/mcp/mcp_config.template.json" > "$HOME/.gemini/config/mcp_config.json" 2>/dev/null || true
fi

if [ ! -f "$HOME/.gemini/config/mcp_config_extended.json" ]; then
  echo "Initializing ~/.gemini/config/mcp_config_extended.json from template..."
  sed "s|__HOME__|$HOME|g; s|/home/fuckadmin|$HOME|g" "$REPO_ROOT/templates/mcp/mcp_config_extended.template.json" > "$HOME/.gemini/config/mcp_config_extended.json" 2>/dev/null || true
fi

echo "======================================================"
echo "[ SUCCESS ] Universal Bootstrap Completed!"
echo "AI coding agents are now fully governed and equipped."
echo "======================================================"
