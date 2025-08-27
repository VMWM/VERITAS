# VERITAS Functional Test Prompts

Use these prompts in a new Claude Code conversation to verify your VERITAS installation is working correctly. Each test targets a specific system component.

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
**Prompt:** "What domain expert templates are available in my .claude/agents directory?"

**Expected:** Claude should mention the domain expert file and describe available templates for your field.

## MCP Server Tests

### 3. Test Filesystem Access
**Prompt:** "List the files in my project directory"

**Expected:** Claude should use the filesystem MCP to list your project files including CLAUDE.md and .claude directory.

### 4. Test Memory MCP (Knowledge Graph)
**Prompt:** "Create a knowledge entity about the VERITAS system with this observation: 'VERITAS enforces citation requirements for all scientific claims.'"

**Expected:** Claude should use memory MCP to create and store an entity in the knowledge graph.

**Follow-up:** "Search for entities related to VERITAS"

**Expected:** Claude should retrieve the entity we just created.

### 5. Test Sequential Thinking
**Prompt:** "Think step-by-step about how to conduct a systematic literature review on any topic"

**Expected:** Claude should use sequential thinking to break down the task showing numbered thought progression.

### 6. Test PubMed MCP
**Prompt:** "Search PubMed for recent papers about machine learning in healthcare and show me 3 results with PMIDs"

**Expected:** Claude should search PubMed and return papers with proper (Author et al., Year, PMID: XXXXXXXX) citations.

### 7. Test Conversation Logger (Session Database)
**Prompt:** "Get statistics about my logged conversation sessions"

**Expected:** Claude should use the conversation logger to show session statistics (number of sessions, messages, etc.).

**Follow-up:** "Generate a summary of today's logged conversations"

**Expected:** Claude should create a summary from the conversation database (different from Obsidian journaling).

## Obsidian Integration Tests (if configured)

### 8. Test Obsidian Connection
**Prompt:** "List the notes in my Obsidian vault"

**Expected:** Claude should connect to your vault and list existing files.

### 9. Test Template-Based Note Creation
**Prompt:** "Create a research question note about 'How effective is machine learning in medical diagnosis' using the templates from my domain expert"

**Expected:** Claude should:
- Use your domain expert's research question template
- Follow the folder structure specified in your domain expert
- Create properly formatted content with frontmatter

### 10. Test Concept Note Creation
**Prompt:** "Create a concept note for 'Machine Learning' using my domain expert templates"

**Expected:** Claude should:
- Use your domain expert's concept template
- Place it in the concepts folder as defined by your domain expert
- Include proper wiki links and structure

### 11. Test Daily Journal Template
**Prompt:** "Create today's journal entry using my domain expert's journal template"

**Expected:** Claude should:
- Use the daily journal template from your domain expert
- Create the entry in your journal vault/folder
- Include today's date and proper structure

## Advanced Workflow Tests

### 12. Test Domain-Specific Workflow
**Prompt:** "Help me research [topic in your field]. Use PubMed to find evidence, store key findings in memory, and create a research question note in Obsidian."

**Expected:** Claude should:
- Use PubMed MCP for literature search
- Use Memory MCP to store findings
- Use Obsidian MCP to create properly templated note
- Follow your domain expert's specifications throughout

### 13. Test Citation Enforcement
**Prompt:** "Tell me about the benefits of exercise on mental health - make sure every claim is properly cited"

**Expected:** Claude should:
- Search PubMed for evidence
- Include (Author et al., Year, PMID: XXXXXXXX) format citations
- Mark verification levels [ABSTRACT-VERIFIED] etc.
- Refuse to make unsupported claims

### 14. Test Multi-System Integration
**Prompt:** "Search for 3 papers about [your topic], save the key findings to memory as entities, and create a concept note summarizing what we learned"

**Expected:** Claude should coordinate:
- PubMed MCP for search
- Memory MCP for entity storage
- Obsidian MCP for note creation with proper templates

### 15. Test Error Handling
**Prompt:** "Read a file that doesn't exist: /this/file/does/not/exist.txt"

**Expected:** Claude should gracefully handle the error and explain the file doesn't exist.

## System-Specific Clarifications

### Memory MCP vs Conversation Logger
- **Memory MCP**: Knowledge graph for research entities, concepts, relationships
- **Conversation Logger**: Session database for conversation history and statistics
- **Test**: Memory stores knowledge entities; Logger tracks conversation metadata

### Obsidian Templates vs Other Systems
- **Templates come from**: Your domain expert file in .claude/agents/
- **Folder structure**: Defined in your domain expert
- **Content format**: Specified by domain expert templates
- **Test**: Claude should reference your specific domain expert for structure

### Citation Requirements
- **PubMed MCP**: Searches and retrieves papers
- **Citation format**: (Author et al., Year, PMID: XXXXXXXX)
- **Verification levels**: [FT-VERIFIED], [ABSTRACT-VERIFIED], [NEEDS-FT-REVIEW]
- **Test**: All medical/scientific claims must have PMIDs

## Troubleshooting

If any test fails:

1. **Check MCP Server Status:**
   ```bash
   jq '.mcpServers | keys' ~/.claude.json
   ```

2. **For Obsidian Issues:**
   - Verify Local REST API plugin is enabled and running
   - Check HTTPS is enabled in plugin settings
   - Confirm port and API token match your configure-claude.sh setup

3. **For Memory/Logger Issues:**
   - Ensure conversation-logger MCP is in configuration
   - Check memory MCP is properly configured
   - Verify database permissions in ~/.conversation-logger/

## Success Criteria

✅ **Basic Success:** Tests 1-7 pass (core functionality)
✅ **Full Success:** Tests 1-13 pass (includes Obsidian)
✅ **Advanced Success:** All tests pass including error handling

## Common Issues and Solutions

| Issue | Solution |
| --- | --- |
| "MCP server not found" | Restart Claude after configuration |
| "Cannot connect to vault" | Check Obsidian Local REST API plugin |
| "Template not found" | Verify domain expert file exists and is referenced in CLAUDE.md |
| "No PMIDs found" | Try broader search terms, check internet connection |
| "Memory not saving" | Check memory MCP configuration |
| "Wrong note structure" | Verify domain expert templates are properly defined |

## Report Issues

If you encounter persistent problems:
1. Note which specific test failed
2. Copy the exact error message
3. Check your domain expert file for template definitions
4. Open an issue at: https://github.com/VMWM/VERITAS/issues

---
*Last updated: August 2025*
*VERITAS Version: 1.0.0*