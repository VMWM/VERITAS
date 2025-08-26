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
│   ├── developer/            # Developer documentation
│   │   ├── CONVERSATION_LOGGER.md
│   │   ├── CUSTOMIZATION.md
│   │   └── MCP_SERVERS.md
│   ├── user/                 # User guides
│   │   ├── CONFIGURATION.md
│   │   ├── INSTALLATION.md
│   │   ├── MULTI_MACHINE.md
│   │   ├── QUICK_START.md
│   │   ├── SETUP_ERRORS.md
│   │   └── TROUBLESHOOTING.md
│   ├── MCP_INSTALLATION.md  # MCP server setup guide
│   ├── TROUBLESHOOTING.md   # Main troubleshooting guide
│   ├── SETUP_CHECKLIST.md   # Installation checklist
│   └── README.md             # Documentation overview
├── scripts/                   # Utility scripts
│   ├── setup/                # Setup and configuration scripts
│   │   └── configure-claude.sh
│   └── utils/                # Utility and maintenance scripts
│       ├── obsidian-enforcer.py
│       └── startup-check.sh
├── templates/                 # Project templates
│   ├── config/               # Configuration templates
│   ├── obsidian/             # Obsidian note templates
│   └── CLAUDE.md.template    # Main project instructions template
├── tests/                     # Test scripts
│   └── test-setup.sh         # Installation testing script
├── assets/                    # Images and resources
├── setup.sh                   # Main installation script
├── README.md                  # This file
├── LICENSE                    # MIT License
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

**CRITICAL**: Many setup issues are caused by missed steps. Follow the **[Setup Checklist](docs/SETUP_CHECKLIST.md)** for guaranteed success, or see **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)** if you encounter problems.

### What's Automated vs. Manual

**Automated by setup.sh:**
- All MCP server installations (7 servers)
- Hook scripts and configuration files
- Environment variable setup (.claude/env.sh)
- Path configuration in settings
- Conversation logger with optional cleanup
- CLAUDE.md template placement

**Manual Steps Required:**
1. **Source environment file** (critical!)
2. **Configure Claude Desktop/CLI** (run configure-claude.sh)
3. **Obsidian plugin setup** (install, enable HTTPS, generate token)
4. **Create vault folder structure**
5. **Restart Claude Desktop**

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

### Manual Installation

Alternatively, you can install manually:

```bash
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
chmod +x setup.sh
./setup.sh

# After setup completes, configure Claude:
./scripts/configure-claude.sh
```

#### What the setup scripts do:

**setup.sh automatically:**
- Installs all 7 MCP servers via npm/npx
- Copies .claude directory with hooks and configs
- Creates environment configuration file
- Sets executable permissions on all hooks
- Configures conversation logger with retention settings
- Creates project structure and logs directory
- Generates customized settings.local.json

**configure-claude.sh automatically:**
- Updates Claude Desktop configuration
- Creates backups of existing configs
- Syncs Desktop and CLI configurations
- Sets up MCP server paths
- Handles multi-machine sync options

**You must manually:**
- Install and configure Obsidian plugin
- Create vault folder structure
- Restart Claude Desktop
- Source environment file (optional if working from project directory)

### Required Manual Steps for Obsidian:

**IMPORTANT: Obsidian must be running with your vaults open for the MCP servers to work!**

1. **Install Obsidian Local REST API plugin**:
   - Open Obsidian Settings → Community Plugins
   - Search for "Local REST API"
   - Install and enable the plugin

