# AI AGENT STANDARDS & UNIVERSAL DEVELOPER BOOTSTRAP KIT

Centralized governance, binding rules, master PRD templates, project standards, and automated Tri-Forge multi-push deployment tooling for AI coding agents (Antigravity CLI `agy`, OpenCode, Codex, Claude Code).

---

## 1. Directory Structure

```
ai-agent-standards/
├── AI_BOOTSTRAP_GUIDE.md      # Autonomous setup instruction for AI Agents
├── GLOBAL_RULES.md            # 11 Core Components & Universal Execution Guidelines
├── PRD-MASTER-TEMPLATE.md     # Mandatory PRD Template for all projects
├── rules/                     # Modular binding rule specifications
│   ├── ai-proposal-protocol.md # RFC standard for AI-initiated suggestions
│   ├── git-push-restriction.md # Strict permission control for remote pushes
│   ├── mcp-discovery.md        # Dual-file MCP discovery protocol
│   ├── obsidian-rag.md         # 4-File memory schema & namespace isolation
│   └── workflow-ai-agent.md    # Hyper-granular chunking & silent QA gates
├── templates/
│   ├── git-hooks/             # Universal pre-commit hooks & emoji scanner
│   │   ├── pre-commit
│   │   └── check_emojis.py
│   ├── mcp/                   # Sanitized zero-secret MCP configuration templates
│   │   ├── mcp_config.template.json
│   │   └── mcp_config_extended.template.json
│   ├── projects/              # Dedicated project architecture standards
│   │   ├── STANDAR_ATURAN_AI_ZYEKH_COM.md
│   │   └── STANDAR_ATURAN_AI_SHOP_ZYEKH.md
│   └── rag/                   # Obsidian memory & ADR templates
│       └── ADR-TEMPLATE.md
└── scripts/
    ├── bootstrap.sh           # Universal environment & directory setup
    ├── install-mcps.sh        # Installs essential global npm MCP servers
    ├── setup-rag.sh           # Scaffolds 4-file Obsidian project memory
    └── setup-tri-push.sh      # Automated multi-remote Git setup (GitHub + GitLab + Codeberg)
```

---

## 2. Fast AI Bootstrapping on a Fresh Host (VPS / Laptop)

1. Clone this repository on the target machine:
   ```bash
   git clone git@github.com:zyekhabdul/ai-agent-standards.git ~/Projects/ai-agent-standards
   ```

2. Instruct your AI agent:
   > *"Baca `AI_BOOTSTRAP_GUIDE.md` di repo ini dan setup seluruh environment mesin ini."*

---

## 3. Manual Quick-Start Commands

### A. Initialize Machine Environment
```bash
bash scripts/bootstrap.sh
```

### B. Scaffold RAG Memory for a Project
```bash
bash scripts/setup-rag.sh <project-name> [repo-path]
```

### C. Setup Tri-Forge Multi-Push (GitHub + GitLab + Codeberg)
```bash
bash scripts/setup-tri-push.sh /path/to/repo [repo-name]
git push all <branch>
```
