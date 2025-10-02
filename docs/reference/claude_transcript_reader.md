# Claude Transcript Reader MCP - Documentation

## Overview

The Claude Transcript Reader MCP provides access to Claude Code's built-in conversation logging system. Unlike the deprecated conversation-logger daemon, this MCP reads Claude Code's native JSONL transcript files without requiring a background process.

**Replaces**: conversation-logger (deprecated)

**Key Difference**: Claude Code automatically logs all conversations to JSONL files in `~/.claude/projects/`. This MCP provides tools to read and analyze those files, eliminating the need for a custom logging daemon.

---

## How It Works

### Claude Code's Built-in Logging

Claude Code automatically saves every conversation as a JSONL file:

- **Location**: `~/.claude/projects/[project-name]/`
- **Format**: One JSON object per line, each representing a message
- **Naming**: Project paths with `/` and `_` replaced by `-`
- **Example**: `/Users/vmwm/VM_F31_2025` becomes `-Users-vmwm-VM-F31-2025`

### The MCP's Role

The claude-transcript-reader MCP:
1. Reads JSONL files from `~/.claude/projects/`
2. Handles path conversion (slashes and underscores to hyphens)
3. Provides tools for searching, stats, and journal generation
4. Respects 5-day retention window

---

## Architecture

### System Components

```
~/VERITAS/claude-transcript-reader/
├── index.js                          # Main MCP server
├── cleanup-old-transcripts.sh        # Retention script
├── install-cleanup.sh                # Installation script
├── com.veritas.transcript-cleanup.plist  # LaunchAgent
└── package.json                      # Metadata

~/.claude/projects/
└── -Users-vmwm-...-VM-F31-2025/     # Project directory
    ├── session-uuid-1.jsonl         # Conversation 1
    ├── session-uuid-2.jsonl         # Conversation 2
    └── ...
```

### Data Flow

```
User Message → Claude Code → JSONL File (automatic)
                                ↓
Claude Transcript Reader MCP → Read JSONL
                                ↓
              Generate Journal / Stats / Search Results
```

---

## Installation

### Prerequisites

- Node.js v16+ (no npm dependencies needed)
- Claude Code (any version with JSONL logging)
- macOS or Linux for cleanup script

### Installation Steps

1. **MCP Server** (already installed with VERITAS)
   ```bash
   # No dependencies to install
   # Just configure in Claude Desktop or ~/.claude.json
   ```

2. **Cleanup Script** (optional but recommended)
   ```bash
   cd ~/VERITAS/claude-transcript-reader
   ./install-cleanup.sh
   ```

   This installs a LaunchAgent that runs daily at 2 AM to delete transcripts older than 5 days.

### Configuration

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "claude-transcript-reader": {
      "command": "node",
      "args": ["/Users/YOU/VERITAS/claude-transcript-reader/index.js"]
    }
  }
}
```

**VS Code** (`~/.claude.json`):
```json
{
  "projects": {
    "/path/to/your/project": {
      "mcpServers": {
        "claude-transcript-reader": {
          "command": "node",
          "args": ["/Users/YOU/VERITAS/claude-transcript-reader/index.js"]
        }
      }
    }
  }
}
```

---

## MCP Tools Reference

### generate_journal

Generates a daily journal entry from conversation transcripts.

**Parameters**:
```javascript
{
  projectPath?: string,  // Optional: defaults to current directory
  date?: string          // Optional: YYYY-MM-DD format, defaults to today
}
```

**Returns**: Formatted journal entry with session summaries, tools used, and message counts.

**Example**:
```javascript
// Generate today's journal
await generate_journal();

// Generate for specific date
await generate_journal({ date: "2025-10-01" });
```

### get_session_stats

Retrieves statistics about recent sessions.

**Parameters**:
```javascript
{
  projectPath?: string  // Optional: defaults to current directory
}
```

**Returns**:
```javascript
{
  sessionCount: 2,
  totalMessages: 4074,
  oldestSession: {
    sessionId: "uuid",
    timestamp: "2025-10-01T14:39:07.861Z",
    messageCount: 2911
  },
  newestSession: {
    sessionId: "uuid",
    timestamp: "2025-10-01T12:51:07.316Z",
    messageCount: 1163
  }
}
```

### search_conversations

Searches through conversation transcripts.

**Parameters**:
```javascript
{
  query: string,         // Required: search term
  projectPath?: string,  // Optional: defaults to current directory
  daysAgo?: number      // Optional: defaults to 5
}
```

**Returns**:
```javascript
{
  query: "search term",
  resultCount: 4,
  results: [
    {
      sessionId: "uuid",
      messageIndex: 1094,
      role: "user",
      content: "message content...",
      timestamp: "2025-10-01T22:26:21.815Z"
    }
  ]
}
```

---

## Usage Examples

### Basic Journal Generation

Ask Claude in conversation:
```
"Generate a journal entry for today"
```

Claude will use the `generate_journal` tool and return a formatted summary.

### Check Session Stats

```
"Get session stats for this project"
```

Returns session count, message counts, and date ranges.

### Search Conversations

```
"Search conversations for 'transcript reader'"
```

Finds all mentions of the search term in recent transcripts.

---

## Journal Format

The generated journal includes:

```markdown
# Journal Entry: 2025-10-02

