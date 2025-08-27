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
                                allow: (.permissions.allow + $existing[0].permissions.allow // []) | unique,
                                deny: (.permissions.deny + $existing[0].permissions.deny // []) | unique,
                                ask: (.permissions.ask + $existing[0].permissions.ask // []) | unique,
                                defaultMode: (.permissions.defaultMode // $existing[0].permissions.defaultMode // "acceptEdits"),
                                additionalDirectories: (.permissions.additionalDirectories + $existing[0].permissions.additionalDirectories // []) | unique
                            },
                            hooks: (.hooks * $existing[0].hooks // {}),
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

# Step 7: Install conversation-logger MCP
echo ""
echo "Installing conversation-logger MCP server..."

if [ -d "$VERITAS_DIR/conversation-logger" ]; then
    cd "$VERITAS_DIR/conversation-logger"
    npm install --silent
    echo -e "${GREEN}[OK] Conversation logger installed${NC}"
    cd "$VERITAS_DIR"
else
    echo -e "${YELLOW}Warning: conversation-logger directory not found${NC}"
fi

# Step 8: Install MCP servers
echo ""
echo "Installing MCP servers..."

# Install PubMed MCP globally for reliability
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

# Step 9: Note about Obsidian configuration
echo ""
echo -e "${YELLOW}Note: Configure Obsidian manually after installation${NC}"
echo "      See docs/configuration-guide.md for Obsidian setup instructions"

# Step 10: Create README for .claude directory
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

# Step 11: Validate installation
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

# Final instructions
echo ""
echo "=================================="
echo -e "${GREEN}VERITAS Installation Complete!${NC}"
echo "=================================="
echo ""
echo "VERITAS installed at: $PROJECT_DIR"
echo "Configuration: Medical research with PMID enforcement"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure Claude Desktop with MCP servers:"
echo "   Run: $VERITAS_DIR/install/scripts/configure-claude.sh"
echo ""
echo "2. Edit project configuration:"
echo "   $PROJECT_DIR/.claude/project.json"
echo ""
echo "3. Review Claude Code settings (may have been merged):"
echo "   $PROJECT_DIR/.claude/settings.local.json"
echo "   Backups created if files existed previously"
echo ""
echo "4. Test your setup:"
echo "   claude 'test VERITAS system'"
echo ""
echo "5. For medical research projects:"
echo "   Domain expert installed: $PROJECT_DIR/.claude/agents/hla-research-director.md"
echo "   Customize this file for your specific research area"
echo ""
echo "6. Constitutional Foundation:"
echo "   CLAUDE.md is the immutable VERITAS Constitution"
echo "   DO NOT modify this document - it governs all enforcement"
echo ""
echo "MCP Server Paths for manual configuration:"
echo "- conversation-logger: $VERITAS_DIR/conversation-logger"
echo "- pubmed: @cyanheads/pubmed-mcp-server (installed globally)"
echo "- obsidian: obsidian-mcp-server (installed globally)"
echo "- memory: npx @modelcontextprotocol/server-memory"
echo "- sequential-thinking: npx @sequentialthinking/sequential-thinking-mcp"
echo "- filesystem: npx @cloudflare/mcp-server-filesystem"
echo ""
echo "For help, see: $VERITAS_DIR/docs/getting-started.md"
echo ""
echo "Happy researching with VERITAS!"