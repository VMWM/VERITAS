# Troubleshooting Guide

Common issues and solutions for the Research Agent-MCP System.

## MCP Server Issues

### Sequential Thinking Not Working
**Symptoms**: Claude doesn't plan tasks or break down problems
**Solutions**:
1. Verify installation: `npx @modelcontextprotocol/server-sequentialthinking --version`
2. Check Claude Desktop config has correct path
3. Restart Claude Desktop
4. Reinstall: `npx @modelcontextprotocol/install sequentialthinking`

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

### REST API Connection Failed
**Symptoms**: Cannot connect to Obsidian vault
**Solutions**:
1. Verify REST API plugin is enabled
2. Check port is not blocked: `lsof -i :27124`
3. Confirm authentication token matches
4. Try disabling authentication temporarily
5. Check Obsidian console for errors

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
