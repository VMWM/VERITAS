#!/bin/bash

# Claude Code + MCP Research System Setup Script
# For macOS systems
# Version: 1.0

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "Claude Code + MCP Research System Setup"
echo "================================================"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS."
    exit 1
fi

# Step 1: Check for Node.js
echo "Step 1: Checking for Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    print_success "Node.js $NODE_VERSION found"
else
    print_error "Node.js not found. Please install from https://nodejs.org/"
    exit 1
fi

# Step 2: Install Claude Code
echo ""
echo "Step 2: Installing Claude Code..."
if command -v claude &> /dev/null; then
    print_warning "Claude Code already installed"
else
    npm install -g @anthropic-ai/claude-code
    print_success "Claude Code installed"
fi

# Step 3: Create directory structure
echo ""
echo "Step 3: Creating directory structure..."

# MCP-Shared directory in iCloud
MCP_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"
if [ ! -d "$MCP_DIR" ]; then
    mkdir -p "$MCP_DIR"
    print_success "Created MCP-Shared directory"
else
    print_warning "MCP-Shared directory already exists"
fi

# Nova memory directory
NOVA_DIR="$MCP_DIR/nova-memory"
if [ ! -d "$NOVA_DIR" ]; then
    mkdir -p "$NOVA_DIR"
    print_success "Created nova-memory directory"
else
    print_warning "nova-memory directory already exists"
fi

# Logs directory
LOGS_DIR="$MCP_DIR/logs"
if [ ! -d "$LOGS_DIR" ]; then
    mkdir -p "$LOGS_DIR"
    print_success "Created logs directory"
else
    print_warning "logs directory already exists"
fi

# Obsidian vault directories (Box)
OBSIDIAN_BASE="$HOME/Library/CloudStorage/Box-Box/Obsidian"
if [ ! -d "$OBSIDIAN_BASE" ]; then
    mkdir -p "$OBSIDIAN_BASE"
    print_success "Created Obsidian base directory"
fi

# HLA Antibodies vault
HLA_VAULT="$OBSIDIAN_BASE/HLA Antibodies"
if [ ! -d "$HLA_VAULT" ]; then
    mkdir -p "$HLA_VAULT/Research Questions"
    mkdir -p "$HLA_VAULT/Concepts"
    print_success "Created HLA Antibodies vault structure"
else
    print_warning "HLA Antibodies vault already exists"
fi

# Research Journal vault
JOURNAL_VAULT="$OBSIDIAN_BASE/Research Journal"
if [ ! -d "$JOURNAL_VAULT" ]; then
    mkdir -p "$JOURNAL_VAULT/Daily"
    mkdir -p "$JOURNAL_VAULT/Concepts"
    print_success "Created Research Journal vault structure"
else
    print_warning "Research Journal vault already exists"
fi

# Step 4: Copy configuration template
echo ""
echo "Step 4: Setting up configuration..."
CONFIG_FILE="$MCP_DIR/claude-desktop-config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "config/claude-desktop-config.template.json" ]; then
        cp "config/claude-desktop-config.template.json" "$CONFIG_FILE"
        print_success "Configuration template copied to MCP-Shared"
        print_warning "IMPORTANT: Edit $CONFIG_FILE to add your API keys"
    else
        print_error "Configuration template not found. Please ensure you're running from the repository root."
        exit 1
    fi
else
    print_warning "Configuration already exists"
fi

# Step 5: Create symlink
echo ""
echo "Step 5: Creating symlink for Claude Code..."
SYMLINK="$HOME/.claude.json"
if [ ! -L "$SYMLINK" ]; then
    ln -s "$CONFIG_FILE" "$SYMLINK"
    print_success "Symlink created: ~/.claude.json → MCP-Shared config"
else
    if [ -L "$SYMLINK" ]; then
        print_warning "Symlink already exists"
    else
        print_error "~/.claude.json exists but is not a symlink. Please remove it manually."
        exit 1
    fi
fi

# Step 6: Copy templates
echo ""
echo "Step 6: Installing templates..."
TEMPLATES_DIR="$MCP_DIR/templates"
if [ ! -d "$TEMPLATES_DIR" ]; then
    mkdir -p "$TEMPLATES_DIR"
    if [ -d "templates" ]; then
        cp templates/*.md "$TEMPLATES_DIR/" 2>/dev/null || true
        print_success "Templates copied to MCP-Shared"
    else
        print_warning "No templates found to copy"
    fi
else
    print_warning "Templates directory already exists"
fi

# Step 7: Initialize Memory with Core Knowledge
echo ""
echo "Step 7: Initializing memory with core knowledge..."
if [ -f "scripts/initialize-memory.sh" ]; then
    bash scripts/initialize-memory.sh
    print_success "Memory initialized with core knowledge"
else
    print_warning "Memory initialization script not found"
fi

# Step 8: Test Claude Code installation
echo ""
echo "Step 8: Testing Claude Code installation..."
if claude --version &> /dev/null; then
    CLAUDE_VERSION=$(claude --version)
    print_success "Claude Code is working: $CLAUDE_VERSION"
else
    print_error "Claude Code test failed"
fi

# Step 9: Check for VS Code
echo ""
echo "Step 9: Checking for VS Code..."
if command -v code &> /dev/null; then
    print_success "VS Code command line tools installed"
else
    print_warning "VS Code command line tools not found"
    print_warning "Install from VS Code: Cmd+Shift+P → 'Shell Command: Install code command'"
fi

# Step 10: Note about CLAUDE.md for project folders
echo ""
echo "Step 10: Project Configuration..."
print_success "CLAUDE.md template available in templates/"
print_warning "IMPORTANT: Copy templates/CLAUDE.md to each project folder where you'll use Claude Code"
print_warning "This file contains critical two-vault structure documentation"

# Final instructions
echo ""
echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. CONFIGURE API KEYS:"
echo "   Edit: $CONFIG_FILE"
echo "   - Add your Claude API key"
echo "   - Add your PubMed API key and email"
echo "   - Add your Obsidian REST API key to AUTH_BEARER field"
echo ""
echo "2. OBSIDIAN SETUP:"
echo "   - Open Obsidian"
echo "   - Settings → Community Plugins → Browse"
echo "   - Search 'Local REST API'"
echo "   - Install and enable"
echo "   - Generate API key and add to config (both places mentioned above)"
echo "   - IMPORTANT: The MCP server handles authentication automatically"
echo "   - Agents should NOT manually add Authorization headers"
echo ""
echo "3. ADD CLAUDE.MD TO YOUR PROJECT:"
echo "   Copy templates/CLAUDE.md to your project folders"
echo "   This prevents duplicate Obsidian folder creation issues"
echo ""
echo "4. TEST THE SYSTEM:"
echo "   Run: claude"
echo "   Then type: /mcp"
echo "   You should see all servers connected"
echo ""
echo "5. TRY YOUR FIRST AGENT:"
echo "   /agent \"Find recent papers on HLA antibodies\""
echo ""
echo "For troubleshooting, see docs/TROUBLESHOOTING.md"
echo ""
print_success "Happy researching!"