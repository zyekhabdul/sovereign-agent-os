# AI AGENT AUTONOMOUS ONBOARDING & BOOTSTRAP GUIDE

> **MANDATORY INSTRUCTION FOR ALL AI CODING AGENTS (AGY, CLAUDE CODE, OPENCODE, CODEX)**  
> When initialized on a fresh system, workspace, or VPS containing this repository, you MUST follow this protocol autonomously to configure the host environment.

---

## 1. ONE-SHOT MASTER INSTALLATION

Execute the master setup installer:
```bash
bash install.sh
```

This autonomously and deterministically handles:
1. **CLI Tool Installation**: Copies `bin/agy-guard` to `~/.local/bin/agy-guard` (`chmod +x`).
2. **Directory Architecture**: Sets up `~/.gemini/config/rules/`, `~/.gemini/config/plugins/`, `~/.agents/skills/`, and `~/Documents/Obsidian Vault/00-AGY-Memory/`.
3. **16 Binding Rule Specs**: Deploys all 16 formal rules (`inspect-before-apply.md`, `empirical-verification.md`, `ponytail-yagni.md`, `sensitive-area-guard.md`, `ai-proposal-protocol.md`, `git-push-restriction.md`, `mcp-discovery.md`, `obsidian-rag.md`, `workflow-ai-agent.md`, `agent-persona-invariants.md`, `agy-runtime-troubleshooting.md`, `autonomous-failure-modes.md`, `deterministic-machine-harness.md`, `environment-topology.md`, `hardware-cluster-topology.md`, `system-diagnostics.md`).
4. **4-File GEMINI.md Parity & Cross-Agent Sync**: Synchronizes `~/GEMINI.md`, `~/.gemini/GEMINI.md`, `~/.gemini/config/GEMINI.md`, and `~/.agents/GEMINI.md` byte-for-byte, plus auto-configures Claude Code, OpenCode, and Codex.
5. **Active Plugins & Skills**: Deploys the production-grade engineering plugin `agent-skills` into `~/.gemini/config/plugins/` and syncs modular agent skills.
6. **Global Git Templates & Anti-Blunder Hooks**: Configures `~/.git-templates` with `pre-commit` (anti-blunder, anti-lazy truncation, anti-emoji, test guard), `post-commit` (auto-checkpoint), and `pre-push` (push interceptor) hooks.
7. **Empirical Status Verification**: Runs `agy-guard status` to confirm 100% compliance.

---

## 2. DAILY AGENT USAGE & COMMANDS

Once installed, AI agents must utilize `agy-guard` subcommands during normal workflows:

| Command | Function | Principle / Rule |
| :--- | :--- | :--- |
| `agy-guard prep` | Instant pre-flight onboarding (Branch, Dirty files, DoD, Decisions). | `inspect-before-apply.md` |
| `agy-guard verify` | Auto-detect stack & execute test/linter verification. | `empirical-verification.md` |
| `agy-guard diff-guard` | Audit diff radius and flag sensitive area modifications. | `sensitive-area-guard.md` |
| `agy-guard checkpoint` | Atomically log progress to `00-AGY-Memory/<ns>/STATE.md`. | `obsidian-rag.md` |
| `agy-guard push` | Execute safe human-authorized git push (`ALLOW_GIT_PUSH=1`). | `git-push-restriction.md` |
| `agy-guard status` | Full system audit of rules, MCPs, and memory limits. | `mcp-discovery.md` |

---

## 3. MULTI-FORGE REPOSITORY PROTOCOL (TRI-PUSH & PENTA-MIRROR)

Every project repository is synchronized to multi-remote endpoints:
- **GitHub**: `git@github.com:zyekhabdul/<repo-name>.git` (Primary)
- **GitLab**: `git@gitlab.com:aomiqaza/<repo-name>.git`
- **Codeberg**: `git@codeberg.org:aomiqaza/<repo-name>.git`
- **Gitea**: `git@gitea.com:aomiqaza/<repo-name>.git`
- **Bitbucket**: `git@bitbucket.org:aomiqaza/<repo-name>.git`

**Sovereign Architecture**:
- **Local Lean Tri-Push (Default)**: `all` routes to GitHub + GitLab (+ Codeberg for FOSS) for high speed and zero developer latency.
- **Server-Side Penta-Mirroring**: GitHub Actions (`.github/workflows/tri-mirror.yml`) automatically mirrors commits to all 5 platforms asynchronously upon push.
- **Direct Local Penta-Push (Optional)**: To bind all 5 platforms directly into local `all`, pass `--penta`.

To configure on any repo:
```bash
# Default Lean Tri-Push:
bash scripts/setup-tri-push.sh /path/to/repo <repo-name>

# Direct 5-Platform Penta-Push:
bash scripts/setup-tri-push.sh --penta /path/to/repo <repo-name>
# (or symlink: bash scripts/setup-penta-push.sh --penta /path/to/repo <repo-name>)
```

---

## 4. CREDENTIAL & SECRET MANAGEMENT PROTOCOL

**Golden Law: ZERO Plaintext Secrets in Sovereign Git Tree.**

All credentials, tokens, and keys must remain isolated outside version control using one of two sovereign methods:

### Method A: KeePass KDBX Database (Recommended)
- Store sensitive API keys (GitHub PAT, Tavily, Supabase, Postgres) in an encrypted KeePass database (e.g. `~/.keepass/sovereign-credentials.kdbx` or `~/.keepass/passwords.kdbx`).
- Inspect status:
  ```bash
  bash scripts/vault.sh kdbx-status [path/to/sovereign-credentials.kdbx]
  ```
- Inject tokens into active local MCP configs (`~/.gemini/config/mcp_config*.json`) and sync across all agent runtimes:
  ```bash
  bash scripts/vault.sh kdbx-inject [path/to/sovereign-credentials.kdbx]
  ```

### Method B: OpenSSL AES-256 Local Locker
- Local encrypted credential bundle encrypted with master passphrase:
  ```bash
  # Backup local MCP configs into encrypted vault.enc:
  bash scripts/vault.sh pack

  # Restore credentials on a new device:
  bash scripts/vault.sh unpack
  ```

