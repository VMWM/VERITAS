# Complete Setup Guide

This guide walks through the complete setup of the Research Agent-MCP System.

## Prerequisites

### Required Software
- Claude Desktop application
- Claude Code CLI (installed via npm)
- Node.js and npm (v16 or higher)
- Obsidian with Local REST API plugin
- Python 3.8+ (for validation hooks)
- Bash shell

### System Requirements
- macOS, Linux, or WSL on Windows
- 4GB RAM minimum
- Internet connection for MCP installation

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
```

### 2. Run Automated Setup

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Check prerequisites
- Install all MCP servers
- Copy configuration files (including .claude directory)
- Copy agent reference documents with templates
- Set proper permissions for all hooks
- Configure paths dynamically in settings
- **Configure conversation logger cleanup** (interactive prompt)
- Display configuration to copy

#### Conversation Logger Cleanup

During setup, you'll be asked about automatic log cleanup:
- **5-day retention**: Keeps last 5 days of conversations
- **Automatic cleanup**: Optional 2 AM daily cron job
- **Manual option**: Run `node conversation-logger/cleanup-old-logs.js` as needed

This prevents unlimited database growth while preserving recent research history.

After setup.sh completes, run:
```bash
./scripts/configure-claude.sh
```

This configuration script will:
- Detect existing Claude configurations
- Offer to merge with or replace existing configs
- Create backups of any existing configurations
- Set up both Claude Desktop and CLI with identical MCP servers
- Optionally create symlinks for unified configuration management

#### Configuration Options

The script offers several configuration strategies:

**1. Merge vs Replace**
- **Merge** (recommended): Adds VERITAS servers to your existing configuration
- **Replace**: Creates fresh configuration (backs up existing)
- **Preview**: Shows what will be added without making changes

**2. Separate vs Symlinked Configs**
- **Separate configs** (default): Desktop and CLI have independent configuration files
  - Best for: Single machine setups
  - Changes must be made to each file separately
- **Symlinked configs**: Both Desktop and CLI use the same configuration file
  - Best for: Keeping Desktop and CLI in perfect sync
  - Changes to one automatically affect the other
  - The CLI config (~/.claude.json) becomes the master file

**3. Multi-Machine Synchronization**
For syncing configurations across multiple machines:
1. Place your master config in a cloud-synced directory (iCloud/Dropbox/etc)
2. Create symlinks from all Claude config locations to the cloud file
3. All machines will automatically stay in sync

Example multi-machine setup:
```bash
# Create master config in iCloud
cp ~/.claude.json ~/Library/Mobile\ Documents/com~apple~CloudDocs/claude-config.json

# Symlink from all locations
ln -sf ~/Library/Mobile\ Documents/com~apple~CloudDocs/claude-config.json ~/.claude.json
ln -sf ~/Library/Mobile\ Documents/com~apple~CloudDocs/claude-config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### 3. Configuration Complete

After running `configure-claude.sh`:
- Both Claude Desktop and CLI have identical MCP server configurations
- Backups are created with timestamps if you had existing configs
- Your chosen configuration strategy is applied (separate/symlinked)
- Project .mcp.json is symlinked to CLI config for consistency

Copy the entire JSON configuration provided by the setup script.

**Important:** Make sure the file contains valid JSON only - no comments or extra text.

#### Step 2: Restart Claude Desktop
Completely quit and restart Claude Desktop to load the MCP servers.

#### Step 3: Configure Claude Code CLI
After Claude Desktop is configured and running, import the servers to Claude Code CLI:

```bash
claude mcp add-from-claude-desktop
```

When prompted:
1. Use arrow keys to navigate
2. Press Space to select/deselect servers
3. Select all servers (they should have checkmarks)
4. Press Enter to confirm

#### Step 4: Verify Configuration
```bash
# Check that servers are imported
claude mcp list

# Test in a new Claude session
claude
> /mcp  # Should show your configured servers
```

### 4. Configure Obsidian

#### Install REST API Plugin
1. Open Obsidian
2. Settings → Community Plugins → Browse
3. Search for "Local REST API"
4. Install and Enable

