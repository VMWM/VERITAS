# VERITAS Functional Test Prompts

Use these prompts in a new Claude Code conversation to verify your VERITAS installation is working correctly. Start with Basic Tests, then move to MCP-specific tests.

## Prerequisites
- [ ] Completed setup.sh successfully
- [ ] Ran configure-claude.sh and merged MCP servers
- [ ] Restarted Claude Desktop/CLI
- [ ] Have your project directory ready

## Basic Tests

### 1. Test Constitutional Awareness
**Prompt:** "What is your role according to CLAUDE.md?"

**Expected:** Claude should reference the constitution and explain the VERITAS system's purpose.

### 2. Test Domain Expert Loading
**Prompt:** "What domain expert templates are available?"

**Expected:** Claude should mention the domain expert file in .claude/agents/ and describe available templates.

## MCP Server Tests

### 3. Test Filesystem Access
**Prompt:** "List the files in my project directory"

**Expected:** Claude should use the filesystem MCP to list your project files.

### 4. Test Memory MCP
**Prompt:** "Remember that my research focus is [your topic]. What did I just tell you to remember?"

**Expected:** Claude should store this in memory and retrieve it.

### 5. Test Sequential Thinking
**Prompt:** "Plan a research literature review on [simple topic] - think through the steps carefully"

**Expected:** Claude should use sequential thinking to break down the task.

### 6. Test PubMed MCP
**Prompt:** "Find recent papers about CRISPR gene editing"

**Expected:** Claude should search PubMed and return papers with PMIDs.

### 7. Test Conversation Logger
**Prompt:** "Generate a journal entry for today's session"

**Expected:** Claude should create a summary of the conversation using the logger.

## Obsidian Integration Tests (if configured)

### 8. Test Obsidian Connection
**Prompt:** "List the notes in my Obsidian vault"

**Expected:** Claude should connect to your vault and list files.

### 9. Test Note Creation
**Prompt:** "Create a test note in my vault called 'VERITAS Test Note' with some sample content"

**Expected:** Claude should create the note in your Obsidian vault.

### 10. Test Note Reading
**Prompt:** "Read the VERITAS Test Note we just created"

**Expected:** Claude should retrieve and display the note content.

## Workflow Tests

### 11. Test Research Workflow
**Prompt:** "Help me research [your topic]. Start by searching for papers, then organize the findings."

**Expected:** Claude should:
- Use PubMed to search
- Use memory to store findings
- Potentially create notes if Obsidian is configured
- Use sequential thinking for planning

### 12. Test Citation Verification
**Prompt:** "Tell me about the benefits of exercise on mental health - make sure to include citations"

**Expected:** Claude should:
- Search PubMed for evidence
- Include (Author et al., Year, PMID: XXXXXXXX) format citations
- Mark verification levels

### 13. Test Daily Journal
**Prompt:** "Create today's research journal entry"

**Expected:** Claude should create a structured journal entry (in Obsidian if configured, or as a file).

## Advanced Tests

### 14. Test Multi-Tool Coordination
**Prompt:** "Search for papers about [topic], save the best 3 to memory, and create a summary note"

**Expected:** Claude should coordinate multiple MCP servers:
- PubMed for search
- Memory for storage
- Filesystem or Obsidian for note creation

### 15. Test Error Handling
**Prompt:** "Read a file that doesn't exist: /nonexistent/file.txt"

**Expected:** Claude should gracefully handle the error and explain the file doesn't exist.

## Troubleshooting

If any test fails:

1. **Check MCP Server Status:**
   ```
   # In terminal
   ps aux | grep -E "conversation-logger|pubmed|memory|obsidian"
   ```

2. **Verify Configuration:**
   ```
   # Check Claude configuration
   cat ~/.claude.json | jq '.mcpServers | keys'
   ```

3. **Check Logs:**
   - Claude logs: Check Claude's developer console
   - Conversation logs: `~/.conversation-logger/`

4. **For Obsidian Issues:**
   - Verify Local REST API plugin is enabled
   - Check HTTPS is enabled in plugin settings
   - Confirm port and API token match configuration

## Success Criteria

✅ **Basic Success:** Tests 1-7 pass
✅ **Full Success:** Tests 1-13 pass
✅ **Advanced Success:** All tests pass including 14-15

## Common Issues and Solutions

| Issue | Solution |
| --- | --- |
| "MCP server not found" | Restart Claude after running configure-claude.sh |
| "Cannot connect to Obsidian" | Check Local REST API plugin is running with HTTPS |
| "PubMed returns no results" | Try a broader search term, check internet connection |
| "Memory not persisting" | Ensure memory MCP is in your configuration |
| "Sequential thinking not working" | Verify @modelcontextprotocol/server-sequentialthinking is installed |

## Report Issues

If you encounter persistent problems:
1. Document which test failed
2. Copy any error messages
3. Note your OS and Claude version
4. Create an issue at: https://github.com/VMWM/VERITAS/issues

---
*Last updated: August 2025*
*VERITAS Version: 1.0.0*