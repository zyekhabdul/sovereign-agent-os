#!/usr/bin/env python3
"""CI: scripts/lib/vault_inject.py survives hostile token characters.

Covers: | & / backslash " $ backtick newline (all break naive sed),
corrupted JSON (exit 1), missing file (exit 0 SKIP), chmod 600.
"""

import json
import os
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LIB = ROOT / "scripts" / "lib" / "vault_inject.py"

HOSTILE_GH = 'ghp_A|B&C/D\\E"F$G`H\nI'
HOSTILE_TAV = 'tvly|X&Y/Z"${PWN}"'


def run_inject(target, gh, tavily):
    env = dict(os.environ)
    env["TARGET_FILE_ENV"] = str(target)
    env["GH_TOKEN_ENV"] = gh
    env["TAVILY_KEY_ENV"] = tavily
    return subprocess.run([sys.executable, str(LIB)], env=env,
                          capture_output=True, text=True)


def main():
    failures = []

    with tempfile.TemporaryDirectory() as td:
        target = Path(td) / "mcp_config.json"
        payload = {"mcpServers": {
            "github": {"command": "node", "env": {"GITHUB_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"}},
            "tav": {"apiKey": "${TAVILY_API_KEY}", "nested": ["${TAVILY_API_KEY}", 42, None]},
        }}
        target.write_text(json.dumps(payload), encoding="utf-8")

        r = run_inject(target, HOSTILE_GH, HOSTILE_TAV)
        if r.returncode != 0:
            failures.append(f"hostile inject exited {r.returncode}: {r.stdout} {r.stderr}")
        else:
            out = json.loads(target.read_text(encoding="utf-8"))
            if out["mcpServers"]["github"]["env"]["GITHUB_TOKEN"] != HOSTILE_GH:
                failures.append("GH token round-trip mismatch")
            if out["mcpServers"]["tav"]["apiKey"] != HOSTILE_TAV:
                failures.append("Tavily key round-trip mismatch")
            if out["mcpServers"]["tav"]["nested"][1:] != [42, None]:
                failures.append("non-string values mutated")
            mode = stat.S_IMODE(target.stat().st_mode)
            if mode != 0o600:
                failures.append(f"chmod {oct(mode)} != 0o600")

        bad = Path(td) / "bad.json"
        bad.write_text("{not json", encoding="utf-8")
        r = run_inject(bad, "x", "y")
        if r.returncode != 1:
            failures.append(f"corrupted JSON exited {r.returncode}, want 1")

        r = run_inject(Path(td) / "nope.json", "x", "y")
        if r.returncode != 0 or "SKIP" not in r.stdout:
            failures.append("missing file should exit 0 with SKIP")

    if failures:
        for f in failures:
            print("[ FAIL ]", f)
        return 1
    print("[ PASS ] vault_inject: hostile round-trip OK, corrupted=1, missing=SKIP, chmod 600.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
