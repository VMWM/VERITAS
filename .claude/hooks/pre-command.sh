#!/bin/bash

# Pre-command hook for VERITAS Research Assistant
# This hook runs before every Claude Code command to enforce CLAUDE.md instructions

echo "COMPLIANCE VALIDATOR ACTIVE"
echo "=============================="

# Function to display critical reminders
display_reminders() {
    cat << 'EOF'
CRITICAL REQUIREMENTS:
1. EVERY research/scientific claim MUST have (Author et al., Year, PMID: XXXXXXXX)
2. Use PubMed MCP for ALL claims - no exceptions
3. Verify project files via PubMed (may contain personal notes)
4. No PMID = Remove the claim entirely
5. Include verification level: [FT-VERIFIED], [ABSTRACT-VERIFIED], or [NEEDS-FT-REVIEW]

TOOL PRIORITY:
1. mcp__memory__* - Check existing knowledge first
2. mcp__pubmed__search_pubmed - PRIMARY for all research claims
3. mcp__pubmed__fetch_summary - Get article details
4. mcp__pubmed__get_fulltext - Try for PMC full text
5. mcp__filesystem-local__* - Read files (verify claims)

OBSIDIAN FORMATTING:
- NO escaped newlines (\n) - use actual line breaks
- Tables: spaces around pipes | Cell |
- Use actual > < symbols, not HTML entities
- NO underscores in H1 headings
- Use [[Wiki_Links]] for concepts

RESEARCH CONTEXT:
- Citation-enforced research workflow
- Domain expert templates guide structure
- Write publication-ready content with embedded citations
EOF
}

# Function to check if CLAUDE.md exists
check_claude_md() {
    # Get project directory from environment or use current directory
    PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
    
    if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
        echo "WARNING: CLAUDE.md not found in $PROJECT_DIR!"
        return 1
    else
        echo "CLAUDE.md found and loaded"
        return 0
    fi
}

# Function to check if we're dealing with research content
check_context() {
    # Check if the command involves research files or topics
    if [[ "$CLAUDE_COMMAND" == *"pubmed"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"research"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"grant"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"academic"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"scientific"* ]]; then
        echo "Research context detected - STRICT PMID enforcement active"
        export CLAUDE_STRICT_PMID="true"
    fi
}

# Function to inject reminders into the context
inject_context() {
    # Export environment variables that Claude can access
    export CLAUDE_RESEARCH_MODE="true"
    export CLAUDE_REQUIRE_PMID="true"
    export CLAUDE_VERIFY_CLAIMS="true"
    export CLAUDE_GRANT_CONTEXT="RESEARCH_GRANT"
    
    # Create a temporary context file that Claude will read
    CONTEXT_FILE="/tmp/claude_research_context_$$.txt"
    display_reminders > "$CONTEXT_FILE"
    export CLAUDE_CONTEXT_FILE="$CONTEXT_FILE"
    
    echo "Context injection complete"
}

# Main execution
echo "Running pre-command checks..."
echo ""

# Run all checks
check_claude_md
check_context
display_reminders
inject_context

echo ""
echo "==========================================="
echo "Pre-command hook completed successfully"
echo ""

# Allow command to proceed
exit 0