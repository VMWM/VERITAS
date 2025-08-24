#!/bin/bash

# Research Agent-MCP System Setup Script
# Complete installation including all MCP servers

echo "Research Agent-MCP System Setup"
echo "================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running from correct directory
if [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}Error: CLAUDE.md not found. Please run from the repository root.${NC}"
    exit 1
fi

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check for npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}npm is not installed. Please install Node.js and npm first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check for npx
if ! command -v npx &> /dev/null; then
    echo -e "${RED}npx is not installed. Please update npm: npm install -g npx${NC}"
    exit 1
fi

echo -e "${GREEN}Prerequisites check passed!${NC}"
echo ""

# Get project directory
echo "Enter your project directory path (where CLAUDE.md should be placed):"
read -r PROJECT_DIR

# Validate directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Directory $PROJECT_DIR does not exist.${NC}"
    exit 1
fi

echo ""
echo "Installing to: $PROJECT_DIR"
echo ""

# Install MCP Servers
echo "================================"
echo "Installing MCP Servers"
echo "================================"
echo ""

# Sequential Thinking MCP
echo "Installing Sequential Thinking MCP..."
npx @modelcontextprotocol/install sequentialthinking
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Sequential Thinking MCP installed${NC}"
else
    echo -e "${YELLOW}⚠ Sequential Thinking MCP installation may have failed${NC}"
fi
echo ""

# PubMed MCP (using cyanheads version to avoid debug output issues)
echo "Installing PubMed MCP (cyanheads version)..."
npm install -g @cyanheads/pubmed-mcp-server
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PubMed MCP (cyanheads) installed${NC}"
else
    echo -e "${YELLOW}⚠ PubMed MCP installation may have failed${NC}"
fi
echo ""

# Memory MCP
echo "Installing Memory MCP..."
npx @modelcontextprotocol/install memory
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Memory MCP installed${NC}"
else
    echo -e "${YELLOW}⚠ Memory MCP installation may have failed${NC}"
fi
echo ""

# Filesystem MCP
echo "Installing Filesystem MCP..."
npx @modelcontextprotocol/install filesystem
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Filesystem MCP installed${NC}"
else
    echo -e "${YELLOW}⚠ Filesystem MCP installation may have failed${NC}"
fi
echo ""

# Conversation Logger
echo "Installing Conversation Logger dependencies..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/conversation-logger"
npm install --silent
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Conversation Logger dependencies installed${NC}"
    # Initialize database
    mkdir -p ~/.conversation-logger
    echo -e "${GREEN}✓ Conversation Logger database directory created${NC}"
else
    echo -e "${YELLOW}⚠ Conversation Logger installation may have failed${NC}"
fi
cd "$SCRIPT_DIR"
echo ""

# Copy core files
echo "================================"
echo "Copying Project Files"
echo "================================"
echo ""

echo "Copying CLAUDE.md..."
cp CLAUDE.md "$PROJECT_DIR/"
echo -e "${GREEN}✓ CLAUDE.md copied${NC}"

echo "Copying .claude directory..."
cp -r .claude "$PROJECT_DIR/"
echo -e "${GREEN}✓ .claude directory copied${NC}"

# Make hooks executable
echo "Setting hook permissions..."
chmod +x "$PROJECT_DIR/.claude/hooks/"*.sh 2>/dev/null
chmod +x "$PROJECT_DIR/.claude/hooks/"*.py 2>/dev/null
chmod +x "$PROJECT_DIR/.claude/scripts/"*.py 2>/dev/null
echo -e "${GREEN}✓ Permissions set${NC}"

# Update paths in settings.local.json
echo "Configuring hook paths..."
if [ -f "$PROJECT_DIR/.claude/settings.local.json.template" ]; then
    sed "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$PROJECT_DIR/.claude/settings.local.json.template" > "$PROJECT_DIR/.claude/settings.local.json"
    echo -e "${GREEN}✓ Hook paths configured${NC}"
else
    echo -e "${YELLOW}⚠ settings.local.json.template not found, hooks may not work${NC}"
fi

# Update paths in CLAUDE.md
echo ""
echo "Updating paths in CLAUDE.md..."
sed -i.bak "s|\[Your project directory\]|$PROJECT_DIR|g" "$PROJECT_DIR/CLAUDE.md"
echo -e "${GREEN}✓ Paths updated${NC}"

# Create logs directory
echo "Creating logs directory..."
mkdir -p "$PROJECT_DIR/.claude/logs"
echo -e "${GREEN}✓ Logs directory created${NC}"

# Obsidian Configuration
echo ""
echo "================================"
echo "Obsidian Configuration"
echo "================================"
echo ""

echo "Have you installed the Obsidian Local REST API plugin? (y/n)"
read -r OBSIDIAN_INSTALLED

