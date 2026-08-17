#!/usr/bin/env bash
set -euo pipefail

# verify-env.sh — Comprehensive Diagnostic & Health Check for Host Environment
# Usage: ./verify-env.sh

echo "======================================================"
echo "    HOST & AI AGENT ENVIRONMENT DIAGNOSTIC CHECKER    "
echo "======================================================"

PASSED=0
WARNINGS=0
ERRORS=0

report_ok() {
  echo "  [ PASS ] $1"
  PASSED=$((PASSED + 1))
}

report_warn() {
  echo "  [ WARN ] $1"
  WARNINGS=$((WARNINGS + 1))
}

report_err() {
  echo "  [ FAIL ] $1"
  ERRORS=$((ERRORS + 1))
}

# 1. Check Essential CLI Binaries
echo "\n--- 1. Essential CLI Tools ---"
for bin in git rg jq python3 node npm ssh; do
  if command -v "$bin" >/dev/null 2>&1; then
    report_ok "Command '$bin' is installed ($(command -v "$bin"))"
  else
    report_err "Command '$bin' is NOT installed"
  fi
done

# 2. Check Global Rules & Governance
echo "\n--- 2. AI Governance & Binding Rules ---"
if [ -f "$HOME/.gemini/GEMINI.md" ]; then
  report_ok "~/.gemini/GEMINI.md exists"
else
  report_warn "~/.gemini/GEMINI.md is missing"
fi

for r in git-push-restriction.md obsidian-rag.md workflow-ai-agent.md ai-proposal-protocol.md mcp-discovery.md; do
  if [ -f "$HOME/.gemini/config/rules/$r" ]; then
    report_ok "Rule '$r' is active"
  else
    report_warn "Rule '$r' is missing in ~/.gemini/config/rules/"
  fi
done

# 3. Check Obsidian RAG Memory Vault
echo "\n--- 3. Obsidian RAG Memory Vault ---"
OBSIDIAN_DIR="${OBSIDIAN_VAULT_PATH:-$HOME/Documents/Obsidian Vault}"
if [ -d "$OBSIDIAN_DIR/00-AGY-Memory" ]; then
  report_ok "Obsidian Vault RAG directory active at: $OBSIDIAN_DIR/00-AGY-Memory"
else
  report_warn "Obsidian RAG directory not found at $OBSIDIAN_DIR/00-AGY-Memory"
fi

# 4. Check Dual-File MCP Configurations
echo "\n--- 4. Dual-File MCP Configuration ---"
for mcp_file in "$HOME/.gemini/config/mcp_config.json" "$HOME/.gemini/config/mcp_config_extended.json"; do
  if [ -f "$mcp_file" ]; then
    if jq empty "$mcp_file" 2>/dev/null; then
      report_ok "MCP config valid JSON: $(basename "$mcp_file")"
    else
      report_err "MCP config is corrupted JSON: $(basename "$mcp_file")"
    fi
  else
    report_warn "MCP config missing: $(basename "$mcp_file")"
  fi
done

# 5. Check SSH Connectivity (Fast probe)
echo "\n--- 5. SSH Multi-Forge Connectivity (Dry probe) ---"
if [ -f "$HOME/.ssh/config" ]; then
  report_ok "SSH config exists at ~/.ssh/config"
else
  report_warn "SSH config is missing at ~/.ssh/config"
fi

echo "======================================================"
echo "DIAGNOSTIC SUMMARY: $PASSED Passed, $WARNINGS Warnings, $ERRORS Errors"
if [ $ERRORS -eq 0 ]; then
  echo "[ STATUS: HEALTHY ] Environment is ready for sovereign development."
else
  echo "[ STATUS: ACTION REQUIRED ] Resolve errors above before proceeding."
fi
echo "======================================================"
