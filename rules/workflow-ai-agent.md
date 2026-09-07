---
trigger: always_on
description: Autonomous Batch Execution & Deterministic Machine-Gated Verification Workflow
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
---

## 3. SLIDING PACKET WINDOW & EPHEMERAL PLAN INVARIANT
1. **10-Chunk Active Packet Invariant**:
   - `PLAN.md` may contain a high-level roadmap outline of all phase packets, but MUST ONLY expand granular step-by-step DoD for a maximum of 10 chunks (1 active work packet) at any time.
   - Future chunks remain in the roadmap outline; they are expanded only when the active packet is completed.
2. **Ephemeral Single-Plan Invariant**:
   - Exactly ONE `PLAN.md` file is allowed in the local repository root.
   - Creating ad-hoc execution dump files (`PLAN-part2.md`, `Session-XX.md`, `task-detail.md`, `scratch-plan.md`) is strictly forbidden.
   - Once an active packet of 10 chunks is verified (exit code 0) and committed, the detail section of `PLAN.md` is overwritten with the next packet.
