<p align="center">
  <img src="assets/VERITAS.png" alt="VERITAS" width="600">
</p>

# VERITAS
Verification-Enforced Research Infrastructure with Tracking and Automated Structuring

A Claude Code research infrastructure that enforces citation compliance, validates scientific claims in real-time, and automatically structures your knowledge base.


## About VERITAS

VERITAS embodies the core principle of truth in research. Every claim must be verified, every source must be cited, and every process is tracked to maintain complete research integrity.

- **Verification-Enforced** - Active enforcement of citation requirements and validation through hooks and compliance checks
- **Research Infrastructure** - The comprehensive framework and tools providing a complete research environment
- **Tracking and Automated Structuring** - Intelligent organization and documentation of all research activities

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

## Installation

⚠️ **CRITICAL**: Many setup issues are caused by missed steps. Follow the **[Setup Checklist](SETUP_CHECKLIST.md)** for guaranteed success, or see **[Common Setup Errors](docs/user/SETUP_ERRORS.md)** if you encounter problems.

### What's Automated vs. Manual

**✅ Automated by setup.sh:**
- All MCP server installations (7 servers)
- Hook scripts and configuration files
- Environment variable setup (.claude/env.sh)
- Path configuration in settings
- Conversation logger with optional cleanup
- CLAUDE.md template placement

**⚠️ Manual Steps Required:**
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
- ✅ Installs all 7 MCP servers via npm/npx
- ✅ Copies .claude directory with hooks and configs
- ✅ Creates environment configuration file
- ✅ Sets executable permissions on all hooks
- ✅ Configures conversation logger with retention settings
- ✅ Creates project structure and logs directory
- ✅ Generates customized settings.local.json

**configure-claude.sh automatically:**
- ✅ Updates Claude Desktop configuration
- ✅ Creates backups of existing configs
- ✅ Syncs Desktop and CLI configurations
- ✅ Sets up MCP server paths
- ✅ Handles multi-machine sync options

**You must manually:**
- ⚠️ Install and configure Obsidian plugin
- ⚠️ Create vault folder structure
- ⚠️ Restart Claude Desktop
- 💡 Source environment file (optional if working from project directory)

### Required Manual Steps for Obsidian:

⚠️ **IMPORTANT: Obsidian must be running with your vaults open for the MCP servers to work!**

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

## Support

- **Documentation**: [Documentation Hub](docs/README.md)
- **Issues**: [GitHub Issues](https://github.com/VMWM/VERITAS/issues)
- **Templates**: [/templates/](templates/) directory

## License

MIT License - See [LICENSE](LICENSE) file for details.

---

**[Quick Start →](docs/user/QUICK_START.md)** | **[Documentation](docs/)** | **[Report Issues](https://github.com/VMWM/VERITAS/issues)**
