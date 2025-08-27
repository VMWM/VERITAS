#!/bin/bash

# VERITAS Comprehensive Test Suite
# Tests all constitutional articles, hooks, and MCP servers

# set -e  # Disabled to prevent early exit

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "VERITAS CONSTITUTIONAL TEST SUITE"
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
    echo -e "  ℹ $1"
}

# 1. Test File Structure
echo "1. TESTING FILE STRUCTURE"
echo "------------------------"

if [ -f "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/CLAUDE.md" ]; then
    pass "CLAUDE.md found in project"
else
    fail "CLAUDE.md not found in project"
fi

if [ -f "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/agents/hla-research-director.md" ]; then
    pass "Domain expert file found"
else
    fail "Domain expert file not found"
fi

if [ -d "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/hooks" ]; then
    pass "Hooks directory exists"
else
    fail "Hooks directory missing"
fi

echo ""

# 2. Test Hook Files
echo "2. TESTING ENFORCEMENT HOOKS"
echo "----------------------------"

HOOKS=(
    "pre-command.sh"
    "task-router.py"
    "compliance-validator.sh"
    "enforce-claude-md.py"
    "post-command.py"
)

for hook in "${HOOKS[@]}"; do
    if [ -f "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/hooks/$hook" ]; then
        if [ -x "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/hooks/$hook" ]; then
            pass "$hook exists and is executable"
        else
            warn "$hook exists but not executable"
        fi
    else
        fail "$hook not found"
    fi
done

echo ""

# 3. Test MCP Servers
echo "3. TESTING MCP SERVERS"
echo "----------------------"

# Check if Claude CLI is available
if command -v claude &> /dev/null; then
    # List MCP servers
    MCP_OUTPUT=$(claude mcp list 2>/dev/null || echo "ERROR")
    
    if [[ "$MCP_OUTPUT" != "ERROR" ]]; then
        # Check for required servers
        REQUIRED_SERVERS=(
            "sequential-thinking"
            "pubmed"
            "memory"
            "conversation-logger"
            "obsidian-rest-hla"
            "obsidian-rest-journal"
            "filesystem-local"
        )
        
        for server in "${REQUIRED_SERVERS[@]}"; do
            if echo "$MCP_OUTPUT" | grep -q "$server"; then
                pass "MCP server '$server' configured"
            else
                fail "MCP server '$server' not found"
            fi
        done
    else
        warn "Could not list MCP servers"
    fi
else
    warn "Claude CLI not installed - skipping MCP tests"
fi

echo ""

# 4. Test Conversation Logger Database
echo "4. TESTING CONVERSATION LOGGER"
echo "------------------------------"

DB_PATH="$HOME/.conversation-logger/conversations.db"

if [ -f "$DB_PATH" ]; then
    pass "Conversation logger database exists"
    
    # Check if we can query it
    if command -v sqlite3 &> /dev/null; then
        SESSION_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM sessions;" 2>/dev/null || echo "ERROR")
        if [[ "$SESSION_COUNT" != "ERROR" ]]; then
            pass "Database accessible (Sessions: $SESSION_COUNT)"
        else
            fail "Database exists but not accessible"
        fi
    else
        warn "sqlite3 not installed - cannot verify database"
    fi
else
    warn "Conversation logger database not found"
fi

# Check cleanup script
CLEANUP_SCRIPT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/conversation-logger/cleanup-old-logs.js"
if [ -f "$CLEANUP_SCRIPT" ]; then
    pass "Cleanup script exists"
else
    warn "Cleanup script not found"
fi

# Check cron job
if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
    pass "Cleanup cron job configured"
else
    warn "Cleanup cron job not configured"
fi

echo ""

# 5. Test Obsidian REST API
echo "5. TESTING OBSIDIAN INTEGRATION"
echo "-------------------------------"

