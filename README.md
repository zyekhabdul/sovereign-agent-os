# SOVEREIGN AGENT OS (`sovereign-agent-os`)
> **The Sovereign Multi-Agent & Developer Runtime Environment**  
> *Universal Bootstrap, Cross-Agent Parity (AGY, Claude Code, OpenCode, Codex), 11 Core Components, Tri-Forge Mirroring, & Encrypted Secret Vault.*

---

## ARSITEKTUR REPOSITORI

```
sovereign-agent-os/
├── AI_BOOTSTRAP_GUIDE.md          # Autonomous Onboarding Guide for AI Agents
├── GLOBAL_RULES.md                # 11 Core Components & Binding Governance Rules
├── Dockerfile                     # Universal Containerized Linux Sandbox
├── docker-compose.yml             # Sandbox Compose Service Definition
├── .devcontainer/                 # VS Code & Cursor Devcontainer Integration
├── .github/workflows/             # Server-Side Tri-Forge Mirroring (GitHub -> GitLab + Codeberg)
├── .gitlab-ci.yml                 # GitLab CI Mirroring Pipeline
├── docs/                          # Master Tata Kelola Proyek
│   ├── GLOBAL-PROJECT-STANDARD.md # 7 Inti + 2 Wajib File Standards
│   ├── WORKFLOW-AI-AGENT-STANDARD.md # 6-Phase AI Execution Workflow
│   └── PRD-MASTER-TEMPLATE.md     # Master PRD Blueprint
├── rules/                         # 15 Modular Binding Directives
│   ├── agent-persona-invariants.md # Cognitive Persona & Autonomous Single-Stream
│   ├── agy-runtime-troubleshooting.md # AGY Error Recovery & Runtime Fixes
│   ├── ai-proposal-protocol.md    # RFC Standard for Breaking Architectural Changes
│   ├── autonomous-failure-modes.md # 10 Anti-Blunder Invariants & Circuit Breaker
│   ├── deterministic-machine-harness.md # Compiler, Typechecker, & Test Gates
│   ├── empirical-verification.md  # Terminal Verification & Zero-Test Trap Defense
│   ├── environment-topology.md    # Dual-Mode Topology & Sovereign VPS Discipline
│   ├── git-push-restriction.md    # Strict Remote Push Authorization
│   ├── inspect-before-apply.md    # Pre-Execution Inspection & AST Call-Site Scan
│   ├── mcp-discovery.md           # Dual-File MCP Discovery Protocol
│   ├── obsidian-rag.md            # 4-File Namespace Schema & RFC-RAG-003
│   ├── ponytail-yagni.md          # Minimalist Code Generation & Zero Bloat
│   ├── sensitive-area-guard.md    # Hard-Stop on Sensitive Surfaces
│   ├── system-diagnostics.md      # OS Diagnostics & Resource Invariants
│   └── workflow-ai-agent.md       # 5-Stage Autonomous Machine-Gated Workflow
├── plugins/
│   └── agent-skills/              # Core Agent Skills, Checklists, & Commands
├── templates/
│   ├── dotfiles/                  # SSH, Git, & Shell Aliases Templates
│   ├── git-hooks/                 # Pre-commit Hook & Emoji Guard
│   ├── mcp/                       # Sanitized Zero-Secret MCP Templates
│   ├── projects/                  # Project-Specific Rules
│   └── rag/                       # ADR & Memory Schemas
└── scripts/
    ├── bootstrap.sh               # Complete Machine & Environment Bootstrap
    ├── sync-agents.sh             # Cross-Agent Parity Syncer (AGY, Claude, OpenCode, Codex)
    ├── vault.sh                   # Encrypted Credential Locker (AES-256-CBC)
    ├── clone-velora.sh            # Instant Velora Workspace & Repo Manager
    ├── install-mcps.sh            # Global MCP Server Installer
    ├── install-rag-hooks.sh       # Post-Commit Auto-Sync Hook Installer
    ├── rag-lint.sh                # Obsidian RAG Integrity Linter
    ├── setup-penta-push.sh        # Git Multi-Push Remote Setup (5 Platforms)
    ├── setup-rag.sh               # 4-File Obsidian Memory Scaffolder
    ├── setup-tri-push.sh          # Git Multi-Push Remote Setup (3 Platforms)
    ├── sync-all-repos.sh          # Batch Git Multi-Push Mirroring
    └── verify-env.sh              # 17-Point Host Health Diagnostic
```

---

## PANDUAN PENGGUNAAN CEPAT (QUICK START)

### 1. Di Mesin / VPS Baru (Native)
```bash
git clone git@github.com:zyekhabdul/sovereign-agent-os.git ~/Projects/sovereign-agent-os
cd ~/Projects/sovereign-agent-os
bash install.sh
```

### 2. Di Lingkungan Docker / Sandbox
```bash
docker compose up -d
docker compose exec agent-os bash
```

### 3. Sinkronisasi Seluruh AI Agent (AGY, Claude Code, OpenCode, Codex)
```bash
bash scripts/sync-agents.sh
```

### 4. Mengunci & Membuka Vault Kredensial Terenkripsi
```bash
# Simpan kredensial aktif ke vault.enc terenkripsi
./scripts/vault.sh pack

# Pulihkan kredensial dari vault.enc di mesin baru
./scripts/vault.sh unpack
```

### 5. Multi-Platform Remote Push (GitHub + GitLab + Codeberg + Gitea + Bitbucket)
```bash
# Setup remote 'all' di repositori aktif
./scripts/setup-penta-push.sh

# Push ke 5 platform sekaligus
git push all main
```

---

## STATUS SINKRONISASI PENTA-FORGE (5 PLATFORMS)
- **GitHub**: `https://github.com/zyekhabdul/sovereign-agent-os`
- **GitLab**: `https://gitlab.com/aomiqaza/sovereign-agent-os`
- **Codeberg**: `https://codeberg.org/aomiqaza/sovereign-agent-os`
- **Gitea**: `https://gitea.com/aomiqaza/sovereign-agent-os`
- **Bitbucket**: `https://bitbucket.org/aomiqaza/sovereign-agent-os`
