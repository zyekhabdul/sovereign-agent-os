---
trigger: always_on
description: inspect-before-apply.md
---

# MANDATORY GLOBAL RULE: PRE-EXECUTION INSPECTION PROTOCOL ("CARI DULU BARU TERAPKAN")

- **Principle**: "No Mutation Without Prior Inspection & Zero Blind Full-File Overwrite"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. STRICT PROHIBITION ON BLIND MUTATION (ZERO SPECULATION)
- AI agents MUST NEVER invoke file-mutating tools (`write_to_file`, `replace_file_content`, file-modifying bash commands) without FIRST reading and verifying the target file in the conversation context.
- Guessing line numbers, file contents, module exports, or function signatures without a prior read tool call is STRICTLY FORBIDDEN.

---

## 2. ANTI-AMPUTATION INVARIANT: SURGICAL DIFF OVER BLIND OVERWRITE
- For **EXISTING** source files: AI agents MUST use `replace_file_content` (surgical diff) to preserve peripheral functions, helpers, comments, and docstrings.
- `write_to_file` is strictly restricted to **NEW** file creation. Using `write_to_file (Overwrite=true)` on existing source files without explicit instruction is prohibited.

---

## 3. MANDATORY TWO-PHASE EXECUTION GATE

### Phase 1: Inspection & Evidence Gathering (Read-Only Gate)
Before modifying any code or proposing an implementation:
1. **Locate Target**: Use `agy-guard find`, `grep_search`, or `list_dir` to find the exact file path.
2. **Read Authoritative State**: Use `view_file` (with bounded line slices) or `agy-guard inspect-symbol` to inspect target lines and surrounding imports.
3. **Verify Reality**: Confirm the exact syntax, types, and logic before drafting changes.

### Phase 2: Evidence-Backed Mutation (Write Gate)
1. **Exact Matching**: Use the exact inspected character sequence in `TargetContent` for `replace_file_content`.
2. **Minimal Radius**: Mutate only the strictly required lines (Ponytail / YAGNI). Zero unsolicited refactorings.
3. **Silent Verification**: Immediately run build, lint, or test commands to empirically verify the change.

---

## 4. PROOF-OF-INSPECTION REQUIREMENT
Every code modification MUST be preceded by a tool read step in the conversation trajectory. Generating a file modification without prior inspection is classified as a Critical Protocol Failure.
