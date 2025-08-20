#!/bin/bash

# HLA Research MCP System - Claude Code Setup
# For macOS systems with iCloud Drive
# Version: 2.0 (Simplified)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "HLA Research MCP System - Claude Code Setup"
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

# Step 3: Install MCP Servers
echo ""
echo "Step 3: Installing MCP servers..."
echo "This may take a few minutes..."

# Install each MCP server
print_warning "Installing MCP servers (this requires npm)..."

# Memory MCP
echo "  Installing memory server..."
npm install -g @modelcontextprotocol/server-memory 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "Memory server installed"
else
    print_warning "Memory server may already be installed"
fi

# Sequential Thinking MCP
echo "  Installing sequential thinking server..."
npm install -g @modelcontextprotocol/server-sequential-thinking 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "Sequential thinking server installed"
else
    print_warning "Sequential thinking server may already be installed"
fi

# Filesystem MCP
echo "  Installing filesystem server..."
npm install -g @modelcontextprotocol/server-filesystem 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "Filesystem server installed"
else
    print_warning "Filesystem server may already be installed"
fi

# Obsidian REST API MCP
echo "  Installing Obsidian REST API server..."
npm install -g dkmaker-mcp-rest-api 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "Obsidian REST API server installed"
else
    print_warning "Obsidian REST API server may already be installed"
fi

# PubMed MCP
echo "  Installing PubMed server..."
npm install -g @ncukondo/pubmed-mcp 2>/dev/null
if [ $? -eq 0 ]; then
    print_success "PubMed server installed"
else
    print_warning "PubMed server may already be installed"
fi

print_success "All MCP servers installed!"

# Step 4: Create directory structure
echo ""
echo "Step 4: Creating directory structure..."

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

# Agents directory for custom agent personalities
AGENTS_DIR="$MCP_DIR/agents"
if [ ! -d "$AGENTS_DIR" ]; then
    mkdir -p "$AGENTS_DIR"
    print_success "Created agents directory"
else
    print_warning "agents directory already exists"
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

# Step 5: Copy configuration template
echo ""
echo "Step 5: Setting up configuration..."
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

# Step 6: Create symlink
echo ""
echo "Step 6: Creating symlink for Claude Code..."
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

# Step 7: Copy templates and agent files
echo ""
echo "Step 7: Installing templates and agent library..."

# Copy general templates
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

# Copy agent template and examples to agents folder
if [ -d "$AGENTS_DIR" ]; then
    # Copy agent template
    if [ -f "templates/AGENT_TEMPLATE.md" ]; then
        cp "templates/AGENT_TEMPLATE.md" "$AGENTS_DIR/"
        print_success "Agent template installed"
    fi
    
    # Copy HLA Research Agent as example
    if [ -f "templates/CLAUDE.md" ]; then
        cp "templates/CLAUDE.md" "$AGENTS_DIR/HLA-Research-Agent.md"
        print_success "HLA Research Agent installed as example"
    fi
    
    # Create README for agents directory
    cat > "$AGENTS_DIR/README.md" << 'EOF'
# Agent Library

This folder contains different agent personalities for Claude Code. Each agent is configured for specific tasks and workflows.

## How to Use

1. **Choose an agent** from the list below
2. **Copy it to your project** as `CLAUDE.md`:
   ```bash
   cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/[Agent-Name].md ./CLAUDE.md
   ```
3. **Use `/agent`** in Claude Code to activate that personality

## Available Agents

### 🧬 HLA-Research-Agent.md
**Purpose**: HLA antibody research, transplant immunology, immunogenetics
- Dual vault support (HLA Antibodies + Research Journal)
- PubMed integration with PMID verification
- Sequential thinking for complex immunology questions
- Knowledge graph linking for Obsidian

### 📝 AGENT_TEMPLATE.md
**Purpose**: Template for creating new agents
- Complete structure for defining agent behavior
- Sections for knowledge, tools, workflows
- Customizable for any domain
- Copy and modify for new agents

## Creating New Agents

1. Copy `AGENT_TEMPLATE.md` to a new file:
   ```bash
   cp AGENT_TEMPLATE.md My-New-Agent.md
   ```

2. Fill in each section:
   - Define the agent's role and expertise
   - Specify which MCP servers it uses
   - Set behavioral rules and response style
   - Add domain-specific knowledge

3. Test in a project:
   ```bash
   cp My-New-Agent.md ~/my-project/CLAUDE.md
   cd ~/my-project
   claude
   /agent [test prompt]
   ```

## Tips

- **Keep agents focused**: One domain per agent works best
- **Document changes**: Update version and date in agent file
- **Test thoroughly**: Verify MCP server access before sharing
- **Backup originals**: Keep copies before major edits

---
*Last updated: $(date +%Y-%m-%d)*
EOF
    print_success "Agent library README created"
fi

# Step 8: Initialize Memory (if script exists)
echo ""
echo "Step 8: Initializing memory..."
if [ -f "scripts/initialize-memory.sh" ]; then
    bash scripts/initialize-memory.sh
    print_success "Memory initialized"
else
    print_warning "Memory initialization script not found"
fi

# Step 9: Test Claude Code installation
echo ""
echo "Step 9: Testing Claude Code installation..."
if claude --version &> /dev/null; then
    CLAUDE_VERSION=$(claude --version)
    print_success "Claude Code is working: $CLAUDE_VERSION"
else
    print_error "Claude Code test failed"
fi

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
echo "   - Install 'Local REST API' plugin"
echo "   - Generate API key and add to config"
echo ""
echo "3. CHOOSE YOUR AGENT:"
echo "   Your agent library is at: $AGENTS_DIR"
echo "   Copy an agent to your project as CLAUDE.md:"
echo "   cp $AGENTS_DIR/HLA-Research-Agent.md ./CLAUDE.md"
echo ""
echo "4. CREATE CUSTOM AGENTS:"
echo "   Use the template: $AGENTS_DIR/AGENT_TEMPLATE.md"
echo "   Create specialized agents for different tasks"
echo ""
echo "5. TEST THE SYSTEM:"
echo "   Run: claude"
echo "   Then type: /mcp"
echo "   You should see all servers connected"
echo ""
echo "Documentation: https://github.com/VMWM/HLA_Agent-MCP_System"
echo ""
print_success "Happy researching!"