# VERITAS Quick Reference

## Essential Commands

### Installation
```bash
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
./setup.sh
./scripts/setup/configure-claude.sh
```

### Testing
```bash
# Use prompts from tests/veritas-functional-test.md
# Start a Claude conversation and try each test prompt
```

### Daily Operations
```bash
source [project]/.claude/env.sh      # Load environment
node conversation-logger/cleanup.js  # Manual log cleanup
```

## File Locations

### Your Project
- `CLAUDE.md` - Constitutional rules (project root)
- `.claude/agents/` - Domain expert files
- `.claude/hooks/` - Validation hooks
- `.claude/logs/` - Validation logs

### System Files
- `~/.claude.json` - Claude CLI configuration
- `~/Library/Application Support/Claude/claude_desktop_config.json` - Desktop config
- `~/.conversation-logger/` - Conversation database

### Obsidian (if configured)
- Vault structure defined in your domain expert
- Local REST API plugin required
- HTTPS must be enabled

## MCP Servers

| Server | Purpose | Test Command |
|--------|---------|--------------|
| conversation-logger | Session tracking | "Generate today's journal" |
| filesystem-local | File access | "List my project files" |
| memory | Knowledge graph | "Remember that..." |
| pubmed | Citation search | "Find papers about..." |
| sequential-thinking | Problem solving | "Plan a research review..." |
| obsidian-rest-* | Vault access | "List my vault notes" |

## Environment Variables

### Required for Obsidian
```bash
OBSIDIAN_API_TOKEN_[VAULT]  # API token for each vault
OBSIDIAN_BASE_URL           # https://127.0.0.1:[port]
OBSIDIAN_VERIFY_SSL         # false (for self-signed)
```

### Optional
```bash
MCP_LOG_LEVEL              # error, warn, info, debug
NODE_ENV                   # production, development
```

## Common Tasks

### Add New Obsidian Vault
1. Configure Local REST API plugin
2. Run `./scripts/setup/configure-claude.sh`
3. Choose merge option
4. Add vault configuration
5. Restart Claude

### Switch Domain Expert
1. Edit `.claude/agents/[your-expert].md`
2. Update CLAUDE.md Article 2 reference
3. Restart Claude conversation

### Debug MCP Server
```bash
# Check if running
ps aux | grep [server-name]

# View configuration
jq '.mcpServers."[server-name]"' ~/.claude.json

# Test directly
npx @modelcontextprotocol/[server-name]
```

### Update VERITAS
```bash
cd VERITAS
git pull origin main
npm update -g  # Update global packages if needed
```

## Troubleshooting Quick Fixes

| Issue | Fix |
|-------|-----|
| "MCP server not found" | Restart Claude |
| "Cannot connect to vault" | Check Obsidian plugin is running |
| "No PMIDs found" | Use broader search terms |
| "Memory not saving" | Check memory MCP in config |
| "Hooks not running" | Make hooks executable: `chmod +x` |

## Getting Help

1. Try functional tests: `tests/veritas-functional-test.md`
2. Check troubleshooting: `docs/TROUBLESHOOTING.md`
3. Open GitHub issue: https://github.com/VMWM/VERITAS/issues