#!/usr/bin/env bash
set -euo pipefail

# install-mcps.sh — Installs essential global MCP servers for AI coding agents
# Usage: ./install-mcps.sh

echo "=== Installing Essential Global MCP Servers via npm ==="

MCP_PACKAGES=(
  "@modelcontextprotocol/server-filesystem"
  "@modelcontextprotocol/server-github"
  "@modelcontextprotocol/server-gitlab"
  "@modelcontextprotocol/server-postgres"
  "@modelcontextprotocol/server-memory"
  "@modelcontextprotocol/server-sequential-thinking"
  "@amonstack/gitea-mcp"
)

for pkg in "${MCP_PACKAGES[@]}"; do
  echo "Installing $pkg..."
  npm install -g "$pkg" || echo "[ WARN ] Failed to install $pkg (check npm permissions)"
done

echo "[ SUCCESS ] All core MCP packages processed."
