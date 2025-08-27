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
if [ ! -f "templates/CLAUDE.md.template" ]; then
    echo -e "${RED}Error: CLAUDE.md.template not found. Please run from the repository root.${NC}"
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

# Expand tilde if present
PROJECT_DIR="${PROJECT_DIR/#\~/$HOME}"

# Validate directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Directory $PROJECT_DIR does not exist.${NC}"
    echo "Would you like to create it? (y/n)"
    read -r CREATE_DIR
    if [[ $CREATE_DIR =~ ^[Yy]$ ]]; then
        mkdir -p "$PROJECT_DIR"
        echo -e "${GREEN}✓ Created directory: $PROJECT_DIR${NC}"
    else
        exit 1
    fi
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
echo "Verifying Sequential Thinking MCP..."
# MCP servers run directly with npx, no installation needed
echo -e "${GREEN}✓ Sequential Thinking MCP will run with npx${NC}"
echo ""

# PubMed MCP (using cyanheads version to avoid debug output issues)
echo "Installing PubMed MCP (cyanheads version)..."
echo "  (Note: Deprecation warnings are expected and safe to ignore)"
npm install -g @cyanheads/pubmed-mcp-server --loglevel=error
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PubMed MCP (cyanheads) installed${NC}"
else
    echo -e "${RED}✗ PubMed MCP installation failed${NC}"
    echo "This is a critical component. Please fix and re-run setup."
    exit 1
fi
echo ""

# Memory MCP
echo "Verifying Memory MCP..."
# MCP servers run directly with npx, no installation needed
echo -e "${GREEN}✓ Memory MCP will run with npx${NC}"
echo ""

# Filesystem MCP
echo "Verifying Filesystem MCP..."
# MCP servers run directly with npx, no installation needed
echo -e "${GREEN}✓ Filesystem MCP will run with npx${NC}"
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

