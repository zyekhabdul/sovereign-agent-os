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

echo "Usage: ./vault.sh [pack | unpack | status]"
exit 1