if [ "$OBSIDIAN_INSTALLED" = "y" ]; then
    echo "Enter the port for your HLA/primary vault (default: 27124):"
    read -r PRIMARY_PORT
    PRIMARY_PORT=${PRIMARY_PORT:-27124}
    
    echo "Enter the API key for your HLA/primary vault:"
    read -r BEARER_TOKEN
    
    echo "Enter the port for your journal vault (default: 27125):"
    read -r JOURNAL_PORT
    JOURNAL_PORT=${JOURNAL_PORT:-27125}
    
    echo "Enter the API key for your journal vault (or same as primary):"
    read -r JOURNAL_TOKEN
    JOURNAL_TOKEN=${JOURNAL_TOKEN:-$BEARER_TOKEN}
    
    echo -e "${GREEN}✓ Obsidian configuration noted${NC}"
    echo ""
    echo "Note: The configuration below uses REST API connections."
    echo "Claude will connect directly to your Obsidian vaults."
    echo ""
    echo "Add this to your Claude Desktop configuration:"
    echo ""
    cat << EOF
"obsidian-rest-hla": {
  "command": "npx",
  "args": ["obsidian-mcp-server"],
  "env": {
    "OBSIDIAN_API_KEY": "$BEARER_TOKEN",
    "OBSIDIAN_BASE_URL": "https://127.0.0.1:$PRIMARY_PORT",
    "OBSIDIAN_VERIFY_SSL": "false",
    "OBSIDIAN_ENABLE_CACHE": "true"
  }
}

"obsidian-rest-journal": {
  "command": "npx",
  "args": ["obsidian-mcp-server"],
  "env": {
    "OBSIDIAN_API_KEY": "$JOURNAL_TOKEN",
    "OBSIDIAN_BASE_URL": "https://127.0.0.1:$JOURNAL_PORT",
    "OBSIDIAN_VERIFY_SSL": "false",
    "OBSIDIAN_ENABLE_CACHE": "true"
  }
}
EOF
else
    echo ""
    echo -e "${YELLOW}Please install the Obsidian Local REST API plugin:${NC}"
    echo "1. Open Obsidian"
    echo "2. Go to Settings > Community Plugins"
    echo "3. Search for 'Local REST API'"
    echo "4. Install and enable the plugin"
    echo "5. Configure authentication if needed"
fi

# Test hook execution
echo ""
echo "================================"
echo "Testing Installation"
echo "================================"
echo ""

echo "Testing hook execution..."
if bash "$PROJECT_DIR/.claude/hooks/pre-command.sh" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Hooks are working correctly${NC}"
else
    echo -e "${YELLOW}⚠ Hooks may not be configured correctly${NC}"
    echo "Please check file permissions and paths."
fi

# Generate Claude Desktop config
echo ""
echo "================================"
echo "Claude Desktop Configuration"
echo "================================"
echo ""
echo "Step 1: Configure Claude Desktop"
echo "---------------------------------"
echo "Add the following to your Claude Desktop config file:"
echo "(Usually at ~/Library/Application Support/Claude/claude_desktop_config.json)"
echo ""

cat << EOF
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed-cyanheads": {
      "command": "npx",
      "args": ["@cyanheads/pubmed-mcp-server"],
      "env": {
        "MCP_TRANSPORT_TYPE": "stdio",
        "MCP_LOG_LEVEL": "error",
        "NODE_ENV": "production"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "filesystem-local": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "$PROJECT_DIR"]
    },
    "conversation-logger": {
      "command": "node",
      "args": ["$SCRIPT_DIR/conversation-logger/index.js"],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
EOF

echo ""
echo "Step 2: Configure Claude Code CLI"
echo "----------------------------------"
echo "After configuring Claude Desktop and restarting it, run:"
echo ""
echo -e "${GREEN}  claude mcp add-from-claude-desktop${NC}"
echo ""
echo "This will automatically import all MCP servers to Claude Code CLI."
echo "Select all servers when prompted and press Enter to confirm."
echo ""
echo "To verify the import worked, run:"
echo -e "${GREEN}  claude mcp list${NC}"

# Final instructions
echo ""
echo "================================"
echo -e "${GREEN}Setup Complete!${NC}"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Run the configuration script to set up Claude:"
echo -e "   ${GREEN}./scripts/configure-claude.sh${NC}"
echo "   This will create configs for both Claude Desktop and CLI"
echo "2. Update PROJECT CONTEXT section in $PROJECT_DIR/CLAUDE.md"
echo "3. Restart Claude Desktop and/or Claude CLI"
echo "5. Configure your Obsidian vault structure:"
echo "   - Create 'Research Questions' folder"
echo "   - Create 'Concepts' folder"
echo "   - Create 'Daily' folder for journals"
echo "6. Test the system with a simple task"
echo ""
echo "To test, start a new Claude Code conversation and try:"
echo "  'Create a research question about [your topic] in my vault'"
echo ""
echo "For detailed documentation, see:"
echo "  - docs/MCP_INSTALLATION.md"
echo "  - docs/SETUP.md"
echo "  - docs/TROUBLESHOOTING.md"
echo ""
echo "Templates are available in: templates/obsidian/"