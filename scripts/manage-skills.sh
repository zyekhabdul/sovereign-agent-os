#!/usr/bin/env bash
set -euo pipefail

# manage-skills.sh — Skill Context Optimization & Restore Tool
# Manages skills in ~/.agents/skills and ~/.agents/skills-archive
# Prevents token context blowout in LLMs with 128k context limits.

SKILLS_DIR="$HOME/.agents/skills"
ARCHIVE_DIR="$HOME/.agents/skills-archive"
MANIFEST_DIR="$ARCHIVE_DIR/manifest/skills-manifest"

usage() {
  echo "Usage: $0 {status|list-active|list-archive|restore <name>|restore-all|archive <name>}"
  exit 1
}

cmd="${1:-status}"

case "$cmd" in
  status)
    active_count=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    archive_count=$(find "$ARCHIVE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "manifest" 2>/dev/null | wc -l)
    echo "=================================================="
    echo "            SKILLS INVENTORY STATUS               "
    echo "=================================================="
    echo "Active Skills in ~/.agents/skills:        $active_count"
    echo "Archived Skills in ~/.agents/skills-archive: $archive_count"
    echo "Total Managed Skills:                     $((active_count + archive_count))"
    echo "Context footprint recommendation:         <= 450 active"
    echo "=================================================="
    ;;

  list-active)
    find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
    ;;

  list-archive)
    find "$ARCHIVE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "manifest" -exec basename {} \; | sort
    ;;

  restore)
    target="${2:-}"
    if [ -z "$target" ]; then
      echo "Error: Specify skill name to restore."
      usage
    fi
    if [ ! -d "$ARCHIVE_DIR/$target" ]; then
      echo "Error: Skill '$target' not found in $ARCHIVE_DIR"
      exit 1
    fi
    mv "$ARCHIVE_DIR/$target" "$SKILLS_DIR/$target"
    echo "[ RESTORED ] Moved '$target' -> $SKILLS_DIR/$target"
    ;;

  restore-all)
    echo "Restoring all archived skills to $SKILLS_DIR..."
    find "$ARCHIVE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "manifest" | while read -r d; do
      mv "$d" "$SKILLS_DIR/"
    done
    echo "[ COMPLETED ] All skills restored."
    ;;

  archive)
    target="${2:-}"
    if [ -z "$target" ]; then
      echo "Error: Specify skill name to archive."
      usage
    fi
    if [ ! -d "$SKILLS_DIR/$target" ]; then
      echo "Error: Skill '$target' not found in $SKILLS_DIR"
      exit 1
    fi
    mkdir -p "$ARCHIVE_DIR"
    mv "$SKILLS_DIR/$target" "$ARCHIVE_DIR/$target"
    echo "[ ARCHIVED ] Moved '$target' -> $ARCHIVE_DIR/$target"
    ;;

  *)
    usage
    ;;
esac
