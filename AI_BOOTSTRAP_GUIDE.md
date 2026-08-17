# AI AGENT BOOTSTRAP & SYSTEM SETUP INSTRUCTION

> **Target Audience**: AI Coding Agents (AGY Antigravity CLI, OpenCode, Codex, Claude Code, Cursor) running on a newly provisioned machine (VPS, container, or developer workstation).
> **Objective**: Read this document and execute the autonomous environment setup sequence to bring the host to full sovereign development standard.

---

## 1. IDENTITY & GOVERNANCE ACKNOWLEDGMENT
Before executing any shell commands or modifying files, you MUST acknowledge and strictly internalize:
1. **11 Active Components**: Ponytail (YAGNI), Serena, Caveman, Codegraph, Contextmode, Headroom, RTK, Graphify, Delphitools, Skills, MCP.
2. **Objective Mentor Persona**: Zero pleasantries, zero fluff, direct, concise, empirical solutions.
3. **Strict No-Emoji Standard**: All generated code, templates, and markdown files must remain 100% free of graphical emojis.
4. **Strict Git Push Permission Control**: `git commit` is permitted locally; `git push` is STRICTLY PROHIBITED unless explicitly commanded by the user.

---

## 2. AUTONOMOUS HOST BOOTSTRAP SEQUENCE

When instructed to "Setup this machine" or "Bootstrap environment", execute the following sequence in order:

### Step 1: Run Environment Initializer
```bash
# Execute universal bootstrap script (creates directory tree, links global rules, installs MCPs)
bash scripts/bootstrap.sh
```

### Step 2: Configure Model Context Protocol (MCP)
1. Verify dual config files exist at `~/.gemini/config/mcp_config.json` and `~/.gemini/config/mcp_config_extended.json`.
2. If missing, copy from `templates/mcp/` and prompt the user securely for required API keys (GitHub, GitLab, Codeberg, etc.) without printing tokens to stdout.
3. Verify MCP servers function via standard CLI inspection.

### Step 3: Scaffold Project RAG Memory (Obsidian Vault)
For every active project repository under `~/Projects/<repo-name>`:
```bash
# Scaffold the 4-file memory schema (INDEX, CONTEXT, STATE, DECISIONS)
bash scripts/setup-rag.sh <repo-name> ~/Projects/<repo-name>
```

### Step 4: Configure Tri-Forge Multi-Push Remotes
For every git project requiring high-availability multi-forge mirroring:
```bash
# Setup remote 'all' pointing to GitHub (zyekhabdul), GitLab (aomiqaza), Codeberg (aomiqaza)
bash scripts/setup-tri-push.sh ~/Projects/<repo-name> <repo-name>
```

---

## 3. PROJECT DEVELOPMENT RULES INJECTION
When working on a specific project type, inject the dedicated project rule into the repo root as `GEMINI.md`:
- **Static Engineering Portfolio / Tools / Web**:
  Copy `templates/projects/STANDAR_ATURAN_AI_ZYEKH_COM.md` -> `<project-root>/GEMINI.md`
- **Shopify Liquid 2.0 E-Commerce Theme**:
  Copy `templates/projects/STANDAR_ATURAN_AI_SHOP_ZYEKH.md` -> `<project-root>/GEMINI.md`
- **Pre-Commit Quality Gate**:
  Copy `templates/git-hooks/pre-commit` -> `<project-root>/.git/hooks/pre-commit` (`chmod +x`)
  Copy `templates/git-hooks/check_emojis.py` -> `<project-root>/check_emojis.py`

---

## 4. VERIFICATION DEFINITION OF DONE
- [ ] Directory `~/.gemini/config/rules/` contains all 5 modular rule files.
- [ ] `~/.gemini/GEMINI.md` contains 11 active core components.
- [ ] MCP servers installed globally via npm.
- [ ] Obsidian Vault `~/Documents/Obsidian Vault/00-AGY-Memory/` initialized.
- [ ] All pre-commit hooks executable (`chmod +x`).
