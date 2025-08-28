#!/bin/bash

# Configure Claude Desktop and CLI with MCP servers
# This script merges configurations with existing setups

echo "════════════════════════════════════════════════"
echo "Claude Configuration Setup"
echo "════════════════════════════════════════════════"
echo ""

# Get script directory and VERITAS root (two levels up)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERITAS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    CLAUDE_CLI_CONFIG="$HOME/.claude.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    CLAUDE_DESKTOP_CONFIG="$HOME/.config/Claude/claude_desktop_config.json"
    CLAUDE_CLI_CONFIG="$HOME/.claude.json"
else
    echo -e "${RED}Unsupported OS. Please configure manually.${NC}"
    exit 1
fi

echo "Detected configuration paths:"
echo "  Desktop: $CLAUDE_DESKTOP_CONFIG"
echo "  CLI: $CLAUDE_CLI_CONFIG"
echo ""

# Function to create config directory if needed
ensure_dir() {
    local file_path="$1"
    local dir_path="$(dirname "$file_path")"
    if [ ! -d "$dir_path" ]; then
        echo "Creating directory: $dir_path"
        mkdir -p "$dir_path"
    fi
}

# Check for existing configurations
echo "Checking for existing configurations..."
echo ""

EXISTING_DESKTOP=false
EXISTING_CLI=false

if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
    echo -e "${YELLOW}Warning: Found existing Claude Desktop configuration${NC}"
    EXISTING_DESKTOP=true
    # Count existing MCP servers
    DESKTOP_COUNT=$(jq '.mcpServers | length' "$CLAUDE_DESKTOP_CONFIG" 2>/dev/null || echo "0")
    echo "  Current MCP servers: $DESKTOP_COUNT"
fi

if [ -f "$CLAUDE_CLI_CONFIG" ]; then
    echo -e "${YELLOW}Warning: Found existing Claude CLI configuration${NC}"
    EXISTING_CLI=true
    # Count existing MCP servers
    CLI_COUNT=$(jq '.mcpServers | length' "$CLAUDE_CLI_CONFIG" 2>/dev/null || echo "0")
    echo "  Current MCP servers: $CLI_COUNT"
fi

echo ""

# Ask user how to proceed
if [ "$EXISTING_DESKTOP" = true ] || [ "$EXISTING_CLI" = true ]; then
    echo "How would you like to proceed?"
    echo "1) Merge VERITAS servers with existing configuration (recommended)"
    echo "2) Replace entire configuration (will backup existing)"
    echo "3) Show what will be added and exit"
    echo "4) Cancel"
    echo ""
    read -p "Choose an option (1-4): " CHOICE
    
    case $CHOICE in
        1) MODE="merge" ;;
        2) MODE="replace" ;;
        3) MODE="preview" ;;
        4) echo "Cancelled."; exit 0 ;;
        *) echo "Invalid choice. Cancelled."; exit 1 ;;
    esac
else
    MODE="create"
    echo "No existing configurations found. Will create new ones."
fi

# Ask about symlinking
if [ "$MODE" != "preview" ]; then
    echo ""
    echo "Configuration management options:"
    echo ""
    echo "1) Create separate config files (standard setup)"
    echo "   - Desktop and CLI have independent configurations"
    echo "   - Changes must be made to each separately"
    echo "   - Best for: Single machine setups"
    echo ""
    echo "2) Symlink Desktop and CLI configs (unified management)"
    echo "   - Both use the same configuration file"
    echo "   - Changes to one affect both"
    echo "   - Best for: Keeping Desktop and CLI in perfect sync"
    echo ""
    echo ""
    read -p "Choose an option (1-2, default: 1): " SYMLINK_CHOICE
    SYMLINK_CHOICE=${SYMLINK_CHOICE:-1}
    
    if [ "$SYMLINK_CHOICE" = "2" ]; then
        USE_SYMLINKS=true
        echo ""
        echo -e "${BLUE}Will create symlinks for unified configuration${NC}"
        echo "Desktop will use the same config file as CLI (~/.claude.json)"
    else
        USE_SYMLINKS=false
        echo ""
        echo "Will create separate configuration files"
    fi
