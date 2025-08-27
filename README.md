# VERITAS

**V**erification-**E**nforced **R**esearch **I**nfrastructure with **T**racking and **A**utomated **S**tructuring

A powerful research assistant framework for Claude that enforces citation compliance, validates claims, and manages your knowledge base.

## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
./setup.sh

# 2. Configure Claude
./scripts/setup/configure-claude.sh

# 3. Restart Claude and test
# Use prompts from: tests/veritas-functional-test.md
```

## ✨ What VERITAS Does

VERITAS transforms Claude into a rigorous research assistant that:

- **Enforces Citations**: Every scientific claim requires a PMID citation
- **Validates Sources**: Real-time verification through PubMed integration  
- **Manages Knowledge**: Automatic organization in Obsidian vaults
- **Tracks Progress**: Conversation logging and daily journal generation
- **Thinks Systematically**: Sequential reasoning for complex problems

## 🎯 Perfect For

- **Grant Writers**: NIH, NSF, and other funding applications
- **PhD Students**: Literature reviews and thesis preparation
- **Research Teams**: Collaborative knowledge management
- **Clinical Researchers**: Evidence-based practice documentation
- **Any Domain**: Customizable for any research field

## 🛠 System Components

### Core Infrastructure
- **CLAUDE.md**: Constitutional rules governing all interactions
- **Domain Expert**: Field-specific templates and workflows
- **MCP Servers**: 5 specialized servers for different functions

### MCP Servers Included
1. **PubMed**: 35+ million biomedical articles with citation verification
2. **Memory**: Persistent knowledge graph management
3. **Sequential Thinking**: Step-by-step problem decomposition
4. **Conversation Logger**: Session tracking and journal generation
5. **Filesystem**: Local file and project management

### Optional: Obsidian Integration
- Create structured research notes
- Manage literature reviews
- Track daily research progress
- Build interconnected knowledge bases

## 📋 Prerequisites

- macOS or Linux (Windows via WSL)
- Node.js 18+ and npm
- Claude Desktop or Claude CLI
- Git
- (Optional) Obsidian with Local REST API plugin

## 🔧 Installation

### 1. Run Setup Script

```bash
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS
./setup.sh
```

You'll be prompted for:
- Project directory location
- Conversation log retention period (days)
- Obsidian configuration (optional)

### 2. Configure Claude

```bash
./scripts/setup/configure-claude.sh
```

Choose to:
- Merge with existing configuration (recommended)
- Replace entire configuration
- Preview changes first

### 3. Customize Your Domain

Edit the domain expert file in your project:
```bash
# Located at: [your-project]/.claude/agents/example-domain-expert.md
```

See `templates/agents/` for examples:
- `example-domain-expert.md` - Generic template
- `hla-research-example.md` - Real-world NIH F31 example

### 4. Test Your Setup

Start a new Claude conversation and try the prompts from:
```
tests/veritas-functional-test.md
```

## 📚 Documentation

### Essential Guides
- [Functional Test Prompts](tests/veritas-functional-test.md) - Verify your setup
- [Domain Expert Templates](templates/agents/README.md) - Customize for your field
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues

### Advanced Topics
- [Multi-Machine Setup](docs/user/MULTI_MACHINE.md) - Sync across devices
- [Developer Documentation](docs/developer/) - Extend VERITAS
- [MCP Server Details](docs/developer/MCP_SERVERS.md) - Technical reference

## 🧪 Testing Your Installation

Run through the functional tests to verify everything works:

```bash
# Basic functionality (required)
- Constitutional awareness
- Domain expert loading
- Filesystem access
- Memory storage
- Sequential thinking
- PubMed searching
- Conversation logging

# With Obsidian (optional)
- Vault connection
- Note creation
- Note reading
- Journal generation
```

See [tests/veritas-functional-test.md](tests/veritas-functional-test.md) for specific prompts.

## 🏗 Project Structure

```
VERITAS/
├── setup.sh                    # Main installation script
├── scripts/
│   └── setup/
│       └── configure-claude.sh # Claude configuration tool
├── templates/
│   ├── CLAUDE.md              # Constitutional rules
│   └── agents/                # Domain expert examples
├── conversation-logger/        # Session tracking system
├── tests/                     # Verification prompts
└── docs/                      # Documentation
```

## 🤝 Contributing

We welcome contributions! Areas where help is needed:

- Domain expert templates for different fields
- Documentation improvements
- Bug fixes and enhancements
- Testing on different platforms

## 🐛 Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| MCP servers not found | Restart Claude after configuration |
| Obsidian connection fails | Enable HTTPS in Local REST API plugin |
| PubMed returns no results | Check internet connection |
| Memory not persisting | Verify memory MCP in configuration |

### Getting Help

1. Check [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Review [Functional Tests](tests/veritas-functional-test.md)
3. Open an [issue on GitHub](https://github.com/VMWM/VERITAS/issues)

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Built for the Claude Code community
- Inspired by research best practices
- MCP (Model Context Protocol) by Anthropic
- PubMed integration via NCBI E-utilities

---

**Version**: 1.0.0  
**Last Updated**: August 2025  
**Created by**: Research automation enthusiasts

*Transform your research workflow with citation-enforced AI assistance*