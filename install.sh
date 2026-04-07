#!/bin/bash
set -e

REPO="dariuschira/know-thy-repo"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/.claude/skills"
SKILLS="explore-thy-repo learn-thy-repo test-thy-knowledge"

# Determine target: --local installs into .claude/skills/ in the current project
if [ "$1" = "--local" ]; then
  SKILL_DIR=".claude/skills"
  shift
elif [ "$1" = "--uninstall" ]; then
  SKILL_DIR="${HOME}/.claude/skills"
  for skill in $SKILLS; do
    rm -rf "${SKILL_DIR}/${skill}"
    echo "  removed /${skill}"
  done
  echo ""
  echo "Done — skills removed."
  exit 0
else
  SKILL_DIR="${HOME}/.claude/skills"
fi

# Detect if running from a local clone or via curl
SCRIPT_DIR="$(cd "$(dirname "$0" 2>/dev/null)" 2>/dev/null && pwd 2>/dev/null || echo "")"
LOCAL_SOURCE="${SCRIPT_DIR}/.claude/skills"

for skill in $SKILLS; do
  mkdir -p "${SKILL_DIR}/${skill}"
  if [ -n "$SCRIPT_DIR" ] && [ -f "${LOCAL_SOURCE}/${skill}/SKILL.md" ]; then
    ln -sf "${LOCAL_SOURCE}/${skill}/SKILL.md" "${SKILL_DIR}/${skill}/SKILL.md"
  else
    curl -fsSL "${BASE_URL}/${skill}/SKILL.md" -o "${SKILL_DIR}/${skill}/SKILL.md"
  fi
  echo "  installed /${skill}"
done

echo ""
echo "Done — skills are now available in Claude Code."
