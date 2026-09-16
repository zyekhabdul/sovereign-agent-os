---
trigger: always_on
description: Standard Protocol for Architectural Changes, RFCs, and Proactive Proposals
---

# MANDATORY GLOBAL RULE: ARCHITECTURAL PROPOSAL PROTOCOL (RFC STANDARD)

- **Principle**: "Autonomous Local Coding, RFC for Breaking Architecture Changes Only"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. SCOPE OF AUTONOMOUS EXECUTION VS RFC (THRESHOLD GATE)
1. **Autonomous Execution (Zero RFC/ADR Required — Fast Track)**:
   - Routine bug fixes, requested features within existing patterns, performance tuning, typo corrections, and localized refactoring.
   - Proceed directly via: `Ide -> PRD Lite -> PLAN.md -> Exec / QA`.
2. **Mandatory RFC & ADR Protocol (Human Approval Required)**:
   Triggered IF AND ONLY IF changes meet at least one of these 4 conditions:
   - **Condition 1**: Proposing new third-party external dependencies / packages.
   - **Condition 2**: Major database schema overhauls, structural migrations, or table deprecations.
   - **Condition 3**: Fundamental architectural restructuring altering public API contracts across multiple services.
   - **Condition 4**: Multi-module blast radius touching > 3 independent modules/packages simultaneously.
3. **Pre-Flight ADR Scan Invariant**:
   - Before drafting any PRD, RFC, or PLAN, AI agents MUST scan the last 10 entries of project ADRs located in the Obsidian RAG namespace: `00-AGY-Memory/<project-namespace>/DECISIONS.md` (via Obsidian MCP or direct filesystem path) to ensure proposed architectures do not violate prior ADRs or resurrect rejected concepts.

---

## 2. 3-PART RFC PROPOSAL FORMAT
When a major architectural proposal is required, format it as follows:
1. **Data-Backed Rationale (Why)**: Cite empirical metrics, audit findings, compiler warnings, or benchmark data.
2. **Impact & Risk Assessment**: Define performance/conversion gains alongside breaking risks and blast radius.
3. **Execution Options**: Present modular implementation choices (minimal/lean vs full).

---

## 3. DECISION RECORDING (RAG)
- **Approved Architectural Decisions**: Logged to `00-AGY-Memory/<project-namespace>/DECISIONS.md` as standard single-line ADRs.
- **Rejected Proposals**: Logged to `00-AGY-Memory/<project-namespace>/DECISIONS.md` with status `[REJECTED]`. AI agents must never re-propose previously rejected concepts.
