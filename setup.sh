#!/bin/bash

# Setup Router Script
# Redirects to the appropriate setup script

echo "========================================"
echo "HLA Research MCP System Setup"
echo "========================================"
echo ""
echo "Choose your setup:"
echo "1) Claude Code (Recommended)"
echo "2) GitHub Copilot (Manual steps required)"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Starting Claude Code setup..."
        ./scripts/setup-claude.sh
        ;;
    2)
        echo "Starting GitHub Copilot setup..."
        echo "Note: This requires additional manual configuration in VS Code"
        ./scripts/setup-copilot-manual.sh
        ;;
    *)
        echo "Invalid choice. Please run again and select 1 or 2."
        exit 1
        ;;
esac
