---
trigger: always_on
description: sensitive-area-guard.md
---

# MANDATORY GLOBAL RULE: SENSITIVE AREA HARD-STOP & AUTHORIZATION GATE

- **Principle**: "Human Authorization Required for High-Risk & Destructive Surfaces"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. DEFINITION OF SENSITIVE SURFACES
The following surfaces are classified as **Critical / Sensitive**:
1. **Authentication & Identity**: Session handling, password hashing, JWT/OAuth logic, permission gates.
2. **Financial & Payments**: Stripe, PayPal, billing calculations, webhook handlers.
3. **Database Schema & Migrations**: Table drops, structural migrations, irreversible data mutations.
4. **Secrets & Environment**: `.env*` files, API keys, private certificates, cloud credentials.
5. **Production Deployment & CI/CD**: Workflow YAMLs, docker production configs, domain routing.

---

## 2. MANDATORY HARD-STOP PROTOCOL
- Before modifying or applying changes to any of the sensitive surfaces above:
  1. AI agent MUST pause execution immediately (*Hard Stop*).
  2. Present the proposed change as a concise RFC/Diff to the user.
  3. Wait for explicit human confirmation before executing the mutation.
- Autonomous bulk execution is strictly prohibited when touching sensitive surfaces.
