#!/bin/bash

# Test script to verify MCP system setup
# Run after setup to ensure everything works

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================================"
echo "MCP System Connection Test"
echo "================================================"
echo ""

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Function to test a command
test_command() {
    local description=$1
    local command=$2
    
    echo -n "Testing: $description... "
    
    if eval $command &> /dev/null; then
        echo -e "${GREEN}✓ PASSED${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAILED${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Test Node.js
test_command "Node.js installation" "node --version"

# Test npm
test_command "npm installation" "npm --version"

# Test Claude Code
test_command "Claude Code installation" "claude --version"

# Test configuration file
test_command "Configuration file exists" "test -f ~/.claude.json"

# Test symlink
test_command "Configuration symlink valid" "test -L ~/.claude.json"

# Test MCP directories
test_command "MCP-Shared directory" "test -d \"$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared\""
test_command "nova-memory directory" "test -d \"$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory\""

# Test Obsidian directories
test_command "Obsidian base directory" "test -d \"$HOME/Library/CloudStorage/Box-Box/Obsidian\""
test_command "HLA vault exists" "test -d \"$HOME/Library/CloudStorage/Box-Box/Obsidian/HLA Antibodies\""
test_command "Research Journal exists" "test -d \"$HOME/Library/CloudStorage/Box-Box/Obsidian/Research Journal\""

# Check for VS Code
echo ""
echo "Checking VS Code..."
if command -v code &> /dev/null; then
    echo -e "${GREEN}✓${NC} VS Code command line tools installed"
    ((TESTS_PASSED++))
else
    echo -e "${YELLOW}⚠${NC} VS Code command line tools not found"
    echo "   Install from VS Code: Cmd+Shift+P → 'Shell Command: Install code command'"
fi

# Check Obsidian (can't directly test if running)
echo ""
echo "Obsidian Check:"
echo "- Please ensure Obsidian is running"
echo "- Local REST API plugin should be enabled"
echo "- API key should be added to config"

# Parse config for API keys (without showing them)
echo ""
echo "Configuration Check:"
CONFIG_FILE="$HOME/.claude.json"

if [ -f "$CONFIG_FILE" ]; then
    # Check for placeholder values
    if grep -q "YOUR_.*_HERE" "$CONFIG_FILE"; then
        echo -e "${YELLOW}⚠${NC} Found placeholder API keys - please update with real keys"
    else
        echo -e "${GREEN}✓${NC} API keys appear to be configured"
    fi
    
    # Check JSON validity
    if python -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Configuration JSON is valid"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} Configuration JSON has syntax errors"
        ((TESTS_FAILED++))
    fi
fi

# Summary
echo ""
echo "================================================"
echo "Test Results"
echo "================================================"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}All tests passed! System is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Update API keys in configuration if needed"
    echo "2. Start Claude Code: claude"
    echo "3. Test MCP servers: /mcp"
    echo "4. Try an agent: /agent \"test query\""
else
    echo ""
    echo -e "${YELLOW}Some tests failed. Please review the issues above.${NC}"
    echo "See docs/TROUBLESHOOTING.md for help"
fi

echo ""
echo "To run a full system test with Claude Code:"
echo "  ./scripts/full-test.sh"