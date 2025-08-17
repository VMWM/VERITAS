# GitHub Copilot MCP Setup Guide

## Overview

This guide shows how to use the HLA Research MCP System with GitHub Copilot's MCP support. GitHub Copilot can now connect to MCP servers, giving you access to the same research capabilities through VS Code's chat interface.

## Prerequisites

- macOS
- VS Code with GitHub Copilot extension
- GitHub Copilot subscription
- Node.js v18+
- Obsidian (for note management)

## Quick Setup

### 1. Run the Copilot Setup Script

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup-copilot.sh
./setup-copilot.sh
```

This will:
- Install all MCP servers globally
- Create the GitHub Copilot MCP configuration
- Set up directory structure
- Copy template files

### 2. Configure API Keys

Edit the GitHub Copilot MCP configuration file:

```bash
open ~/Library/Application\ Support/Code/User/mcp.json
```

Add your API keys:
- PubMed API key and email
- Obsidian REST API key

### 3. Set Up Obsidian REST API

1. Open Obsidian
2. Settings → Community Plugins → Browse
3. Search "Local REST API"
4. Install and enable
5. Generate API key
6. Add to the configuration file

### 4. Restart VS Code

Close VS Code completely and reopen. GitHub Copilot will detect the MCP servers.

## Usage with GitHub Copilot

### Basic Research Queries

```
@github Search PubMed for recent papers on prozone effect in HLA testing
```

```
@github Create a research note about complement interference in SAB assays
```

### Advanced Workflows

```
@github Find papers about pediatric kidney transplant DSA and create a comprehensive analysis with Obsidian notes
```

```
@github What is the current evidence on MFI cutoffs for virtual crossmatching? Include citations and create concept pages.
```

### Daily Documentation

```
@github Create today's research journal entry focusing on HAML implementation progress
```

## MCP Servers Available

| Server | Purpose | Available Actions |
|--------|---------|-------------------|
| **Memory** | Persistent templates & context | Store/recall information, apply templates |
| **PubMed** | Medical literature search | Search papers, verify PMIDs, get abstracts |
| **Obsidian REST** | Note creation & search | Create notes, search vault, execute commands |
| **Obsidian File** | Direct file access | Read/write files, backup when REST unavailable |
| **Sequential Thinking** | Complex reasoning | Multi-step analysis, systematic comparisons |

## Key Differences from Claude Code

### Advantages
- ✅ Integrated with VS Code workflow
- ✅ Can edit files directly in editor
- ✅ Access to VS Code extensions
- ✅ Built-in terminal integration

### Limitations
- ❌ No native `/agent` command (but see [Agent Setup Guide](GITHUB_COPILOT_AGENT_SETUP.md))
- ❌ Less autonomous by default (fixable with custom instructions)
- ❌ May require initial configuration for agent behavior

## Example Workflows

### Literature Review Workflow

1. **Search**: `@github Search PubMed for "prozone effect HLA antibodies" papers from 2020-2024`
2. **Analyze**: `@github Analyze these papers and extract key findings about prevalence`
3. **Document**: `@github Create a research question note in Obsidian with this analysis`
4. **Link**: `@github Create concept pages for related terms and cross-link them`

### Daily Research Documentation

1. **Start**: `@github Create today's research journal entry`
2. **Update**: `@github Add my progress on HAML implementation to today's entry`
3. **Plan**: `@github Add next steps for this week to the journal`
4. **Connect**: `@github Link today's work to related concept pages`

## Troubleshooting

### MCP Servers Not Detected

1. Restart VS Code completely
2. Check that Node.js packages are installed globally:
   ```bash
   npm list -g @nova-mcp/mcp-nova
   ```
3. Verify configuration file exists:
   ```bash
   cat ~/Library/Application\ Support/Code/User/mcp.json
   ```

### Obsidian Connection Issues

1. Ensure Obsidian is running
2. Verify REST API plugin is enabled
3. Check API key in configuration
4. Test connection:
   ```bash
   curl -H "Authorization: Bearer YOUR_KEY" https://127.0.0.1:27124/vault
   ```

### PubMed Rate Limiting

1. Get a PubMed API key: https://www.ncbi.nlm.nih.gov/account/
2. Add to configuration file
3. This increases rate limits significantly

## Configuration File Location

GitHub Copilot MCP configuration is stored at:
```
~/Library/Application Support/Code/User/mcp.json
```

This is separate from Claude Code's configuration, allowing you to run both systems simultaneously.

## Comparison: GitHub Copilot vs Claude Code

| Feature | GitHub Copilot | Claude Code |
|---------|----------------|-------------|
| **Integration** | VS Code native | Terminal/CLI |
| **File editing** | Direct in editor | Via commands |
| **Agent workflows** | Manual prompting | Automated |
| **Research depth** | Good | Excellent |
| **Code assistance** | Excellent | Good |
| **Setup complexity** | Medium | Low |

## Tips for Best Results

1. **Be specific**: GitHub Copilot works best with clear, detailed instructions
2. **Use @ mentions**: Always start with `@github` for MCP server access
3. **Break down tasks**: Complex workflows may need multiple steps
4. **Verify outputs**: Review generated notes and citations
5. **Cross-reference**: Use both tools for different strengths

## Future Enhancements

As GitHub Copilot's MCP support evolves, we may see:
- Better agent orchestration
- Improved workflow automation
- Enhanced context retention
- Custom command creation

---

*This setup enables powerful research capabilities within your familiar VS Code environment while maintaining access to all the specialized HLA research tools.*