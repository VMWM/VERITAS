#!/bin/bash

# VERITAS Installation Verification Script
# Checks that all required components are present

# Get VERITAS root directory (parent of tests directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERITAS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$VERITAS_DIR"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================="
echo "VERITAS Installation Verification"
echo "=================================="
echo ""

# Track issues
ISSUES=0

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}[OK]${NC} $2"
        return 0
    else
        echo -e "${RED}[MISSING]${NC} $2"
        ((ISSUES++))
        return 1
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}[OK]${NC} $2"
        return 0
    else
        echo -e "${RED}[MISSING]${NC} $2"
        ((ISSUES++))
        return 1
    fi
}

# Function to count files
count_files() {
    local count=$(find "$1" -type f -name "$2" 2>/dev/null | wc -l)
    if [ $count -gt 0 ]; then
        echo -e "${GREEN}[OK]${NC} Found $count $3"
        return 0
    else
        echo -e "${YELLOW}[WARN]${NC} No $3 found"
        return 1
    fi
}

echo "Checking Core Files..."
echo "----------------------"
check_file "README.md" "Main README"
check_file "install/scripts/setup.sh" "Setup Script"
check_file "install/scripts/configure-claude.sh" "Claude Configuration Script"
check_file "tests/verify-installation.sh" "Verification Script"
check_file "license" "License File"
echo ""

echo "Checking Directories..."
echo "-----------------------"
check_dir "install" "Installation Directory"
check_dir "install/hooks" "Hooks Directory"
check_dir "install/scripts" "Scripts Directory"
check_dir "install/templates" "Templates Directory"
check_dir "install/templates/agents" "Agent Templates"
check_dir "install/templates/obsidian" "Obsidian Templates"
check_dir "docs" "Documentation Directory"
check_dir "tests" "Test Scripts"
check_dir "conversation-logger" "Conversation Logger MCP"
echo ""

echo "Checking Hooks..."
echo "-----------------"
check_file "install/hooks/pre-command.sh" "Pre-command Hook"
check_file "install/hooks/post-command.sh" "Post-command Hook"
check_file "install/hooks/config.json" "Hook Configuration"
check_file "install/hooks/enforce-claude-md.py" "CLAUDE.md Enforcer"
check_file "install/hooks/task-router.py" "Task Router"
check_file "install/hooks/auto-conversation-logger.py" "Conversation Logger"
check_file "install/hooks/post-command.py" "Python Post-command Hook"
echo ""

echo "Checking Templates..."
echo "--------------------"
check_file "install/CLAUDE.md" "Installation CLAUDE.md"
check_file "install/templates/config/project.json.template" "Project Configuration Template"
check_file "install/templates/config/settings.local.json.template" "Claude Code Settings Template"
count_files "install/templates/obsidian" "*.md" "Obsidian templates"
count_files "install/templates/agents" "*.md" "Domain expert templates"
echo ""

echo "Checking Test Scripts..."
echo "----------------------"
check_file "tests/veritas-test.sh" "VERITAS Test Script"
check_file "tests/veritas-functional-test.md" "Functional Test Documentation"
count_files "tests" "*.sh" "test scripts"
echo ""

echo "Checking Installation Scripts..."
echo "-------------------------------"
count_files "install/hooks" "*.py" "Python hooks"
count_files "install/hooks" "*.sh" "Shell hooks"
check_file "install/CLAUDE.md" "Installation CLAUDE.md"
echo ""

echo "Checking Documentation..."
echo "------------------------"
check_file "docs/getting-started.md" "Getting Started Guide"
check_file "docs/configuration-guide.md" "Configuration Guide"
count_files "docs" "*.md" "documentation files"
echo ""

echo "Checking MCP Components..."
echo "-------------------------"
check_file "conversation-logger/index.js" "Conversation Logger Index"
check_file "conversation-logger/package.json" "Conversation Logger Package"

# Check for conversation-logger dependencies
if [ -d "conversation-logger/node_modules" ]; then
    echo -e "${GREEN}[OK]${NC} Conversation Logger dependencies installed"
else
    echo -e "${YELLOW}[WARNING]${NC} Conversation Logger dependencies not installed"
    echo "             Run: cd conversation-logger && npm install"
    ISSUES=$((ISSUES + 1))
fi

# Verify MCP servers configuration
echo ""
echo "MCP Server Configuration:"
echo "- Expected: 7 servers (5 core + 2 Obsidian)"
echo "- Core: conversation-logger, sequential-thinking, memory, filesystem, pubmed"
echo "- Obsidian: 2 vault connections (configurable)"
echo ""

echo "=================================="
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}Verification PASSED!${NC}"
    echo "All required VERITAS components are present."
    echo ""
    echo "Next steps:"
    echo "1. Run ./setup.sh to set up a project"
    echo "2. Run ./scripts/configure-claude.sh to configure MCP servers"
    echo "3. Test with: claude 'test VERITAS system'"
else
    echo -e "${RED}Verification FAILED${NC}"
    echo "Found $ISSUES missing component(s)."
    echo ""
    echo "Please ensure you have:"
    echo "1. Cloned the complete repository"
    echo "2. Run from the VERITAS directory"
    echo "3. Have all submodules initialized"
fi
echo "=================================="

exit $ISSUES