#!/bin/bash

# VERITAS Environment Setup Script
# Run this script to set environment variables for terminal sessions
# Usage: source setup-env.sh

echo "Setting up VERITAS environment variables..."

# Set CLAUDE_PROJECT_DIR
export CLAUDE_PROJECT_DIR="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
echo "CLAUDE_PROJECT_DIR set to: $CLAUDE_PROJECT_DIR"

# Set OBSIDIAN_API_TOKEN if .obsidian_api_token exists
TOKEN_FILE="$HOME/.obsidian_api_token"
if [ -f "$TOKEN_FILE" ]; then
    export OBSIDIAN_API_TOKEN=$(cat "$TOKEN_FILE")
    echo "OBSIDIAN_API_TOKEN loaded from $TOKEN_FILE"
else
    echo "Warning: No token file found at $TOKEN_FILE"
    echo "To create one:"
    echo "1. Open Obsidian"
    echo "2. Go to Settings > Community Plugins > Local REST API"
    echo "3. Copy the API token"
    echo "4. Run: echo 'YOUR_TOKEN' > ~/.obsidian_api_token"
fi

# Optional: Add to shell profile for persistence
echo ""
echo "To make these permanent, add to your shell profile (~/.zshrc or ~/.bash_profile):"
echo "  export CLAUDE_PROJECT_DIR=\"$CLAUDE_PROJECT_DIR\""
echo "  [ -f ~/.obsidian_api_token ] && export OBSIDIAN_API_TOKEN=\$(cat ~/.obsidian_api_token)"

echo ""
echo "Environment setup complete!"