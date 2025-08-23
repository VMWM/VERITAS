# Complete Setup Guide

This guide walks through the complete setup of the Research Agent-MCP System.

## Prerequisites

### Required Software
- Claude Desktop (Claude Code)
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
git clone https://github.com/[your-username]/Research_Agent-MCP_System.git
cd Research_Agent-MCP_System
```

### 2. Run Automated Setup

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Check prerequisites
- Install all MCP servers
- Copy configuration files
- Set proper permissions
- Configure paths

### 3. Configure Claude Desktop

Open your Claude Desktop configuration file:
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

Add the MCP server configurations provided by the setup script.

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

#### Update CLAUDE.md
Edit the PROJECT CONTEXT section:
- Add your project description
- Set your timeline
- Update directory paths

#### Customize Templates
Templates are in `templates/obsidian/`:
- `research_question_template.md`
- `concept_template.md`
- `daily_journal_template.md`

### 6. Test the System

#### Test MCP Servers
```bash
# In Claude Desktop, test each MCP:
"Test sequential thinking by planning a task"
"Search PubMed for a recent paper"
"Store a concept in memory"
"Read a file from the project"
```

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

## Directory Structure

After setup, your project should have:

```
Your_Project/
├── CLAUDE.md                    # Main configuration
├── .claude/
│   ├── agents/
│   │   └── research-director.md # Templates and workflows
│   ├── config/
│   │   └── verification.json    # Validation rules
│   ├── hooks/                  # Enforcement scripts
│   ├── scripts/                 # Additional tools
│   ├── logs/                    # System logs
│   └── settings.local.json     # Hook configuration
└── [Your project files]
```

## Troubleshooting

See `docs/TROUBLESHOOTING.md` for common issues and solutions.

## Next Steps

1. Review `docs/MCP_INSTALLATION.md` for MCP details
2. Study templates in `templates/obsidian/`
3. Read agent documentation in `.claude/agents/`
4. Start creating research content!

## Support

- GitHub Issues: Report problems
- Documentation: Check `/docs` folder
- Templates: See `/templates` folder