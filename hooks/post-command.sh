#!/bin/bash

# Universal VERITAS Post-Command Validation Hook
# Validates output compliance after generation

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=================================="
echo "VERITAS Post-Execution Validator"
echo "=================================="

# Function to find project root
find_project_root() {
    local current_dir="$(cd "$(dirname "$0")" && pwd)"
    # Check up two levels for CLAUDE.md (hooks are in .claude/hooks/)
    if [ -f "$current_dir/../../CLAUDE.md" ]; then
        echo "$(cd "$current_dir/../.." && pwd)"
        return 0
    fi
    # Otherwise search upward
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/CLAUDE.md" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    return 1
}

# Get project root
PROJECT_ROOT=$(find_project_root)
if [ $? -ne 0 ]; then
    echo "  Not in a VERITAS project"
    exit 0
fi

# Load project configuration if available
PROJECT_JSON="$PROJECT_ROOT/.claude/project.json"
OBSIDIAN_VAULTS=()

if [ -f "$PROJECT_JSON" ]; then
    # Extract Obsidian vault paths from project.json
    while IFS= read -r vault; do
        # Clean up the vault path (remove quotes and commas only, preserve spaces in paths)
        vault=$(echo "$vault" | sed 's/[",]//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$vault" ]; then
            # Expand home directory if present
            vault="${vault/#\~/$HOME}"
            # Convert relative paths to absolute
            if [[ "$vault" == /* ]]; then
                FULL_PATH="$vault"
            else
                FULL_PATH="$HOME/Library/CloudStorage/Box-Box$vault"
            fi
            if [ -d "$FULL_PATH" ]; then
                OBSIDIAN_VAULTS+=("$FULL_PATH")
            fi
        fi
    done < <(grep -A10 '"obsidian_vaults"' "$PROJECT_JSON" 2>/dev/null | grep '"/' | sed 's/.*"\(.*\)".*/\1/')
fi

# Set up logging
LOG_DIR="$PROJECT_ROOT/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/validation-$(date +%Y%m%d).log"
VIOLATIONS_FILE="$LOG_DIR/violations.json"

# Function to log violations
log_violation() {
    local type="$1"
    local file="$2"
    local issue="$3"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] VIOLATION: $type - $file - $issue" >> "$LOG_FILE"
    echo -e "${RED}❌ VIOLATION: $issue${NC}"
}

# Function to check recently modified files
check_recent_files() {
    local vault_path="$1"
    local vault_name="$2"
    local violations_found=0
    
    if [ ! -d "$vault_path" ]; then
        return 0
    fi
    
    # Find files modified in the last 5 minutes
    recent_files=$(find "$vault_path" -type f -name "*.md" -mmin -5 2>/dev/null)
    
    if [ -z "$recent_files" ]; then
        return 0
    fi
    
    echo "Checking recent files in: $(basename "$vault_path")"
    
    while IFS= read -r file; do
        local filename=$(basename "$file")
        local content=$(cat "$file" 2>/dev/null)
        
        # Check 1: File extension
        if [[ ! "$filename" =~ \.md$ ]]; then
            log_violation "EXTENSION" "$file" "Missing .md extension"
            ((violations_found++))
        fi
        
        # Check 2: Table formatting
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
            log_violation "HTML_ENTITIES" "$file" "Contains HTML entities"
            ((violations_found++))
        fi
        
        # Check 5: H1 with underscores
        if echo "$content" | grep -q '^# .*_'; then
            log_violation "H1_UNDERSCORES" "$file" "H1 heading contains underscores"
            ((violations_found++))
        fi
        
        # Check 6: Wiki links formatting
        if echo "$content" | grep -q '\[\[[A-Za-z]* [A-Za-z]*\]\]'; then
            log_violation "WIKI_LINKS" "$file" "Wiki links need underscores for spaces"
            ((violations_found++))
        fi
        
        # Check 7: Medical content without PMID (if medical project)
        if [ -f "$PROJECT_JSON" ] && grep -q '"type".*"medical_research"' "$PROJECT_JSON"; then
            if [[ "$file" =~ "Research" ]] || [[ "$file" =~ "Concept" ]]; then
                # Count potential claims
                claims=$(echo "$content" | grep -c '\(increase\|decrease\|associate\|correlat\|significant\|risk\|rate\|incidence\|prevalence\|%\)')
                # Count PMID citations
                pmids=$(echo "$content" | grep -c 'PMID: [0-9]\{8\}')
                
                if [ $claims -gt 0 ] && [ $pmids -eq 0 ]; then
                    log_violation "MISSING_PMID" "$file" "Medical claims without PMID"
                    ((violations_found++))
                fi
            fi
        fi
        
    done <<< "$recent_files"
    
    return $violations_found
}

# Function to check for missing extensions
check_missing_extensions() {
    local vault_path="$1"
    local issues=0
    
    # Check common directories for files without extensions
    for dir in "Research Questions" "Concepts" "Daily" "Rules" "Notes"; do
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

# Check each configured Obsidian vault
if [ ${#OBSIDIAN_VAULTS[@]} -gt 0 ]; then
    echo "Checking ${#OBSIDIAN_VAULTS[@]} configured vault(s)..."
    for vault in "${OBSIDIAN_VAULTS[@]}"; do
        check_recent_files "$vault" "$(basename "$vault")"
        vault_violations=$?
        total_violations=$((total_violations + vault_violations))
        
        check_missing_extensions "$vault"
        ext_violations=$?
        total_violations=$((total_violations + ext_violations))
    done
else
    echo "No Obsidian vaults configured for this project"
fi

# Report results
echo "=================================="
if [ $total_violations -eq 0 ]; then
    echo -e "${GREEN}✅ Output Validation: PASSED${NC}"
    echo "All files meet VERITAS formatting requirements"
else
    echo -e "${RED}⚠️  Output Validation: FAILED${NC}"
    echo -e "${RED}Found $total_violations violation(s)${NC}"
    echo ""
    echo "TO FIX VIOLATIONS:"
    echo "1. Missing extensions: Add .md to file paths"
    echo "2. Table formatting: Use | Cell | with spaces"
    echo "3. Wiki links: Use [[Concept_Name]] with underscores"
    echo "4. Check log: $LOG_FILE"
fi

# Create JSON report
cat > "$VIOLATIONS_FILE" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "project": "$PROJECT_ROOT",
  "total_violations": $total_violations,
  "log_file": "$LOG_FILE",
  "status": $([ $total_violations -eq 0 ] && echo '"passed"' || echo '"failed"')
}
EOF

echo "=================================="

# Return status (0 = success, non-zero = violations found)
exit $total_violations