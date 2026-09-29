#!/usr/bin/env bash
set -euo pipefail

# sync-agents.sh — Cross-Agent Configuration & MCP Parity Syncer
# Ensures Antigravity (AGY), Claude Code, OpenCode, and Codex share identical rules, skills, and MCP endpoints.
# Usage: ./sync-agents.sh [--dry-run]
#   --dry-run: print planned actions without writing anything.

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
fi

echo "======================================================"
echo "      CROSS-AGENT CONFIGURATION PARITY SYNCER         "
if [ "$DRY_RUN" = true ]; then
  echo "      [ DRY-RUN MODE: no writes will be performed ]    "
fi
echo "======================================================"

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=""
for _cand in "$SCRIPT_DIR/.." "$HOME/Projects/sovereign-agent-os"; do
  if [ -f "$_cand/GLOBAL_RULES.md" ]; then REPO_ROOT=$(cd "$_cand" && pwd); break; fi
done
[ -z "$REPO_ROOT" ] && REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
GEMINI_DIR="$HOME/.gemini"
CLAUDE_DIR="$HOME/.claude"
OPENCODE_DIR="$HOME/.opencode"
CODEX_DIR="$HOME/.codex"
AGENTS_DIR="$HOME/.agents"

# 0. Snapshot existing agent configs (rollback safety, skipped on dry-run)
BACKUP_BASE="$HOME/.config/sovereign-backup"
if [ "$DRY_RUN" = true ]; then
  echo "[ 1/5 ] [ DRY-RUN ] Would snapshot existing configs to $BACKUP_BASE/<timestamp>/"
