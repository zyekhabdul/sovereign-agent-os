#!/usr/bin/env python3
"""JSON-safe placeholder injection for sovereign MCP configs (stdlib only).

Replaces ${GITHUB_PERSONAL_ACCESS_TOKEN} and ${TAVILY_API_KEY} in every
string value of a JSON document. Safe against hostile token characters
(| & / \\ " $ `) that break sed-based replacement.

Usage (env):
    TARGET_FILE_ENV=<path> GH_TOKEN_ENV=<token> TAVILY_KEY_ENV=<key> \
        python3 scripts/lib/vault_inject.py
Exit 1 on missing file or corrupted JSON. chmod 600 on success.
"""

import json
import os
import sys


def replace_placeholders(obj, gh, tavily):
    if isinstance(obj, dict):
        return {k: replace_placeholders(v, gh, tavily) for k, v in obj.items()}
    if isinstance(obj, list):
        return [replace_placeholders(v, gh, tavily) for v in obj]
    if isinstance(obj, str):
        if gh:
            obj = obj.replace("${GITHUB_PERSONAL_ACCESS_TOKEN}", gh)
        if tavily:
            obj = obj.replace("${TAVILY_API_KEY}", tavily)
        return obj
    return obj


def main():
    target = os.environ.get("TARGET_FILE_ENV", "")
    gh = os.environ.get("GH_TOKEN_ENV", "")
    tavily = os.environ.get("TAVILY_KEY_ENV", "")
    if not target or not os.path.isfile(target):
        print(f"[ SKIP ] vault_inject: target not found: {target}")
        return 0
    try:
        with open(target, encoding="utf-8") as fp:
            data = json.load(fp)
    except Exception as e:
        print(f"[ ERROR ] Corrupted MCP JSON, injection skipped for {target}: {e}")
        return 1
    data = replace_placeholders(data, gh, tavily)
    with open(target, "w", encoding="utf-8") as fp:
        json.dump(data, fp, indent=2)
    os.chmod(target, 0o600)
    return 0


if __name__ == "__main__":
    sys.exit(main())
