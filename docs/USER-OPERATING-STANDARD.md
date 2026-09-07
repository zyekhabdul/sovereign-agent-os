# PANDUAN STANDAR OPERASIONAL PENGGUNA (HUMAN OPERATING STANDARD)
> Standard Operating Procedure (SOP) Interaksi Deterministik Manusia & AI Agent

- **Otoritas**: Sovereign Agent OS Governance
- **Status**: MANDATORY OPERATING PROCEDURE
- **Target**: Seluruh pengembang (human) saat berinteraksi dengan AI Coding Agents (Antigravity CLI, Claude Code, OpenCode, Codex).
- **Prinsip Utama**: AI Agent adalah mesin eksekusi deterministik. Output yang presisi mensyaratkan input yang berbatas tegas (bounded input). Garbage in, hallucination out.

---

## 1. MENGAPA STANDAR PENGGUNA DIBUTUHKAN?

Kegagalan AI dalam coding (halusinasi, perombakan liar/unsolicited refactor, loop eror, degradasi konteks) mayoritas dipicu oleh pola interaksi pengguna yang tidak terstruktur:
1. Instruksi tidak memiliki kriteria sukses (Definition of Done) yang terukur.
2. Instruksi mencampuradukkan beberapa domain dalam satu tarikan napas.
3. Manusia memberikan persetujuan buta (*blind approval*) tanpa menginspeksi diff terminal.

Sistem tata kelola AI (15 binding rules, `agy-guard`, pre-commit hook) mengunci perilaku mesin. Standar ini mengunci disiplin manusia sebagai komandan sistem.

---

## 2. 5 HUKUM BAKU INTERAKSI PENGGUNA (THE 5 LAWS OF HUMAN PROMPTING)

### Hukum 1: Single-Intent Command Invariant (Satu Perintah, Satu Domain)
- **Aturan**: Satu prompt hanya boleh menangani satu unit kerja terisolasi.
- **Terlarang**: *"Tolong perbaiki bug login, sekalian rapikan CSS navbar dan tambahkan migration kolom baru di database."*
- **Benar**: 
  1. Prompt 1: *"Perbaiki bug login di `auth/login.go`."* -> Verifikasi -> Komit.
  2. Prompt 2: *"Rapikan CSS navbar di `components/Navbar.tsx`."* -> Verifikasi -> Komit.

### Hukum 2: Mandatory Definition of Done (DoD) & Boundary Pointer
- **Aturan**: Setiap perintah pengerjaan fitur atau perbaikan bug WAJIB menyertakan berkas target dan syarat lolos yang bisa diverifikasi mesin.
- **Terlarang**: *"Bikin fungsi parser CSV yang bagus dan cepat."* (Kata "bagus" dan "cepat" mengundang overengineering dan penambahan dependensi liar).
- **Benar**: *"Implementasikan parser CSV di `internal/parser/csv.go`. Syarat DoD: streaming reader, memori < 10MB untuk file 50MB, unit test di `internal/parser/csv_test.go` lolos dengan exit code 0."*

### Hukum 3: Context Anchor Invariant (Jangkar Konteks Riil)
- **Aturan**: Wajib menyebutkan path berkas, nama fungsi, atau error trace spesifik. Jangan menggunakan rujukan abstrak.
- **Terlarang**: *"Benerin error yang tadi muncul."* atau *"Coba refactor bagian yang lemot."*
- **Benar**: *"Periksa kegagalan fungsi `TokenValidator` di `src/middleware/auth.ts:45`. Error log: `TokenExpiredError: jwt expired`."*

### Hukum 4: Inspection Before Approval (Inspeksi Sebelum Melanjutkan)
- **Aturan**: Dilarang mengetik *"lanjut"*, *"oke"*, *"gas"* tanpa memvalidasi 3 indikator empiris:
  1. Apakah pengujian berhasil dengan kode keluar 0 (`exit code 0`)?
  2. Apakah berkas yang dimodifikasi sesuai scope (`git status --short`)?
  3. Apakah task checklist aktif di `STATE.md` tidak melebihi 10 item?
