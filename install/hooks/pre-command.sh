#!/bin/bash

# Universal VERITAS Pre-Command Hook
# Enforces constitutional requirements with project-specific context

echo "=================================="
echo "VERITAS Constitutional Enforcement"
echo "=================================="

# Function to find project root (where CLAUDE.md exists)
find_project_root() {
    # Get the directory where this script is located
    local script_dir="$(cd "$(dirname "$0")" && pwd)"
    
    # If we're in .claude/hooks/, go up two levels to project root
    if [[ "$script_dir" == *"/.claude/hooks" ]]; then
        local project_root="$(cd "$script_dir/../.." && pwd)"
        if [ -f "$project_root/CLAUDE.md" ]; then
            echo "$project_root"
            return 0
        fi
    fi
    
    # Fallback: search upward from current directory
    local current_dir="$script_dir"
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/CLAUDE.md" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    # Last resort: check current working directory
    if [ -f "$(pwd)/CLAUDE.md" ]; then
        echo "$(pwd)"
        return 0
    fi
    
    return 1
}

# Function to load project context if available
load_project_context() {
    local project_root="$1"
    local project_json="$project_root/.claude/project.json"
    
    if [ -f "$project_json" ]; then
        # Extract project info using grep and sed (portable)
        PROJECT_TITLE=$(grep -o '"title"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        PROJECT_ICON=$(grep -o '"icon"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        PROJECT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        PROJECT_TYPE=$(grep -o '"type"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        
        if [ -n "$PROJECT_TITLE" ]; then
            echo "$PROJECT_TITLE Pre-Command Check"
            echo "Project: $PROJECT_NAME"
            return 0
        fi
    fi
    
    # Default if no project context
    echo "VERITAS Pre-Command Check"
    return 1
}

# Function to display universal VERITAS requirements
display_veritas_requirements() {
    cat << 'EOF'

VERITAS CONSTITUTIONAL REQUIREMENTS:
Article 1: START with mcp__sequential-thinking for complex tasks
Article 2: Read domain expert files for templates
Article 3: EVERY claim needs (Author et al., Year, PMID: XXXXXXXX)
Article 4: Follow tool priority order
Article 5: Obsidian formatting laws (.md extension, proper tables)
Article 6: Professional writing standards (no emojis, no drama)
Article 7: Automatic conversation logging (silent)
Article 8: All articles are mandatory

UNIVERSAL TOOL PRIORITY:
1. mcp__sequential-thinking__* - Problem breakdown
2. mcp__memory__* - Check existing knowledge
3. mcp__pubmed__* - Citation verification
4. mcp__obsidian-rest-*__* - Vault operations
5. Domain-specific tools per project

FORMATTING STANDARDS:
- NO escaped newlines (\n) - use actual line breaks
- Tables: spaces around pipes | Cell |
- Use actual > < symbols, not HTML entities
- NO underscores in H1 headings
- Wiki links: [[Concept_Name]] with underscores
- ALWAYS append .md to file paths
EOF
}

# Function to display project-specific context
display_project_context() {
    local project_json="$1"
    
    if [ ! -f "$project_json" ]; then
        return 1
    fi
    
    # Check if medical research project
    if grep -q '"type"[[:space:]]*:[[:space:]]*"medical_research"' "$project_json"; then
        echo ""
        echo "PROJECT CONTEXT:"
        
        # Extract and display grant details if present
        if grep -q '"grant_details"' "$project_json"; then
            GRANT_TYPE=$(grep -A5 '"grant_details"' "$project_json" | grep '"type"' | sed 's/.*: *"\(.*\)".*/\1/')
            SUBMISSION=$(grep -A5 '"grant_details"' "$project_json" | grep '"submission"' | sed 's/.*: *"\(.*\)".*/\1/')
            
            [ -n "$GRANT_TYPE" ] && echo "- Grant: $GRANT_TYPE"
            [ -n "$SUBMISSION" ] && echo "- Submission: $SUBMISSION"
        fi
        
        # Extract focus if present
        FOCUS=$(grep -o '"focus"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        [ -n "$FOCUS" ] && echo "- Focus: $FOCUS"
        
        # Extract stage if present
        STAGE=$(grep -o '"stage"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_json" | sed 's/.*: *"\(.*\)"/\1/')
        [ -n "$STAGE" ] && echo "- Stage: $STAGE"
        
        echo ""
        echo "STRICT ENFORCEMENT MODE: Medical/Scientific"
        echo "- ALL claims require PMID citations"
        echo "- Include verification levels"
        echo "- Grant-ready prose expected"
    fi
}

# Function to check if CLAUDE.md exists
check_claude_md() {
    local project_root="$1"
    
    if [ ! -f "$project_root/CLAUDE.md" ]; then
        echo "WARNING: CLAUDE.md not found in $project_root"
        return 1
    else
        echo " CLAUDE.md loaded from $project_root"
        return 0
    fi
}

# Function to check command context for enforcement
check_command_context() {
    # Medical/scientific terms that trigger strict enforcement
    if [[ "$CLAUDE_COMMAND" == *"pubmed"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"research"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"grant"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"medical"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"clinical"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"study"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"patient"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"treatment"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"diagnosis"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"antibod"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"transplant"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"HLA"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"epitope"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"MFI"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"algorithm"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"rule"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"Rule"* ]]; then
        echo " Medical/Scientific context detected - STRICT PMID enforcement"
        export CLAUDE_STRICT_PMID="true"
        export CLAUDE_MEDICAL_CONTEXT="true"
    fi
    
    # Obsidian-specific context
    if [[ "$CLAUDE_COMMAND" == *"obsidian"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"vault"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"note"* ]] || \
       [[ "$CLAUDE_COMMAND" == *"journal"* ]]; then
        echo " Obsidian context detected - Formatting enforcement active"
        export CLAUDE_OBSIDIAN_MODE="true"
    fi
}

# Function to inject context into environment
inject_environment() {
    # Universal VERITAS flags
    export CLAUDE_VERITAS_ACTIVE="true"
    export CLAUDE_REQUIRE_SEQUENTIAL="true"
    export CLAUDE_REQUIRE_CITATIONS="true"
    export CLAUDE_PROFESSIONAL_WRITING="true"
    
    # Create temporary context file
    CONTEXT_FILE="/tmp/claude_veritas_context_$$.txt"
    {
        echo "VERITAS ENFORCEMENT ACTIVE"
        echo "=========================="
        display_veritas_requirements
    } > "$CONTEXT_FILE"
    export CLAUDE_CONTEXT_FILE="$CONTEXT_FILE"
    
    echo " VERITAS context injected"
}

# Main execution
echo "Running pre-command checks..."
echo ""

# Find project root
PROJECT_ROOT=$(find_project_root)
if [ $? -ne 0 ]; then
    echo "⚠️  WARNING: Not in a VERITAS project (no CLAUDE.md found)"
    PROJECT_ROOT="."
fi

# Load project context if available
load_project_context "$PROJECT_ROOT"

# Check for CLAUDE.md
check_claude_md "$PROJECT_ROOT"

# Display universal requirements
display_veritas_requirements

# Display project-specific context
display_project_context "$PROJECT_ROOT/.claude/project.json"

# Check command context
check_command_context

# Inject environment variables
inject_environment

echo ""
echo "=================================="
echo "✅ Pre-command hook completed"
echo ""

# Allow command to proceed
exit 0