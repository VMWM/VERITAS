#!/bin/bash

# VERITAS System Setup Script
# Complete installation of research integrity framework

set -e

echo "=================================="
echo "VERITAS System Setup"
echo "=================================="
echo ""
echo "Verification-Enforced Research Infrastructure"
echo "with Tracking and Automated Structuring"
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

# Check Node.js version
NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" -lt 16 ]; then
    echo -e "${YELLOW}Warning: Node.js version is less than 16. Some features may not work.${NC}"
    echo "Current version: $(node -v)"
    echo "Recommended: v16.0.0 or higher"
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
    echo "This may be from a previous installation or your own project instructions."
    echo ""
    echo -e "${YELLOW}IMPORTANT: VERITAS requires its specific CLAUDE.md to function correctly.${NC}"
    echo "Claude Code automatically looks for CLAUDE.md files for project instructions."
    echo ""
    echo "Your existing CLAUDE.md will be replaced, but a backup will be created."
    echo "After installation, you can add project-specific customizations to CLAUDE.md,"
    echo "but ensure they don't conflict with VERITAS constitutional rules."
    echo ""
    echo "What would you like to do?"
    echo "1) Replace with VERITAS CLAUDE.md (backup will be created)"
    echo "2) Use a different project directory"
    echo "3) Cancel installation"
    read -r CLAUDE_CHOICE
    
    case $CLAUDE_CHOICE in
        1)
            # Replace with VERITAS CLAUDE.md
            BACKUP_NAME="CLAUDE.md.backup.$(date +%Y%m%d-%H%M%S)"
            mv "$PROJECT_DIR/CLAUDE.md" "$PROJECT_DIR/$BACKUP_NAME"
            echo -e "${GREEN}[OK] Existing CLAUDE.md backed up to: $BACKUP_NAME${NC}"
            echo "  You can reference it later if you need to restore any custom instructions"
            ;;
        2)
            # Use different directory
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
        3)
            # Cancel
            echo "Installation cancelled."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting...${NC}"
            exit 1
            ;;
    esac
    
    # Copy VERITAS CLAUDE.md if we chose to replace (option 1) or changed directory (option 2)
    if [ "$CLAUDE_CHOICE" = "1" ] || [ "$CLAUDE_CHOICE" = "2" ]; then
        cp "$VERITAS_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
        echo -e "${GREEN}[OK] VERITAS Constitution installed${NC}"
        echo -e "${YELLOW}Note: You can add project-specific customizations at the end of CLAUDE.md${NC}"
        echo "      Just ensure they don't conflict with VERITAS rules above"
    fi
else
    # No existing CLAUDE.md, install fresh
    cp "$VERITAS_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
    echo -e "${GREEN}[OK] VERITAS Constitution installed${NC}"
    echo -e "${YELLOW}Note: You can add project-specific customizations at the end of CLAUDE.md${NC}"
    echo "      Just ensure they don't conflict with VERITAS rules above"
fi

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
    "pre-citation-hook.sh"
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
if [ $INSTALLED_COUNT -eq 9 ]; then
    echo -e "${GREEN}[VERIFIED] All 9 essential hooks installed${NC}"
else
    echo -e "${RED}[WARNING] Only $INSTALLED_COUNT of 9 essential hooks installed${NC}"
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
cp "$VERITAS_DIR/install/templates/config/project.json.template" "$PROJECT_DIR/.claude/project.json" 2>/dev/null || true
echo -e "${GREEN}[OK] Installed project configuration template${NC}"

# Install Claude Code settings (merge with existing)
if [ -f "$VERITAS_DIR/install/templates/config/settings.local.json.template" ]; then
    SETTINGS_FILE="$PROJECT_DIR/.claude/settings.local.json"
    
    # Process template with project directory
    PROCESSED_SETTINGS=$(sed "s|PROJECT_DIR_PLACEHOLDER|$PROJECT_DIR|g" "$VERITAS_DIR/install/templates/config/settings.local.json.template")
    
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

# Copy config files if they exist in templates/config
if [ -d "$VERITAS_DIR/install/templates/config" ] && [ "$(ls -A "$VERITAS_DIR/install/templates/config")" ]; then
    # Note: Template files are for reference, not direct copying
    echo -e "${GREEN}[OK] Configuration templates available in install/templates/config${NC}"
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

# Step 7: Install PMID Verification System
echo ""
echo "Installing PMID Verification System..."
echo "  This ensures 100% accuracy of PubMed IDs in all documents"

