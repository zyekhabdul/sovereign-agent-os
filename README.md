# AI AGENT STANDARDS & TRI-FORGE ARCHITECTURE

Centralized governance, binding rules, master PRD templates, and multi-forge deployment guidelines for AI coding agents (Antigravity CLI `agy`, OpenCode, Codex, Claude Code).

---

## 1. Directory Structure

```
ai-agent-standards/
├── GLOBAL_RULES.md            # 11 Core Components & Universal Execution Guidelines
├── PRD-MASTER-TEMPLATE.md     # Mandatory PRD Template for all projects
├── rules/                     # Modular binding rule specifications
│   ├── ai-proposal-protocol.md # RFC standard for AI-initiated suggestions
│   ├── git-push-restriction.md # Strict permission control for remote pushes
│   ├── mcp-discovery.md        # Dual-file MCP discovery protocol
│   ├── obsidian-rag.md         # 4-File memory schema & namespace isolation
│   └── workflow-ai-agent.md    # Hyper-granular chunking & silent QA gates
├── templates/
│   └── mcp/
│       ├── mcp_config.template.json          # Sanitized base MCP server config
│       └── mcp_config_extended.template.json # Sanitized extended MCP server config
└── scripts/
    └── setup-tri-push.sh       # Automated multi-remote Git setup (GitHub + GitLab + Codeberg)
```

---

## 2. Quick Setup for a New Machine (VPS / Laptop)

1. Clone this repository:
   ```bash
   git clone git@github.com:zyekhabdul/ai-agent-standards.git ~/Projects/ai-agent-standards
   ```

2. Link global rules to agent configuration:
   ```bash
   mkdir -p ~/.gemini/config/rules
   cp ~/Projects/ai-agent-standards/rules/*.md ~/.gemini/config/rules/
   cp ~/Projects/ai-agent-standards/GLOBAL_RULES.md ~/.gemini/GEMINI.md
   ```

3. Setup MCP configuration from template:
   ```bash
   cp ~/Projects/ai-agent-standards/templates/mcp/mcp_config.template.json ~/.gemini/config/mcp_config.json
   cp ~/Projects/ai-agent-standards/templates/mcp/mcp_config_extended.template.json ~/.gemini/config/mcp_config_extended.json
   # Populate actual tokens locally or via environment variables
   ```

---

## 3. Tri-Forge Multi-Push Standard

To configure a repository to push simultaneously to GitHub, GitLab, and Codeberg in a single command (`git push all`):

```bash
./scripts/setup-tri-push.sh /path/to/repository <repo-name>
```
