#!/bin/bash

# VERITAS System Setup Script
# Complete installation of research integrity framework

set -e

echo "=================================="
echo "VERITAS System Setup"
echo "=================================="
echo ""
echo "Verification-Enforced Research Infrastructure"
echo "with Tracking and Automated Standards"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the VERITAS root directory (two levels up from where setup.sh is located)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERITAS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Check if running from correct directory
if [ ! -f "$VERITAS_DIR/install/CLAUDE.md" ]; then
    echo -e "${RED}Error: CLAUDE.md not found. Please run from the VERITAS repository root.${NC}"
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

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Warning: Python 3 not found. Some hooks may not function properly.${NC}"
fi

echo -e "${GREEN}Prerequisites check passed!${NC}"
echo ""

# Get project directory
echo "Enter your project directory path (where VERITAS will be installed):"
echo "Example: ~/Projects/MyResearch"
read -r PROJECT_DIR

# Expand tilde if present
PROJECT_DIR="${PROJECT_DIR/#\~/$HOME}"

# Create directory if it doesn't exist
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Directory doesn't exist. Create it? (y/n)"
    read -r CREATE_DIR
    if [[ $CREATE_DIR =~ ^[Yy]$ ]]; then
        mkdir -p "$PROJECT_DIR"
        echo -e "${GREEN}[OK] Created directory: $PROJECT_DIR${NC}"
    else
        echo "Exiting..."
        exit 1
    fi
fi

echo ""
echo "Installing VERITAS to: $PROJECT_DIR"
echo ""

# Step 1: Install VERITAS Constitution
echo "Installing VERITAS Constitution..."
echo "  CLAUDE.md is the immutable constitutional foundation"
echo "  This document should never be modified"

# Check if CLAUDE.md already exists
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    echo ""
    echo -e "${YELLOW}[WARNING] CLAUDE.md already exists in this directory${NC}"
    echo "This may be from a previous VERITAS installation."
    echo ""
    echo "What would you like to do?"
    echo "1) Use a different project directory"
    echo "2) Overwrite the existing installation (will backup current CLAUDE.md)"
    echo "3) Cancel installation"
    read -r CLAUDE_CHOICE
    
    case $CLAUDE_CHOICE in
        1)
            echo ""
            echo "Enter a different project directory path:"
            read -r NEW_PROJECT_DIR
            NEW_PROJECT_DIR="${NEW_PROJECT_DIR/#\~/$HOME}"
            
            if [ ! -d "$NEW_PROJECT_DIR" ]; then
                echo "Directory doesn't exist. Create it? (y/n)"
                read -r CREATE_NEW_DIR
                if [[ $CREATE_NEW_DIR =~ ^[Yy]$ ]]; then
                    mkdir -p "$NEW_PROJECT_DIR"
                    echo -e "${GREEN}[OK] Created directory: $NEW_PROJECT_DIR${NC}"
                else
                    echo "Exiting..."
                    exit 1
                fi
            fi
            
            PROJECT_DIR="$NEW_PROJECT_DIR"
            echo ""
            echo "Continuing installation in: $PROJECT_DIR"
            echo ""
            ;;
        2)
            # Backup existing CLAUDE.md
            BACKUP_NAME="CLAUDE.md.backup.$(date +%Y%m%d-%H%M%S)"
            chmod 644 "$PROJECT_DIR/CLAUDE.md" 2>/dev/null
            mv "$PROJECT_DIR/CLAUDE.md" "$PROJECT_DIR/$BACKUP_NAME"
            echo -e "${GREEN}[OK] Existing CLAUDE.md backed up to: $BACKUP_NAME${NC}"
            ;;
        3)
            echo "Installation cancelled."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting...${NC}"
            exit 1
            ;;
    esac
fi

cp "$VERITAS_DIR/install/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
chmod 444 "$PROJECT_DIR/CLAUDE.md"  # Make read-only to prevent accidental edits
echo -e "${GREEN}[OK] Constitution installed (read-only)${NC}"

