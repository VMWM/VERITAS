<p align="center">
  <img src="assets/VERITAS.png" alt="VERITAS" width="600">
</p>

# VERITAS
Verification-Enforced Research Infrastructure with Tracking and Automated Structuring

A Claude Code research infrastructure that enforces citation compliance, validates scientific claims in real-time, and automatically structures your knowledge base.

## Table of Contents

- [About VERITAS](#about-veritas)
- [What VERITAS Does](#what-veritas-does)
- [System Architecture](#how-veritas-works---system-architecture)
- [Primary Use Cases](#primary-use-cases)
- [System Components](#system-components)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#after-installation---critical-steps)
- [Example Workflows](#example-workflows)
- [Documentation](#documentation)
- [FAQ](#frequently-asked-questions)
- [Support](#support)
- [Contributing](#contributing)
- [License](#license)

## About VERITAS

VERITAS embodies the core principle of truth in research. Every claim must be verified, every source must be cited, and every process is tracked to maintain complete research integrity.

- **Verification-Enforced** - Active enforcement of citation requirements and validation through hooks and compliance checks
- **Research Infrastructure** - The comprehensive framework and tools providing a complete research environment
- **Tracking and Automated Structuring** - Intelligent organization and documentation of all research activities

**GitHub**: https://github.com/VMWM/VERITAS

## What VERITAS Does

VERITAS creates a multi-layer guidance and validation framework that:
- **Routes research tasks** to appropriate MCP tools through task detection and guidance
- **Enforces PMID citation requirements** through instruction compliance and reminders
- **Creates properly formatted Obsidian notes** using predefined templates in CLAUDE.md
- **Guides tool usage** through pre-execution warnings and workflow recommendations
- **Validates output compliance** after generation (NOW IMPLEMENTED via post-command.sh)

### How VERITAS Works - System Architecture

```
User Message → Pre-Command Hooks → Claude Processes → Tool Calls → POST-VALIDATION → Response
                    ↓                      ↓                            ↓
              (Shows reminders)    (Reads CLAUDE.md)         (Checks what was created)
                    ↓                      ↓                            ↓
              (Sets env vars)     (Follows instructions)    (Logs violations & reports)
```

This architecture ensures multiple checkpoints for compliance:
1. **Pre-Command**: Displays requirements and routing guidance
2. **During Processing**: Claude follows CLAUDE.md instructions
3. **Post-Execution**: Validates actual output and logs any violations

## Primary Use Cases

- **Literature Review Management**: Automatic PubMed citation verification with PMID enforcement
- **Research Question Documentation**: Structured templates for grant-ready research questions
- **Concept Note Creation**: Wiki-linked knowledge base entries with validation requirements
- **Progress Tracking**: Progress tracking with automatic date-based organization
- **Knowledge Graph Building**: Memory MCP and Conversation Logging integration for persistent concept storage

## System Components

### MCP Servers (7 total)

#### Third-Party MCP Servers (via npm)
1. **Sequential Thinking** - Task decomposition and planning
2. **PubMed** - Citation search and verification (35+ million articles)
3. **Memory** - Persistent knowledge graph storage
4. **Filesystem** - Local project file access

#### Obsidian Integration (via REST API)
5. **Obsidian REST (Primary)** - Main vault operations
6. **Obsidian REST (Journal)** - Journal vault operations

#### Custom-Built MCP Server (included in this repository)
7. **Conversation Logger** - Conversation tracking and journal generation
   - Built specifically for this system
   - Source code in `conversation-logger/` directory
   - Fully customizable and extendable
   - **5-day retention policy**: Automatically maintains last 5 days of conversations
   - **Automatic cleanup**: Optional 2 AM daily cleanup via cron job
   - **Database management**: SQLite database at `~/.conversation-logger/conversations.db`

### Enforcement Hooks
- **Pre-command validation** (`pre-command.sh`) - Displays requirements before execution
- **Task router** (`task-router.py`) - Detects and routes Obsidian tasks
- **Compliance validator** (`compliance-validator.sh`) - Blocks incorrect tool usage
- **Post-command validator** (`post-command.py`) - Verifies output compliance

### Templates
- Research question template with grant-ready sections
- Concept template with implementation guides
- Daily journal template with metrics tracking

## Project Structure

VERITAS follows a clean, organized directory structure:

```
VERITAS/
├── .claude/                    # Claude-specific configuration
│   ├── agents/                # Agent templates
│   ├── config/               # Configuration files  
│   ├── hooks/                # All validation and enforcement hooks
│   ├── logs/                 # Validation and verification logs
│   └── settings.local.json.template
├── conversation-logger/       # Custom MCP server for conversation tracking
├── docs/                      # Documentation
│   ├── getting-started.md    # Complete installation guide
│   ├── obsidian-integration.md # Obsidian vault setup
│   ├── customization.md      # Domain adaptation
│   ├── troubleshooting.md    # Problem solving
│   ├── quick_reference.md    # Command reference
│   └── reference/            # Technical documentation
│       ├── mcp-servers.md   # MCP server details
│       └── conversation_logger.md # Logger deep-dive
├── scripts/                   # Utility scripts
│   ├── setup/                # Setup and configuration scripts
│   │   └── configure-claude.sh
│   └── utils/                # Utility and maintenance scripts
│       ├── obsidian-enforcer.py
│       └── startup-check.sh
├── templates/                 # Project templates
│   ├── agents/               # Domain expert examples
│   ├── obsidian/             # Obsidian note templates
│   └── claude.md             # Main project instructions template
├── tests/                     # Test scripts
│   └── veritas-functional-test.md # Installation verification
├── assets/                    # Images and resources
├── setup.sh                   # Main installation script
├── README.md                  # This file
├── license                    # MIT License
└── .gitignore
```

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

## Output Validation System

VERITAS includes a comprehensive post-execution validation system that automatically checks all created content for compliance with formatting and citation requirements.

### What Gets Validated

The validation system checks:
- **File Extensions**: All Obsidian files must have `.md` extension
- **Table Formatting**: Tables must have spaces around pipes `| Cell |`
- **Citation Compliance**: Medical claims must have PMID citations
- **Wiki Link Format**: Multi-word concepts use underscores `[[De_Novo_DSA]]`
- **Character Escaping**: No `\n` or HTML entities like `&gt;`
- **Header Formatting**: No underscores in H1 headings

### Validation Reports

After each operation, the system:
1. Scans files modified in the last 5 minutes
2. Checks against all formatting rules
3. Logs violations to `.claude/logs/validation-YYYYMMDD.log`
4. Displays summary with fix instructions
5. Provides auto-fix commands when available

### Example Validation Output

```
POST-EXECUTION VALIDATOR
============================
Output Validation: PASSED
All recently created files meet formatting requirements
============================
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
- **Windows**: Via WSL2 (Windows Subsystem for Linux)

### Prerequisites Check

Run this command to verify your system is ready:

```bash
# Check all prerequisites at once
echo "Checking prerequisites..." && \
command -v node >/dev/null 2>&1 && echo "[OK] Node.js: $(node -v)" || echo "[MISSING] Node.js: Not installed" && \
command -v npm >/dev/null 2>&1 && echo "[OK] npm: $(npm -v)" || echo "[MISSING] npm: Not installed" && \
command -v python3 >/dev/null 2>&1 && echo "[OK] Python: $(python3 --version)" || echo "[MISSING] Python 3: Not installed" && \
command -v git >/dev/null 2>&1 && echo "[OK] Git: $(git --version)" || echo "[MISSING] Git: Not installed" && \
command -v claude >/dev/null 2>&1 && echo "[OK] Claude CLI: Installed" || echo "[WARNING] Claude CLI: Not installed (optional)" && \
[ -d "/Applications/Claude.app" ] && echo "[OK] Claude Desktop: Installed" || echo "[WARNING] Claude Desktop: Check manually"
```

## Installation

**CRITICAL**: Many setup issues are caused by missed steps. Follow the [Getting Started Guide](docs/getting-started.md) for guaranteed success, or see [Troubleshooting Guide](docs/troubleshooting.md) if you encounter problems.

### Quick Installation

```bash
# 1. Clone and setup
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
./setup.sh

# 2. Configure Claude
./scripts/setup/configure-claude.sh

# 3. Restart Claude and test
# Use prompts from: tests/veritas-functional-test.md
```

### Automated Installation with Claude Code

If you're already using Claude Code, copy and paste this prompt for automated setup:

```
Please install VERITAS from https://github.com/VMWM/VERITAS.git for me.

1. Clone it to ~/VERITAS in my home directory
2. Run ./setup.sh and when prompted:
   - Enter my current directory as the project directory
   - Choose 'y' for automatic 2 AM conversation cleanup
3. Source the environment file: source [project-dir]/.claude/env.sh
4. Run ./scripts/configure-claude.sh and choose:
   - Option 1 (merge with existing)
   - Option 1 (separate config files)
5. Verify servers loaded: claude mcp list

After you're done, remind me of these MANUAL steps I must do:
- Install Obsidian Local REST API plugin
- Enable HTTPS server (NOT HTTP) in plugin settings
- Set ports: 27124 (main), 27125 (journal)
- Generate and save bearer token
- Export OBSIDIAN_API_TOKEN="[token]"
- Create vault folders: Research Questions/, Concepts/, Daily/
- Keep Obsidian running while using Claude
- Restart Claude Desktop completely
```

## After Installation - Critical Steps

**Before using Claude with VERITAS, you MUST:**

1. **Source the environment** (once, or add to shell profile):
   ```bash
   source ~/your-project/.claude/env.sh
   # OR add to ~/.bashrc or ~/.zshrc for automatic loading
   ```
   Note: If you always work from your project directory, the hooks will work without this

2. **Keep Obsidian running** with your vaults open

3. **Verify everything works**:
   ```bash
   # Check environment
   echo $CLAUDE_PROJECT_DIR
   
   # Check MCP servers
   claude mcp list
   
   # Test in Claude
   "Generate a test journal entry"
   ```

4. **If something doesn't work**, see [Troubleshooting Guide](docs/troubleshooting.md)

## Documentation

### Getting Started
- [Installation Guide](docs/getting-started.md) - Complete setup instructions
- [Functional Test Prompts](tests/veritas-functional-test.md) - Verify your setup
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues

### Configuration
- [Obsidian Integration](docs/obsidian-integration.md) - Connect your research vault
- [Customization Guide](docs/customization.md) - Adapt for your research domain
- [Quick Reference](docs/quick_reference.md) - Command cheat sheet

### Technical Reference
- [MCP Server Details](docs/reference/mcp-servers.md) - Server specifications
- [Conversation Logger](docs/reference/conversation_logger.md) - Session tracking system
- [Domain Expert Templates](templates/agents/README.md) - Customize for your field

## Frequently Asked Questions

**Q: Do I need Obsidian to use VERITAS?**
A: No, but Obsidian integration provides the best experience for research documentation. VERITAS works with any text editor for basic functionality.

**Q: Can I customize VERITAS for my research domain?**
A: Yes! See the [Customization Guide](docs/customization.md) for adapting templates, citation formats, and validation rules to your field.

**Q: How does VERITAS compare to other research tools?**
A: VERITAS is unique in providing real-time citation enforcement, automatic validation, and integrated knowledge management specifically for Claude Code users.

**Q: What happens if I don't follow the citation requirements?**
A: The validation system will flag violations in post-execution reports and guide you to fix them. Critical violations may block certain operations.

**Q: Can I use VERITAS with multiple research projects?**
A: Yes! Each project gets its own CLAUDE.md file and can have different validation rules and templates.

## Support

Having issues? Try these resources:

1. Check [Troubleshooting Guide](docs/troubleshooting.md)
2. Review [Functional Tests](tests/veritas-functional-test.md)
3. Open an [issue on GitHub](https://github.com/VMWM/VERITAS/issues)

## Contributing

We welcome contributions! Areas where help is needed:
- Domain-specific templates for different research fields
- Additional MCP server integrations
- Documentation improvements
- Bug fixes and testing

Submit issues and PRs to: https://github.com/VMWM/VERITAS

## License

MIT License - See [license](license) file for details

## Acknowledgments

- Built for the Claude Code community
- Inspired by research best practices
- MCP (Model Context Protocol) by Anthropic
- Special thanks to all beta testers and contributors