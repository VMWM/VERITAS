# Research Agent-MCP System

A hook-based enforcement system that ensures Claude Code follows consistent workflows for research documentation, citation management, and Obsidian integration.

## What This System Does

This system creates a multi-layer enforcement framework that:
- Routes research tasks to appropriate MCP tools automatically
- Enforces PMID citation requirements for all scientific claims
- Creates properly formatted Obsidian notes using predefined templates
- Blocks incorrect tool usage before execution
- Validates output compliance after generation

## Primary Use Cases

- **Literature Review Management**: Automatic PubMed citation verification with PMID enforcement
- **Research Question Documentation**: Structured templates for grant-ready research questions
- **Concept Note Creation**: Wiki-linked knowledge base entries with validation requirements
- **Daily Research Journals**: Progress tracking with automatic date-based organization
- **Knowledge Graph Building**: Memory MCP integration for persistent concept storage
- **Multi-Vault Support**: Separate Obsidian vaults for different research areas

## System Components

### MCP Servers (6 total)
1. **Sequential Thinking** - Task decomposition and planning
2. **PubMed** - Citation search and verification (35+ million articles)
3. **Memory** - Persistent knowledge graph storage
4. **Filesystem** - Local project file access
5. **Obsidian REST (Primary)** - Main vault operations (port 27124)
6. **Obsidian REST (Journal)** - Journal vault operations (port 27125)

### Enforcement Hooks
- **Pre-command validation** (`pre-command.sh`) - Displays requirements before execution
- **Task router** (`task-router.py`) - Detects and routes Obsidian tasks
- **Compliance validator** (`compliance-validator.sh`) - Blocks incorrect tool usage
- **Post-command validator** (`post-command.py`) - Verifies output compliance

### Templates
- Research question template with grant-ready sections
- Concept template with implementation guides
- Daily journal template with metrics tracking

## Example Workflows

### Research Question Creation
```
You: "What evidence exists for MFI thresholds predicting transplant outcomes?"

Claude: [Researches and provides comprehensive answer with citations]

You: "Create this research question and its concept pages in my Obsidian vault"

System automatically:
1. Task router detects "obsidian vault" → triggers enforcement
2. Routes to primary vault (port 27124) for research content
3. Creates note in /Research Questions/ folder
4. Generates concept pages in /Concepts/ folder
5. Enforces (Author et al., Year, PMID: XXXXXXXX) format
6. Adds wiki links between related concepts
7. Validates all citations have PMIDs
```

### Daily Journal Entry
```
You: "I'm done for today, create a research journal entry"

System automatically:
1. Task router detects "journal" → routes to journal vault (port 27125)
2. Creates entry in /Daily/ folder with today's date
3. Summarizes session accomplishments
4. Lists all research questions explored
5. Documents key findings with citations
6. Notes problems solved and next steps
```

## Requirements

### Required Software
- **Claude Desktop** (Claude Code) with API access
- **VS Code** or compatible editor
- **Obsidian** with Local REST API plugin installed
- **Node.js** v16+ and npm
- **Python** 3.8+ (for validation hooks)
- **Git** for repository management

### API Requirements
- **Claude Code API** key configured
- **Obsidian REST API** bearer token generated
- **PubMed API** (email address recommended for higher rate limits)

### Operating System
- **macOS**: Native support
- **Linux**: Native support
- **Windows**: Requires WSL (Windows Subsystem for Linux)

## Installation

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

The setup script:
- Installs 4 MCP servers automatically
- Configures hook system with proper permissions
- Sets up dynamic path resolution
- Provides Obsidian configuration template

Manual steps required:
1. Install Obsidian Local REST API plugin
2. Configure bearer token and ports
3. Add MCP configurations to Claude Desktop
4. Create vault folder structure

## Documentation

- [`docs/SETUP.md`](docs/SETUP.md) - Detailed setup instructions
- [`docs/SETUP_CHECKLIST.md`](docs/SETUP_CHECKLIST.md) - Interactive setup checklist
- [`docs/MCP_INFO.md`](docs/MCP_INFO.md) - MCP server details
- [`docs/CUSTOMIZATION.md`](docs/CUSTOMIZATION.md) - Customization guide
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) - Common issues and solutions

## Customization

The system can be adapted for different research domains by modifying:
- `.claude/agents/research-director.md` - Template specifications
- `.claude/config/verification.json` - Validation rules
- `.claude/hooks/` - Enforcement scripts
- `CLAUDE.md` - Routing rules and priorities

## Support

- **Issues**: [GitHub Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues)
- **Templates**: `/templates/obsidian/` directory
- **Logs**: `.claude/logs/` for debugging

## License

This project is provided as-is for research use. See LICENSE file for details.

---

**[Setup Guide →](docs/SETUP.md)** | **[Documentation](docs/)** | **[Report Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues)**