# Troubleshooting Guide

Common issues and solutions for the Research Agent-MCP System.

## Quick Diagnosis Commands

Run these commands to quickly identify configuration issues:

```bash
# Check Claude Code CLI MCP servers
claude mcp list

# Test MCP availability in Claude
claude
> /mcp

# Check Claude Desktop config location and validity
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | python3 -m json.tool

# Check Claude Code config locations
ls -la ~/.claude/*.json

# Verify MCP server installations
npx @modelcontextprotocol/server-sequentialthinking --version
npx @cyanheads/pubmed-mcp-server --version
npx @modelcontextprotocol/server-memory --version

# Check for multiple Claude installations
which -a claude
```

## MCP Configuration Issues

### Claude Code CLI Shows "No MCP servers configured"
**Symptoms**: Running `/mcp` in Claude Code shows no servers, even after setup
**Solutions**:
1. Import from Claude Desktop:
   ```bash
   claude mcp add-from-claude-desktop
   ```
2. Verify import worked:
   ```bash
   claude mcp list
   ```
3. If still not working, use explicit config:
   ```bash
   claude --mcp-config ~/.claude/mcp.json
   ```
4. Create alias for convenience:
   ```bash
   echo 'alias claude="claude --mcp-config ~/.claude/mcp.json"' >> ~/.zshrc
   source ~/.zshrc
   ```

### Claude Desktop JSON Parse Errors
**Symptoms**: "Unexpected token" errors when starting Claude Desktop
**Common Causes & Solutions**:
1. **Invalid JSON in config file**:
   - Remove ALL comments (no // or /* */ allowed)
   - Remove trailing commas
   - Ensure proper quotes around all strings
   - Validate JSON at jsonlint.com

2. **Symlink issues**:
   - Remove symlink: `rm ~/Library/Application\ Support/Claude/claude_desktop_config.json`
   - Create fresh file with clean JSON
   - Restart Claude Desktop

3. **Path issues with spaces**:
   - In JSON, use paths as-is: `"/Users/name/Mobile Documents/folder"`
   - Don't escape spaces in JSON strings
   - DO escape spaces in shell commands

### Multiple Claude Installations Warning
**Symptoms**: "Warning: Multiple installations found" when running claude
**Solutions**:
1. Check installations:
   ```bash
   which -a claude
   ```
2. Use specific version:
   - Local: `~/.claude/local/bin/claude`
   - Global: `~/.npm-global/bin/claude`
3. Update PATH to prefer one version

### MCP Servers Work in Desktop but Not CLI
**Symptoms**: Claude Desktop has MCP access but Claude Code doesn't
**Solution**: Different config locations!
- Claude Desktop: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Claude Code: `~/.claude/claude_desktop_config.json` or `~/.claude/mcp.json`
- Fix: Use `claude mcp add-from-claude-desktop` to sync

### Conversation-Logger Path Issues
**Symptoms**: Error about conversation-logger/index.js not found
**Common Causes**:
1. **iCloud path with spaces**: 
   - Path like `/Users/name/Library/Mobile Documents/com~apple~CloudDocs/`
   - In JSON: Use path as-is, no escaping needed
   - In shell: Escape spaces with backslash

2. **Relative vs absolute paths**:
   - Always use absolute paths in config
   - Replace `$(pwd)` with actual path

3. **Fix**:
   ```json
   "conversation-logger": {
     "command": "node",
     "args": ["/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/conversation-logger/index.js"]
   }
   ```

## MCP Server Issues

### Sequential Thinking Not Working
**Symptoms**: Claude doesn't plan tasks or break down problems
**Solutions**:
1. Verify installation: `npx @modelcontextprotocol/server-sequentialthinking --version`
2. Check Claude Desktop config has correct path
3. Restart Claude Desktop
4. Reinstall: `npx @modelcontextprotocol/install sequentialthinking`

### PubMed MCP JSON Parsing Errors in Claude Desktop
**Symptoms**: "Unexpected token 'M', 'MCP PubMed Server' is not valid JSON" errors
**Root Cause**: Some PubMed MCP packages output debug info to stdout, breaking JSON parsing
**Solution**: Use @cyanheads/pubmed-mcp-server with production settings:
```json
"pubmed-cyanheads": {
  "command": "npx",
  "args": ["@cyanheads/pubmed-mcp-server"],
  "env": {
    "MCP_TRANSPORT_TYPE": "stdio",
    "MCP_LOG_LEVEL": "error",
    "NODE_ENV": "production"
  }
}
```

### PubMed MCP Rate Limiting
**Symptoms**: PubMed searches fail or timeout
**Solutions**:
1. Add delays between searches
2. Batch queries when possible
3. Check NCBI API key if configured
4. Wait 1-2 seconds between requests

### Memory MCP Not Persisting
**Symptoms**: Knowledge graph resets between sessions
**Solutions**:
1. Check memory server is running
2. Verify storage path permissions
3. Look for `.mcp-memory` folder in home directory
4. Clear corrupted data: `rm -rf ~/.mcp-memory`

## Obsidian Integration Issues

### ⚠️ CRITICAL: Obsidian Must Be Running!
**The #1 cause of Obsidian MCP failures**: Obsidian is not open
- **Both vaults must be open** in Obsidian for the MCP servers to work
- The REST API plugin only responds when Obsidian is actively running
- If you close Obsidian, Claude will immediately lose connection

### REST API Connection Failed
**Symptoms**: Cannot connect to Obsidian vault, tools fail silently, "disconnected" errors
**Solutions**:
1. **FIRST: Ensure Obsidian is running with the vault open**
2. **Check HTTPS vs HTTP settings**:
   - VERITAS expects **HTTPS (encrypted)** connections
   - In Obsidian REST API settings: "Enable Encrypted (HTTPS) Server" should be ON (green ✓)
   - The config uses `https://127.0.0.1:27124` not `http://`
3. Verify REST API plugin is enabled in the open vault
4. Check port is not blocked: `lsof -i :27124`
5. Confirm authentication token matches **exactly** (copy the full token)
6. Check Obsidian console for errors (Cmd+Option+I on Mac)

### Wrong File Location
**Symptoms**: Files created in wrong folder
**Solutions**:
1. Check CLAUDE.md has correct paths
2. Verify vault folder structure exists
3. Use exact endpoint: `/vault/Research Questions/`
4. Check for typos in folder names

## Hook System Issues

### Hooks Not Running
**Symptoms**: No pre-command messages displayed
**Solutions**:
1. Check permissions: `chmod +x .claude/hooks/*.sh`
2. Verify settings.local.json exists
3. Check hook paths are absolute
4. Test manually: `bash .claude/hooks/pre-command.sh`

## Citation Issues

### Missing PMIDs
**Symptoms**: Medical claims without citations
**Solutions**:
1. Ensure PubMed MCP is installed
2. Check verification.json rules
3. Test PubMed search manually
4. Verify post-command validator running

## Getting Help

1. Check error logs in `.claude/logs/`
2. Review Claude Desktop console output
3. Submit GitHub issue with error details
