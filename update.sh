#!/usr/bin/env bash
# plane-task-creator — update script
# Usage: ~/.agents/skills/plane-task-creator/update.sh

set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Updating plane-task-creator..."
cd "$SKILL_DIR"
git pull origin main
echo ""
echo "✅ Updated to latest version."
