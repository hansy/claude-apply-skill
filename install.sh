#!/bin/bash
# Root Ventures Apply Skill - One-line installer for Claude CLI

set -e

SKILL_DIR="$HOME/.claude/skills/root-ventures-apply"
REPO_URL="https://raw.githubusercontent.com/rootvc/claude-apply-skill/main"

echo ""
echo "🚀 Installing Root Ventures Apply Skill..."
echo ""

# Create skills directory if it doesn't exist
mkdir -p "$SKILL_DIR"

# Download files
echo "📥 Downloading skill files..."
curl -fsSL "$REPO_URL/skill.json" -o "$SKILL_DIR/skill.json"
curl -fsSL "$REPO_URL/prompt.txt" -o "$SKILL_DIR/prompt.txt"
curl -fsSL "$REPO_URL/apply.sh" -o "$SKILL_DIR/apply.sh"
curl -fsSL "$REPO_URL/README.md" -o "$SKILL_DIR/README.md"

# Make apply.sh executable
chmod +x "$SKILL_DIR/apply.sh"

echo ""
echo "✅ Root Ventures Apply Skill installed successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Starting Claude with the application skill loaded..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
  echo "⚠️  Claude CLI not found. Install it from: https://claude.ai/download"
  echo ""
  echo "After installing Claude CLI, run this to apply:"
  echo "  claude 'Read ~/.claude/skills/root-ventures-apply/prompt.txt then I want to apply'"
  echo ""
  exit 0
fi

# Launch Claude with the skill pre-loaded
sleep 1
exec claude "Read ~/.claude/skills/root-ventures-apply/prompt.txt then I want to apply"

