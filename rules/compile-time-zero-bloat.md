---
trigger: always_on
description: Mandatory Compile-Time & Zero-Bloat Engineering Standards
---

# MANDATORY GLOBAL RULE: COMPILE-TIME & ZERO-BLOAT ENGINEERING STANDARDS

- **Principle**: "Compile-Time Heavy, Runtime Featherlight — Zero-Bloat by Default"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

Setiap kali menulis, mengedit, atau menyarankan kode di seluruh proyek, AI agent WAJIB mematuhi 4 pilar arsitektur berikut:

---

## 1. ZERO-BLOAT DEPENDENCY POLICY (WEB-STANDARD NATIVE FIRST)
- **Strict Native Priority**: DILARANG menginstal package/library eksternal baru (`npm install`, `deno add`, `bun add`, `pip install`) untuk fungsionalitas yang sudah dapat ditangani oleh Web-Standard API bawaan runtime:
  - Gunakan `fetch` native (Node 18+, Bun, Deno, Browser), dilarang `axios` atau `got`.
  - Gunakan `URL` dan `URLSearchParams` bawaan, dilarang library parsing query-string eksternal.
  - Gunakan `crypto.randomUUID()` dan Web Crypto API, dilarang `uuid`.
  - Gunakan `Intl` API (`Intl.DateTimeFormat`, `Intl.NumberFormat`), dilarang `moment` atau `dayjs` untuk pemformatan dasar.
  - Gunakan native Array/Object methods (`structuredClone`, `Array.prototype.flat`, `Object.fromEntries`), dilarang `lodash` atau `underscore`.
- **Minimalist External Selection**: Jika mutlak memerlukan library pihak ketiga:
  - Wajib memilih alternatif dengan bundle size terkecil dan dependensi transitif nol/minimal (contoh: gunakan framework `hono` dibanding `express`; gunakan `valibot` dibanding validator berat).
  - Evaluasi ukuran paket dan transitive dependencies sebelum mengusulkan penambahan package baru.
- **Dead Dependency Prohibition**: Dilarang membiarkan library tak terpakai tetap tercatat di `package.json` atau `requirements.txt`.

---

## 2. STRICT TYPESCRIPT & COMPILE-TIME TYPE SAFETY (SELF-HEALING FRIENDLY)
- **Strict Type Mode**: Seluruh kode baru berbasis JavaScript/TypeScript WAJIB ditulis menggunakan TypeScript dengan `strict: true`.
- **Zero `any` & Zero `@ts-ignore`**:
  - DILARANG menggunakan tipe `any`, `unknown` tanpa narrowing, atau directive `@ts-ignore` / `@ts-nocheck` untuk membungkam compiler.
  - Definisikan `interface`, `type`, atau schema validator eksplisit (Valibot/Zod) agar inkonsistensi terdeteksi saat compile-time melalui `tsc --noEmit`, bukan saat runtime di production.
- **Python Static Typing**: Untuk proyek Python, wajib melengkapi type annotations (`typing`, `dataclasses`, `mypy`) dengan `check_untyped_defs = True` dan melarang pemanggilan fungsi tanpa tipe pada domain kritis.

---

## 3. COMPILE-TIME HEAVY, RUNTIME FEATHERLIGHT (VPS & RESOURCE DEFENSE)
- **Target Deployment Invariant**: VPS berspesifikasi minimalis (RAM & CPU terbatas). Performa production dan efisiensi memori adalah prioritas tertinggi di atas kenyamanan spekulatif.
- **Frontend Architecture**:
  - Kirim sesedikit mungkin JavaScript ke browser client. Utamakan rendering HTML/CSS statis (MPA atau Islands architecture). Gunakan client-side JS hanya untuk komponen yang benar-benar membutuhkan interaktivitas dinamis.
  - Styling wajib teroptimasi saat build (Tailwind CSS dengan purge otomatis / Lightning CSS, atau Vanilla CSS murni). DILARANG menggunakan library CSS-in-JS dengan runtime injection yang berat.
- **Backend Architecture**:
  - Terapkan pola Web-Standard `Request`/`Response` (WinterCG-compliant).
  - Wajib mencegah memory leak: selalu unregister event listeners, batasi ukuran buffer in-memory, dan pastikan koneksi database/file descriptor ditutup dengan benar.
- **Containerization Footprint**:
  - Gunakan base image minimalis (`alpine` atau `distroless`) untuk memangkas ukuran image container.
  - Dilarang menginstal utilitas OS tambahan (seperti `curl`) semata-mata untuk healthcheck; gunakan one-liner native runtime (`node -e "fetch(...)"`).

---

## 4. CODE LOCALITY, SIMPLICITY & PONYTAIL/YAGNI
- **Anti-Overengineering**: DILARANG membuat abstraksi berlapis-lapis (factory of factories, generic wrappers berlebihan, unnecessary intermediate services) jika satu fungsi sederhana dan lugas sudah menyelesaikan masalah.
- **High Readability**: Tulis kode yang mudah dibaca, modular, mandiri (*high cohesion, low coupling*), dan langsung ke inti permasalahan tanpa spekulasi masa depan yang belum terbukti (*You Aren't Gonna Need It*).
