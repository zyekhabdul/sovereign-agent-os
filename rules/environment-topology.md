---
trigger: always_on
description: Sovereign Environment Topology - Local Laptop Development vs VPS Production Runtime Separation
---

# MANDATORY GLOBAL RULE: SOVEREIGN ENVIRONMENT TOPOLOGY & WORKSPACE DECOUPLING

- **Principle**: "Laptop Builds, VPS Serves" (Total Decoupling of Development Workspace and Production Runtime)
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. MACHINE ROLE DEFINITION

### A. Laptop Environment (Active Development Workspace)
- **Primary Function**: Coding, feature design, PRD formulation, local build/test verification, and AI-assisted mutation.
- **Workflow Scope**:
  - Run local dev servers (`npm run dev`, `python main.py`, etc.).
  - Execute automated tests, linters, and type checks locally before committing.
  - Maintain local Git branches and make structured commits (`git commit`).
  - Request user confirmation before pushing code to remotes (`git push`).

### B. VPS Environment (Production Runtime & Ingress Host)
- **Primary Function**: Passive hosting of live production containers, databases, proxy routing, and 24/7 background daemons.
- **Workflow Scope**:
  - Run Docker Swarm (Dokploy, Traefik, PostgreSQL).
  - Run production Docker Compose stacks (`zyekh-web`, `zyekh-ai-core`, `chat-zyekh`, `bot-telegram`, `bot-whatsapp`).
  - Run background systemd daemons (`yt-warmup.service`, `cloudflared.service`).
  - Receive automated or pull-based deployment updates from Git remotes.

---

## 2. STRICT OPERATIONAL DIRECTIVES

### 1. Zero Direct Code Mutation on VPS
- AI agents and developers MUST NEVER edit application source code directly on the VPS.
- All code changes MUST originate on the Laptop workspace, pass local empirical verification, be committed, and be pushed to Git remotes.

### 2. Strict Secret & Environment Variable Isolation
- Production secrets, master tokens, and server-only configurations MUST remain strictly locked on the VPS (`~/Projects/.env.dokploy` and production `.env` files).
- The Laptop workspace MUST ONLY use `.env.local` or `.env.development` with mock or development-scoped credentials.
- AI agents on the laptop MUST NEVER request, write, or exfiltrate production secrets into local repositories.

### 3. Deployment Protocol (Laptop -> Remote -> VPS)
- **Step 1 (Laptop)**: Modify code -> Run local verification (`npm test` / `npm run build`) -> `git commit`.
- **Step 2 (Laptop -> Remote)**: User authorizes `git push` to remotes (GitHub/GitLab/Codeberg).
- **Step 3 (Remote -> VPS)**: VPS deploys updated code via Dokploy webhook, GitHub Actions, or SSH pull & container reload (`docker compose up -d --build`).

### 4. Empirical Local Quality Gate
- Before any code is declared ready for production push, the AI agent on the laptop MUST verify that the codebase compiles cleanly and passes all local tests with exit code 0.
