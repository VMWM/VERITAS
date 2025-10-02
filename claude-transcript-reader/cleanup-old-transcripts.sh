#!/bin/bash
#
# Cleanup script for old Claude Code transcripts
# Deletes JSONL files older than 5 days
#

RETENTION_DAYS=5
CLAUDE_PROJECTS_DIR="$HOME/.claude/projects"

echo "=== Claude Transcript Cleanup ==="
echo "Retention period: $RETENTION_DAYS days"
echo "Projects directory: $CLAUDE_PROJECTS_DIR"
echo ""

if [ ! -d "$CLAUDE_PROJECTS_DIR" ]; then
    echo "Error: Projects directory does not exist"
    exit 1
fi

# Find and delete JSONL files older than retention period
DELETED_COUNT=0
while IFS= read -r -d '' file; do
    echo "Deleting: $file"
    rm "$file"
    ((DELETED_COUNT++))
done < <(find "$CLAUDE_PROJECTS_DIR" -name "*.jsonl" -type f -mtime +$RETENTION_DAYS -print0)

echo ""
echo "Cleanup complete. Deleted $DELETED_COUNT file(s)."
