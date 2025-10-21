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
5. **Claude Transcript Reader** - Session tracking and journal generation

### Automatic Conversation Logging

Claude Code automatically logs all conversations to JSONL files in `~/.claude/projects/`. The transcript reader MCP server provides tools to access this data.

**Install the cleanup script (one-time setup)**:
```bash
cd ~/VERITAS/claude-transcript-reader
./install-cleanup.sh
```

This installs a macOS LaunchAgent that:
- Runs daily at 2 AM
- Deletes JSONL files older than 5 days
- Maintains 5-day retention window
- Auto-starts on schedule

**No daemon needed!** Claude Code handles logging automatically. The cleanup script only manages retention.

**MCP Configuration**:
- **VS Code Extension**: Transcript reader MCP is automatically available (no configuration needed)
- **Claude Desktop**: Requires manual MCP server configuration in `claude_desktop_config.json`

### Optional Components

- **Obsidian Integration** - If you use Obsidian for research notes (see [Configuration Guide](configuration-guide.md))

## Verification

After installation, verify everything works:

1. **Verify CLAUDE.md is loaded**
   ```
   Start a new conversation and ask:
   "What is your role according to CLAUDE.md?"
   ```
   Claude should respond with awareness of VERITAS rules

2. **Run Functional Tests**
   ```bash
   cat ~/VERITAS/tests/veritas-functional-test.md
   ```
   Follow the test prompts in a new Claude Code conversation

3. **Test Core Features**
   Try these commands in Claude Code:
   - "Search PubMed for papers on [your topic]" (tests PubMed MCP)
   - "Remember that [fact]" (tests Memory MCP)
   - "Generate a journal for today" (tests Transcript Reader)

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
# CLAUDE.md auto-loads when you open your project
# Transcript cleanup runs automatically at 2 AM daily
# No manual intervention needed
```

### File Locations

#### Your Project
- `CLAUDE.md` - Constitutional rules (project root)
- `.claude/agents/` - Domain expert files
- `.claude/templates/` - Note templates
- `.claude/commands/` - Slash commands (optional)
- `.claude/scripts/` - Utility scripts

#### System Files
- `~/Library/Application Support/Claude/claude_desktop_config.json` - Desktop MCP config (if using Desktop)
- `~/.claude/projects/` - JSONL transcript files (automatic, managed by Claude Code)
- `~/Library/LaunchAgents/` - Cleanup script (runs at 2 AM daily)

#### Obsidian (if configured)
- Vault structure defined in your domain expert
- Local REST API plugin required
- HTTPS must be enabled

### MCP Servers

| Server | Purpose | Test Command |
|--------|---------|--------------|
| claude-transcript-reader | Session tracking | "Generate today's journal" |
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
| "MCP server not found" | VS Code: MCP servers auto-available. Desktop: Check config |
| "Cannot connect to vault" | Check Obsidian Local REST API plugin is running |
| "No PMIDs found" | Use broader search terms |
| "Memory not saving" | Memory MCP is built-in for VS Code extension |
| "CLAUDE.md not recognized" | Ensure file is in project root |

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

### Claude Transcript Reader (Custom)
```bash
# No installation needed - MCP server has no dependencies
# Just install the cleanup script:
cd claude-transcript-reader
./install-cleanup.sh
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
    "claude-transcript-reader": {
      "command": "node",
      "args": ["/path/to/VERITAS/claude-transcript-reader/index.js"]
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
        "claude-transcript-reader": {
          "command": "node",
          "args": ["/Users/YOU/VERITAS/claude-transcript-reader/index.js"]
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

### Optional: Auto-Approve MCP Tools

By default, Claude Code asks for permission each time it wants to use an MCP tool. To skip these prompts and auto-approve VERITAS tools, add both `allowedTools` and `autoApprove` arrays to your project configuration in `~/.claude.json`:

```json
{
  "projects": {
    "/path/to/your/project": {
      "allowedTools": [
        "mcp__sequential-thinking__*",
        "mcp__memory__*",
        "mcp__claude-transcript-reader__*",
        "mcp__pubmed-ncukondo__*",
        "mcp__obsidian-rest-hla__*",
        "mcp__obsidian-rest-research-journal__*",
        "mcp__filesystem-local__*"
      ],
      "autoApprove": [
        "mcp__sequential-thinking__*",
        "mcp__memory__*",
        "mcp__claude-transcript-reader__*",
        "mcp__pubmed-ncukondo__*",
        "mcp__obsidian-rest-hla__*",
        "mcp__obsidian-rest-research-journal__*",
        "mcp__filesystem-local__*"
      ],
      "mcpServers": {
        // ... your MCP server configuration
      }
    }
  }
}
```

The wildcard `*` approves all tools from each MCP server. For more granular control, specify individual tools like `mcp__memory__read_graph` instead.

**Note**: Some versions of Claude Code require both `allowedTools` (granted permissions) and `autoApprove` (skip prompts) to work properly.

**After adding**: Reload VS Code window for changes to take effect (Cmd+Shift+P → "Developer: Reload Window").

## Common Installation Issues

**MCP not connecting in Desktop**: Restart Claude Desktop after configuration changes

**`/mcp` shows no servers in VS Code**: MCP servers must be configured per-project in `~/.claude.json`. Check that your project path matches exactly and reload VS Code window.

**MCP servers work in Desktop but not VS Code**: These are separate configurations. Desktop uses `claude_desktop_config.json`, VS Code uses `~/.claude.json` with per-project settings.

**Permission errors**: Ensure you have write permissions to home directory

**npm/node issues**: Update to Node.js 16+ and npm 8+

**Transcript reader not working**: Update VERITAS repo with `cd ~/VERITAS && git pull`

## Getting Help

1. Try functional tests: `tests/veritas-functional-test.md`
2. Check troubleshooting: `docs/troubleshooting.md`
3. Open GitHub issue: https://github.com/VMWM/VERITAS/issues

For detailed troubleshooting, see [Troubleshooting Guide](troubleshooting.md).