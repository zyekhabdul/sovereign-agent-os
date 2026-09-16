# Standar Workflow: Dari Ide/Kebutuhan ke PRD hingga Eksekusi dengan AI Agent

Panduan alur kerja standar yang WAJIB dipatuhi oleh seluruh AI coding agent (AGY / Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode, dll) dalam berkolaborasi dari perencanaan sampai eksekusi kode.

---

## Ringkasan Alur Standar

```
[HULU: Discovery & Definition]
Ide Mentah / Kebutuhan Bisnis
  → Triage & Klasifikasi Kompleksitas (T1 Ringan / T2 Menengah / T3 Kompleks)
  → Pre-Flight ADR Scan (Baca 10 ADR terakhir di DECISIONS.md)
  → Clarify & Problem Boundaries (Falsifiable problem, Non-Goals, Scope Wedge)
  → PRD.md (Spesifikasi "What & Why" — Track A Lite atau Track B Full Enterprise)

[ARSITEKTUR: Threshold Gate]
  → Apakah butuh modifikasi arsitektur besar / DB schema / dependensi baru / >3 modul?
       ├─ YA  → RFC (Eksplorasi Opsi Teknis) → Review → ADR (Kunci di DECISIONS.md)
       └─ TDK → Bypass Langsung ke Perencanaan

[HILIR: Deterministic Execution]
  → PLAN.md (Traceability ID ke PRD-REQ, Sliding Packet max 10 chunks aktif)
  → Upfront Approval (Dev review & approve sekali di awal)
  → Autonomous Batch Execution (Surgical diff, YAGNI minimalism)
  → Two-Tier QA Gate (Tier 1: Syntax/Tests Exit 0, Tier 2: Real-world Reality Audit)
  → Atomic Local Checkpoint (Git commit + RAG Sync 50ms, Push remote ditahan)
```

Pola ini memisahkan secara tegas antara eksplorasi arsitektur, penguncian keputusan, dan eksekusi deterministik tanpa birokrasi berlebih.

---

## 1. Structure & File Role

| File / Artefak | Fungsi & Lokasi | Dibuat oleh |
|---|---|---|
| `questions.md` / Brief | Klarifikasi batas masalah, asumsi, dan Non-Goals (fase pra-PRD) | Dev / AI Agent |
| `PRD.md` | Requirement level "what & why" (falsifiable spec, personas, metrics, non-goals) di root repo | Dev / PM / AI Agent |
| `RFC` (Opsional) | Eksplorasi opsi teknis, trade-offs, dan mitigasi risiko arsitektur | AI Agent / Architect |
| `DECISIONS.md` (ADR) | Catatan keputusan arsitektur permanen di Obsidian RAG (`00-AGY-Memory/<namespace>/DECISIONS.md`) | Dev / AI Agent (Append-only) |
| `PLAN.md` | Breakdown teknis level "how" dengan Traceability ID ke PRD (max 10 chunks aktif) di root repo | AI Agent, direview dev |
| `AGENTS.md` | Aturan permanen alur kerja lokal di root repo | Dev, sekali dibuat per repo |
| `GEMINI.md` | Identitas proyek & binding rules supreme di root repo | Dev / System |
| `STATE.md` | **AI Machine Memory SSOT** (fase aktif, checkpoint, status milestone, max 10 task aktif) di Obsidian RAG | AI Agent (Ditimpa per sesi) |
| `DEVELOPMENT.md` | **Human Narrative Log** (catatan kerja dev, log naratif manual, handoff antar manusia) di root repo | Manusia / AI Agent |
| `/src` (source code) | Kode aktual hasil mutasi bedah | AI Agent, hanya setelah plan di-approve |

> **Catatan PRD Master**: Semua proyek baru atau existing yang belum memiliki PRD WAJIB dibuatkan PRD terlebih dahulu mengacu pada template `09-Panduan-Projek/PRD-MASTER-TEMPLATE.md` (Dual-Track: Track A Lite untuk task/fitur kecil, Track B Full Enterprise untuk sistem/SaaS).

---

## 2. Tahapan Kerja Wajib

### Tahap 0 — Dari Ide/Kebutuhan ke PRD (Pre-PRD Discovery & Clarification Gate)
Ketika menerima ide mentah, problem statement, atau permintaan fitur baru:
1. **Triage Kompleksitas Ide**:
   - **T1 (Ringan/Utilitas/Surgical Fix)**: Perbaikan bug spesifik, skrip utilitas mandiri, atau penambahan komponen UI tunggal. Langsung gunakan *Track A (Lite PRD)* tanpa riset panjang.
   - **T2 (Menengah/Fitur Baru/SaaS MVP)**: Integrasi modul baru, perombakan alur data, atau fitur multi-halaman. Wajib melalui tahap klarifikasi tertulis dan riset kompetitor/API.
   - **T3 (Kompleks/Arsitektur/Regulated)**: Platform multi-tenant, e-commerce enterprise, sistem finansial/kripto, atau migrasi backend. Wajib riset mendalam, audit keamanan, dan *Track B (Full Enterprise PRD)*.
