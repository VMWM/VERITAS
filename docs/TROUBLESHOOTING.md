# VERITAS Troubleshooting Guide

This guide helps diagnose and fix common runtime issues with VERITAS.

## Quick Diagnostics

Run this diagnostic script to check your setup:

```bash
#!/bin/bash
echo "=== VERITAS Diagnostics ==="
echo ""
echo "1. Environment Variables:"
echo "   CLAUDE_PROJECT_DIR: $CLAUDE_PROJECT_DIR"
echo "   OBSIDIAN_VAULT_PATH: $OBSIDIAN_VAULT_PATH"
echo "   OBSIDIAN_API_KEY: ${OBSIDIAN_API_KEY:0:10}..."
echo ""
echo "2. Hook Files:"
ls -la ~/.claude/hooks/*.{sh,py} 2>/dev/null | grep -E "\.(sh|py)$"
echo ""
echo "3. MCP Servers:"
claude mcp list 2>/dev/null || echo "   Claude CLI not installed"
echo ""
echo "4. Conversation Logger:"
ls -la ~/.conversation-logger/ 2>/dev/null || echo "   Database not found"
echo ""
echo "5. Obsidian Connection:"
curl -k -s https://127.0.0.1:27124/vault/ \
  -H "Authorization: Bearer $OBSIDIAN_API_KEY" \
  | head -c 50 || echo "   Connection failed"
```

## Common Issues and Solutions

### Issue: Files Created Without .md Extension

**Symptom**: Obsidian files open in text editor instead of Obsidian

**Solution**: 
1. Check CLAUDE.md has the rule: "ALWAYS append `.md` to ALL file paths"
2. Verify post-command.sh is running to validate output
3. Update to latest version: `cd ~/VERITAS && git pull`

### Issue: Tables Not Formatting Correctly

**Symptom**: Tables appear without proper spacing in Obsidian

**Solution**: Ensure tables use spaces around pipes:
```markdown
CORRECT:   | Cell 1 | Cell 2 |
INCORRECT: |Cell 1|Cell 2|
```

### Issue: Hooks Not Running

**Symptom**: No pre-command reminders or post-command validation

**Solution**:
1. Check hook permissions:
   ```bash
   chmod +x ~/.claude/hooks/*.sh
   chmod +x ~/.claude/hooks/*.py
   ```

2. Verify settings.local.json exists:
   ```bash
   cat ~/.claude/settings.local.json
   ```

3. Ensure hooks are in correct location

### Issue: PubMed MCP "Unexpected token 'M'" Error

**Symptom**: PubMed MCP fails with "Unexpected token 'M', 'MCP PubMed'... is not valid JSON"

**Cause**: The @ncukondo/pubmed-mcp server outputs diagnostic text before JSON, breaking Claude Desktop's parser.

**Solution**: 
VERITAS now includes a wrapper script that filters out non-JSON startup messages. The fix is automatically applied when you run the configuration script. If you encounter this issue:

1. Update VERITAS to get the fix:
   ```bash
   cd ~/VERITAS && git pull
   ```
2. Re-run the configuration:
   ```bash
   ./install/scripts/configure-claude.sh
   ```
3. Restart Claude Desktop

**Manual Fix** (if needed):
The wrapper is located at `install/mcp-wrappers/pubmed-wrapper.js` and is automatically configured by the setup script.

### Issue: MCP Servers Disconnected

**Symptom**: "MCP server [name] is disconnected" in Claude

**Solution**:
1. Restart Claude Desktop completely
2. Check server is installed:
   ```bash
   npm list -g --depth=0 | grep mcp
   ```
3. Verify configuration JSON is valid:
   ```bash
   jq . ~/Library/Application\ Support/Claude/claude_desktop_config.json
   ```

### Issue: Obsidian Connection Failed

**Symptom**: Cannot create notes in Obsidian vault

**Checklist**:
- [ ] Obsidian is running
- [ ] Local REST API plugin is enabled
- [ ] HTTPS server is ON (not HTTP)
- [ ] Port matches configuration (27124/27125)
- [ ] Bearer token is correct
- [ ] API key is set in environment

**Test Connection**:
```bash
curl -k https://127.0.0.1:27124/vault/ \
  -H "Authorization: Bearer $OBSIDIAN_API_KEY"
```

### Issue: Citations Missing PMIDs

**Symptom**: Medical claims without PMID citations

**Solution**:
1. Ensure PubMed MCP is connected
2. Check CLAUDE.md enforcement rules
3. Verify pre-command hook shows citation requirements
4. Use sequential-thinking for complex research

### Issue: Conversation Logger Not Working

**Symptom**: No conversations being logged or "conversation-logger disconnected" in Claude

**Common Causes**:

