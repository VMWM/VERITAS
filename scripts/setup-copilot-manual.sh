#!/bin/bash

# GitHub Copilot + MCP Research System Setup Script (Manual Steps Required)
# For macOS systems with GitHub Copilot
# Version: 2.0 - Includes manual VS Code configuration steps

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================"
echo "GitHub Copilot + MCP Research System Setup"
echo "Manual Configuration Required After Script"
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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS."
    exit 1
fi

echo "IMPORTANT: GitHub Copilot's MCP support requires manual steps!"
echo "This script will prepare the foundation, but you'll need to:"
echo "1. Manually install MCP servers through VS Code"
echo "2. Use Agent Mode (not regular chat)"
echo "3. Manually orchestrate workflows"
echo ""
read -p "Press Enter to continue if you understand these limitations..."

# Check for VS Code and GitHub Copilot
echo ""
echo "Step 1: Checking for VS Code and GitHub Copilot..."
if command -v code &> /dev/null; then
    print_success "VS Code found"
    if code --list-extensions | grep -q "github.copilot"; then
        print_success "GitHub Copilot extension found"
    else
        print_error "GitHub Copilot extension not found."
        echo "Please install it: code --install-extension GitHub.copilot"
        exit 1
    fi
else
    print_error "VS Code not found. Please install VS Code first."
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

# Create shared directories
echo ""
echo "Step 3: Creating shared directories..."

NOVA_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory"
mkdir -p "$NOVA_DIR"
print_success "Created nova-memory directory"

OBSIDIAN_BASE="$HOME/Library/CloudStorage/Box-Box/Obsidian"
mkdir -p "$OBSIDIAN_BASE/HLA Antibodies/Research Questions"
mkdir -p "$OBSIDIAN_BASE/HLA Antibodies/Concepts"
mkdir -p "$OBSIDIAN_BASE/Research Journal/Daily"
mkdir -p "$OBSIDIAN_BASE/Research Journal/Concepts"
print_success "Created Obsidian vault structure"

# Install base npm packages (required but not sufficient)
echo ""
echo "Step 4: Installing npm packages (base requirement)..."
npm install -g @nova-mcp/mcp-nova@0.3.0
npm install -g @ncukondo/pubmed-mcp
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g dkmaker-mcp-rest-api
npm install -g @modelcontextprotocol/server-filesystem
print_success "Base npm packages installed"

# Create initial mcp.json (will be modified by VS Code)
echo ""
echo "Step 5: Creating initial MCP configuration..."
MCP_CONFIG="$HOME/Library/Application Support/Code/User/mcp.json"
MCP_DIR=$(dirname "$MCP_CONFIG")
mkdir -p "$MCP_DIR"

# Only create if doesn't exist
if [ ! -f "$MCP_CONFIG" ]; then
    cat > "$MCP_CONFIG" << 'EOF'
{
  "mcpServers": {}
}
EOF
    print_success "Created initial mcp.json"
else
    print_warning "mcp.json already exists - skipping"
fi

echo ""
echo "================================================"
echo "MANUAL STEPS REQUIRED - PLEASE FOLLOW CAREFULLY"
echo "================================================"
echo ""

print_info "Step 1: Restart VS Code completely (Cmd+Q)"
echo ""

print_info "Step 2: Install MCP servers through VS Code:"
echo "   a. Open Command Palette (Cmd+Shift+P)"
echo "   b. Type: 'Add MCP Server'"
echo "   c. Select 'NPM Package'"
echo "   d. Install these packages ONE BY ONE:"
echo "      - @nova-mcp/mcp-nova"
echo "      - @ncukondo/pubmed-mcp"
echo "   e. The others should auto-configure"
echo ""

print_info "Step 3: Configure API keys when prompted:"
echo "   - PubMed: Get from https://www.ncbi.nlm.nih.gov/account/"
echo "   - Obsidian: Get from Local REST API plugin in Obsidian"
echo ""

print_info "Step 4: Switch to Agent Mode:"
echo "   a. Open GitHub Copilot chat (Ctrl+Cmd+I)"
echo "   b. Look for dropdown at top of chat panel"
echo "   c. Change from 'Chat' to 'Agent'"
echo "   d. Click 'Tools' button"
echo "   e. Select all MCP servers"
echo ""

print_info "Step 5: Test with these commands IN AGENT MODE:"
echo '   "Use the pubmed tool to search for HLA antibodies 2024"'
echo '   "Use the obsidian-rest tool to create a test note in my Obsidian vault"'
echo '   "Use the filesystem-local tool to list files in /Users/'$USER'/Library/CloudStorage/Box-Box"'
echo ""

echo "================================================"
echo "LIMITATIONS TO BE AWARE OF"
echo "================================================"
echo ""
print_warning "1. No autonomous agent - you must manually orchestrate"
print_warning "2. Memory server may have issues"
print_warning "3. Must use Agent Mode, not regular chat"
print_warning "4. Each workflow step must be explicitly commanded"
echo ""

echo "================================================"
echo "COMPARISON WITH CLAUDE CODE"
echo "================================================"
echo ""
echo "Claude Code:  /agent 'Research prozone effect'"
echo "              → Automatically does everything"
echo ""
echo "GitHub Copilot: 'Use pubmed tool to search...'"
echo "                'Now use obsidian tool to create...'"
echo "                'Now create concept pages...'"
echo "                → Manual step-by-step control"
echo ""

print_info "For the full autonomous experience, use Claude Code (main branch)"
print_info "For IDE-integrated MCP tools with manual control, continue with GitHub Copilot"
echo ""

echo "Documentation: docs/GITHUB_COPILOT_REALITY_CHECK.md"
echo ""