#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# AI AGENT STANDARDS & GOVERNANCE — ONE-SHOT UNIVERSAL INSTALLER
# ==============================================================================
# This script configures any Linux/macOS machine to be 100% compliant with
# the Sovereign AI Agent Governance Standard (agy-guard, 16 formal rules,
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

# 2. Install agy-guard CLI Tool (v5.2)
echo "[ 1/10 ] Installing agy-guard CLI to ~/.local/bin/agy-guard..."
cp "$SCRIPT_DIR/bin/agy-guard" "$HOME/.local/bin/agy-guard"
chmod +x "$HOME/.local/bin/agy-guard"

# 3. Create Core AI Directory Trees
echo "[ 2/10 ] Initializing AI agent directory structure..."
mkdir -p "$HOME/.gemini/config/rules"
mkdir -p "$HOME/.gemini/config/plugins"
mkdir -p "$HOME/.agents/skills"
mkdir -p "$HOME/.agents/skills-archive"
mkdir -p "$HOME/.agents/skills-manifest"
mkdir -p "$HOME/Projects"
mkdir -p "$HOME/Documents/Obsidian Vault/00-AGY-Memory"
mkdir -p "$HOME/Documents/Obsidian Vault/09-Panduan-Projek"

# 4. Deploy 16 Formal Rule Specifications, Guides & Helper Scripts
echo "[ 3/10 ] Deploying 16 formal binding rule files, project guides & scripts..."
cp -v "$SCRIPT_DIR/rules/"*.md "$HOME/.gemini/config/rules/"
cp -v "$SCRIPT_DIR/docs/"*.md "$HOME/Documents/Obsidian Vault/09-Panduan-Projek/"
mkdir -p "$HOME/scripts"
cp -v "$SCRIPT_DIR/scripts/"*.sh "$HOME/scripts/" 2>/dev/null || true
chmod +x "$HOME/scripts/"*.sh 2>/dev/null || true
if [ -d "$SCRIPT_DIR/scripts/lib" ]; then
  mkdir -p "$HOME/scripts/lib"
  cp -v "$SCRIPT_DIR/scripts/lib/"*.py "$HOME/scripts/lib/" 2>/dev/null || true
fi

# 5. Synchronize All 4 Physical GEMINI.md Files Byte-for-Byte
echo "[ 4/10 ] Synchronizing GEMINI.md rules across all active endpoints..."
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.gemini/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.gemini/config/GEMINI.md"
cp -v "$SCRIPT_DIR/GLOBAL_RULES.md" "$HOME/.agents/GEMINI.md"

# Adapt absolute paths to current user home directory dynamically
echo "  -> Normalizing absolute paths for local host environment ($HOME)..."
find "$HOME/.gemini/config/rules" -type f -name "*.md" -exec sed -i -E "s|/home/[A-Za-z0-9_.-]+|$HOME|g" {} + 2>/dev/null || true
sed -i -E "s|/home/[A-Za-z0-9_.-]+|$HOME|g" "$HOME/GEMINI.md" "$HOME/.gemini/GEMINI.md" "$HOME/.gemini/config/GEMINI.md" "$HOME/.agents/GEMINI.md" 2>/dev/null || true

# Cross-agent configuration parity (Claude Code, OpenCode, Codex)
bash "$SCRIPT_DIR/scripts/sync-agents.sh" || true

# 6. Deploy Plugins & Config
echo "[ 5/10 ] Deploying plugins to ~/.gemini/config/plugins/..."
cp -r "$SCRIPT_DIR/plugins/"* "$HOME/.gemini/config/plugins/" 2>/dev/null || true

# 7. Configure Global Git Templates & Install Hooks Across Projects
echo "[ 6/10 ] Configuring global Git hook templates & batch installing guards..."
agy-guard set-global-git-templates
agy-guard install-hooks-all || true
echo "[ 7/10 ] Scaffolding Obsidian RAG memory namespaces..."
agy-guard scaffold-all-projects || true

# 8. Safely Deploy Sovereign SSH Config Template
echo "[ 8/10 ] Deploying Sovereign SSH config routing to ~/.ssh/config..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh" 2>/dev/null || true
SSH_CONFIG="$HOME/.ssh/config"
SSH_TEMPLATE="$SCRIPT_DIR/templates/dotfiles/ssh_config.template"

