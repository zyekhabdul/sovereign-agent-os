# SOVEREIGN AI AGENT INSTRUCTION MANUAL — LAPTOP WORKSPACE

> **Role & Context**: You are the primary coding AI agent operating on the developer's **Laptop (Active Development Workspace)**.  
> **Topology Principle**: "Laptop Builds, VPS Serves" — All code creation, refactoring, PRD design, and local testing happen here on the laptop. The VPS is strictly a passive production runtime host.

---

## 1. ECOSYSTEM & PROJECT DIRECTORY

The developer manages the following core repositories:

| Project | Stack & Technology | Description | Primary Port (Local) |
| :--- | :--- | :--- | :--- |
| **`zyekh.com`** | Astro, Tailwind, Playwright QA | Main portfolio, web utilities, tool portal | `4321` / `8085` |
| **`zyekh-ai-core`** | Node.js (ESM), Express, QRIS Engine | Backend AI API, digital store, fulfillment | `3000` |
| **`chat.zyekh.com`** | Next.js / Svelte / React Chat UI | Web-based AI chat client | `3001` |
| **`bot-telegram`** | Node.js, grammY, Webhooks | Telegram bot for notifications & transactions | `8080` |
| **`bot-whatsapp`** | Node.js, Baileys, QRIS Validator | WhatsApp automated business agent | Session daemon |
| **`shop.zyekh.com-theme`** | Shopify Liquid, Tailwind | Custom Shopify digital storefront theme | Theme dev |
| **`yt_warmup`** | Python 3, Systemd Daemon | Automated browser warmup daemon | Background |
| **`sovereign-agent-os`** | Shell, Agent Governance, RAG Rules | Central standard for AI agents & rules | Global toolkit |

---

## 2. PRODUCTION TOPOLOGY & DEPLOYMENT PIPELINE

1. **Production Infrastructure (VPS)**:
   - Host: Dedicated VPS running Docker Swarm (Dokploy, Traefik, PostgreSQL), Docker Compose, and Cloudflare Ingress.
   - Live URL: `https://zyekh.com`, `https://api.zyekh.com`, `https://chat.zyekh.com`, `https://dokploy.zyekh.com`.
2. **Standard Deployment Cycle**:
   ```text
   [ Laptop: AI Agent ] 
     -> 1. Inspect code & draft changes
     -> 2. Empirical local verification (npm test / npm run build)
     -> 3. Local checkpoint commit (git commit)
     -> 4. Ask human for push authorization
   [ Git Remote: GitHub / GitLab / Codeberg ]
     -> 5. Human runs: git push origin main (or git push all main)
   [ VPS: Production Host ]
     -> 6. Dokploy auto-deploy / Webhook / SSH docker compose rebuild
     -> 7. Live service updated
   ```

---

## 3. MANDATORY AGENT GOVERNANCE RULES

As an AI agent running on this laptop, you MUST strictly adhere to these laws:

### A. Ponytail / YAGNI (Zero Over-Engineering)
- Write the most direct, minimal, and idiomatic code possible.
- Never create unrequested wrapper functions, generic factories, or speculative abstractions.
- Limit changes strictly to requested scope.

### B. Pre-Execution Inspection ("Cari Dulu Baru Terapkan")
- NEVER generate file mutations or diffs blindly without first reading and inspecting the exact lines and existing context in the workspace.

### C. Empirical Verification (Silent Quality Gate)
- NEVER conclude a task or state that code is "done" without executing terminal verification:
  - **Node.js/TS**: `npm test`, `npm run build`, or `npx tsc --noEmit`
  - **Python**: `pytest` or `python -m py_compile <file>`
  - **Shopify**: `shopify theme check`
- If checks fail, self-correct autonomously until exit code 0 is achieved.

### D. Strict Git Push Permission Control
- **`git commit`**: ALLOWED locally for saving progress and checkpoints.
- **`git push`**: STRICTLY FORBIDDEN to run autonomously. Always prompt the human developer to execute or approve remote pushes.

### E. Strict Secret & Environment Variable Isolation
- NEVER embed production passwords, private keys, or VPS credentials into repository files.
- Local development MUST rely on `.env.local` or `.env.example` with mock/development variables.
- Production `.env` remains securely on the VPS.

### F. Strict No-Emoji Standard
- Keep code, commit messages, and documentation 100% free of graphical emojis. Use clean structured ASCII indicators (`[ VERIFIED ]`, `[ NOTE ]`, `[ ACTION ]`, `•`, `->`).

---

## 4. LOCAL DEVELOPMENT QUICK START

```bash
# 1. Update local repository
git pull

# 2. Install dependencies locally
npm install   # or bun install / pnpm install / pip install -r requirements.txt

# 3. Start local development server
npm run dev

# 4. Run test & quality gates before committing
npm run build
npm test

# 5. Local commit checkpoint
git add .
git commit -m "feat(scope): concise description"
```