fi

echo ""

# Collect information
echo "Please provide the following information:"
echo ""

read -p "Project directory path (default: $VERITAS_DIR): " PROJECT_DIR
PROJECT_DIR=${PROJECT_DIR:-$VERITAS_DIR}

echo ""
echo "Obsidian Configuration (press Enter to skip if not using Obsidian):"
echo ""

# Arrays to store vault configurations
VAULT_NAMES=()
VAULT_PORTS=()
VAULT_TOKENS=()

# Ask about first vault
read -p "Do you use Obsidian with MCP? (y/n): " USE_OBSIDIAN

if [[ "$USE_OBSIDIAN" =~ ^[Yy]$ ]]; then
    VAULT_COUNT=0
    DEFAULT_PORT=27124
    
    while true; do
        VAULT_COUNT=$((VAULT_COUNT + 1))
        echo ""
        echo "Vault #$VAULT_COUNT Configuration:"
        echo "------------------------"
        
        if [ $VAULT_COUNT -eq 1 ]; then
            read -p "  Vault name (e.g., 'main', 'research', 'hla'): " VAULT_NAME
        else
            read -p "  Vault name (or press Enter to finish): " VAULT_NAME
        fi
        
        # If no name entered and not the first vault, we're done
        if [ -z "$VAULT_NAME" ] && [ $VAULT_COUNT -gt 1 ]; then
            VAULT_COUNT=$((VAULT_COUNT - 1))
            break
        fi
        
        # First vault is required
        if [ -z "$VAULT_NAME" ] && [ $VAULT_COUNT -eq 1 ]; then
            echo "    Skipping Obsidian configuration"
            VAULT_COUNT=0
            break
        fi
        
        VAULT_NAMES+=("$VAULT_NAME")
        
        SUGGESTED_PORT=$((DEFAULT_PORT + VAULT_COUNT - 1))
        read -p "  Obsidian vault port (default: $SUGGESTED_PORT): " VAULT_PORT
        VAULT_PORT=${VAULT_PORT:-$SUGGESTED_PORT}
        VAULT_PORTS+=("$VAULT_PORT")
        
        read -p "  API token for '$VAULT_NAME' vault: " VAULT_TOKEN
        VAULT_TOKENS+=("$VAULT_TOKEN")
        
        echo -e "${GREEN}✓ Vault '$VAULT_NAME' configured${NC}"
        
        # Ask if they want to add another vault
        if [ $VAULT_COUNT -ge 1 ]; then
            echo ""
            read -p "Do you want to add another vault? (y/n): " ADD_MORE
            if [[ ! $ADD_MORE =~ ^[Yy]$ ]]; then
                break
            fi
        fi
    done
    
    if [ $VAULT_COUNT -gt 0 ]; then
        echo ""
        echo -e "${GREEN}Configured $VAULT_COUNT vault(s)${NC}"
    fi
fi

