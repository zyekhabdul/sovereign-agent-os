---
trigger: always_on
description: workflow-ai-agent.md
---

# MANDATORY GLOBAL RULE: AUTONOMOUS WORKFLOW & MACHINE-GATED VERIFICATION

All AI coding tools and agents (AGY Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode) MUST adhere to the following Autonomous Execution Standard:

```
Goal / Request → AST & Call-Site Pre-Scan → Autonomous Execution → Deterministic Machine Gate (Compiler/Tests/Lint == 0) → Atomic Local Commit → Report Proof
```

---

## 1. FIVE-STAGE AUTONOMOUS EXECUTION LIFECYCLE

### Stage 1: Pre-Scan & Grounding (Inspect Before Apply)
- Read target files and scan global call-sites/references via AST or grep (`inspect-before-apply.md`).
- Identify blast radius across consumers before making changes.

### Stage 2: Autonomous Implementation (Ponytail / YAGNI)
- Write minimal, idiomatic, and clean code to satisfy the goal (`ponytail-yagni.md`).
- Zero unsolicited bloat, zero unneeded wrappers, zero dead code.

### Stage 3: Deterministic Machine Verification Gate
- Run terminal verification suites (`tsc --noEmit`, `pytest`, `cargo check`, `npm test`, `shopify theme check`).
- **Pass Condition**: Exit code 0 with zero compiler/test errors.
- **Self-Healing Loop**: If verification fails, parse stack trace and auto-repair (Max 3 iterations before circuit breaker trips).

### Stage 4: Atomic Local Git Checkpoint
- Commit changes to local feature branch with terse, structured commit messages (`git-push-restriction.md`).

### Stage 5: Proof-Based Final Reporting
- Report task completion to user with empirical terminal proof (`[ VERIFIED ]`, test pass counts, zero error status).

---

## 2. STRATEGIC HARD-STOP CHECKPOINTS
Pause execution and solicit human confirmation ONLY at:
1. Irreversible destructive database operations.
2. Remote `git push` operations.
3. Production server deployments.
4. Circuit breaker trip (after 3 failed self-healing attempts).
