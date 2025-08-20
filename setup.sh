#!/bin/bash

# HLA Research MCP System - Claude Code Setup
# For macOS systems with cloud storage
# Version: 3.0 (Cloud-agnostic)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================"
echo "HLA Research MCP System - Claude Code Setup"
echo "Version 3.1 - With Content Validation"
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

# Step 4: Choose cloud provider
echo ""
echo "Step 4: Configuring cloud storage location..."
echo ""
echo "Choose your cloud storage provider:"
echo "  1) iCloud Drive (default)"
echo "  2) Dropbox"
echo "  3) Google Drive"
echo "  4) Box"
echo "  5) OneDrive"
echo "  6) Custom path"
echo ""
read -p "Enter your choice (1-6) [1]: " cloud_choice
cloud_choice=${cloud_choice:-1}

# Set the base cloud directory based on choice
case $cloud_choice in
    1)
        CLOUD_BASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
        CLOUD_NAME="iCloud Drive"
        ;;
    2)
        CLOUD_BASE="$HOME/Dropbox"
        CLOUD_NAME="Dropbox"
        ;;
    3)
        CLOUD_BASE="$HOME/Google Drive"
        if [ ! -d "$CLOUD_BASE" ]; then
            # Try alternate path
            CLOUD_BASE="$HOME/Library/CloudStorage/GoogleDrive-*"
            CLOUD_BASE=$(echo $CLOUD_BASE | head -n1)
        fi
        CLOUD_NAME="Google Drive"
        ;;
    4)
        CLOUD_BASE="$HOME/Library/CloudStorage/Box-Box"
        CLOUD_NAME="Box"
        ;;
    5)
        CLOUD_BASE="$HOME/OneDrive"
        if [ ! -d "$CLOUD_BASE" ]; then
            # Try alternate path
            CLOUD_BASE="$HOME/Library/CloudStorage/OneDrive-*"
            CLOUD_BASE=$(echo $CLOUD_BASE | head -n1)
        fi
        CLOUD_NAME="OneDrive"
        ;;
    6)
        read -p "Enter the full path to your cloud storage folder: " CLOUD_BASE
        CLOUD_NAME="Custom location"
        ;;
    *)
        print_error "Invalid choice. Using iCloud Drive as default."
        CLOUD_BASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
        CLOUD_NAME="iCloud Drive"
        ;;
esac

# Verify cloud directory exists
if [ ! -d "$CLOUD_BASE" ]; then
    print_warning "Cloud directory not found at: $CLOUD_BASE"
    read -p "Would you like to create it? (y/n) [y]: " create_cloud
    create_cloud=${create_cloud:-y}
    if [[ "$create_cloud" == "y" ]]; then
        mkdir -p "$CLOUD_BASE"
        print_success "Created cloud directory"
    else
        print_error "Please ensure your cloud storage is set up and try again."
        exit 1
    fi
else
    print_success "Using $CLOUD_NAME at: $CLOUD_BASE"
fi

# Step 5: Choose Obsidian location
echo ""
echo "Step 5: Configuring Obsidian vault location..."
echo ""
echo "Where do you store your Obsidian vaults?"
echo "  1) Same cloud provider as MCP config"
echo "  2) Different location"
echo ""
read -p "Enter your choice (1-2) [1]: " obsidian_choice
obsidian_choice=${obsidian_choice:-1}

