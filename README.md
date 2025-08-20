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
- [Node.js](https://nodejs.org/) v18 or higher
- [Obsidian](https://obsidian.md/) (for note management)
- Claude API key from [Anthropic Console](https://console.anthropic.com/)
- Cloud storage (iCloud, Dropbox, Box, Google Drive, or OneDrive)

### Step 1: Clone and Run Setup

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

The setup script will:
- ✅ Install Claude Code CLI tool
- ✅ Install all 5 MCP servers (Memory, PubMed, Obsidian, Filesystem, Sequential Thinking)
- ✅ Ask you to choose your cloud provider (iCloud, Dropbox, Box, Google Drive, OneDrive, or custom)
- ✅ Create directory structure in your chosen cloud location
- ✅ Set up configuration templates
- ✅ Initialize memory with HLA knowledge base

### Step 2: Add Your API Keys

The setup script will tell you the exact location of your config file based on your chosen cloud provider.
For example:
- **iCloud**: `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json`
- **Dropbox**: `~/Dropbox/MCP-Shared/claude-desktop-config.json`
- **Box**: `~/Library/CloudStorage/Box-Box/MCP-Shared/claude-desktop-config.json`

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

#### Obsidian REST API Keys (Dual Vault Setup)

**For Single Vault (Simple Setup):**
```json
"obsidian-rest": {
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27124",
    "AUTH_BEARER": "YOUR-OBSIDIAN-API-KEY"
  }
}
```

**For Dual Vault (Recommended - Full Automation):**
```json
"obsidian-rest-hla": {
  "command": "npx",
  "args": ["dkmaker-mcp-rest-api@latest"],
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27124",
    "AUTH_BEARER": "YOUR-HLA-VAULT-API-KEY",
    "REST_ENABLE_SSL_VERIFY": "false",
    "NODE_TLS_REJECT_UNAUTHORIZED": "0"
  }
},
"obsidian-rest-journal": {
  "command": "npx",
  "args": ["dkmaker-mcp-rest-api@latest"],
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27125",
    "AUTH_BEARER": "YOUR-JOURNAL-VAULT-API-KEY",
    "REST_ENABLE_SSL_VERIFY": "false",
    "NODE_TLS_REJECT_UNAUTHORIZED": "0"
  }
}
```
Get from: Obsidian → Settings → Community Plugins → Local REST API

### Step 3: Set Up Obsidian

> **📌 NOTE**: This system comes with HLA research vaults as examples. 
> **To customize for your research**: See [Personal Setup Guide](docs/PERSONAL_SETUP.md)

#### Option A: Single Vault Setup (Simpler)
1. **Install the Local REST API Plugin:**
   - Open Obsidian
   - Settings → Community Plugins → Browse
   - Search for "Local REST API"
   - Install and Enable

2. **Generate API Key:**
   - Settings → Local REST API
   - Copy the API key
   - Add to config as `obsidian-rest`

3. **Verify Settings:**
   - Ensure HTTPS is enabled (port 27124)
   - API key is visible

#### Option B: Dual Vault Setup (Recommended for Full Automation)
1. **Set up HLA Antibodies vault:**
   - Open HLA Antibodies vault in Obsidian
   - Install Local REST API plugin
   - Keep default port 27124
   - Copy API key for `obsidian-rest-hla`

2. **Set up Research Journal vault:**
   - Open Research Journal vault in separate Obsidian window
   - Install Local REST API plugin
   - **Change port to 27125** in Advanced Settings
   - Copy API key for `obsidian-rest-journal`

3. **Benefits of Dual Vault:**
   - ✅ Agent writes to both vaults automatically
   - ✅ HLA concepts → HLA Antibodies vault
   - ✅ Daily entries → Research Journal vault
   - ✅ No manual vault switching needed

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
- 🎭 **Custom Agents** - Create specialized personalities for different tasks

## 🎭 Custom Agent System

### Using Pre-Built Agents
```bash
# Copy HLA Research Agent to your project
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/HLA-Research-Agent.md ./CLAUDE.md
```

### Creating Your Own Agent
```bash
# Start with the template
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/AGENT_TEMPLATE.md ./My-Agent.md
# Edit to add your domain knowledge and rules
# Use as CLAUDE.md in your projects
```

Agents can be specialized for:
- Grant writing
- Protocol development
- Data analysis
- Literature reviews
- Clinical documentation

## 📁 System Architecture

```
Your Machine
├── ~/.claude.json                    → Symlink to config
├── [Your Cloud Provider]/            → Syncs across machines
│   └── MCP-Shared/
│       ├── claude-desktop-config.json → Your configuration
│       ├── nova-memory/              → Persistent storage
│       ├── agents/                   → Agent personality library
│       │   ├── HLA-Research-Agent.md → Pre-configured HLA expert
│       │   ├── AGENT_TEMPLATE.md     → Create custom agents
│       │   └── README.md             → Agent usage guide
│       └── templates/                → Note templates
└── [Your Obsidian Location]/         → Can be same or different cloud
    └── Obsidian/
        ├── [Your Research Area]/     → Research vault (rename from HLA)
        │   ├── Concepts/
        │   └── Research Questions/
        └── Research Journal/         → Daily notes
            ├── Daily/
            └── Concepts/
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

## 📝 Important: Two-Vault Structure

You have TWO separate Obsidian vaults:
1. **HLA Antibodies** (Port 27124) - Research questions and HLA concepts
2. **Research Journal** (Port 27125) - Daily notes and project concepts

**Single Vault Setup:** REST API connects to one vault at a time
**Dual Vault Setup:** Both vaults accessible simultaneously via different ports

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

---

**Need help?** Open an issue on [GitHub](https://github.com/VMWM/HLA_Agent-MCP_System/issues)