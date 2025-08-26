# Common Setup Errors and Fixes

This document lists the most common errors users encounter when setting up VERITAS and how to fix them.

## Critical Setup Steps Often Missed

### 1. Environment Variables Not Set
**Error**: "CLAUDE.md not found!" or hooks failing to find files

**Solution**: After running `setup.sh`, you MUST:
```bash
# Source the environment file
source ~/.claude/env.sh

# Or add to your shell profile (.bashrc, .zshrc, etc.):
echo "source ~/your-project-path/.claude/env.sh" >> ~/.bashrc
```

### 2. Obsidian HTTPS Configuration
**Error**: "MCP server obsidian-rest-hla is disconnected"

**Solution**: In Obsidian Local REST API settings:
- ✅ **Enable Encrypted (HTTPS) Server** - MUST BE ON
- ❌ **Enable Non-encrypted (HTTP) Server** - MUST BE OFF
- Set correct ports (27124 for main, 27125 for journal)

### 3. Wrong Directory During Setup
**Error**: Paths not working, files not found

**Solution**: Run setup.sh from VERITAS directory AND provide correct project path:
```bash
cd ~/VERITAS
./setup.sh
# When prompted for project directory, enter YOUR project path
# NOT the VERITAS directory
```

## Installation Errors

### Error: "npm is not installed"
**Solution**:
```bash
# macOS
brew install node

# Linux
sudo apt-get install nodejs npm
```

### Error: "npx command not found"
**Solution**:
```bash
npm install -g npx
```

### Error: "Permission denied" on hooks
**Solution**:
```bash
chmod +x ~/.claude/hooks/*.sh
chmod +x ~/.claude/hooks/*.py
```

## MCP Server Errors

### Error: "Cannot find module '@modelcontextprotocol/sdk'"
**Solution**:
```bash
cd ~/VERITAS/conversation-logger
npm install
```

### Error: "OBSIDIAN_API_TOKEN not set"
**Solution**:
```bash
# Add to your shell profile:
export OBSIDIAN_API_TOKEN="your-token-from-obsidian-plugin"
```

### Error: Conversation logger not capturing
**Solution**: Verify SessionEnd hook is configured:
1. Check `~/.claude/settings.local.json` has SessionEnd section
2. Restart Claude Desktop or run `claude restart`
3. Sessions log automatically on end (no /exit needed)

## Path-Related Errors

### Error: "No such file or directory" in hooks
**Cause**: Hardcoded paths from original setup

**Solution**: Re-run setup and ensure environment is sourced:
```bash
cd ~/VERITAS
git pull  # Get latest fixes
./setup.sh
source ~/.claude/env.sh
```

### Error: Templates not found
**Solution**: Copy templates to your project:
```bash
cp -r ~/VERITAS/templates ~/your-project-path/
```

## Configuration Errors

### Error: Claude Desktop not loading MCP servers
**Solution**: 
1. Check config file location:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/claude/claude_desktop_config.json`

2. Ensure proper JSON format (validate with `jq`):
```bash
jq . ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

3. Restart Claude Desktop completely

### Error: CLI not syncing with Desktop
**Solution**: Run after configuring Desktop:
```bash
claude mcp add-from-claude-desktop
claude mcp list  # Verify servers loaded
```

## Quick Diagnostic Commands

Run these to check your setup:

```bash
# Check environment variables
echo "Project Dir: $CLAUDE_PROJECT_DIR"
echo "Obsidian Vault: $OBSIDIAN_VAULT_PATH"

# Check if hooks are executable
ls -la ~/.claude/hooks/*.py

# Check if conversation logger DB exists
ls -la ~/.conversation-logger/

# Test Obsidian connection
curl -k https://127.0.0.1:27124/vault/ \
  -H "Authorization: Bearer $OBSIDIAN_API_TOKEN"

# Check MCP servers
claude mcp list
```

## Still Having Issues?

1. **Pull latest updates**:
   ```bash
   cd ~/VERITAS && git pull
   ```

2. **Re-run setup**:
   ```bash
   ./setup.sh
   ```

3. **Check logs**:
   ```bash
   ls -la ~/.claude/logs/
   ```

4. **Report issue** with:
   - Error message
   - Output of diagnostic commands above
   - Your OS and Claude version

## Prevention Tips

1. Always run `setup.sh` from VERITAS directory
2. Always source the env.sh file after setup
3. Keep Obsidian running while using Claude
4. Use HTTPS (not HTTP) for Obsidian REST API
5. Restart Claude after configuration changes