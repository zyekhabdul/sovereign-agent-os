#!/usr/bin/env bash
# CI: sync-agents.sh Codex TOML writer, black-box under fake HOME.
# Asserts: valid TOML, edge-case names/values round-trip, url-server support,
# user-owned tables win (single declaration), enabled=true preserved,
# re-sync idempotent, --dry-run writes nothing.
set -uo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export T_HOME="$(mktemp -d)"
export HOME="$T_HOME"
trap 'rm -rf "$T_HOME"' EXIT

PASS=0
FAIL=0
ok()   { echo "  [ PASS ] $1"; PASS=$((PASS + 1)); }
bad()  { echo "  [ FAIL ] $1"; FAIL=$((FAIL + 1)); }

mkdir -p "$HOME/.gemini/config" "$HOME/.codex"
cat > "$HOME/.gemini/config/mcp_config.json" << 'JSON'
{"mcpServers": {
  "plain": {"command": "node", "args": ["a.js"]},
  "weird\"q\\b sp.dot": {"command": "npx", "args": ["-y", "pkg"], "env": {"K": "v"}},
  "hostile-env": {"command": "node", "env": {"T": "a|b&c/d\\e\"f$g`h"}},
  "http-srv": {"url": "https://mcp.example.com/rpc"},
  "github": {"command": "SHOULD-NOT-WIN", "args": []}
}}
JSON
echo '{"mcpServers": {}}' > "$HOME/.gemini/config/mcp_config_extended.json"
printf '[mcp_servers.github]\ncommand = "user-node"\nargs = ["keep.js"]\nenabled = true\n\n[other]\nfoo = 1\n' > "$HOME/.codex/config.toml"

bash "$REPO_ROOT/scripts/sync-agents.sh" >/dev/null 2>&1
python3 -c "import tomllib, os; tomllib.load(open(os.environ['T_HOME'] + '/.codex/config.toml','rb'))" 2>/dev/null \
  && ok "output is valid TOML" || bad "output TOML invalid"

python3 - << 'PYEOF'
import os, sys, tomllib
d = tomllib.load(open(os.environ['T_HOME'] + '/.codex/config.toml', 'rb'))
s = d.get('mcp_servers', {})
checks = [
    ('plain' in s, 'plain server present'),
    (s.get('weird"q\\b sp.dot', {}).get('args') == ['-y', 'pkg'], 'weird name round-trip'),
    (s.get('hostile-env', {}).get('env', {}).get('T') == 'a|b&c/d\\e"f$g`h', 'hostile env round-trip'),
    (s.get('http-srv', {}).get('url') == 'https://mcp.example.com/rpc', 'url-server support'),
    (s.get('github', {}).get('command') == 'user-node', 'user-owned table wins'),
    (s.get('github', {}).get('enabled') is True, 'user-owned enabled kept'),
    ('other' in d, 'unrelated user config preserved'),
]
failed = [m for c, m in checks if not c]
for c, m in checks:
    print(('  [ PASS ] ' if c else '  [ FAIL ] ') + 'codex: ' + m)
sys.exit(1 if failed else 0)
PYEOF
if [ $? -eq 0 ]; then ok "edge-case assertions green"; else FAIL=$((FAIL + 1)); fi

# enabled=true preservation inside managed block
python3 - << 'PYEOF'
import os, re
p = os.environ['T_HOME'] + '/.codex/config.toml'
t = open(p).read()
t2, n = re.subn(r'(\[mcp_servers\."plain"\](?:(?!\n\[)[\s\S])*?)enabled\s*=\s*false', r'\1enabled = true', t, count=1)
assert n == 1, 'flip target not found'
open(p, 'w').write(t2)
PYEOF
bash "$REPO_ROOT/scripts/sync-agents.sh" >/dev/null 2>&1
python3 -c "
import tomllib, os
d = tomllib.load(open(os.environ['T_HOME'] + '/.codex/config.toml','rb'))
assert d['mcp_servers']['plain'].get('enabled') is True, 'enabled flag lost'
" 2>/dev/null && ok "managed enabled=true preserved" || bad "managed enabled=true not preserved"

# idempotency (snapshot kept inside fake HOME so trap cleans it)
cp "$HOME/.codex/config.toml" "$HOME/.codex/config.run2.toml"
bash "$REPO_ROOT/scripts/sync-agents.sh" >/dev/null 2>&1
cmp -s "$HOME/.codex/config.toml" "$HOME/.codex/config.run2.toml" \
  && ok "re-sync idempotent" || bad "re-sync not idempotent"
rm -f "$HOME/.codex/config.run2.toml"

# dry-run (no pipe: grep -q exits early -> SIGPIPE 141 under pipefail)
BEFORE=$(find "$HOME" -type f | sort | xargs md5sum 2>/dev/null | md5sum)
DRY_OUT=$(bash "$REPO_ROOT/scripts/sync-agents.sh" --dry-run 2>&1)
if [[ "$DRY_OUT" == *"DRY-RUN"* ]]; then ok "--dry-run announces itself"; else bad "--dry-run banner missing"; fi
AFTER=$(find "$HOME" -type f | sort | xargs md5sum 2>/dev/null | md5sum)
[ "$BEFORE" = "$AFTER" ] && ok "--dry-run writes nothing" || bad "--dry-run mutated files"

echo "=== CODEX BLACKBOX: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ]
