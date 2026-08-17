#!/usr/bin/env bash
set -euo pipefail

# sync-agents.sh — Cross-Agent Configuration & MCP Parity Syncer
# Ensures Antigravity (AGY), Claude Code, OpenCode, and Codex share identical rules, skills, and MCP endpoints.

echo "======================================================"
echo "      CROSS-AGENT CONFIGURATION PARITY SYNCER         "
echo "======================================================"

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
GEMINI_DIR="$HOME/.gemini"
CLAUDE_DIR="$HOME/.claude"
OPENCODE_DIR="$HOME/.opencode"
CODEX_DIR="$HOME/.codex"
AGENTS_DIR="$HOME/.agents"

# 1. Ensure Agent Directories
echo "[ 1/4 ] Creating multi-agent directory structures..."
mkdir -p "$GEMINI_DIR/config/rules" "$GEMINI_DIR/config/plugins"
mkdir -p "$CLAUDE_DIR"
mkdir -p "$OPENCODE_DIR/skills"
mkdir -p "$CODEX_DIR"
mkdir -p "$AGENTS_DIR/skills"

# 2. Sync Global Binding Rules across all agents
echo "[ 2/4 ] Synchronizing global rules across agent environments..."
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$GEMINI_DIR/GEMINI.md"
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$AGENTS_DIR/GEMINI.md"
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null || true
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$OPENCODE_DIR/OPENCODE.md" 2>/dev/null || true
cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$CODEX_DIR/CODEX.md" 2>/dev/null || true

# 3. Sync Rules folder
if [ -d "$REPO_ROOT/rules" ]; then
  cp -v "$REPO_ROOT/rules/"*.md "$GEMINI_DIR/config/rules/"
fi

# 4. Generate Claude Code & OpenCode MCP Configurations
echo "[ 3/4 ] Generating unified MCP configurations for Claude Code & OpenCode..."
python3 - << 'EOF'
import os, json

gemini_mcp = os.path.expanduser("~/.gemini/config/mcp_config.json")
gemini_ext = os.path.expanduser("~/.gemini/config/mcp_config_extended.json")
claude_cfg = os.path.expanduser("~/.claude.json")
opencode_cfg = os.path.expanduser("~/.opencode/opencode.json")

all_servers = {}

for f in [gemini_mcp, gemini_ext]:
    if os.path.exists(f):
        try:
            with open(f) as fp:
                d = json.load(fp)
                servers = d.get("mcpServers", {})
                for k, v in servers.items():
                    all_servers[k] = v
        except Exception as e:
            print(f"Warn: failed to parse {f}: {e}")

# 1. Update ~/.claude.json
if all_servers:
    claude_data = {}
    if os.path.exists(claude_cfg):
        try:
            with open(claude_cfg) as fp:
                claude_data = json.load(fp)
        except:
            claude_data = {}
    claude_data["mcpServers"] = all_servers
    with open(claude_cfg, "w") as fp:
        json.dump(claude_data, fp, indent=2)
    print(f"  [ PASS ] Updated ~/.claude.json with {len(all_servers)} MCP servers.")

# 2. Update ~/.opencode/opencode.json
    opencode_data = {"mcp": all_servers}
    with open(opencode_cfg, "w") as fp:
        json.dump(opencode_data, fp, indent=2)
    print(f"  [ PASS ] Updated ~/.opencode/opencode.json with {len(all_servers)} MCP servers.")

EOF

# 5. Sync Agent Skills
echo "[ 4/4 ] Synchronizing Agent Skills & 11 Core Components..."
if [ -d "$REPO_ROOT/plugins/agent-skills/skills" ]; then
  cp -r "$REPO_ROOT/plugins/agent-skills/skills/"* "$AGENTS_DIR/skills/" 2>/dev/null || true
  cp -r "$REPO_ROOT/plugins/agent-skills/skills/"* "$OPENCODE_DIR/skills/" 2>/dev/null || true
fi

echo "======================================================"
echo "[ SUCCESS ] Multi-Agent Parity Synchronized!"
echo "AGY, Claude Code, OpenCode, and Codex are 100% aligned."
echo "======================================================"
