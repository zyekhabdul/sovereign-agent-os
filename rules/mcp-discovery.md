---
trigger: always_on
description: Mandatory Global Rule - Dual-File MCP Discovery Protocol (mcp_config.json & mcp_config_extended.json) - Strictly On-Demand
---

# MANDATORY GLOBAL RULE: DUAL-FILE MCP DISCOVERY PROTOCOL

- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).
- **Execution Mode**: STRICTLY ON-DEMAND. DILARANG membaca file konfigurasi MCP secara otomatis di awal sesi untuk menghemat token dan context window.

---

## 1. MANDATORY DUAL-FILE DISCOVERY (ON-DEMAND ONLY)
HANYA ketika ada perintah atau kebutuhan untuk memeriksa ketersediaan endpoint/server MCP (e.g. GitHub, Supabase, Cloudflare, Vercel, Sentry, Slack, Google Drive / gdrive, MEGA, Social Media, dll):

- AI Agent **WAJIB** mengecek KEDUA file:
  1. `/home/fuckadmin/.gemini/config/mcp_config.json`
  2. `/home/fuckadmin/.gemini/config/mcp_config_extended.json`

- **STRICT PROHIBITION**:
  - DILARANG membaca file MCP di awal sesi jika tidak diminta/dibutuhkan.
  - DILARANG berhenti setelah hanya memeriksa `mcp_config.json`.
  - DILARANG berasumsi konfigurasi MCP hanya 1 file.

---

## 2. STRICT ANTI-EXFILTRATION SECURE PARSING
- All future AI agents MUST rely on MCP endpoints for external APIs.
- NEVER dump raw API tokens/keys directly into the chat context window.
- Always parse JSON structurally using tools like `jq` without printing token/secret values.
