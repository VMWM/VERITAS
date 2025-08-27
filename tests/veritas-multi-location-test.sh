#!/bin/bash

# VERITAS Multi-Location Test Suite
# Tests VERITAS setup across all locations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================"
echo "VERITAS MULTI-LOCATION TEST SUITE"
echo "========================================"
echo ""

# Test counters
PASSED=0
FAILED=0
WARNINGS=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Define locations
F31_PROJECT="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
MCP_SHARED="/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"
LOCAL_VERITAS="/Users/vmwm/VERITAS"
GITHUB_REPO="/Users/vmwm/VERITAS" # Assuming local clone

echo "Testing 4 VERITAS locations:"
echo "A) F31 Project: $F31_PROJECT"
echo "B) MCP-Shared: $MCP_SHARED"
echo "C) Local VERITAS: $LOCAL_VERITAS"
echo "D) GitHub Repository: $GITHUB_REPO"
echo ""

# ========================================
# A) F31 PROJECT FOLDER TEST
# ========================================
echo "========================================"
echo "A) F31 PROJECT FOLDER"
echo "========================================"

if [ -d "$F31_PROJECT" ]; then
    info "Testing F31 project configuration..."
    
    # Check for CLAUDE.md (should be configured, not template)
    if [ -f "$F31_PROJECT/CLAUDE.md" ]; then
        # Check if it's the constitution (should be ~78 lines)
        LINE_COUNT=$(wc -l < "$F31_PROJECT/CLAUDE.md")
        if [ "$LINE_COUNT" -lt 100 ]; then
            pass "CLAUDE.md is constitutional (compact at $LINE_COUNT lines)"
        else
            warn "CLAUDE.md is large ($LINE_COUNT lines) - should be constitutional"
        fi
        
        # Check for HLA-specific content (should NOT be in constitution)
        if grep -q "HLA F31 Grant Assistant" "$F31_PROJECT/CLAUDE.md"; then
            fail "CLAUDE.md contains HLA-specific content (should be in domain expert)"
        else
            pass "CLAUDE.md is domain-agnostic (good)"
        fi
    else
        fail "CLAUDE.md not found"
    fi
    
    # Check for domain expert file
    if [ -f "$F31_PROJECT/.claude/agents/hla-research-director.md" ]; then
        pass "HLA domain expert file found"
        
        # Check for HLA-specific content
        if grep -q "antigen\|antibod\|transplant\|HLA" "$F31_PROJECT/.claude/agents/hla-research-director.md"; then
            pass "Domain expert contains HLA-specific content"
        else
            warn "Domain expert missing HLA-specific content"
        fi
    else
        fail "Domain expert file not found"
    fi
    
    # Check hooks
    if [ -d "$F31_PROJECT/.claude/hooks" ]; then
        pass "Hooks directory exists"
        
        # Check critical hooks
        for hook in "enforce-claude-md.py" "pre-command.sh" "task-router.py"; do
            if [ -f "$F31_PROJECT/.claude/hooks/$hook" ]; then
                pass "Hook $hook exists"
            else
                fail "Hook $hook missing"
            fi
        done
    else
        fail "Hooks directory missing"
    fi
    
    # Check for test script
    if [ -f "$F31_PROJECT/veritas-test.sh" ]; then
        pass "Local test script exists"
    else
        warn "Local test script not found"
    fi
    
else
    fail "F31 project directory not found"
fi

echo ""

# ========================================
# B) MCP-SHARED FOLDER TEST
# ========================================
echo "========================================"
echo "B) MCP-SHARED FOLDER"
echo "========================================"

