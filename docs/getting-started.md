# Getting Started with VERITAS

VERITAS (Verification-Enforced Research Infrastructure with Tracking and Automated Structuring) is a comprehensive research framework that enforces citation standards and automates documentation workflows.

## Quick Installation

1. **Clone and Setup**
   ```bash
   git clone https://github.com/VMWM/VERITAS.git
   cd VERITAS
   ./install/scripts/setup.sh
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

- **Obsidian Integration** - If you use Obsidian for research notes (see [Configuration Guide](configuration-guide.md))

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

## Quick Reference

### Essential Commands

#### Installation
```bash
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
./install/scripts/setup.sh
./install/scripts/configure-claude.sh
```

#### Testing
```bash
# Use prompts from tests/veritas-functional-test.md
# Start a Claude conversation and try each test prompt
```

#### Daily Operations
```bash
# Hooks auto-load when Claude runs in project directory
# Conversation-logger auto-cleans logs older than 5 days
```

### File Locations

#### Your Project
- `CLAUDE.md` - Constitutional rules (project root)
- `.claude/agents/` - Domain expert files
- `.claude/hooks/` - Validation hooks
- `.claude/logs/` - Validation logs

#### System Files
- `~/.claude.json` - Claude CLI configuration
- `~/Library/Application Support/Claude/claude_desktop_config.json` - Desktop config
- `~/.conversation-logger/` - Conversation database

#### Obsidian (if configured)
- Vault structure defined in your domain expert
- Local REST API plugin required
- HTTPS must be enabled

### MCP Servers

| Server | Purpose | Test Command |
|--------|---------|--------------|
| conversation-logger | Session tracking | "Generate today's journal" |
| filesystem-local | File access | "List my project files" |
| memory | Knowledge graph | "Remember that..." |
| pubmed | Citation search | "Find papers about..." |
| sequential-thinking | Problem solving | "Plan a research review..." |
| obsidian-rest-* | Vault access | "List my vault notes" |

### Environment Variables

#### Required for Obsidian
```bash
OBSIDIAN_API_TOKEN_[VAULT]  # API token for each vault
OBSIDIAN_BASE_URL           # https://127.0.0.1:[port]
OBSIDIAN_VERIFY_SSL         # false (for self-signed)
```

#### Optional
```bash
MCP_LOG_LEVEL              # error, warn, info, debug
NODE_ENV                   # production, development
```

### Common Tasks

#### Add New Obsidian Vault
1. Configure Local REST API plugin
2. Run `./scripts/setup/configure-claude.sh`
3. Choose merge option
4. Add vault configuration
5. Restart Claude

#### Switch Domain Expert
1. Edit `.claude/agents/[your-expert].md`
2. Update CLAUDE.md Article 2 reference
3. Restart Claude conversation

#### Debug MCP Server
```bash
# Check if running
ps aux | grep [server-name]

# View configuration
jq '.mcpServers."[server-name]"' ~/.claude.json

# Test directly
npx @modelcontextprotocol/[server-name]
```

#### Update VERITAS
```bash
cd VERITAS
git pull origin main
npm update -g  # Update global packages if needed
```

### Troubleshooting Quick Fixes

| Issue | Fix |
|-------|-----|
| "MCP server not found" | Restart Claude |
| "Cannot connect to vault" | Check Obsidian plugin is running |
| "No PMIDs found" | Use broader search terms |
| "Memory not saving" | Check memory MCP in config |
| "Hooks not running" | Make hooks executable: `chmod +x` |

## Next Steps

- **For Research Use**: Continue with [Configuration Guide](configuration-guide.md) to adapt VERITAS for your domain
- **Having Issues**: Check the [Troubleshooting Guide](troubleshooting.md)
- **Technical Details**: See [reference documentation](reference/)

## Manual Installation (If Needed)

If the automatic setup fails, you can install components manually:

### Sequential Thinking MCP
```bash
npx @modelcontextprotocol/install sequentialthinking
```

### PubMed MCP
```bash
npm install -g @ncukondo/pubmed-mcp
```
Note: Requires NCBI email and API key. See [SETUP_PUBMED.md](SETUP_PUBMED.md) for details.

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

## MCP Server Configuration

VERITAS MCP servers need to be configured in two places depending on where you use Claude Code:

### Claude Desktop Configuration

Location: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

The setup script automatically configures Claude Desktop, but if you need to do it manually, add this:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed": {
      "command": "npx",
      "args": ["@ncukondo/pubmed-mcp"],
      "env": {
        "PUBMED_EMAIL": "your-email@example.com",
        "PUBMED_API_KEY": "your-ncbi-api-key",
        "PUBMED_CACHE_DIR": "/tmp/pubmed-cache",
        "PUBMED_CACHE_TTL": "86400"
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

### Claude Code (VS Code Extension) Configuration

Location: `~/.claude.json` (per-project configuration)

Claude Code in VS Code uses a **per-project** configuration system. MCP servers are configured inside the project object:

```json
{
  "projects": {
    "/path/to/your/project": {
      "mcpServers": {
        "conversation-logger": {
          "command": "node",
          "args": ["/Users/YOU/VERITAS/conversation-logger/index.js"]
        },
        "sequential-thinking": {
          "command": "npx",
          "args": ["@modelcontextprotocol/server-sequential-thinking"]
        },
        "memory": {
          "command": "npx",
          "args": ["@modelcontextprotocol/server-memory"]
        },
        "filesystem-local": {
          "command": "npx",
          "args": ["@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
        },
        "pubmed-ncukondo": {
          "command": "node",
          "args": ["/Users/YOU/VERITAS/install/mcp-wrappers/pubmed-wrapper.js"],
          "env": {
            "PUBMED_EMAIL": "your-email@example.com",
            "PUBMED_API_KEY": "your-ncbi-api-key",
            "PUBMED_CACHE_DIR": "/tmp/pubmed-cache",
            "PUBMED_CACHE_TTL": "86400"
          }
        },
        "obsidian-rest-vault": {
          "command": "npx",
          "args": ["obsidian-mcp-server"],
          "env": {
            "OBSIDIAN_API_KEY": "your-api-key",
            "OBSIDIAN_BASE_URL": "https://127.0.0.1:27124",
            "OBSIDIAN_VERIFY_SSL": "false",
            "OBSIDIAN_ENABLE_CACHE": "true"
          }
        }
      }
    }
  }
}
```

**Important**: After editing `~/.claude.json`, reload VS Code window (Cmd+Shift+P → "Developer: Reload Window")

## Common Installation Issues

**MCP not connecting in Desktop**: Restart Claude Desktop after configuration changes

**`/mcp` shows no servers in VS Code**: MCP servers must be configured per-project in `~/.claude.json`. Check that your project path matches exactly and reload VS Code window.

**MCP servers work in Desktop but not VS Code**: These are separate configurations. Desktop uses `claude_desktop_config.json`, VS Code uses `~/.claude.json` with per-project settings.

**Permission errors**: Ensure you have write permissions to home directory

**npm/node issues**: Update to Node.js 16+ and npm 8+

**Missing dependencies**: Run `npm install` in the conversation-logger directory

## Getting Help

1. Try functional tests: `tests/veritas-functional-test.md`
2. Check troubleshooting: `docs/troubleshooting.md`
3. Open GitHub issue: https://github.com/VMWM/VERITAS/issues

For detailed troubleshooting, see [Troubleshooting Guide](troubleshooting.md).