else
  BACKUP_DIR="$BACKUP_BASE/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  for _cfg in "$HOME/.claude.json" "$HOME/.opencode/opencode.json" "$HOME/.config/opencode/opencode.json" "$HOME/.codex/config.toml" "$HOME/.config/antigravity/mcp_config.json"; do
    if [ -f "$_cfg" ]; then
      cp -v "$_cfg" "$BACKUP_DIR/$(echo "$_cfg" | tr '/' '_')" 2>/dev/null || true
    fi
  done
  echo "[ 1/5 ] Pre-sync snapshot saved to $BACKUP_DIR (pruned to newest 5)"
  ls -dt "$BACKUP_BASE"/*/ 2>/dev/null | tail -n +6 | xargs -r rm -rf 2>/dev/null || true
fi

# 1. Ensure Agent Directories
echo "[ 2/5 ] Creating multi-agent directory structures..."
if [ "$DRY_RUN" = true ]; then
  echo "  [ DRY-RUN ] Would mkdir: $GEMINI_DIR/config/rules $GEMINI_DIR/config/plugins $CLAUDE_DIR $OPENCODE_DIR/skills $CODEX_DIR $AGENTS_DIR/skills"
else
  mkdir -p "$GEMINI_DIR/config/rules" "$GEMINI_DIR/config/plugins"
  mkdir -p "$CLAUDE_DIR"
  mkdir -p "$OPENCODE_DIR/skills"
  mkdir -p "$CODEX_DIR"
  mkdir -p "$AGENTS_DIR/skills"
fi

# 2. Sync Global Binding Rules across all agents
echo "[ 3/5 ] Synchronizing global rules across agent environments..."
if [ "$DRY_RUN" = true ]; then
  echo "  [ DRY-RUN ] Would copy GLOBAL_RULES.md to ~/GEMINI.md, ~/.gemini/GEMINI.md, ~/.gemini/config/GEMINI.md, ~/.agents/GEMINI.md, ~/.claude/CLAUDE.md, ~/.opencode/OPENCODE.md, ~/.codex/CODEX.md"
  echo "  [ DRY-RUN ] Would copy rules/*.md to $GEMINI_DIR/config/rules/"
else
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$HOME/GEMINI.md"
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$GEMINI_DIR/GEMINI.md"
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$GEMINI_DIR/config/GEMINI.md"
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$AGENTS_DIR/GEMINI.md"
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null || true
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$OPENCODE_DIR/OPENCODE.md" 2>/dev/null || true
  cp -v "$REPO_ROOT/GLOBAL_RULES.md" "$CODEX_DIR/CODEX.md" 2>/dev/null || true
fi

# 3. Sync Rules folder
if [ "$DRY_RUN" = true ]; then
  echo "  [ DRY-RUN ] (covered above)"
elif [ -d "$REPO_ROOT/rules" ]; then
  cp -v "$REPO_ROOT/rules/"*.md "$GEMINI_DIR/config/rules/"
fi

# 4. Generate Claude Code & OpenCode MCP Configurations
echo "[ 4/5 ] Generating unified MCP configurations (Claude Code, OpenCode, Codex, Antigravity)..."
if [ "$DRY_RUN" = true ]; then
  export SOV_DRY_RUN=1
  echo "  [ DRY-RUN ] Would merge MCP servers into ~/.claude.json, ~/.opencode/opencode.json, ~/.config/opencode/opencode.json, ~/.codex/config.toml, ~/.config/antigravity/mcp_config.json"
fi
python3 - << 'EOF'
import os, json, re
DRY = os.environ.get("SOV_DRY_RUN") == "1"

gemini_mcp = os.path.expanduser("~/.gemini/config/mcp_config.json")
gemini_ext = os.path.expanduser("~/.gemini/config/mcp_config_extended.json")
claude_cfg = os.path.expanduser("~/.claude.json")
opencode_cfg = os.path.expanduser("~/.opencode/opencode.json")

all_servers = {}

for f in [gemini_mcp, gemini_ext]:
    if os.path.exists(f):
        try:
            with open(f) as fp:
                d = json.load(fp)
                servers = d.get("mcpServers", {})
                for k, v in servers.items():
                    all_servers[k] = v
        except Exception as e:
            print(f"Warn: failed to parse {f}: {e}")

# 1. Update ~/.claude.json (merge-safe: preserve user servers not managed here)
if all_servers:
    claude_data = {}
    if os.path.exists(claude_cfg):
        try:
            with open(claude_cfg) as fp:
                claude_data = json.load(fp)
        except:
            claude_data = {}
    existing_servers = claude_data.get("mcpServers", {})
    if not isinstance(existing_servers, dict):
        existing_servers = {}
    existing_servers.update(all_servers)
    claude_data["mcpServers"] = existing_servers
    if DRY:
        print(f"  [ DRY-RUN ] Would write {claude_cfg} ({len(all_servers)} servers).")
    else:
        with open(claude_cfg, "w") as fp:
            json.dump(claude_data, fp, indent=2)
        os.chmod(claude_cfg, 0o600)
        print(f"  [ PASS ] Merged ~/.claude.json with {len(all_servers)} MCP servers (preserved {len(existing_servers) - len(all_servers)} user entries).")

# 2. Update ~/.opencode/opencode.json & ~/.config/opencode/opencode.json (merge-safe)
    opencode_mcp = {}
    for name, srv in all_servers.items():
        cmd = srv.get("command", "")
        args = srv.get("args", [])
        if isinstance(cmd, list):
            full_cmd = cmd
        elif isinstance(args, list) and args:
            full_cmd = [cmd] + args
        elif cmd:
            full_cmd = [cmd]
        else:
            full_cmd = []

        env = srv.get("env", {})
        if not isinstance(env, dict):
            env = {}

        entry = {
            "type": "local",
            "command": full_cmd,
            "enabled": False
        }
        if env:
            entry["environment"] = env
        opencode_mcp[name] = entry

    home_dir = os.path.expanduser("~")
    managed_defaults = {
        "$schema": "https://opencode.ai/config.json",
        "instructions": [
            os.path.join(home_dir, ".opencode/OPENCODE.md"),
            os.path.join(home_dir, ".gemini/config/rules/agent-persona-invariants.md"),
            os.path.join(home_dir, ".gemini/config/rules/ponytail-yagni.md"),
            os.path.join(home_dir, ".gemini/config/rules/deterministic-machine-harness.md")
        ],
        "skills": {
            "paths": [
                os.path.join(home_dir, ".opencode/skills"),
                os.path.join(home_dir, ".config/opencode/skills")
            ]
        },
        "tool_output": {
            "max_lines": 200,
            "max_bytes": 16384
        },
        "compaction": {
            "auto": True,
            "tail_turns": 15
        }
    }

    for target_path in [opencode_cfg, os.path.expanduser("~/.config/opencode/opencode.json")]:
        if not DRY:
            os.makedirs(os.path.dirname(target_path), exist_ok=True)
        existing_data = {}
        if os.path.exists(target_path):
            try:
                with open(target_path) as fp:
                    existing_data = json.load(fp)
                if not isinstance(existing_data, dict):
                    existing_data = {}
            except:
                existing_data = {}
        existing_mcp = existing_data.get("mcp", {})
        if not isinstance(existing_mcp, dict):
            existing_mcp = {}
        for name, entry in opencode_mcp.items():
            if name in existing_mcp and isinstance(existing_mcp[name], dict) and "enabled" in existing_mcp[name]:
                entry["enabled"] = existing_mcp[name]["enabled"]
        merged_mcp = {**existing_mcp, **opencode_mcp}
        existing_data["mcp"] = merged_mcp
        for k, v in managed_defaults.items():
            existing_data.setdefault(k, v)
        if DRY:
            print(f"  [ DRY-RUN ] Would write {target_path} ({len(merged_mcp)} entries).")
        else:
            with open(target_path, "w") as fp:
                json.dump(existing_data, fp, indent=2)
            os.chmod(target_path, 0o600)
            print(f"  [ PASS ] Merged {target_path} (preserved user mcp enabled flags, Hybrid MVO: new servers disabled by default).")

# 3. Update ~/.codex/config.toml (first-class parity, merge-safe managed block)
    codex_cfg = os.path.expanduser("~/.codex/config.toml")
    if not DRY:
        os.makedirs(os.path.dirname(codex_cfg), exist_ok=True)

    def toml_esc(s):
        return (str(s).replace("\\", "\\\\").replace('"', '\\"')
                .replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r"))

    def norm_id(raw):
        raw = raw.strip()
        if len(raw) >= 2 and raw[0] == raw[-1] and raw[0] in ('"', "'"):
            raw = raw[1:-1]
        return raw.replace('\\"', '"').replace("\\\\", "\\")

    prev_enabled = set()
    prev_text = ""
    old_block = None
    if os.path.exists(codex_cfg):
        try:
            with open(codex_cfg) as fp:
                prev_text = fp.read()
            m = re.search(r"# BEGIN SOVEREIGN MANAGED MCP.*?# END SOVEREIGN MANAGED MCP", prev_text, re.DOTALL)
            if m:
                old_block = m.group(0)
                for em in re.finditer(r'\[mcp_servers\.((?:"(?:[^"\\]|\\.)*")|(?:[A-Za-z0-9_-]+))\]((?:(?!\n\[)[\s\S])*?)enabled\s*=\s*true', old_block):
                    prev_enabled.add(norm_id(em.group(1)))
        except Exception as e:
            print(f"Warn: failed to parse {codex_cfg}: {e}")

    base_text = prev_text
    if old_block:
        base_text = base_text.replace(old_block, "")
    user_owned = set()
    for um in re.finditer(r"^[ \t]*\[mcp_servers\.([^\]]+)\]", base_text, re.MULTILINE):
        user_owned.add(norm_id(um.group(1)))

    managed = ["# BEGIN SOVEREIGN MANAGED MCP (sync-agents.sh: do not edit inside this block)"]
    skipped = 0
    for name, srv in all_servers.items():
        if name in user_owned:
            skipped += 1
            continue
        cmd = srv.get("command", "")
        args = srv.get("args", [])
        if isinstance(cmd, list):
            full = cmd
            cmd = full[0] if full else ""
            args = full[1:] + (args if isinstance(args, list) else [])
        if not isinstance(args, list):
            args = []
        env = srv.get("env", {})
        if not isinstance(env, dict):
            env = {}
        esc = toml_esc(name)
        managed.append(f'[mcp_servers."{esc}"]')
        if srv.get("url") and not cmd:
            managed.append(f'url = "{toml_esc(srv["url"])}"')
        else:
            managed.append(f'command = "{toml_esc(cmd)}"')
            if args:
                managed.append("args = [" + ", ".join(f'"{toml_esc(a)}"' for a in args) + "]")
        if env:
            pairs = ", ".join(f'"{toml_esc(k)}" = "{toml_esc(v if isinstance(v, str) else str(v))}"' for k, v in env.items())
            managed.append("env = { " + pairs + " }")
        managed.append(f'enabled = {"true" if esc in prev_enabled else "false"}')
        managed.append("")
    managed.append("# END SOVEREIGN MANAGED MCP")
    managed_block = "\n".join(managed) + "\n"

    new_text = (base_text.rstrip() + "\n\n" if base_text.strip() else "") + managed_block
    added = len(all_servers) - skipped
    if DRY:
        print(f"  [ DRY-RUN ] Would write {codex_cfg}: {added} managed, {skipped} user-owned skipped.")
    else:
        with open(codex_cfg, "w") as fp:
            fp.write(new_text)
        os.chmod(codex_cfg, 0o600)
        print(f"  [ PASS ] Merged {codex_cfg}: {added} managed, {skipped} user-owned skipped (single declaration guaranteed).")

# 4. Update ~/.config/antigravity/mcp_config.json
    antigravity_cfg = os.path.expanduser("~/.config/antigravity/mcp_config.json")
    if os.path.exists(os.path.dirname(antigravity_cfg)):
        if DRY:
            print(f"  [ DRY-RUN ] Would write {antigravity_cfg} ({len(all_servers)} servers).")
        else:
            with open(antigravity_cfg, "w") as fp:
                json.dump({"mcpServers": all_servers}, fp, indent=2)
            os.chmod(antigravity_cfg, 0o600)
            print(f"  [ PASS ] Updated ~/.config/antigravity/mcp_config.json with {len(all_servers)} MCP servers.")

EOF

# 5. Sync Agent Skills
echo "[ 5/5 ] Synchronizing Agent Skills & 16 Core Components & Binding Rules..."
if [ "$DRY_RUN" = true ]; then
  echo "  [ DRY-RUN ] Would copy agent-skills to $AGENTS_DIR/skills/ and $OPENCODE_DIR/skills/"
elif [ -d "$REPO_ROOT/plugins/agent-skills/skills" ]; then
  cp -r "$REPO_ROOT/plugins/agent-skills/skills/"* "$AGENTS_DIR/skills/" 2>/dev/null || true
  cp -r "$REPO_ROOT/plugins/agent-skills/skills/"* "$OPENCODE_DIR/skills/" 2>/dev/null || true
fi

echo "======================================================"
echo "[ SUCCESS ] Multi-Agent Parity Synchronized!"
echo "AGY, Claude Code, OpenCode, and Codex are 100% aligned."
echo "======================================================"
