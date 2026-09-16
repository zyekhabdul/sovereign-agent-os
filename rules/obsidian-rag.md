---
trigger: always_on
description: Enterprise Standard Obsidian Vault RAG Governance & Zero-Maintenance Isolation Protocol
---

# MANDATORY GLOBAL RULE: OBSIDIAN RAG ENTERPRISE GOVERNANCE

- **Global Obsidian Vault Path**: `~/Documents/Obsidian Vault`
- **MCP Server Name**: `obsidian`
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. STRICT NAMESPACE ISOLATION, CWD AUTO-BINDING & TIERED RETRIEVAL
- Every project MUST have its dedicated namespace directory in Obsidian Vault:
  `~/Documents/Obsidian Vault/00-AGY-Memory/<project-namespace>/`
- **Automatic CWD Auto-Binding**:
  - `CWD = ~/Projects/my-app` -> Namespace: `00-AGY-Memory/my-app/`
  - `CWD = ~/Projects/payment-service` -> Namespace: `00-AGY-Memory/payment-service/`
- **Tiered Retrieval Strategy (Strict Execution Order)**:
  1. **Tier 1 (Direct Path CWD)**: Read `INDEX.md` -> `CONTEXT.md` -> `STATE.md` via explicit filepath. Zero search overhead.
  2. **Tier 2 (Scoped Keyword Grep)**: If searching for specific functions or tokens, grep strictly scoped to `00-AGY-Memory/<project-namespace>/`.
  3. **Tier 3 (Local Semantic Similarity)**: If keyword search misses due to synonyms/paraphrase, invoke local vector embeddings scoped within namespace.
- **STRICT PROHIBITION**:
  - NEVER execute global wildcard RAG searches (`search_notes`) without prefixing/scoping to the active project namespace.
  - NEVER read or cross-reference notes from another project's namespace.

---

## 2. FIXED 4-FILE MEMORY ARCHITECTURE (STRICT SCHEMA)
To prevent RAG memory bloat, noise, and stale file pollution, every project namespace MUST maintain EXACTLY 4 core files:

1. `INDEX.md`: Project metadata, local repo path mapping, and Latest Git Commit Hash stamp (`git_commit_hash`).
2. `CONTEXT.md`: High-density project overview, technical stack, architectural constraints, and mandatory **`## Known Gotchas & Environment Traps`** (documenting solved debugging traps, environment quirks, and edge cases to prevent regression). Max 200 lines.
3. `STATE.md`: Active task status, current phase, and checkpoint (OVERWRITTEN at the end of each session, MAX 10 active tasks).
4. `DECISIONS.md`: Architectural Decision Records (ADR). **Mandatory Lifecycle States**: Every recorded ADR MUST carry an explicit status tag:
   - `[ACTIVE]`: Decision actively governs codebase.
   - `[SUPERSEDED by ADR-XXX]`: Overridden by newer decision (eliminates stale facts).
   - `[DEPRECATED]`: No longer applicable.

- **Strict 4-File Whitelist**: Namespaces MUST NOT contain any additional files (e.g. `Session-*.md`, `task-detail.md`, `PLAN-*.md`, scratch dumps). All execution step details are ephemeral (terminal/chat only).
- **10-Task Cap Invariant**: `STATE.md` task checklists MUST NOT exceed 10 active items (packet/milestone level). Micro-chunks and granular DoDs belong strictly in the local repository's `PLAN.md`.

> **Archiving Protocol**: Any deprecated notes MUST be moved to `00-AGY-Memory/<project-namespace>/_archive/`. AI agents MUST IGNORE any files inside `_archive/` or starting with `_`.

---

## 3. GLOBAL MEMORY & CROSS-PROJECT PREFERENCES (`00-AGY-Memory/global/`)
- Cross-project architectural decisions, persistent developer preferences, and global invariant laws are governed in `00-AGY-Memory/global/`:
  - `00-AGY-Memory/global/DECISIONS.md`: Global ADRs applicable across all workspaces.
- AI agents may read `global/DECISIONS.md` during cold-start to align with universal developer preferences (e.g. strict no-emoji, pnpm preference, minimal diff radius).
- Global memory MUST NEVER contain project-specific business logic or transient states.

---

## 4. ZERO-MAINTENANCE DIRECTIVES & AUTOMATION INVARIANTS (RFC-RAG-003)
1. **Auto-Scaffolding Invariant**: Before modifying code in an unmapped project, AI agent must ensure the 4-file set exists in `00-AGY-Memory/<project-namespace>/`.
2. **Solar System Linking Invariant**: Child documents (`CONTEXT.md`, `STATE.md`, `DECISIONS.md`) must link ONLY to their namespace `INDEX.md`. Direct links from child notes to `00-MASTER-INDEX.md` are prohibited to preserve graph physics.
3. **Rolling Archive Protocol**: When any memory note reaches 180 lines, historical completed tasks or deprecated ADRs must be archived to `_archive/` to strictly uphold the 200-line token cap.
4. **Autonomous Git-Sync Invariant**: Git post-commit hooks (`scripts/install-rag-hooks.sh`) automatically sync `git_commit_hash` to `STATE.md` on every local commit.
5. **Zero-File Execution Dump Invariant**: Agents are strictly prohibited from writing session logs, temporary plan files, or execution dumps into the vault. RAG memory is updated solely via in-place overwrites to `STATE.md` and append to `DECISIONS.md`.

---

## 5. STRICT AUTHORITY HIERARCHY (CONFLICT RESOLUTION)
In case of conflicting directives, AI agents MUST resolve truth using this strict 4-tier pyramid:

1. **Tier 1 (Supreme Rules)**: Global Safety & Security Rules (`.gemini/config/rules/`) [NON-OVERRIDABLE]
2. **Tier 2 (Authoritative Source)**: Local Workspace Repository (`GEMINI.md`, `DEVELOPMENT.md`, Root PRD, Source Code)
3. **Tier 3 (Project RAG Memory)**: Project Namespace RAG (`00-AGY-Memory/<project-namespace>/`)
4. **Tier 4 (Global RAG Vault)**: Unscoped Obsidian Notes [LOWEST PRIORITY]

---

## 5. HIGH-DENSITY & TOKEN CAPACITY CAP
- RAG files MUST be terse, high-density markdown (bullet points, tables, zero fluff/conversational filler).
- Total lines per RAG file MUST NOT exceed **200 lines**.

---

## 6. GRACEFUL DEGRADED MODE (MCP FALLBACK)
- If the `obsidian` MCP server fails or is unavailable, the AI agent MUST NOT halt or error out.
- The agent MUST gracefully fall back to local workspace documentation (`DEVELOPMENT.md`, `CHANGELOG.md`) and notify the user:
  `[SYSTEM] Obsidian RAG unavailable. Operating in Local Repository Fallback Mode.`
