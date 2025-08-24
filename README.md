# VERITAS - Verification-Enforced Research Infrastructure with Tracking and Automated Structuring

A Claude-powered research framework ensuring academic rigor through enforced citations, intelligent conversation tracking, and automated documentation generation.

**Repository**: `VERITAS` (formerly HLA_Agent-MCP_System)

## About VERITAS

VERITAS (Verification-Enforced Research Infrastructure with Tracking and Automated Structuring) embodies the core principle of truth in research. Every claim must be verified, every source must be cited, and every conversation is tracked to maintain complete research integrity.

The name VERITAS, Latin for "truth," reflects our commitment to:
- **Verification-Enforced** citations with mandatory PMID requirements
- **Research Infrastructure** providing comprehensive framework
- **Tracking** of all conversations and sources
- **Automated Structuring** of research content
- **Scientific** integrity through active validation

**GitHub**: https://github.com/VMWM/VERITAS

## What VERITAS Does

VERITAS creates a multi-layer enforcement framework that:
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

### MCP Servers (7 total)

#### Third-Party MCP Servers (via npm)
1. **Sequential Thinking** - Task decomposition and planning
2. **PubMed** - Citation search and verification (35+ million articles)
3. **Memory** - Persistent knowledge graph storage
4. **Filesystem** - Local project file access

#### Obsidian Integration (via REST API)
5. **Obsidian REST (Primary)** - Main vault operations (port 27124)
6. **Obsidian REST (Journal)** - Journal vault operations (port 27125)

#### Custom-Built MCP Server (included in this repository)
7. **Conversation Logger** - Conversation tracking and journal generation
   - Built specifically for this system
   - Source code in `conversation-logger/` directory
   - Fully customizable and extendable

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
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
chmod +x setup.sh
./setup.sh

# After setup completes, configure Claude:
./scripts/configure-claude.sh
```

The setup process handles everything:
- `setup.sh`: Installs all MCP servers and dependencies
- `configure-claude.sh`: Interactive configuration with multiple options:
  - Merges with or replaces existing configurations
  - Creates automatic backups of existing configs
  - Offers symlink option for unified Desktop/CLI management
  - Supports multi-machine synchronization via cloud directories
- Both interfaces get identical MCP server configurations
- Configures hook system with proper permissions
- Sets up dynamic path resolution
- Creates database directories

Manual steps required:
1. Install Obsidian Local REST API plugin (if using Obsidian)
2. Configure bearer token and ports
3. Create vault folder structure

## Documentation

**[📚 Documentation Hub](docs/README.md)** - All documentation organized by audience

### Quick Links
- **[🚀 Quick Start](docs/user/QUICK_START.md)** - Get running in 5 minutes
- **[📖 Full Installation](docs/user/INSTALLATION.md)** - Detailed setup
- **[⚙️ Configuration](docs/user/CONFIGURATION.md)** - All options explained
- **[🔧 Troubleshooting](docs/user/TROUBLESHOOTING.md)** - Fix common issues
- **[🔄 Multi-Machine Sync](docs/user/MULTI_MACHINE.md)** - Advanced setup

## Customization

See **[Developer Documentation](docs/developer/)** for customization options:
- **[Customization Guide](docs/developer/CUSTOMIZATION.md)** - Adapt for your domain
- **[MCP Servers](docs/developer/MCP_SERVERS.md)** - Technical details
- **[Conversation Logger](docs/developer/CONVERSATION_LOGGER.md)** - Logger API

## Support

- **Documentation**: [📚 Documentation Hub](docs/README.md)
- **Issues**: [GitHub Issues](https://github.com/VMWM/VERITAS/issues)
- **Templates**: [/templates/](templates/) directory

## License

MIT License - See [LICENSE](LICENSE) file for details.

---

**[Setup Guide →](docs/SETUP.md)** | **[Documentation](docs/)** | **[Report Issues](https://github.com/VMWM/VERITAS/issues)**