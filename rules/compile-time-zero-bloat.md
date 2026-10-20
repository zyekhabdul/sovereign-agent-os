---
trigger: always_on
description: Pragmatic Compile-Time & Zero-Bloat Engineering Standards
---

# MANDATORY GLOBAL RULE: PRAGMATIC COMPILE-TIME & ZERO-BLOAT STANDARDS

- **Principle**: "Compile-Time Heavy, Runtime Featherlight — Pragmatic Zero-Bloat, Never Extremist"
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

Setiap kali menulis, mengedit, atau menyarankan kode di seluruh proyek, AI agent WAJIB mematuhi 4 pilar arsitektur yang berimbang dan pragmatis berikut:

---

## 1. PRAGMATIC ZERO-BLOAT DEPENDENCY POLICY (NATIVE-FIRST, NOT ANTI-LIBRARY)
- **Native-First Priority**: DILARANG menginstal package eksternal untuk fungsi utilitas standar yang sudah ditangani secara andal oleh Web-Standard API bawaan runtime:
  - Gunakan `fetch` native (Node 18+, Bun, Deno, Browser), dilarang `axios` atau `got`.
  - Gunakan `URL` dan `URLSearchParams` bawaan, dilarang library parsing query-string eksternal.
  - Gunakan `crypto.randomUUID()` dan Web Crypto API, dilarang `uuid`.
  - Gunakan `Intl` API (`Intl.DateTimeFormat`, `Intl.NumberFormat`), dilarang `moment` atau `dayjs` untuk pemformatan dasar.
  - Gunakan native Array/Object methods (`structuredClone`, `Array.prototype.flat`, `Object.fromEntries`), dilarang `lodash` atau `underscore`.
- **Anti-Reinventing-the-Wheel Exception (Keamanan & Protokol Kritis)**:
  - DILARANG menulis sendiri algoritma kriptografi, parser token/JWT, atau streaming multipart kompleks dari nol semata-mata demi klaim "zero dependencies". Hal ini memicu celah keamanan fatal (*timing attacks*, *memory leaks*).
  - Gunakan library mikro yang terspesialisasi, zero-transitive dependency, dan teruji secara keamanan (contoh: gunakan `jose` untuk JWT/JWE, `@fastify/busboy` untuk multipart streams).
- **Minimalist External Selection**:
  - Jika mutlak memerlukan library pihak ketiga, evaluasi bundle size dan transitif dependensi (prioritaskan < 10 KB gzipped, zero transitives).
  - Utamakan framework modern ultra-ringan (seperti `hono` dibanding `express`, `valibot` dibanding validator monolitik).
- **Dead Dependency Prohibition**: Dilarang membiarkan library tak terpakai tetap tercatat di `package.json` atau `requirements.txt`.

---

## 2. STRICT TYPE SAFETY & RUNTIME BOUNDARY DEFENSE (NO TYPE ASTRONOMY)
- **Strict Type Mode**: Seluruh kode baru berbasis JavaScript/TypeScript WAJIB ditulis menggunakan TypeScript dengan `strict: true`.
- **Zero `any` & Zero `@ts-ignore`**:
  - DILARANG menggunakan tipe `any`, `unknown` tanpa narrowing, atau directive `@ts-ignore` / `@ts-nocheck` untuk membungkam compiler.
  - Definisikan `interface` atau `type` eksplisit yang lugas dan mudah dipahami.
- **Anti-Type Gymnastics**:
  - DILARANG menulis tipe bersarang berlebihan (*type gymnastics*: recursive conditional types yang rumit) yang memperlambat compiler tanpa memberikan manfaat nyata bagi logika bisnis.
- **Runtime Boundary Mandate**:
  - Karena tipe TypeScript terhapus saat runtime (*type erasure*), semua boundary I/O eksternal (API request body, Webhook publik, WebSocket messages, query params) WAJIB divalidasi menggunakan runtime schema validator ringan (Valibot / TypeBox). Jangan mengasumsikan payload eksternal valid hanya karena ada deklarasi interface TS.