if [ -d "$MCP_SHARED" ]; then
    info "Testing MCP-Shared configuration..."
    
    # Check for conversation-logger
    if [ -d "$MCP_SHARED/conversation-logger" ]; then
        pass "Conversation-logger directory found"
        
        # Check critical files
        if [ -f "$MCP_SHARED/conversation-logger/index.js" ]; then
            pass "Conversation-logger index.js exists"
        else
            fail "Conversation-logger index.js missing"
        fi
        
        if [ -f "$MCP_SHARED/conversation-logger/package.json" ]; then
            pass "Conversation-logger package.json exists"
        else
            fail "Conversation-logger package.json missing"
        fi
        
        if [ -f "$MCP_SHARED/conversation-logger/cleanup-old-logs.js" ]; then
            pass "Cleanup script exists"
        else
            warn "Cleanup script missing"
        fi
    else
        fail "Conversation-logger not found in MCP-Shared"
    fi
    
    # Check for other MCP server directories (if any)
    info "Checking for other MCP servers..."
    MCP_COUNT=$(find "$MCP_SHARED" -name "package.json" -type f | wc -l)
    info "Found $MCP_COUNT MCP server(s) in MCP-Shared"
    
else
    warn "MCP-Shared directory not found"
fi

echo ""

# ========================================
# C) LOCAL VERITAS FOLDER TEST
# ========================================
echo "========================================"
echo "C) LOCAL VERITAS FOLDER"
echo "========================================"

if [ -d "$LOCAL_VERITAS" ]; then
    info "Testing local VERITAS configuration..."
    
    # Check for template files
    if [ -f "$LOCAL_VERITAS/templates/CLAUDE.md" ]; then
        pass "CLAUDE.md template found"
        
        # Check it's constitutional (no domain content)
        if grep -q "Domain Expert:" "$LOCAL_VERITAS/templates/CLAUDE.md"; then
            fail "Template contains domain-specific content"
        else
            pass "Template is domain-agnostic"
        fi
    else
        fail "CLAUDE.md template not found"
    fi
    
    # Check for domain expert template
    if [ -f "$LOCAL_VERITAS/templates/agents/example-domain-expert.md" ]; then
        pass "Domain expert template found"
    else
        fail "Domain expert template missing"
    fi
    
    # Check for documentation
    if [ -f "$LOCAL_VERITAS/README.md" ]; then
        pass "README.md exists"
    else
        fail "README.md missing"
    fi
    
    if [ -f "$LOCAL_VERITAS/ARCHITECTURE.md" ]; then
        pass "ARCHITECTURE.md exists"
    else
        warn "ARCHITECTURE.md missing"
    fi
    
    # Check for test files
    if [ -d "$LOCAL_VERITAS/tests" ]; then
        pass "Tests directory exists"
        
        if [ -f "$LOCAL_VERITAS/tests/veritas-test.sh" ]; then
            pass "Test script exists"
        else
            fail "Test script missing"
        fi
        
        if [ -f "$LOCAL_VERITAS/tests/test-checklist.md" ]; then
            pass "Test checklist exists"
        else
            warn "Test checklist missing"
        fi
    else
        fail "Tests directory missing"
    fi
    
    # Check for setup script
    if [ -f "$LOCAL_VERITAS/setup.sh" ]; then
        pass "Setup script exists"
    else
        fail "Setup script missing"
    fi
    
else
    fail "Local VERITAS directory not found"
fi

echo ""

# ========================================
# D) GITHUB REPOSITORY TEST
# ========================================
echo "========================================"
echo "D) GITHUB REPOSITORY (Local Clone)"
echo "========================================"

# For GitHub, we check the same as local VERITAS but ensure it's git-tracked
if [ -d "$GITHUB_REPO/.git" ]; then
    info "Testing GitHub repository structure..."
    pass "Git repository detected"
    
    # Check remote
    REMOTE_URL=$(cd "$GITHUB_REPO" && git remote get-url origin 2>/dev/null)
    if [[ "$REMOTE_URL" == *"github.com"* ]]; then
        pass "GitHub remote configured: $REMOTE_URL"
    else
        warn "Non-GitHub remote: $REMOTE_URL"
    fi
    
    # Check branch
    BRANCH=$(cd "$GITHUB_REPO" && git branch --show-current 2>/dev/null)
    info "Current branch: $BRANCH"
    
    # Check for uncommitted changes
    if [ -n "$(cd "$GITHUB_REPO" && git status --porcelain 2>/dev/null)" ]; then
        warn "Uncommitted changes in repository"
    else
        pass "Repository is clean"
    fi
    
    # Ensure no personal data in templates
    if [ -f "$GITHUB_REPO/templates/CLAUDE.md" ]; then
        if grep -q "VM_F31_2025\|vmwm\|HLA" "$GITHUB_REPO/templates/CLAUDE.md"; then
            fail "Personal/project data found in template!"
        else
            pass "Template is generic (no personal data)"
        fi
    fi
    
