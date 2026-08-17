# AI AGENT AUTONOMOUS ONBOARDING & BOOTSTRAP GUIDE

> **MANDATORY INSTRUCTION FOR ALL AI CODING AGENTS (AGY, CLAUDE CODE, OPENCODE, CODEX)**  
> When initialized on a fresh system, workspace, or VPS containing this repository, you MUST follow this protocol autonomously to configure the host environment.

---

## 1. PRIMARY BOOTSTRAP EXECUTION

Execute the master bootstrap script:
```bash
cd /path/to/sovereign-agent-os && bash scripts/bootstrap.sh
```

This autonomously handles:
1. System package verification (`git`, `ripgrep`, `jq`, `python3`, `node`, `npm`, `ssh`).
2. Directory structure creation (`~/.gemini/config/rules`, `~/.agents/skills`, `~/Projects`, `~/Documents/Obsidian Vault/00-AGY-Memory`).
3. Deployment of `GLOBAL_RULES.md` to `~/.gemini/GEMINI.md`, `~/.agents/GEMINI.md`, `~/.claude/CLAUDE.md`, `~/.opencode/OPENCODE.md`.
4. Global npm installation of filesystem, postgres, and git MCP servers.
5. Synchronization of 29 MCP servers across AGY, Claude Code, and OpenCode.
6. Execution of the environment diagnostic verification.

---

## 2. CROSS-AGENT PARITY & MULTI-AGENT SYNC

Whenever MCP endpoints or rules are modified, execute:
```bash
bash scripts/sync-agents.sh
```
This guarantees that **Antigravity CLI**, **Claude Code**, **OpenCode**, and **Codex** run with identical MCP servers, rules, and skills without manual intervention.

---

## 3. TRI-FORGE MULTI-REMOTE PROTOCOL

Every local git repository MUST be configured with a multi-remote push target named `all` pointing to:
1. GitHub (`git@github.com:zyekhabdul/<repo-name>.git`)
2. GitLab (`git@gitlab.com:aomiqaza/<repo-name>.git`)
3. Codeberg (`git@codeberg.org:aomiqaza/<repo-name>.git`)

To configure automatically:
```bash
bash scripts/setup-tri-push.sh /path/to/repo <repo-name>
```

---

## 4. OBSIDIAN RAG MEMORY GOVERNANCE

Every project repository MUST have a corresponding memory directory in:
`/home/fuckadmin/Documents/Obsidian Vault/00-AGY-Memory/<project-namespace>/`

Maintaining strictly 4 core files:
- `INDEX.md`: Metadata & latest git commit hash.
- `CONTEXT.md`: Architecture & stack overview.
- `STATE.md`: Active task status (updated at the end of every session).
- `DECISIONS.md`: Append-only Architectural Decision Records (ADR).

To scaffold automatically:
```bash
bash scripts/setup-rag.sh /path/to/repo <project-namespace>
```
