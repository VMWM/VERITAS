#!/bin/bash

# VERITAS Test Environment Setup
# Creates an isolated test environment without affecting your working setup

echo "════════════════════════════════════════════════"
echo "VERITAS Test Environment Setup"
echo "════════════════════════════════════════════════"
echo ""
echo "This will create a test environment that won't interfere"
echo "with your existing VERITAS setup."
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Create test directory
TEST_DIR="$HOME/VERITAS-TEST"
echo "Creating test environment at: $TEST_DIR"
echo ""

# Check if test directory already exists
if [ -d "$TEST_DIR" ]; then
    echo -e "${YELLOW}Test directory already exists.${NC}"
    read -p "Remove and recreate? (y/n): " RECREATE
    if [ "$RECREATE" = "y" ]; then
        rm -rf "$TEST_DIR"
    else
        echo "Using existing directory."
    fi
fi

# Create test project structure
mkdir -p "$TEST_DIR/project"
mkdir -p "$TEST_DIR/test-vaults/HLA-Test"
mkdir -p "$TEST_DIR/test-vaults/Journal-Test"

# Copy VERITAS files (not git clone, use current version)
echo "Copying VERITAS files to test environment..."
cp -r "$(pwd)" "$TEST_DIR/VERITAS-COPY"

# Create test configuration
echo "Creating test configuration..."

