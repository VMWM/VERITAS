#!/bin/bash

# Setup Validation Script for HLA Agent-MCP System
# This script checks that all components are properly installed and configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================"
echo "HLA Agent-MCP System - Setup Validation"
echo "================================================"
echo ""

# Counters
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# Functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS_COUNT++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL_COUNT++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN_COUNT++))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 1. Check Operating System
echo "1. System Requirements"
echo "----------------------"
if [[ "$OSTYPE" == "darwin"* ]]; then
    check_pass "macOS detected"
else
    check_fail "This system requires macOS (found: $OSTYPE)"
fi

# 2. Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    check_pass "Node.js installed: $NODE_VERSION"
else
    check_fail "Node.js not installed"
fi

# 3. Check Claude Code
echo ""
echo "2. Claude Code Installation"
echo "---------------------------"
if command -v claude &> /dev/null; then
    check_pass "Claude Code CLI installed"
else
    check_fail "Claude Code CLI not found - install with: npm install -g @anthropic-ai/claude-code"
fi

# 4. Check MCP Servers
echo ""
echo "3. MCP Server Installation"
echo "--------------------------"

# Check each server
MCP_SERVERS=(
    "@nova-mcp/mcp-nova"
    "@modelcontextprotocol/server-sequential-thinking"
    "@modelcontextprotocol/server-filesystem"
    "@ncukondo/pubmed-mcp"
    "dkmaker-mcp-rest-api"
)

for server in "${MCP_SERVERS[@]}"; do
    if npm list -g 2>/dev/null | grep -q "$server"; then
        check_pass "$server installed"
    else
        check_warn "$server not found globally (may be using npx)"
    fi
done

# 5. Check Configuration File
echo ""
echo "4. Configuration File"
echo "--------------------"

# Try multiple possible locations
CONFIG_PATHS=(
    "$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json"
    "$HOME/Library/CloudStorage/Box-Box/MCP-Shared/claude-desktop-config.json"
    "$HOME/Dropbox/MCP-Shared/claude-desktop-config.json"
    "$HOME/Google Drive/MCP-Shared/claude-desktop-config.json"
    "$HOME/OneDrive/MCP-Shared/claude-desktop-config.json"
)

CONFIG_FOUND=false
for config_path in "${CONFIG_PATHS[@]}"; do
    if [ -f "$config_path" ]; then
        CONFIG_FOUND=true
        CONFIG_FILE="$config_path"
        check_pass "Config file found at: $(dirname "$config_path")"
        
        # Check for placeholders
        if grep -q "YOUR_" "$CONFIG_FILE" 2>/dev/null; then
            PLACEHOLDER_COUNT=$(grep -c "YOUR_" "$CONFIG_FILE")
            check_fail "Config has $PLACEHOLDER_COUNT unreplaced placeholders (YOUR_...)"
            check_info "Edit: $CONFIG_FILE"
        else
            check_pass "All placeholders replaced in config"
        fi
        break
    fi
done

if [ "$CONFIG_FOUND" = false ]; then
    check_fail "Config file not found in any standard location"
    check_info "Run setup.sh first or check your cloud storage path"
fi

# 6. Check Obsidian
echo ""
echo "5. Obsidian Setup"
echo "-----------------"
if [ -d "/Applications/Obsidian.app" ]; then
    check_pass "Obsidian installed"
else
    check_warn "Obsidian not found in /Applications"
fi

# 7. Check Directory Structure
echo ""
echo "6. Directory Structure"
echo "----------------------"

if [ "$CONFIG_FOUND" = true ]; then
    MCP_DIR=$(dirname "$CONFIG_FILE")
    
    # Check MCP directories
    if [ -d "$MCP_DIR/nova-memory" ]; then
        check_pass "Memory directory exists"
    else
        check_warn "Memory directory not found at $MCP_DIR/nova-memory"
    fi
    
    if [ -d "$MCP_DIR/agents" ]; then
        check_pass "Agents directory exists"
    else
        check_warn "Agents directory not found at $MCP_DIR/agents"
    fi
fi

# 8. Check for CLAUDE.md
echo ""
echo "7. Agent Configuration"
echo "----------------------"
if [ -f "./CLAUDE.md" ]; then
    check_pass "CLAUDE.md found in current directory"
elif [ -f "../CLAUDE.md" ]; then
    check_pass "CLAUDE.md found in parent directory"
else
    check_warn "CLAUDE.md not found - copy from templates or examples"
fi

# 9. Network Tests
echo ""
echo "8. Network Connectivity"
echo "-----------------------"

# Test Obsidian ports
echo "Testing Obsidian REST API ports..."
if nc -z 127.0.0.1 27124 2>/dev/null; then
    check_pass "Port 27124 (Research vault) is listening"
else
    check_warn "Port 27124 not responding - is Obsidian running with REST API?"
fi

if nc -z 127.0.0.1 27125 2>/dev/null; then
    check_pass "Port 27125 (Journal vault) is listening"
else
    check_warn "Port 27125 not responding - second vault configured?"
fi

# Test PubMed
if curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=test" > /dev/null; then
    check_pass "PubMed API accessible"
else
    check_fail "Cannot reach PubMed API"
fi

# 10. Summary
echo ""
echo "================================================"
echo "Validation Summary"
echo "================================================"
echo -e "${GREEN}Passed:${NC} $PASS_COUNT checks"
echo -e "${YELLOW}Warnings:${NC} $WARN_COUNT checks"
echo -e "${RED}Failed:${NC} $FAIL_COUNT checks"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    if [ $WARN_COUNT -eq 0 ]; then
        echo -e "${GREEN}✓ Setup looks good! Your system is ready.${NC}"
    else
        echo -e "${YELLOW}⚠ Setup mostly complete. Check warnings above.${NC}"
    fi
    echo ""
    echo "Next steps:"
    echo "1. Start Obsidian and enable Local REST API in both vaults"
    echo "2. Run: cd /your/project && claude"
    echo "3. Type /mcp to verify all servers are connected"
else
    echo -e "${RED}✗ Setup incomplete. Please fix the errors above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Run ./setup.sh if you haven't already"
    echo "2. Replace YOUR_... placeholders in config file"
    echo "3. Install missing components with npm"
fi

echo ""
echo "For detailed setup instructions, see docs/SETUP_CHECKLIST.md"