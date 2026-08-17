# WORKSPACE RULES & STOREFRONT ARCHITECTURE — SHOP.ZYEKH.COM-THEME

## 1. PROJECT IDENTITY & BOUNDARIES (READ FIRST)
- Type: Standalone Shopify Liquid 2.0 Frontend Catalog & E-Commerce Theme.
- Store URL: `jdidjn-c3.myshopify.com` / Custom Domain: `shop.zyekh.com`
- STRICT ISOLATION: Proyek ini BERDIRI SENDIRI. TIDAK ADA koneksi runtime/database ke Laravel, Bagisto backend, PostgreSQL, atau VPS backend.
- Architecture Separation:
  - MESIN (Teknologi): Identik dengan standar zyekh.com (Zero-dependency Vanilla JS/CSS, CSS variables single source of truth, anti-FOUC, performance-first).
  - KULIT (UI/UX): Disesuaikan khusus untuk konversi pasar e-commerce dropshipping (Light mode default, kompatibel dengan foto produk supplier latar putih/transparan, layout belanja berdensitas tinggi terinspirasi dari Bagisto 2.4.x / Shopee / Amazon).

---

## 2. STRICT WORKFLOW & EXECUTION STANDARDS

1. CARI DULU BARU TERAPKAN:
   - Dilarang mengedit file apapun tanpa membaca file tersebut secara penuh dan memahami konteksnya.
   - Semua keputusan teknis harus berbasis data (Shopify liquid specs, benchmark, audit log), bukan asumsi.

2. HYPER-GRANULAR TASK & SILENT QUALITY GATES:
   - Alur kerja: `PRD.md` -> `PLAN.md` -> Eksekusi per Chunk -> Silent Verification via `shopify theme check` -> Local Commit per Chunk.
   - STOP TOTAL jika: (a) `shopify theme check` menghasilkan error, (b) menyentuh kredensial / payment / skema sensitif.

3. STRICT GIT PUSH PERMISSION CONTROL:
   - `git commit` di lokal diizinkan untuk menyimpan checkpoint.
   - `git push` DILARANG KERAS dieksekusi secara otomatis tanpa instruksi eksplisit bertuliskan "push" dari pengguna.

4. LOG SEMUA PERUBAHAN:
   - Setiap akhir sesi pengerjaan, AI WAJIB memperbarui `CHANGELOG.md` dan `DEVELOPMENT.md`.

---

## 3. THE 10 LAWS OF DESIGN SYSTEM

- Law 1 (Hybrid Color Mode): Default **Light Mode** (Off-white `#F9FAFB`, cards `#FFFFFF`, text `#111827`). Dark Mode tersedia via atribut `[data-theme="dark"]` (`#09090b`, cards `#141417`, text `#fafafa`). Riset membuktikan dark mode menurunkan konversi 10-18% pada e-commerce umum karena merusak foto produk berlatar putih.
- Law 2 (Zero Hardcoded Colors): SEMUA warna wajib menggunakan `var(--token-name)`. Dilarang menulis raw hex/rgb di dalam CSS section/snippet.
- Law 3 (No Inline Style Blocks): DILARANG meletakkan tag `<style>` inline di dalam template Liquid section atau snippet. Gunakan `critical.css`, `assets/section-*.css`, atau blok `{% stylesheet %}`.
- Law 4 (Single Source of Truth `:root`): `snippets/css-variables.liquid` adalah SATU-SATUNYA tempat pendefinisian token CSS `:root`. File CSS lain dilarang mendefinisikan ulang `:root`.
- Law 5 (Spacing & Radius Tokens): Gunakan `--space-xs` (0.25rem), `--space-sm` (0.5rem), `--space-md` (1rem), `--space-lg` (1.5rem), `--space-xl` (2.5rem). Radius: `--radius-sm` (4px), `--radius-md` (6px), `--radius-lg` (8px).
- Law 6 (Transition Standard): Semua transisi memakai Apple fluid spring curve: `transition: all var(--transition);` di mana `--transition: 0.2s cubic-bezier(0.16, 1, 0.3, 1)`.
- Law 7 (Grid Blowout Prevention): Setiap grid child wajib menyertakan `min-width: 0;` untuk mencegah overflow kontainer saat merender gambar/teks panjang.
- Law 8 (Full Localization / Zero Hardcoded Text): Semua string UI yang tampil ke pengguna WAJIB menggunakan filter translation: `{{ 'products.product.add_to_cart' | t }}`. Kamus translation tersimpan sinkron di `locales/en.default.json` dan `locales/id.json`.
- Law 9 (Anti-FOUC Protocol): Script sinkron pendek pencegah kedipan tema wajib dieksekusi di `<head>` sebelum `<body>` dirender.
- Law 10 (Supplier Photography Compatibility): Gunakan solid card background (`--bg-card`) dengan border konsisten agar foto produk dari supplier (putih, transparan, atau lifestyle) tampil rapi dan menyatu.