2. **Pre-Flight ADR Invariant Scan**:
   - AI Agent WAJIB membaca 10 entri terakhir dari `DECISIONS.md` yang tersimpan di namespace Obsidian RAG (`00-AGY-Memory/<project-namespace>/DECISIONS.md`) untuk memastikan solusi tidak melanggar hukum arsitektur yang sudah disepakati sebelumnya atau mengusulkan ulang ide yang pernah ditolak.
3. **Klarifikasi Batasan & Non-Goals**:
   - Ajukan pertanyaan tajam yang menentukan arah arsitektur (Who, Pain Point, Constraints).
   - Kunci **Non-Goals** (apa yang secara sadar TIDAK akan dibangun pada iterasi ini) untuk mematikan scope creep sejak hulu.
4. **Anti-Hallucination Entry Gate (Pre-PRD Invariant)**:
   - AI Agent DILARANG merumuskan `PRD.md` jika problem statement masih abstrak (*unfalsifiable*) atau batas *Non-Goals* belum disepakati bersama manusia.

### Tahap 1 — RFC & ADR Threshold Gate (Arsitektur vs Bypass)
Tidak semua tugas membutuhkan RFC. AI Agent mengevaluasi ambang batas secara deterministik:
1. **Kondisi Wajib RFC & ADR (Pemicu Keputusan Arsitektur)**:
   - Menambah dependensi / package pihak ketiga baru.
   - Mengubah skema database (migration / perombakan tabel).
   - Mengubah kontrak public API yang dikonsumsi oleh service atau client lain.
   - Blast radius mutasi menyentuh > 3 modul independen sekaligus.
   *Jika memenuhi kondisi di atas: Tulis dokumen RFC (pilihan opsi teknis & mitigasi risiko), diskusikan, lalu kunci opsi terpilih sebagai ADR di `00-AGY-Memory/<project-namespace>/DECISIONS.md`.*
2. **Bypass RFC/ADR (Jalur Cepat)**:
   - Jika perubahan tidak menyentuh 4 kondisi di atas (misal refactoring lokal, bugfix, styling, penambahan endpoint rutin), **Bypass RFC/ADR langsung ke Tahap 2**.

### Tahap 2 — Buat Hyper-Granular `PLAN.md` (Traceability Link & Sliding Packet)
Ketika menyusun rencana eksekusi:
- **Mandatory Traceability Invariant**:
  - **Feature Track (Proyek dengan PRD)**: Setiap task chunk di `PLAN.md` WAJIB menyertakan ID kriteria penerimaan dari PRD (misal `[Chunk 1] -> [PRD-REQ-01]`).
  - **Maintenance / Bugfix Track (Perbaikan Bug, Refactor, Task Non-PRD)**: Task chunk ditautkan ke kriteria prompt pengguna atau ID issue (misal `[Chunk 1] -> [BUG-FIX-01]`, `[CHORE-01]`, `[REFACTOR-01]`). Dilarang membuat file `PRD.md` baru tanpa diminta untuk perbaikan bug rutin.
  - Chunk di luar lingkup tugas yang disepakati otomatis DITOLAK sebagai scope creep/ngide liar.
- **Pola Sliding Packet (Maksimal 10 Chunks Detail Aktif)**: Jika fase memiliki banyak chunk (misal 20–30), kelompokkan ke dalam paket kerja. `PLAN.md` memuat roadmap outline seluruh paket, namun **hanya meng-expand detail spesifikasi DoD untuk maksimal 10 chunks pada paket yang sedang aktif**. Paket berikutnya di-expand setelah paket aktif tuntas.
- **JANGAN menulis atau mengubah kode apa pun di tahap ini.**
- Berhenti dan tunggu review dari dev.

### Tahap 3 — Upfront Approval (Sekali di Awal)
- Dev review `PLAN.md` secara keseluruhan.
- Setelah dev beri approval *"plan oke, eksekusi semua"*, agent jalan sendiri mengeksekusi seluruh chunk **tanpa minta approve ulang tiap chunk**.
- Syarat: Chunk sudah **hyper-granular** (kecil, scope sempit, DoD terukur).

### Tahap 4 — Autonomous Batch Execution & Two-Tier QA Gate
- Kerjakan chunk **berturut-turut** sesuai `PLAN.md` menggunakan mutasi bedah (`replace_file_content`).
- Setiap chunk wajib lulus **Two-Tier Verification Gate**:
  1. **Tier 1 (Syntax & Unit Test)**: Linter, typecheck (`tsc --noEmit`), dan test suite lulus dengan `exit code 0` (`tests_executed > 0`, `failures == 0`).
  2. **Tier 2 (Production Reality Audit)**: Verifikasi kesesuaian parameter desimal/filter API eksternal, anti-deadlock timeout, dan integritas closed-state data.
