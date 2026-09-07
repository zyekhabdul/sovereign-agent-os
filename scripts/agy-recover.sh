#!/usr/bin/env bash
# ==============================================================================
# AGY RUNTIME & AI ENVIRONMENT AUTOMATED RECOVERY SCRIPT (VPS SERVV)
# Single Source of Truth: /home/fuckadmin/.gemini/config/rules/agy-runtime-troubleshooting.md
# ==============================================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "[1/5] Memperbaiki Ownership & Izin File .gemini & .agents..."
sudo chown -R fuckadmin:fuckadmin /home/fuckadmin/.gemini /home/fuckadmin/.agents 2>/dev/null || true
chmod -R u+rwX /home/fuckadmin/.gemini /home/fuckadmin/.agents 2>/dev/null || true
echo -e "[ OK ] Ownership dan permission berhasil dinormalisasi."

echo -e "[2/5] Membersihkan Orphaned Presence Locks..."
REMOVED_LOCKS=$(ls /home/fuckadmin/.gemini/antigravity-cli/presence/*.lock 2>/dev/null | wc -l)
sudo rm -f /home/fuckadmin/.gemini/antigravity-cli/presence/*.lock
echo -e "[ OK ] Berhasil membersihkan $REMOVED_LOCKS presence lock file."

echo -e "[3/5] Me-refresh Koneksi Network & Cloudflare WARP..."
if command -v warp-cli >/dev/null 2>&1; then
  warp-cli disconnect >/dev/null 2>&1 || true
  sleep 1
  warp-cli connect >/dev/null 2>&1 || true
  echo -e "[ OK ] Cloudflare WARP berhasil di-refresh."
fi

echo -e "[4/5] Menguji Latency & Akses Endpoint Google CloudCode & GitHub..."
GOOGLE_HTTP=$(curl -s -m 5 -o /dev/null -w "%{http_code}" https://daily-cloudcode-pa.googleapis.com 2>/dev/null || echo "TIMEOUT")
GITHUB_HTTP=$(curl -s -m 5 -o /dev/null -w "%{http_code}" https://api.github.com 2>/dev/null || echo "TIMEOUT")
echo -e "  - Google CloudCode API: HTTP $GOOGLE_HTTP"
echo -e "  - GitHub API          : HTTP $GITHUB_HTTP"

echo -e "[5/5] Memeriksa Riwayat Error Log Terakhir..."
LATEST_LOG=$(ls -t /home/fuckadmin/.gemini/antigravity-cli/log/*.log 2>/dev/null | head -n 1)
if [ -n "$LATEST_LOG" ]; then
  echo -e "  Log Aktif: $LATEST_LOG"
  RECENT_ERRORS=$(grep -E 'FAILED_PRECONDITION|RESOURCE_EXHAUSTED|UNAVAILABLE|permission denied' "$LATEST_LOG" | tail -n 3 || true)
  if [ -n "$RECENT_ERRORS" ]; then
    echo -e "  Riwayat error tercatat:"
    echo "$RECENT_ERRORS"
  else
    echo -e "  Tidak ada error kritis di log terbaru."
  fi
fi

echo -e "\n======================================================"
echo -e "[ OK ] RECOVERY SELESAI. Anda dapat langsung menjalankan 'agy'."
echo -e "======================================================"