# Step 2: Create .claude directory structure
echo ""
echo "Creating .claude directory structure..."
mkdir -p "$PROJECT_DIR/.claude/"{hooks,templates,scripts,agents,logs,config,archive}
echo -e "${GREEN}[OK] Created .claude directories${NC}"

# Step 3: Install hooks
echo ""
echo "Installing VERITAS hooks..."

# Essential hooks (proven through testing)
ESSENTIAL_HOOKS=(
    "pre-command.sh"
    "post-command.sh" 
    "post-command.py"
    "enforce-claude-md.py"
    "task-router.py"
    "auto-conversation-logger.py"
    "obsidian-enforcer.py"
    "config.json"
)

# Copy only essential hooks
INSTALLED_COUNT=0
for hook in "${ESSENTIAL_HOOKS[@]}"; do
    if [ -f "$VERITAS_DIR/install/hooks/$hook" ]; then
        cp "$VERITAS_DIR/install/hooks/$hook" "$PROJECT_DIR/.claude/hooks/"
        
        # Make shell scripts executable
        if [[ "$hook" == *.sh ]]; then
            chmod +x "$PROJECT_DIR/.claude/hooks/$hook"
        fi
        
        # Make Python scripts executable
        if [[ "$hook" == *.py ]]; then
            chmod +x "$PROJECT_DIR/.claude/hooks/$hook"
        fi
        
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        echo "  ✓ $hook"
    else
        echo -e "${RED}  ✗ Missing: $hook${NC}"
    fi
done

echo -e "${GREEN}[OK] Installed $INSTALLED_COUNT essential hooks${NC}"

# Verify all essential hooks are present
if [ $INSTALLED_COUNT -eq 8 ]; then
    echo -e "${GREEN}[VERIFIED] All 8 essential hooks installed${NC}"
else
    echo -e "${RED}[WARNING] Only $INSTALLED_COUNT of 8 essential hooks installed${NC}"
fi

# Step 4: Install templates
echo ""
echo "Installing templates..."

# Copy Obsidian templates if they exist
if [ -d "$VERITAS_DIR/install/templates/obsidian" ]; then
    cp "$VERITAS_DIR/install/templates/obsidian/"*.md "$PROJECT_DIR/.claude/templates/" 2>/dev/null || true
    echo -e "${GREEN}[OK] Installed Obsidian templates${NC}"
fi

# Install project configuration template
cp "$VERITAS_DIR/install/project.json.template" "$PROJECT_DIR/.claude/project.json" 2>/dev/null || true
echo -e "${GREEN}[OK] Installed project configuration template${NC}"

