#!/usr/bin/env bash
#
# DEPRECATED: Use the venv instead — source .venv/bin/activate
# This script is kept for reference only.
#
# setup.sh — One-shot setup for DAS Remix Toolkit
#
# Run this once to install dependencies and add tools to PATH.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"

echo "🎵 DAS Remix Toolkit — Setup"
echo "=============================="
echo ""

# Check Python
if ! command -v python3 &>/dev/null; then
    echo "❌ Python 3 is required. Install it first."
    exit 1
fi

echo "✓ Python 3 found: $(python3 --version)"

# Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."
pip3 install -r "$SCRIPT_DIR/requirements.txt"

# Check for optional tools
echo ""
echo "🔍 Checking optional tools..."

if command -v tidal-dl-ng &>/dev/null; then
    echo "  ✓ tidal-dl-ng installed"
else
    echo "  ⚠ tidal-dl-ng not found — install with: pip install tidal-dl-ng"
fi

if command -v demucs &>/dev/null; then
    echo "  ✓ demucs installed"
else
    echo "  ⚠ demucs not found — install with: pip install demucs"
fi

if command -v songsee &>/dev/null; then
    echo "  ✓ songsee installed"
else
    echo "  ⚠ songsee not found (optional) — install with: pip install songsee"
fi

# Make scripts executable
echo ""
echo "🔧 Making scripts executable..."
chmod +x "$BIN_DIR"/*
echo "  ✓ Done"

# Add to PATH
echo ""
echo "📂 Adding bin/ to PATH..."

SHELL_RC=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

PATH_LINE="export PATH=\"$BIN_DIR:\$PATH\""

if [[ -n "$SHELL_RC" ]]; then
    if grep -qF "das-remix-toolkit" "$SHELL_RC" 2>/dev/null; then
        echo "  ✓ Already in PATH (found in $(basename "$SHELL_RC"))"
    else
        echo "" >> "$SHELL_RC"
        echo "# DAS Remix Toolkit" >> "$SHELL_RC"
        echo "$PATH_LINE" >> "$SHELL_RC"
        echo "  ✓ Added to $(basename "$SHELL_RC")"
        echo "  → Run: source $SHELL_RC"
    fi
else
    echo "  ⚠ Could not find shell config. Add manually:"
    echo "    $PATH_LINE"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Quick start:"
echo "  track-info <audio-file>           # Detect BPM + key"
echo "  tidal-search \"artist - song\"      # Search Tidal"
echo "  scaffold-remix <stems-dir>        # Create Ableton project"
echo "  remix-pipeline \"search query\"     # Full pipeline"
