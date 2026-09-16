# ARCHITECTURE BLUEPRINT — FULLSTACK & WEB APPLICATION STANDARD

## 1. PROJECT IDENTITY & CORE ARCHITECTURE
- Type: High-Performance Web Application, Static Portfolio, or API Platform.
- Core Principle: Extreme Minimalism, Ponytail / YAGNI (Zero Speculative Abstraction).
- Performance Standards: Core Web Vitals compliance, 100/100 Lighthouse target, accessible semantic HTML (WCAG 2.1 AA), structured metadata (OpenGraph & Schema.org JSON-LD).

---

## 2. STRICT OPERATIONAL INVARIANTS

1. STRICT NO EMOJI:
   - Zero emojis in source code, commits, configuration, logs, or technical artifacts.
   - Use structured text tokens: `[ VERIFIED ]`, `[ NOTE ]`, `[ WARN ]`, `[ INFO ]`, `->`.

2. INSPECT BEFORE APPLY:
   - Verify target files, existing imports, and call-site blast radius prior to modifying code.
   - Ground changes on local runtime truth, never subjective assumption.

3. DETERMINISTIC MACHINE HARNESS:
   - All mutations must pass local compiler (`tsc`, `mypy`, `cargo check`), linter, and unit test suites before checkpointing.
   - Exit code 0 is the sole arbiter of completion.

4. ATOMIC CHECKPOINTS & DISK INTEGRITY:
   - Use atomic, surgical diffs (`replace_file_content`) on existing source code. Full file overwrites strictly forbidden on existing files.
   - Commit code atomically per logical chunk.

5. SENSITIVE AREA GUARD & REMOTE PUSH RESTRICTION:
   - Never mutate production secrets, authentication flows, or destructive database operations without human confirmation.
   - Remote `git push` is blocked without explicit human command.

---

## 3. UI/UX & DESIGN SYSTEM LAWS

1. Layout Uniformity:
   - Establish consistent layout containers (`max-width`) and responsive grid systems.
   - Avoid ad-hoc, inline layout overrides in individual view templates.

2. Component Reusability & DRY:
   - Shared navigational headers, footers, and cards must reside in modular components or custom elements.
   - Single source of truth for design tokens (colors, typography, spacing, border radii) via CSS custom properties.

3. Progressive Enhancement & Accessibility:
   - Core pages must remain functional under baseline HTML/CSS before JavaScript hydration.
   - Full keyboard navigation, proper ARIA labeling, and color contrast compliance.