## Sessions
- Session 1: X messages at [time]
- Session 2: Y messages at [time]

## Summary
[Number] conversation(s) with [total] messages.
Tools used: [list of tools]

## Conversations
### Session [uuid]
Timestamp: [ISO timestamp]
Messages: [count]
Preview: [first 200 chars of first message]
```

---

## Cleanup System

### Automatic Cleanup

The LaunchAgent runs daily at 2 AM:
```bash
# Deletes files older than 5 days
find ~/.claude/projects -name "*.jsonl" -type f -mtime +5 -delete
```

### Manual Cleanup

```bash
# Run cleanup script manually
~/VERITAS/claude-transcript-reader/cleanup-old-transcripts.sh

# Check LaunchAgent status
launchctl list | grep transcript-cleanup
```

### Uninstall Cleanup

```bash
launchctl unload ~/Library/LaunchAgents/com.veritas.transcript-cleanup.plist
rm ~/Library/LaunchAgents/com.veritas.transcript-cleanup.plist
```

---

## Troubleshooting

### No Sessions Found

**Symptom**: `sessionCount: 0` when you know you've had conversations

**Cause**: Path conversion issue (underscores not converted to hyphens)

**Solution**: Update to latest version:
```bash
cd ~/VERITAS && git pull
```

### MCP Not Connecting

**Symptom**: "claude-transcript-reader disconnected"

**Solutions**:
1. Check path in config is correct
2. Restart Claude Desktop or reload VS Code window
3. Verify `index.js` exists at the specified path

### Transcripts Not Found

**Symptom**: Tools work but return no data

**Check**:
```bash
ls ~/.claude/projects/*/
```

Should show `.jsonl` files. If empty, you haven't had any conversations yet in that project.

---

## Migration from conversation-logger

If you're upgrading from the old conversation-logger:

### What Changed

| Old System | New System |
|------------|------------|
| SQLite database | JSONL files (built-in) |
| Background daemon | No daemon needed |
| Custom logging | Claude Code handles it |
| `~/.conversation-logger/` | `~/.claude/projects/` |

### Migration Steps

1. **Uninstall old daemon**:
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.veritas.conversation-watcher.plist
   rm ~/Library/LaunchAgents/com.veritas.conversation-watcher.plist
   ```

2. **Update configs** to use `claude-transcript-reader` instead of `conversation-logger`

3. **Install new cleanup script**:
   ```bash
   cd ~/VERITAS/claude-transcript-reader
   ./install-cleanup.sh
   ```

4. **Optional**: Archive old database:
   ```bash
   mv ~/.conversation-logger ~/conversation-logger-archive
   ```

---

## Comparison: Old vs New

### conversation-logger (Deprecated)

- ❌ Required background daemon
- ❌ Used SQLite database
- ❌ Monitored `~/.claude.json` (wrong file)
- ❌ Never actually logged conversations
- ❌ npm dependencies needed

### claude-transcript-reader (Current)

- ✅ No daemon needed
- ✅ Reads native JSONL files
- ✅ Uses Claude Code's built-in logging
- ✅ Actually works
- ✅ No dependencies

---

## Best Practices

1. **Daily Journals**: Generate journals at end of each work day
2. **Retention**: Default 5-day window is usually sufficient
3. **Backups**: If archiving important conversations, copy JSONL files elsewhere
4. **Search**: Use specific search terms for better results

---

## Future Enhancements

Planned features:
- Weekly/monthly aggregated reports
- Export to various formats (PDF, HTML)
- Integration with Memory MCP for combined output
- Advanced search with regex support

---

## Support

- **GitHub Issues**: https://github.com/VMWM/VERITAS/issues
- **Documentation**: VERITAS docs directory
- **Reference**: This file

---

*Last updated: October 2025*
*Version: 1.0.0*
