# Research Agent-MCP System

A comprehensive Claude Code enforcement system for academic research and knowledge management, featuring automatic tool routing, citation validation, and Obsidian integration.

## Purpose

This system ensures Claude Code consistently:
- Routes Obsidian tasks to correct MCP tools (not filesystem)
- Enforces proper citations for all scientific claims
- Follows templates for research questions and concepts
- Starts with sequential thinking for complex tasks
- Maintains proper formatting for academic documentation

## Key Features

### Multi-Layer Enforcement
1. **CLAUDE.md** - Direct routing rules with IF/THEN logic
2. **Agent System** - Research Director with detailed templates
3. **Hook System** - Pre/post command validation
4. **Compliance Scripts** - Block incorrect tool usage
5. **Settings Integration** - Automatic hook execution

### Research Support
- Templates for research questions, concepts, and daily journals
- Automatic citation verification with PubMed MCP
- Wiki-link knowledge graph creation
- Academic writing standards enforcement

## Installation

### Prerequisites
- Claude Code (Claude Desktop)
- Obsidian with REST API plugin
- Python 3.8+
- Bash shell
- PubMed MCP server

### Quick Setup

1. Clone the repository
2. Copy CLAUDE.md and .claude folder to your project
3. Configure Obsidian REST API
4. Update paths in CLAUDE.md for your environment

## Testing the System

Test in a new Claude Code conversation:

```
"Add this research question to my obsidian vault: 
How does [your topic] affect [outcome]?"
```

### Success Indicators
- Starts with sequential thinking
- Uses mcp__obsidian-rest-*__test_request
- Creates file in correct vault folder
- All claims have proper citations
- Follows templates exactly

## License

MIT License - See LICENSE file for details

---

**Note**: For detailed documentation, see the `/docs` folder.