1. **Moved VERITAS Directory After Installation**
   - The conversation-logger uses an absolute path in Claude's config
   - If you move ~/VERITAS to a different location, the path becomes invalid
   
   **Solution**: Update the path in your Claude Desktop config:
   ```json
   "conversation-logger": {
     "command": "node",
     "args": ["/new/path/to/VERITAS/conversation-logger/index.js"]
   }
   ```
   Location: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

2. **Dependencies Not Installed**
   - Check: `ls ~/VERITAS/conversation-logger/node_modules`
   - Fix: `cd ~/VERITAS/conversation-logger && npm install`

3. **Database Permission Issues**
   - Check: `ls -la ~/.conversation-logger/conversations.db`
   - Fix: `chmod 644 ~/.conversation-logger/conversations.db`

**Checks**:
1. Database exists:
   ```bash
   ls -la ~/.conversation-logger/conversations.db
   ```

2. MCP server is running:
   ```bash
   claude mcp list | grep conversation-logger
   ```

3. SessionEnd hook configured:
   ```bash
   grep -A5 "SessionEnd" ~/.claude/settings.local.json
   ```

4. Test manual logging:
   ```bash
   # In Claude conversation
   /exit  # or however your setup triggers logging
   ```

### Issue: Journal Generation Fails

**Symptom**: Cannot generate daily journal from conversations

**Solution**:
1. Check conversations exist in database:
   ```bash
   sqlite3 ~/.conversation-logger/conversations.db \
     "SELECT COUNT(*) FROM messages;"
   ```

2. Verify date format:
   ```bash
   # Generate for today
   mcp__conversation-logger__generate_journal
   
   # Generate for specific date
   mcp__conversation-logger__generate_journal "2024-01-15"
   ```

### Issue: Path Not Found Errors

**Symptom**: "No such file or directory" errors

**Solution**:
1. Source environment file:
   ```bash
   source ~/.claude/env.sh
   ```

2. Check current directory:
   ```bash
   pwd  # Should be your project directory
   ```

3. Update paths in env.sh if needed

## Performance Issues

### Slow MCP Server Response

**Optimize**:
1. Set production environment:
   ```bash
   export NODE_ENV=production
   export MCP_LOG_LEVEL=error
   ```

2. Disable debug output in config

3. Clear cache if needed:
   ```bash
   rm -rf ~/.npm/_cacache
   ```

### High Memory Usage

**Solutions**:
1. Restart Claude periodically
2. Limit conversation logger retention:
   ```bash
   node ~/VERITAS/conversation-logger/cleanup-old-logs.js
   ```
3. Clear memory MCP knowledge graph if too large

## Debugging Tools

### Enable Verbose Logging

```bash
# In claude_desktop_config.json
"env": {
  "MCP_LOG_LEVEL": "debug",
  "NODE_ENV": "development"
}
```

### View Claude Logs

**Desktop**:
- View � Developer Tools � Console

**CLI**:
```bash
claude --verbose [command]
```

### Test Individual MCP Servers

```bash
# Test server directly
npx @modelcontextprotocol/server-sequentialthinking --test
```

### Check System Resources

```bash
# Memory usage
ps aux | grep -E "claude|node" | awk '{sum+=$6} END {print "Total MB: " sum/1024}'

# Disk usage
du -sh ~/.conversation-logger/
du -sh ~/.claude/
```

## Reset Procedures

### Reset Conversation Logger

```bash
# Backup existing data
cp ~/.conversation-logger/conversations.db ~/conversations.backup.db

# Clear database
rm ~/.conversation-logger/conversations.db

# Restart Claude
```

### Reset MCP Configuration

```bash
# Backup current config
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json ~/claude.backup.json

# Re-run configuration
cd ~/VERITAS
./install/scripts/configure-claude.sh
```

### Complete Reset

```bash
# Full reset (preserves backups)
cd ~/VERITAS
# Reset script not included - manually clean up

# Or manually:
rm -rf ~/.claude/logs/*
rm -rf ~/.conversation-logger/active
# Re-run setup from VERITAS directory
./install/scripts/setup.sh
```

## Getting Additional Help

1. **Check Logs**:
   ```bash
   tail -f ~/.claude/logs/*.log
   ```

2. **Run Diagnostics**:
   ```bash
   ./tests/verify-installation.sh  # Run verification
   ```

3. **Report Issue** with:
   - Diagnostic output
   - Error messages
   - Steps to reproduce
   - OS and Claude version

4. **Community Support**:
   - GitHub Issues: https://github.com/VMWM/VERITAS/issues
   - Include diagnostic output in issue

## Prevention Best Practices

1. **Regular Maintenance**:
   - Update VERITAS weekly: `git pull`
   - Clean logs monthly
   - Restart Claude daily

2. **Before Major Work**:
   - Check all MCP servers connected
   - Verify Obsidian is running
   - Source environment variables

3. **Monitor Resources**:
   - Check conversation logger size
   - Watch for memory issues
   - Clear caches periodically