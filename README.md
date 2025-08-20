# HLA Agent-MCP System

> **Claude Code Exclusive** - AI-powered HLA antibody research assistant with PubMed verification, automated knowledge graphs, and intelligent literature review

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-green)](https://modelcontextprotocol.org)
[![PubMed](https://img.shields.io/badge/PubMed-Integrated-orange)](https://pubmed.ncbi.nlm.nih.gov/)
[![HLA](https://img.shields.io/badge/HLA-Research-red)](https://www.ashi-hla.org/)

## 🎯 Two Ways to Use This System

### Option 1: Use My Exact HLA Setup
Perfect if you're working on:
- HLA antibody research
- Transplant immunology
- F31/grant writing in immunogenetics
- Any HLA-related research

→ Follow the setup as-is and get my complete HLA research environment

### Option 2: Customize for Your Research Domain
Adapt this system for:
- Cancer biology, neuroscience, cardiology, etc.
- Different vault structures
- Custom agent personalities
- Your preferred cloud storage

→ See [Personal Setup Guide](docs/PERSONAL_SETUP.md) for customization

## 🚀 Quick Start (10 minutes)

### Prerequisites
- macOS
- [VS Code](https://code.visualstudio.com/) (required for Claude Code)
- [Claude Code](https://claude.ai/code) - Install via VS Code or npm
- [Node.js](https://nodejs.org/) v18 or higher
- [Obsidian](https://obsidian.md/) with Local REST API plugin
- Claude API key from [Anthropic Console](https://console.anthropic.com/)
- Cloud storage (iCloud, Dropbox, Box, Google Drive, or OneDrive)

### Step 0: Install Claude Code (if needed)

**Option A: Via VS Code Extension**
1. Open VS Code
2. Go to Extensions (⌘⇧X)
3. Search for "Claude Code"
4. Install the extension

**Option B: Via npm**
```bash
npm install -g @anthropic-ai/claude-code
```

### Step 1: Clone and Run Setup

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

The setup script will:
- ✅ Install Claude Code CLI tool (if not already installed)
- ✅ Install all 5 MCP servers (Memory, PubMed, Obsidian, Filesystem, Sequential Thinking)
- ✅ Ask you to choose your cloud provider (iCloud, Dropbox, Box, Google Drive, OneDrive, or custom)
- ✅ Create directory structure in your chosen cloud location
- ✅ Set up configuration templates
- ✅ Copy knowledge base template (includes HLA examples, but customizable for any domain)

**Note**: PubMed MCP may need manual configuration. See [Troubleshooting](docs/TROUBLESHOOTING.md) if it shows "Failed to connect".

### Step 2: Set Up Obsidian

> **📌 NOTE**: This system comes with HLA research vaults as examples. 
> **To customize for your research**: See [CUSTOMIZATION.md](docs/CUSTOMIZATION.md)

#### Option A: Single Vault (Simpler)
Everything in one Obsidian vault:
1. Open Obsidian → Settings → Community Plugins → Browse
2. Search "Local REST API" → Install and Enable
3. In plugin settings → Copy API key (save for Step 3)
4. Ensure HTTPS enabled on port 27124

#### Option B: Two-Vault System (Recommended)
Separate research notes from daily journal:

**Vault Structure:**
```
Obsidian/
├── [Your Research Topic]/      # e.g., "HLA Antibodies"
│   ├── Concepts/
│   └── Research Questions/
└── Research Journal/            # Daily notes
    ├── Daily/
    └── Projects/
```

**Setup:**
1. **Research vault** (port 27124):
   - Install Local REST API → Copy API key for `obsidian-rest-hla`
2. **Journal vault** (port 27125):
   - Install Local REST API → Change port to 27125 → Copy API key

**Benefits:**
- Agent automatically routes content to correct vault
- Research stays organized separately from daily notes
- No manual vault switching needed

### Step 3: Configure API Keys

**See [docs/SETUP.md](docs/SETUP.md) for detailed instructions.**

Required keys:
1. **Claude API Key** - From [console.anthropic.com](https://console.anthropic.com/)
2. **PubMed Email** - Any valid email (API key optional)
3. **Obsidian API Key(s)** - From Step 2 above

The setup script shows where to add these based on your cloud provider.

### Step 4: Add CLAUDE.md to Your Project

**CRITICAL:** The agent file MUST be named `CLAUDE.md` in your project folder:

```bash
# Copy and rename the template
cp templates/CLAUDE.md /path/to/your/project/CLAUDE.md
```

This file tells Claude how to behave for your specific research domain.

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
- 🎭 **Custom Agents** - Create specialized personalities for different tasks

## 🎭 Custom Agent System

**IMPORTANT:** Agent files must be named `CLAUDE.md` in your project folder.

### Using the HLA Research Agent
```bash
# Copy to your project AS CLAUDE.md (not HLA-Research-Agent.md!)
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/HLA-Research-Agent.md ./CLAUDE.md
```

### Creating Your Own Agent
```bash
# 1. Start with template
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/AGENT_TEMPLATE.md ./CLAUDE.md

# 2. Edit CLAUDE.md to add your domain knowledge

# 3. Save as a reusable agent for future projects
cp ./CLAUDE.md ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/My-Domain-Agent.md
```

Agents can be specialized for any research domain or task.

## 📁 System Architecture

```
Your Machine
├── ~/.claude.json                    → Symlink to cloud config
├── Your Project/
│   └── CLAUDE.md                     → Agent personality (REQUIRED NAME)
│
├── Cloud Storage (iCloud/Dropbox/Box/etc)
│   └── MCP-Shared/
│       ├── claude-desktop-config.json → Synced configuration
│       ├── nova-memory/              → Persistent memory
│       ├── agents/                   → Reusable agent library
│       └── templates/                → Note templates
│
└── Obsidian Vaults (anywhere)
    ├── [Your Research]/              → Main research vault
    └── Research Journal/             → Daily notes vault
```

**Supported Cloud Providers:**
- iCloud Drive (`~/Library/Mobile Documents/com~apple~CloudDocs`)
- Dropbox (`~/Dropbox`)
- Google Drive (`~/Google Drive` or `~/Library/CloudStorage/GoogleDrive-*`)
- Box (`~/Library/CloudStorage/Box-Box`)
- OneDrive (`~/OneDrive` or `~/Library/CloudStorage/OneDrive-*`)
- Custom path (any local or mounted directory)

## 🛠️ MCP Servers Included

| Server | Purpose | Usage |
|--------|---------|-------|
| **memory** | Persistent knowledge storage | Stores facts, templates, context |
| **pubmed** | Medical literature search | Real-time PMID-verified searches |
| **obsidian-rest-hla** | HLA vault access | Concepts & research questions |
| **obsidian-rest-journal** | Journal vault access | Daily entries & project notes |
| **filesystem-local** | Read local files | PDFs, documents in current folder |
| **sequential-thinking** | Complex reasoning | Multi-step analysis and synthesis |

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
3. For dual vault: Ensure ports are different (27124 & 27125)

### Dual Vault Setup Issues?

**Both vaults using same port?**
- HLA Antibodies: Keep port 27124
- Research Journal: Change to port 27125 in Advanced Settings

**Only one vault connecting?**
- Verify both Obsidian windows are open
- Check both API keys are different
- Ensure config has both `obsidian-rest-hla` and `obsidian-rest-journal`

**iCloud sync conflicts?**
- Choose "Modified recently" when prompted
- Let iCloud fully sync before testing

### Testing Dual Vault Connection
```bash
# In Claude Code, verify both servers:
/mcp

# Should show:
✅ obsidian-rest-hla
✅ obsidian-rest-journal
```
3. Verify API key matches in both Obsidian and config
4. Confirm HTTPS on port 27124

### Files created with JSON wrappers?
This happens if the API format is wrong. Ensure your CLAUDE.md is in the project folder.

### "Access denied" errors?
You're using the wrong MCP server. Use `obsidian-rest` for Obsidian operations, not `filesystem-local`.

## 📚 Documentation

Just three essential guides:
- **[SETUP.md](docs/SETUP.md)** - Complete installation & API configuration
- **[CUSTOMIZATION.md](docs/CUSTOMIZATION.md)** - Adapt for your research domain
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Solutions for common issues

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

---

**Need help?** Open an issue on [GitHub](https://github.com/VMWM/HLA_Agent-MCP_System/issues)