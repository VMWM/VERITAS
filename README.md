# HLA Research MCP System - GitHub Copilot Edition

> **Branch**: `Github-Copilot-Setup`  
> **For Claude Code setup**: Switch to `Claude-Code-Setup` branch
> 
> **Note**: These branches are independent - each configured for its specific tool

## What This Is

A research system that brings MCP (Model Context Protocol) servers to GitHub Copilot in VS Code, enabling:
- PubMed literature search with PMID verification
- Obsidian note creation and management (via REST API - works from any folder)
- Sequential thinking for complex analysis
- Persistent memory storage (experimental)
- Local filesystem access for reading project files

## Reality Check

**This is NOT a drop-in replacement for Claude Code's agent system.**

### What Works
✅ MCP servers in VS Code Agent Mode  
✅ PubMed search with real PMIDs  
✅ Obsidian file operations  
✅ Sequential thinking  
⚠️ Memory storage (has issues)

### What's Different from Claude Code

| Feature | Claude Code | GitHub Copilot |
|---------|------------|----------------|
| Setup | Run script → Done | Script + Manual VS Code steps |
| Agent command | `/agent "question"` | No equivalent |
| Workflow automation | Fully autonomous | Manual step-by-step |
| MCP installation | Automatic | Manual via VS Code UI |
| Works in | Terminal | VS Code only |

## Installation

### Prerequisites
- macOS
- VS Code with GitHub Copilot extension
- Node.js v18+
- Obsidian with Local REST API plugin

### Step 1: Run Base Setup
```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
git checkout github-copilot-support
chmod +x setup.sh
./setup.sh
# Choose option 2 for GitHub Copilot
```

### Step 2: Manual VS Code Configuration

1. **Restart VS Code completely** (Cmd+Q)

2. **Install MCP servers through VS Code**:
   - Open Command Palette (Cmd+Shift+P)
   - Type: "Add MCP Server"
   - Select "NPM Package"
   - Install these ONE BY ONE:
     - `@nova-mcp/mcp-nova`
     - `@ncukondo/pubmed-mcp`

3. **Configure API keys** when prompted:
   - PubMed: Get from https://www.ncbi.nlm.nih.gov/account/
   - Obsidian: Get from Local REST API plugin

### Step 3: Use Agent Mode

1. Open GitHub Copilot chat (Ctrl+Cmd+I)
2. **Switch dropdown from "Chat" to "Agent"**
3. Click "Tools" button
4. Select all MCP servers

## Usage Examples

### In Agent Mode (Required!)

**Literature Search**:
```
Use the pubmed tool to search for "prozone effect HLA antibodies"
```

**Create Note**:
```
Use the obsidian-rest tool to create a note at /Users/[your-username]/Library/CloudStorage/Box-Box/Obsidian/HLA Antibodies/Concepts/Prozone-Effect.md with content about complement interference
```

**Complex Analysis**:
```
Use the sequential-thinking tool to analyze the relationship between C1q binding and prozone effect in SAB assays
```

### Manual Workflow Example

Unlike Claude Code's single `/agent` command, you must orchestrate each step:

1. "Use pubmed tool to search for dnDSA pediatric"
2. "Based on those results, use obsidian-file to create a research question note"
3. "Now create concept pages for the key terms mentioned"
4. "Cross-link the pages using WikiLinks"

## Limitations

1. **No autonomous agent** - You manually control each step
2. **Memory server issues** - May not persist properly
3. **Agent Mode only** - Regular chat can't use MCP tools
4. **Manual orchestration** - No multi-step automation
5. **VS Code only** - Won't work in other editors

## Should You Use This?

### Use GitHub Copilot MCP if:
- You're already using VS Code/GitHub Copilot daily
- You prefer manual control over each step
- You want MCP tools integrated in your IDE
- You don't mind the setup complexity

### Use Claude Code Instead if:
- You want autonomous research workflows
- You need the `/agent` command
- You prefer "it just works" setup
- You want terminal-based operation

## Troubleshooting

### MCP servers not showing in Tools?
- Did you restart VS Code completely?
- Did you install via VS Code's "Add MCP Server" interface?
- Are you in Agent Mode, not Chat Mode?

### Memory server not working?
- Known issue, use file-based persistence instead

### Can't find Agent Mode?
- Update GitHub Copilot to latest version
- Look for dropdown at top of chat panel

## Documentation

- [Reality Check](docs/GITHUB_COPILOT_REALITY_CHECK.md) - Honest assessment
- [Manual Steps Guide](docs/GITHUB_COPILOT_AGENT_SETUP.md) - Detailed setup
- [API Setup](docs/API_AND_PATH_SETUP.md) - Get your API keys

## The Bottom Line

This brings MCP capabilities to VS Code, but requires significant manual setup and operation. It's a toolkit you operate manually, not an autonomous assistant.

**For the full autonomous experience, use Claude Code on the `main` branch.**