2. **Configure the plugin**:
   - Go to plugin settings
   - **IMPORTANT**: Make sure "Enable Encrypted (HTTPS) Server" is ON (green checkmark)
   - The "Enable Non-encrypted (HTTP) Server" should be OFF (red X) for security
   - Generate a bearer token (save this - you'll need the exact full token!)
   - Set **Encrypted (HTTPS) Server Port** to 27124 for main vault
   - For journal vault: install plugin again, set **Encrypted (HTTPS) Server Port** to 27125

3. **Create vault folder structure**:
   - Main vault: Create folders for "Research Questions", "Concepts"
   - Journal vault: Create folder for "Daily"

4. **Set environment variable**:
   ```bash
   export OBSIDIAN_API_TOKEN="your-bearer-token-here"
   ```

5. **Keep Obsidian Running**:
   - Both vaults must be open in Obsidian while using Claude
   - The REST API only works when Obsidian is running
   - If Claude can't connect, check that Obsidian is open with the correct vaults

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

4. **If something doesn't work**, see [Setup Errors](docs/user/SETUP_ERRORS.md)

### Additional Manual Configuration:

If you installed manually without using `configure-claude.sh`, update these paths in your Claude configuration:

**For conversation-logger** - Update the path in your config files:
- Claude Desktop: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Claude CLI: `~/.claude.json`

Change `/path/to/conversation-logger/index.js` to your actual installation path, for example:
```json
"conversation-logger": {
  "command": "node",
  "args": ["/Users/yourname/VERITAS/conversation-logger/index.js"]
}
```

Note: The `configure-claude.sh` script handles these path updates automatically.



## Conversation Preservation & Privacy

VERITAS includes automatic conversation logging with intelligent retention management:

### Automatic Logging
- **SessionEnd Hook**: Conversations automatically logged when sessions end
- **No Manual Steps**: Logging happens transparently via hooks
- **Smart Capture**: Only logs substantial content (>10 chars)
- **Tool Tracking**: Records which tools were used in each conversation

### Data Retention
- **5-Day History Window**: Maintains last 5 days of research conversations
- **Automatic Cleanup**: Optional 2 AM daily cleanup removes older entries
- **Database Location**: All data stored locally in `~/.conversation-logger/conversations.db`
- **Privacy First**: No cloud storage - all conversations remain on your local machine

### Journal Generation
Generate comprehensive research journals from your conversations:
- Daily journals: "Create journal entry for today"
- Historical journals: "Create journal entry for 2025-01-20"
- Weekly summaries: "Generate weekly research summary"
- Session-based journals: All conversations are preserved for journal creation

### Automatic Features
- **Session Detection**: Logs activate via SessionEnd hook (no /exit required)
- **Content Filtering**: Skips empty or trivial messages
- **Database Management**: SQLite with automatic schema creation
- **Cleanup Schedule**: Configurable via cron (default: 2 AM daily)

### Manual Maintenance
- **View database stats**: `mcp__conversation-logger__get_session_stats`
- **Generate journal**: `mcp__conversation-logger__generate_journal`
- **Manual cleanup**: `node ~/VERITAS/conversation-logger/cleanup-old-logs.js`
- **Disable automatic cleanup**: Remove cron job with `crontab -e`

This ensures your research history is preserved for reference while preventing unlimited database growth.

## Documentation

**[Documentation Hub](docs/README.md)** - All documentation organized by audience

### Quick Links
- **[Quick Start](docs/user/QUICK_START.md)** - Get running in 5 minutes
- **[Full Installation](docs/user/INSTALLATION.md)** - Detailed setup
- **[Configuration](docs/user/CONFIGURATION.md)** - All options explained
- **[Troubleshooting](docs/user/TROUBLESHOOTING.md)** - Fix common issues
- **[Multi-Machine Sync](docs/user/MULTI_MACHINE.md)** - Advanced setup

## Customization

See **[Developer Documentation](docs/developer/)** for customization options:
- **[Customization Guide](docs/developer/CUSTOMIZATION.md)** - Adapt for your domain
- **[MCP Servers](docs/developer/MCP_SERVERS.md)** - Technical details
- **[Conversation Logger](docs/developer/CONVERSATION_LOGGER.md)** - Logger API

## Frequently Asked Questions

### General Questions

**Q: What makes VERITAS different from plain Claude Desktop?**
A: VERITAS adds research-specific enforcement layers, automatic citation validation, Obsidian integration for knowledge management, and conversation logging with journal generation.

**Q: Can I use VERITAS without Obsidian?**
A: Yes, but you'll lose the automatic knowledge base creation features. The citation enforcement and conversation logging still work.

**Q: Does VERITAS work with Claude.ai (web version)?**
A: No, VERITAS requires Claude Desktop (Claude Code) for MCP server support.

### Setup Issues

**Q: Why do I see "MCP server not found" errors?**
A: Usually means you haven't restarted Claude Desktop after installation. Completely quit and restart Claude Desktop.

**Q: Why aren't my Obsidian notes being created?**
A: Check that: 1) Obsidian is running, 2) REST API plugin is enabled with HTTPS, 3) Bearer token is correctly set in environment variables.

**Q: Can I use different port numbers for Obsidian?**
A: Yes! The setup script asks for your preferred ports. Default are 27124 (main) and 27125 (journal).

### Usage Questions

**Q: How do I trigger the conversation logger?**
A: It logs automatically. View logs with: `mcp__conversation-logger__generate_journal`

**Q: Can I customize the citation format?**
A: Yes, edit the validation rules in `.claude/hooks/post-command.sh`

**Q: How do I sync VERITAS across multiple machines?**
A: See [Multi-Machine Sync Guide](docs/user/MULTI_MACHINE.md)

## Support

- **Documentation**: [Complete Documentation Hub](docs/README.md)
- **Issues**: [GitHub Issues](https://github.com/VMWM/VERITAS/issues)
- **Discussions**: [GitHub Discussions](https://github.com/VMWM/VERITAS/discussions)
- **Contact**: Open an issue with the "question" label
- **Templates**: [/templates/](templates/) directory

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) (coming soon) for detailed guidelines.

## License

MIT License - See [LICENSE](LICENSE) file for details.

---

