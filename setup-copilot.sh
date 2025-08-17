#!/bin/bash

# GitHub Copilot + MCP Research System Setup Script
# For macOS systems with GitHub Copilot
# Version: 1.0

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "GitHub Copilot + MCP Research System Setup"
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

# Check for VS Code and GitHub Copilot
echo "Step 1: Checking for VS Code and GitHub Copilot..."
if command -v code &> /dev/null; then
    print_success "VS Code found"
    # Check if GitHub Copilot is installed
    if code --list-extensions | grep -q "github.copilot"; then
        print_success "GitHub Copilot extension found"
    else
        print_warning "GitHub Copilot extension not found. Please install it from VS Code marketplace."
    fi
else
    print_error "VS Code not found. Please install VS Code and GitHub Copilot extension."
    exit 1
fi

# Check for Node.js
echo ""
echo "Step 2: Checking for Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    print_success "Node.js $NODE_VERSION found"
else
    print_error "Node.js not found. Please install from https://nodejs.org/"
    exit 1
fi

# Create directory structure for shared MCP resources
echo ""
echo "Step 3: Creating shared directories for MCP servers..."

# Nova memory directory (shared across tools)
NOVA_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory"
if [ ! -d "$NOVA_DIR" ]; then
    mkdir -p "$NOVA_DIR"
    print_success "Created nova-memory directory"
else
    print_warning "nova-memory directory already exists"
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

# Copy GitHub Copilot MCP configuration
echo ""
echo "Step 4: Setting up GitHub Copilot MCP configuration..."
COPILOT_CONFIG="$HOME/Library/Application Support/Code/User/mcp.json"
COPILOT_DIR=$(dirname "$COPILOT_CONFIG")

if [ ! -d "$COPILOT_DIR" ]; then
    mkdir -p "$COPILOT_DIR"
    print_success "Created GitHub Copilot config directory"
fi

if [ ! -f "$COPILOT_CONFIG" ]; then
    if [ -f "config/copilot-mcp-config.template.json" ]; then
        cp "config/copilot-mcp-config.template.json" "$COPILOT_CONFIG"
        print_success "GitHub Copilot MCP configuration installed"
        print_warning "IMPORTANT: Edit $COPILOT_CONFIG to add your API keys"
    else
        print_error "Copilot MCP configuration template not found."
        exit 1
    fi
else
    print_warning "GitHub Copilot MCP configuration already exists"
fi

# Note: Templates are handled by Memory MCP automatically for GitHub Copilot

# Install MCP packages globally for reliability
echo ""
echo "Step 6: Installing MCP packages..."
npm install -g @nova-mcp/mcp-nova@0.3.0 &
npm install -g @modelcontextprotocol/server-sequential-thinking &
npm install -g @ncukondo/pubmed-mcp &
npm install -g dkmaker-mcp-rest-api &
npm install -g @modelcontextprotocol/server-filesystem &
wait
print_success "MCP packages installed"

# Final instructions
echo ""
echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. CONFIGURE API KEYS:"
echo "   Edit: $COPILOT_CONFIG"
echo "   - Add your PubMed API key and email"
echo "   - Add your Obsidian REST API key"
echo ""
echo "2. OBSIDIAN SETUP:"
echo "   - Open Obsidian"
echo "   - Settings → Community Plugins → Browse"
echo "   - Search 'Local REST API'"
echo "   - Install and enable"
echo "   - Generate API key and add to config"
echo ""
echo "3. ENABLE VS CODE SETTINGS SYNC:"
echo "   - Sign in to GitHub in VS Code"
echo "   - Enable Settings Sync (your config will sync across machines)"
echo ""
echo "4. RESTART VS CODE:"
echo "   - Close VS Code completely"
echo "   - Reopen VS Code"
echo "   - GitHub Copilot should detect the MCP servers"
echo ""
echo "5. TEST THE SYSTEM:"
echo "   - Start GitHub Copilot chat"
echo "   - You should see MCP servers being detected"
echo "   - Try: '@github Search PubMed for HLA antibodies'"
echo ""
echo "For troubleshooting, see docs/TROUBLESHOOTING.md"
echo ""
print_success "Happy researching with GitHub Copilot!"