# STANDAR ARSITEKTUR WEBSITE MODERN & AI-READY SPECIFICATION

Dokumen ini adalah Standar Tunggal (SSOT) untuk pengembangan, audit, dan deployment website modern di seluruh ekosistem proyek. Banyak website konvensional dibangun hanya untuk peramban manusia era web 2.0 dan mengabaikan machine-readability, AI agent discovery, keamanan standar RFC, dan optimasi Core Web Vitals.

Dokumen ini menetapkan standar wajib agar setiap website yang dirilis memiliki interoperabilitas tinggi, terindeks sempurna oleh mesin pencari maupun agen AI otonom (LLM scrapers & agents), serta aman dan berkinerja tinggi.

---

## 1. DUAL-AUDIENCE PARADIGM

Setiap website modern memiliki dua kelas konsumen utama:
1. **Human Consumers**: Mengonsumsi visual UI/UX, interaktivitas, tipografi, dan pengalaman responsif pada peramban layar (Desktop, Mobile, Tablet).
2. **Machine & AI Consumers**: Mengonsumsi semantic markup, manifest terstruktur, skema data JSON-LD, serta endpoint teks padat (`llms.txt`, `robots.txt`, `security.txt`) untuk penalaran otonom dan pengindeksan data tanpa rendering headless browser yang boros sumber daya.

---

## 2. TAKSONOMI FILE & ENDPOINT STATIS WAJIB

Tiap website yang dideploy ke production wajib menyediakan struktur file statis di root webserver (`/usr/share/nginx/html/`, `/public/`, atau root reverse proxy):

| File / Path | Protokol / RFC | Format | Audience | Status |
| :--- | :--- | :--- | :--- | :--- |
| `/robots.txt` | Robots Exclusion Standard | `text/plain` | Crawler / Bots | `[ WAJIB ]` |
| `/sitemap.xml` | Sitemaps XML Protocol | `text/xml` | Search Engines | `[ WAJIB ]` |
| `/llms.txt` | LLMs.txt Proposed Standard | `text/plain` (Markdown) | AI Agents / LLMs | `[ WAJIB ]` |
| `/llms-full.txt` | LLMs.txt Proposed Standard | `text/plain` (Markdown) | AI Agents / RAG | `[ KONDISIONAL ]` (Katalog/Dokumentasi) |
| `/.well-known/security.txt` | RFC 9116 | `text/plain` | Security Researchers | `[ WAJIB ]` |
| `/site.webmanifest` | W3C Web App Manifest | `application/manifest+json` | PWA / Mobile OS | `[ WAJIB ]` |
| `/favicon.ico` | Standard Favicon Suite | `image/x-icon` | Browser Tabs | `[ WAJIB ]` |
| `/favicon.svg` | Scalable Vector Favicon | `image/svg+xml` | Modern Browsers | `[ REKOMENDASI ]` |
| `/apple-touch-icon.png` | Apple Touch Icon (180x180) | `image/png` | iOS / iPadOS | `[ WAJIB ]` |

---

## 3. SPESIFIKASI DETAIL TIAP KOMPONEN

### 3.1 AI Agent Discovery Layer (`/llms.txt` & `/llms-full.txt`)

Tujuan: Memberikan konteks instan berdensitas tinggi bagi AI Agent (Claude, ChatGPT, Perplexity, Gemini, Cursor) agar agen dapat memahami identitas website, arsitektur, katalog produk, dan cara berinteraksi programatik tanpa membuang kuota context window atau token scraping.

#### Aturan Struktur `/llms.txt`:
1. **Header Markdown**: Nama sistem, deskripsi satu kalimat, dan identitas canonical.
2. **System Architecture / High-Density Overview**: Menjelaskan apa fungsi website, teknologi utama, dan kapabilitas.
3. **Core Sections / Navigation Map**: Tautan terkurasi ke halaman kunci atau dokumentasi.
4. **Machine API & Interaction Protocol**: Jika website memiliki API atau aksi interaktif (misal: checkout, pencarian, query stok), sertakan spesifikasi payload HTTP (`method`, `endpoint`, request/response JSON schema).
5. **Kondisi `/llms-full.txt`**: Jika website adalah e-commerce, portal dokumentasi, atau basis pengetahuan besar, `/llms-full.txt` wajib memuat seluruh katalog atau isi ringkasan teks dalam satu file linear.

#### Contoh Template Baku `/llms.txt`:
```markdown
# [Nama Entitas / Proyek]

> [Deskripsi singkat fungsi proyek dan domain otoritas dalam 1-2 kalimat]

## Overview
- Website: https://example.com/
- Primary Function: [E-Commerce / Developer Portal / API Gateway]
- Audience: [Target pengguna]

## Key Navigation
- [Catalog](https://example.com/catalog): Daftar seluruh layanan aktif
- [Terms](https://example.com/terms): Ketentuan layanan dan kebijakan privasi

## Machine API & Action Specification
AI agents dapat melakukan aksi terprogram melalui endpoint publik:
- **Search API**: `GET /api/search?q={query}` -> returns `{ results: [] }`
- **Checkout API**: `POST /api/checkout` -> payload `{ productId: string, quantity: number }`

## Additional Resources
- Full Catalog & Knowledge: https://example.com/llms-full.txt
- Security Policy: https://example.com/.well-known/security.txt
```

