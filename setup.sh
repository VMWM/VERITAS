#!/bin/bash

# Research Agent-MCP System Setup Script

echo "Research Agent-MCP System Setup"
echo "================================"
echo ""

# Check if running from correct directory
if [ ! -f "CLAUDE.md" ]; then
    echo "Error: CLAUDE.md not found. Please run from the repository root."
    exit 1
fi

# Get project directory
echo "Enter your project directory path:"
read -r PROJECT_DIR

# Validate directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory $PROJECT_DIR does not exist."
    exit 1
fi

echo ""
echo "Installing files to: $PROJECT_DIR"
echo ""

# Copy core files
echo "Copying CLAUDE.md..."
cp CLAUDE.md "$PROJECT_DIR/"

echo "Copying .claude directory..."
cp -r .claude "$PROJECT_DIR/"

# Make hooks executable
echo "Setting hook permissions..."
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh
chmod +x "$PROJECT_DIR/.claude/hooks/"*.py
chmod +x "$PROJECT_DIR/.claude/scripts/"*.py

echo ""
echo "Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Update PROJECT CONTEXT in CLAUDE.md"
echo "2. Configure Obsidian REST API"
echo "3. Test the system"
