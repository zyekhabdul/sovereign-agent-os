---
trigger: always_on
description: environment-topology.md
---

# MANDATORY GLOBAL RULE: SOVEREIGN ENVIRONMENT TOPOLOGY & DUAL-MODE WORKSPACE

- **Principle**: "Laptop Builds, VPS Serves" (Decoupled) / "Sovereign Host Discipline" (Direct VPS)
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. DUAL-MODE OPERATIONAL MODES

### MODE A: Decoupled Topology (Laptop -> Remote -> VPS)
*Active when the developer operates from a separate personal laptop/workstation.*

1. **Laptop Workspace**:
   - Primary coding, PRD design, local build/test verification, and local git commits.
   - Uses `.env.local` or mock credentials only. Production secrets MUST NEVER exist on the laptop.
2. **VPS Ingress Host**:
   - Purely passive deployment runtime. Direct manual code mutation on VPS is STRICTLY PROHIBITED in this mode.
   - Deploys code automatically via Dokploy webhooks, GitHub Actions, or SSH pull (`docker compose up -d --build`).

---

### MODE B: Direct Sovereign Host Mode (VPS as Primary Autonomous Workspace)
*Active when the developer/admin runs AI agents directly inside the VPS environment (`fuckadmin@...`).*

When running directly on the VPS host, AI agents ARE PERMITTED to perform maintenance, configuration, and feature development under these strict operational guardrails:

1. **Port Collision Guard**:
   - AI agents MUST NEVER bind dev servers to active production container ports (e.g. Port `3000` for `zyekh-ai-core`, Ports `80`/`443` for Traefik/Cloudflare Tunnel).
   - Use ephemeral or isolated development ports (e.g., `3001`, `8085`, `4321`) or dry-run testing.

2. **Resource & OOM Defense**:
   - Limit Node.js / tool memory allocations (`--max-old-space-size=256` or `512`) to prevent Linux Out-Of-Memory (OOM) Killer from terminating critical production daemons.
   - Avoid excessive concurrent subagents on the VPS host; prioritize sequential, token-efficient batch execution.

3. **Empirical Quality Gate & Local Checkpoint**:
   - Code modifications MUST pass silent terminal verification (`agy-guard verify`, `npm test`, `npm run build`) before committing.
   - Changes MUST be recorded via `git commit` and Obsidian RAG checkpoint (`agy-guard checkpoint`).

4. **Deterministic Service Reloading**:
   - Live container updates MUST be executed via standard container controls (`docker compose restart <service>` or Dokploy redeploy) only after clean verification and commit.

5. **Physical Anti-Push Compliance**:
   - Pushes to remote repositories from the VPS must pass the pre-push guardrail using `agy-guard push` or explicit `ALLOW_GIT_PUSH=1`.

---

## 2. PRODUCTION SECRETS & CREDENTIAL BOUNDARIES

1. Production `.env` files and `~/Projects/.env.dokploy` are locked to mode `0600` on the VPS.
2. AI agents MUST NEVER dump, print, or exfiltrate raw production secrets into conversation transcripts, RAG notes, or Git repositories.
3. Secret management MUST utilize the encrypted vault (`scripts/vault.sh`) or sanitized environment inspection (`agy-guard inspect-env`).
