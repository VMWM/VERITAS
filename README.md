# HLA Agent-MCP System

> AI-powered HLA antibody research assistant with PubMed verification, automated knowledge graphs, and intelligent literature review

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-green)](https://modelcontextprotocol.org)
[![PubMed](https://img.shields.io/badge/PubMed-Integrated-orange)](https://pubmed.ncbi.nlm.nih.gov/)
[![HLA](https://img.shields.io/badge/HLA-Research-red)](https://www.ashi-hla.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What This Does

This system transforms Claude Code into a specialized HLA research assistant that:

- **Searches** PubMed and HLA literature with automatic PMID verification
- **Creates** structured notes on antibody patterns, epitopes, and transplant outcomes
- **Maintains** persistent memory of SAB interpretations and clinical protocols
- **Automates** complex HLA antibody analysis workflows
- **Builds** interconnected knowledge graphs of HLA concepts and relationships

### What This System Provides for HLA Research

This system was built to address specific needs in HLA antibody research that weren't met by existing tools:

**Integrated Knowledge Sources**
- Searches your local HLA lecture PDFs and protocols
- Queries PubMed with automatic PMID verification
- Maintains persistent memory across all sessions
- Combines all sources into synthesized answers

**Automated Research Workflows**
- Completes literature reviews in minutes instead of hours
- Creates structured notes with proper citations
- Builds interconnected knowledge graphs
- Remembers context between sessions

**Domain-Specific Accuracy**
- Verifies HLA-specific values from your lab protocols
- Provides accurate MFI thresholds, cPRA calculations, etc.
- Links to source documents for verification
- Prevents citation hallucination with PMID checking

**Practical Output**
- Creates files directly in your Obsidian vaults
- Maintains consistent formatting via templates
- Cross-links related concepts automatically
- Syncs across all machines via iCloud

### Example Use Cases

#### Research Query: "What causes prozone effect in SAB testing?"

The system:
- Searches your HLA lecture PDFs for prozone discussions
- Queries PubMed for recent papers on the topic
- Finds 70-85% prevalence in cPRA >95% patients
- Creates linked notes: [[Prozone Effect]], [[C1q Interference]], [[EDTA Treatment]]
- Provides verified citations: Tambur 2015 (PMID: 25649423), Schnaidt 2011 (PMID: 21199346)
- Remembers this information for future related queries

#### Coding with Domain Knowledge

```python
# Query: "What's the standard MFI cutoff for positive DSA in pediatric kidney transplant?"

# System searches your protocols and literature, returns:
# - Lab protocol: 1500 MFI (from protocol_2024.pdf)
# - Literature range: 500-5000 (Garcia 2023, PMID: 37654321)
# - Pediatric specific: 1000 (Kim 2019, PMID: 31402319)

# Your code with verified values:
POSITIVE_DSA_CUTOFF = 1500  # Lab standard, see protocol_2024.pdf
PEDIATRIC_ADJUSTMENT = 1000  # Kim 2019, PMID: 31402319
```

## System Architecture

```
┌──────────────────────────────────────────────────────┐
│                 VS Code + Claude Code                 │
│      (Works from ANY project folder on ANY machine)   │
└────────────────────┬──────────────────────────────────┘
                     │
                     ▼
            ~/.claude.json (symlink)
                     │
                     ▼
    ┌────────────────────────────────────────┐
    │  iCloud MCP-Shared Configuration         │
    │  (Syncs across all your machines)        │
    └────────────────┬───────────────────────┘
                     │
         ┌───────────┴───────────────┐
         ▼                           ▼
    MCP Servers                 Knowledge Base
    ├── Memory (templates)      ├── HLA lectures
    ├── PubMed (PMIDs)         ├── Lab protocols  
    ├── Obsidian (notes)       ├── Literature PDFs
    └── Agent (automation)      └── Meeting notes
```

## Prerequisites

- macOS
- [VS Code](https://code.visualstudio.com/)
- [Node.js](https://nodejs.org/) (v18 or higher)
- [Obsidian](https://obsidian.md/) (for note management)
- Claude API key ([get one here](https://console.anthropic.com/))
- iCloud Drive enabled (for cross-machine sync)

## Quick Start (15 minutes)

### 1. Clone This Repository

```bash
git clone https://github.com/yourusername/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
```

### 2. Run the Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

This script will:

- Install Claude Code globally
- Create necessary directories
- Set up configuration files
- Create symlinks for cloud sync

### 3. Configure Your API Keys

```bash
# Copy the template to create your config file
cp config/claude-desktop-config.template.json ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json

# Open the file to add your API keys
open ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json
```

**See [API &amp; Path Setup Guide](docs/API_AND_PATH_SETUP.md) for detailed instructions on:**

- Getting each API key (with screenshots)
- Setting up your file paths
- Common path examples

### 4. Install Obsidian Plugin

1. Open Obsidian
2. Settings → Community Plugins → Browse
3. Search "Local REST API"
4. Install, enable, and generate API key
5. Add API key to your config

### 5. Test the System

```bash
claude
# In Claude, type:
/mcp  # Should show all servers connected
```

## Repository Structure

```
HLA_Agent-MCP_System/
├── README.md                           # This file
├── setup.sh                           # Automated setup script
├── config/
│   ├── claude-desktop-config.template.json  # MCP server configuration
│   ├── memory-instructions.md        # Templates and routing rules
│   └── agent-specification.json      # HLA Research Agent config
├── templates/
│   ├── daily-entry.md                # Research journal template
│   ├── research-question.md          # Question template with citations
│   └── concept.md                    # Concept page template
├── scripts/
│   ├── install-claude.sh             # Claude Code installation
│   ├── setup-obsidian.sh             # Obsidian vault structure
│   └── test-connection.sh            # Verify setup
├── docs/
│   ├── SETUP_GUIDE.md               # Detailed setup instructions
│   ├── USAGE_GUIDE.md               # How to use the system
│   ├── TROUBLESHOOTING.md          # Common issues and solutions
│   └── AGENT_GUIDE.md               # Creating custom agents
└── examples/
    ├── sample-research-question.md   # Example output
    ├── sample-daily-entry.md        # Example journal
    └── sample-workflow.md           # Example agent workflow
```

## Manual Setup Steps

If you prefer manual setup or need to customize:

### Step 1: Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### Step 2: Create Directory Structure

```bash
mkdir -p "~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"
mkdir -p "~/Library/CloudStorage/Box-Box/Obsidian/HLA Antibodies/Research Questions"
mkdir -p "~/Library/CloudStorage/Box-Box/Obsidian/HLA Antibodies/Concepts"
mkdir -p "~/Library/CloudStorage/Box-Box/Obsidian/Research Journal/Daily"
```

### Step 3: Configure MCP Servers

Copy `config/claude-desktop-config.template.json` to your MCP-Shared folder and update:

- PubMed API key and email
- Obsidian REST API key
- File paths for your knowledge base

### Step 4: Create Symlink

```bash
ln -s "~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json" ~/.claude.json
```

## Core Features

### MCP Servers Included

| Server                        | Purpose                        | Auto-Triggers On           |
| ----------------------------- | ------------------------------ | -------------------------- |
| **Memory**              | Persistent templates & context | Every session              |
| **PubMed**              | Medical literature with PMIDs  | Medical terms, "how often" |
| **Obsidian-REST**       | Full Obsidian features         | When app is running        |
| **Obsidian-File**       | Direct file access             | Fallback/offline           |
| **Sequential-Thinking** | Complex reasoning              | Multi-step problems        |

### HLA Research Agent Capabilities

The specialized HLA Research Agent can:

- Search PubMed for HLA antibody studies with automatic PMID verification
- Analyze SAB patterns and prozone effects from literature
- Create comprehensive notes on DSA, epitopes, and MFI interpretation
- Extract transplant outcome statistics and alloimmunization rates
- Build knowledge graphs connecting HLA concepts, testing methods, and clinical outcomes
- Synthesize conflicting findings across HLA literature for comprehensive reviews

## Usage Examples

### HLA Literature Review

```bash
/agent "What is the prevalence of dnDSA in pediatric kidney transplant recipients?"
/agent "How do SAB MFI values correlate with C1q positivity?"
/agent "What patterns indicate prozone effect in highly sensitized patients?"
```

### Daily Documentation

```bash
"Create today's research journal entry"
```

### HLA Research Synthesis

```bash
/agent "Analyze HLA epitope patterns from recent literature"
/agent "Compare SAB interpretation methods across different laboratories"
/agent "Synthesize evidence on complement interference in Luminex assays"
```

### Real Workflow Example

```
User: /agent "What is the prevalence of prozone effect in highly sensitized patients?"

Agent executes:
1. Searches your knowledge base → Finds 3 lecture PDFs
2. Queries PubMed → Retrieves 12 relevant papers
3. Extracts statistics → "70-85% in cPRA ≥95% patients"
4. Creates Research Question note with verified PMIDs
5. Identifies concepts: [[Prozone Effect]], [[C1q Interference]], [[EDTA Treatment]]
6. Creates 4 concept pages with cross-links
7. Time: 2 minutes (vs 6+ hours manually)
```

## Configuration

### PubMed Setup

Add to your config:

```json
"pubmed": {
  "env": {
    "PUBMED_EMAIL": "your.email@university.edu",
    "PUBMED_API_KEY": "your-api-key-here"
  }
}
```

### Obsidian REST API

```json
"obsidian-rest": {
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27124",
    "REST_API_KEY": "your-obsidian-api-key",
    "REST_DEFAULT_HEADERS": "{\"Authorization\": \"Bearer your-obsidian-api-key\"}",
    "NODE_TLS_REJECT_UNAUTHORIZED": "0"
  }
}
```

### Knowledge Base Paths

Update these to point to your files:

```json
"knowledge_paths": [
  "/path/to/your/PDFs",
  "/path/to/your/notes"
]
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Adding new MCP servers
- Creating domain-specific agents
- Improving setup scripts
- Extending to other research domains

## Documentation

- [API &amp; Path Setup](docs/API_AND_PATH_SETUP.md) - **START HERE** - Get your API keys and configure paths
- [System Architecture](docs/ARCHITECTURE.md) - Technical design and components
- [Complete Guide](docs/COMPLETE_GUIDE.md) - Comprehensive system documentation
- [Workflow Examples](docs/WORKFLOW_EXAMPLES.md) - Detailed agent execution traces
- [Demo Script](docs/DEMO_SCRIPT.md) - For lab presentations
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

## Troubleshooting

| Issue                      | Solution                                 |
| -------------------------- | ---------------------------------------- |
| MCP servers not connecting | Restart Claude:`claude`                |
| Obsidian files not created | Check REST API is enabled                |
| PubMed rate limited        | Automatic 1-second delay between queries |
| Agent not saving files     | Check file paths in config               |

---