if [[ "$obsidian_choice" == "2" ]]; then
    echo ""
    echo "Choose Obsidian storage location:"
    echo "  1) iCloud Drive"
    echo "  2) Dropbox"
    echo "  3) Google Drive"
    echo "  4) Box"
    echo "  5) OneDrive"
    echo "  6) Local folder (not synced)"
    echo "  7) Custom path"
    echo ""
    read -p "Enter your choice (1-7): " obs_location
    
    case $obs_location in
        1)
            OBSIDIAN_BASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Obsidian"
            ;;
        2)
            OBSIDIAN_BASE="$HOME/Dropbox/Obsidian"
            ;;
        3)
            OBSIDIAN_BASE="$HOME/Google Drive/Obsidian"
            if [ ! -d "$(dirname "$OBSIDIAN_BASE")" ]; then
                OBSIDIAN_BASE="$HOME/Library/CloudStorage/GoogleDrive-*/Obsidian"
                OBSIDIAN_BASE=$(echo $OBSIDIAN_BASE | head -n1)
            fi
            ;;
        4)
            OBSIDIAN_BASE="$HOME/Library/CloudStorage/Box-Box/Obsidian"
            ;;
        5)
            OBSIDIAN_BASE="$HOME/OneDrive/Obsidian"
            if [ ! -d "$(dirname "$OBSIDIAN_BASE")" ]; then
                OBSIDIAN_BASE="$HOME/Library/CloudStorage/OneDrive-*/Obsidian"
                OBSIDIAN_BASE=$(echo $OBSIDIAN_BASE | head -n1)
            fi
            ;;
        6)
            OBSIDIAN_BASE="$HOME/Documents/Obsidian"
            ;;
        7)
            read -p "Enter the full path to your Obsidian folder: " OBSIDIAN_BASE
            ;;
        *)
            OBSIDIAN_BASE="$CLOUD_BASE/Obsidian"
            ;;
    esac
else
    OBSIDIAN_BASE="$CLOUD_BASE/Obsidian"
fi

print_info "Obsidian vaults will be at: $OBSIDIAN_BASE"

# Step 6: Create directory structure
echo ""
echo "Step 6: Creating directory structure..."

# MCP-Shared directory
MCP_DIR="$CLOUD_BASE/MCP-Shared"
if [ ! -d "$MCP_DIR" ]; then
    mkdir -p "$MCP_DIR"
    print_success "Created MCP-Shared directory"
else
    print_warning "MCP-Shared directory already exists"
fi

# Save the paths to a config file for reference
CONFIG_PATHS="$MCP_DIR/.setup-paths"
cat > "$CONFIG_PATHS" << EOF
# Cloud Storage Configuration
# Generated by setup.sh on $(date)
CLOUD_PROVIDER="$CLOUD_NAME"
CLOUD_BASE="$CLOUD_BASE"
MCP_DIR="$MCP_DIR"
OBSIDIAN_BASE="$OBSIDIAN_BASE"
EOF
print_success "Saved configuration paths for reference"

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

# Obsidian vault directories
if [ ! -d "$OBSIDIAN_BASE" ]; then
    mkdir -p "$OBSIDIAN_BASE"
    print_success "Created Obsidian base directory"
fi

# Example vault structure (customize for your research)
echo ""
print_info "Creating example vault structure..."
print_warning "IMPORTANT: Rename these vaults to match your research area!"

# Example Research vault (rename to your field)
RESEARCH_VAULT="$OBSIDIAN_BASE/HLA Antibodies"  # Change to your research area
if [ ! -d "$RESEARCH_VAULT" ]; then
    mkdir -p "$RESEARCH_VAULT/Research Questions"
    mkdir -p "$RESEARCH_VAULT/Concepts"
    print_success "Created example research vault: 'HLA Antibodies'"
    print_warning "➜ Rename 'HLA Antibodies' to your research field (e.g., 'Cancer Biology', 'Neuroscience')"
else
    print_warning "Research vault already exists"
fi

# Research Journal vault (recommended to keep)
JOURNAL_VAULT="$OBSIDIAN_BASE/Research Journal"
if [ ! -d "$JOURNAL_VAULT" ]; then
    mkdir -p "$JOURNAL_VAULT/Daily"
    mkdir -p "$JOURNAL_VAULT/Concepts"
    print_success "Created Research Journal vault"
else
    print_warning "Research Journal vault already exists"
fi

echo ""
print_warning "Remember to customize vault names for your research!"
print_info "See docs/PERSONAL_SETUP.md for detailed instructions"