---

## 4. PERMANENT ARCHITECTURAL DECISIONS (DO NOT OVERTURN)

- KF-001: Light mode default dengan dark mode toggle (Hybrid).
- KF-002: Shopify API token membutuhkan OAuth flow (`shpat_`), bukan token langsung dari dashboard (`atkn_`).
- KF-003: Shopify CLI Auth untuk theme dev menggunakan Device Code Flow (`shopify theme dev --store ...`), bukan API token manual.
- KF-004: Repositori berdiri sendiri dan terpisah dari `zyekh.com`.
- KF-011 (Seasonal Campaign Layer): Promo musiman (Black Friday, Ramadhan, dll.) wajib diterapkan via Campaign Layer (banner admin, promo text, collection link). DILARANG merombak arsitektur dasar tema.
- KF-012 (3D Product Avatar & Mobile Touch UX): Kategori produk menggunakan foto studio 3D. Khusus layar HP (< 768px), tombol panah melayang (< & >) DILARANG MUNCUL (`display: none !important`) agar tidak menutupi avatar; navigasi 100% menggunakan swipe natural jari.
- KF-013 (Hero Banner High-Contrast Overlay): Pada layar seluler (< 768px), overlay banner menggunakan `linear-gradient(180deg, rgba(9,13,22,0.92) 0%, rgba(15,23,42,0.82) 100%)` dan `backdrop-filter: blur(2px)` agar teks judul terbaca kontras tanpa menabrak detail foto.
- KF-014 (Dual-Mode Architecture): Mendukung Single-Product Landing Funnel (`templates/product.landing.json`) untuk ad-traffic (TikTok/Meta Ads) dan Full Marketplace Catalog tanpa menggunakan redirect URL terpisah.

---

## 5. SHOPIFY LIQUID 2.0 GUIDELINES & ANTI-PATTERNS

### Strict Shopify Rules:
1. Deprecated Filters: DILARANG menggunakan filter usang `img_url`. WAJIB gunakan `image_url` + `image_tag`.
2. Section Schemas: Tag `{% schema %}` hanya boleh ada 1 blok per file section.
3. Component Reuse: Semua card produk dalam collection grid, search, maupun related products wajib memanggil snippet `snippets/product-card.liquid`.
4. Cart Drawer: Gunakan Sliding AJAX Cart (`snippets/cart-drawer.liquid`) dengan Free Shipping Progress Bar dan Escrow Shield.

### Anti-Pattern Register (DILARANG KERAS):
- AP-001: Menyisipkan inline `<style>` di dalam section/snippet.
- AP-002: Menulis hardcoded hex color (misal `#DC2626` alih-alih `var(--color-sale)`).
- AP-003: Menduplikasi blok `:root` di `critical.css`.
- AP-004: Hardcode teks UI tanpa translation key (mencampur bahasa ID/EN).
- AP-005: Melakukan edit file tanpa membaca file aslinya terlebih dahulu.
- AP-006: Menggunakan karakter emoji di dalam kode, template, atau dokumentasi.
- AP-007: Menghabiskan waktu mencoba debug API token untuk development alih-alih memakai CLI device code.
- AP-008: Menambahkan library CSS/JS pihak ketiga (Tailwind, jQuery, Animate.css) yang menyebabkan bloat.

---

## 6. DEVELOPMENT & VERIFICATION COMMANDS
```bash
# Menjalankan Dev Server Lokal Shopify (Login via device code)
shopify theme dev --store jdidjn-c3.myshopify.com

# Audit Kepatuhan Liquid & Best Practices (Wajib 0 Error)
shopify theme check

# Deploy Theme ke Store Target
shopify theme push --store jdidjn-c3.myshopify.com
```
