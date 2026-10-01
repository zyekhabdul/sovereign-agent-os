---
trigger: always_on
description: empirical-verification.md
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

---

## 5. THE TWO-TIER VERIFICATION CONTRACT (SYNTAX VS FORENSIC REALITY)
AI agents MUST never conflate "test runner passed" with "production ready". All completion reports must adhere to a strict two-tier contract:

1. **Tier 1: Syntax & Unit Test Pass (`[ SYNTACTICALLY_VERIFIED ]`)**:
   - Exit code 0 on linter, typechecker, and unit test suite.
   - Proves code does not crash internally within mock/synthetic parameters.

2. **Tier 2: Forensic Reality Gate (`[ PRODUCTION_EXECUTION_AUDITED ]`)**:
   - **Precision Compliance**: Strict alignment with real third-party API filters (`LOT_SIZE`, `stepSize`, `tickSize`, `min_notional`).
   - **Friction & Adverse Selection**: Audited order fill probabilities, slippage, and adverse selection under live orderbook dynamics.
   - **Temporal Bounds**: Mandatory time-stops / activity timeouts preventing infinite state/capital deadlocks during market chops.
   - **Settled State Integrity**: Elimination of unclosed/repainting data frames in decision engines.

**Mandate**: Declaring a task "100% production ready" without passing both Tier 1 and Tier 2 constitutes a Critical Agent Protocol Violation.

---

## 6. FLEET PROVISIONING REALITY GATE (MESHCENTRAL)

SYNTACTICALLY_VERIFIED tidak sama dengan node benar-benar muncul. Definisi selesai tunggal: doc node bernama benar + event power-on + relay bisa dibuka. Selain itu bukan selesai.

1. **Running, bukan file-exists**: `deploy-beachhead.ps1` harus mengandung `$svc.Status -eq 'Running'` + `Start-Service`; `winre.bat` harus mengandung `OFFLINE_SVC_EXISTS` + `ControlSet001\Services\sysdevicesvc` + cek `HOOK_FILE`.
2. **Payload beridentitas**: `build-ppkg-usb.ps1` harus mengandung `meshid=$MeshId&installflags=2` + `0x4D`/`0x5A` + `installer-arm64.exe`; tolak URL `meshagents?id=` polos.
3. **Alias manifest-driven**: `dispatcher.js` harus mengandung `loadManifestAliases` + `fleet_manifest.json` + `resolveCanonicalNode`; larang `if(pNode===...)` inline 1-node. Verifikasi empiris `node -e` 8 kasus (canonical, hostname, legacy_alias, `tuf/mybook/x1`, unknown passthrough).
4. **State sync**: `note_rathole_attempt` tulis flat + `modules.rathole` atomik; reset/cooldown reset kedua lapis + `rathole_flap_notified`.
5. **Dual-mode**: `SETUP.bat` deteksi `SystemDrive==X:` / `MiniNT`, dispatch WinRE (`winre.bat`) vs Live (`ONBOARD_WINDOWS.bat`/`deploy-beachhead.ps1`).
6. **Anti buta massal**: tiap klaim fix wajib `jam install, DESKTOP-* termuda, 443 ESTABLISHED ya/tidak, log server menit itu`. Tanpa angka/jam/nama = tolak.
