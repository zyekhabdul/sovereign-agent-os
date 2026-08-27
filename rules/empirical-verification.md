---
trigger: always_on
description: Mandatory Empirical Verification & Silent Quality Gate Protocol - Zero Assumptions
---

# MANDATORY GLOBAL RULE: EMPIRICAL VERIFICATION & SILENT QUALITY GATE

- **Principle**: "No Assumption Without Empirical Terminal Proof"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. MANDATORY POST-MUTATION VERIFICATION
- AI agents MUST NEVER conclude a task or state that code is "fixed/working" without running an empirical verification command in the terminal.
- Every code modification MUST be followed by the appropriate check command:
  - **Node.js/TS**: `npm test`, `npm run build`, or `npx tsc --noEmit`
  - **Python**: `pytest`, `python -m py_compile <file>`, or type check
  - **Rust**: `cargo check` or `cargo test`
  - **Go**: `go vet` or `go test ./...`
  - **PHP**: `php -l <file>`
  - **Shopify Liquid**: `shopify theme check`

---

## 2. THE ZERO-TEST TRAP DEFENSE (NON-EMPTY PASS MANDATE)
- A test suite returning exit code 0 is INVALID if `tests_run == 0` or all tests were skipped (`.skip()`, `xit()`, `@pytest.mark.skip`).
- Pass condition strictly requires:
  1. `exit code == 0`
  2. `tests_executed > 0`
  3. `failures == 0` and `errors == 0`

---

## 3. AUTONOMOUS RECOVERY PROTOCOL (SELF-CORRECTION)
- If an empirical check fails with errors:
  1. AI Agent MUST parse the exact compiler/linter error output.
  2. Perform targeted, minimal fixes following the *Ponytail (YAGNI)* principle.
  3. Re-run verification silently until 0 errors are achieved.
- If an error cannot be resolved within 3 iterations, STOP and report the exact trace and root cause to the user (Circuit Breaker).

---

## 4. DEFINITION OF DONE (DoD)
A task chunk is officially classified as COMPLETE only when:
1. Target code has been written and verified against inspection data.
2. Build/Lint/Test verification returns exit code 0 with non-zero test execution.
3. Checkpoint has been logged via `agy-guard checkpoint`.
