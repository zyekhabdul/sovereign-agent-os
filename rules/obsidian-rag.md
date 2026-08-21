---
trigger: always_on
description: Enterprise Standard Obsidian Vault RAG Governance & Isolation Protocol - Mandatory for All AI Agents
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
  - `CWD = /home/fuckadmin/Projects/shop.zyekh.com` -> Namespace: `00-AGY-Memory/shop-zyekh-com/`
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

## 3. STRICT AUTHORITY HIERARCHY (CONFLICT RESOLUTION)
In case of conflicting directives, AI agents MUST resolve truth using this strict 4-tier pyramid:

1. **Tier 1 (Supreme Rules)**: Global Safety & Security Rules (`.gemini/config/rules/`) [NON-OVERRIDABLE]
2. **Tier 2 (Authoritative Source)**: Local Workspace Repository (`GEMINI.md`, `DEVELOPMENT.md`, Root PRD, Source Code)
3. **Tier 3 (Project RAG Memory)**: Project Namespace RAG (`00-AGY-Memory/<project-namespace>/`)
4. **Tier 4 (Global RAG Vault)**: Unscoped Obsidian Notes [LOWEST PRIORITY]

---

## 4. GIT-HASH SYNCHRONIZATION & MILESTONE-GATED CHECKPOINT
- At each task milestone or successful local commit, the agent MUST update `STATE.md` using deterministic tooling: `agy-guard checkpoint --msg "<summary>"`.
- The tooling automatically captures `git rev-parse HEAD`, active branch, and namespace mapping without probabilistic hallucination.
- **Session Retrieval Check**: When reading RAG at session start, if `STATE.md`'s `git_commit_hash` does NOT match `git rev-parse HEAD`, RAG is considered **STALE**. The agent MUST treat the local repository source code as the absolute truth.

---

## 5. HIGH-DENSITY & TOKEN CAPACITY CAP
- RAG files MUST be terse, high-density markdown (bullet points, tables, zero fluff/conversational filler).
- Total lines per RAG file MUST NOT exceed **200 lines**.

---

## 6. GRACEFUL DEGRADED MODE (MCP FALLBACK)
- If the `obsidian` MCP server fails or is unavailable, the AI agent MUST NOT halt or error out.
- The agent MUST gracefully fall back to local workspace documentation (`DEVELOPMENT.md`, `CHANGELOG.md`) and notify the user:
  `[SYSTEM] Obsidian RAG unavailable. Operating in Local Repository Fallback Mode.`
