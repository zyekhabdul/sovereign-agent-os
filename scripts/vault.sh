#!/usr/bin/env bash
set -euo pipefail

# vault.sh — Sovereign Encrypted Credential Locker
# Uses standard OpenSSL AES-256-CBC with PBKDF2 to encrypt/decrypt sensitive credentials without vendor lock-in.

SCRIPT_DIR_VAULT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=""
for _cand in "$SCRIPT_DIR_VAULT/.." "$HOME/Projects/sovereign-agent-os"; do
  if [ -f "$_cand/GLOBAL_RULES.md" ]; then REPO_ROOT=$(cd "$_cand" && pwd); break; fi
done
[ -z "$REPO_ROOT" ] && REPO_ROOT=$(cd "$SCRIPT_DIR_VAULT/.." && pwd)
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
  if [ -f "$TMP_DIR/extracted/.gitconfig" ]; then
    cp -v "$TMP_DIR/extracted/.gitconfig" "$HOME/.gitconfig"
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

resolve_kdbx_path() {
  local explicit="${1:-}"
  if [ -n "$explicit" ]; then
    echo "$explicit"
    return
  fi
  if [ -n "${SOVEREIGN_KDBX_PATH:-}" ]; then
    echo "$SOVEREIGN_KDBX_PATH"
    return
  fi
  if [ -f "$HOME/.keepass/sovereign-credentials.kdbx" ]; then
    echo "$HOME/.keepass/sovereign-credentials.kdbx"
    return
  fi
  if [ -f "$HOME/.keepass/passwords.kdbx" ]; then
    echo "$HOME/.keepass/passwords.kdbx"
    return
  fi
  if [ -f "$HOME/shared-storage/passwords.kdbx" ]; then
    echo "$HOME/shared-storage/passwords.kdbx"
    return
  fi
  echo "$HOME/.keepass/sovereign-credentials.kdbx"
}

if [ "$ACTION" == "kdbx-status" ]; then
  KDBX_PATH="$(resolve_kdbx_path "${2:-}")"
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
  KDBX_PATH="$(resolve_kdbx_path "${2:-}")"
  if ! command -v keepassxc-cli >/dev/null 2>&1; then
    echo "[ ERROR ] keepassxc-cli is not installed. Install via: sudo apt install keepassxc"
    exit 1
  fi
  if [ ! -f "$KDBX_PATH" ]; then
    echo "[ ERROR ] KeePass database file not found at: $KDBX_PATH"
    echo "Usage: ./scripts/vault.sh kdbx-inject [/path/to/sovereign-credentials.kdbx]"
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
  [ -z "$GH_TOKEN" ] && GH_TOKEN=$(extract_secret "MCP/Services/MCP: github")
  [ -z "$GH_TOKEN" ] && GH_TOKEN=$(extract_secret "MCP/Git Tokens/GitHub Master PAT (zyekhabdul)")

  TAVILY_KEY=$(extract_secret "Tokens/Tavily")
  [ -z "$TAVILY_KEY" ] && TAVILY_KEY=$(extract_secret "Tavily")
  [ -z "$TAVILY_KEY" ] && TAVILY_KEY=$(extract_secret "MCP/Services/MCP: search-tavily")

  inject_placeholders_json() {
    local target_file="$1"
    local gh_token="$2"
    local tavily_key="$3"
    [ -f "$target_file" ] || return 0
    local lib_cand=""
    for _lib in "$REPO_ROOT/scripts/lib/vault_inject.py" "$HOME/Projects/sovereign-agent-os/scripts/lib/vault_inject.py"; do
      if [ -f "$_lib" ]; then lib_cand="$_lib"; break; fi
    done
    if [ -z "$lib_cand" ]; then
      echo "[ ERROR ] vault_inject.py not found; injection skipped for $target_file" >&2
      return 1
    fi
    GH_TOKEN_ENV="$gh_token" TAVILY_KEY_ENV="$tavily_key" TARGET_FILE_ENV="$target_file" python3 "$lib_cand" || return 1
    echo "[ INJECTED ] Placeholders replaced (JSON-safe) in $target_file"
  }

  if [ -z "$GH_TOKEN" ] && [ -z "$TAVILY_KEY" ]; then
    echo "[ WARN ] No secrets extracted (wrong master password or missing entries). Configs left untouched." >&2
  fi

  TARGET_CONF="$HOME/.gemini/config/mcp_config.json"
  inject_placeholders_json "$TARGET_CONF" "$GH_TOKEN" "$TAVILY_KEY"

  TARGET_EXT="$HOME/.gemini/config/mcp_config_extended.json"
  inject_placeholders_json "$TARGET_EXT" "$GH_TOKEN" "$TAVILY_KEY"

  unset KDBX_PASS GH_TOKEN TAVILY_KEY
  if [ -f "$REPO_ROOT/scripts/sync-agents.sh" ]; then
    bash "$REPO_ROOT/scripts/sync-agents.sh"
  fi
  echo "[ SUCCESS ] KeePass secret injection and agent parity sync completed."
  exit 0
fi

echo "Usage: ./vault.sh [pack | unpack | status | kdbx-status | kdbx-inject [path.kdbx]]"
exit 1
