---
trigger: always_on
description: Modern Agentic Engineering & Dual-Track Verification Harness Workflow
---

# MANDATORY GLOBAL RULE: AUTONOMOUS WORKFLOW & MACHINE-GATED VERIFICATION

All AI coding tools and agents (AGY Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode) MUST adhere to the following Dual-Track Autonomous Execution Standard:

```
[Track A: Fast-Track / Agentic TDD (80%)]
  Prompt/Issue → Inspect AST/Grep → Red (Test/Harness) → Green (Minimal Edit) → Machine Gate (Exit 0) → Local Commit → Dev Reviews Diff

[Track B: Spec-Driven Development (20%)]
  Complex Request → Pre-Flight ADR Scan → SPEC.md (Types/Invariants) → [RFC/ADR Gate] → Sliding PLAN.md (Max 10) → Two-Tier Gate → PR Review
```

---

## 1. DUAL-TRACK EXECUTION LIFECYCLE

### Track A: Fast-Track / Agentic TDD (Default 80%)
Applies to: Bug fixes, localized features, chores, refactoring, performance improvements, and single components.
1. **Inspection**: Scan target files and call-sites via AST or grep (`inspect-before-apply.md`).
2. **Test/Harness First (Red)**: Write a failing reproduction test or ensure targeted test coverage exists.
3. **Surgical Implementation (Green)**: Implement minimal, clean code (*Ponytail / YAGNI*).
4. **Machine Verification Gate**: Compiler, linter, and test runner MUST exit code 0 (`tests_executed > 0`, `failures == 0`).
5. **Atomic Checkpoint & Review**: Commit locally; human reviews the change via `git diff` / PR.
*Strict Invariant: Zero PRD or multi-chunk PLAN overhead for Track A tasks.*

### Track B: Spec-Driven Development / SDD (Complex 20%)
Applies to: New system architectures, database migrations, public API changes, or blast radius > 3 modules.
1. **Pre-Flight ADR Scan**: Scan the last 10 ADRs (`00-AGY-Memory/<ns>/DECISIONS.md`).
2. **Lightweight SPEC.md**: Define data contracts, typed schemas, behavioral invariants, and explicit Non-Goals.
3. **RFC / ADR Threshold Gate**: Mandatory RFC only if introducing new third-party dependencies, breaking API contracts, or altering database schemas.
4. **Sliding Packet PLAN.md**: Expand granular DoD for a maximum of 10 chunks at any time.
5. **Two-Tier Verification Gate**:
   - **Tier 1 (Syntax & Tests)**: Exit code 0 on compiler, linter, and test suite.
   - **Tier 2 (Production Reality Audit)**: Decimal precision (`stepSize`, `tickSize`), timeout guards, settled-state integrity.

---

## 2. STRATEGIC HARD-STOP CHECKPOINTS
Pause execution and solicit human confirmation ONLY at:
1. Irreversible destructive database operations (Drop/Truncate).
2. Remote `git push` operations (`git-push-restriction.md`).
3. Production server deployments.
4. Circuit breaker trip (after 3 failed self-healing attempts).

---

## 3. SLIDING PACKET WINDOW & EPHEMERAL PLAN INVARIANT
1. **10-Chunk Active Packet Invariant**:
   - For Track B, `PLAN.md` may outline future milestones, but MUST ONLY expand granular DoD for a maximum of 10 chunks (1 active work packet) at any time.
2. **Ephemeral Single-Plan Invariant**:
   - Exactly ONE `PLAN.md` file is allowed in the repository root. Ad-hoc split plan files are strictly forbidden.
   - Once an active packet is verified (exit code 0) and committed, the active packet is marked complete or overwritten with the next packet.

---

## 4. RFC/ADR THRESHOLD GATE
- RFC is strictly bypassed for routine work and Track A tasks.
- RFC is triggered ONLY when touching new dependencies, DB schemas, breaking public API contracts, or >3 modules blast radius.
