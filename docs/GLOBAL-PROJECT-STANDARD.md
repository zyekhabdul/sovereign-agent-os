# Standar Global Proyek — File Wajib & Mekanisme Enforcement

Dokumen ini berlaku MUTLAK untuk seluruh proyek (baru maupun lama) yang dikerjakan AI Agent (AGY, Claude Code, Cursor, OpenCode) di sistem ini. Simpan di `09-Panduan-Projek/GLOBAL-PROJECT-STANDARD.md`.

---

## 1. Perbaikan Penamaan File (Naming Consistency)

Semua referensi path antar file WAJIB menggunakan nama file **persis sama** dengan nama file aslinya — huruf besar/kecil dan tanda hubung termasuk. Referensi yang tidak persis sama menyebabkan AI agent (khususnya yang fetch file via MCP/RAG) **gagal menemukan file**, lalu melanjutkan kerja tanpa membaca aturan — bukan "lupa", tapi gagal load sejak awal.

**Nama baku file panduan global** (gunakan persis ini di semua referensi):

| Nama File Baku | Lokasi |
|---|---|
| `PRD-MASTER-TEMPLATE.md` | `09-Panduan-Projek/` |
| `WORKFLOW-AI-AGENT-STANDARD.md` | `09-Panduan-Projek/` |
| `GLOBAL-PROJECT-STANDARD.md` | `09-Panduan-Projek/` (file ini) |

Sebelum menulis referensi path di `PLAN.md`, `AGENTS.md`, atau `GEMINI.md` manapun, **cocokkan dulu ke tabel ini** — jangan menulis dari ingatan/asumsi nama file.

---

## 2. Daftar File Standar per Repositori Lokal (Klasifikasi Wajib vs Kondisional)

Untuk mencegah pemaksaan file yang tidak relevan ("ngide liar"), file repositori distandarkan dengan batas kebutuhan nyata:

### A. File Wajib Universal (Semua Repositori)
| Nama File | Fungsi | Wajib Untuk |
|---|---|---|
| `README.md` | Entry point manusia: deskripsi proyek, cara install/run, tech stack ringkas | Semua proyek |
| `.env.example` | Template variabel lingkungan tanpa secret asli | Semua proyek yang menggunakan env |

### B. File Wajib Proyek Terstruktur / Feature Track (Saat Ada PRD & Eksekusi PLAN)
| Nama File | Fungsi | Wajib Untuk |
|---|---|---|
| `PRD.md` | Requirement level "what & why" dan batasan Non-Goals | Proyek berbasis fitur/SaaS/aplikasi |
| `PLAN.md` | Rencana kerja teknis bertahap dengan DoD terukur (fase eksekusi) | Proyek dengan PRD aktif |
| `GEMINI.md` | Identitas proyek & binding rules supreme lokal | Proyek yang dikerjakan AI agent |
| `CHANGELOG.md` | Riwayat rilis perubahan user-facing (format standar) | Proyek dengan rilis/milestone |

### C. File Kondisional & Opsional (Sesuai Kebutuhan Nyata)
| Nama File | Fungsi | Status |
|---|---|---|
| `DESIGN_SYSTEM.md` | Token warna, tipografi, komponen UI, rules styling | **Kondisional**: Wajib untuk Frontend/UI/Theme (N/A untuk Backend/CLI/Service) |
| `DEPLOYMENT.md` | Cara deploy, environment staging/production, rollback procedure | **Kondisional**: Wajib untuk proyek production/staging |
| `AGENTS.md` | Aturan alur kerja spesifik lokal di luar standar global | **Opsional**: Hanya jika repo butuh aturan agen khusus tingkat lokal |
| `DEVELOPMENT.md` | Catatan naratif kerja manusia & handoff manual developer | **Opsional**: Dev log manual developer manusia |
| `DEVELOPMENT-ARCHIVE.md` | Arsip task lama dari `DEVELOPMENT.md` | Proyek berjalan lama jika `DEVELOPMENT.md` melebihi batas |
| `CHANGELOG-ARCHIVE.md` | Arsip entri lama dari `CHANGELOG.md` | Proyek berjalan lama jika `CHANGELOG.md` melebihi batas |

