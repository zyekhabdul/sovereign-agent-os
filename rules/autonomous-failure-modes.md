# MANDATORY GLOBAL RULE: AUTONOMOUS FAILURE MODES & HARDENING DEFENSE

- **Principle**: "Anticipate, Block, and Harden Against Autonomous AI Blunders"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. PRIMARY FAILURE MODES (TEST & EXECUTION INTEGRITY)

### Failure Mode 1: Test Cheating / Tautological Passing
- **Mechanism**: AI alters or weakens existing assertions (`expect(true).toBe(true)`) or mocks out real logic to force `exit code 0`.
- **Defense Invariant**: AI is strictly forbidden from modifying, weakening, or deleting existing test assertions. New tests must validate black-box contracts with realistic input-output payloads.

### Failure Mode 2: Infinite Self-Healing Death Loop
- **Mechanism**: AI repeatedly attempts to fix compiler/test errors in an endless loop, draining tokens and compute without progress.
- **Defense Invariant**: Circuit Breaker strictly enforced at **3 iterations**. If verification fails on iteration 3, hard-stop, isolate the diff, and report raw compiler stack trace to user.

### Failure Mode 3: Silent Semantic Logic Drift
- **Mechanism**: Code passes compiler and type checks, but inverts business logic or drops edge-case handling.
- **Defense Invariant**: Enforce Ponytail Diff Minimalism. Restrict diff radius to the exact requested logic. For dynamic languages, mandate boundary-condition table tests.

### Failure Mode 4: The Zero-Test Trap (False Green Suite)
- **Mechanism**: Test runner returns exit code 0 because tests were skipped (`.skip()`, `xit()`, `@pytest.mark.skip`) or pattern matched 0 files.
- **Defense Invariant**: Machine verification pass criteria strictly requires `test_count > 0` and `skipped_count == 0` for the target module.

---

## 2. CODEBASE & FILE MUTATION FAILURE MODES

### Failure Mode 5: Blind Full-File Overwrite / Code Amputation
- **Mechanism**: Using full file overwrites (`write_to_file` with Overwrite=true) on existing source files, accidentally erasing unmentioned helper functions, peripheral exports, or comments.
- **Defense Invariant**: `replace_file_content` (surgical diff) is STRICTLY MANDATORY for existing files. `write_to_file` is permitted ONLY when creating brand new files.

### Failure Mode 6: Context Headroom Saturation on Long Chains
- **Mechanism**: Executing long multi-file tasks in a single turn dumps massive compiler logs into context, degrading reasoning quality near the end of the chain.
- **Defense Invariant**: Filter verbose terminal outputs. For tasks touching >5 independent modules, enforce atomic local commits and modular boundary checkpoints.

### Failure Mode 7: "Clever Code" & Unmaintainable Metaprogramming
- **Mechanism**: AI introduces excessive generics, reflection, or obscure metaprogramming patterns that pass tests but degrade human readability.
- **Defense Invariant**: Strict Ponytail/YAGNI law. Prefer explicit, readable, and idiomatic standard patterns over clever abstractions.

---

## 3. SYSTEMIC & RUNTIME FAILURE MODES

### Failure Mode 8: Phantom Dependency & Supply Chain Bloat
- **Mechanism**: AI installs unverified, hallucinated, or CVE-vulnerable third-party packages to quickly bypass tasks.
- **Defense Invariant**: Native Standard Library First (`node:fs`, `node:crypto`, `fetch`, `datetime`). New third-party dependencies strictly require human approval.

### Failure Mode 9: Hardcoded Local Path & Environment Leakage
- **Mechanism**: AI hardcodes local paths (`/home/fuckadmin/...`) or relies on uncommitted local `.env` variables.
- **Defense Invariant**: Absolute paths strictly prohibited in application source code. Enforce relative path resolution and sanitized config loaders.

### Failure Mode 10: Zombie Processes & Port Collisions
- **Mechanism**: AI spawns background dev servers or background workers that do not terminate, locking ports and consuming RAM.
- **Defense Invariant**: Automated process teardown on test completion. Use ephemeral ports for isolated development testing.

### Failure Mode 11: State Pollution & Non-Idempotent Database Mutations
- **Mechanism**: Tests mutate shared database tables or file fixtures without cleanup, causing subsequent test runs to fail flakily.
- **Defense Invariant**: Transactional test rollbacks or ephemeral in-memory databases (SQLite/isolated Docker fixtures). Zero permanent state mutation in test suites.

### Failure Mode 12: Cache Poisoning & Stale Build Artifacts
- **Mechanism**: Test runner passes based on stale cached bytecode (`__pycache__`, `.next/cache`, `dist/`), masking broken source files.
- **Defense Invariant**: Verification commands must use clean/no-cache flags when build errors or syntax changes occur.

### Failure Mode 13: Secret Exfiltration in Logs & Stack Traces
- **Mechanism**: AI adds verbose debug logs (`console.log(process.env)`) dumping private credentials into terminal transcripts.
- **Defense Invariant**: Strict credential scrubbing. AI must never print, export, or log raw environment secrets to transcripts or notes.

### Failure Mode 14: Diverged Remote / Unpulled Git Tree
- **Mechanism**: Modifying local code without pulling remote changes leads to severe merge conflicts upon git push.
- **Defense Invariant**: Mandatory `git status` and `git pull` sync check before initiating major refactoring on shared repositories.

### Failure Mode 15: Namespace / Alias Mismatch in Automation Hooks
- **Mechanism**: Repository folder names differing from memory vault namespaces cause background git hooks to fail silently.
- **Defense Invariant**: Canonical namespace mapping resolution in scripts (`scripts/install-rag-hooks.sh` and `scripts/rag-lint.sh`).