# Create isolated .claude directory
mkdir -p "$TEST_DIR/project/.claude"
cp -r .claude/* "$TEST_DIR/project/.claude/" 2>/dev/null || true

# Create test environment file
cat > "$TEST_DIR/project/.claude/env.sh" << 'EOF'
#!/bin/bash
# TEST Environment Configuration
export CLAUDE_PROJECT_DIR="$HOME/VERITAS-TEST/project"
export OBSIDIAN_VAULT_PATH="$HOME/VERITAS-TEST/test-vaults/HLA-Test"
export OBSIDIAN_JOURNAL_PATH="$HOME/VERITAS-TEST/test-vaults/Journal-Test"
export OBSIDIAN_API_KEY="test-api-key-12345"
export OBSIDIAN_PRIMARY_PORT="27130"  # Different port for testing
export OBSIDIAN_JOURNAL_PORT="27131"  # Different port for testing
export TEST_ENVIRONMENT=1
export ENFORCE_OBSIDIAN_MCP=1
EOF

chmod +x "$TEST_DIR/project/.claude/env.sh"

# Create test CLAUDE.md
cp templates/CLAUDE.md.template "$TEST_DIR/project/CLAUDE.md"

# Create a test script to run setup
cat > "$TEST_DIR/run-test-setup.sh" << 'EOF'
#!/bin/bash

echo "════════════════════════════════════════════════"
echo "Running VERITAS Setup in Test Mode"
echo "════════════════════════════════════════════════"
echo ""
echo "This will test the setup process without affecting"
echo "your working VERITAS installation."
echo ""

cd "$HOME/VERITAS-TEST/VERITAS-COPY"

# Create temporary Claude configs for testing
TEST_CLAUDE_DESKTOP="$HOME/VERITAS-TEST/claude_desktop_config.json"
TEST_CLAUDE_CLI="$HOME/VERITAS-TEST/claude.json"

echo "Test configuration files will be created at:"
echo "  Desktop: $TEST_CLAUDE_DESKTOP"
echo "  CLI: $TEST_CLAUDE_CLI"
echo ""

# Run setup with test project directory
echo "When prompted for project directory, enter:"
echo "  $HOME/VERITAS-TEST/project"
echo ""
echo "For Obsidian configuration, use these test values:"
echo "  Vault path: $HOME/VERITAS-TEST/test-vaults/HLA-Test"
echo "  Journal path: $HOME/VERITAS-TEST/test-vaults/Journal-Test"
echo "  Ports: 27130 and 27131 (different from your real setup)"
echo ""

read -p "Press Enter to start the test setup..."

# Run the actual setup
./setup.sh

echo ""
echo "════════════════════════════════════════════════"
echo "Test Setup Complete!"
echo "════════════════════════════════════════════════"
echo ""
echo "The test created configuration files at:"
echo "  $TEST_CLAUDE_DESKTOP"
echo "  $TEST_CLAUDE_CLI"
echo ""
echo "These are separate from your real Claude configs and"
echo "won't affect your working setup."
echo ""
echo "To verify the setup worked:"
echo "1. Check for errors in the output above"
echo "2. Verify MCP servers were installed"
echo "3. Check configuration files were created"
echo "4. Review $HOME/VERITAS-TEST/project/.claude/env.sh"
echo ""
echo "To clean up the test environment:"
echo "  rm -rf $HOME/VERITAS-TEST"
EOF

chmod +x "$TEST_DIR/run-test-setup.sh"

# Create a validation script
cat > "$TEST_DIR/validate-test.sh" << 'EOF'
#!/bin/bash

echo "════════════════════════════════════════════════"
echo "Validating Test Installation"
echo "════════════════════════════════════════════════"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

ERRORS=0

# Check if project directory was created
if [ -d "$HOME/VERITAS-TEST/project" ]; then
    echo -e "${GREEN}✓ Project directory created${NC}"
else
    echo -e "${RED}✗ Project directory missing${NC}"
    ((ERRORS++))
fi

# Check if .claude directory exists
if [ -d "$HOME/VERITAS-TEST/project/.claude" ]; then
    echo -e "${GREEN}✓ .claude directory created${NC}"
else
    echo -e "${RED}✗ .claude directory missing${NC}"
    ((ERRORS++))
fi

# Check if env.sh was created
if [ -f "$HOME/VERITAS-TEST/project/.claude/env.sh" ]; then
    echo -e "${GREEN}✓ Environment file created${NC}"
    echo "  Contents:"
    grep "export" "$HOME/VERITAS-TEST/project/.claude/env.sh" | head -5
else
    echo -e "${RED}✗ Environment file missing${NC}"
    ((ERRORS++))
fi

# Check if hooks are executable
HOOK_COUNT=$(find "$HOME/VERITAS-TEST/project/.claude/hooks" -type f \( -name "*.sh" -o -name "*.py" \) -perm +111 2>/dev/null | wc -l)
if [ $HOOK_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓ $HOOK_COUNT hooks are executable${NC}"
else
    echo -e "${RED}✗ Hooks not executable or missing${NC}"
    ((ERRORS++))
fi

# Check if CLAUDE.md was copied
if [ -f "$HOME/VERITAS-TEST/project/CLAUDE.md" ]; then
    echo -e "${GREEN}✓ CLAUDE.md created${NC}"
else
    echo -e "${RED}✗ CLAUDE.md missing${NC}"
    ((ERRORS++))
fi

# Check test configs (if setup was run)
if [ -f "$HOME/VERITAS-TEST/claude_desktop_config.json" ]; then
    echo -e "${GREEN}✓ Test Desktop config created${NC}"
    echo "  MCP servers configured:"
    jq '.mcpServers | keys[]' "$HOME/VERITAS-TEST/claude_desktop_config.json" 2>/dev/null | head -5
else
    echo -e "${RED}✗ Test Desktop config not created (setup not run yet?)${NC}"
fi

echo ""
echo "════════════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Validation PASSED - Test environment is ready${NC}"
else
    echo -e "${RED}Validation FAILED - $ERRORS issues found${NC}"
fi
echo "════════════════════════════════════════════════"
EOF

chmod +x "$TEST_DIR/validate-test.sh"

# Final instructions
echo ""
echo "════════════════════════════════════════════════"
echo -e "${GREEN}Test Environment Created Successfully!${NC}"
echo "════════════════════════════════════════════════"
echo ""
echo "Test directory structure:"
echo "  $TEST_DIR/"
echo "  ├── VERITAS-COPY/       (copy of VERITAS repo)"
echo "  ├── project/            (test project directory)"
echo "  ├── test-vaults/        (test Obsidian vaults)"
echo "  ├── run-test-setup.sh   (run the setup test)"
echo "  └── validate-test.sh    (validate installation)"
echo ""
echo "To test the setup process:"
echo "  1. cd $TEST_DIR"
echo "  2. ./run-test-setup.sh"
echo ""
echo "To validate the test installation:"
echo "  ./validate-test.sh"
echo ""
echo "To clean up when done:"
echo "  rm -rf $TEST_DIR"
echo ""
echo -e "${YELLOW}Note: This test environment is completely isolated${NC}"
echo -e "${YELLOW}from your working VERITAS setup.${NC}"