- Jika agen melaporkan hasil tanpa menyertakan bukti terminal: Pengguna wajib menolak dan meminta verifikasi empiris.

### Hukum 5: Explicit Mutation & Push Flagging (Protokol Izin Eksplisit)
- **Aturan**: Perubahan sensitif membutuhkan deklarasi niat eksplisit dari manusia:
  - **Ubah Berkas Tes**: Jika manusia sengaja ingin mengubah perilaku spesifikasi tes bersamaan dengan kode sumber, manusia harus menginstruksikan atau mengizinkan penggunaan flag:
    `ALLOW_TEST_MUTATION=1 git commit`
  - **Git Push ke Remote**: Agen dilarang keras melakukan push secara otomatis. Manusia wajib memberikan perintah spesifik kata demi kata: *"push"* atau mengeksekusi `agy-guard push`.

---

## 3. ANATOMI PROMPT STANDAR (CANONICAL PROMPT TEMPLATE)

Gunakan struktur berikut untuk instruksi yang melibatkan modifikasi kode:

```text
[KONTEKS & TARGET]:
- Berkas: <path/ke/berkas>
- Referensi Masalah: <issue / log error / baris kode>

[TUGAS]:
<Deskripsi tugas konkret dalam 1-2 kalimat ringkas>

[BATASAN TEKNIS (INVARIANTS)]:
- Patuhi aturan Ponytail / YAGNI (tanpa library baru tanpa izin).
- Jangan ubah kontrak API publik / signature fungsi eksisting.
- Batas panjang berkas <= 200 baris.

[DEFINITION OF DONE (DOD)]:
- Command verifikasi: `<perintah_test_atau_build>` harus exit code 0.
- `git diff` hanya menyentuh berkas target.
```

---

## 4. PROTOKOL PENANGANAN KEBUNTUAN (CIRCUIT BREAKER & CONTEXT ROT)

### 1. Ketika Circuit Breaker Meledak (Exit Code 126)
- Jika mesin melaporkan `[ CIRCUIT BREAKER TRIPPED ]` dan melakukan rollback `git restore .`:
- **Tindakan Manusia**:
  1. JANGAN mengulangi prompt yang sama persis.
  2. Baca raw error yang dilaporkan sebelum rollback.
  3. Berikan arahan arsitektur baru atau pecah task menjadi sub-tugas yang jauh lebih kecil.
  4. Periksa `STATE.md` yang telah ditandai `BLOCKED` untuk melihat diagnosis.

### 2. Mengatasi Pembengkakan Konteks (Context Rot)
- Jika sesi percakapan telah melebihi 35 putaran (turns) atau AI mulai lambat dan mengulang kesalahan:
- **Tindakan Manusia**:
  1. Perintahkan checkpoint akhir: `agy-guard checkpoint -m "Checkpoint sebelum restart sesi" -s ACTIVE`.
  2. Buka sesi baru (fresh terminal session).
  3. Mulai sesi baru dengan instruksi ringkas: *"Baca STATE.md dan lanjutkan task aktif berikutnya."* Agen akan instan sinkron tanpa membawa sampah memori lama.

---

## 5. TABEL KELAIKAN INTERAKSI (CHECKLIST EVALUASI DIRI PENGGUNA)

| Situasi | Tindakan Pengguna yang Salah | Tindakan Pengguna yang Benar |
| :--- | :--- | :--- |
| Memulai fitur besar | Langsung menyuruh nulis kode | Minta outline roadmap & rincian packet aktif (max 10 chunks) |
| Menemukan bug | Mengirim screenshot tanpa teks | Menyalin error log mentah, stack trace, dan CWD |
| Mengganti requirement di tengah jalan | Menimpa instruksi sebelumnya di chat panjang | Reset task aktif di `STATE.md`, batalkan staged diff, mulai fresh chunk |
| Menginginkan kode ringkas | Mengatakan "buat yang simpel" | Menentukan batasan baris kode dan melarang dependensi eksternal |
