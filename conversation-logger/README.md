# Conversation Logger MCP Server

A custom Model Context Protocol (MCP) server that provides persistent conversation logging, session tracking, and journal generation capabilities for Claude Desktop and Claude CLI.

## Why This Server is Special

Unlike other MCP servers used by VERITAS (pubmed, memory, sequential-thinking, etc. which run via `npx`), conversation-logger is:

1. **Custom-built for VERITAS** - Not available on npm registry, developed specifically for research integrity
2. **Runs as a shared service** - One instance serves all your VERITAS projects
3. **Lives in VERITAS root** - Not copied to individual projects during setup
4. **Requires manual configuration** - Must be added to Claude Desktop settings with absolute path
5. **Stateful with database** - Maintains SQLite database of all conversations

### Key Architecture Difference

```
VERITAS/
├── conversation-logger/    # RUNS FROM HERE (shared service)
│   ├── index.js           # Server stays here
│   └── data/              # Database stays here
└── install/               # COPIED TO PROJECTS
    ├── hooks/             # Copied to each project
    └── templates/         # Copied to each project
```

**Important**: This server is NOT in `/install/` because it's not meant to be copied. It runs as a centralized service from the VERITAS directory, similar to how a database server works.

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

### Manual Logging
The conversation logger provides MCP tools that you must explicitly invoke to log conversations. While the MCP server runs automatically in the background, logging requires manual tool calls:

- Ask Claude to "log this conversation"
- Request "log this message to the conversation database"
- Use specific tool calls like `log_message` or `log_activity`

**Note**: The `auto-conversation-logger.py` hook exists but cannot automatically call MCP tools due to Claude Code hook limitations. Logging must be explicitly requested.

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