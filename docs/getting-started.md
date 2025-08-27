# Getting Started with VERITAS

VERITAS (Verification-Enforced Research Infrastructure with Tracking and Automated Structuring) is a comprehensive research framework that enforces citation standards and automates documentation workflows.

## Quick Installation

1. **Clone and Setup**
   ```bash
   git clone https://github.com/VMWM/VERITAS.git
   cd VERITAS
   ./setup.sh
   ```

2. **Test Installation**
   ```bash
   # Start a new Claude Code conversation and try:
   "Help me test the VERITAS installation"
   ```

That's it! The setup script handles all MCP server installation and configuration automatically.

## What Gets Installed

### Core MCP Servers

VERITAS installs these essential MCP servers:

1. **Sequential Thinking** - Problem breakdown and planning
2. **PubMed** - Literature search and citation verification
3. **Memory** - Knowledge graph and entity management
4. **Filesystem** - Local file access for your project
5. **Conversation Logger** - Session tracking and journal generation

### Optional Components

- **Obsidian Integration** - If you use Obsidian for research notes (see [Obsidian Integration](obsidian-integration.md))

## Verification

After installation, verify everything works:

1. **Check MCP Connections**
   ```bash
   claude mcp list
   ```
   You should see all servers listed as "Connected"

2. **Run Functional Tests**
   Open the functional test guide:
   ```bash
   cat tests/veritas-functional-test.md
   ```
   Follow the test prompts in a new Claude Code conversation

3. **Test Core Features**
   Try these commands in Claude Code:
   - "Help me plan a research task" (tests Sequential Thinking)
   - "Search PubMed for a recent paper on [your topic]" (tests PubMed)
   - "Generate a journal for today" (tests Conversation Logger)

## Next Steps

- **For Research Use**: Start with [Customization Guide](customization.md) to adapt VERITAS for your domain
- **For Obsidian Users**: Set up [Obsidian Integration](obsidian-integration.md)
- **Having Issues**: Check the [Troubleshooting Guide](troubleshooting.md)

## Manual Installation (If Needed)

If the automatic setup fails, you can install components manually:

### Sequential Thinking MCP
```bash
npx @modelcontextprotocol/install sequentialthinking
```

### PubMed MCP
```bash
npm install -g @cyanheads/pubmed-mcp-server
```

### Memory MCP
```bash
npx @modelcontextprotocol/install memory
```

### Filesystem MCP
```bash
npx @modelcontextprotocol/install filesystem
```

### Conversation Logger (Custom)
```bash
cd conversation-logger
npm install
```

## Claude Desktop Configuration

The setup script automatically configures Claude Desktop, but if you need to do it manually, add this to your Claude Desktop config:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed": {
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
      "args": ["@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    },
    "conversation-logger": {
      "command": "node",
      "args": ["/path/to/VERITAS/conversation-logger/index.js"]
    }
  }
}
```

## Common Installation Issues

**MCP not connecting**: Restart Claude Desktop after configuration changes

**Permission errors**: Ensure you have write permissions to home directory

**npm/node issues**: Update to Node.js 16+ and npm 8+

**Missing dependencies**: Run `npm install` in the conversation-logger directory

For detailed troubleshooting, see [Troubleshooting Guide](troubleshooting.md).