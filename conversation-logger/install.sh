#!/bin/bash

# Conversation Logger MCP Installation Script
# This script installs and configures the conversation logger system

set -e

echo "🚀 Installing Conversation Logger MCP Server..."
echo "============================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install dependencies
echo -e "${BLUE}Step 1: Installing dependencies...${NC}"
DIR="/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/conversation-logger"
cd "$DIR"
npm install

# Step 2: Make scripts executable
echo -e "${BLUE}Step 2: Making scripts executable...${NC}"
chmod +x index.js
chmod +x obsidian-journal-generator.js
chmod +x ~/.claude/hooks/conversation-logger-hook.js

# Step 3: Configure MCP server
echo -e "${BLUE}Step 3: Adding MCP server to Claude configuration...${NC}"
claude mcp add-json conversation-logger '{
  "command": "node",
  "args": ["'$(pwd)'/index.js"],
  "env": {
    "NODE_ENV": "production"
  }
}' -s user

echo -e "${GREEN}✓ MCP server configured${NC}"

# Step 4: Configure hooks
echo -e "${BLUE}Step 4: Setting up activity tracking hooks...${NC}"

# Create hook configuration
cat > ~/.claude/hooks/config.json << 'EOF'
{
  "conversation-logger": {
    "enabled": true,
    "events": ["user-prompt-submit", "tool-call", "file-modified"],
    "logPath": "~/.claude/hooks/activity.log"
  }
}
EOF

echo -e "${GREEN}✓ Hooks configured${NC}"

# Step 5: Create helper scripts
echo -e "${BLUE}Step 5: Creating helper scripts...${NC}"

# Create journal generation script
cat > ~/bin/generate-journal << 'EOF'
#!/bin/bash
# Generate journal for today or specified date

DATE=${1:-$(date +%Y-%m-%d)}
DIR="/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/conversation-logger"
cd "$DIR"
node obsidian-journal-generator.js $DATE $2
EOF

chmod +x ~/bin/generate-journal

# Create session stats script
cat > ~/bin/session-stats << 'EOF'
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

# Step 6: Create daily journal automation
echo -e "${BLUE}Step 6: Setting up daily journal automation...${NC}"

# Create cron job for automatic journal generation
(crontab -l 2>/dev/null; echo "0 23 * * * ~/bin/generate-journal --post") | crontab -

echo -e "${GREEN}✓ Daily automation configured${NC}"

# Step 7: Initialize database
echo -e "${BLUE}Step 7: Initializing conversation database...${NC}"
node -e "
const Database = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');
const os = require('os');

const dbDir = path.join(os.homedir(), '.conversation-logger');
fs.mkdirSync(dbDir, { recursive: true });

console.log('Database initialized at: ' + dbDir);
"

echo -e "${GREEN}✓ Database initialized${NC}"

# Final instructions
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Available commands:"
echo -e "${YELLOW}  generate-journal${NC}     - Generate journal for today"
echo -e "${YELLOW}  generate-journal YYYY-MM-DD${NC} - Generate journal for specific date"
echo -e "${YELLOW}  generate-journal YYYY-MM-DD --post${NC} - Generate and post to Obsidian"
echo -e "${YELLOW}  session-stats${NC}        - View today's session statistics"
echo ""
echo "MCP Tools available in Claude:"
echo "  • log_message - Log conversation messages"
echo "  • log_activity - Log activities and events"
echo "  • generate_journal - Generate journal entries"
echo "  • get_session_stats - Get session statistics"
echo "  • start_new_session - Start a new logging session"
echo ""
echo -e "${BLUE}Restart Claude Code to activate the conversation logger.${NC}"
echo ""