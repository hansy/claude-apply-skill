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
echo "  Launching Claude..."
echo ""
echo "  Claude will confirm it's ready, then just say:"
echo "  'I want to apply to Root Ventures'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Claude CLI is installed
# Try multiple ways to find claude (handles aliases, PATH, and direct installation)
CLAUDE_CMD=""

if command -v claude &> /dev/null; then
  CLAUDE_CMD="claude"
elif [ -f "$HOME/.claude/local/claude" ]; then
  CLAUDE_CMD="$HOME/.claude/local/claude"
elif [ -f "/usr/local/bin/claude" ]; then
  CLAUDE_CMD="/usr/local/bin/claude"
fi

if [ -z "$CLAUDE_CMD" ]; then
  echo "⚠️  Claude CLI not found."
  echo ""
  echo "📦 Installing Claude CLI..."
  echo ""

  # Detect OS
  OS="$(uname -s)"
  case "$OS" in
    Darwin*)
      # macOS installation
      if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo ""
        echo "Or install Claude CLI manually from: https://claude.ai/download"
        exit 1
      fi

      echo "Installing Claude CLI via Homebrew..."
      brew install claude
      ;;

    Linux*)
      # Linux installation using curl installer
      echo "Installing Claude CLI..."
      curl -fsSL https://storage.googleapis.com/claude-cli/install.sh | sh

      # Add to PATH if not already there
      if ! command -v claude &> /dev/null; then
        export PATH="$HOME/.claude/local:$PATH"

        # Add to shell profile
        SHELL_PROFILE=""
        if [ -f "$HOME/.zshrc" ]; then
          SHELL_PROFILE="$HOME/.zshrc"
        elif [ -f "$HOME/.bashrc" ]; then
          SHELL_PROFILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
          SHELL_PROFILE="$HOME/.bash_profile"
        fi

        if [ -n "$SHELL_PROFILE" ]; then
          if ! grep -q "/.claude/local" "$SHELL_PROFILE"; then
            echo 'export PATH="$HOME/.claude/local:$PATH"' >> "$SHELL_PROFILE"
            echo "✅ Added Claude CLI to PATH in $SHELL_PROFILE"
          fi
        fi
      fi
      ;;

    *)
      echo "❌ Unsupported operating system: $OS"
      echo "Please install Claude CLI manually from: https://claude.ai/download"
      exit 1
      ;;
  esac

  # Verify installation
  if command -v claude &> /dev/null; then
    CLAUDE_CMD="claude"
    echo ""
    echo "✅ Claude CLI installed successfully!"
    echo ""
  elif [ -f "$HOME/.claude/local/claude" ]; then
    CLAUDE_CMD="$HOME/.claude/local/claude"
    echo ""
    echo "✅ Claude CLI installed successfully!"
    echo ""
  else
    echo ""
    echo "❌ Claude CLI installation failed."
    echo "Please install manually from: https://claude.ai/download"
    echo ""
    echo "After installing, run this to apply:"
    echo "  claude 'Read ~/.claude/skills/root-ventures-apply/prompt.txt then I want to apply'"
    echo ""
    exit 1
  fi
fi

# Launch Claude with the skill pre-loaded
sleep 1
exec "$CLAUDE_CMD" "Read ~/.claude/skills/root-ventures-apply/prompt.txt"

