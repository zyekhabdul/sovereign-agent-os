---
trigger: always_on
description: Continuous Empirical Diagnostics & Workspace Health Verification
---

# MANDATORY GLOBAL RULE: CONTINUOUS EMPIRICAL DIAGNOSTICS & SYSTEM INTEGRITY

- **Principle**: "Zero Speculation, Zero Hallucination, Continuous Empirical Verification"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).
- **Core Diagnostic Principle**: Machine-Executable Verification over Subjective Assumption.

---

## 1. MANDATORY DIAGNOSTIC TOOL SYNCHRONIZATION ON CODE MUTATION
Setiap kali terjadi modifikasi kode, penambahan endpoint, perubahan skema database, pembaruan konfigurasi server, atau migrasi arsitektur pada repositori aktif:

1. **Sinkronisasi Test & Probing Logic**: AI Agent **WAJIB** memperbarui atau menambahkan skenario pengujian baru ke dalam test suite atau script diagnostik lokal repositori (misal: unit/integration test, `scripts/doctor.sh`, atau `pytest`/`vitest`/`cargo test`).
2. **Larangan Asumsi Tanpa Eksekusi Tool**: AI Agent DILARANG KERAS mengklaim bahwa sebuah fitur atau sistem "berjalan normal" tanpa menjalankan diagnostic suite / test suite secara langsung di terminal dengan output exit code 0.
3. **Penyimpanan Bukti Verifikasi**: Setiap eksekusi verifikasi wajib menghasilkan bukti terminal empiris (`tests_executed > 0`, `exit code 0`, atau log telemetri) sebelum tugas dilaporkan selesai.

---

## 2. UNIVERSAL EMPIRICAL QUALITY GATES
Sebelum merilis fitur atau menandai checkpoint selesai, verifikasi layer berikut sesuai cakupan repositori:
- **Layer 1: Resource & Host Integrity**: Beban CPU/RAM wajar, socket jaringan tidak konflik (`ss -tulpn` jika relevan).
- **Layer 2: Daemons & Runtime Health**: Layanan lokal / container berjalan normal (`docker compose ps` atau process check).
- **Layer 3: Security & File Permissions**: File kredensial/kunci terlindungi (`0600`), zero secret leak ke git tree.
- **Layer 4: Compiler & Type System**: 0 syntax/typing errors (`tsc --noEmit`, `cargo check`, `go vet`, dll).
- **Layer 5: Test Harness & Assertions**: Suite tes lokal lulus tanpa skipping dan tanpa mock cheating.
- **Layer 6: API & Network Contracts**: Header keamanan, HTTP response valid, data contract sesuai spesifikasi PRD.
- **Layer 7: Telemetry & Observability**: Log bebas unhandled exceptions dan crash traces.

---

## 3. CHECKPOINT CRITERIA
Sebelum sesi berakhir atau commit dilakukan:
- Jalankan test runner / health probe lokal milik repositori aktif (misal: `npm test`, `pytest`, `cargo test`, atau script health check lokal).
- Pastikan: `Failed checks: 0` dan semua pengujian menghasilkan `exit code 0`.
