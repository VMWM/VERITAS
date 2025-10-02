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

### Issue: Transcript Reader Not Working

**Symptom**: No transcripts found or "claude-transcript-reader disconnected" in Claude

**Common Causes**:

1. **Moved VERITAS Directory After Installation**
   - The claude-transcript-reader uses an absolute path in Claude's config
   - If you move ~/VERITAS to a different location, the path becomes invalid

   **Solution**: Update the path in your Claude Desktop config:
   ```json
   "claude-transcript-reader": {
     "command": "node",
     "args": ["/new/path/to/VERITAS/claude-transcript-reader/index.js"]
   }
   ```
   Location: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

2. **Path Conversion Issue**
   - Claude Code converts both `/` and `_` to `-` in directory names
   - The MCP must handle this conversion correctly

   **Fix**: Ensure you're using the latest version with underscore-to-hyphen conversion:
   ```bash
   cd ~/VERITAS && git pull
   ```

3. **No Conversations Yet**
   - Claude Code only logs when you use it
   - Check: `ls ~/.claude/projects/*/`

**Checks**:
1. JSONL files exist:
   ```bash
   ls ~/.claude/projects/*/
   ```

2. MCP server is running:
   ```bash
   # Check MCP connection in Claude Code
   /mcp
   ```

3. Test session stats:
   ```bash
   # In Claude conversation, ask:
   "Get session stats"
   ```

### Issue: Journal Generation Fails

**Symptom**: Cannot generate daily journal from conversations

**Solution**:
1. Check transcripts exist:
   ```bash
   ls -lh ~/.claude/projects/*/
   ```

2. Verify date format and test in Claude Code:
   ```bash
   # Ask Claude:
   "Generate journal for today"

   # Or for specific date:
   "Generate journal for 2024-01-15"
   ```

3. Check that sessions are being found:
   ```bash
   # Ask Claude:
   "Get session stats"
   # Should show sessionCount > 0
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
2. Cleanup runs automatically at 2 AM daily
3. Manual cleanup if needed:
   ```bash
   find ~/.claude/projects -name "*.jsonl" -mtime +5 -delete
   ```
4. Clear memory MCP knowledge graph if too large

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

### Reset Transcript Reader

```bash
# Backup existing transcripts
cp -r ~/.claude/projects ~/claude-projects-backup

# Clear old transcripts (optional - automatic cleanup happens daily)
find ~/.claude/projects -name "*.jsonl" -mtime +5 -delete

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