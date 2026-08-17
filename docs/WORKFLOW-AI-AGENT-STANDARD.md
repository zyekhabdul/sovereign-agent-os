# Standar Workflow: Dari PRD ke Eksekusi dengan AI Agent

Panduan alur kerja standar yang WAJIB dipatuhi oleh seluruh AI coding agent (AGY / Antigravity CLI, Antigravity IDE, Claude Code, Cursor, Codex, OpenCode, dll) dalam berkolaborasi dari perencanaan sampai eksekusi kode.

---

## Ringkasan Alur Standar

```
PRD.md → PLAN.md (hyper-granular chunks, dibuat agent) → Upfront Approval (sekali di awal)
        → Autonomous Batch Execution (silent verification & commit per chunk)
        → STOP TOTAL jika ada satu chunk gagal verifikasi / menyentuh area sensitif
        → Strategic Checkpoints (re-acknowledge aturan)
        → Human Review Checkpoint sebelum merge/deploy
```

Pola ini menggantikan "approve tiap chunk satu-satu" — dipakai untuk eksekusi cepat chunk kecil dan berisiko rendah, dengan syarat pengaman (Hard Stop & Checkpoint) dijalankan ketat.

---

## 1. Structure & File Role

| File | Fungsi | Dibuat oleh |
|---|---|---|
| `PRD.md` | Requirement level "what & why" | Dev/PM |
| `PLAN.md` | Breakdown teknis & task list, level "how" (hyper-granular chunks) | AI Agent, direview dev |
| `AGENTS.md` | Aturan permanen alur kerja lokal | Dev, sekali dibuat per repo |
| `GEMINI.md` | Identitas proyek & binding rules supreme | Dev / System |
| `/src` (atau source code) | Kode aktual | AI Agent, hanya setelah plan di-approve |

> **Catatan PRD Master**: Semua proyek baru atau existing yang belum memiliki PRD WAJIB dibuatkan PRD terlebih dahulu mengacu pada template `09-Panduan-Projek/PRD-MASTER-TEMPLATE.md`.

---

## 2. Tahapan Kerja Wajib

### Tahap 1 — Baca PRD, Buat Hyper-Granular `PLAN.md`
Ketika diberi `PRD.md` atau requirement baru:
- Baca dan pahami seluruh isi PRD.
- Tulis rencana teknis ke `PLAN.md`: breakdown task kecil, file target & lokasi eksplisit, urutan dependency, dan Definition of Done (DoD) per chunk.
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

---

## 5. Safety & Git Control

1. **Git Commit**: Boleh dieksekusi di lokal per chunk untuk simpan checkpoint.
2. **Git Push**: **DILARANG KERAS** me-push kode ke remote tanpa perintah eksplisit "push" dari user.
3. **Restricted Files**: DILARANG mengubah `.env`, secrets, prod DB schema, CI/CD tanpa izin eksplisit.
