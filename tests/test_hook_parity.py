#!/usr/bin/env python3
"""CI: embedded hook scripts must equal templates/git-hooks/* (SSOT).

templates/ is source of truth; agy-guard loads it at runtime
(load_*_script) with the embedded constants as offline fallback.
Fails on any drift. Covers pre-commit, post-commit, pre-push.
"""

import difflib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

HOOKS = {
    "pre-commit": "PRE_COMMIT_SCRIPT",
    "post-commit": "POST_COMMIT_SCRIPT",
    "pre-push": "PRE_PUSH_SCRIPT",
}


def extract(src, const):
    m = re.search(re.escape(const) + ' = r?"""(.*?)"""\n', src, re.DOTALL)
    return m.group(1).strip() + "\n" if m else None


def main():
    src = (ROOT / "bin" / "agy-guard").read_text(encoding="utf-8")
    failures = []
    for name, const in HOOKS.items():
        embedded = extract(src, const)
        if embedded is None:
            failures.append(f"{const} block not found in bin/agy-guard")
            continue
        template = (ROOT / "templates" / "git-hooks" / name).read_text(encoding="utf-8").strip() + "\n"
        if embedded != template:
            failures.append(f"{name}: embedded != template")
            for line in list(difflib.unified_diff(
                    embedded.splitlines(), template.splitlines(),
                    f"bin/agy-guard:{const}", f"templates/git-hooks/{name}"))[:15]:
                print("  " + line)
    if "SOVEREIGN_TIER" not in src or "sovereign_warn" not in src:
        failures.append("tier engine tokens missing from pre-commit path")
    for loader in ["load_pre_commit_script()", "load_post_commit_script()", "load_pre_push_script()"]:
        if src.count(loader) < 3:  # def + call sites
            failures.append(f"{loader} not wired (want >=3 refs)")
    if failures:
        for f in failures:
            print("[ FAIL ]", f)
        return 1
    print("[ PASS ] Hook parity x3: embedded == template, loaders wired.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
