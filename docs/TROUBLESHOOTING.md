# Troubleshooting Guide

## Common Issues and Solutions

### 1. MCP Servers Not Connecting

**Symptom**: Running `/mcp` shows servers as disconnected or missing

**Solutions**:
1. **Restart Claude Code**
   ```bash
   # Exit current session (Ctrl+C or type 'exit')
   claude
   ```

2. **Check Configuration Path**
   ```bash
   # Verify symlink exists
   ls -la ~/.claude.json
   # Should show: ~/.claude.json -> /Users/.../MCP-Shared/claude-desktop-config.json
   ```

3. **Validate JSON Configuration**
   ```bash
   # Check for syntax errors
   python -m json.tool ~/.claude.json > /dev/null
   ```

4. **Check API Keys**
   - Ensure all API keys are properly quoted in the config
   - No trailing spaces or hidden characters

### 2. Obsidian Files Not Created

**Symptom**: Agent says it created notes but they don't appear in Obsidian

**Solutions**:
1. **Check REST API is Enabled**
   - Open Obsidian
   - Settings → Community Plugins
   - Ensure "Local REST API" is enabled (toggle on)

2. **Verify API Key**
   - In Obsidian REST API settings, regenerate key
   - Update in `claude-desktop-config.json`:
   ```json
   "REST_API_KEY": "your-new-key-here",
   "REST_DEFAULT_HEADERS": "{\"Authorization\": \"Bearer your-new-key-here\"}"
   ```

3. **Check Obsidian is Running**
   - REST API only works when Obsidian app is open
   - Fallback to file system access works offline

4. **Test Connection**
   ```bash
   # In Claude Code
   /mcp
   # Should show obsidian-rest connected
   ```

### 3. PubMed Rate Limiting

**Symptom**: "Rate limit exceeded" errors from PubMed

**Solutions**:
1. **Automatic Handling**
   - System auto-waits 1 second between queries
   - No action needed for normal use

2. **For Heavy Use**
   - Get PubMed API key: https://www.ncbi.nlm.nih.gov/account/
   - Add to config:
   ```json
   "PUBMED_API_KEY": "your-key-here",
   "PUBMED_EMAIL": "your.email@university.edu"
   ```

### 4. Agent Seems Stuck

**Symptom**: Agent starts but doesn't complete task

**Solutions**:
1. **Wait 60 Seconds**
   - Complex queries take time
   - Agent is likely still working

2. **Check for Errors**
   - Look for red error messages
   - Common: file permissions, API limits

3. **Restart if Needed**
   ```bash
   # Exit and restart
   exit
   claude
   ```

### 5. Wrong Vault Used

**Symptom**: Notes created in wrong location

**Solutions**:
1. **Update Memory MCP Instructions**
   ```bash
   # In Claude Code
   "Update Memory MCP routing rules to use HLA Antibodies vault for medical content"
   ```

2. **Check File Paths**
   - Verify paths in config match your structure
   - Use absolute paths, not relative

### 6. Memory Not Persisting

**Symptom**: Claude doesn't remember previous sessions

**Solutions**:
1. **Check Memory Directory**
   ```bash
   ls -la ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/nova-memory/
   # Should see memory.db file
   ```

2. **Verify Memory MCP Running**
   ```bash
   /mcp
   # Should show memory connected
   ```

3. **Test Memory**
   ```bash
   # Store something
   "Remember that my favorite color is blue"
   # New session
   exit
   claude
   "What's my favorite color?"
   # Should recall "blue"
   ```

### 7. Cloud Sync Issues

**Symptom**: Settings don't sync between machines

**Solutions**:
1. **Check iCloud Status**
   - System Preferences → Apple ID → iCloud
   - Ensure iCloud Drive is enabled

2. **Force Sync**
   ```bash
   # On machine with changes
   killall bird
   # Wait 30 seconds for sync
   ```

3. **Verify Symlink on Both Machines**
   ```bash
   # On each machine
   ls -la ~/.claude.json
   # Should point to same iCloud location
   ```