- **Featherlight Scripting Alternatives**:
  - Untuk script utilitas sederhana atau microservice single-file, penggunaan JSDoc + `@ts-check` atau Node.js 22+ Type Stripping (`--experimental-strip-types`) DIPERBOLEHKAN untuk mendapatkan type safety tanpa friksi build pipeline.
- **Python Static Typing**: Untuk proyek Python, wajib melengkapi type annotations (`typing`, `dataclasses`, `mypy`) dengan `check_untyped_defs = True` pada domain kritis.

---

## 3. COMPILE-TIME HEAVY, RUNTIME FEATHERLIGHT (VPS & RESOURCE DEFENSE)
- **Target Deployment Invariant**: VPS berspesifikasi minimalis (RAM & CPU terbatas). Performa production dan efisiensi memori adalah prioritas tertinggi di atas kenyamanan spekulatif.
- **Frontend Architecture**:
  - Kirim sesedikit mungkin JavaScript ke browser client. Utamakan rendering HTML/CSS statis (MPA atau Islands architecture) untuk halaman katalog dan informasi.
  - **Dynamic State Exception**: Jika UI membutuhkan interaktivitas dinamis tinggi atau manajemen state real-time (seperti live chat atau dashboard), gunakan micro-framework reaktif ringan (seperti Preact ~3 kB, Svelte 5, atau Solid) alih-alih memaksakan manipulasi DOM Vanilla JS yang rentan menjadi spaghetti code.
  - Styling wajib teroptimasi saat build (Tailwind CSS dengan purge otomatis / Lightning CSS, atau Vanilla CSS murni). DILARANG menggunakan library CSS-in-JS dengan runtime injection yang berat.
- **Backend Architecture & V8 Awareness**:
  - Terapkan pola Web-Standard `Request`/`Response` (WinterCG-compliant).
  - Wajib mencegah memory leak: selalu unregister event listeners, bersihkan abort signals, batasi buffer in-memory, dan pastikan koneksi database/file descriptor ditutup dengan benar.
  - **Runtime Consolidation Awareness**: Waspadai fragmentasi proses V8 berlebihan (banyak container Node.js kecil yang memakan 40-50MB RAM dasar per proses). Pertimbangkan modular monolith atau worker threads untuk mengonsolidasikan heap RAM di VPS hemat.
- **Containerization Footprint & Runtime Pairing**:
  - Gunakan base image `alpine` untuk pure JS/TS microservices.
  - **Native/Glibc Exception**: Tetap gunakan `node:22-bookworm-slim` atau Debian jika proyek bergantung pada native C++ bindings, library ML/AI (ONNX, PyTorch wheels), atau Playwright browser binaries untuk mencegah masalah kompilasi `musl` dan thread contention.
  - Dilarang menginstal utilitas OS tambahan (seperti `curl`) semata-mata untuk healthcheck; gunakan one-liner native runtime (`node -e "fetch(...)"`).

---

## 4. CODE LOCALITY, SIMPLICITY & PRAGMATIC ABSTRACTION
- **Anti-Overengineering**: DILARANG membuat abstraksi berlapis-lapis (factory of factories, generic wrappers berlebihan, unnecessary intermediate services) jika satu fungsi sederhana dan lugas sudah menyelesaikan masalah.
- **Anti-Copy-Paste Trap (Pragmatic DRY)**:
  - Larangan over-engineering BUKAN berarti larangan modularisasi.
  - DILARANG men-copy-paste logika kritis (koneksi database, verifikasi signature pembayaran, sanitasi input, token auth) ke berbagai modul secara berulang.
  - Ekstrak ke helper/utilitas bersama jika logika yang sama digunakan di >2 tempat atau menyangkut keamanan dan finansial.
- **Architectural Boundary Integrity (Hexagonal / Ports & Adapters)**:
  - Pada sistem omnichannel/multi-channel (seperti core bot yang melayani Web, Telegram, WhatsApp), pisahkan domain logic inti dari adapter channel. Hal ini memastikan penambahan channel baru tidak mengacak-acak business logic pemrosesan data.
- **High Readability**: Tulis kode yang mudah dibaca, modular, mandiri (*high cohesion, low coupling*), dan langsung ke inti permasalahan tanpa spekulasi masa depan yang belum terbukti (*You Aren't Gonna Need It*).