# Create the VERITAS servers configuration
create_veritas_servers() {
    cat << EOF
{
  "conversation-logger": {
    "_comment": "Custom VERITAS server - runs from VERITAS directory as shared service",
    "command": "node",
    "args": ["$VERITAS_DIR/conversation-logger/index.js"],
    "env": {
      "NODE_ENV": "production"
    }
  },
  "filesystem-local": {
    "command": "npx",
    "args": ["@modelcontextprotocol/server-filesystem", "$PROJECT_DIR"]
  },
  "memory": {
    "command": "npx",
    "args": ["@modelcontextprotocol/server-memory"]
  },
  "pubmed": {
    "command": "npx",
    "args": ["@ncukondo/pubmed-mcp"],
    "env": {
      "PUBMED_EMAIL": "${PUBMED_EMAIL}",
      "PUBMED_API_KEY": "${PUBMED_API_KEY}",
      "PUBMED_CACHE_DIR": "/tmp/pubmed-cache",
      "PUBMED_CACHE_TTL": "86400"
    }
  },
  "sequential-thinking": {
    "command": "npx",
    "args": ["@modelcontextprotocol/server-sequential-thinking"]
  }$(if [ ${#VAULT_NAMES[@]} -gt 0 ]; then echo ","; fi)
EOF

    # Add vault configurations dynamically
    for i in "${!VAULT_NAMES[@]}"; do
        # Add comma before all but the first vault
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

    echo "}"
}

# Function to merge configurations
merge_configs() {
    local existing_file="$1"
    local new_servers=$(create_veritas_servers)
    
    if [ -f "$existing_file" ]; then
        # Merge with existing
        jq --argjson new "$new_servers" '.mcpServers = (.mcpServers // {}) + $new' "$existing_file"
    else
        # Create new
        echo "{\"mcpServers\": $new_servers}"
    fi
}

# Function to create full config
create_full_config() {
    local new_servers=$(create_veritas_servers)
    echo "{\"mcpServers\": $new_servers}"
}

# Preview mode
if [ "$MODE" = "preview" ]; then
    echo -e "${BLUE}The following MCP servers will be added to your Claude configuration:${NC}"
    echo ""
    echo -e "${YELLOW}Note: conversation-logger is custom - it runs from $VERITAS_DIR${NC}"
    echo "      Other servers run via npx (automatically downloaded)"
    echo ""
    create_veritas_servers | jq 'keys[]' | while read -r server; do
        echo "  • ${server//\"/}"
    done
    echo ""
    echo "Note: The MCP server packages are already installed by setup.sh."
    echo "This script configures Claude to use them."
    echo ""
    echo "To apply these changes, run:"
    echo -e "${GREEN}  ./scripts/setup/configure-claude.sh${NC}"
    echo ""
    echo "Then choose:"
    echo "  Option 1 - Merge with your existing configuration (recommended)"
    echo "  Option 2 - Replace your entire configuration"
    exit 0
fi

# Apply configurations
echo ""
echo "Applying configurations..."
echo ""

# Handle CLI configuration first (it will be the master if using symlinks)
if [ "$MODE" = "merge" ]; then
    echo "Merging Claude CLI configuration..."
    
    # Backup existing
    if [ -f "$CLAUDE_CLI_CONFIG" ]; then
        cp "$CLAUDE_CLI_CONFIG" "${CLAUDE_CLI_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "  Backup created"
    fi
    
    # Merge and save
    merge_configs "$CLAUDE_CLI_CONFIG" > "${CLAUDE_CLI_CONFIG}.tmp"
    mv "${CLAUDE_CLI_CONFIG}.tmp" "$CLAUDE_CLI_CONFIG"
    echo -e "${GREEN}✓ Claude CLI configuration merged${NC}"
    
elif [ "$MODE" = "replace" ] || [ "$MODE" = "create" ]; then
    echo "Creating Claude CLI configuration..."
    
    # Backup existing if it exists
    if [ -f "$CLAUDE_CLI_CONFIG" ]; then
        cp "$CLAUDE_CLI_CONFIG" "${CLAUDE_CLI_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "  Backup created"
    fi
    
    # Create new config
    create_full_config > "$CLAUDE_CLI_CONFIG"
    echo -e "${GREEN}✓ Claude CLI configuration created${NC}"
fi

# Handle Desktop configuration
echo ""
if [ "$USE_SYMLINKS" = true ]; then
    echo "Creating symlink for Claude Desktop configuration..."
    ensure_dir "$CLAUDE_DESKTOP_CONFIG"
    
    # Backup existing if it exists
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ] || [ -L "$CLAUDE_DESKTOP_CONFIG" ]; then
        mv "$CLAUDE_DESKTOP_CONFIG" "${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "  Backup created"
    fi
    
    # Create symlink to CLI config
    ln -s "$CLAUDE_CLI_CONFIG" "$CLAUDE_DESKTOP_CONFIG"
    echo -e "${GREEN}✓ Claude Desktop symlinked to CLI configuration${NC}"
    echo -e "${BLUE}  Both will now use the same configuration file${NC}"
    
else
    # Create separate Desktop config
    if [ "$MODE" = "merge" ]; then
        echo "Merging Claude Desktop configuration..."
        ensure_dir "$CLAUDE_DESKTOP_CONFIG"
        
        # Backup existing
        if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
            cp "$CLAUDE_DESKTOP_CONFIG" "${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
            echo "  Backup created"
        fi
        
        # Merge and save
        merge_configs "$CLAUDE_DESKTOP_CONFIG" > "${CLAUDE_DESKTOP_CONFIG}.tmp"
        mv "${CLAUDE_DESKTOP_CONFIG}.tmp" "$CLAUDE_DESKTOP_CONFIG"
        echo -e "${GREEN}✓ Claude Desktop configuration merged${NC}"
        
    elif [ "$MODE" = "replace" ] || [ "$MODE" = "create" ]; then
        echo "Creating Claude Desktop configuration..."
        ensure_dir "$CLAUDE_DESKTOP_CONFIG"
        
        # Backup existing if it exists
        if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
            cp "$CLAUDE_DESKTOP_CONFIG" "${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
            echo "  Backup created"
        fi
        
        # Create new config
        create_full_config > "$CLAUDE_DESKTOP_CONFIG"
        echo -e "${GREEN}✓ Claude Desktop configuration created${NC}"
    fi
fi

# Create project .mcp.json (symlink to CLI config)
echo ""
echo "Setting up project configuration..."
if [ -f "$PROJECT_DIR/.mcp.json" ] || [ -L "$PROJECT_DIR/.mcp.json" ]; then
    echo -e "${YELLOW}Warning: Existing .mcp.json found${NC}"
    read -p "Replace with symlink to CLI config? (y/n): " REPLACE_MCP
    if [ "$REPLACE_MCP" = "y" ]; then
        mv "$PROJECT_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json.backup.$(date +%Y%m%d-%H%M%S)"
        ln -s "$CLAUDE_CLI_CONFIG" "$PROJECT_DIR/.mcp.json"
        echo -e "${GREEN}✓ Project .mcp.json symlinked to CLI config${NC}"
    else
        echo "  Keeping existing .mcp.json"
    fi
else
    ln -s "$CLAUDE_CLI_CONFIG" "$PROJECT_DIR/.mcp.json"
    echo -e "${GREEN}✓ Project .mcp.json symlinked to CLI config${NC}"
fi

# Show summary
echo ""
echo "════════════════════════════════════════════════"
echo "Configuration Complete!"
echo "════════════════════════════════════════════════"
echo ""

if [ "$MODE" = "merge" ]; then
    echo "Added VERITAS MCP servers to existing configurations:"
else
    echo "Created new configurations with VERITAS MCP servers:"
fi

echo ""
create_veritas_servers | jq -r 'keys[]' | while read -r server; do
    echo "  ✓ $server"
done

echo ""
echo "Configuration files:"
echo "  • $CLAUDE_DESKTOP_CONFIG"
echo "  • $CLAUDE_CLI_CONFIG"
if [ -L "$PROJECT_DIR/.mcp.json" ]; then
    echo "  • $PROJECT_DIR/.mcp.json (symlink)"
fi

echo ""
echo "Backups created with timestamp suffix if files existed"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop application"
echo "2. For Claude CLI, run: claude restart"
echo "3. Verify MCP servers are connected"
echo ""

if [ "$EXISTING_DESKTOP" = true ] || [ "$EXISTING_CLI" = true ]; then
    echo -e "${YELLOW}Note: Your existing MCP servers were preserved.${NC}"
    echo "To see all configured servers, run:"
    echo "  jq '.mcpServers | keys' \"$CLAUDE_CLI_CONFIG\""
fi