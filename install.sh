#!/usr/bin/env bash
# plane-task-creator — install script
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/plane-task-creator/main/install.sh | bash

set -e

SKILL_NAME="plane-task-creator"
REPO_URL="https://github.com/YOUR_USERNAME/plane-task-creator.git"
INSTALL_DIR="${HOME}/.agents/skills/${SKILL_NAME}"

echo "📦 Installing ${SKILL_NAME}..."

if [ -d "$INSTALL_DIR" ]; then
  echo "⚠️  Skill already installed at ${INSTALL_DIR}"
  echo "   Run update.sh to update, or remove the folder to reinstall."
  exit 0
fi

# Require git
if ! command -v git &> /dev/null; then
  echo "❌ git is required but not installed. Please install git first."
  exit 1
fi

mkdir -p "${HOME}/.agents/skills"
git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

echo ""
echo "✅ Installed to: ${INSTALL_DIR}"
echo ""
echo "   Skill is now active for any AI agent that reads ~/.agents/skills/"
echo "   To update later, run: ${INSTALL_DIR}/update.sh"