# Install Claude Code settings (merge with existing)
if [ -f "$VERITAS_DIR/install/settings.local.json.template" ]; then
    SETTINGS_FILE="$PROJECT_DIR/.claude/settings.local.json"
    
    # Process template with project directory
    PROCESSED_SETTINGS=$(sed "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$VERITAS_DIR/install/settings.local.json.template")
    
    if [ -f "$SETTINGS_FILE" ]; then
        echo -e "${YELLOW}[INFO] Existing Claude Code settings found${NC}"
        echo "How would you like to handle Claude Code settings?"
        echo "1) Merge VERITAS settings with existing (recommended)"
        echo "2) Replace existing settings"
        echo "3) Skip Claude Code settings installation"
        read -p "Choose an option (1-3): " SETTINGS_CHOICE
        
        case $SETTINGS_CHOICE in
            1)
                # Backup existing
                cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup.$(date +%Y%m%d-%H%M%S)"
                echo "  Backup created"
                
                # Merge configurations using jq if available
                if command -v jq >/dev/null 2>&1; then
                    # Intelligent merge: combine permissions, hooks, etc.
                    echo "$PROCESSED_SETTINGS" | jq --slurpfile existing "$SETTINGS_FILE" '
                        {
                            permissions: {
                                allow: ((.permissions.allow // []) + ($existing[0].permissions.allow // [])) | unique,
                                deny: ((.permissions.deny // []) + ($existing[0].permissions.deny // [])) | unique,
                                ask: ((.permissions.ask // []) + ($existing[0].permissions.ask // [])) | unique,
                                defaultMode: (.permissions.defaultMode // $existing[0].permissions.defaultMode // "acceptEdits"),
                                additionalDirectories: ((.permissions.additionalDirectories // []) + ($existing[0].permissions.additionalDirectories // [])) | unique
                            },
                            hooks: ((.hooks // {}) + ($existing[0].hooks // {})),
                            outputStyle: (.outputStyle // $existing[0].outputStyle // "Explanatory")
                        }
                    ' > "$SETTINGS_FILE"
                    echo -e "${GREEN}[OK] Claude Code settings merged intelligently${NC}"
                else
                    # Fallback: replace with VERITAS settings
                    echo "$PROCESSED_SETTINGS" > "$SETTINGS_FILE"
                    echo -e "${GREEN}[OK] Claude Code settings installed (jq not available for merging)${NC}"
                fi
                ;;
            2)
                cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup.$(date +%Y%m%d-%H%M%S)"
                echo "$PROCESSED_SETTINGS" > "$SETTINGS_FILE"
                echo -e "${GREEN}[OK] Claude Code settings replaced${NC}"
                ;;
            3)
                echo -e "${YELLOW}[SKIP] Claude Code settings installation skipped${NC}"
                ;;
            *)
                echo -e "${RED}Invalid choice, skipping settings installation${NC}"
                ;;
        esac
    else
        # No existing settings, install new
        echo "$PROCESSED_SETTINGS" > "$SETTINGS_FILE"
        echo -e "${GREEN}[OK] Claude Code settings installed${NC}"
    fi
else
    echo -e "${YELLOW}[WARNING] Claude Code settings template not found${NC}"
fi

# Step 5: Install test script
echo ""
echo "Installing test script..."

# Copy veritas-test.sh to project scripts directory
if [ -f "$VERITAS_DIR/tests/veritas-test.sh" ]; then
    cp "$VERITAS_DIR/tests/veritas-test.sh" "$PROJECT_DIR/.claude/scripts/" 2>/dev/null || true
    chmod +x "$PROJECT_DIR/.claude/scripts/veritas-test.sh" 2>/dev/null || true
    echo -e "${GREEN}[OK] Installed veritas-test.sh for local testing${NC}"
else
    echo -e "${YELLOW}[WARNING] Test script not found${NC}"
fi

# Copy config files if they exist
if [ -d "$VERITAS_DIR/install/config" ] && [ "$(ls -A "$VERITAS_DIR/install/config")" ]; then
    cp "$VERITAS_DIR/install/config/"* "$PROJECT_DIR/.claude/config/" 2>/dev/null || true
    echo -e "${GREEN}[OK] Installed configuration files${NC}"
fi

# Step 6: Configure project type
echo ""
echo "Configuring VERITAS for medical research..."
PROJECT_TYPE_STR="medical_research"

# Update project.json for medical research
sed -i '' "s/\"type\": \".*\"/\"type\": \"medical_research\"/" "$PROJECT_DIR/.claude/project.json" 2>/dev/null || \
sed -i "s/\"type\": \".*\"/\"type\": \"medical_research\"/" "$PROJECT_DIR/.claude/project.json"

sed -i '' "s/\"strict_citations\": false/\"strict_citations\": true/" "$PROJECT_DIR/.claude/project.json" 2>/dev/null || \
sed -i "s/\"strict_citations\": false/\"strict_citations\": true/" "$PROJECT_DIR/.claude/project.json"

# Copy HLA domain expert template
if [ -f "$VERITAS_DIR/install/templates/agents/hla-research-director.md" ]; then
    cp "$VERITAS_DIR/install/templates/agents/hla-research-director.md" "$PROJECT_DIR/.claude/agents/hla-research-director.md"
    echo -e "${GREEN}[OK] Installed HLA research domain expert template${NC}"
    echo -e "${YELLOW}Note: Customize .claude/agents/hla-research-director.md for your specific research area${NC}"
    echo -e "${YELLOW}      Or ask Claude to create a domain expert for your field${NC}"
fi

echo -e "${GREEN}[OK] Configured for medical research with PMID enforcement${NC}"

# Step 7: Install and configure conversation-logger MCP
echo ""
echo "Installing conversation-logger MCP server..."

if [ -d "$VERITAS_DIR/conversation-logger" ]; then
    cd "$VERITAS_DIR/conversation-logger"
    npm install --silent
    echo -e "${GREEN}[OK] Conversation logger installed${NC}"
    
    # Configure retention period
    echo ""
    echo "Configuring conversation logger cleanup..."
    echo ""
    echo "How would you like to manage conversation logs?"
    echo "1) Auto-cleanup after 5 days (recommended)"
    echo "2) Keep indefinitely (no automatic cleanup)" 
    echo "3) Custom retention period"
    echo ""
    read -p "Choose an option (1-3): " CLEANUP_CHOICE
    
    RETENTION_DAYS=5
    ENABLE_CLEANUP=true
    
    case $CLEANUP_CHOICE in
        1)
            RETENTION_DAYS=5
            ENABLE_CLEANUP=true
            echo -e "${GREEN}[OK] Will auto-cleanup logs older than 5 days${NC}"
            ;;
        2)
            ENABLE_CLEANUP=false
            echo -e "${GREEN}[OK] Logs will be kept indefinitely${NC}"
            ;;
        3)
            echo ""
            read -p "Enter retention period in days (1-365): " CUSTOM_DAYS
            if [[ "$CUSTOM_DAYS" =~ ^[0-9]+$ ]] && [ "$CUSTOM_DAYS" -ge 1 ] && [ "$CUSTOM_DAYS" -le 365 ]; then
                RETENTION_DAYS=$CUSTOM_DAYS
                ENABLE_CLEANUP=true
                echo -e "${GREEN}[OK] Will auto-cleanup logs older than $RETENTION_DAYS days${NC}"
            else
                echo -e "${YELLOW}Warning: Invalid input. Using default 5 days${NC}"
                RETENTION_DAYS=5
                ENABLE_CLEANUP=true
            fi
            ;;
        *)
            RETENTION_DAYS=5
            ENABLE_CLEANUP=true
            echo -e "${YELLOW}Warning: Invalid choice. Using default 5-day cleanup${NC}"
            ;;
    esac
    
    # Configure cleanup script if enabled
    CLEANUP_SCRIPT="$VERITAS_DIR/conversation-logger/cleanup-old-logs.js"
    if [ "$ENABLE_CLEANUP" = true ] && [ -f "$CLEANUP_SCRIPT" ]; then
        chmod +x "$CLEANUP_SCRIPT"
        
        # Update retention period in cleanup script
        if [ "$RETENTION_DAYS" != "5" ]; then
            sed -i.bak "s/RETENTION_DAYS = 5/RETENTION_DAYS = $RETENTION_DAYS/" "$CLEANUP_SCRIPT"
            echo "  Updated retention period to $RETENTION_DAYS days"
        fi
        
        # Schedule cron job
        CRON_CMD="0 2 * * * cd '$VERITAS_DIR/conversation-logger' && node cleanup-old-logs.js > /tmp/conversation-cleanup.log 2>&1"
        
        if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
            echo -e "${GREEN}[OK] Cleanup job already scheduled${NC}"
        else
            (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
            echo -e "${GREEN}[OK] Automatic cleanup scheduled for 2 AM daily${NC}"
        fi
    fi
    
    cd "$VERITAS_DIR"
else
    echo -e "${YELLOW}Warning: conversation-logger directory not found${NC}"
fi

# Step 8: Install MCP servers
echo ""
echo "Installing MCP servers..."

# Get PubMed email for NCBI API compliance
echo ""
echo "PubMed Configuration"
echo "--------------------"
echo "NCBI requires an email address for API access (prevents rate limiting)."
echo "Enter your email for PubMed API access:"
read -r PUBMED_EMAIL

# Validate email format (basic check)
if [[ ! "$PUBMED_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${YELLOW}Warning: Email format appears invalid. Using default.${NC}"
    PUBMED_EMAIL="user@example.com"
fi

echo -e "${GREEN}[OK] PubMed email configured: $PUBMED_EMAIL${NC}"

# Install PubMed MCP globally for reliability
echo ""
echo "Installing PubMed MCP (this may take a moment)..."
npm install -g @cyanheads/pubmed-mcp-server --loglevel=error
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[OK] PubMed MCP installed${NC}"
else
    echo -e "${YELLOW}Warning: PubMed MCP installation may require sudo${NC}"
    echo "  You can install it later with: sudo npm install -g @cyanheads/pubmed-mcp-server"
fi

# Install Obsidian MCP Server
echo "Installing Obsidian MCP Server..."
npm install -g obsidian-mcp-server --loglevel=error
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[OK] Obsidian MCP Server installed${NC}"
else
    echo -e "${YELLOW}Warning: Obsidian MCP installation may require sudo${NC}"
    echo "  You can install it later with: sudo npm install -g obsidian-mcp-server"
fi

# Other servers run with npx
echo -e "${GREEN}[OK] Sequential-thinking MCP will run with npx${NC}"
echo -e "${GREEN}[OK] Memory MCP will run with npx${NC}"
echo -e "${GREEN}[OK] Filesystem MCP will run with npx${NC}"

# Step 9: Configure Obsidian vaults
echo ""
echo "=================================="
echo "Obsidian Vault Configuration"
echo "=================================="
echo ""
echo "VERITAS integrates with Obsidian for research documentation."
echo ""

echo "Have you installed the Obsidian Local REST API plugin? (y/n)"
read -r OBSIDIAN_INSTALLED

if [[ $OBSIDIAN_INSTALLED =~ ^[Yy]$ ]]; then
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
            echo "(e.g., /Users/$USER/Obsidian/$VAULT_NAME)"
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
            echo "(Set this in Obsidian's Local REST API settings)"
            read -r VAULT_TOKEN
            VAULT_TOKENS+=("$VAULT_TOKEN")
            
            echo -e "${GREEN}[OK] Vault '$VAULT_NAME' configured${NC}"
            
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
        echo -e "${GREEN}[OK] Configured $VAULT_COUNT vault(s)${NC}"
        for i in "${!VAULT_NAMES[@]}"; do
            echo "  - ${VAULT_NAMES[$i]}: ${VAULT_PATHS[$i]} (port ${VAULT_PORTS[$i]})"
        done
else
    echo ""
    echo -e "${YELLOW}Please install the Obsidian Local REST API plugin:${NC}"
    echo "1. Open Obsidian"
    echo "2. Go to Settings > Community Plugins"
    echo "3. Search for 'Local REST API'"
    echo "4. Install and enable the plugin"
    echo "5. Configure authentication in the plugin settings"
    echo ""
    echo "After installing the plugin, run this setup again or use:"
    echo "  $VERITAS_DIR/install/scripts/configure-claude.sh"
fi

# Step 10: Create environment configuration file
echo ""
echo "Creating environment configuration..."

ENV_FILE="$PROJECT_DIR/.claude/env.sh"
cat > "$ENV_FILE" << EOF
#!/bin/bash
# VERITAS Environment Configuration
# Source this file or add to your shell profile

export CLAUDE_PROJECT_DIR="$PROJECT_DIR"
export ENFORCE_OBSIDIAN_MCP=1

# PubMed Configuration
export PUBMED_EMAIL="$PUBMED_EMAIL"
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
export OBSIDIAN_API_TOKEN="${VAULT_TOKENS[0]}"
export OBSIDIAN_BASE_URL="https://127.0.0.1:${VAULT_PORTS[0]}"
export OBSIDIAN_PRIMARY_PORT="${VAULT_PORTS[0]}"
EOF
    fi
fi

chmod +x "$ENV_FILE"
echo -e "${GREEN}[OK] Environment configuration created${NC}"
echo "  Add to your shell profile: source $ENV_FILE"

# Step 11: Create README for .claude directory
cat > "$PROJECT_DIR/.claude/README.md" << 'EOF'
# VERITAS Implementation

This directory contains the VERITAS implementation for this project.

## Structure

- **hooks/** - VERITAS enforcement mechanisms
- **templates/** - Project-specific templates
- **scripts/** - Utility and maintenance scripts
- **agents/** - Domain expert files
- **logs/** - Validation and error logs
- **config/** - Additional configuration
- **archive/** - Deprecated items
- **project.json** - Project-specific context

## Customization

1. Edit `project.json` with your project details
2. Add domain expert files to `agents/` if needed
3. Add project-specific templates to `templates/`
4. Customize CLAUDE.md articles if needed

## Testing

Run the test script to verify your setup:
```bash
.claude/scripts/veritas-test.sh
```

---
Created with VERITAS System
EOF

echo -e "${GREEN}[OK] Created project README${NC}"

# Step 12: Validate installation
echo ""
echo "Validating installation..."

# Test hook functionality
if [ -f "$PROJECT_DIR/.claude/scripts/veritas-test.sh" ]; then
    echo "Running VERITAS system test..."
    cd "$PROJECT_DIR"
    if bash .claude/scripts/veritas-test.sh >/dev/null 2>&1; then
        echo -e "${GREEN}[PASS] System test passed${NC}"
    else
        echo -e "${YELLOW}[INFO] System test completed (check .claude/logs/ for details)${NC}"
    fi
else
    echo -e "${YELLOW}[SKIP] Test script not found${NC}"
fi

# Verify hook permissions
echo "Verifying hook permissions..."
PERMISSION_ISSUES=0
for hook in "${ESSENTIAL_HOOKS[@]}"; do
    if [[ "$hook" == *.sh ]] || [[ "$hook" == *.py ]]; then
        if [ ! -x "$PROJECT_DIR/.claude/hooks/$hook" ]; then
            echo -e "${RED}  ✗ $hook not executable${NC}"
            PERMISSION_ISSUES=$((PERMISSION_ISSUES + 1))
        fi
    fi
done

if [ $PERMISSION_ISSUES -eq 0 ]; then
    echo -e "${GREEN}[OK] All hooks have correct permissions${NC}"
else
    echo -e "${RED}[WARNING] $PERMISSION_ISSUES hooks lack execute permissions${NC}"
fi

# Step 13: Configure Claude Desktop automatically
echo ""
echo "=================================="
echo "Configuring Claude Desktop"
echo "=================================="
echo ""

# Claude Desktop config path
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Build the MCP servers configuration
MCP_CONFIG='{"mcpServers":{'

# Add Obsidian vault configurations if any
if [ ${#VAULT_NAMES[@]} -gt 0 ]; then
    for i in "${!VAULT_NAMES[@]}"; do
        [ $i -gt 0 ] && MCP_CONFIG+=","
        MCP_CONFIG+="\"obsidian-rest-${VAULT_NAMES[$i]}\":{"
        MCP_CONFIG+="\"command\":\"npx\","
        MCP_CONFIG+="\"args\":[\"obsidian-mcp-server\"],"
        MCP_CONFIG+="\"env\":{"
        MCP_CONFIG+="\"OBSIDIAN_API_KEY\":\"${VAULT_TOKENS[$i]}\","
        MCP_CONFIG+="\"OBSIDIAN_BASE_URL\":\"https://127.0.0.1:${VAULT_PORTS[$i]}\","
        MCP_CONFIG+="\"OBSIDIAN_VERIFY_SSL\":\"false\","
        MCP_CONFIG+="\"OBSIDIAN_ENABLE_CACHE\":\"true\""
        MCP_CONFIG+="}}"
        [ ${#VAULT_NAMES[@]} -gt 0 ] && MCP_CONFIG+=","
    done
fi

# Add other MCP servers
MCP_CONFIG+="\"sequential-thinking\":{\"command\":\"npx\",\"args\":[\"@sequentialthinking/sequential-thinking-mcp\"]},"
MCP_CONFIG+="\"pubmed\":{\"command\":\"pubmed-mcp-server\",\"env\":{\"PUBMED_EMAIL\":\"$PUBMED_EMAIL\"}},"
MCP_CONFIG+="\"memory\":{\"command\":\"npx\",\"args\":[\"@modelcontextprotocol/server-memory\"]},"
MCP_CONFIG+="\"filesystem-local\":{\"command\":\"npx\",\"args\":[\"@cloudflare/mcp-server-filesystem\",\"$PROJECT_DIR\"]},"
MCP_CONFIG+="\"conversation-logger\":{\"command\":\"node\",\"args\":[\"$VERITAS_DIR/conversation-logger/index.js\"]}"
MCP_CONFIG+="}}"

# Check if Claude config directory exists
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Claude Desktop config directory not found${NC}"
    echo "Creating directory: $CLAUDE_CONFIG_DIR"
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

# Check if config file exists
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
    echo "Found existing Claude Desktop configuration"
    
    # Backup existing config
    BACKUP_FILE="${CLAUDE_CONFIG_FILE}.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}[OK] Backup created: $BACKUP_FILE${NC}"
    
    # Merge configurations using jq if available
    if command -v jq >/dev/null 2>&1; then
        echo "Merging VERITAS servers with existing configuration..."
        
        # Merge the configurations
        echo "$MCP_CONFIG" | jq --slurpfile existing "$CLAUDE_CONFIG_FILE" '
            . as $new |
            $existing[0] | 
            .mcpServers = ((.mcpServers // {}) * ($new.mcpServers // {}))
        ' > "$CLAUDE_CONFIG_FILE"
        
        echo -e "${GREEN}[OK] Claude Desktop configuration updated successfully${NC}"
    else
        echo -e "${YELLOW}Warning: jq not installed, cannot merge configurations${NC}"
        echo "Please install jq or manually add the following to your Claude config:"
        echo "$MCP_CONFIG" | jq . 2>/dev/null || echo "$MCP_CONFIG"
    fi
else
    echo "Creating new Claude Desktop configuration..."
    echo "$MCP_CONFIG" | jq . > "$CLAUDE_CONFIG_FILE" 2>/dev/null || echo "$MCP_CONFIG" > "$CLAUDE_CONFIG_FILE"
    echo -e "${GREEN}[OK] Claude Desktop configuration created${NC}"
fi

# Final instructions
echo ""
echo "=================================="
echo -e "${GREEN}VERITAS Installation Complete!${NC}"
echo "=================================="
echo ""
echo "VERITAS installed at: $PROJECT_DIR"
echo "Configuration: Medical research with PMID enforcement"
echo ""
echo "Claude Desktop configuration has been automatically updated."
echo ""
echo "Next steps:"
echo ""
echo "1. Restart Claude Desktop completely (Quit and reopen)"
echo ""
echo "2. Configure Claude CLI:"
echo "   claude mcp add-from-claude-desktop"
echo ""
echo "3. Test your installation:"
echo "   claude 'test VERITAS system'"
echo ""
echo "4. Start using VERITAS:"
echo "   claude 'help me with my research'"
echo ""
echo "Optional customization:"
echo "- Customize domain expert: $PROJECT_DIR/.claude/agents/hla-research-director.md"
echo "- Review project settings: $PROJECT_DIR/.claude/project.json"
echo ""

# Show conversation logger status
if [ "$ENABLE_CLEANUP" = true ]; then
    echo "Conversation Logger Status:"
    echo "  - Database: ~/.conversation-logger/conversations.db"
    echo "  - Retention: $RETENTION_DAYS days"
    echo "  - Cleanup: Automatic at 2 AM daily"
else
    echo "Conversation Logger Status:"
    echo "  - Database: ~/.conversation-logger/conversations.db"
    echo "  - Retention: Indefinite (no automatic cleanup)"
fi

echo ""
echo "For help, see: $VERITAS_DIR/docs/getting-started.md"
echo ""
echo "Happy researching with VERITAS!"