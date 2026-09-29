#!/usr/bin/env bash
# CI: pre-commit strictness tier matrix (strict | standard | passthrough).
# Isolated via fake HOME. Asserts:
#   strict      -> >150-line diff HARDBLOCK (exit != 0, no commit)
#   standard    -> >150-line diff WARN + commit lands; test+source co-mod WARN + lands
#   passthrough -> hook SKIP + commit lands
set -uo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export PATH="$REPO_ROOT/bin:$PATH"
export T_HOME="$(mktemp -d)"
export HOME="$T_HOME"
trap 'rm -rf "$T_HOME"' EXIT

git config --global user.email "ci@sovereign.test" 2>/dev/null || true
git config --global user.name "ci" 2>/dev/null || true
git config --global init.defaultBranch master 2>/dev/null || true

PASS=0
FAIL=0
ok()   { echo "  [ PASS ] $1"; PASS=$((PASS + 1)); }
bad()  { echo "  [ FAIL ] $1"; FAIL=$((FAIL + 1)); }

mkpayload() { python3 -c "
open('data.txt','w').write(''.join('record line %d of payload data\n' % i for i in range(200)))
"; }

# --- strict (no origin, no config) ---
mkdir -p "$T_HOME/r-strict" && git -C "$T_HOME/r-strict" init -q
(cd "$T_HOME/r-strict" && python3 "$REPO_ROOT/bin/agy-guard" install-pre-commit >/dev/null)
(cd "$T_HOME/r-strict" && mkpayload && git add data.txt)
if (cd "$T_HOME/r-strict" && git commit -m "x" >/dev/null 2>&1); then
  bad "strict: oversized commit should be blocked"
else
  if [ -z "$(cd "$T_HOME/r-strict" && git log --oneline 2>/dev/null)" ]; then
    ok "strict: HARDBLOCK, 0 commits"
  else
    bad "strict: blocked but commit exists"
  fi
fi
OUT=$(cd "$T_HOME/r-strict" && git commit -m "x" 2>&1 || true)
if echo "$OUT" | grep -q HARDBLOCK; then
  ok "strict: HARDBLOCK banner present"
else
  bad "strict: HARDBLOCK banner missing"
fi

# --- standard ---
mkdir -p "$T_HOME/r-standard" && git -C "$T_HOME/r-standard" init -q
git -C "$T_HOME/r-standard" config sovereign.strictness standard
(cd "$T_HOME/r-standard" && python3 "$REPO_ROOT/bin/agy-guard" install-pre-commit >/dev/null)
(cd "$T_HOME/r-standard" && mkpayload && git add data.txt)
OUT=$(cd "$T_HOME/r-standard" && git commit -m "x" 2>&1); CODE=$?
if [ $CODE -eq 0 ] && echo "$OUT" | grep -q "WARN.*standard tier"; then
  ok "standard: WARN + commit lands (150-line)"
else
  bad "standard: want exit 0 + WARN (exit=$CODE)"
fi
(cd "$T_HOME/r-standard" && mkdir -p tests src && echo t1 > tests/a.test.js && echo s1 > src/a.js && git add . && git commit -qm init)
(cd "$T_HOME/r-standard" && echo v2 >> tests/a.test.js && echo v2 >> src/a.js && git add .)
OUT=$(cd "$T_HOME/r-standard" && git commit -m "co-mod" 2>&1); CODE=$?
if [ $CODE -eq 0 ] && echo "$OUT" | grep -q "WARN.*Test+source"; then
  ok "standard: WARN + commit lands (test co-mod)"
else
  bad "standard: test co-mod should WARN-pass (exit=$CODE)"
fi

# --- passthrough (third-party origin) ---
mkdir -p "$T_HOME/r-pass" && git -C "$T_HOME/r-pass" init -q
git -C "$T_HOME/r-pass" remote add origin https://github.com/someone/vendor-lib.git
(cd "$T_HOME/r-pass" && python3 "$REPO_ROOT/bin/agy-guard" install-pre-commit >/dev/null)
(cd "$T_HOME/r-pass" && mkpayload && git add data.txt)
OUT=$(cd "$T_HOME/r-pass" && git commit -m "x" 2>&1); CODE=$?
if [ $CODE -eq 0 ] && echo "$OUT" | grep -q "passthrough"; then
  ok "passthrough: SKIP + commit lands"
else
  bad "passthrough: want exit 0 + SKIP (exit=$CODE)"
fi

echo "=== TIER MATRIX: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ]
