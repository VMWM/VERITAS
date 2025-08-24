#!/bin/bash

# Conversation Logger Configuration Script
# For manual configuration after main installation

set -e

echo "🔧 Conversation Logger Configuration"
echo "===================================="
echo ""
echo "This script configures the conversation logger MCP server"
echo "after it has been installed via the main setup.sh"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if already configured
if claude mcp list | grep -q "conversation-logger"; then
    echo -e "${YELLOW}Conversation logger is already configured in Claude.${NC}"
    echo "Would you like to reconfigure it? (y/n)"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Configuration cancelled."
        exit 0
    fi
    claude mcp remove conversation-logger
fi

# Configure MCP server
echo -e "${BLUE}Adding conversation logger to Claude configuration...${NC}"
claude mcp add-json conversation-logger '{
  "command": "node",
  "args": ["'$DIR'/index.js"],
  "env": {
    "NODE_ENV": "production"
  }
}' -s user

echo -e "${GREEN}✓ MCP server configured${NC}"

# Create helper scripts
echo -e "${BLUE}Creating helper scripts...${NC}"

# Ensure ~/bin exists
mkdir -p ~/bin

# Create journal generation script
cat > ~/bin/generate-journal << EOF
#!/bin/bash
# Generate journal for today or specified date

DATE=\${1:-\$(date +%Y-%m-%d)}
cd "$DIR"
node obsidian-journal-generator.js \$DATE \$2
EOF

chmod +x ~/bin/generate-journal

# Create session stats script
cat > ~/bin/session-stats << EOF
#!/bin/bash
# Show current session statistics

sqlite3 ~/.conversation-logger/conversations.db << SQL
.headers on
.mode column
SELECT 
  substr(id, 1, 8) as session_id,
  datetime(start_time) as started,
  project_path
FROM sessions 
WHERE date(start_time) = date('now')
ORDER BY start_time DESC;
SQL
EOF

chmod +x ~/bin/session-stats

echo -e "${GREEN}✓ Helper scripts created${NC}"

# Setup daily automation (optional)
echo ""
echo "Would you like to set up automatic daily journal generation? (y/n)"
read -r response
if [[ "$response" == "y" ]]; then
    (crontab -l 2>/dev/null | grep -v "generate-journal"; echo "0 23 * * * ~/bin/generate-journal --post") | crontab -
    echo -e "${GREEN}✓ Daily automation configured for 11 PM${NC}"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}✅ Configuration Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Available commands:"
echo -e "${YELLOW}  generate-journal${NC}     - Generate journal for today"
echo -e "${YELLOW}  generate-journal YYYY-MM-DD${NC} - Generate for specific date"
echo -e "${YELLOW}  session-stats${NC}        - View today's session statistics"
echo ""
echo "MCP Tools available in Claude:"
echo "  • log_message - Log conversation messages"
echo "  • log_activity - Log activities and events"
echo "  • generate_journal - Generate journal entries"
echo "  • get_session_stats - Get session statistics"
echo ""
echo -e "${BLUE}Restart Claude Code to activate changes.${NC}"