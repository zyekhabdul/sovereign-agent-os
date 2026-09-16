# Standar Workflow: Dari Ide/Kebutuhan ke PRD hingga Eksekusi dengan AI Agent

Panduan alur kerja standar yang WAJIB dipatuhi oleh seluruh AI coding agent (AGY / Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode, dll) dalam berkolaborasi dari perencanaan sampai eksekusi kode.

---

## Ringkasan Alur Standar

```
[HULU: Discovery & Definition]
Ide Mentah / Kebutuhan Bisnis
  → Triage & Klasifikasi Kompleksitas (T1 Ringan / T2 Menengah / T3 Kompleks)
  → Clarify & Problem Boundaries (Falsifiable problem, Non-Goals, Scope Wedge)
  → Mini-Research / Feasibility Spike (Opsional untuk T1, Wajib untuk T2/T3)
  → PRD.md (Spesifikasi "What & Why" — Track A Lite atau Track B Full Enterprise)

[HILIR: Deterministic Execution]
  → PLAN.md (Hyper-granular chunks, dibuat agent, pola Sliding Packet max 10 chunks aktif)
  → Upfront Approval (Dev review & approve sekali di awal)
  → Autonomous Batch Execution (Silent machine verification & commit per chunk)
  → STOP TOTAL jika ada satu chunk gagal verifikasi / menyentuh area sensitif
  → Strategic Checkpoints (Re-acknowledge aturan)
  → Human Review Checkpoint (Sebelum merge/deploy)
```

Pola ini menggantikan "approve tiap chunk satu-satu" — dipakai untuk eksekusi cepat chunk kecil dan berisiko rendah, dengan syarat pengaman (Hard Stop & Checkpoint) dijalankan ketat.

---

## 1. Structure & File Role

| File / Artefak | Fungsi | Dibuat oleh |
|---|---|---|
| `questions.md` / Brief | Klarifikasi batas masalah, asumsi, dan Non-Goals (fase pra-PRD) | Dev / AI Agent |
| `PRD.md` | Requirement level "what & why" (falsifiable spec, personas, metrics, non-goals) | Dev / PM / AI Agent |
| `PLAN.md` | Breakdown teknis & task list, level "how" (hyper-granular chunks) | AI Agent, direview dev |
| `AGENTS.md` | Aturan permanen alur kerja lokal | Dev, sekali dibuat per repo |
| `GEMINI.md` | Identitas proyek & binding rules supreme | Dev / System |
| `/src` (atau source code) | Kode aktual | AI Agent, hanya setelah plan di-approve |

> **Catatan PRD Master**: Semua proyek baru atau existing yang belum memiliki PRD WAJIB dibuatkan PRD terlebih dahulu mengacu pada template `09-Panduan-Projek/PRD-MASTER-TEMPLATE.md` (Dual-Track: Track A Lite untuk task/fitur kecil, Track B Full Enterprise untuk sistem/SaaS).

---

## 2. Tahapan Kerja Wajib

### Tahap 0 — Dari Ide/Kebutuhan ke PRD (Pre-PRD Discovery & Clarification Gate)
Ketika menerima ide mentah, problem statement, atau permintaan fitur baru:
1. **Triage Kompleksitas Ide**:
   - **T1 (Ringan/Utilitas/Surgical Fix)**: Perbaikan bug spesifik, skrip utilitas mandiri, atau penambahan komponen UI tunggal. Langsung gunakan *Track A (Lite PRD)* tanpa riset panjang.
   - **T2 (Menengah/Fitur Baru/SaaS MVP)**: Integrasi modul baru, perombakan alur data, atau fitur multi-halaman. Wajib melalui tahap klarifikasi tertulis dan riset kompetitor/API.
   - **T3 (Kompleks/Arsitektur/Regulated)**: Platform multi-tenant, e-commerce enterprise, sistem finansial/kripto, atau migrasi backend. Wajib riset mendalam, audit keamanan, dan *Track B (Full Enterprise PRD)*.
2. **Klarifikasi Batasan & Non-Goals**:
   - Ajukan pertanyaan tajam yang menentukan arah arsitektur (Who, Pain Point, Constraints).
   - Kunci **Non-Goals** (apa yang secara sadar TIDAK akan dibangun pada iterasi ini) untuk mematikan scope creep sejak hulu.
