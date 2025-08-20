# HLA Agent-MCP System

> **Claude Code Exclusive** - AI-powered HLA antibody research assistant with PubMed verification, automated knowledge graphs, and intelligent literature review

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-green)](https://modelcontextprotocol.org)
[![PubMed](https://img.shields.io/badge/PubMed-Integrated-orange)](https://pubmed.ncbi.nlm.nih.gov/)
[![HLA](https://img.shields.io/badge/HLA-Research-red)](https://www.ashi-hla.org/)

## 🚀 Quick Start (10 minutes)

### Prerequisites
- macOS
- [Node.js](https://nodejs.org/) v18 or higher
- [Obsidian](https://obsidian.md/) (for note management)
- Claude API key from [Anthropic Console](https://console.anthropic.com/)

### Step 1: Clone and Run Setup

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

This single command will:
- ✅ Install Claude Code CLI tool
- ✅ Install all 5 MCP servers (Memory, PubMed, Obsidian, Filesystem, Sequential Thinking)
- ✅ Create directory structure in iCloud and Box
- ✅ Set up configuration templates
- ✅ Initialize memory with HLA knowledge base

### Step 2: Add Your API Keys

Edit the configuration file:
```bash
open ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json
```

Add your keys in these sections:

#### Claude API Key
```json
"claude": {
  "apiKey": "sk-ant-YOUR-KEY-HERE"
}
```
Get from: https://console.anthropic.com/

#### PubMed Credentials
```json
"pubmed": {
  "env": {
    "PUBMED_EMAIL": "your.email@university.edu",
    "PUBMED_API_KEY": "YOUR-PUBMED-KEY"
  }
}
```
Get from: https://www.ncbi.nlm.nih.gov/account/settings/

#### Obsidian REST API Key
```json
"obsidian-rest": {
  "env": {
    "AUTH_BEARER": "YOUR-OBSIDIAN-API-KEY"
  }
}
```
Get from: Obsidian → Settings → Community Plugins → Local REST API

### Step 3: Set Up Obsidian

1. **Install the Local REST API Plugin:**
   - Open Obsidian
   - Settings → Community Plugins → Browse
   - Search for "Local REST API"
   - Install and Enable

2. **Generate API Key:**
   - Settings → Local REST API
   - Copy the API key
   - Add to config (Step 2)

3. **Verify Settings:**
   - Ensure HTTPS is enabled (port 27124)
   - API key is visible

### Step 4: Add CLAUDE.md to Your Projects

**CRITICAL:** Copy the CLAUDE.md template to each project folder where you'll use Claude Code:

```bash
cp templates/CLAUDE.md /path/to/your/project/
```

This prevents Obsidian path issues and ensures proper vault routing.

### Step 5: Test Your Setup

```bash
claude
```

Then in Claude:
```
/mcp
```

You should see 5 servers connected:
- ✅ memory
- ✅ pubmed
- ✅ obsidian-rest
- ✅ filesystem-local
- ✅ sequential-thinking

## 🎯 What This System Does

### Automated HLA Research
- **Literature Search**: `/agent "Find recent papers on prozone effect in SAB testing"`
- **Note Creation**: `/agent "Create a concept note on Halifax Protocol"`
- **Knowledge Synthesis**: `/agent "Compare MFI cutoff strategies across transplant centers"`

### Key Features
- 📚 **PubMed Integration** - Real-time literature search with PMID verification
- 🧠 **Persistent Memory** - Remembers your research context across sessions
- 📝 **Obsidian Integration** - Creates structured notes in your vaults
- 🔗 **Knowledge Graphs** - Automatically links related concepts
- 🚀 **One-Command Agent** - Complex workflows with `/agent`

## 📁 System Architecture

```
Your Machine
├── ~/.claude.json                    → Symlink to config
├── ~/Library/Mobile Documents/       → iCloud (syncs across machines)
│   └── MCP-Shared/
│       ├── claude-desktop-config.json → Your configuration
│       ├── nova-memory/              → Persistent storage
│       └── templates/                → Note templates
└── ~/Library/CloudStorage/Box-Box/   → Box Drive
    └── Obsidian/
        ├── HLA Antibodies/           → Research vault
        │   ├── Concepts/
        │   └── Research Questions/
        └── Research Journal/         → Daily notes
            ├── Daily/
            └── Concepts/
```

## 🛠️ MCP Servers Included

| Server | Purpose | Usage |
|--------|---------|-------|
| **memory** | Persistent knowledge storage | Stores facts, templates, context |
| **pubmed** | Medical literature search | Real-time PMID-verified searches |
| **obsidian-rest** | Note creation/editing | Works from ANY project folder |
| **filesystem-local** | Read local files | PDFs, documents in current folder |
| **sequential-thinking** | Complex reasoning | Multi-step analysis and synthesis |

## 📝 Important: Two-Vault Structure

You have TWO separate Obsidian vaults:
1. **HLA Antibodies** - Research questions and HLA concepts
2. **Research Journal** - Daily notes and project concepts

The REST API connects to ONE vault at a time (typically HLA Antibodies).

## 🔧 Troubleshooting

### MCP servers not showing as connected?
```bash
# Restart Claude Code
claude

# Check servers
/mcp
```

### Obsidian REST API connection refused?
1. Ensure Obsidian is running
2. Check Local REST API plugin is enabled
3. Verify API key matches in both Obsidian and config
4. Confirm HTTPS on port 27124

### Files created with JSON wrappers?
This happens if the API format is wrong. Ensure your CLAUDE.md is in the project folder.

### "Access denied" errors?
You're using the wrong MCP server. Use `obsidian-rest` for Obsidian operations, not `filesystem-local`.

## 📚 Documentation

- [API & Path Setup Guide](docs/API_AND_PATH_SETUP.md) - Detailed API key instructions
- [System Architecture](docs/ARCHITECTURE.md) - Technical design
- [Workflow Examples](docs/WORKFLOW_EXAMPLES.md) - Real usage patterns
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues

## 🎯 Example Workflows

### Literature Review
```
/agent "Search PubMed for HLA antibody prozone effect papers from 2020-2024, create summary note"
```

### Daily Research Journal
```
/agent "Create today's research journal entry documenting F31 grant progress"
```

### Concept Development
```
/agent "Create concept note on MFI interpretation with links to related concepts"
```

## 🤝 Contributing

This system is designed for HLA research but can be adapted for other domains. Pull requests welcome!

## 📄 License

MIT License - See LICENSE file for details

## 🙏 Acknowledgments

Built for the transplant immunology community to accelerate HLA antibody research.

---

**Need help?** Open an issue on [GitHub](https://github.com/VMWM/HLA_Agent-MCP_System/issues)