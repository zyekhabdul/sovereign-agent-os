---
trigger: always_on
description: Standard Protocol for AI-Initiated Proposals, RFCs, and Proactive Ideas - Mandatory for All AI Agents
---

# MANDATORY GLOBAL RULE: AI-INITIATED PROPOSAL PROTOCOL (RFC STANDARD)

- **Principle**: "AI Proposes, Human Disposes"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. STRICT PROHIBITION ON UNREQUESTED CODE MUTATION
- The AI Agent MUST NEVER directly write code, refactor architectures, or add unrequested features/libraries based purely on an autonomous "idea" without prior human approval.
- All proactive ideas MUST pass through this proposal protocol first.

---

## 2. MANDATORY 3-PART PROPOSAL FORMAT (AI RFC)
When proposing an optimization, new feature, or architectural change, the AI Agent MUST format the proposal as follows:

1. **Data-Backed Rationale (Why)**: Cite empirical logs, audit findings, theme check warnings, CWV metrics, or UX standard data. Zero speculation or subjective fluff.
2. **Impact & Risk Assessment**: Define clear performance/conversion benefits alongside potential breaking risks.
3. **Execution Options**: Present clear, modular implementation choices (from minimal/lean to full).

---

## 3. RAG DECISION RECORDING PROTOCOL
- **APPROVED Proposals**: Added to the active project task checklist (`STATE.md` & `DEVELOPMENT.md`) and implemented incrementally.
- **REJECTED Proposals**: The decision and rejection reason MUST be logged immediately to `00-AGY-Memory/<project-namespace>/DECISIONS.md`.
- **STRICT AGENT CONSTRAINT**: Future AI agents MUST inspect `DECISIONS.md` at session start. An agent MUST NEVER re-propose or re-attempt an idea that has been previously rejected by the user.
