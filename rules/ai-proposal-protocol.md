---
trigger: always_on
description: Standard Protocol for Architectural Changes, RFCs, and Proactive Proposals
---

# MANDATORY GLOBAL RULE: ARCHITECTURAL PROPOSAL PROTOCOL (RFC STANDARD)

- **Principle**: "Autonomous Local Coding, RFC for Breaking Architecture Changes Only"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. SCOPE OF AUTONOMOUS EXECUTION VS RFC
1. **Autonomous Execution (Zero RFC Required)**:
   - Routine bug fixes, requested features, performance tuning, typo corrections, and localized refactoring.
   - Proceed directly via `Inspect -> Code -> Machine Verify -> Commit`.
2. **Mandatory RFC Protocol (Human Approval Required)**:
   - Proposing new third-party external dependencies / packages.
   - Major database schema overhauls or table deprecations.
   - Fundamental architectural restructuring altering public API contracts across multiple services.

---

## 2. 3-PART RFC PROPOSAL FORMAT
When a major architectural proposal is required, format it as follows:
1. **Data-Backed Rationale (Why)**: Cite empirical metrics, audit findings, compiler warnings, or benchmark data.
2. **Impact & Risk Assessment**: Define performance/conversion gains alongside breaking risks and blast radius.
3. **Execution Options**: Present modular implementation choices (minimal/lean vs full).

---

## 3. DECISION RECORDING (RAG)
- **Approved Architectural Decisions**: Logged to project `DECISIONS.md` as standard single-line ADRs.
- **Rejected Proposals**: Logged to `00-AGY-Memory/<project-namespace>/DECISIONS.md`. AI agents must never re-propose previously rejected concepts.