---

## 3. Enforcement Mekanis (Git Pre-Commit Hook)

Kepatuhan terhadap file wajib dan sanitasi kode **tidak boleh 100% bergantung pada AI agent mengingat aturan**. Pasang git hook berikut supaya sistem yang memaksa, bukan cuma instruksi tertulis.

### 3.1 Cara Pasang

Gunakan script bawaan sovereign-agent-os di `templates/git-hooks/pre-commit` atau simpan script di bawah sebagai `.git/hooks/pre-commit` di tiap repo, lalu jalankan `chmod +x .git/hooks/pre-commit`.

```bash
#!/usr/bin/env bash
# PRE-COMMIT HARNESS: Deterministic Anti-Blunder Sanitizer
set -euo pipefail

# 1. Block Lazy Truncation Placeholders (Membunuh: // ... existing code ...)
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    if git diff --cached -- . ':!*.md' ':!*pre-commit*' ':!*agy-guard*' | grep -E '^\+[^+]' | grep -Eiq '(existing code|remaining unchanged|TODO: implement|rest of (the|your) code)'; then
        echo "[ HARDBLOCK ] Terdeteksi placeholder kode malas/terpotong di staged diff source code!" >&2
        echo "Contoh terlarang: '// ... existing code ...', 'TODO: implement'" >&2
        exit 1
    fi
fi

# 2. Block Emojis in staged files (Membunuh: Polusi Emoji di Codebase)
if git diff --cached | grep -E '^\+[^+]' | grep -P "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]" 2>/dev/null; then
    echo "[ HARDBLOCK ] Terdeteksi karakter emoji dalam staged files." >&2
    echo "Gunakan ikon SVG/Lucide atau token teks sesuai aturan strict no-emoji." >&2
    exit 1
fi

# 3. Block Test Tampering (Membunuh: Mengubah tes eksisting saat mengerjakan fitur)
if [ "${ALLOW_TEST_MUTATION:-0}" != "1" ]; then
    MODIFIED_TESTS=$(git diff --cached --diff-filter=M --name-only | grep -E '^tests/|^spec/|.*\.test\..*|.*\.spec\..*' || true)
    STAGED_SRC=$(git diff --cached --name-only | grep -vE '^tests/|^spec/|.*\.test\..*|.*\.spec\..*' || true)
    if [ -n "$MODIFIED_TESTS" ] && [ -n "$STAGED_SRC" ]; then
        echo "[ HARDBLOCK ] Memodifikasi file tes eksisting bersamaan dengan source code dilarang." >&2
        echo "Penambahan file tes baru diizinkan. Untuk memodifikasi tes eksisting, jalankan: ALLOW_TEST_MUTATION=1 git commit" >&2
        exit 1
    fi
fi

# 4. Block Secret & Private Key Leaks
STAGED_SECRETS=$(git diff --cached --name-only | grep -E '(^|/)\.env$|\.pem$|\.key$|id_rsa' || true)
if [ -n "$STAGED_SECRETS" ]; then
    if [ "${ALLOW_SECRET_COMMIT:-0}" != "1" ]; then
        echo "[ HARDBLOCK ] File rahasia/kredensial terdeteksi di staged files: $STAGED_SECRETS" >&2
        echo "Gunakan .env.example atau password manager." >&2
        exit 1
    fi
fi

# 5. Check Required Files on projects in execution phase (PLAN.md present)
if [ -f "PLAN.md" ]; then
    REQUIRED_FILES=("PRD.md" "PLAN.md" "GEMINI.md" "CHANGELOG.md" "README.md")
    for f in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "$f" ]; then
            echo "[ HARDBLOCK ] File standar proyek wajib ada saat fase eksekusi: $f" >&2
            exit 1
        fi
    done
fi

echo "[ PASS ] Pre-commit deterministic checks verified (exit 0)."
exit 0
```