#### Configure Authentication
1. In plugin settings, enable authentication
2. Generate a bearer token
3. Note the port number (default: 27124)

#### Create Vault Structure
```
Your Vault/
├── Research Questions/
├── Concepts/
└── Daily/
```

### 5. Project Configuration

#### Customize CLAUDE.md
The setup script copies CLAUDE.md from templates/CLAUDE.md.template.
Edit it to match your project:
- Update PROJECT CONTEXT with your project details
- Configure ROUTING RULES for your workflow
- Set TOOL PRIORITIES for your domain
- Add CITATION REQUIREMENTS as needed

#### Customize Templates
Templates are in `templates/obsidian/`:
- `research_question_template.md`
- `concept_template.md`
- `daily_journal_template.md`

### 6. Test the System

#### Test MCP Servers in Claude Code CLI
```bash
# Start Claude Code
claude

# Check MCP servers are available
/mcp

# Test each MCP:
"Use sequential thinking to plan a research task"
"Search PubMed for papers on HLA antibodies"
"Store a concept about antibody testing in memory"
"Read the CLAUDE.md file from my project"
```

#### Test MCP Servers in Claude Desktop
Open Claude Desktop and test with similar commands.

#### Test Obsidian Integration
```
"Create a research question about [topic] in my vault"
```

Success indicators:
- Uses `mcp__obsidian-rest__*` tools
- Creates file in correct location
- Follows template structure
- Includes PMID citations

## Environment Variables

Optional environment variables for advanced configuration:

```bash
export OBSIDIAN_TOKEN="your-bearer-token"
export OBSIDIAN_PRIMARY_PORT="27124"
export OBSIDIAN_JOURNAL_PORT="27125"
export PROJECT_ROOT="/path/to/project"
```

## Hook System

The system includes several hooks that run automatically:

### Pre-Command Hook
- Location: `.claude/hooks/pre-command.sh`
- Purpose: Display requirements before commands
- Runs: On every user prompt

### Task Router
- Location: `.claude/hooks/task-router.py`
- Purpose: Route tasks to correct tools
- Runs: When Obsidian tasks detected

### Compliance Validator
- Location: `.claude/hooks/compliance-validator.sh`
- Purpose: Block incorrect tool usage
- Runs: Before tool execution

### Post-Command Validator
- Location: `.claude/hooks/post-command.py`
- Purpose: Verify output compliance
- Runs: After content generation

## What Gets Installed

### MCP Servers (Software)
These are actual programs that need installation:
- Sequential Thinking MCP - For task planning
- PubMed MCP - For citation search
- Memory MCP - For knowledge storage
- Filesystem MCP - For file access
- Obsidian REST (configured separately)

### Configuration Files (Copied)
These are configuration and reference files:
- **CLAUDE.md** - Main instructions and routing rules
- **research-director.md** - Detailed templates (not software, just reference)
- **Hooks** - Python/Bash scripts for enforcement
- **Templates** - Obsidian note templates
- **settings.local.json** - Hook configuration

Note: The "agent" (research-director.md) is just a reference document with templates, not software that runs. It's automatically included when the .claude directory is copied.

## Directory Structure

After setup, your project should have:

```
Your_Project/
├── CLAUDE.md                    # Main configuration
├── .claude/
│   ├── agents/
│   │   └── research-director.md # Templates and workflows (reference doc)
│   ├── config/
│   │   └── verification.json    # Validation rules
│   ├── hooks/                  # Enforcement scripts
│   ├── scripts/                 # Additional tools
│   ├── logs/                    # System logs
│   └── settings.local.json     # Hook configuration (auto-generated)
└── [Your project files]
```

## Troubleshooting

See `docs/TROUBLESHOOTING.md` for common issues and solutions.

## Next Steps

1. Review `docs/MCP_INFO.md` for MCP details
2. Study templates in `templates/obsidian/`
3. Read agent documentation in `.claude/agents/`
4. Start creating research content!

## Support

- GitHub Issues: Report problems
- Documentation: Check `/docs` folder
- Templates: See `/templates` folder