---

### 3.2 Crawler & Indexing Control (`/robots.txt` & `/sitemap.xml`)

#### Aturan Standar `/robots.txt`:
1. Wajib memiliki direct declaration `User-agent: *`.
2. Dilarang memblokir file asset statis (`.css`, `.js`, `.svg`, `.png`, `.webp`, `.avif`).
3. Direktori internal/API yang tidak ditujukan untuk indeks web publik wajib di-disallow (contoh: `/api/`, `/admin/`, `/_internal/`).
4. File AI discovery (`/llms.txt`, `/llms-full.txt`, `/.well-known/security.txt`) WAJIB di-whitelist secara eksplisit jika ada disallow umum.
5. Wajib mencantumkan URL absolut `Sitemap: https://domain/sitemap.xml` di baris terakhir.

#### Contoh Template Baku `/robots.txt`:
```text
User-agent: *
Allow: /
Allow: /llms.txt
Allow: /llms-full.txt
Allow: /.well-known/security.txt
Disallow: /api/
Disallow: /admin/

Sitemap: https://example.com/sitemap.xml
```

#### Aturan Standar `/sitemap.xml`:
1. Valid XML namespace: `xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"`.
2. Seluruh URL dalam `<loc>` wajib berprotokol `https://` dan menggunakan canonical domain baku (bukan IP address atau localhost).
3. Cantumkan `<lastmod>` dengan format ISO 8601 UTC (`YYYY-MM-DD` atau `YYYY-MM-DDThh:mm:ssTZD`).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <lastmod>2026-10-21</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

---

### 3.3 Security Vulnerability Disclosure (`/.well-known/security.txt`)

Sesuai spesifikasi **RFC 9116**, setiap website publik wajib mencantumkan kontak pelaporan kerentanan keamanan siber.

#### Aturan Standar:
1. Terletak di direktori `/.well-known/security.txt` (bukan di root langsung, meski symlink dari root diperbolehkan).
2. Field wajib:
   - `Contact:` URI kontak pelaporan (email `mailto:` atau tautan portal pelaporan bug `https://`).
   - `Expires:` Tanggal kedaluwarsa dokumen berformat ISO 8601 (maksimal 1 tahun ke depan, wajib diperbarui berkala).
3. Field pendukung:
   - `Canonical:` URL absolut menuju file `security.txt` ini.
   - `Preferred-Languages:` Bahasa komunikasi yang diterima (contoh: `id, en`).
   - `Policy:` Tautan menuju kebijakan pengungkapan kerentanan (vulnerability disclosure policy).

#### Contoh Template Baku `/.well-known/security.txt`:
```text
Contact: mailto:security@example.com
Expires: 2027-12-31T23:59:59.000Z
Canonical: https://example.com/.well-known/security.txt
Preferred-Languages: id, en
```

---

### 3.4 Web App Manifest & Mobile Integration (`/site.webmanifest`)

Website modern harus siap diinstal sebagai Progressive Web App (PWA) atau di-bookmark ke homescreen ponsel tanpa menghasilkan icon default peramban yang pecah.

#### Aturan Standar:
1. Nama file baku: `site.webmanifest` atau `manifest.json`.
2. Tipe konten HTTP wajib: `application/manifest+json`.
3. Minimal memiliki icon ukuran `192x192` dan `512x512`, serta flag `purpose: "any maskable"`.
4. Theme color dan background color wajib selaras dengan CSS aplikasi.

#### Contoh Template Baku `/site.webmanifest`:
```json
{
  "name": "Example Web Portal",
  "short_name": "Example",
  "description": "Enterprise grade web portal and autonomous services.",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#09090b",
  "theme_color": "#09090b",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ]
}
```

---

## 4. METADATA HEAD HTML5 BAKU (`<head>`)

Seluruh dokumen HTML wajib memiliki header metadata lengkap yang mencakup SEO dasar, Open Graph, Twitter Card, dan JSON-LD Structured Data.