# Check if Obsidian REST API is responding
if command -v curl &> /dev/null; then
    # Test main vault (port 27124)
    RESPONSE=$(curl -s -k -H "Authorization: Bearer $OBSIDIAN_API_TOKEN" https://localhost:27124/ 2>/dev/null)
    if echo "$RESPONSE" | grep -q '"status":"OK"'; then
        if echo "$RESPONSE" | grep -q '"authenticated":true'; then
            pass "Obsidian REST API (main vault) responding and authenticated"
        else
            if [ -z "$OBSIDIAN_API_TOKEN" ]; then
                warn "Obsidian API (main vault) responding but no token set - run: source setup-env.sh"
            else
                warn "Obsidian API (main vault) responding but authentication failed - check token"
            fi
        fi
    else
        warn "Obsidian REST API (main vault) not responding - is Obsidian running?"
    fi
    
    # Test journal vault (port 27125)
    RESPONSE=$(curl -s -k -H "Authorization: Bearer $OBSIDIAN_API_TOKEN" https://localhost:27125/ 2>/dev/null)
    if echo "$RESPONSE" | grep -q '"status":"OK"'; then
        if echo "$RESPONSE" | grep -q '"authenticated":true'; then
            pass "Obsidian REST API (journal vault) responding and authenticated"
        else
            if [ -z "$OBSIDIAN_API_TOKEN" ]; then
                warn "Obsidian API (journal vault) responding but no token set - run: source setup-env.sh"
            else
                warn "Obsidian API (journal vault) responding but authentication failed - check token"
            fi
        fi
    else
        warn "Obsidian REST API (journal vault) not responding - is Obsidian running?"
    fi
else
    warn "curl not installed - cannot test Obsidian REST API"
fi

echo ""

# 6. Test Constitutional Compliance
echo "6. TESTING CONSTITUTIONAL ARTICLES"
echo "----------------------------------"

# Check CLAUDE.md size (should be <150 lines)
if [ -f "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/CLAUDE.md" ]; then
    LINE_COUNT=$(wc -l < "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/CLAUDE.md")
    if [ "$LINE_COUNT" -lt 150 ]; then
        pass "CLAUDE.md is compact ($LINE_COUNT lines)"
    else
        warn "CLAUDE.md is large ($LINE_COUNT lines) - may affect compliance"
    fi
fi

# Check for required articles in CLAUDE.md
ARTICLES=(
    "Article 1.*Complex Task Protocol"
    "Article 2.*Research Documentation"
    "Article 3.*Citation Requirements"
    "Article 4.*Tool Priority"
    "Article 5.*Obsidian Formatting"
    "Article 6.*Professional Writing"
    "Article 7.*Conversation Logging"
    "Article 8.*Enforcement"
)

for article in "${ARTICLES[@]}"; do
    if grep -E "$article" "$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/CLAUDE.md" > /dev/null 2>&1; then
        pass "Found: $article"
    else
        fail "Missing: $article"
    fi
done

echo ""

# 7. Test Validation Logs
echo "7. TESTING VALIDATION SYSTEM"
echo "----------------------------"

LOG_DIR="$HOME/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/logs"

if [ -d "$LOG_DIR" ]; then
    pass "Logs directory exists"
    
    # Check for recent validation logs
    RECENT_LOGS=$(find "$LOG_DIR" -name "validation-*.log" -mtime -7 2>/dev/null | wc -l)
    if [ "$RECENT_LOGS" -gt 0 ]; then
        pass "Found $RECENT_LOGS validation logs from past week"
    else
        warn "No recent validation logs found"
    fi
else
    warn "Logs directory not found"
fi

echo ""

# 8. Test Environment Variables
echo "8. TESTING ENVIRONMENT"
echo "----------------------"

if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    pass "CLAUDE_PROJECT_DIR is set: $CLAUDE_PROJECT_DIR"
else
    warn "CLAUDE_PROJECT_DIR not set - run: source /Users/vmwm/VERITAS/setup-env.sh"
    echo "   Note: This variable is automatically set in Claude Desktop"
fi

if [ -n "$OBSIDIAN_API_TOKEN" ]; then
    pass "OBSIDIAN_API_TOKEN is set"
else
    warn "OBSIDIAN_API_TOKEN not set - run: source /Users/vmwm/VERITAS/setup-env.sh"
    echo "   To get your token:"
    echo "   1. Open Obsidian > Settings > Community Plugins > Local REST API"
    echo "   2. Copy the API token"
    echo "   3. Run: echo 'YOUR_TOKEN' > ~/.obsidian_api_token"
fi

# Check if setup-env.sh exists
if [ -f "/Users/vmwm/VERITAS/setup-env.sh" ]; then
    info "Setup script available at /Users/vmwm/VERITAS/setup-env.sh"
else
    warn "Setup script not found - environment variables must be set manually"
fi

echo ""
echo "========================================"
echo "TEST RESULTS"
echo "========================================"
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ "$FAILED" -eq 0 ]; then
    if [ "$WARNINGS" -eq 0 ]; then
        echo -e "${GREEN}ALL TESTS PASSED!${NC}"
        exit 0
    else
        echo -e "${YELLOW}TESTS PASSED WITH WARNINGS${NC}"
        echo "Review warnings above for optional improvements"
        exit 0
    fi
else
    echo -e "${RED}TESTS FAILED${NC}"
    echo "Fix the failed tests above before using VERITAS"
    exit 1
fi