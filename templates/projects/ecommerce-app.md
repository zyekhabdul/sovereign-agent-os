# ARCHITECTURE BLUEPRINT — E-COMMERCE & STOREFRONT STANDARD

## 1. PROJECT IDENTITY & SCOPE
- Type: High-Performance E-Commerce & Storefront Architecture.
- Scope: Modular frontend, catalog indexing, checkout integration, and conversion optimization.
- Principle: Zero unnecessary dependencies, performance-first, mobile-first, and SEO-optimized.

---

## 2. CORE WORKFLOW & INTEGRITY GATES

1. INSPECT BEFORE APPLY:
   - Always read and understand target template, snippet, and schema files prior to modifications.
   - Ground all architectural decisions on empirical benchmarks, theme check linters, or schema standards.

2. MACHINE VERIFICATION GATES:
   - Mandatory syntax and integrity validation before commits (e.g. theme check, type check, linting).
   - Zero errors / zero failures gate.

3. SENSITIVE AREA GUARD:
   - Explicit human confirmation required before mutating payment gateways, checkout hooks, API credentials, or customer data schemas.

4. GIT COMMIT DISCIPLINE:
   - Checkpoint progress atomically using local git commits.
   - Remote pushes strictly blocked without explicit user command.

---

## 3. DESIGN SYSTEM LAWS

- Law 1 (Hybrid Color Mode): Default to high-contrast Light Mode for product photography integrity, with system-respecting Dark Mode toggle.
- Law 2 (CSS Tokens Single Source of Truth): All colors, spacing, and elevation MUST reference CSS custom properties (`var(--token-name)`). Zero raw hex values in individual component styles.
- Law 3 (No Inline Style Blocks): Styles must be colocated in designated stylesheets or asset bundles. Never inject inline `<style>` tags in repetitive template snippets.
- Law 4 (Fluid Transitions): Apply consistent transition curves across interactive states (`transition: all var(--transition)`).
- Law 5 (Grid Blowout Defense): All grid children must specify `min-width: 0` to prevent overflow breakage from oversized images or dynamic text.
- Law 6 (Localization First): String tokens rendered to end-users must route through translation/localization dictionaries.
- Law 7 (Anti-FOUC Protocol): Include minimal inline critical style/script in `<head>` to prevent theme flash before body hydration.
- Law 8 (Touch-First Navigation): Mobile interfaces (< 768px) must provide touch-friendly tap targets (minimum 44x44px) and native swipe interactions.

---

## 4. SECURITY & API HYGIENE
- Public storefront tokens must have read-only scope.
- Secret tokens, private API keys, and admin mutations must route exclusively through backend middleware or edge functions.