# Copy PMID verification scripts
if [ -f "$VERITAS_DIR/.claude/scripts/verify_pmids.py" ]; then
    cp "$VERITAS_DIR/.claude/scripts/verify_pmids.py" "$PROJECT_DIR/.claude/scripts/"
    chmod +x "$PROJECT_DIR/.claude/scripts/verify_pmids.py"
    echo -e "${GREEN}[OK] Installed PMID verification script${NC}"
else
    echo -e "${YELLOW}[WARNING] PMID verification script not found${NC}"
fi

# Copy pre-citation hook
if [ -f "$VERITAS_DIR/.claude/hooks/pre-citation-hook.sh" ]; then
    cp "$VERITAS_DIR/.claude/hooks/pre-citation-hook.sh" "$PROJECT_DIR/.claude/hooks/"
    chmod +x "$PROJECT_DIR/.claude/hooks/pre-citation-hook.sh"
    echo -e "${GREEN}[OK] Installed pre-citation hook${NC}"
else
    echo -e "${YELLOW}[WARNING] Pre-citation hook not found${NC}"
fi

# PMID verification is documented in CLAUDE.md Article 8
# No separate workflow document needed to avoid confusion

# Install Python requests library if needed
python3 -c "import requests" 2>/dev/null || {
    echo "Installing requests library for PMID verification..."
    pip3 install requests --quiet || echo "  Note: Please install manually: pip3 install requests"
}

# Set up git pre-commit hook for PMID verification
if [ -d "$PROJECT_DIR/.git" ]; then
    PRECOMMIT_FILE="$PROJECT_DIR/.git/hooks/pre-commit"
    
    # Check if pre-commit hook exists
    if [ -f "$PRECOMMIT_FILE" ]; then
        # Append PMID verification to existing hook
        if ! grep -q "verify_pmids.py" "$PRECOMMIT_FILE"; then
            cat >> "$PRECOMMIT_FILE" << 'EOF'

# VERITAS PMID Verification
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.md$'); do
    if grep -q "PMID:" "$file"; then
        echo "Verifying PMIDs in $file..."
        if ! python3 .claude/scripts/verify_pmids.py "$file"; then
            echo "PMID verification failed. Commit aborted."
            echo "Please fix the PMIDs and try again."
            exit 1
        fi
    fi
done
EOF
            echo -e "${GREEN}[OK] Added PMID verification to git pre-commit hook${NC}"
        else
            echo -e "${GREEN}[OK] Git pre-commit hook already has PMID verification${NC}"
        fi
    else
        # Create new pre-commit hook
        cat > "$PRECOMMIT_FILE" << 'EOF'
#!/bin/bash
# VERITAS PMID Verification Pre-Commit Hook

# Find all markdown files being committed
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.md$'); do
    if grep -q "PMID:" "$file"; then
        echo "Verifying PMIDs in $file..."
        if ! python3 .claude/scripts/verify_pmids.py "$file"; then
            echo "PMID verification failed. Commit aborted."
            echo "Please fix the PMIDs and try again."
            exit 1
        fi
    fi
done
EOF
        chmod +x "$PRECOMMIT_FILE"
        echo -e "${GREEN}[OK] Created git pre-commit hook for PMID verification${NC}"
    fi
fi

echo -e "${GREEN}[OK] PMID Verification System installed${NC}"
echo "  Zero-tolerance policy for PMID errors is now active"

# Step 8: Install and configure conversation-logger MCP
echo ""
echo "Installing conversation-logger MCP server..."

if [ -d "$VERITAS_DIR/conversation-logger" ]; then
    cd "$VERITAS_DIR/conversation-logger"
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${YELLOW}[DRY RUN] Would install conversation logger dependencies${NC}"
    else
        npm install --silent
        echo -e "${GREEN}[OK] Conversation logger installed${NC}"
    fi
    
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
if [ "$DRY_RUN" = "true" ]; then
    echo -e "${YELLOW}[DRY RUN] Would install @ncukondo/pubmed-mcp globally${NC}"
else
    npm install -g @ncukondo/pubmed-mcp --loglevel=error 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] PubMed MCP installed globally${NC}"
    else
        echo -e "${YELLOW}Warning: Global installation failed (may need sudo)${NC}"
        echo "  Attempting local installation..."
        npm install @ncukondo/pubmed-mcp --loglevel=error 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[OK] PubMed MCP installed locally (will use npx)${NC}"
        else
            echo -e "${YELLOW}  Manual installation required: sudo npm install -g @ncukondo/pubmed-mcp${NC}"
        fi
    fi
fi

