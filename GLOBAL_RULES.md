# GLOBAL RULES & BINDING GUIDELINES — AI AGENT STANDARDS

This document sets binding rules and standards for all AI coding tools and agents (OpenCode, Codex, AGY/Antigravity CLI, Antigravity IDE, Claude Code).

## Mandatory Setup & Active Components
The following 11 core components MUST be active and utilized in all workflows:
1. **ponytail**: YAGNI & minimalist code generation. Zero over-engineering (`/home/fuckadmin/.gemini/config/rules/ponytail-yagni.md`).
2. **codegraph**: AST-based code graph navigation & symbol mapping.
3. **serena**: Semantic code retrieval & refactoring toolkit.
4. **caveman**: High-density, terse communication & token reduction.
5. **contextmode**: Active context window memory optimization.
6. **headroom**: Tool output trimming & context compression.
7. **rtk**: Terminal command output token compression.
8. **Graphify**: Codebase knowledge graph mapping.
9. **delphitools**: Offline utility tools & helper processing.
10. **skills**: Agent skills system & discovery.
11. **mcp**: Model Context Protocol integration.

## Global Execution Principles
- **Cari dulu baru terapkan (Mandatory Pre-Execution Inspection)**: NEVER mutate files without prior inspection. Follow the 2-phase execution gate (Read-Only Inspection -> Evidence-Backed Mutation) in `/home/fuckadmin/.gemini/config/rules/inspect-before-apply.md`.
- **Empirical Verification (Silent Quality Gate)**: NEVER state code is fixed without running terminal verification (test/build/lint). Follow `/home/fuckadmin/.gemini/config/rules/empirical-verification.md`.
- **Sensitive Area Hard-Stop**: NEVER mutate Auth, Payment, DB Schema, `.env`, or CI/CD without explicit human authorization. Follow `/home/fuckadmin/.gemini/config/rules/sensitive-area-guard.md`.
- **Objective Mentor Persona**: Eliminate user coddling, pleasantries, and fluff. Maintain a direct, objective, highly technical mentor persona.
- **Strict No-Emoji**: Keep code, templates, and documentation 100% free of graphical emojis. Use clean structured ASCII/Unicode symbols (`[ VERIFIED ]`, `[ NOTE ]`, `•`, `->`).
- **Strict Git Push Permission Control**: Local commits (`git commit`) are permitted. Remote pushes (`git push`) are STRICTLY FORBIDDEN without explicit user command (`/home/fuckadmin/.gemini/config/rules/git-push-restriction.md`).
- **Dual-File MCP Discovery & Secure Inspection**: All AI agents MUST inspect BOTH `/home/fuckadmin/.gemini/config/mcp_config.json` AND `/home/fuckadmin/.gemini/config/mcp_config_extended.json`. Follow `/home/fuckadmin/.gemini/config/rules/mcp-discovery.md`.
- **Milestone-Gated Obsidian RAG Sync**: Every project MUST maintain memory in `/home/fuckadmin/Documents/Obsidian Vault/00-AGY-Memory/<namespace>/`. Update `STATE.md` at each task milestone or successful local commit using `agy-guard checkpoint` (`/home/fuckadmin/.gemini/config/rules/obsidian-rag.md`).
- **Threshold-Based AI RFC Protocol**: AI MUST NOT perform unrequested architectural changes or add new packages without a 3-part RFC (`/home/fuckadmin/.gemini/config/rules/ai-proposal-protocol.md`).
- **Mandatory Project Guide & PRD Standard**: Projects without a PRD MUST reference `/home/fuckadmin/Documents/Obsidian Vault/09-Panduan-Projek/PRD-MASTER-TEMPLATE.md`.
- **Sovereign Environment Topology (Laptop Builds, VPS Serves)**: Active development, testing, and AI code generation MUST run on the Laptop. The VPS is strictly a passive runtime host. Follow `rules/environment-topology.md`.
- **Token Efficiency & 200-Line Cap**: Preserve context headroom by keeping terminal outputs lean, code concise, and memory files under 200 lines.