### 8. VS Code Integration Issues

**Symptom**: Can't start Claude from VS Code terminal

**Solutions**:
1. **Install VS Code Command Line Tools**
   - In VS Code: Cmd+Shift+P
   - Type: "Shell Command: Install 'code' command"
   - Restart terminal

2. **Check PATH**
   ```bash
   echo $PATH
   # Should include npm global bin directory
   which claude
   # Should show path to claude executable
   ```

### 9. API Key Errors

**Symptom**: "Invalid API key" or "Unauthorized" errors

**Solutions**:
1. **Claude API Key**
   - Get from: https://console.anthropic.com/
   - Add to VS Code settings or environment

2. **Obsidian API Key**
   - Regenerate in Obsidian settings
   - Update both REST_API_KEY and REST_DEFAULT_HEADERS

3. **PubMed Credentials**
   - Optional but recommended for heavy use
   - Register at: https://www.ncbi.nlm.nih.gov/account/

### 10. Performance Issues

**Symptom**: Slow responses or timeouts

**Solutions**:
1. **Reduce Parallel Operations**
   - Process fewer files at once
   - Smaller agent queries

2. **Clear Logs**
   ```bash
   rm ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/logs/*.log
   ```

3. **Check System Resources**
   ```bash
   # Monitor CPU/memory
   top
   # High usage may slow responses
   ```

## Error Messages Reference

| Error | Meaning | Solution |
|-------|---------|----------|
| "MCP server disconnected" | Server crashed or timed out | Restart Claude |
| "REST_BASE_URL not defined" | Config error | Check environment variables |
| "Cannot read property of undefined" | API response issue | Check API keys and endpoints |
| "ECONNREFUSED" | Service not running | Start Obsidian app |
| "Rate limit exceeded" | Too many API calls | Wait or add API key |
| "File not found" | Wrong path | Check file paths in config |
| "Permission denied" | File access issue | Check directory permissions |

## Getting More Help

### Diagnostic Commands

```bash
# Check all MCP servers
/mcp

# Test memory
"Store test: The answer is 42"
"Recall test: What's the answer?"

# Test PubMed
"Search PubMed for 'kidney transplant' papers from 2024"

# Test Obsidian
"Create test note in Research Journal"

# Check logs
cat ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/logs/*.log
```

### Support Resources

1. **Claude Code Documentation**
   - https://docs.anthropic.com/en/docs/claude-code

2. **MCP Protocol Specs**
   - https://modelcontextprotocol.org

3. **GitHub Issues**
   - Report bugs: https://github.com/anthropics/claude-code/issues

4. **Community Discord**
   - Join MCP community for help

### Debug Mode

For detailed debugging:
```bash
# Set environment variable
export LOG_LEVEL=DEBUG
claude
```

### Clean Reinstall

If all else fails:
```bash
# Backup your config
cp ~/.claude.json ~/claude-backup.json

# Uninstall
npm uninstall -g @anthropic-ai/claude-code

# Clear cache
rm -rf ~/.npm
rm ~/.claude.json

# Reinstall
npm install -g @anthropic-ai/claude-code

# Restore config
cp ~/claude-backup.json ~/.claude.json
```

## Frequently Asked Questions

**Q: Can I use this on non-macOS systems?**
A: Currently this is macOS-only due to iCloud integration and path structures. The core MCP components could theoretically work on other systems with significant modifications.

**Q: How much does this cost?**
A: ~$20/month for heavy daily use of Claude API. Other services have free tiers.

**Q: Can multiple people share a config?**
A: Yes, but each needs their own API keys.

**Q: Is my data secure?**
A: Data stays local or in your cloud. Only API calls go to services.

**Q: Can I customize the agents?**
A: Yes! See docs/AGENT_GUIDE.md for creating custom agents.

---

*Still having issues? Create an issue on GitHub with:*
1. Your error message
2. Your config (remove API keys!)
3. Steps to reproduce
4. System info (macOS version, Node version)