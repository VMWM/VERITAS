#!/bin/bash

# Post-Command Validation Hook for VERITAS
# Validates output compliance after generation

# Configuration - UPDATE THESE PATHS FOR YOUR SYSTEM
# Default paths - users should modify these in their local setup
OBSIDIAN_HLA="${OBSIDIAN_VAULT_PATH:-$HOME/Obsidian/HLA Antibodies}"
OBSIDIAN_JOURNAL="${OBSIDIAN_JOURNAL_PATH:-$HOME/Obsidian/Research Journal}"
LOG_FILE="${CLAUDE_PROJECT_DIR:-$HOME/Projects}/.claude/logs/validation-$(date +%Y%m%d).log"
VIOLATIONS_FILE="${CLAUDE_PROJECT_DIR:-$HOME/Projects}/.claude/logs/violations.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 POST-EXECUTION VALIDATOR"
echo "============================"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log violations
log_violation() {
    local type="$1"
    local file="$2"
    local issue="$3"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] VIOLATION: $type - $file - $issue" >> "$LOG_FILE"
    echo -e "${RED}❌ VIOLATION: $issue${NC}"
}

# Function to check recently modified Obsidian files
check_recent_files() {
    local vault_path="$1"
    local vault_name="$2"
    local violations_found=0
    
    # Find files modified in the last 5 minutes
    recent_files=$(find "$vault_path" -type f -name "*.md" -mmin -5 2>/dev/null)
    
    if [ -z "$recent_files" ]; then
        return 0
    fi
    
    echo "Checking recently created files in $vault_name..."
    
    while IFS= read -r file; do
        local filename=$(basename "$file")
        local content=$(cat "$file" 2>/dev/null)
        
        # Check 1: File extension (should always have .md)
        if [[ ! "$filename" =~ \.md$ ]]; then
            log_violation "EXTENSION" "$file" "Missing .md extension"
            ((violations_found++))
        fi
        
        # Check 2: Table formatting (pipes without spaces)
        if echo "$content" | grep -q '|[^[:space:]|]' || echo "$content" | grep -q '[^[:space:]|]|'; then
            log_violation "TABLE_FORMAT" "$file" "Tables missing spaces around pipes"
            ((violations_found++))
        fi
        
        # Check 3: Escaped newlines
        if echo "$content" | grep -q '\\n'; then
            log_violation "ESCAPED_CHARS" "$file" "Contains escaped newlines (\\n)"
            ((violations_found++))
        fi
        
        # Check 4: HTML entities
        if echo "$content" | grep -q '&gt;\|&lt;\|&amp;'; then
            log_violation "HTML_ENTITIES" "$file" "Contains HTML entities (&gt; &lt; &amp;)"
            ((violations_found++))
        fi
        
        # Check 5: H1 headings with underscores
        if echo "$content" | grep -q '^# .*_'; then
            log_violation "H1_UNDERSCORES" "$file" "H1 heading contains underscores"
            ((violations_found++))
        fi
        
        # Check 6: Wiki links without underscores for multi-word concepts
        if echo "$content" | grep -q '\[\[[A-Za-z]* [A-Za-z]*\]\]'; then
            log_violation "WIKI_LINKS" "$file" "Wiki links contain spaces instead of underscores"
            ((violations_found++))
        fi
        
        # Check 7: PMID citations (for research/medical content)
        if [[ "$file" =~ "Research Questions" ]] || [[ "$file" =~ "Concepts" ]]; then
            # Count claims that might need citations
            claims=$(echo "$content" | grep -c '\(increase\|decrease\|associate\|correlat\|significant\|risk\|rate\|incidence\|prevalence\|%\)')
            # Count actual PMID citations
            pmids=$(echo "$content" | grep -c 'PMID: [0-9]\{8\}')
            
            if [ $claims -gt 0 ] && [ $pmids -eq 0 ]; then
                log_violation "MISSING_PMID" "$file" "Contains claims without PMID citations"
                ((violations_found++))
            fi
        fi
        
    done <<< "$recent_files"
    
    return $violations_found
}

# Function to check for files without extensions
check_missing_extensions() {
    local vault_path="$1"
    local issues=0
    
    # Check key directories for files without extensions
    for dir in "Research Questions" "Concepts" "Daily" "Rules"; do
        if [ -d "$vault_path/$dir" ]; then
            files_without_ext=$(find "$vault_path/$dir" -type f ! -name "*.*" 2>/dev/null | head -5)
            if [ -n "$files_without_ext" ]; then
                while IFS= read -r file; do
                    log_violation "NO_EXTENSION" "$file" "File lacks .md extension"
                    ((issues++))
                done <<< "$files_without_ext"
            fi
        fi
    done
    
    return $issues
}

# Main validation
total_violations=0

# Check HLA vault
if [ -d "$OBSIDIAN_HLA" ]; then
    check_recent_files "$OBSIDIAN_HLA" "HLA Antibodies"
    hla_violations=$?
    total_violations=$((total_violations + hla_violations))
    
    check_missing_extensions "$OBSIDIAN_HLA"
    ext_violations=$?
    total_violations=$((total_violations + ext_violations))
fi

# Check Journal vault
if [ -d "$OBSIDIAN_JOURNAL" ]; then
    check_recent_files "$OBSIDIAN_JOURNAL" "Research Journal"
    journal_violations=$?
    total_violations=$((total_violations + journal_violations))
    
    check_missing_extensions "$OBSIDIAN_JOURNAL"
    ext_violations=$?
    total_violations=$((total_violations + ext_violations))
fi

# Report results
echo "============================"
if [ $total_violations -eq 0 ]; then
    echo -e "${GREEN}✅ Output Validation: PASSED${NC}"
    echo "All recently created files meet formatting requirements"
else
    echo -e "${RED}⚠️  Output Validation: FAILED${NC}"
    echo -e "${RED}Found $total_violations violation(s)${NC}"
    echo ""
    echo "TO FIX VIOLATIONS:"
    echo "1. For missing extensions: Add .md to file paths"
    echo "2. For table formatting: Use | Cell | with spaces"
    echo "3. For other issues: Check $LOG_FILE"
    echo ""
    echo -e "${YELLOW}To fix: Add .md extension to file paths in your Obsidian API calls${NC}"
fi

# Create JSON report for programmatic access
cat > "$VIOLATIONS_FILE" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "total_violations": $total_violations,
  "log_file": "$LOG_FILE",
  "status": $([ $total_violations -eq 0 ] && echo '"passed"' || echo '"failed"')
}
EOF

echo "============================"

# Return non-zero if violations found (signals failure)
exit $total_violations