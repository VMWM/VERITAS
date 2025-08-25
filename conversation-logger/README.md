# Conversation Logger MCP Server

A Model Context Protocol (MCP) server that provides persistent conversation logging, session tracking, and journal generation capabilities for Claude Desktop and Claude CLI.

## Overview

The Conversation Logger MCP Server captures and stores all conversations between users and Claude, enabling:
- Historical conversation retrieval
- Research journal generation
- Session analytics and metrics
- Activity tracking and categorization
- Automatic database maintenance with configurable retention

## Features

### Core Capabilities
- **Persistent Storage**: SQLite database for reliable conversation history
- **Session Management**: Automatic session detection and segmentation
- **Activity Tracking**: Categorized logging of user intents and actions
- **Journal Generation**: Formatted daily summaries with customizable templates
- **Retention Management**: Configurable cleanup with 5-day default retention
- **Tool Integration**: Tracks which MCP tools were used in each conversation
- **File Tracking**: Records which files were modified during sessions

### MCP Tools Provided

The server exposes these tools to Claude:

| Tool | Description | Parameters |
|------|-------------|------------|
| `log_message` | Log a conversation message | `role`, `content`, `tools_used`, `files_modified` |
| `log_activity` | Track a specific activity | `activity_type`, `description`, `metadata` |
| `generate_journal` | Create a journal entry | `date` (optional, defaults to today) |
| `get_session_stats` | Retrieve session statistics | None |
| `start_new_session` | Begin a new logging session | None |

## Installation

### Prerequisites
- Node.js v16 or higher
- npm or yarn
- Claude Desktop or Claude CLI
- SQLite3 (usually pre-installed on most systems)

### Step 1: Install Dependencies

```bash
cd conversation-logger
npm install
```

### Step 2: Register with Claude

#### For Claude Desktop
Add to your Claude Desktop configuration (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

```json
{
  "mcpServers": {
    "conversation-logger": {
      "command": "node",
      "args": ["/path/to/conversation-logger/index.js"]
    }
  }
}
```

#### For Claude CLI
Add to your Claude CLI configuration (`~/.claude.json`):

```json
{
  "mcpServers": {
    "conversation-logger": {
      "command": "node",
      "args": ["/path/to/conversation-logger/index.js"]
    }
  }
}
```

### Step 3: Configure Retention (Optional)

Set up automatic cleanup for logs older than 5 days:

```bash
# Add to crontab for 2 AM daily cleanup
crontab -e
# Add this line:
0 2 * * * cd /path/to/conversation-logger && node cleanup-old-logs.js
```

Or run manually when needed:
```bash
node cleanup-old-logs.js
```

## Usage

### Basic Commands in Claude

Once installed, you can use these commands in your Claude conversations:

```text
# Generate a journal for today
"Generate a journal entry for today"

# Generate a journal for a specific date
"Create a journal entry for 2025-01-20"

# View session statistics
"Show me session statistics"

# Start a new session
"Start a new logging session"
```

### Command Line Utilities

The package includes command-line tools for direct interaction:

```bash
# Generate today's journal
node obsidian-journal-generator.js

# Generate journal for specific date
node obsidian-journal-generator.js 2025-01-20

# Clean up old logs manually
node cleanup-old-logs.js

# View database statistics
sqlite3 ~/.conversation-logger/conversations.db "SELECT COUNT(*) FROM messages;"
```

## Database Structure

### Location
Database is stored at: `~/.conversation-logger/conversations.db`

### Schema

#### sessions table
```sql
CREATE TABLE sessions (
    id TEXT PRIMARY KEY,
    start_time TEXT NOT NULL,
    end_time TEXT,
    project_path TEXT,
    summary TEXT
);
```

#### messages table
```sql
CREATE TABLE messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    tools_used TEXT,
    files_modified TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions(id)
);
```

#### activities table
```sql
CREATE TABLE activities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    activity_type TEXT NOT NULL,
    description TEXT,
    metadata TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions(id)
);
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CONVERSATION_DB_PATH` | Database location | `~/.conversation-logger/conversations.db` |
| `RETENTION_DAYS` | Days to keep logs | `5` |
| `OBSIDIAN_API_TOKEN` | Token for Obsidian integration | None |
| `OBSIDIAN_PORT` | Port for Obsidian REST API | `27125` |
| `JOURNAL_OUTPUT_DIR` | Directory for journal files | Current directory |

### Journal Templates

Customize journal output by modifying the template in `obsidian-journal-generator.js`:

```javascript
const journalTemplate = {
  sections: [
    'Session Summary',
    'Technical Implementations',
    'Problems Solved',
    'Key Insights',
    'Next Actions'
  ]
};
```

## API Reference

### MCP Server Protocol

The server implements the MCP protocol with these endpoints:

```javascript
// List available tools
POST /tools/list

// Execute a tool
POST /tools/call
{
  "name": "tool_name",
  "arguments": {}
}
```

### Direct Database Access

For advanced queries, access the SQLite database directly:

```javascript
const Database = require('sqlite3').verbose();
const db = new Database.Database('~/.conversation-logger/conversations.db');

// Query example
db.all("SELECT * FROM messages WHERE session_id = ?", [sessionId], (err, rows) => {
  console.log(rows);
});
```

## Troubleshooting

### Server Not Starting

1. Check Node.js version:
```bash
node --version  # Should be v16+
```

2. Verify installation:
```bash
cd conversation-logger
npm list
```

3. Check MCP registration:
```bash
# For CLI
cat ~/.claude.json | grep conversation-logger

# For Desktop (macOS)
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | grep conversation-logger
```

### Database Issues

1. Check database exists:
```bash
ls -la ~/.conversation-logger/
```

2. Verify database integrity:
```bash
sqlite3 ~/.conversation-logger/conversations.db "PRAGMA integrity_check;"
```

3. Reset database (WARNING: Deletes all history):
```bash
rm ~/.conversation-logger/conversations.db
# Restart Claude to recreate
```

### Journal Generation Problems

1. Test generation manually:
```bash
node obsidian-journal-generator.js
```

2. Check for errors:
```bash
node obsidian-journal-generator.js 2>&1 | grep -i error
```

3. Verify Obsidian integration:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:27125/vault/
```

## Development

### Running Tests
```bash
npm test
```

### Debug Mode
```bash
DEBUG=conversation-logger* node index.js
```

### Contributing
Pull requests welcome! Please ensure:
- Code follows existing style
- Tests pass
- Documentation is updated
- Database migrations are backward compatible

## Performance Considerations

- Database size grows ~1MB per 100 conversations
- Cleanup script reduces size by ~80% when run
- Journal generation takes <1 second for typical daily usage
- MCP overhead is minimal (<10ms per tool call)

## Security

- All data stored locally - no cloud transmission
- Database uses SQLite with default permissions
- No encryption by default (can be added via SQLCipher)
- API tokens should be kept secure

## License

MIT License - See LICENSE file for details

## Support

For issues, questions, or contributions:
- Open an issue in the repository
- Check existing documentation
- Review closed issues for common problems

## Version History

- **1.0.0** - Initial release with core logging
- **1.1.0** - Added retention management
- **1.2.0** - Obsidian integration support
- **1.3.0** - Session analytics and metrics