---
trigger: always_on
description: Sovereign Cloud Storage Routing & GDrive aqz220309@gmail.com Sovereign Hub Invariant
---

# MANDATORY GLOBAL RULE: SOVEREIGN CLOUD STORAGE ROUTING & PRIMARY HUB INVARIANT

- **Principle**: "Default to GDrive aqz220309@gmail.com, Zero Unsolicited Multi-Cloud Drift"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. SOVEREIGN PRIMARY CLOUD HUB (`gdrive:aqz220309@gmail.com`)
- **Default Cloud Destination**: All automated, autonomous, or agent-initiated cloud transfers, file backups, archival operations, and storage syncs MUST route exclusively to and through the Google Drive account `aqz220309@gmail.com`:
  - Canonical Rclone Remote Target: `Gdrive-aqz220309_at_gmail.com:` (or default alias `gdrive:` / `gdrive-aqz:`).
- **Prohibition on Unsolicited Cloud Provider Drift**:
  - AI agents are STRICTLY FORBIDDEN from uploading, syncing, or backing up data to any other cloud remotes (MEGA, OneDrive, Dropbox, ProtonDrive, Filen, Box, B2, Koofr, etc.) by default or on autonomous agent initiative.

---

## 2. EXPLICIT USER OVERRIDE EXCEPTION
- The ONLY exception to Rule 1 is an **EXPLICIT USER COMMAND** naming a specific alternative target remote or provider.
  - Examples:
    - User explicitly says: `backup rclone.conf ke mega` -> ALLOWED (User explicitly specified `mega`).
    - User explicitly says: `sinkronkan folder X ke b2` -> ALLOWED (User explicitly specified `b2`).
    - User says generic command: `backup project ini ke cloud` or `sync data ke cloud` -> MUST USE `Gdrive-aqz220309_at_gmail.com:` (`gdrive:`).
- In the absence of an explicit alternative destination named in the user prompt, `Gdrive-aqz220309_at_gmail.com:` is the sole authorized target.

---

## 3. RCLONE CANONICAL ALIAS ENFORCEMENT
- When constructing or invoking `rclone` commands where the destination is generic cloud storage (e.g. `gdrive:`, `cloud:`), agents MUST ensure the target resolves to `Gdrive-aqz220309_at_gmail.com:`.
- Before executing cloud uploads, agents must verify remote connectivity and directory hierarchy under `Gdrive-aqz220309_at_gmail.com:`.