3. **Anti-Hallucination Entry Gate (Pre-PRD Invariant)**:
   - AI Agent DILARANG merumuskan `PRD.md` jika problem statement masih abstrak (*unfalsifiable*) atau batas *Non-Goals* belum disepakati bersama manusia.

### Tahap 1 — Baca PRD, Buat Hyper-Granular `PLAN.md` (Pola Sliding Packet)
Ketika diberi `PRD.md` atau requirement baru:
- Baca dan pahami seluruh isi PRD.
- Tulis rencana teknis ke `PLAN.md`: breakdown task kecil, file target & lokasi eksplisit, urutan dependency, dan Definition of Done (DoD) per chunk.
- **Pola Sliding Packet (Maksimal 10 Chunks Detail Aktif)**: Jika sebuah fase memiliki banyak chunk (misal 20–30), kelompokkan ke dalam paket-paket kerja (Paket 1: Chunks 1-10, Paket 2: Chunks 11-20, dst.). `PLAN.md` memuat roadmap outline seluruh paket, namun **hanya meng-expand detail spesifikasi DoD untuk maksimal 10 chunks pada paket yang sedang aktif**. Paket berikutnya di-expand setelah paket aktif tuntas.
- **JANGAN menulis atau mengubah kode apa pun di tahap ini.**
- Berhenti dan tunggu review dari dev.

### Tahap 2 — Upfront Approval (Sekali di Awal)
- Dev review `PLAN.md` secara keseluruhan.
- Setelah dev beri approval *"plan oke, eksekusi semua"*, agent jalan sendiri mengeksekusi seluruh chunk **tanpa minta approve ulang tiap chunk**.
- Syarat: Chunk sudah **hyper-granular** (kecil, scope sempit, DoD terukur).

### Tahap 3 — Autonomous Batch Execution (Silent Verification)
- Kerjakan chunk **berturut-turut** sesuai `PLAN.md`.
- Tiap chunk selesai, jalankan test/lint/build **secara otomatis dan diam-diam** (silent verification).
- **Commit per chunk** (`git commit`), pesan commit jelas menyebut chunk/task mana.

### Tahap 3B — Aturan Berhenti Wajib (Hard Stop - Non-Negotiable)
Agent **WAJIB STOP TOTAL** (tidak lanjut ke chunk berikutnya) jika:
1. Test, lint, atau build **gagal** di chunk mana pun.
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

1. `GEMINI.md` — Identitas proyek & binding rules (paling otoritatif)
2. `AGENTS.md` — Aturan alur kerja lokal
3. `PLAN.md` — Breakdown teknis yang sudah di-approve
4. `DEVELOPMENT.md` — Status & keputusan aktif
5. `PRD.md` — Requirement dasar ("what & why")

---

## 4. Batasan Panjang File (Anti Context-Bloat)

- `DEVELOPMENT.md` hanya berisi task **aktif**. Task lama dipindah ke `DEVELOPMENT-ARCHIVE.md`.
- `CHANGELOG.md` hanya menyimpan entri **beberapa sesi terakhir**. Entri lama dipindah ke `CHANGELOG-ARCHIVE.md`.
- File RAG `CONTEXT.md` maksimal **200 baris**.
- **Single-Plan Invariant**: Di root repo hanya ada **satu** file `PLAN.md`. Dilarang membuat file pecahan (`PLAN-old.md`, `PLAN-part2.md`, `task-detail.md`). Setelah satu paket kerja selesai, bagian detail ditimpa (overwrite) untuk paket berikutnya.
- **RAG State Cap**: Checklist task aktif di `STATE.md` RAG dibatasi **maksimal 10 item** level milestone/paket, bukan dump puluhan mikro-DoD.

---

## 5. Safety & Git Control

1. **Git Commit**: Boleh dieksekusi di lokal per chunk untuk simpan checkpoint.
2. **Git Push**: **DILARANG KERAS** me-push kode ke remote tanpa perintah eksplisit "push" dari user.
3. **Restricted Files**: DILARANG mengubah `.env`, secrets, prod DB schema, CI/CD tanpa izin eksplisit.
