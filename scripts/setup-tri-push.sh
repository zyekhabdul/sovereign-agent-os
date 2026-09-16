#!/usr/bin/env bash
set -euo pipefail

# setup-tri-push.sh — Configures tiered multi-forge remote ('all') based on repo category
# FOSS Tools (sshm, agy-quota, etc.): GitHub + GitLab + Codeberg
# Web / Commercial Apps (zyekh.com, etc.): GitHub + GitLab (Codeberg excluded to respect FOSS TOS)
# Usage: ./setup-tri-push.sh [--dry-run] [--foss|--web] [REPO_PATH] [REPO_NAME]

DRY_RUN=false
EXPLICIT_PROFILE=""
SET_PROFILE=""
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --foss|--tool)
      EXPLICIT_PROFILE="foss"
      shift
      ;;
    --web|--app|--private)
      EXPLICIT_PROFILE="web"
      shift
      ;;
    --set-profile)
      SET_PROFILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--foss|--web] [--set-profile foss|web] [REPO_PATH] [REPO_NAME]"
      echo "Deterministic Multi-Forge Git Remote Setup:"
      echo "  --foss          : Route to GitHub + GitLab + Codeberg (FOSS Tools)"
      echo "  --web           : Route to GitHub + GitLab only (Web/Commercial apps)"
      echo "  --set-profile X : Persistently save git config sovereign.profile = X (foss|web)"
      echo "  --dry-run       : Display execution plan without applying"
      exit 0
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

REPO_PATH="${POSITIONAL[0]:-.}"
REPO_NAME="${POSITIONAL[1]:-}"

REPO_PATH=$(cd "$REPO_PATH" && pwd)
if [ ! -d "$REPO_PATH/.git" ]; then
  echo "[ ERROR ] Target path is not a valid git repository: $REPO_PATH"
  exit 1
fi

ORIGIN_URL=$(git -C "$REPO_PATH" config --get remote.origin.url 2>/dev/null || echo "")

# Gate 0: Third-party upstream guard (AUR / external vendor mirrors)
if echo "$ORIGIN_URL" | grep -Eq 'aur\.archlinux\.org|gitlab\.archlinux\.org'; then
  echo "[ SKIP ] Third-party upstream repository detected (AUR/Arch): $ORIGIN_URL"
  exit 0
fi

if [ -z "$REPO_NAME" ]; then
  if [ -n "$ORIGIN_URL" ] && echo "$ORIGIN_URL" | grep -Eq '(zyekhabdul|aomiqaza)'; then
    REPO_NAME=$(basename "$ORIGIN_URL" .git)
  else
    REPO_NAME=$(basename "$REPO_PATH")
  fi
fi

# Persist profile to repo git config if requested
if [ -n "$SET_PROFILE" ]; then
  git -C "$REPO_PATH" config sovereign.profile "$SET_PROFILE"
  echo "[ CONFIG ] Saved sovereign.profile = $SET_PROFILE in $REPO_PATH/.git/config"
fi

# --- DETERMINISTIC PROFILE RESOLUTION STATE MACHINE ---
IS_PRIVATE=false
PRIVATE_REASON=""

# Gate 1: Manifest inspection for private flags (Immutable Hardblock)
if [ -f "$REPO_PATH/package.json" ]; then
  if grep -Eq '"private"[[:space:]]*:[[:space:]]*true' "$REPO_PATH/package.json" 2>/dev/null; then
    IS_PRIVATE=true
    PRIVATE_REASON="package.json declares 'private: true'"
  fi
fi

if [ -f "$REPO_PATH/Cargo.toml" ]; then
  if grep -Eq 'publish[[:space:]]*=[[:space:]]*false' "$REPO_PATH/Cargo.toml" 2>/dev/null; then
    IS_PRIVATE=true
    PRIVATE_REASON="Cargo.toml declares 'publish = false'"
  fi
fi

# Gate 2: Local Git Config inspection
LOCAL_CONFIG=$(git -C "$REPO_PATH" config --get sovereign.profile 2>/dev/null || echo "")

# Gate 3: State Machine Resolution (Priority Order)
if [ "$IS_PRIVATE" = true ]; then
  PROFILE="web"
  RESOLUTION="Hardblock: $PRIVATE_REASON (Codeberg strictly prohibited)"
elif [ -n "$EXPLICIT_PROFILE" ]; then
  PROFILE="$EXPLICIT_PROFILE"
  RESOLUTION="Explicit CLI parameter (--${EXPLICIT_PROFILE})"
elif [ -n "$LOCAL_CONFIG" ]; then
  PROFILE="$LOCAL_CONFIG"
  RESOLUTION="Repository Git Config (sovereign.profile = ${LOCAL_CONFIG})"