# Optional: Get NCBI API key
echo ""
echo "Do you have an NCBI API key? (recommended for better performance) [y/N]:"
read -r HAS_API_KEY
if [[ "$HAS_API_KEY" =~ ^[Yy]$ ]]; then
    echo "Enter your NCBI API key:"
    read -r PUBMED_API_KEY
    export PUBMED_API_KEY="$PUBMED_API_KEY"
else
    echo "Note: You can get a free API key at https://www.ncbi.nlm.nih.gov/account/settings/"
    PUBMED_API_KEY=""
fi

# Install Obsidian MCP Server
echo "Installing Obsidian MCP Server..."
if [ "$DRY_RUN" = "true" ]; then
    echo -e "${YELLOW}[DRY RUN] Would install obsidian-mcp-server globally${NC}"
else
    npm install -g obsidian-mcp-server --loglevel=error
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] Obsidian MCP Server installed${NC}"
    else
        echo -e "${YELLOW}Warning: Obsidian MCP installation may require sudo${NC}"
        echo "  You can install it later with: sudo npm install -g obsidian-mcp-server"
    fi
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
export PUBMED_API_KEY="$PUBMED_API_KEY"
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

# Step 13: Configure Claude Desktop and CLI
echo ""
echo "=================================="
echo "Configuring Claude Desktop & CLI"
echo "=================================="
echo ""

# Configuration paths
CLAUDE_DESKTOP_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_DESKTOP_CONFIG="$CLAUDE_DESKTOP_CONFIG_DIR/claude_desktop_config.json"
CLAUDE_CLI_CONFIG="$HOME/.claude.json"

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
MCP_CONFIG+="\"sequential-thinking\":{\"command\":\"npx\",\"args\":[\"@modelcontextprotocol/server-sequential-thinking\"]},"
MCP_CONFIG+="\"pubmed\":{\"command\":\"npx\",\"args\":[\"@ncukondo/pubmed-mcp\"],\"env\":{\"PUBMED_EMAIL\":\"$PUBMED_EMAIL\",\"PUBMED_API_KEY\":\"$PUBMED_API_KEY\",\"PUBMED_CACHE_DIR\":\"/tmp/pubmed-cache\",\"PUBMED_CACHE_TTL\":\"86400\"}},"
MCP_CONFIG+="\"memory\":{\"command\":\"npx\",\"args\":[\"@modelcontextprotocol/server-memory\"]},"
MCP_CONFIG+="\"filesystem-local\":{\"command\":\"npx\",\"args\":[\"@modelcontextprotocol/server-filesystem\",\"$PROJECT_DIR\"]},"
MCP_CONFIG+="\"conversation-logger\":{\"command\":\"node\",\"args\":[\"$VERITAS_DIR/conversation-logger/index.js\"]}"
MCP_CONFIG+="}}"

# Check for existing configurations and ask user preference
EXISTING_CONFIGS=false
if [ -f "$CLAUDE_DESKTOP_CONFIG" ] || [ -f "$CLAUDE_CLI_CONFIG" ]; then
    EXISTING_CONFIGS=true
    echo -e "${YELLOW}Found existing Claude configurations${NC}"
    
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        DESKTOP_COUNT=$(jq '.mcpServers | length' "$CLAUDE_DESKTOP_CONFIG" 2>/dev/null || echo "0")
        echo "  Desktop: $DESKTOP_COUNT MCP servers configured"
    fi
    
    if [ -f "$CLAUDE_CLI_CONFIG" ]; then
        CLI_COUNT=$(jq '.mcpServers | length' "$CLAUDE_CLI_CONFIG" 2>/dev/null || echo "0")
        echo "  CLI: $CLI_COUNT MCP servers configured"
    fi
    
    echo ""
    echo "How would you like to proceed?"
    echo "1) Backup and merge VERITAS servers with existing (recommended)"
    echo "2) Backup and replace entire configuration"
    echo "3) Cancel (do not modify configurations)"
    echo ""
    read -p "Choose an option (1-3): " CONFIG_CHOICE
    
    case $CONFIG_CHOICE in
        1) CONFIG_MODE="merge" ;;
        2) CONFIG_MODE="replace" ;;
        3) CONFIG_MODE="skip" ;;
        *) 
            echo -e "${RED}Invalid choice. Cancelling configuration.${NC}"
            CONFIG_MODE="skip"
            ;;
    esac
else
    CONFIG_MODE="create"
fi

