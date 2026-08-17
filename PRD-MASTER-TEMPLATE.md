# PRODUCT REQUIREMENT DOCUMENT (PRD) — MASTER TEMPLATE

## 1. Executive Summary & Problem Statement
- **Product Name**: [Nama Produk / Fitur]
- **Target Audience**: [Pengguna Utama]
- **Core Problem**: [Masalah Spesifik yang Diselesaikan]
- **Value Proposition**: [Solusi Inti & Manfaat Utama]

---

## 2. Technical Stack & Architectural Constraints
- **Runtime / Framework**: [Contoh: Vanilla HTML5 / Shopify Liquid 2.0 / Node.js]
- **Styling Architecture**: [Contoh: Vanilla CSS Custom Properties / Zero Frameworks]
- **Performance Targets**: Lighthouse 100/100, TTFB < 200ms, Core Web Vitals (LCP < 1.2s, CLS 0, INP < 50ms)
- **External Dependencies**: Zero-dependency standard (YAGNI & Ponytail principle)

---

## 3. Functional Requirements & Feature Specification
### Feature Group 1: [Nama Fitur 1]
- **User Story**: As a [role], I want [action] so that [benefit].
- **Acceptance Criteria**:
  - [ ] Criteria 1 (Spesifik & Terukur)
  - [ ] Criteria 2 (Data Contract / Format URL)

### Feature Group 2: [Nama Fitur 2]
- **User Story**: As a [role], I want [action] so that [benefit].
- **Acceptance Criteria**:
  - [ ] Criteria 1
  - [ ] Criteria 2

---

## 4. Non-Functional Requirements & Security Rails
- **Accessibility (a11y)**: WCAG 2.2 AA Compliance, Keyboard Navigation, Contrast Ratio >= 4.5:1.
- **Localization (i18n)**: Zero hardcoded strings (All via translation keys / dictionaries).
- **Security & Privacy**: Zero credential leaks, Strict Content Security Policy (CSP), Anti-Clickjacking headers.
- **Caching & Invalidation**: Deterministic cache busting (`?v=...` & Service Worker / CDN purge).

---

## 5. Machine-Verifiable Definition of Done (DoD)
- [ ] 0 Syntax / Linter Errors (`theme check` / `linter` exit code 0).
- [ ] 0 Visual Regressions / Grid Blowouts (`min-width: 0` on grid children).
- [ ] 0 Emoji Characters across all source files (`check_emojis.py`).
- [ ] Localhost live smoke test passes (`smoke_test.py` HTTP 200).