### 4.1 Snippet Header Baku:
```html
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
  <title>Nama Layanan — Slogan Singkat Padat</title>
  <meta name="description" content="Deskripsi layanan bernilai tinggi dalam 120-160 karakter untuk snippet hasil pencarian." />
  <link rel="canonical" href="https://example.com/" />

  <!-- Icons & Webmanifest -->
  <link rel="icon" type="image/x-icon" href="/favicon.ico" />
  <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
  <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
  <link rel="manifest" href="/site.webmanifest" />
  <meta name="theme-color" content="#09090b" media="(prefers-color-scheme: dark)" />
  <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)" />

  <!-- Open Graph Protocol (Facebook, WhatsApp, LinkedIn, Discord) -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://example.com/" />
  <meta property="og:title" content="Nama Layanan — Slogan Singkat Padat" />
  <meta property="og:description" content="Deskripsi layanan bernilai tinggi dalam 120-160 karakter." />
  <meta property="og:image" content="https://example.com/og-image.png" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:site_name" content="Nama Brand" />
  <meta property="og:locale" content="id_ID" />

  <!-- Twitter / X Card Tags -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:url" content="https://example.com/" />
  <meta name="twitter:title" content="Nama Layanan — Slogan Singkat Padat" />
  <meta name="twitter:description" content="Deskripsi layanan bernilai tinggi dalam 120-160 karakter." />
  <meta name="twitter:image" content="https://example.com/og-image.png" />

  <!-- Schema.org JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Nama Brand",
    "url": "https://example.com/",
    "description": "Deskripsi layanan bernilai tinggi.",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "https://example.com/search?q={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  }
  </script>
</head>
```

---

## 5. KEAMANAN HTTP RESPONSE HEADERS

Penyedia reverse proxy (Nginx, Caddy, Traefik, atau Cloudflare) WAJIB menginjeksi header keamanan standar pada setiap response `200 OK`:

```nginx
# Konfigurasi Nginx Security Headers Baku
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https:;" always;
```

---

## 6. PERFORMA & CORE WEB VITALS (CWV)

Untuk memastikan loading instan dan mencegah layout shifts:

1. **Cumulative Layout Shift (CLS = 0)**:
   - Seluruh tag `<img>` dan `<video>` WAJIB menyertakan atribut eksplisit `width` dan `height` atau `aspect-ratio` di CSS.
   - Gunakan format modern `image/webp` atau `image/avif` dengan atribut `loading="lazy"` dan `decoding="async"` (kecuali LCP image di atas fold yang wajib `loading="eager"`).
2. **First Contentful Paint & LCP (Largest Contentful Paint < 1.2s)**:
   - Font: Gunakan format WOFF2 murni. Dilarang mengimpor Google Fonts via eksternal render-blocking CSS (`@import url(...)`). Host font secara lokal dengan `font-display: swap`.
   - Asset Compression: Aktifkan Brotli (`br`) level kompresi 4-6, fallback Gzip.
   - Caching Policy:
     - Aset statis dengan hash build (`bundle.[hash].js` / `.css`): `Cache-Control: public, max-age=31536000, immutable`.
     - Dokumen HTML (`index.html`): `Cache-Control: no-cache, must-revalidate`.

---

## 7. MECHANICAL AUDIT HARNESS (VERIFIKASI TERMINAL)

Sebelum menyatakan sebuah website production-ready, jalankan serangkaian uji empiris melalui terminal (exit code 0):

```bash
# 1. Audit AI Agent Discovery File
curl -s -o /dev/null -w "llms.txt: %{http_code} (%{content_type})\n" https://example.com/llms.txt

# 2. Audit Crawler & Sitemap
curl -s -o /dev/null -w "robots.txt: %{http_code} (%{content_type})\n" https://example.com/robots.txt
curl -s -o /dev/null -w "sitemap.xml: %{http_code} (%{content_type})\n" https://example.com/sitemap.xml

# 3. Audit Security RFC 9116
curl -s -o /dev/null -w "security.txt: %{http_code} (%{content_type})\n" https://example.com/.well-known/security.txt

# 4. Audit Web Manifest
curl -s -o /dev/null -w "webmanifest: %{http_code} (%{content_type})\n" https://example.com/site.webmanifest

# 5. Audit Security Headers
curl -s -I https://example.com/ | grep -Ei "(strict-transport|x-content-type|x-frame|content-security|referrer-policy)"

# 6. Audit OpenGraph & JSON-LD
curl -s https://example.com/ | grep -Ei "(og:title|application/ld\+json)"
```

---

## 8. CHECKLIST PRE-RELEASE WEBSITE

- [ ] `/llms.txt` terpasang dengan ringkasan sistem & API schema.
- [ ] `/robots.txt` mengizinkan discovery files & mengarah ke `/sitemap.xml`.
- [ ] `/sitemap.xml` berisi URL kanonikal HTTPS yang valid.
- [ ] `/.well-known/security.txt` terpasang dengan tanggal kadaluwarsa valid.
- [ ] `/site.webmanifest` terpasang dengan theme color & icon resolusi tinggi.
- [ ] `<head>` HTML memiliki OpenGraph, Twitter Card, dan JSON-LD `WebSite`/`Product`.
- [ ] Security headers aktif di level webserver / reverse proxy.
- [ ] Seluruh gambar memiliki dimensi eksplisit (`width`/`height`) dan lazy loading.
- [ ] Seluruh endpoint statis mengembalikan `HTTP 200` dengan Content-Type yang benar.
