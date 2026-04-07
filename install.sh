#!/bin/bash
set -e

REPO="dariuschira/know-thy-repo"
SKILLS="explore-thy-repo learn-thy-repo test-thy-knowledge"
VERSION="latest"
SCOPE="global"

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --local)    SCOPE="local"; shift ;;
    --uninstall) SCOPE="uninstall"; shift ;;
    --version)  VERSION="$2"; shift 2 ;;
    --version=*) VERSION="${1#--version=}"; shift ;;
    v[0-9]*)    VERSION="$1"; shift ;;
    latest)     VERSION="latest"; shift ;;
    *)          shift ;;
  esac
done

# Resolve version to a git ref
if [ "$VERSION" = "latest" ]; then
  REF="main"
else
  REF="$VERSION"
fi

BASE_URL="https://raw.githubusercontent.com/${REPO}/${REF}/.claude/skills"

# Set target directory
if [ "$SCOPE" = "local" ]; then
  SKILL_DIR=".claude/skills"
elif [ "$SCOPE" = "uninstall" ]; then
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
if [ "$VERSION" = "latest" ]; then
  echo "Done — skills (latest) are now available in Claude Code."
else
  echo "Done — skills (${VERSION}) are now available in Claude Code."
fi
