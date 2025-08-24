# Configuration Guide

This guide explains all configuration options for VERITAS.

## Automated Configuration

The easiest way to configure VERITAS is using the interactive wizard:

```bash
./scripts/configure-claude.sh
```

## Configuration Options

### 1. Merge vs Replace Strategy

When running the configuration script, you'll be asked how to handle existing configurations:

- **Merge** (recommended): Adds VERITAS servers to your existing configuration
- **Replace**: Creates a fresh configuration (backs up existing)
- **Preview**: Shows what will be added without making changes

### 2. Configuration Management

Choose how to manage your Claude configurations:

#### Separate Configurations (Default)
- Desktop and CLI have independent configuration files
- Changes must be made to each file separately
- Best for: Single machine setups, users who prefer isolation

#### Symlinked Configurations
- Both Desktop and CLI use the same configuration file
- Changes to one automatically affect the other
- The CLI config (~/.claude.json) becomes the master file
- Best for: Users who want perfect Desktop/CLI synchronization

## Configuration Files

### Claude Desktop
- **Location**: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)
- **Location**: `~/.config/Claude/claude_desktop_config.json` (Linux)

### Claude CLI
- **Location**: `~/.claude.json`

### Project Configuration
- **Location**: `[project]/.mcp.json`
- Usually symlinked to CLI config for consistency

## MCP Server Configuration

Each MCP server requires specific configuration:

### Conversation Logger
```json
"conversation-logger": {
  "command": "node",
  "args": ["/path/to/VERITAS/conversation-logger/index.js"],
  "env": {
    "NODE_ENV": "production"
  }
}
```

### PubMed (Fixed for JSON parsing issues)
```json
"pubmed": {
  "command": "npx",
  "args": ["@cyanheads/pubmed-mcp-server"],
  "env": {
    "MCP_TRANSPORT_TYPE": "stdio",
    "MCP_LOG_LEVEL": "error",
    "NODE_ENV": "production"
  }
}
```

### Obsidian REST API
```json
"obsidian-rest-primary": {
  "command": "npx",
  "args": ["obsidian-mcp-server"],
  "env": {
    "OBSIDIAN_API_KEY": "your-api-key",
    "OBSIDIAN_BASE_URL": "https://127.0.0.1:27124",
    "OBSIDIAN_VERIFY_SSL": "false",
    "OBSIDIAN_ENABLE_CACHE": "true"
  }
}
```

## Environment Variables

Optional environment variables for advanced configuration:

```bash
# Obsidian settings
export OBSIDIAN_TOKEN="your-bearer-token"
export OBSIDIAN_PRIMARY_PORT="27124"
export OBSIDIAN_JOURNAL_PORT="27125"

# Project settings
export PROJECT_ROOT="/path/to/project"
export VERITAS_DIR="/path/to/VERITAS"
```

## Manual Configuration

If you prefer manual configuration:

1. Copy the example from `templates/config/`
2. Update paths and API keys
3. Place in appropriate location
4. Restart Claude

### Example Manual Setup

```bash
# Copy template
cp templates/config/claude-desktop.example.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Edit with your settings
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Restart Claude Desktop
```

## Backup and Recovery

The configuration script automatically creates backups:

```bash
# Backups are named with timestamps
claude_desktop_config.json.backup.20250824-143022

# Restore a backup
cp ~/.claude.json.backup.20250824-143022 ~/.claude.json
```

## Validation

To validate your configuration:

```bash
# Check JSON syntax
cat ~/.claude.json | python3 -m json.tool

# Test in Claude
claude
> /mcp  # Should list all configured servers
```

## Advanced: Multi-Machine Sync

For synchronizing across multiple machines, see [MULTI_MACHINE.md](MULTI_MACHINE.md).

## Templates

Example configurations are available in:
- `templates/config/claude-desktop.example.json`
- `templates/config/claude-cli.example.json`

## Troubleshooting Configuration

### Common Issues

**Invalid JSON error**
- Remove all comments from JSON files
- Check for trailing commas
- Validate with: `python3 -m json.tool < config.json`

**Servers not appearing**
- Restart Claude completely
- Check file permissions
- Verify paths are absolute, not relative

**API key issues**
- Ensure keys are in quotes
- Check for special characters
- Verify Obsidian REST API is enabled

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for more solutions.