# Configure automatic cleanup for conversation logger
echo "Configuring conversation logger cleanup..."
CLEANUP_SCRIPT="$SCRIPT_DIR/conversation-logger/cleanup-old-logs.js"
if [ -f "$CLEANUP_SCRIPT" ]; then
    chmod +x "$CLEANUP_SCRIPT"
    
    # Check if user wants automatic cleanup
    echo ""
    echo "How would you like to manage conversation logs?"
    echo "1) Auto-cleanup after 5 days (recommended)"
    echo "2) Keep indefinitely (no automatic cleanup)"
    echo "3) Custom retention period"
    echo ""
    read -p "Choose an option (1-3): " CLEANUP_CHOICE
    
    case $CLEANUP_CHOICE in
        1)
            # Default 5-day cleanup
            RETENTION_DAYS=5
            ENABLE_CLEANUP=true
            echo -e "${GREEN}✓ Will auto-cleanup logs older than 5 days${NC}"
            ;;
        2)
            # Keep indefinitely
            ENABLE_CLEANUP=false
            echo -e "${GREEN}✓ Logs will be kept indefinitely${NC}"
            ;;
        3)
            # Custom retention
            echo ""
            read -p "Enter retention period in days (1-365): " CUSTOM_DAYS
            if [[ $CUSTOM_DAYS =~ ^[0-9]+$ ]] && [ $CUSTOM_DAYS -ge 1 ] && [ $CUSTOM_DAYS -le 365 ]; then
                RETENTION_DAYS=$CUSTOM_DAYS
                ENABLE_CLEANUP=true
                echo -e "${GREEN}✓ Will auto-cleanup logs older than $RETENTION_DAYS days${NC}"
            else
                echo -e "${YELLOW}⚠ Invalid input. Using default 5 days${NC}"
                RETENTION_DAYS=5
                ENABLE_CLEANUP=true
            fi
            ;;
        *)
            # Default to 5 days for invalid input
            RETENTION_DAYS=5
            ENABLE_CLEANUP=true
            echo -e "${YELLOW}⚠ Invalid choice. Using default 5-day cleanup${NC}"
            ;;
    esac
    
    if [ "$ENABLE_CLEANUP" = true ]; then
        # Update the cleanup script with custom retention if needed
        if [ "$RETENTION_DAYS" != "5" ]; then
            sed -i.bak "s/RETENTION_DAYS = 5/RETENTION_DAYS = $RETENTION_DAYS/" "$CLEANUP_SCRIPT"
            echo "  Updated retention period to $RETENTION_DAYS days"
        fi
        
        CRON_CMD="0 2 * * * cd '$SCRIPT_DIR/conversation-logger' && node cleanup-old-logs.js > /tmp/conversation-cleanup.log 2>&1"
        
        # Check if cron job already exists
        if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
            echo -e "${GREEN}✓ Cleanup job already scheduled${NC}"
        else
            # Add to crontab
            (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
            echo -e "${GREEN}✓ Automatic cleanup scheduled for 2 AM daily${NC}"
            echo "  Logs older than $RETENTION_DAYS days will be automatically removed"
        fi
    else
        echo "  No automatic cleanup configured"
        echo "  To manually clean old logs, run:"
        echo "  node '$SCRIPT_DIR/conversation-logger/cleanup-old-logs.js'"
    fi
else
    echo -e "${YELLOW}⚠ Cleanup script not found${NC}"
fi
echo ""

# Obsidian MCP Server (for REST API integration)
echo "Installing Obsidian MCP Server..."
npm install -g obsidian-mcp-server --loglevel=error
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Obsidian MCP Server installed${NC}"
else
    echo -e "${YELLOW}⚠ Obsidian MCP Server installation may have failed${NC}"
    echo "  You can install it later with: npm install -g obsidian-mcp-server"
fi
echo ""

# Copy core files
echo "================================"
echo "Copying Project Files"
echo "================================"
echo ""

echo "Copying CLAUDE.md template..."
cp templates/CLAUDE.md.template "$PROJECT_DIR/CLAUDE.md"
echo -e "${GREEN}✓ CLAUDE.md template copied - please customize it for your project${NC}"

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

# Environment file will be created after Obsidian configuration
ENV_FILE="$PROJECT_DIR/.claude/env.sh"

# Note about CLAUDE.md customization
echo ""
echo -e "${YELLOW}Note: CLAUDE.md is a template - please customize it for your project${NC}"

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
    # Arrays to store vault configurations
    VAULT_NAMES=()
    VAULT_PATHS=()
    VAULT_PORTS=()
    VAULT_TOKENS=()
    
    VAULT_COUNT=0
    DEFAULT_PORT=27124
    
    # Loop to add vaults
    while true; do
        VAULT_COUNT=$((VAULT_COUNT + 1))
        echo ""
        echo "Vault #$VAULT_COUNT Configuration"
        echo "------------------------"
        
        if [ $VAULT_COUNT -eq 1 ]; then
            echo "Enter a name for your first vault (e.g., 'hla', 'research', 'main'):"
        else
            echo "Enter a name for vault #$VAULT_COUNT (or press Enter to finish):"
        fi
        read -r VAULT_NAME
        
        # If no name entered and not the first vault, we're done
        if [ -z "$VAULT_NAME" ] && [ $VAULT_COUNT -gt 1 ]; then
            VAULT_COUNT=$((VAULT_COUNT - 1))
            break
        fi
        
        # First vault is required
        if [ -z "$VAULT_NAME" ] && [ $VAULT_COUNT -eq 1 ]; then
            echo -e "${RED}At least one vault is required${NC}"
            VAULT_NAME="primary"
            echo "Using default name: $VAULT_NAME"
        fi
        
        VAULT_NAMES+=("$VAULT_NAME")
        
        echo "Enter the path to your '$VAULT_NAME' vault:"
        echo "(e.g., /Users/yourname/Obsidian/$VAULT_NAME)"
        read -r VAULT_PATH
        # Expand tilde if present
        VAULT_PATH="${VAULT_PATH/#\~/$HOME}"
        VAULT_PATHS+=("$VAULT_PATH")
        
        SUGGESTED_PORT=$((DEFAULT_PORT + VAULT_COUNT - 1))
        echo "Enter the port for '$VAULT_NAME' vault (default: $SUGGESTED_PORT):"
        read -r VAULT_PORT
        VAULT_PORT=${VAULT_PORT:-$SUGGESTED_PORT}
        VAULT_PORTS+=("$VAULT_PORT")
        
        echo "Enter the API key for '$VAULT_NAME' vault:"
        read -r VAULT_TOKEN
        VAULT_TOKENS+=("$VAULT_TOKEN")
        
        echo -e "${GREEN}✓ Vault '$VAULT_NAME' configured${NC}"
        
        # Ask if they want to add another vault
        if [ $VAULT_COUNT -ge 1 ]; then
            echo ""
            read -p "Add another vault? (y/n): " ADD_MORE
            if [[ ! $ADD_MORE =~ ^[Yy]$ ]]; then
                break
            fi
        fi
    done
    
    echo ""
    echo -e "${GREEN}✓ Configured $VAULT_COUNT vault(s)${NC}"
    for i in "${!VAULT_NAMES[@]}"; do
        echo "  - ${VAULT_NAMES[$i]}: ${VAULT_PATHS[$i]} (port ${VAULT_PORTS[$i]})"
    done
    echo ""
    echo "Note: The configuration below uses REST API connections."
    echo "Claude will connect directly to your Obsidian vaults."
    echo ""
    echo "Add this to your Claude Desktop configuration:"
    echo ""
    echo "{"
    echo '  "mcpServers": {'
    
    # Generate config for each vault
    for i in "${!VAULT_NAMES[@]}"; do
        if [ $i -gt 0 ]; then
            echo ","
        fi
        cat << EOF
    "obsidian-rest-${VAULT_NAMES[$i]}": {
      "command": "npx",
      "args": ["obsidian-mcp-server"],
      "env": {
        "OBSIDIAN_API_KEY": "${VAULT_TOKENS[$i]}",
        "OBSIDIAN_BASE_URL": "https://127.0.0.1:${VAULT_PORTS[$i]}",
        "OBSIDIAN_VERIFY_SSL": "false",
        "OBSIDIAN_ENABLE_CACHE": "true"
      }
    }
EOF
    done
    
    echo "  }"
    echo "}"
else
    echo ""
    echo -e "${YELLOW}Please install the Obsidian Local REST API plugin:${NC}"
    echo "1. Open Obsidian"
    echo "2. Go to Settings > Community Plugins"
    echo "3. Search for 'Local REST API'"
    echo "4. Install and enable the plugin"
    echo "5. Configure authentication if needed"
fi

# Create environment setup file AFTER Obsidian configuration
echo ""
echo "Creating environment configuration..."

cat > "$ENV_FILE" << EOF
#!/bin/bash
# VERITAS Environment Configuration  
# Source this file or add to your shell profile

export CLAUDE_PROJECT_DIR="$PROJECT_DIR"
export ENFORCE_OBSIDIAN_MCP=1

# Obsidian vault configurations
EOF

# Add vault configurations if any were provided
if [ ${#VAULT_NAMES[@]} -gt 0 ]; then
    echo "# Configured vaults: ${VAULT_NAMES[*]}" >> "$ENV_FILE"
    for i in "${!VAULT_NAMES[@]}"; do
        VAULT_NAME_UPPER=$(echo "${VAULT_NAMES[$i]}" | tr '[:lower:]' '[:upper:]')
        cat >> "$ENV_FILE" << EOF
export OBSIDIAN_${VAULT_NAME_UPPER}_PATH="${VAULT_PATHS[$i]}"
export OBSIDIAN_${VAULT_NAME_UPPER}_PORT="${VAULT_PORTS[$i]}"
export OBSIDIAN_${VAULT_NAME_UPPER}_TOKEN="${VAULT_TOKENS[$i]}"
EOF
    done
    
    # For backward compatibility, set the first vault as primary
    if [ ${#VAULT_NAMES[@]} -gt 0 ]; then
        cat >> "$ENV_FILE" << EOF

# Backward compatibility - first vault as primary
export OBSIDIAN_VAULT_PATH="${VAULT_PATHS[0]}"
export OBSIDIAN_API_KEY="${VAULT_TOKENS[0]}"
export OBSIDIAN_PRIMARY_PORT="${VAULT_PORTS[0]}"
EOF
    fi
else
    # No vaults configured, use defaults
    cat >> "$ENV_FILE" << EOF
# No vaults configured - using defaults
export OBSIDIAN_VAULT_PATH="$HOME/Obsidian/Vault"
export OBSIDIAN_API_KEY=""
export OBSIDIAN_PRIMARY_PORT="27124"
EOF
fi

chmod +x "$ENV_FILE"
echo -e "${GREEN}✓ Environment configuration created at .claude/env.sh${NC}"
echo "  Add this to your shell profile: source $ENV_FILE"

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

# Get absolute path for conversation logger
CONV_LOGGER_PATH="$SCRIPT_DIR/conversation-logger/index.js"

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
      "args": ["$CONV_LOGGER_PATH"],
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
echo "Conversation Logger Status:"
echo "  - Database: ~/.conversation-logger/conversations.db"
echo "  - Retention: 5 days (configurable)"
if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
    echo "  - Cleanup: Automatic at 2 AM daily"
else
    echo "  - Cleanup: Manual (run: node conversation-logger/cleanup-old-logs.js)"
fi
echo ""
echo "Next steps:"
echo "1. Configure Claude to use the installed MCP servers:"
echo -e "   ${GREEN}cd $SCRIPT_DIR && ./scripts/setup/configure-claude.sh${NC}"
echo "   This will add the MCP servers to your Claude configuration"
echo "   Choose option 1 (merge) if you have existing servers configured"
echo "2. Customize $PROJECT_DIR/CLAUDE.md for your specific project"
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