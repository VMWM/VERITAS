# Addition for VERITAS setup.sh

Add this section after the Conversation Logger installation (around line 116):

```bash
# Configure automatic cleanup for conversation logger
echo "Configuring conversation logger cleanup..."
CLEANUP_SCRIPT="$SCRIPT_DIR/conversation-logger/cleanup-old-logs.js"
if [ -f "$CLEANUP_SCRIPT" ]; then
    chmod +x "$CLEANUP_SCRIPT"
    
    # Check if user wants automatic cleanup
    echo ""
    echo "The conversation logger can automatically clean up logs older than 5 days."
    read -p "Enable automatic cleanup at 2 AM daily? (y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        CRON_CMD="0 2 * * * cd '$SCRIPT_DIR/conversation-logger' && node cleanup-old-logs.js > /tmp/conversation-cleanup.log 2>&1"
        
        # Check if cron job already exists
        if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
            echo -e "${GREEN}✓ Cleanup job already scheduled${NC}"
        else
            # Add to crontab
            (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
            echo -e "${GREEN}✓ Automatic cleanup scheduled for 2 AM daily${NC}"
            echo "  Logs older than 5 days will be automatically removed"
        fi
    else
        echo -e "${YELLOW}⚠ Skipped automatic cleanup setup${NC}"
        echo "  To enable later, add to crontab:"
        echo "  0 2 * * * cd '$SCRIPT_DIR/conversation-logger' && node cleanup-old-logs.js"
    fi
else
    echo -e "${YELLOW}⚠ Cleanup script not found${NC}"
fi
echo ""
```

## Also Update the Final Summary Section

Add to the success message section:

```bash
echo "Conversation Logger:"
echo "  - Database: ~/.conversation-logger/conversations.db"
echo "  - Retention: 5 days (configurable)"
if crontab -l 2>/dev/null | grep -q "cleanup-old-logs.js"; then
    echo "  - Cleanup: Automatic at 2 AM daily"
else
    echo "  - Cleanup: Manual (run: node conversation-logger/cleanup-old-logs.js)"
fi
echo ""
```

## Required Files in conversation-logger/

Ensure these files exist in the VERITAS conversation-logger directory:
1. `index.js` - Main MCP server
2. `cleanup-old-logs.js` - Cleanup script with 5-day retention
3. `package.json` - Dependencies
4. `README.md` or `SETUP_GUIDE.md` - Documentation

## Update VERITAS README.md

Add this section:

```markdown
### Conversation Preservation

The system includes automatic conversation logging with 5-day retention:

- **Automatic Logging**: Research conversations are preserved automatically
- **Journal Generation**: Create comprehensive daily journals with `"Create journal entry for [date]"`
- **5-Day History**: Rolling window maintains last 5 days of conversations
- **Privacy**: All data stored locally in `~/.conversation-logger/`
- **Automatic Cleanup**: Optional 2 AM daily cleanup of old logs

To generate a journal:
- "Create journal entry for today"
- "Create journal entry for yesterday"
- "Generate weekly research summary"

Database location: `~/.conversation-logger/conversations.db`
Manual cleanup: `node conversation-logger/cleanup-old-logs.js`
```