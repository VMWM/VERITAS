# HLA Agent-MCP System

> **Transform Claude Code into your personal research assistant** - A complete system that connects Claude to PubMed, Obsidian, and persistent memory for automated literature reviews, knowledge management, and research documentation.

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-green)](https://modelcontextprotocol.org)
[![PubMed](https://img.shields.io/badge/PubMed-Integrated-orange)](https://pubmed.ncbi.nlm.nih.gov/)
[![HLA](https://img.shields.io/badge/HLA-Research-red)](https://www.ashi-hla.org/)

[🎥 Video Demonstration](https://tulane.box.com/s/xvn2vjap776cuj4y3gpidhfv1ixecz9b)

## 🤖 What is This?

This system supercharges Claude Code by connecting it to:
- **PubMed** - Search literature, verify citations, get PMIDs in real-time
- **Obsidian** - Automatically create structured notes in your knowledge vault
- **Memory** - Remember your research context across sessions
- **Your Files** - Read PDFs, analyze data, process documents
- **Sequential Thinking** - Handle complex multi-step research tasks

### In Practice:
Instead of manually searching papers, copying citations, and creating notes, you can:
```
/agent "Find recent papers on prozone effect in HLA testing and create a summary note"
```

Claude will:
1. Search PubMed for relevant papers
2. Read and synthesize the findings
3. Create a properly formatted note in Obsidian
4. Link it to related concepts
5. Remember the key findings for future queries

### Who Is This For?
- **HLA Researchers** who need rigorous citation management
- **Transplant Immunologists** working on clinical studies
- **Laboratory Directors** managing quality standards
- **PhD Students** conducting systematic literature reviews
- **Clinicians** who need evidence-based HLA interpretations
- **Anyone** who values accuracy and PMID-verified citations

## 💡 Why This Exists

I built this while working on my F31 grant proposal. I needed to:
- Review hundreds of papers on HLA antibody testing
- Keep track of conflicting findings across studies
- Build a knowledge graph of interconnected concepts
- Generate evidence-based research questions
- Document daily progress without losing context

Manual tools weren't cutting it. This system automated the tedious parts while keeping me in control of the thinking.

## 🎯 Two Ways to Use This System

### Option 1: Use My Exact HLA Setup
Perfect if you're working on:
- HLA antibody research
- Transplant immunology  
- Clinical histocompatibility testing
- Multi-center standardization studies
- Any HLA-related research requiring verified citations

→ Follow the setup as-is and get my complete HLA research environment

### Option 2: Customize for Your Research Domain
Adapt this system for:
- Cancer biology, neuroscience, cardiology, etc.
- Different vault structures
- Custom agent personalities
- Your preferred cloud storage

→ See [CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for adaptation

## 🚀 Quick Start (10 minutes)

### Prerequisites
- macOS
- [VS Code](https://code.visualstudio.com/) (required for Claude Code)
- [Claude Code](https://claude.ai/code) - Install via VS Code or npm
- [Node.js](https://nodejs.org/) v18 or higher
- [Obsidian](https://obsidian.md/) with Local REST API plugin
- Claude API key from [Anthropic Console](https://console.anthropic.com/)
- Cloud storage (iCloud, Dropbox, Box, Google Drive, or OneDrive)

### Step 1: Install Claude Code (if needed)

**Option A: Via VS Code Extension**
1. Open VS Code
2. Go to Extensions (⌘⇧X)
3. Search for "Claude Code"
4. Install the extension

**Option B: Via npm**
```bash
npm install -g @anthropic-ai/claude-code
```

### Step 2: Clone and Run Setup

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

**After setup, run validation:**
```bash
./scripts/validate_setup.sh
```
This checks all components are properly installed and configured.

**Note**: PubMed MCP may need manual configuration. See [Troubleshooting](docs/TROUBLESHOOTING.md) if it shows "Failed to connect".

### Step 3: Set Up Obsidian

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

### Step 4: Configure API Keys

> **📋 NEW**: Use [docs/SETUP_CHECKLIST.md](docs/SETUP_CHECKLIST.md) for a complete walkthrough with validation steps!

**See [docs/SETUP.md](docs/SETUP.md) for detailed instructions.**

Edit the configuration file:
```bash
# Location depends on your cloud provider:
# iCloud: ~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json
# Dropbox: ~/Dropbox/MCP-Shared/claude-desktop-config.json
# Box: ~/Library/CloudStorage/Box-Box/MCP-Shared/claude-desktop-config.json
```

Required keys:
1. **Claude API Key** - From [console.anthropic.com](https://console.anthropic.com/)
2. **PubMed Email** - Any valid email (API key optional)
3. **Obsidian API Key(s)** - From Step 2 above

The setup script creates a template showing exactly where to add these.

### Step 5: Add CLAUDE.md to Your Project

**CRITICAL:** The agent file MUST be named `CLAUDE.md` in your project folder:

```bash
# Option 1: Use the included HLA research agent
cp ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/CLAUDE.md /path/to/your/project/

# Option 2: Create your own custom agent
cp ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/templates/AGENT_TEMPLATE.md /path/to/your/project/CLAUDE.md
```

This file tells Claude how to behave for your specific research domain. 

**⚠️ KEY FEATURES of CLAUDE.md v5.1 (Public Release):**
- **MANDATORY PMID verification** for ALL medical/scientific claims
- **Three-tier verification system**: [FT-VERIFIED], [ABSTRACT-VERIFIED], [NEEDS-FT-REVIEW]
- **Anti-fabrication safeguards** - explicitly states "requires verification" when uncertain
- **PubMed-first approach** - searches literature before making any medical claims
- **Template-based note creation** - ensures consistent, high-quality documentation
- **Suitable for public sharing** - proprietary research details removed

### Step 6: Test Your Setup

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

## ✨ Key Capabilities

### What You Can Do
```bash
# Literature Review
/agent "Find papers from 2020-2024 on prozone effect in HLA testing, create summary"

# Concept Development
/agent "Create a concept note on MFI cutoffs with clinical decision thresholds"

# Daily Documentation
/agent "Create today's research journal entry with progress on Aim 2"

# Knowledge Synthesis
/agent "Compare Halifax vs EDTA protocols for prozone detection"

# Grant Writing
/agent "Generate specific aims for studying antibody standardization"
```

### How It's Different
| Traditional Workflow | This System |
|---------------------|-------------|
| Search PubMed manually | Claude searches and filters |
| Copy/paste citations | Auto-generates with PMIDs |
| Create notes manually | Auto-creates in Obsidian |
| Lose context between sessions | Memory persists everything |
| Manage references manually | Auto-links related concepts |
| Switch between tools | Everything in one terminal |

## 🎭 Custom Agent System

**IMPORTANT:** Agent files must be named `CLAUDE.md` in your project folder.

### Using the HLA Research Agent
```bash
# Copy to your project AS CLAUDE.md
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/CLAUDE.md ./CLAUDE.md
```

### Creating Your Own Agent
```bash
# 1. Start with template
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System/templates/AGENT_TEMPLATE.md ./CLAUDE.md

# 2. Edit CLAUDE.md to add your domain knowledge

# 3. Save as a reusable agent for future projects (optional)
mkdir -p ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/
cp ./CLAUDE.md ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/My-Domain-Agent.md
```

Agents can be specialized for any research domain or task.

## 📁 System Architecture

```
Your Machine
├── ~/.config/claude/
│   └── claude-desktop-config.json    → Main Claude configuration
│
├── Your Project/
│   └── CLAUDE.md                     → Agent personality (REQUIRED NAME)
│
├── Cloud Storage (iCloud/Dropbox/Box/etc)
│   └── MCP-Shared/
│       ├── HLA_Agent-MCP_System/     → This repository
│       │   ├── CLAUDE.md             → Master agent personality
│       │   ├── config/               → Templates & validation
│       │   ├── docs/                 → Documentation
│       │   ├── scripts/              → Setup scripts
│       │   └── templates/            → Note templates
│       ├── claude-desktop-config.json → Synced MCP configuration
│       ├── nova-memory/              → Persistent memory database
│       └── CLAUDE.md                 → Shared agent personality
│
└── Obsidian Vaults (anywhere)
    ├── [Your Research]/              → Main research vault
    └── Research Journal/             → Daily notes vault (optional)
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
| **obsidian-rest** | Obsidian vault access | Single vault setup (default) |
| **obsidian-rest-hla** | HLA vault access | Dual vault: Concepts & research questions |
| **obsidian-rest-journal** | Journal vault access | Dual vault: Daily entries & project notes |
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
