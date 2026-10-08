# AI AGENT WORKSPACE STANDARDS & SSOT POINTER

Global rules and binding guidelines are centralized in the Master Configuration directory.
All agents (Antigravity CLI, OpenCode, Claude Code, Codex) MUST strictly adhere to the authoritative rules defined in:
- Master Rules Index: `~/.gemini/config/GEMINI.md`
- Modular Rule Definitions: `~/.gemini/config/rules/`

### Core Directives Summary (16 Modular Binding Rules)
- **Deterministic Machine Harness**: Autonomous execution governed by compiler, typecheck, and test gates (`~/.gemini/config/rules/deterministic-machine-harness.md`)
- **Autonomous Failure Modes Defense**: 10 anti-blunder invariants and circuit breaker (`~/.gemini/config/rules/autonomous-failure-modes.md`)
- **Agent Persona & Execution Invariants**: Objective technical mentor, autonomous single-stream execution, strict no-emoji (`~/.gemini/config/rules/agent-persona-invariants.md`)
- **Runtime Troubleshooting**: AGY error recovery protocol (`~/.gemini/config/rules/agy-runtime-troubleshooting.md`)
- **Inspection Gate**: Cari dulu baru terapkan & AST call-site scan (`~/.gemini/config/rules/inspect-before-apply.md`)
- **Verification Gate**: Empirical terminal proof exit code 0 (`~/.gemini/config/rules/empirical-verification.md`)
- **Safety Gate**: Hard-stop on sensitive areas (`~/.gemini/config/rules/sensitive-area-guard.md`) & Git push restriction (`~/.gemini/config/rules/git-push-restriction.md`)
- **Environment Topology**: Dual-mode laptop vs VPS decoupling & sovereign host discipline (`~/.gemini/config/rules/environment-topology.md`)
- **Hardware Topology**: Tri-node sovereign hardware cluster and burst worker constraints (`~/.gemini/config/rules/hardware-cluster-topology.md`)
- **System Diagnostics**: Periodic VPS & endpoint verification (`~/.gemini/config/rules/system-diagnostics.md`)
- **Code Style**: Ponytail / YAGNI minimalism & native-first (`~/.gemini/config/rules/ponytail-yagni.md`)
- **Architectural Proposal Protocol**: Autonomous local coding, RFC for major breaking changes only (`~/.gemini/config/rules/ai-proposal-protocol.md`)
- **Workflow Standard**: Modern Dual-Track Agentic Engineering & Machine Verification Harness (`~/.gemini/config/rules/workflow-ai-agent.md`)
- **Memory & RAG**: Obsidian 4-file governance (`~/.gemini/config/rules/obsidian-rag.md`)
- **MCP Discovery**: On-demand dual-file configuration protocol (`~/.gemini/config/rules/mcp-discovery.md`)
- **Communication**: Caveman terse high-density, strict no-emoji.

### Mandatory Cold-Start Protocol (Tier 1 RAG Bootstrap)
Before analyzing codebase or modifying code in any repository, ALL agents (AGY, Claude Code, OpenCode, Codex) MUST:
1. **Auto-Bind Namespace**: Resolve target namespace from CWD (e.g. `~/Projects/<repo>` -> `00-AGY-Memory/<repo>/`).
2. **Read Project Context & Traps**: Read `~/Documents/Obsidian Vault/00-AGY-Memory/<repo>/CONTEXT.md` to load architecture constraints and `## Known Gotchas & Environment Traps`.
3. **Pre-Flight ADR Scan**: Scan the last 10 ADRs in `~/Documents/Obsidian Vault/00-AGY-Memory/<repo>/DECISIONS.md` before planning or proposing architectural changes.
4. **Inspect Active State**: Check `~/Documents/Obsidian Vault/00-AGY-Memory/<repo>/STATE.md` for current milestone, commit checkpoint, and active invariants.

> [ NOTE ] Fresh clone without `~/.gemini` yet: authoritative fallback is `rules/` + `docs/` in this repo. Run `bash install.sh` to materialize `~/.gemini/config/`.