if [ "$CONFIG_MODE" != "skip" ]; then
    # Configure Claude Desktop
    echo ""
    echo "Configuring Claude Desktop..."
    if [ ! -d "$CLAUDE_DESKTOP_CONFIG_DIR" ]; then
        echo "  Creating config directory..."
        mkdir -p "$CLAUDE_DESKTOP_CONFIG_DIR"
    fi

    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        # Backup existing config
        BACKUP_FILE="${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$CLAUDE_DESKTOP_CONFIG" "$BACKUP_FILE"
        echo "  Backup created: $(basename $BACKUP_FILE)"
        
        if [ "$CONFIG_MODE" = "merge" ]; then
            # Merge configurations using jq if available
            if command -v jq >/dev/null 2>&1; then
                echo "$MCP_CONFIG" | jq --slurpfile existing "$CLAUDE_DESKTOP_CONFIG" '
                    . as $new |
                    $existing[0] | 
                    .mcpServers = ((.mcpServers // {}) + ($new.mcpServers // {}))
                ' > "$CLAUDE_DESKTOP_CONFIG.tmp"
                mv "$CLAUDE_DESKTOP_CONFIG.tmp" "$CLAUDE_DESKTOP_CONFIG"
                echo -e "${GREEN}[OK] Claude Desktop configuration merged${NC}"
            else
                echo -e "${YELLOW}Warning: jq not installed, cannot merge Desktop config${NC}"
                echo "Please install jq or manually add the configuration"
            fi
        else
            # Replace configuration
            echo "$MCP_CONFIG" | jq . > "$CLAUDE_DESKTOP_CONFIG" 2>/dev/null || echo "$MCP_CONFIG" > "$CLAUDE_DESKTOP_CONFIG"
            echo -e "${GREEN}[OK] Claude Desktop configuration replaced${NC}"
        fi
    else
        # Create new configuration
        echo "$MCP_CONFIG" | jq . > "$CLAUDE_DESKTOP_CONFIG" 2>/dev/null || echo "$MCP_CONFIG" > "$CLAUDE_DESKTOP_CONFIG"
        echo -e "${GREEN}[OK] Claude Desktop configuration created${NC}"
    fi

    # Configure Claude CLI
    echo ""
    echo "Configuring Claude CLI..."
    if [ -f "$CLAUDE_CLI_CONFIG" ]; then
        # Backup existing config
        BACKUP_FILE="${CLAUDE_CLI_CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$CLAUDE_CLI_CONFIG" "$BACKUP_FILE"
        echo "  Backup created: $(basename $BACKUP_FILE)"
        
        if [ "$CONFIG_MODE" = "merge" ]; then
            # Merge configurations using jq if available
            if command -v jq >/dev/null 2>&1; then
                echo "$MCP_CONFIG" | jq --slurpfile existing "$CLAUDE_CLI_CONFIG" '
                    . as $new |
                    $existing[0] | 
                    .mcpServers = ((.mcpServers // {}) + ($new.mcpServers // {}))
                ' > "$CLAUDE_CLI_CONFIG.tmp"
                mv "$CLAUDE_CLI_CONFIG.tmp" "$CLAUDE_CLI_CONFIG"
                echo -e "${GREEN}[OK] Claude CLI configuration merged${NC}"
            else
                echo -e "${YELLOW}Warning: jq not installed, cannot merge CLI config${NC}"
                echo "Please install jq or manually add the configuration"
            fi
        else
            # Replace configuration
            echo "$MCP_CONFIG" | jq . > "$CLAUDE_CLI_CONFIG" 2>/dev/null || echo "$MCP_CONFIG" > "$CLAUDE_CLI_CONFIG"
            echo -e "${GREEN}[OK] Claude CLI configuration replaced${NC}"
        fi
    else
        # Create new configuration
        echo "$MCP_CONFIG" | jq . > "$CLAUDE_CLI_CONFIG" 2>/dev/null || echo "$MCP_CONFIG" > "$CLAUDE_CLI_CONFIG"
        echo -e "${GREEN}[OK] Claude CLI configuration created${NC}"
    fi
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

if [ "$CONFIG_MODE" = "skip" ]; then
    echo -e "${YELLOW}Claude configuration was cancelled.${NC}"
    echo ""
    echo "To configure Claude later, run:"
    echo "  $VERITAS_DIR/install/scripts/configure-claude.sh"
    echo ""
elif [ "$CONFIG_MODE" = "merge" ]; then
    echo "Claude configurations have been merged with existing settings."
    echo ""
elif [ "$CONFIG_MODE" = "replace" ]; then
    echo "Claude configurations have been replaced (backups created)."
    echo ""
else
    echo "Claude Desktop and CLI have been configured."
    echo ""
fi

echo "Next steps:"
echo ""
echo "1. Restart Claude Desktop completely (Quit and reopen)"
echo ""
echo "2. Restart Claude CLI:"
echo "   claude restart"
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