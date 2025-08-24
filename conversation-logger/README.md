# Conversation Logger MCP Server

A comprehensive conversation logging and journal generation system for Claude Code, providing MemoriPilot-like functionality.

**For complete documentation, see [docs/CONVERSATION_LOGGER.md](../docs/CONVERSATION_LOGGER.md)**

## Features

### Persistent Conversation Memory
- Logs all conversations between user and Claude
- Tracks tool usage and file modifications
- Maintains session context across Claude restarts
- Stores data in SQLite database for easy querying

### Activity Tracking
- Automatic activity logging via hooks
- User intent extraction and categorization
- Project-aware session management
- Timestamp-based activity correlation

### Journal Generation
- Comprehensive daily research logs
- Automatic topic extraction and summarization
- Metrics and statistics tracking
- Direct integration with Obsidian vaults

### MCP Tools
Available tools in Claude Code:
- `log_message` - Log conversation messages with context
- `log_activity` - Track specific activities and events
- `generate_journal` - Create formatted journal entries
- `get_session_stats` - View session statistics
- `start_new_session` - Begin a new logging session

## Installation

### Automatic Installation (Recommended)
The conversation logger is automatically installed when you run the main setup script from the repository root:
```bash
# From HLA_Agent-MCP_System directory
./setup.sh
```

### Manual Configuration (Optional)
For advanced configuration or reconfiguration after installation:
```bash
cd conversation-logger
./configure.sh
```

After installation, restart Claude Code to activate the MCP server.

## Usage

### In Claude Code

The conversation logger will automatically start tracking when Claude Code launches. You can use these commands:

```
# Generate today's journal
generate_journal

# Get session statistics
get_session_stats

# Log a specific activity
log_activity "implementation" "Created new MCP server"
```

### Command Line Tools

```bash
# Generate journal for today
generate-journal

# Generate journal for specific date
generate-journal 2025-01-24

# Generate and post to Obsidian
generate-journal --post

# View session statistics
session-stats
```

### Automatic Journal Generation

The system is configured to automatically generate and post journals to Obsidian daily at 11 PM.

## Architecture

```
conversation-logger/
├── index.js                    # Main MCP server
├── obsidian-journal-generator.js # Journal generation engine
├── package.json                # Dependencies
├── install.sh                  # Installation script
└── README.md                   # This file

~/.conversation-logger/
└── conversations.db            # SQLite database

~/.claude/hooks/
├── conversation-logger-hook.js # Activity tracking hook
└── activity.log               # Activity log file
```

## Database Schema

### Sessions Table
- `id` - Unique session identifier
- `start_time` - Session start timestamp
- `end_time` - Session end timestamp
- `project_path` - Working directory
- `summary` - Session summary

### Messages Table
- `id` - Message identifier
- `session_id` - Associated session
- `timestamp` - Message timestamp
- `role` - user/assistant/system
- `content` - Message content
- `tools_used` - JSON array of tools
- `files_modified` - JSON array of files

### Activities Table
- `id` - Activity identifier
- `session_id` - Associated session
- `timestamp` - Activity timestamp
- `activity_type` - Type of activity
- `description` - Activity description
- `metadata` - JSON metadata

## Journal Format

Generated journals follow your established format:
- Session Summary
- Technical Implementations
- Research Insights & Discoveries
- Problems Solved
- Session Metrics
- Next Actions
- References

## Configuration

### Obsidian Integration

Set your Obsidian API token:
```bash
export OBSIDIAN_API_TOKEN="your-token-here"
```

The journal generator posts to:
- Port: 27125 (Research Journal vault)
- Path: `/vault/Daily/YYYY-MM-DD.md`

### Hook Configuration

Edit `~/.claude/hooks/config.json` to customize:
```json
{
  "conversation-logger": {
    "enabled": true,
    "events": ["user-prompt-submit", "tool-call", "file-modified"],
    "logPath": "~/.claude/hooks/activity.log"
  }
}
```

## Troubleshooting

### MCP Server Not Connecting
```bash
# Check if server is registered
claude mcp list

# Re-add the server
claude mcp remove conversation-logger
./install.sh
```

### Database Issues
```bash
# Check database location
ls -la ~/.conversation-logger/

# View database contents
sqlite3 ~/.conversation-logger/conversations.db ".tables"
```

### Journal Not Generating
```bash
# Check for errors in manual generation
generate-journal 2>/dev/null

# View recent sessions
session-stats
```

## Future Enhancements

- [ ] Working modes (Research, Code, Debug)
- [ ] Advanced NLP for topic extraction
- [ ] Integration with Memory MCP
- [ ] Web UI for session browsing
- [ ] Export to multiple formats
- [ ] Team collaboration features

## License

MIT

## Contributing

Contributions welcome! This is an open-source project designed to enhance Claude Code's capabilities.

## Credits

Inspired by MemoriPilot for GitHub Copilot. Built for the Claude Code community.
