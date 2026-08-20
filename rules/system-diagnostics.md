# MANDATORY GLOBAL RULE: CONTINUOUS EMPIRICAL DIAGNOSTICS & SYSTEM DOCTOR SYNCHRONIZATION

- **Principle**: "Zero Speculation, Zero Hallucination, Continuous Empirical Verification"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).
- **Core Diagnostic Suite**: `/home/fuckadmin/Projects/zyekh-ai-core/scripts/zyekh_doctor.py`

---

## 1. MANDATORY DIAGNOSTIC TOOL SYNCHRONIZATION ON CODE MUTATION
Setiap kali terjadi modifikasi kode, penambahan endpoint, perubahan skema database/katalog stok, pembaruan template tema/widget, perubahan konfigurasi Nginx/Cloudflare, atau migrasi arsitektur pada ekosistem proyek:

1. **Sinkronisasi Test & Probing Logic**: AI Agent **WAJIB** memperbarui atau menambahkan skenario pengujian baru ke dalam test suite diagnostik empiris (`scripts/zyekh_doctor.py` atau `scripts/audit_system_integrity.py`).
2. **Larangan Asumsi Tanpa Eksekusi Tool**: AI Agent DILARANG KERAS mengklaim bahwa sebuah fitur atau sistem "berjalan normal" tanpa menjalankan diagnostic doctor/test suite secara langsung di terminal.
3. **Penyimpanan Telemetri Otomatis**: Setiap eksekusi diagnostik wajib menghasilkan log artefak JSON empiris (`telemetry_latest.json`) sebagai bukti verifikasi tanpa halusinasi.

---

## 2. 7-LAYER EMPIRICAL QUALITY GATES
Setiap checkpoint tugas besar atau sesi rilis WAJIB lulus 7 layer diagnostik:
- **Layer 1**: OS, Resource (RAM/Disk/Load) & Kernel Listening Sockets (`ss -tulpn`).
- **Layer 2**: Systemd Daemons & Background Process Health (`systemctl is-active`).
- **Layer 3**: Defensive Security & File Permissions (`0600` least-privilege mode).
- **Layer 4**: Omnichannel Bot Sessions (WhatsApp Baileys auth keys & Telegram `getMe`).
- **Layer 5**: E-Commerce & CMS Theme Asset Integrity (Shopify Admin API asset checks).
- **Layer 6**: Edge Network, Public HTTPS & Header Policies (Cloudflare CSP `connect-src`).
- **Layer 7**: Live End-to-End Inference Probing & Latency Benchmarks (Multi-persona responses).

---

## 3. CHECKPOINT CRITERIA
Sebelum sesi berakhir atau commit/push dilakukan:
- Jalankan `python3 /home/fuckadmin/Projects/zyekh-ai-core/scripts/zyekh_doctor.py`
- Pastikan: `Failed checks: 0` dan `100% Empirically Operational`.
