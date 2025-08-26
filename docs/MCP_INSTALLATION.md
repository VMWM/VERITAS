# MCP Server Installation Guide

This guide covers the installation and configuration of all MCP (Model Context Protocol) servers used by VERITAS.

## Required MCP Servers

VERITAS uses the following MCP servers:

1. **Sequential Thinking** - Problem breakdown and planning
2. **PubMed** - Medical literature search and citation
3. **Memory** - Knowledge graph and entity management
4. **Filesystem** - Local file access
5. **Conversation Logger** - Session tracking and journaling
6. **Obsidian REST** (optional) - Vault integration

## Automatic Installation

The `setup.sh` script automatically installs all MCP servers:

```bash
cd VERITAS
./setup.sh
```

## Manual Installation

If automatic installation fails, install each server manually:

### 1. Sequential Thinking MCP

```bash
npx @modelcontextprotocol/install sequentialthinking
```

**Purpose**: Helps Claude break down complex problems systematically
**Required**: Yes

### 2. PubMed MCP (Cyanheads Version)

```bash
npm install -g @cyanheads/pubmed-mcp-server
```

**Purpose**: PubMed search, article fetching, citation management
**Required**: Yes for research features
**Note**: We use the cyanheads fork to avoid debug output issues

### 3. Memory MCP

```bash
npx @modelcontextprotocol/install memory
```

**Purpose**: Knowledge graph, entity tracking, concept relationships
**Required**: Yes

### 4. Filesystem MCP

```bash
npx @modelcontextprotocol/install filesystem
```

**Purpose**: Read/write local files, project management
**Required**: Yes

### 5. Conversation Logger

```bash
cd conversation-logger
npm install
```

**Purpose**: Track conversations, generate daily journals
**Required**: Yes for logging features
**Database**: Created at `~/.conversation-logger/conversations.db`

### 6. Obsidian MCP Server (Optional)

```bash
npm install -g obsidian-mcp-server
```

**Purpose**: Direct integration with Obsidian vaults
**Required**: Only if using Obsidian features
**Prerequisite**: Obsidian Local REST API plugin

## Configuration

### Claude Desktop Configuration

After installation, add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed-cyanheads": {
      "command": "npx",
      "args": ["@cyanheads/pubmed-mcp-server"],
      "env": {
        "MCP_TRANSPORT_TYPE": "stdio",
        "MCP_LOG_LEVEL": "error",
        "NODE_ENV": "production"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "filesystem-local": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "conversation-logger": {
      "command": "node",
      "args": ["/path/to/VERITAS/conversation-logger/index.js"],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
```

### Claude CLI Configuration

Import servers from Desktop:

```bash
claude mcp add-from-claude-desktop
```

Or configure manually in `~/.claude.json`.

## Obsidian Configuration

If using Obsidian integration:

### 1. Install Obsidian Plugin

1. Open Obsidian
2. Settings ’ Community Plugins
3. Search "Local REST API"
4. Install and Enable

### 2. Configure Plugin

- **Enable Encrypted (HTTPS) Server**: ON
- **Enable Non-encrypted (HTTP) Server**: OFF
- **Port**: 27124 (main vault)
- **Port**: 27125 (journal vault)
- Generate and save bearer token

### 3. Add to MCP Configuration

```json
"obsidian-rest-hla": {
  "command": "npx",
  "args": ["obsidian-mcp-server"],
  "env": {
    "OBSIDIAN_API_KEY": "your-bearer-token",
    "OBSIDIAN_BASE_URL": "https://127.0.0.1:27124",
    "OBSIDIAN_VERIFY_SSL": "false",
    "OBSIDIAN_ENABLE_CACHE": "true"
  }
}
```

## Verification

### Check Installation

```bash
# List npm global packages
npm list -g --depth=0

# Check specific server
which npx
npx @modelcontextprotocol/server-sequentialthinking --version
```

### Test in Claude

1. Start new conversation
2. Run `/mcp` to see available servers
3. Test each server:

```
# Test Sequential Thinking
"Break down the problem of setting up VERITAS"

# Test PubMed
"Search PubMed for HLA antibodies"

# Test Memory
"Create an entity for 'VERITAS' with observations"

# Test Filesystem
"Read the CLAUDE.md file"

# Test Conversation Logger
"Generate a journal entry for today"
```

## Troubleshooting

### Server Not Found

```bash
# Reinstall the server
npx @modelcontextprotocol/install [server-name]

# Check node_modules
ls ~/.npm/_npx/*/node_modules/@modelcontextprotocol/
```

### Permission Errors

```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

### Server Crashes

Check logs:
- Claude Desktop: View ’ Developer Tools ’ Console
- CLI: Check terminal output
- Server logs: `~/.claude/logs/`

### Connection Issues

For Obsidian:
```bash
# Test connection
curl -k https://127.0.0.1:27124/vault/ \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Updating MCP Servers

```bash
# Update all npm packages
npm update -g

# Update specific server
npm install -g @cyanheads/pubmed-mcp-server@latest
```

## Uninstalling

```bash
# Remove global npm packages
npm uninstall -g @cyanheads/pubmed-mcp-server
npm uninstall -g obsidian-mcp-server

# Remove MCP installations
rm -rf ~/.npm/_npx/*/node_modules/@modelcontextprotocol/
```

## Advanced Configuration

### Custom Server Locations

You can install servers in project-specific locations:

```bash
cd ~/my-project
npm install @cyanheads/pubmed-mcp-server
```

Then reference in config:
```json
"pubmed": {
  "command": "node",
  "args": ["~/my-project/node_modules/@cyanheads/pubmed-mcp-server/index.js"]
}
```

### Environment Variables

Set in your shell profile:
```bash
export MCP_LOG_LEVEL=error
export NODE_ENV=production
```

## Getting Help

- Check server documentation on npm
- Review Claude MCP documentation
- Open issue at https://github.com/VMWM/VERITAS/issues