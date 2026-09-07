---
trigger: always_on
description: Mandatory AGY Runtime Error Recovery & Empirical Log Triage Protocol
---
# MANDATORY GLOBAL RULE: AGY RUNTIME ERROR RECOVERY & TROUBLESHOOTING

- **Principle**: "Empirical Log Triage Before Mutation"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. MANDATORY LOG INSPECTION FIRST (ZERO GUESSWORK)
When `agy` terminates with error or user reports runtime failures:
1. AI Agent MUST immediately inspect the active log in `/home/fuckadmin/.gemini/antigravity-cli/log/` (e.g. `ls -lat /home/fuckadmin/.gemini/antigravity-cli/log | head -n 5`).
2. Search for exact failure traces: `grep -E "agent executor error|FAILED_PRECONDITION|RESOURCE_EXHAUSTED|UNAVAILABLE" <latest_log>`.
3. NEVER guess, speculate, or make unsolicited model/proxy modifications without empirical log proof.

---

## 2. STANDARD TRIAGE & RECOVERY PROTOCOL

### Case A: `FAILED_PRECONDITION (code 400): User location is not supported`
- **Root Cause**: Temporary regional geo-fence on Google CloudCode backend hooks (`context summarization` / intent generation) or specific model clusters.
- **Recovery Standard**:
  1. DO NOT immediately overwrite user's preferred model in `settings.json` (e.g. `Gemini 3.7 Flash (High)`).
  2. Clean stale lock files: `rm -f ~/.gemini/antigravity-cli/presence/*.lock`.
  3. Verify network/DNS latency: `curl -I -s https://daily-cloudcode-pa.googleapis.com`.
  4. Wait 1–2 minutes for Google edge load-balancer to normalize before proposing alternative routing.

### Case B: Stale Presence Lock Accumulation
- **Root Cause**: Ungraceful process termination leaves orphaned `.lock` files in `presence/` causing session start contention.
- **Recovery Standard**:
  ```bash
  rm -f ~/.gemini/antigravity-cli/presence/*.lock
  chmod -R u+rwX ~/.gemini
  ```

### Case C: `RESOURCE_EXHAUSTED (code 429)`
- **Root Cause**: Minute rate limit or daily token quota hit on active model.
- **Recovery Standard**: Report exact quota limit to user and wait for cooldown window.

### Case D: `UNAVAILABLE (code 503)`
- **Root Cause**: Temporary upstream capacity exhaustion on Google model servers.
- **Recovery Standard**: Retry request after brief pause.

---

## 3. PROHIBITION ON UNREQUESTED ARCHITECTURAL MUTATION
- Never delete user model configurations or permanently inject proxies without explicit user approval.
