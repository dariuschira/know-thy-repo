#!/bin/bash
set -e

REPO="dariuschira/know-thy-repo"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/.claude/skills"
SKILL_DIR="${HOME}/.claude/skills"
SKILLS="explore-thy-repo learn-thy-repo test-thy-knowledge"

if [ "$1" = "--uninstall" ]; then
  for skill in $SKILLS; do
    rm -f "${SKILL_DIR}/${skill}.md"
    echo "  removed /${skill}"
  done
  echo ""
  echo "Done — skills removed."
  exit 0
fi

mkdir -p "$SKILL_DIR"

# Detect if running from a local clone or via curl
SCRIPT_DIR="$(cd "$(dirname "$0" 2>/dev/null)" 2>/dev/null && pwd 2>/dev/null || echo "")"
LOCAL_SOURCE="${SCRIPT_DIR}/.claude/skills"

for skill in $SKILLS; do
  if [ -n "$SCRIPT_DIR" ] && [ -f "${LOCAL_SOURCE}/${skill}.md" ]; then
    ln -sf "${LOCAL_SOURCE}/${skill}.md" "${SKILL_DIR}/${skill}.md"
  else
    curl -fsSL "${BASE_URL}/${skill}.md" -o "${SKILL_DIR}/${skill}.md"
  fi
  echo "  installed /${skill}"
done

echo ""
echo "Done — skills are now available in all Claude Code sessions."
