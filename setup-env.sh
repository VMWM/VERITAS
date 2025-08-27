#!/bin/bash

# VERITAS Environment Setup Script
# Run this script to set environment variables for terminal sessions
# Usage: source setup-env.sh

echo "Setting up VERITAS environment variables..."

# Set CLAUDE_PROJECT_DIR
export CLAUDE_PROJECT_DIR="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
echo "CLAUDE_PROJECT_DIR set to: $CLAUDE_PROJECT_DIR"

# Set OBSIDIAN_API_TOKEN_HLA for main vault (port 27124)
TOKEN_FILE_HLA="$HOME/.obsidian_api_token_hla"
if [ -f "$TOKEN_FILE_HLA" ]; then
    export OBSIDIAN_API_TOKEN_HLA=$(cat "$TOKEN_FILE_HLA")
    echo "OBSIDIAN_API_TOKEN_HLA loaded for main vault (port 27124)"
else
    echo "Warning: No HLA vault token found at $TOKEN_FILE_HLA"
    echo "To create one:"
    echo "1. Open Obsidian HLA Antibodies vault"
    echo "2. Go to Settings > Community Plugins > Local REST API"
    echo "3. Copy the API token"
    echo "4. Run: echo 'YOUR_HLA_TOKEN' > ~/.obsidian_api_token_hla"
fi

# Set OBSIDIAN_API_TOKEN_JOURNAL for journal vault (port 27125)
TOKEN_FILE_JOURNAL="$HOME/.obsidian_api_token_journal"
if [ -f "$TOKEN_FILE_JOURNAL" ]; then
    export OBSIDIAN_API_TOKEN_JOURNAL=$(cat "$TOKEN_FILE_JOURNAL")
    echo "OBSIDIAN_API_TOKEN_JOURNAL loaded for journal vault (port 27125)"
else
    echo "Warning: No Journal vault token found at $TOKEN_FILE_JOURNAL"
    echo "To create one:"
    echo "1. Open Obsidian Research Journal vault"
    echo "2. Go to Settings > Community Plugins > Local REST API"
    echo "3. Copy the API token"
    echo "4. Run: echo 'YOUR_JOURNAL_TOKEN' > ~/.obsidian_api_token_journal"
fi

# Set generic OBSIDIAN_API_TOKEN to HLA token for backward compatibility
if [ -n "$OBSIDIAN_API_TOKEN_HLA" ]; then
    export OBSIDIAN_API_TOKEN="$OBSIDIAN_API_TOKEN_HLA"
fi

# Optional: Add to shell profile for persistence
echo ""
echo "To make these permanent, add to your shell profile (~/.zshrc or ~/.bash_profile):"
echo "  export CLAUDE_PROJECT_DIR=\"$CLAUDE_PROJECT_DIR\""
echo "  [ -f ~/.obsidian_api_token_hla ] && export OBSIDIAN_API_TOKEN_HLA=\$(cat ~/.obsidian_api_token_hla)"
echo "  [ -f ~/.obsidian_api_token_journal ] && export OBSIDIAN_API_TOKEN_JOURNAL=\$(cat ~/.obsidian_api_token_journal)"
echo "  [ -n \"\$OBSIDIAN_API_TOKEN_HLA\" ] && export OBSIDIAN_API_TOKEN=\"\$OBSIDIAN_API_TOKEN_HLA\""

echo ""
echo "Environment setup complete!"