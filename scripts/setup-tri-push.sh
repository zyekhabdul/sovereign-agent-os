#!/usr/bin/env bash
set -euo pipefail

# setup-tri-push.sh — Configures tiered multi-forge remote ('all') based on repo category
# FOSS Tools (sshm, agy-quota, etc.): GitHub + GitLab + Codeberg
# Web / Commercial Apps (zyekh.com, etc.): GitHub + GitLab (Codeberg excluded to respect FOSS TOS)
# Usage: ./setup-tri-push.sh [--dry-run] [--foss|--web] [REPO_PATH] [REPO_NAME]

DRY_RUN=false
PROFILE="auto"
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --foss|--tool)
      PROFILE="foss"
      shift
      ;;
    --web|--app|--private)
      PROFILE="web"
      shift
      ;;
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--foss|--web] [REPO_PATH] [REPO_NAME]"
      echo "Configures 'all' git remote with tiered routing:"
      echo "  --foss : GitHub + GitLab + Codeberg (for public open-source tools)"
      echo "  --web  : GitHub + GitLab only (for websites/apps, avoiding Codeberg TOS/quota)"
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

if [ -z "$REPO_NAME" ]; then
  REPO_NAME=$(basename "$REPO_PATH")
fi

# Auto-detect profile if set to auto
if [ "$PROFILE" = "auto" ]; then
  if [[ "$REPO_NAME" =~ ^(sshm|agy-quota|agy-guard|sovereign-agent-os|vol3.*|volatility.*|os-debloat.*|paru|RAG-Template|termux-tap|homebrew-tap)$ ]] || \
     [[ "$REPO_NAME" =~ (cli|tool|detector|triage|debloat) ]]; then
    PROFILE="foss"
  else
    PROFILE="web"
  fi
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
  PROFILE_DESC="Web/Commercial App (GitHub + GitLab only — Codeberg Excluded)"
fi
ENABLE_GITEA="${ENABLE_GITEA:-false}"

echo "=== Tiered Multi-Forge Git Remote Setup ==="
echo "Repository Path  : $REPO_PATH"
echo "Repository Name  : $REPO_NAME"
echo "Profile Class    : [ $PROFILE_DESC ]"
echo "GitHub (Active)  : $GITHUB_URL"
echo "GitLab (Active)  : $GITLAB_URL"
echo "Codeberg (FOSS)  : $CODEBERG_URL (In 'all': $ENABLE_CODEBERG)"
echo "Gitea (Freeze)   : $GITEA_URL"
echo "==========================================="

if [ "$DRY_RUN" = true ]; then
  echo "[ DRY-RUN ] Commands to be executed:"
  echo "  git -C \"$REPO_PATH\" remote remove all 2>/dev/null || true"
  echo "  git -C \"$REPO_PATH\" remote add all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITHUB_URL\""
  echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITLAB_URL\""
  if [ "$ENABLE_CODEBERG" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$CODEBERG_URL\""
  fi
  if [ "$ENABLE_GITEA" = "true" ]; then
    echo "  git -C \"$REPO_PATH\" remote set-url --add --push all \"$GITEA_URL\""
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

git -C "$REPO_PATH" remote remove codeberg 2>/dev/null || true
git -C "$REPO_PATH" remote add codeberg "$CODEBERG_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove gitea 2>/dev/null || true
git -C "$REPO_PATH" remote add gitea "$GITEA_URL" 2>/dev/null || true

git -C "$REPO_PATH" remote remove bitbucket 2>/dev/null || true

echo "[ SUCCESS ] Remote 'all' successfully configured: ${PROFILE_DESC}!"
echo "To push to active platforms simultaneously, run:"
echo "  ALLOW_GIT_PUSH=1 git push all <branch>"