elif [ -f "$REPO_PATH/LICENSE" ] || [ -f "$REPO_PATH/LICENSE.md" ] || [ -f "$REPO_PATH/LICENSE.txt" ]; then
  PROFILE="foss"
  RESOLUTION="Declarative: Open-source LICENSE file detected"
else
  PROFILE="web"
  RESOLUTION="Safe-by-Default: No explicit FOSS config or LICENSE found"
fi

GITHUB_USER="${GITHUB_USER:-zyekhabdul}"
GITLAB_USER="${GITLAB_USER:-aomiqaza}"
CODEBERG_USER="${CODEBERG_USER:-aomiqaza}"
GITEA_HOST="${GITEA_HOST:-gitea.com}"
GITEA_USER="${GITEA_USER:-aomiqaza}"

GITHUB_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
GITLAB_URL="git@gitlab.com:${GITLAB_USER}/${REPO_NAME}.git"
CODEBERG_URL="git@codeberg.org:${CODEBERG_USER}/${REPO_NAME}.git"
GITEA_URL="git@${GITEA_HOST}:${GITEA_USER}/${REPO_NAME}.git"

if [ "$PROFILE" = "foss" ]; then
  ENABLE_CODEBERG=true
  PROFILE_DESC="FOSS Tool (GitHub + GitLab + Codeberg)"
else
  ENABLE_CODEBERG=false
  PROFILE_DESC="Web/Restricted App (GitHub + GitLab only — Codeberg Excluded)"
fi
ENABLE_GITEA="${ENABLE_GITEA:-false}"

echo "=== Deterministic Multi-Forge Git Remote Setup ==="
echo "Repository Path  : $REPO_PATH"
echo "Repository Name  : $REPO_NAME"
echo "Resolution       : $RESOLUTION"
echo "Profile Class    : [ $PROFILE_DESC ]"
echo "GitHub (Active)  : $GITHUB_URL"
echo "GitLab (Active)  : $GITLAB_URL"
echo "Codeberg (FOSS)  : $CODEBERG_URL (In 'all': $ENABLE_CODEBERG)"
echo "Gitea (Freeze)   : $GITEA_URL"
echo "=================================================="

if [ "$DRY_RUN" = true ]; then
  echo "[ DRY-RUN ] Commands to be executed:"
  echo "  git -C \"$REPO_PATH\" remote remove all 2>/dev/null || true"
  echo "  git -C \"$REPO_PATH\" remote add all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITLAB_URL\""
  if [ "$ENABLE_CODEBERG" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$CODEBERG_URL\""
    echo "  git -C \"$REPO_PATH\" remote add codeberg \"$CODEBERG_URL\""
  else
    echo "  git -C \"$REPO_PATH\" remote remove codeberg (Isolation enforced: Codeberg blocked)"
  fi
  if [ "$ENABLE_GITEA" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITEA_URL\""
    echo "  git -C \"$REPO_PATH\" remote add gitea \"$GITEA_URL\""
  fi
  exit 0
fi

# Execute git remote configuration
git -C "$REPO_PATH" remote remove all 2>/dev/null || true
git -C "$REPO_PATH" remote add all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITHUB_URL"
git -C "$REPO_PATH" remote set-url --add --push all "$GITLAB_URL"

if [ "$ENABLE_CODEBERG" = "true" ]; then
  git -C "$REPO_PATH" remote set-url --add --push all "$CODEBERG_URL"
fi
if [ "$ENABLE_GITEA" = "true" ]; then
  git -C "$REPO_PATH" remote set-url --add --push all "$GITEA_URL"
fi

# Also ensure standalone remotes exist for selective individual pushes
git -C "$REPO_PATH" remote remove github 2>/dev/null || true
git -C "$REPO_PATH" remote add github "$GITHUB_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove gitlab 2>/dev/null || true
git -C "$REPO_PATH" remote add gitlab "$GITLAB_URL" 2>/dev/null || true

# Codeberg standalone remote: ONLY present if repo is FOSS compliant
git -C "$REPO_PATH" remote remove codeberg 2>/dev/null || true
if [ "$ENABLE_CODEBERG" = "true" ]; then
  git -C "$REPO_PATH" remote add codeberg "$CODEBERG_URL" 2>/dev/null || true
fi

# Gitea standalone remote: ONLY present if explicitly enabled
git -C "$REPO_PATH" remote remove gitea 2>/dev/null || true
if [ "$ENABLE_GITEA" = "true" ]; then
  git -C "$REPO_PATH" remote add gitea "$GITEA_URL" 2>/dev/null || true
fi

git -C "$REPO_PATH" remote remove bitbucket 2>/dev/null || true

echo "[ SUCCESS ] Remote 'all' successfully configured: ${PROFILE_DESC}!"
echo "To push to active platforms simultaneously, run:"
echo "  ALLOW_GIT_PUSH=1 git push all <branch>"