- **Commit per chunk** (`git commit`), pesan commit jelas menyebut chunk/task mana.

### Tahap 4B — Aturan Berhenti Wajib (Hard Stop - Non-Negotiable)
Agent **WAJIB STOP TOTAL** (tidak lanjut ke chunk berikutnya) jika:
1. Test, lint, atau build **gagal** di chunk mana pun (Circuit Breaker: maksimal 3 kali self-healing).
2. Chunk berikutnya menyentuh area sensitif: auth, payment, database migration, `.env`/secrets, CI-CD/deployment config.
3. Chunk butuh keputusan/asumsi di luar yang tertulis di `PLAN.md`.
4. Perilaku (behavior) tidak sesuai ekspektasi PRD meskipun test lulus.

Saat stop, laporkan: chunk mana yang tertahan, penyebabnya, dan progress chunk sebelumnya yang sudah aman (committed & verified).

### Tahap 3C — Re-Acknowledge Aturan (Anti Context-Drift)
- **Awal Sesi**: Wajib re-read `AGENTS.md` dan `GEMINI.md` sebelum mulai kerja.
- **Strategic Checkpoint**: Tulis ringkas 3 aturan paling kritis dari `AGENTS.md`/`GEMINI.md` yang relevan untuk kelompok chunk berikutnya sebelum melanjutkan.

### Tahap 4 — Strategic Checkpoint
Laporkan progress ringkas dan re-acknowledge aturan pada titik berikut:
- Setelah kelompok chunk terkait selesai.
- Sebelum masuk kelompok chunk berikutnya yang bergantung pada kelompok sebelumnya.
- Sebelum menyentuh area sensitif.

### Tahap 5 — Human Review Checkpoint
- Wajib review manual dari dev sebelum merge ke branch utama atau deploy.
- Perubahan area sensitif (auth, payment, DB, secrets) **wajib** review manual.

---

## 3. Hierarki Prioritas Antar File (Resolusi Konflik)

Jika ada dua aturan bertentangan, ikuti urutan hierarki berikut (paling tinggi menang):

1. `GEMINI.md` / Master Rules — Identitas proyek & binding rules supreme (paling otoritatif)
2. `DECISIONS.md` (ADR) — Catatan hukum arsitektur permanen di Obsidian RAG (`00-AGY-Memory/<namespace>/DECISIONS.md`)
3. `PRD.md` — Kontrak spesifikasi requirement dasar & batasan Non-Goals
4. `AGENTS.md` — Aturan alur kerja lokal (jika ada)
5. `PLAN.md` — Breakdown teknis level "how" yang sudah di-approve dev
6. `STATE.md` (RAG) / `DEVELOPMENT.md` (Repo) — Status aktif pengerjaan & log naratif dev

---

## 4. Batasan Panjang File & Pemisahan Peran State (Anti Context-Bloat)

- **Pemisahan Peran `STATE.md` vs `DEVELOPMENT.md`**:
  - `STATE.md` (di Obsidian RAG `00-AGY-Memory/<namespace>/STATE.md`): Merupakan **Machine Memory SSOT khusus AI Agent**. Berisi status fase aktif, commit hash terakhir, dan checklist paket aktif (maksimal 10 item). Ditimpa (*in-place overwrite*) di akhir tiap sesi/milestone.
  - `DEVELOPMENT.md` (di Root Git Repo): Merupakan **Human Narrative Dev Log**. Berisi catatan kerja manusia, kronologi pengerjaan informal, catatan handoff, dan riwayat lokal developer. Hanya menyimpan task aktif saat ini; task yang sudah selesai dipindahkan ke `DEVELOPMENT-ARCHIVE.md`.
- `CHANGELOG.md` hanya menyimpan entri **beberapa sesi terakhir**. Entri lama dipindah ke `CHANGELOG-ARCHIVE.md`.
- File RAG `CONTEXT.md` maksimal **200 baris**.
- **Single-Plan Invariant**: Di root repo hanya ada **satu** file `PLAN.md`. Dilarang membuat file pecahan (`PLAN-old.md`, `PLAN-part2.md`, `task-detail.md`). Setelah satu paket kerja selesai, bagian detail ditimpa (overwrite) untuk paket berikutnya.
- **RAG State Cap**: Checklist task aktif di `STATE.md` RAG dibatasi **maksimal 10 item** level milestone/paket, bukan dump puluhan mikro-DoD.

---

## 5. Safety & Git Control

1. **Git Commit**: Boleh dieksekusi di lokal per chunk untuk simpan checkpoint.
2. **Git Push**: **DILARANG KERAS** me-push kode ke remote tanpa perintah eksplisit "push" dari user.
3. **Restricted Files**: DILARANG mengubah `.env`, secrets, prod DB schema, CI/CD tanpa izin eksplisit.
