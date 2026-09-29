#!/usr/bin/env bash
# CI: setup-rag.sh + install-rag-hooks.sh are thin dispatchers to agy-guard.
# Isolated via fake HOME. Asserts:
#   setup-rag <ns> <repo>   -> namespace scaffolded with checkpoint schema
#   setup-rag <ns> (missing path) -> still scaffolds (HOME fallback)
#   setup-rag --all         -> batch scaffolds, skips third-party? (scaffold has no skip; repos included)
#   install-rag-hooks.sh    -> guard post-commit hook installed, third-party skipped
set -uo pipefail

# NOTE: fake HOME must live under the real HOME, not /tmp: agy-guard's
# boundary guard rejects /tmp and out-of-HOME directories by design.
REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export PATH="$REPO_ROOT/bin:$PATH"
REAL_HOME="$HOME"
export T_BASE="$REAL_HOME/.sov-ci-rag-$$"
export T_HOME="$T_BASE/home"
mkdir -p "$T_HOME"
export HOME="$T_HOME"
trap 'rm -rf "$T_BASE"' EXIT

git config --global user.email "ci@sovereign.test" 2>/dev/null || true
git config --global user.name "ci" 2>/dev/null || true
git config --global init.defaultBranch master 2>/dev/null || true
mkdir -p "$HOME/Documents/Obsidian Vault"

PASS=0
FAIL=0
ok()   { echo "  [ PASS ] $1"; PASS=$((PASS + 1)); }
bad()  { echo "  [ FAIL ] $1"; FAIL=$((FAIL + 1)); }

# --- setup-rag single (existing repo) ---
mkdir -p "$T_HOME/myproj" && git -C "$T_HOME/myproj" init -q
bash "$REPO_ROOT/scripts/setup-rag.sh" myproj "$T_HOME/myproj" >/dev/null 2>&1
if [ -f "$T_HOME/Documents/Obsidian Vault/00-AGY-Memory/myproj/STATE.md" ]; then
  grep -q "Invariant Checks" "$T_HOME/Documents/Obsidian Vault/00-AGY-Memory/myproj/STATE.md" \
    && ok "setup-rag single: checkpoint schema scaffolded" \
    || bad "setup-rag single: wrong schema (want checkpoint dialect)"
else
  bad "setup-rag single: STATE.md missing"
fi

# --- setup-rag single (missing path -> HOME fallback) ---
bash "$REPO_ROOT/scripts/setup-rag.sh" ghostns "$T_HOME/does-not-exist" >/dev/null 2>&1
[ -f "$T_HOME/Documents/Obsidian Vault/00-AGY-Memory/ghostns/STATE.md" ] \
  && ok "setup-rag missing path: HOME fallback scaffolds" \
  || bad "setup-rag missing path: nothing scaffolded"

# --- setup-rag --all ---
mkdir -p "$T_HOME/Projects" && git -C "$T_HOME/myproj" rev-parse >/dev/null 2>&1
mkdir -p "$T_HOME/Projects/a-proj" && git -C "$T_HOME/Projects/a-proj" init -q
PROJECTS_DIR="$T_HOME/Projects" bash "$REPO_ROOT/scripts/setup-rag.sh" --all >/dev/null 2>&1
[ -f "$T_HOME/Documents/Obsidian Vault/00-AGY-Memory/a-proj/STATE.md" ] \
  && ok "setup-rag --all: batch scaffolds" \
  || bad "setup-rag --all: namespace missing"

# --- install-rag-hooks.sh (guard hook + third-party skip) ---
mkdir -p "$T_HOME/oc" && git -C "$T_HOME/oc" init -q
git -C "$T_HOME/oc" remote add origin git@github.com:zyekhabdul/oc.git
mkdir -p "$T_HOME/vendor" && git -C "$T_HOME/vendor" init -q
git -C "$T_HOME/vendor" remote add origin https://github.com/someone/vendor.git
OUT=$(PROJECTS_DIR="$T_HOME" bash "$REPO_ROOT/scripts/install-rag-hooks.sh" 2>&1)
echo "$OUT" | grep -q "SKIP.*vendor" && ok "install-rag-hooks: third-party skipped" || bad "install-rag-hooks: skip missing"
grep -q "agy-guard checkpoint" "$T_HOME/oc/.git/hooks/post-commit" 2>/dev/null \
  && ok "install-rag-hooks: guard hook installed" || bad "install-rag-hooks: wrong hook content"
[ ! -f "$T_HOME/vendor/.git/hooks/post-commit" ] || grep -q "agy-guard checkpoint" "$T_HOME/vendor/.git/hooks/post-commit" 2>/dev/null \
  && ok "install-rag-hooks: vendor hook withheld-or-absent" || bad "install-rag-hooks: vendor got foreign hook"

echo "=== RAG WRAPPERS: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ]
