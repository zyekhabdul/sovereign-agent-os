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

## 2. Daftar File Wajib per Repositori Lokal (Update)

Selain 7 file yang sudah baku (`PRD.md`, `PLAN.md`, `AGENTS.md`, `GEMINI.md`, `DEVELOPMENT.md`, `DESIGN_SYSTEM.md`, `CHANGELOG.md`), tambahkan:

| Nama File | Fungsi | Wajib Untuk |
|---|---|---|
| `README.md` | Entry point manusia: cara install/run, tech stack ringkas, link ke PRD/AGENTS.md | Semua proyek |
| `.env.example` | Template environment variable tanpa secret asli | Semua proyek yang pakai env var |
| `DEPLOYMENT.md` | Cara deploy, environment staging/production, rollback procedure | Proyek yang sudah/akan production |
| `DEVELOPMENT-ARCHIVE.md` | Arsip task lama dari `DEVELOPMENT.md` (lihat AGENTS.md Bagian 6) | Proyek berjalan lama |
| `CHANGELOG-ARCHIVE.md` | Arsip entri lama dari `CHANGELOG.md` | Proyek berjalan lama |

Total file wajib per repo: **7 file inti + 2 file wajib (README.md, .env.example) + 1 kondisional (DEPLOYMENT.md untuk proyek production)**. File archive dibuat begitu file induknya melewati batas panjang (lihat AGENTS.md Bagian 6).

---

## 3. Enforcement Mekanis (Git Pre-Commit Hook)

Kepatuhan terhadap file wajib **tidak boleh 100% bergantung pada AI agent mengingat aturan**. Pasang git hook berikut supaya sistem yang memaksa, bukan cuma instruksi tertulis.

### 3.1 Cara Pasang

Simpan script di bawah sebagai `.git/hooks/pre-commit` di tiap repo (atau di template repo baru), lalu jalankan `chmod +x .git/hooks/pre-commit`.

```bash
#!/bin/bash
# pre-commit hook — Standar Global Proyek
# Memverifikasi file wajib ada & CHANGELOG.md diupdate sebelum commit diterima

REQUIRED_FILES=("PRD.md" "PLAN.md" "AGENTS.md" "GEMINI.md" "DEVELOPMENT.md" "DESIGN_SYSTEM.md" "CHANGELOG.md" "README.md")
MISSING=()

for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    MISSING+=("$f")
  fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
  echo "❌ COMMIT DITOLAK — file wajib tidak ditemukan di root repo:"
  for f in "${MISSING[@]}"; do
    echo "   - $f"
  done
  echo "Lengkapi file di atas sesuai GLOBAL-PROJECT-STANDARD.md sebelum commit."
  exit 1
fi

# Cek apakah CHANGELOG.md ikut berubah di commit ini
# (skip pengecekan ini untuk commit pertama / initial commit)
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  CHANGED_FILES=$(git diff --cached --name-only)
  if ! echo "$CHANGED_FILES" | grep -q "CHANGELOG.md"; then
    echo "⚠️  PERINGATAN — commit ini tidak menyertakan update di CHANGELOG.md."
    echo "   Jika perubahan ini memang perlu dicatat, tambahkan entry sebelum commit."
    echo "   Ketik 'y' untuk lanjut tanpa update CHANGELOG, atau apa pun untuk batal:"
    read -r CONFIRM < /dev/tty
    if [ "$CONFIRM" != "y" ]; then
      echo "Commit dibatalkan."
      exit 1
    fi
  fi
fi

echo "✅ File wajib lengkap. Commit dilanjutkan."
exit 0
```

### 3.2 Yang Diverifikasi Hook Ini
- Semua file wajib ada di root repo — commit ditolak keras (`exit 1`) kalau tidak lengkap.
- `CHANGELOG.md` ikut berubah di commit ini — kalau tidak, hook **memperingatkan** (bukan block otomatis, karena tidak semua commit butuh entry changelog) dan minta konfirmasi manual.

### 3.3 Yang TIDAK Bisa Dicek Hook Ini (tetap tanggung jawab AI/dev)
- Isi/kualitas konten tiap file (hook cuma cek file *ada*, bukan *benar*)
- Apakah `PLAN.md` sudah di-approve sebelum eksekusi
- Apakah chunk sudah lulus test sebelum commit — ini idealnya jadi hook terpisah (`pre-commit` tambahan yang jalankan test suite) jika project sudah punya test otomatis

---

## 4. Sinkronisasi Master Template ke Proyek Lama

Kalau `PRD-MASTER-TEMPLATE.md` atau `WORKFLOW-AI-AGENT-STANDARD.md` diupdate di masa depan, proyek lama **tidak otomatis ikut berubah**. Untuk mencegah drift:
- Tiap `PRD.md` per proyek wajib mencantumkan baris: `Mengacu pada PRD-MASTER-TEMPLATE.md versi: <tanggal/versi>`.
- Saat master template diupdate, cek proyek mana saja yang masih mengacu ke versi lama — bukan wajib langsung migrasi, tapi harus disadari, bukan diam-diam basi.

---

## 5. Ringkasan Checklist Setup Proyek Baru

- [ ] 7 file inti dibuat (`PRD.md`, `PLAN.md`, `AGENTS.md`, `GEMINI.md`, `DEVELOPMENT.md`, `DESIGN_SYSTEM.md`, `CHANGELOG.md`)
- [ ] `README.md` dan `.env.example` dibuat
- [ ] `DEPLOYMENT.md` dibuat jika proyek akan production
- [ ] Semua path referensi antar file dicocokkan ke tabel Bagian 1
- [ ] Git pre-commit hook Bagian 3 dipasang
- [ ] Namespace RAG (`INDEX.md`, `CONTEXT.md`, `STATE.md`, `DECISIONS.md`) dibuat di Obsidian Vault
- [ ] `PRD.md` mencantumkan versi master template yang diacu (Bagian 4)
