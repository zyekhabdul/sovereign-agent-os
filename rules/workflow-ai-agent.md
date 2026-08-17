---
trigger: always_on
description: Smart Batch Execution & Hyper-Granular Task Chunking Protocol (Model-Agnostic / Low-Model Compatible)
---

# MANDATORY GLOBAL RULE: ADAPTIVE AI WORKFLOW STANDARD

All AI coding tools and agents (AGY Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode) MUST adhere to the following Adaptive Execution & Hyper-Granular Chunking Standard:

```
PRD / Ide → PLAN.md (Hyper-Granular Sub-detail Chunks) → Upfront Approval → Autonomous Batch Execution (Silent Verification) → Strategic Checkpoint
```

---

## 1. HYPER-GRANULAR TASK CHUNKING SCHEMA (LOW-MODEL COMPATIBLE)

To ensure that even smaller/cheaper AI models (e.g., Flash/Haiku/Mini models) can execute tasks flawlessly without guesswork or hallucinations, every chunk in `PLAN.md` MUST meet these 4 hyper-granularity criteria:

1. **Explicit Target Files & Scope**:
   - Specify absolute/relative file paths and line ranges/selectors.
   - Example: `sections/main-product.liquid` (line ~55-65 inside `.product-price-wrapper`).

2. **Zero-Ambiguity Implementation Steps**:
   - Provide exact CSS variable names (`var(--color-sale)`), Liquid filter signatures (`| money`), HTML IDs, and JS function specs.
   - Prohibit vague instructions like "make it look nice" or "add styling".

3. **Explicit Input/Output Data Contracts**:
   - Define exact translation keys, liquid objects (`product.selected_or_first_available_variant`), and URL structures.

4. **Machine-Verifiable Definition of Done (DoD)**:
   - Specify the exact command or string check to verify completion (e.g., `shopify theme check` 0 errors, translation key verification).

---

## 2. ADAPTIVE WORKFLOW PHASES

### Phase 1: Hyper-Granular `PLAN.md` Generation
- Create `PLAN.md` breaking down the feature into ultra-specific, self-contained sub-detail chunks using the schema above.

### Phase 2: Single Upfront Approval
- Present `PLAN.md` to the user for one-time upfront approval.

### Phase 3: Autonomous Batch Execution with Silent Quality Gates
- Execute all chunks sequentially in batch mode.
- Run silent verification after each chunk (`shopify theme check`). Fix errors autonomously if found.

### Phase 4: Strategic Checkpoint Pause
- Pause ONLY at critical milestones (Pre-git push, production deployment, destructive schema changes).