# Step 7: Copy configuration template
echo ""
echo "Step 7: Setting up configuration..."
CONFIG_FILE="$MCP_DIR/claude-desktop-config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "config/claude-desktop-config.template.json" ]; then
        cp "config/claude-desktop-config.template.json" "$CONFIG_FILE"
        print_success "Configuration template copied to MCP-Shared"
        print_warning "IMPORTANT: Edit the config file to add your API keys"
        print_info "Config location: $CONFIG_FILE"
    else
        print_error "Configuration template not found. Please ensure you're running from the repository root."
        exit 1
    fi
else
    print_warning "Configuration already exists"
fi

# Step 8: Create symlink
echo ""
echo "Step 8: Creating symlink for Claude Code..."
SYMLINK="$HOME/.claude.json"
if [ ! -L "$SYMLINK" ]; then
    ln -s "$CONFIG_FILE" "$SYMLINK"
    print_success "Symlink created: ~/.claude.json → MCP-Shared config"
else
    if [ -L "$SYMLINK" ]; then
        print_warning "Symlink already exists"
        # Verify it points to the right place
        CURRENT_TARGET=$(readlink "$SYMLINK")
        if [ "$CURRENT_TARGET" != "$CONFIG_FILE" ]; then
            print_warning "Symlink points to different location: $CURRENT_TARGET"
            read -p "Update symlink to new location? (y/n) [y]: " update_link
            update_link=${update_link:-y}
            if [[ "$update_link" == "y" ]]; then
                rm "$SYMLINK"
                ln -s "$CONFIG_FILE" "$SYMLINK"
                print_success "Symlink updated"
            fi
        fi
    else
        print_error "~/.claude.json exists but is not a symlink. Please remove it manually."
        exit 1
    fi
fi

# Step 9: Copy templates and agent files
echo ""
echo "Step 9: Installing templates and agent library..."

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

# Copy validation configuration
if [ -f "config/obsidian-content-validation.json" ]; then
    cp "config/obsidian-content-validation.json" "$HLA_DIR/config/" 2>/dev/null || true
    print_success "Content validation rules installed"
else
    print_warning "Content validation config not found - creating default"
    echo '{"obsidian_content_validation": {"version": "1.0"}}' > "$HLA_DIR/config/obsidian-content-validation.json"
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
   cp [agent-file] ~/my-project/CLAUDE.md
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

# Step 10: Initialize Memory (if script exists)
echo ""
echo "Step 10: Initializing memory..."
if [ -f "scripts/initialize-memory.sh" ]; then
    bash scripts/initialize-memory.sh
    print_success "Memory initialized"
else
    print_warning "Memory initialization script not found"
fi

# Step 11: Test Claude Code installation
echo ""
echo "Step 11: Testing Claude Code installation..."
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
echo "📁 YOUR CONFIGURATION:"
echo "   Cloud Provider: $CLOUD_NAME"
echo "   MCP Config: $MCP_DIR"
echo "   Obsidian Vaults: $OBSIDIAN_BASE"
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
echo "3. CUSTOMIZE VAULTS:"
echo "   Current example vault: '$OBSIDIAN_BASE/HLA Antibodies'"
echo "   ➜ Rename to your research area (e.g., 'Cancer Biology')"
echo ""
echo "4. CHOOSE YOUR AGENT:"
echo "   Your agent library is at: $AGENTS_DIR"
echo "   Copy an agent to your project as CLAUDE.md:"
echo "   cp \"$AGENTS_DIR/HLA-Research-Agent.md\" ./CLAUDE.md"
echo ""
echo "5. CREATE CUSTOM AGENTS:"
echo "   Use the template: $AGENTS_DIR/AGENT_TEMPLATE.md"
echo "   Create specialized agents for different tasks"
echo ""
echo "6. TEST THE SYSTEM:"
echo "   Run: claude"
echo "   Then type: /mcp"
echo "   You should see all servers connected"
echo ""
echo "7. CUSTOMIZE FOR YOUR RESEARCH:"
echo "   Read: docs/PERSONAL_SETUP.md"
echo "   - Rename vaults to match your field"
echo "   - Create custom agents for your domain"
echo "   - Modify templates for your workflow"
echo ""
echo "Documentation: https://github.com/VMWM/HLA_Agent-MCP_System"
echo ""
print_success "Happy researching!"