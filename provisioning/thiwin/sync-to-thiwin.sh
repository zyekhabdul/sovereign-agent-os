#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# DISPATCH SOVEREIGN AGENT BUNDLE TO THIWIN (CORE-002)
# ==============================================================================

SOURCE_DIR="/home/fuckadmin/setup-sovereign-thiwin"
TARGET_NODE="thinkpad-win"
TARGET_TAILSCALE_IP="100.78.84.3"

echo "======================================================"
echo "   SOVEREIGN SYNC DISPATCH -> THIWIN (CORE-002)       "
echo "======================================================"

# 1. Check Tailscale ping
ONLINE=0
if ping -c 1 -W 2 "$TARGET_TAILSCALE_IP" >/dev/null 2>&1; then
    echo "[ PASS ] $TARGET_TAILSCALE_IP is reachable via Tailscale."
    ONLINE=1
elif /usr/local/bin/mesh-ssh "$TARGET_NODE" "echo 1" >/dev/null 2>&1; then
    echo "[ PASS ] $TARGET_NODE is reachable via MeshCentral."
    ONLINE=2
fi

if [ "$ONLINE" -eq 0 ]; then
    echo "[ NOTE ] thiwin ($TARGET_TAILSCALE_IP / $TARGET_NODE) is currently OFFLINE / ASLEEP."
    echo "         The distribution package is fully staged at: $SOURCE_DIR"
    echo "         Run this script again once the machine is powered on / awake."
    exit 0
fi

echo "[ INFO ] Dispatching setup bundle to thiwin..."
if [ "$ONLINE" -eq 1 ]; then
    scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no -r "$SOURCE_DIR"/* "sysdevadmin@$TARGET_TAILSCALE_IP:C:/setup-sovereign-thiwin/"
elif [ "$ONLINE" -eq 2 ]; then
    scp -o ProxyCommand="/usr/local/bin/mesh-ssh --stdio %h" -o StrictHostKeyChecking=no -r "$SOURCE_DIR"/* "sysdevadmin@$TARGET_NODE:C:/setup-sovereign-thiwin/"
fi

echo "[ PASS ] Transfer complete. Destination: C:/setup-sovereign-thiwin"
echo "         To execute on thiwin, run in PowerShell:"
echo "         cd C:/setup-sovereign-thiwin ; powershell -ExecutionPolicy Bypass -File .\setup-sovereign-thiwin.ps1"
echo "======================================================"
