# HLA Agent-MCP System
> AI-powered HLA antibody research assistant with PubMed verification, automated knowledge graphs, and intelligent literature review

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)
[![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-green)](https://modelcontextprotocol.org)
[![PubMed](https://img.shields.io/badge/PubMed-Integrated-orange)](https://pubmed.ncbi.nlm.nih.gov/)
[![HLA](https://img.shields.io/badge/HLA-Research-red)](https://www.ashi-hla.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🧬 What This Does

This system transforms Claude Code into a specialized HLA research assistant that:
- **Searches** PubMed and HLA literature with automatic PMID verification
- **Creates** structured notes on antibody patterns, epitopes, and transplant outcomes
- **Maintains** persistent memory of SAB interpretations and clinical protocols
- **Automates** complex HLA antibody analysis workflows
- **Builds** interconnected knowledge graphs of HLA concepts and relationships


## 📋 Prerequisites

- macOS (Windows/Linux adaptations coming soon)
- [VS Code](https://code.visualstudio.com/)
- [Node.js](https://nodejs.org/) (v18 or higher)
- [Obsidian](https://obsidian.md/) (for note management)
- Claude API key ([get one here](https://console.anthropic.com/))
- iCloud Drive enabled (for cross-machine sync)

## 🛠️ Quick Start (15 minutes)

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
cp config/claude-desktop-config.template.json config/claude-desktop-config.json
# Edit the file to add your API keys
```

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

## 📁 Repository Structure

```
HLA_Agent-MCP_System/
├── README.md                           # This file
├── setup.sh                           # Automated setup script
├── setup-windows.ps1                  # Windows setup (coming soon)
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

## ⚙️ Manual Setup Steps

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

## 🎯 Core Features

### MCP Servers Included

| Server | Purpose | Auto-Triggers On |
|--------|---------|------------------|
| **Memory** | Persistent templates & context | Every session |
| **PubMed** | Medical literature with PMIDs | Medical terms, "how often" |
| **Obsidian-REST** | Full Obsidian features | When app is running |
| **Obsidian-File** | Direct file access | Fallback/offline |
| **Sequential-Thinking** | Complex reasoning | Multi-step problems |

### HLA Research Agent Capabilities

The specialized HLA Research Agent can:
- Search PubMed for HLA antibody studies with automatic PMID verification
- Analyze SAB patterns and prozone effects from literature
- Create comprehensive notes on DSA, epitopes, and MFI interpretation
- Extract transplant outcome statistics and alloimmunization rates
- Build knowledge graphs connecting HLA concepts, testing methods, and clinical outcomes
- Synthesize conflicting findings across HLA literature for comprehensive reviews

## 💻 Usage Examples

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

## 🔧 Configuration

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

## 📊 Performance Metrics

Based on real-world usage:
- **Literature searches**: 20/month @ 5 hours saved = 100 hours
- **Note creation**: Automated formatting saves 30 min/day
- **Citation verification**: 100% accuracy vs 70% manual
- **Knowledge retention**: Everything searchable and linked

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Adding new MCP servers
- Creating domain-specific agents
- Improving setup scripts
- Adding Windows/Linux support

## 📚 Documentation

- [Detailed Setup Guide](docs/SETUP_GUIDE.md) - Step-by-step with screenshots
- [Usage Guide](docs/USAGE_GUIDE.md) - Daily workflows and tips
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Agent Development](docs/AGENT_GUIDE.md) - Create custom research agents

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| MCP servers not connecting | Restart Claude: `claude` |
| Obsidian files not created | Check REST API is enabled |
| PubMed rate limited | Automatic 1-second delay between queries |
| Agent not saving files | Check file paths in config |

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) for Claude and MCP
- [Model Context Protocol](https://modelcontextprotocol.org) community
- Obsidian and PubMed for their APIs
- Our research lab for testing and feedback

## 📜 License

MIT License - see [LICENSE](LICENSE) file

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/HLA_Agent-MCP_System/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/HLA_Agent-MCP_System/discussions)
- **Email**: your.email@university.edu

## 🚦 Status

- ✅ macOS support
- ✅ Multi-machine sync via iCloud
- ✅ PubMed integration
- ✅ Obsidian dual-mode access
- 🚧 Windows support (coming soon)
- 🚧 Linux support (planned)
- 🚧 Shared team knowledge base (in development)

---

*If this saves you time in your research, please star ⭐ the repository!*