else
    warn "Not a git repository or git not initialized"
fi

echo ""

# ========================================
# CONSISTENCY CHECKS
# ========================================
echo "========================================"
echo "CONSISTENCY CHECKS"
echo "========================================"

info "Checking consistency between locations..."

# Check if F31 CLAUDE.md matches VERITAS template structure
if [ -f "$F31_PROJECT/CLAUDE.md" ] && [ -f "$LOCAL_VERITAS/templates/CLAUDE.md" ]; then
    # Check for constitutional articles
    F31_ARTICLES=$(grep -c "Article [0-9]:" "$F31_PROJECT/CLAUDE.md" 2>/dev/null || echo 0)
    TEMPLATE_ARTICLES=$(grep -c "Article [0-9]:" "$LOCAL_VERITAS/templates/CLAUDE.md" 2>/dev/null || echo 0)
    
    if [ "$F31_ARTICLES" -eq "$TEMPLATE_ARTICLES" ] && [ "$F31_ARTICLES" -gt 0 ]; then
        pass "Same number of constitutional articles ($F31_ARTICLES)"
    else
        warn "Different number of articles: F31=$F31_ARTICLES, Template=$TEMPLATE_ARTICLES"
    fi
fi

# Check if conversation-logger versions match
if [ -f "$MCP_SHARED/conversation-logger/package.json" ] && [ -f "$LOCAL_VERITAS/conversation-logger/package.json" ]; then
    MCP_VERSION=$(grep '"version"' "$MCP_SHARED/conversation-logger/package.json" | head -1)
    LOCAL_VERSION=$(grep '"version"' "$LOCAL_VERITAS/conversation-logger/package.json" | head -1)
    
    if [ "$MCP_VERSION" = "$LOCAL_VERSION" ]; then
        pass "Conversation-logger versions match"
    else
        warn "Conversation-logger versions differ"
    fi
fi

echo ""

# ========================================
# SUMMARY
# ========================================
echo "========================================"
echo "TEST SUMMARY BY LOCATION"
echo "========================================"

echo ""
echo "A) F31 Project Folder:"
echo "   - Purpose: Active HLA research with configured VERITAS"
echo "   - Expected: Constitutional CLAUDE.md + HLA domain expert"
echo "   - Status: Check results above"

echo ""
echo "B) MCP-Shared Folder:"
echo "   - Purpose: MCP server installations"
echo "   - Expected: conversation-logger and other MCP servers"
echo "   - Status: Check results above"

echo ""
echo "C) Local VERITAS Folder:"
echo "   - Purpose: VERITAS development and templates"
echo "   - Expected: Templates, tests, documentation"
echo "   - Status: Check results above"

echo ""
echo "D) GitHub Repository:"
echo "   - Purpose: Public VERITAS distribution"
echo "   - Expected: Generic templates, no personal data"
echo "   - Status: Check results above"

echo ""
echo "========================================"
echo "OVERALL TEST RESULTS"
echo "========================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ "$FAILED" -eq 0 ]; then
    if [ "$WARNINGS" -eq 0 ]; then
        echo -e "${GREEN}ALL LOCATIONS PROPERLY CONFIGURED!${NC}"
    else
        echo -e "${YELLOW}LOCATIONS CONFIGURED WITH MINOR ISSUES${NC}"
    fi
else
    echo -e "${RED}CONFIGURATION ISSUES DETECTED${NC}"
    echo "Review failed tests above and fix inconsistencies"
fi