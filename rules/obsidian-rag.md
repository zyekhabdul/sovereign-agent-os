---
trigger: always_on
description: obsidian-rag.md
---

# MANDATORY GLOBAL RULE: OBSIDIAN RAG ENTERPRISE GOVERNANCE

- **Global Obsidian Vault Path**: `/home/fuckadmin/Documents/Obsidian Vault`
- **MCP Server Name**: `obsidian`
- **Applicability**: ALL AI coding agents (Antigravity CLI `agy`, Claude Code, Cursor, Codex, OpenCode).

---

## 1. STRICT NAMESPACE ISOLATION & CWD AUTO-BINDING
- Every project MUST have its dedicated namespace directory in Obsidian Vault:
  `/home/fuckadmin/Documents/Obsidian Vault/00-AGY-Memory/<project-namespace>/`
- **Automatic CWD Auto-Binding**:
  - `CWD = /home/fuckadmin/Projects/shop.zyekh.com` -> Namespace: `00-AGY-Memory/shop.zyekh.com/`
  - `CWD = /home/fuckadmin/Projects/bagisto-testing` -> Namespace: `00-AGY-Memory/bagisto-testing/`
- **STRICT PROHIBITION**:
  - NEVER execute global wildcard RAG searches (`search_notes`) without prefixing/scoping to the active project namespace.
  - NEVER read or cross-reference notes from another project's namespace.

---

## 2. FIXED 4-FILE MEMORY ARCHITECTURE (STRICT SCHEMA)
To prevent RAG memory bloat, noise, and stale file pollution, every project namespace MUST maintain EXACTLY 4 core files:

1. `INDEX.md`: Project metadata, local repo path mapping, and Latest Git Commit Hash stamp (`git_commit_hash`).
2. `CONTEXT.md`: High-density project overview, technical stack, and architectural constraints (max 200 lines).
3. `STATE.md`: Active task status, current phase, and checkpoint (OVERWRITTEN at the end of each session).
4. `DECISIONS.md`: Architectural Decision Records (ADR) & fixed technical laws (Append-only).

> **Archiving Protocol**: Any session logs or deprecated PRD notes MUST be moved to `00-AGY-Memory/<project-namespace>/_archive/`. AI agents MUST IGNORE any files inside `_archive/` or starting with `_`.

---

## 3. ZERO-MAINTENANCE DIRECTIVES & AUTOMATION INVARIANTS (RFC-RAG-003)
1. **Auto-Scaffolding Invariant**: Before modifying code in an unmapped project, AI agent must ensure the 4-file set exists in `00-AGY-Memory/<project-namespace>/`.
2. **Solar System Linking Invariant**: Child documents (`CONTEXT.md`, `STATE.md`, `DECISIONS.md`) must link ONLY to their namespace `INDEX.md`. Direct links from child notes to `00-MASTER-INDEX.md` are prohibited to preserve graph physics.
3. **Rolling Archive Protocol**: When any memory note reaches 180 lines, historical completed tasks or deprecated ADRs must be archived to `_archive/` to strictly uphold the 200-line token cap.
4. **Autonomous Git-Sync Invariant**: Git post-commit hooks (`scripts/install-rag-hooks.sh`) automatically sync `git_commit_hash` to `STATE.md` on every local commit.

---

## 4. STRICT AUTHORITY HIERARCHY (CONFLICT RESOLUTION)
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