### 3.2 Yang Diverifikasi Hook Ini
- **Anti-Lazy Code**: Mencegah commit placeholder pemalas (`// ... existing code ...`, `TODO: implement`). Berkas dokumentasi dan skrip guard dikecualikan dari false positive.
- **Strict No-Emoji**: Menolak karakter emoji pada baris yang ditambahkan.
- **Anti Test-Cheating (TDD-Friendly)**: Mencegah modifikasi tes *eksisting* bersamaan dengan perubahan fitur tanpa `ALLOW_TEST_MUTATION=1`. Penambahan file tes baru (`diff-filter=A`) sepenuhnya diizinkan untuk mendukung alur kerja TDD dan penambahan test coverage.
- **Secret Defense**: Menolak commit file `.env`, file `.pem`/`.key`, dan SSH private keys.
- **File Inti Fase Eksekusi**: Memastikan kelengkapan file standar (`PRD.md`, `PLAN.md`, `GEMINI.md`, `CHANGELOG.md`, `README.md`) saat proyek masuk ke fase eksekusi (`PLAN.md` dibuat). Tahap drafting `PRD.md` awal tidak terblokir.
- **Non-Interactive & Autonomous Friendly**: Hook ini berjalan tanpa interupsi interaktif (`read < /dev/tty`), sehingga aman dieksekusi oleh agent secara otomatis. Update `CHANGELOG.md` dilakukan saat penuntasan paket kerja/milestone.

### 3.3 Yang TIDAK Bisa Dicek Hook Ini (tetap tanggung jawab AI/dev)
- Isi/kualitas konten tiap file (hook cuma cek file *ada*, bukan *benar*)
- Apakah `PLAN.md` sudah di-approve sebelum eksekusi
- Apakah chunk sudah lulus test sebelum commit — ini diverifikasi lewat Two-Tier Verification Gate di tahap eksekusi

---

## 4. Sinkronisasi Master Template ke Proyek Lama

Kalau `PRD-MASTER-TEMPLATE.md` atau `WORKFLOW-AI-AGENT-STANDARD.md` diupdate di masa depan, proyek lama **tidak otomatis ikut berubah**. Untuk mencegah drift:
- Tiap `PRD.md` per proyek wajib mencantumkan baris: `Mengacu pada PRD-MASTER-TEMPLATE.md versi: <tanggal/versi>`.
- Saat master template diupdate, cek proyek mana saja yang masih mengacu ke versi lama — bukan wajib langsung migrasi, tapi harus disadari, bukan diam-diam basi.

---

## 5. Ringkasan Checklist Setup Proyek Baru

- [ ] `README.md` dan `.env.example` dibuat
- [ ] File standar alur kerja dibuat saat memulai fase fitur terstruktur (`PRD.md`, `PLAN.md`, `GEMINI.md`, `CHANGELOG.md`)
- [ ] `DESIGN_SYSTEM.md` dibuat jika proyek memiliki tampilan UI/Frontend/Theme
- [ ] `DEPLOYMENT.md` dibuat jika proyek akan dideploy ke production
- [ ] `AGENTS.md` dan `DEVELOPMENT.md` dibuat secara opsional jika dibutuhkan oleh dev lokal
- [ ] Semua path referensi antar file dicocokkan ke tabel Bagian 1
- [ ] Git pre-commit hook Bagian 3 dipasang
- [ ] Namespace RAG (`INDEX.md`, `CONTEXT.md`, `STATE.md`, `DECISIONS.md`) dibuat di Obsidian Vault
- [ ] `PRD.md` mencantumkan versi master template yang diacu (Bagian 4)
