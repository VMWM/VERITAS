# Conversation Logger MCP Server

A Model Context Protocol (MCP) server that provides persistent conversation logging, session tracking, and journal generation capabilities for Claude Desktop and Claude CLI.

## Overview

The Conversation Logger captures and stores all conversations between users and Claude, enabling:
- Historical conversation retrieval
- Research journal generation from conversation database
- Session analytics and metrics
- Activity tracking and categorization
- Automatic database maintenance with configurable retention

## Features

### Core Capabilities
- **Persistent Storage**: SQLite database for reliable conversation history
- **Session Management**: Automatic session detection and segmentation
- **Activity Tracking**: Categorized logging of user intents and actions
- **Journal Generation**: Daily summaries generated from conversation data
- **Retention Management**: Configurable cleanup with automatic old log removal
- **Tool Integration**: Tracks which MCP tools were used in each conversation
- **File Tracking**: Records which files were modified during sessions

### MCP Tools Provided

The server exposes these tools to Claude:

| Tool | Description | Parameters |
|------|-------------|------------|
| `log_message` | Log a conversation message | `role`, `content`, `tools_used`, `files_modified` |
| `log_activity` | Track a specific activity | `activity_type`, `description`, `metadata` |
| `generate_journal` | Create a journal entry from session data | `date` (optional, defaults to today) |
| `get_session_stats` | Retrieve session statistics | None |
| `start_new_session` | Begin a new logging session | None |

## Installation

The Conversation Logger is automatically installed and configured when you run the main VERITAS setup:

```bash
# In your VERITAS directory
./setup.sh
./scripts/setup/configure-claude.sh
```

## Usage

### Automatic Logging
The conversation logger runs automatically in the background. Every conversation with Claude is logged to `~/.conversation-logger/conversations.db`.

### Generate Journal Entries
```
# In a Claude conversation
"Generate a journal entry for today's session"
```

### View Session Statistics
```
# In a Claude conversation  
"Show me my conversation session statistics"
```

### Manual Cleanup
```bash
# Clean old logs manually
node cleanup-old-logs.js
```

## Database Schema

The SQLite database includes these tables:

- **sessions**: Individual conversation sessions with metadata
- **messages**: Individual messages within sessions
- **activities**: Tracked activities and events

## Configuration

### Database Location
- Default: `~/.conversation-logger/conversations.db`
- Configurable via environment variables

### Retention Policy
- Default: 5 days
- Configured during setup.sh installation
- Automatic cleanup via cron job (if enabled)

## Files

```
conversation-logger/
├── index.js                     # Main MCP server
├── cleanup-old-logs.js          # Log retention management
├── package.json                 # Dependencies
└── README.md                    # This file
```

## Troubleshooting

### Database Issues
```bash
# Check if database exists
ls -la ~/.conversation-logger/

# Verify database structure
sqlite3 ~/.conversation-logger/conversations.db ".schema"
```

### MCP Server Issues
```bash
# Check if server is configured
jq '.mcpServers."conversation-logger"' ~/.claude.json

# Test server directly
node index.js
```

### Log Cleanup Issues
```bash
# Check cron jobs
crontab -l | grep conversation

# Run cleanup manually
node cleanup-old-logs.js
```

## Integration

The Conversation Logger integrates seamlessly with:
- **VERITAS**: Automatic setup and configuration
- **Claude Desktop/CLI**: Real-time conversation logging
- **Other MCP Servers**: Tool usage tracking
- **System Cron**: Automated log cleanup

## Privacy & Data

- All data stored locally in SQLite database
- No external network connections
- User controls retention period
- Database can be deleted anytime by removing `~/.conversation-logger/`

---

Part of the VERITAS research infrastructure system.