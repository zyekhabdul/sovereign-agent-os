---
trigger: always_on
description: Mandatory Deterministic Machine Harness & Autonomous Scale-Up Architecture
---
# MANDATORY GLOBAL RULE: DETERMINISTIC MACHINE HARNESS & AUTONOMOUS SCALE-UP

- **Principle**: "Replace Human Bureaucracy with Machine Harness (Compilers, AST Blast Radius, Automated Tests, Git Sandboxes)"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. PARADIGM SHIFT: FROM HUMAN-GATE TO MACHINE-HARNESS
- Procedural text bureaucracy (approving plans, reading RFCs per minor step) creates user fatigue and gives false security against large-scale bugs.
- Scale-up safety is achieved strictly through **Deterministic Machine Gates** (compilers, linters, test runners, AST references, typecheckers).
- AI agents are granted end-to-end execution autonomy within bounded sandboxes, provided all machine gates pass with exit code 0.

---

## 2. FOUR PILLARS OF DETERMINISTIC AUTONOMY

### Pillar 1: Strict Compiler & Type System Gate (Arbiter Mutlak)
- In typed languages (TypeScript `tsc --noEmit`, Go `go vet`, Rust `cargo check`, Python `mypy`), the compiler is the primary quality arbiter.
- AI agent is forbidden from reporting completion if compiler/typecheck errors > 0.
- Rejection and self-healing must be driven by machine diagnostic output.

### Pillar 2: Automated Blast-Radius & Call-Site Audit
- Before mutating any shared interface, utility function, API schema, or database contract:
  1. Perform full-codebase AST or grep scan to locate all references and call-sites.
  2. Update all consuming call-sites within the same atomic patch cycle to prevent silent breaking changes.
  3. Never alter public function signatures in isolation without verifying downstream consumers.

### Pillar 3: Automated Test Harness & Self-Correction Loop
- Post-mutation execution must run the relevant test suite (`npm test`, `pytest`, `cargo test`, `go test ./...`).
- When a test fails:
  1. AI parses the stack trace and failing assertion autonomously.
  2. Fixes the defect using minimalist (Ponytail/YAGNI) diffs.
  3. Re-runs verification until all tests pass (0 failures).

### Pillar 4: Git Sandbox & Blast-Radius Isolation
- Autonomous development must operate in isolated feature/fix branches (`feature/xxx`, `fix/xxx`), never directly on `main`/`master`.
- In case of critical regression or corrupted state, rollback is instantaneous (`git reset --hard` or deleting the branch).
- Remote pushes remain strictly blocked without explicit human command (`git-push-restriction.md`).

---

## 3. SUMMARY COMPARISON

| Aspek | Model Birokrasi Teks | Model Deterministic Harness |
| :--- | :--- | :--- |
| **Beban Validasi** | User manual membaca diff/RFC per langkah | Mesin (`compiler`, `linter`, `test runner`) |
| **Kecepatan** | Lambat & interupsi tinggi | Cepat & autonomous end-to-end |
| **Ketahanan di Skala Besar** | Lemah (human fatigue, context slip) | Sangat kuat (type check & tests memblokir regresi) |
| **Blast Radius** | Terdistribusi ke seluruh chat turns | Terisolasi di Git sandbox lokal |
