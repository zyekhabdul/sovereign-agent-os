#!/usr/bin/env bash
set -euo pipefail

# vault.sh — Sovereign Encrypted Credential Locker
# Uses standard OpenSSL AES-256-CBC with PBKDF2 to encrypt/decrypt sensitive credentials without vendor lock-in.

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VAULT_FILE="$REPO_ROOT/vault.enc"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

ACTION="${1:-status}"

echo "======================================================"
echo "         SOVEREIGN CREDENTIAL VAULT LOCKER            "
echo "======================================================"

if [ "$ACTION" == "pack" ]; then
  echo "Packing local MCP configs & environment keys into encrypted vault..."
  mkdir -p "$TMP_DIR/configs"
  
  if [ -f "$HOME/.gemini/config/mcp_config.json" ]; then
    cp "$HOME/.gemini/config/mcp_config.json" "$TMP_DIR/configs/"
  fi
  if [ -f "$HOME/.gemini/config/mcp_config_extended.json" ]; then
    cp "$HOME/.gemini/config/mcp_config_extended.json" "$TMP_DIR/configs/"
  fi
  if [ -f "$HOME/.gitconfig" ]; then
    cp "$HOME/.gitconfig" "$TMP_DIR/configs/"
  fi
  
  tar -czf "$TMP_DIR/vault.tar.gz" -C "$TMP_DIR/configs" .
  
  echo "Enter master password to encrypt vault:"
  openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -in "$TMP_DIR/vault.tar.gz" -out "$VAULT_FILE"
  echo "[ SUCCESS ] Encrypted vault saved at: $VAULT_FILE"
  exit 0
fi

if [ "$ACTION" == "unpack" ]; then
  if [ ! -f "$VAULT_FILE" ]; then
    echo "[ ERROR ] Vault file $VAULT_FILE not found."
    exit 1
  fi
  
  echo "Enter master password to decrypt vault:"
  openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in "$VAULT_FILE" -out "$TMP_DIR/vault.tar.gz"
  
  mkdir -p "$TMP_DIR/extracted"
  tar -xzf "$TMP_DIR/vault.tar.gz" -C "$TMP_DIR/extracted"
  
  mkdir -p "$HOME/.gemini/config"
  if [ -f "$TMP_DIR/extracted/mcp_config.json" ]; then
    cp -v "$TMP_DIR/extracted/mcp_config.json" "$HOME/.gemini/config/"
  fi
  if [ -f "$TMP_DIR/extracted/mcp_config_extended.json" ]; then
    cp -v "$TMP_DIR/extracted/mcp_config_extended.json" "$HOME/.gemini/config/"
  fi
  
  # Trigger multi-agent sync
  if [ -f "$REPO_ROOT/scripts/sync-agents.sh" ]; then
    bash "$REPO_ROOT/scripts/sync-agents.sh"
  fi
  
  echo "[ SUCCESS ] Credentials restored and multi-agent parity updated!"
  exit 0
fi

if [ "$ACTION" == "status" ]; then
  if [ -f "$VAULT_FILE" ]; then
    SIZE=$(stat -c%s "$VAULT_FILE" 2>/dev/null || stat -f%z "$VAULT_FILE")
    DATE=$(stat -c%y "$VAULT_FILE" 2>/dev/null || stat -f%Sm "$VAULT_FILE")
    echo "Encrypted Vault Status : [ ACTIVE ]"
    echo "Vault File Path        : $VAULT_FILE"
    echo "Size                   : $SIZE bytes"
    echo "Last Modified          : $DATE"
  else
    echo "Encrypted Vault Status : [ NOT INITIALIZED ]"
    echo "Run './scripts/vault.sh pack' to create an encrypted backup of your credentials."
  fi
  exit 0
fi

if [ "$ACTION" == "kdbx-status" ]; then
  KDBX_PATH="${2:-$HOME/vault.kdbx}"
  if command -v keepassxc-cli >/dev/null 2>&1; then
    echo "keepassxc-cli           : [ INSTALLED ] ($(which keepassxc-cli))"
  else
    echo "keepassxc-cli           : [ NOT FOUND ] (Install with: sudo apt install keepassxc)"
  fi
  if [ -f "$KDBX_PATH" ]; then
    echo "KeePass Vault Database  : [ FOUND ] ($KDBX_PATH)"
  else
    echo "KeePass Vault Database  : [ NOT FOUND ] ($KDBX_PATH)"
  fi
  exit 0
fi

if [ "$ACTION" == "kdbx-inject" ]; then
  KDBX_PATH="${2:-$HOME/vault.kdbx}"
  if ! command -v keepassxc-cli >/dev/null 2>&1; then
    echo "[ ERROR ] keepassxc-cli is not installed. Install via: sudo apt install keepassxc"
    exit 1
  fi
  if [ ! -f "$KDBX_PATH" ]; then
    echo "[ ERROR ] KeePass database file not found at: $KDBX_PATH"
    echo "Usage: ./scripts/vault.sh kdbx-inject /path/to/vault.kdbx"
    exit 1
  fi

  echo "Injecting secrets from KeePass vault ($KDBX_PATH)..."
  read -s -p "Enter KeePass master password: " KDBX_PASS
  echo ""

  extract_secret() {
    local ENTRY="$1"
    local ATTR="${2:-password}"
    echo "$KDBX_PASS" | keepassxc-cli show -s -a "$ATTR" "$KDBX_PATH" "$ENTRY" 2>/dev/null || echo ""
  }

  GH_TOKEN=$(extract_secret "Tokens/GitHub")
  [ -z "$GH_TOKEN" ] && GH_TOKEN=$(extract_secret "GitHub")

  TAVILY_KEY=$(extract_secret "Tokens/Tavily")
  [ -z "$TAVILY_KEY" ] && TAVILY_KEY=$(extract_secret "Tavily")

  TARGET_CONF="$HOME/.gemini/config/mcp_config.json"
  if [ -f "$TARGET_CONF" ]; then
    if [ -n "$GH_TOKEN" ]; then
      sed -i "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$GH_TOKEN|g" "$TARGET_CONF"
      echo "[ INJECTED ] GitHub token injected into $TARGET_CONF"
    fi
    if [ -n "$TAVILY_KEY" ]; then
      sed -i "s|\${TAVILY_API_KEY}|$TAVILY_KEY|g" "$TARGET_CONF"
      echo "[ INJECTED ] Tavily API key injected into $TARGET_CONF"
    fi
  fi

  TARGET_EXT="$HOME/.gemini/config/mcp_config_extended.json"
  if [ -f "$TARGET_EXT" ]; then
    if [ -n "$GH_TOKEN" ]; then
      sed -i "s|\${GITHUB_PERSONAL_ACCESS_TOKEN}|$GH_TOKEN|g" "$TARGET_EXT"
    fi
    if [ -n "$TAVILY_KEY" ]; then
      sed -i "s|\${TAVILY_API_KEY}|$TAVILY_KEY|g" "$TARGET_EXT"
    fi
  fi

  if [ -f "$REPO_ROOT/scripts/sync-agents.sh" ]; then
    bash "$REPO_ROOT/scripts/sync-agents.sh"
  fi
  echo "[ SUCCESS ] KeePass secret injection and agent parity sync completed."
  exit 0
fi

echo "Usage: ./vault.sh [pack | unpack | status | kdbx-status | kdbx-inject [path.kdbx]]"
exit 1
