# Repository Structure

This document describes the organization of the HLA Agent-MCP System repository.

## Directory Layout

```
HLA_Agent-MCP_System/
│
├── 📄 Core Files
│   ├── README.md                    # Main repository documentation
│   ├── LICENSE                      # MIT License
│   ├── CLAUDE.md                    # Claude Code instructions
│   ├── setup.sh                     # Main installation script
│   ├── STRUCTURE.md                 # This file
│   └── .gitignore                   # Git ignore rules
│
├── 📁 .claude/                      # Claude-specific configuration
│   ├── agents/                      # Agent configurations
│   │   └── research-director.md     # Research workflow templates
│   ├── hooks/                       # Hook scripts for enforcement
│   │   ├── compliance-validator.sh  # Validates compliance
│   │   ├── first-response.py        # Initial response handler
│   │   ├── post-command.py          # Post-execution validator
│   │   ├── pre-command.sh           # Pre-execution checks
│   │   └── task-router.py           # Routes tasks to tools
│   └── settings.local.json.template # Settings template
│
├── 📁 scripts/                      # Utility scripts
│   ├── startup-check.sh            # System startup checks
│   └── obsidian-enforcer.py        # Obsidian format enforcement
│
├── 📁 conversation-logger/          # Conversation tracking MCP server
│   ├── README.md                   # Module documentation
│   ├── package.json                # Node.js dependencies
│   ├── index.js                    # Main MCP server
│   ├── obsidian-journal-generator.js # Journal generation
│   └── configure.sh                # Configuration script
│
├── 📁 docs/                         # Documentation
│   ├── README.md                   # Documentation index
│   ├── SETUP.md                    # Installation guide
│   ├── SETUP_CHECKLIST.md          # Setup verification
│   ├── CONVERSATION_LOGGER.md      # Conversation logger guide
│   ├── MCP_INFO.md                 # MCP server details
│   ├── CUSTOMIZATION.md            # Customization guide
│   └── TROUBLESHOOTING.md          # Problem solving
│
└── 📁 templates/                    # Templates
    └── obsidian/                   # Obsidian templates
        ├── concept_template.md      # Concept note template
        ├── daily_journal_template.md # Journal template
        └── research_question_template.md # Research template
```

## File Purposes

### Core Files
- **README.md**: Main entry point for users, overview of the system
- **LICENSE**: MIT license for open-source distribution
- **CLAUDE.md**: Instructions loaded by Claude Code for every session
- **setup.sh**: Automated installation of all components
- **.gitignore**: Comprehensive ignore rules for the entire project

### .claude/ Directory
Configuration specific to Claude Code:
- **agents/**: Contains agent behavior definitions and templates
- **hooks/**: Scripts that intercept and validate Claude's actions
- **settings.local.json.template**: Template for local configuration

### scripts/ Directory
Standalone utility scripts:
- **startup-check.sh**: Verifies system is properly configured
- **obsidian-enforcer.py**: Ensures Obsidian formatting compliance

### conversation-logger/ Directory
Complete MCP server for conversation tracking:
- Self-contained Node.js application
- Provides persistent memory across sessions
- Generates journals from conversation history

### docs/ Directory
Comprehensive documentation:
- Each aspect of the system thoroughly documented
- Step-by-step guides for all features
- Troubleshooting for common issues

### templates/ Directory
Ready-to-use templates for Obsidian:
- Research question documentation
- Concept notes
- Daily journals

## Design Principles

1. **Clear Separation**: Each directory has a specific purpose
2. **Self-Contained Modules**: conversation-logger can work independently
3. **Comprehensive Documentation**: Every feature is documented
4. **Single Source of Truth**: One .gitignore, one main README
5. **Logical Grouping**: Related files are kept together

## Navigation Tips

- Start with `README.md` for overview
- Check `docs/README.md` for detailed documentation
- Run `setup.sh` for automatic installation
- Modify `CLAUDE.md` for project-specific settings
- Use `templates/` for consistent documentation