if [ -f "$SSH_TEMPLATE" ]; then
    if [ ! -f "$SSH_CONFIG" ]; then
        sed "s|__HOME__|$HOME|g" "$SSH_TEMPLATE" > "$SSH_CONFIG" 2>/dev/null || cp "$SSH_TEMPLATE" "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG" 2>/dev/null || true
        echo "  -> Sovereign SSH config deployed. Hosts available: github.com, codeberg.org, gitlab.com, gitea.com, bitbucket.org, vps-sovereign, vps-dev"
    elif ! grep -q "Host vps-sovereign" "$SSH_CONFIG" 2>/dev/null; then
        BACKUP_SSH="$SSH_CONFIG.bak.$(date +%s)"
        cp "$SSH_CONFIG" "$BACKUP_SSH" 2>/dev/null || true
        echo "  -> Existing ~/.ssh/config backed up to $BACKUP_SSH"
        {
            printf "\n# >>> SOVEREIGN SSH ROUTING >>>\n"
            sed "s|__HOME__|$HOME|g" "$SSH_TEMPLATE" 2>/dev/null || cat "$SSH_TEMPLATE"
            printf "\n# <<< SOVEREIGN SSH ROUTING <<<\n"
        } >> "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG" 2>/dev/null || true
        echo "  -> Safely appended Sovereign SSH routing to ~/.ssh/config."
    else
        echo "  -> Sovereign SSH routing already configured in ~/.ssh/config."
    fi
fi

# 9. Safely Deploy Sovereign Tmux Environment
echo "[ 9/10 ] Deploying Sovereign Tmux configuration & TPM plugins..."
TMUX_CONF="$HOME/.tmux.conf"
TMUX_TEMPLATE="$SCRIPT_DIR/templates/dotfiles/tmux.conf.template"
TMUX_SCRIPTS_DIR="$HOME/.config/tmux/scripts"
TMUX_PLUGINS_DIR="$HOME/.config/tmux/plugins"
SYSINFO_SRC="$SCRIPT_DIR/templates/dotfiles/tmux-sysinfo.sh"
SYSINFO_DEST="$TMUX_SCRIPTS_DIR/sysinfo.sh"

mkdir -p "$TMUX_SCRIPTS_DIR"
mkdir -p "$TMUX_PLUGINS_DIR"

if [ -f "$SYSINFO_SRC" ]; then
    cp "$SYSINFO_SRC" "$SYSINFO_DEST"
    chmod +x "$SYSINFO_DEST"
    echo "  -> Sovereign Tmux sysinfo script deployed to ~/.config/tmux/scripts/sysinfo.sh"
fi

# Ensure TPM (Tmux Plugin Manager) is cloned if git is available
if [ ! -d "$TMUX_PLUGINS_DIR/tpm" ]; then
    echo "  -> Cloning Tmux Plugin Manager (TPM)..."
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR/tpm" 2>/dev/null || true
fi

# Deploy .tmux.conf safely
if [ -f "$TMUX_TEMPLATE" ]; then
    TARGET_SHELL="$(command -v zsh 2>/dev/null || echo "$SHELL")"
    if [ ! -f "$TMUX_CONF" ]; then
        sed "s|__DEFAULT_SHELL__|$TARGET_SHELL|g" "$TMUX_TEMPLATE" > "$TMUX_CONF"
        echo "  -> Sovereign Tmux config deployed to ~/.tmux.conf"
    elif ! grep -q "SOVEREIGN AI AGENT OS — TMUX CONFIGURATION" "$TMUX_CONF" 2>/dev/null; then
        BACKUP_TMUX="$TMUX_CONF.bak.$(date +%s)"
        cp "$TMUX_CONF" "$BACKUP_TMUX"
        echo "  -> Existing ~/.tmux.conf backed up to $BACKUP_TMUX"
        sed "s|__DEFAULT_SHELL__|$TARGET_SHELL|g" "$TMUX_TEMPLATE" > "$TMUX_CONF"
        echo "  -> Sovereign Tmux config updated in ~/.tmux.conf."
    else
        echo "  -> Sovereign Tmux config already active in ~/.tmux.conf."
    fi
fi

# 10. Run Verification Audit
echo "[ 10/10 ] Running empirical system status audit..."
agy-guard status

echo "======================================================"
echo "[ SUCCESS ] AI Agent Governance System Fully Installed!"
echo "All AI coding agents on this device are now governed."
echo "======================================================"
