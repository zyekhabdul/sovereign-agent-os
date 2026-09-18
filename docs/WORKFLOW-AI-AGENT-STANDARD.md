# Standar Workflow AI Agent: Modern Agentic Engineering & Verification Harness (2026)

Panduan alur kerja standar modern yang WAJIB dipatuhi oleh seluruh AI coding agent (AGY / Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode) dalam berkolaborasi dengan developer:

> **Prinsip Utama**: *"Human Sets Direction, Machine Gates Integrity, AI Executes Autonomously."*  
> Menghilangkan birokrasi teks berlebih (waterfall PRD/PLAN untuk hal rutin). Verifikasi kebenaran dipindahkan dari asumsi teks ke *Machine Harness* (compiler, typecheck, test runner, git diff).

---

## 1. Arsitektur Dual-Track Workflow

Alur kerja dibagi menjadi dua jalur berdasarkan kompleksitas:

```
[INPUT: Issue / Permintaan Dev]
           │
           ├─► [80% Kasus] Track A: Fast-Track / Agentic TDD
           │   (Bugfix, Local Feature, Refactor, Chore, UI Component)
           │   1. Inspect Codebase (AST/Grep call-sites)
           │   2. Red: Tulis failing test / pastikan test harness aktif
           │   3. Green: Implementasi bedah (replace_file_content, YAGNI)
           │   4. Verify: Machine Harness (lint, tsc, test runner exit 0)
           │   5. Review: Dev review Git diff / PR di feature branch
           │
           └─► [20% Kasus] Track B: Spec-Driven Development (SDD)
               (Arsitektur Baru, DB Migrations, Public API, >3 Modul)
               1. Pre-Flight ADR Scan (00-AGY-Memory/<ns>/DECISIONS.md)
               2. Lightweight SPEC.md (Typed schema, Invariants, Non-Goals)
               3. RFC / ADR Threshold Gate (Hanya jika breaking)
               4. Feature Branch Execution (Checklist sliding packet max 10)
               5. Two-Tier QA Gate & PR Review
```

---

## 2. Struktur & Peran File Modern

| File / Artefak | Fungsi & Lokasi | Sifat |
|---|---|---|
| `AGENTS.md` / `GEMINI.md` / `CLAUDE.md` | Single Root Instruction SSOT (build/test commands, invariants, rules) di root repo (<150 baris) | Wajib per repo |
| `SPEC.md` / `PRD.md` | Spesifikasi "what & why", batas Non-Goals, dan skema tipe (hanya untuk Track B) | Kondisional (Track B saja) |
| `PLAN.md` | Checklist kerja aktif terarah (maksimal 10 chunk aktif per batch) | Kondisional (Track B / Multi-step) |
| Test Suite (`tests/`, `spec/`) | **Kontrak Kebenaran Mutlak** (Unit, Integration, E2E, Evals) | Wajib untuk verifikasi |
| `DECISIONS.md` (ADR) | Catatan keputusan arsitektur permanen di Obsidian RAG (`00-AGY-Memory/<ns>/DECISIONS.md`) | Append-only (Arsitektural) |
| `DEVELOPMENT.md` | Human Narrative Log & handoff developer | Opsional / Manual |
| Git History & Branch | **State Management Sejati** (`git diff`, `git log`, `feature/<name>`) | Native SSOT |

> **Anti-Birokrasi Invariant**: Dilarang memaksa pembuatan `PRD.md` atau `PLAN.md` untuk perbaikan bug rutin, refactoring lokal, atau tugas Track A.

---

## 3. Detail Eksekusi Jalur Kerja

### Jalur A: Fast-Track / Agentic TDD (Default 80%)
Untuk tugas-tugas terisolasi:
1. **Inspeksi (Inspect Before Apply)**: AI membaca berkas target dan memindai referensi/call-site global via grep atau AST.
2. **Test Harness First**: AI menulis tes unit/integrasi yang gagal mereproduksi bug (Red), atau mengonfirmasi assertion pengujian target.
3. **Surgical Implementation**: AI mengimplementasikan solusi minimal (*Ponytail / YAGNI*).
4. **Machine Gate Verification**: Jalankan test suite (`pytest`, `npm test`, `cargo test`, `go test ./...`). Wajib `exit code 0` dengan `tests_executed > 0`.
5. **Git Checkpoint**: Buat commit lokal dengan format terstruktur. Developer mereview hasil melalui `git diff`.

### Jalur B: Spec-Driven Development / SDD (Kompleks 20%)
Untuk perubahan skala besar atau arsitektural:
1. **Pre-Flight ADR Scan**: AI membaca 10 ADR terakhir di `00-AGY-Memory/<ns>/DECISIONS.md`.
2. **Klarifikasi Batasan & Non-Goals**: Kunci apa yang TIDAK dikerjakan untuk mencegah scope creep.
3. **Threshold Gate (RFC & ADR)**:
   - Terpicu HANYA JIKA: menambah library baru, migrasi skema database, mengubah kontrak public API, atau blast radius > 3 modul.
   - Opsi terpilih dikunci sebagai ADR di `DECISIONS.md`.
4. **Sliding Packet PLAN.md**: Breakdown tugas maksimal 10 item aktif dalam batch kerja terisolasi.
5. **Two-Tier Verification Gate**:
   - **Tier 1 (Syntax & Tests)**: Exit code 0 pada compiler, linter, dan test runner.
   - **Tier 2 (Production Reality Audit)**: Format API, desimal/precision compliance, anti-deadlock timeout, settled-state validation.

---

## 4. Hard Stop Invariant (Non-Negotiable)

AI Agent **WAJIB BERHENTI TOTAL** dan meminta konfirmasi manusia hanya pada:
1. **Circuit Breaker Meledak**: Gagal self-healing setelah 3 iterasi compiler/test berturut-turut.
2. **Area Kritis / Sensitif**: Modifikasi auth, logic pembayaran, drop/truncate skema database, dan file rahasia/private key (`.env`, credentials).
3. **Remote Git Push**: `git push` dilarang tanpa perintah eksplisit dari developer.

---

## 5. Pergeseran Peran: Human as Tech Lead & PR Reviewer

- Developer tidak lagi menghabiskan waktu membaca draf rencana teks 10 langkah yang spekulatif.
- AI bekerja di dalam Git feature branch (`feature/xxx`) yang terisolasi.
- Developer mereview perubahan melalui **Git Diff** nyata dan log eksekusi machine runner.
- Jika hasil tidak sesuai, dev memberikan koreksi konkret atau rollback instan (`git reset --hard`).
