<p align="center">
  <img src="assets/VERITAS.png" alt="VERITAS" width="600">
</p>

# VERITAS
Verification-Enforced Research Infrastructure with Tracking and Automated Structuring

A Claude Code research framework that enforces citation compliance, validates scientific claims in real-time, and automatically structures your knowledge base.

## Table of Contents

- [About VERITAS](#about-veritas)
- [What Makes VERITAS Different](#what-makes-veritas-different)
- [System Architecture](#system-architecture)
- [Core Features](#core-features)
- [System Components](#system-components)
- [Documentation](#documentation)
- [Example Workflow](#example-workflow)
- [Requirements](#requirements)
- [Installation Details](#installation-details)
- [Creating Your Domain Configuration](#creating-your-domain-configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Get VERITAS](#get-veritas)

## About VERITAS

VERITAS embodies the core principle of truth in research. Every claim must be verified, every source must be cited, and every process is tracked to maintain complete research integrity.

- **Verification-Enforced** - Active enforcement of citation requirements through hooks and compliance checks
- **Research Infrastructure** - Complete framework providing a professional research environment
- **Tracking and Automated Structuring** - Intelligent organization and documentation of all research activities

**GitHub**: https://github.com/VMWM/VERITAS

## What Makes VERITAS Different

Unlike other research tools, VERITAS provides:

1. **Real-time Citation Enforcement** - Claims without PMIDs are flagged and violations reported for correction
2. **Multi-layer Validation** - Pre-command, during execution, and post-command checks ensure compliance
3. **Domain Expert System** - Customizable templates for any research field
4. **Integrated Knowledge Graph** - Automatic knowledge organization via Memory MCP and structured templates
5. **Professional Templates** - Grant-ready research questions and concept notes out of the box

## System Architecture

```
User Message → Pre-Command Hooks → Claude Processes → Tool Calls → Post-Validation → Response
                    ↓                      ↓                            ↓
              (Shows reminders)    (Reads CLAUDE.md)         (Checks what was created)
                    ↓                      ↓                            ↓
              (Sets env vars)     (Follows instructions)    (Logs violations & reports)
```

This multi-checkpoint architecture ensures research integrity at every step.

## Core Features

### Research Management
- **Literature Reviews** - Automatic PubMed citation verification (35+ million articles)
- **Research Questions** - Structured templates for grant applications
- **Concept Notes** - Wiki-linked knowledge base with validation
- **Daily Journals** - Automatic progress tracking and summarization

### Quality Enforcement
- **Citation Validation** - Every claim should include (Author et al., Year, PMID: XXXXXXXX)
- **Format Guidelines** - Tables, headers, and links follow strict standards
- **Output Verification** - Post-execution checks report compliance status

### Knowledge Integration
- **Memory MCP** - Persistent knowledge graph for entities and relationships
- **Obsidian Vaults** - Direct integration with your research notes
- **Session Tracking** - Automatic conversation logging with 5-day retention

## System Components

### MCP Servers

#### External Servers (via npx)
1. **Sequential Thinking** - Task decomposition and planning
2. **PubMed** - Citation search and verification  
3. **Memory** - Knowledge graph storage
4. **Filesystem** - Project file access
5. **Obsidian REST (Primary)** - Main vault operations
6. **Obsidian REST (Journal)** - Journal vault operations

#### Custom VERITAS Server
7. **Conversation Logger** - Session tracking and journal generation
   - **Special**: Custom-built server that runs from VERITAS directory
   - **Not copied**: Stays in `/conversation-logger/`, acts as shared service
   - **Manual setup**: Requires absolute path in Claude Desktop config
   - **Stateful**: Maintains SQLite database of all conversations

### Enforcement System

- **Pre-command hooks** - Display requirements and guidelines before execution
- **Task router** - Intelligent task detection and routing recommendations
- **Compliance validator** - Attempts to block incorrect tool usage patterns
- **Post-command validator** - Reports compliance status and violations

### Your Project After Installation

Once VERITAS is installed, your project will have this structure:

```
YourProject/
├── CLAUDE.md                  # Constitutional rules (read-only)
├── .claude/                   # VERITAS configuration
│   ├── hooks/                # Enforcement scripts
│   │   ├── pre-command.sh   # Pre-execution validation
│   │   ├── post-command.py  # Citation verification
│   │   └── ...              # Other validation hooks
│   ├── agents/              # Domain expertise
│   │   └── domain-expert.md # Your field-specific configuration
│   ├── templates/           # Note templates
│   │   ├── research_question_template.md
│   │   ├── concept_template.md
│   │   └── daily_journal_template.md
│   ├── scripts/             # Utility scripts
│   ├── logs/                # Validation logs
│   └── project.json         # Project configuration
└── [Your existing files]      # Your research content
```

The VERITAS repository remains at `~/VERITAS/` to provide:
- Conversation logger MCP server
- Test scripts for verification
- Documentation and updates

## Documentation

### Getting Started
- **[Installation Guide](docs/getting-started.md)** - Complete setup walkthrough with commands and troubleshooting
- **[Functional Tests](tests/veritas-functional-test.md)** - Verify your setup

### Configuration
- **[Configuration Guide](docs/configuration-guide.md)** - Adapt for your research domain and connect Obsidian
- **[Domain Expert Templates](install/templates/agents/README.md)** - Field-specific configurations

### Troubleshooting
- **[Troubleshooting Guide](docs/troubleshooting.md)** - Common issues and solutions
- **[MCP Server Reference](docs/reference/mcp-servers.md)** - Technical specifications

## Example Workflow

### Creating a Research Question

```
You: "Create a research question about machine learning in medical diagnosis"

VERITAS enforces a workflow that:
1. Starts with sequential thinking for planning
2. Searches PubMed for relevant literature  
3. Creates formatted note in Research Questions/
4. Generates linked concept pages
5. Validates all citations have PMIDs
6. Reports compliance status

The structured templates and Memory MCP work together to organize knowledge automatically
```

### Result Structure

```markdown
# How Does Machine Learning Improve Medical Diagnosis

## Direct Answer
Machine learning significantly enhances diagnostic accuracy...
(Smith et al., 2023, PMID: 37654321) [ABSTRACT-VERIFIED]

## Key Findings
- 92% accuracy improvement in radiology (Jones et al., 2024, PMID: 38765432)
- Reduced false positives by 45% (Chen et al., 2023, PMID: 37890123)

## Knowledge Gaps
- Limited validation in diverse populations
- Interpretability challenges remain unresolved

## Grant Applications
**Significance**: Addresses critical diagnostic errors...
**Innovation**: Novel approach combining...
**Approach**: Three-phase validation study...

## References
1. Smith J, et al. (2023). Machine Learning in Medicine. PMID: 37654321
2. Jones K, et al. (2024). AI Radiology Applications. PMID: 38765432

## Related Concepts
- [[Machine_Learning]]
- [[Medical_Diagnosis]]
- [[Diagnostic_Accuracy]]
```

## Requirements

### Platform
- **macOS** or **Linux** (Unix-based system required)
- **Windows**: Not currently supported (would require WSL)

### Software
- **Claude Desktop** (Claude Code) with API access
- **Node.js** v16+ and npm
- **Python** 3.8+
- **Git**
- **Bash shell** (for scripts)
- **Obsidian** with Local REST API plugin

### Quick Check
```bash
# Verify prerequisites
command -v node && echo "Node.js: OK" || echo "Node.js: MISSING"
command -v python3 && echo "Python: OK" || echo "Python: MISSING"
command -v git && echo "Git: OK" || echo "Git: MISSING"
```

## Installation Details

Full installation guide: [docs/getting-started.md](docs/getting-started.md)

### What the Setup Script Does

The setup script (`install/scripts/setup.sh`) provides:
- Installation of VERITAS hooks and constitution  
- Project type selection (medical research, software, documentation)
- Creation of `.claude/` directory structure in your project
- Template installation for your domain
- Conversation logger setup (special: runs from VERITAS as shared service)
- MCP server configuration for Claude Desktop

## Creating Your Domain Configuration

### Option 1: If You Used Claude Code Installation
Claude automatically created a custom domain expert file based on the field, citation style, and grant type you specified.

### Option 2: If You Installed Manually

After running the setup scripts, create your domain expert configuration:

**For Medical Research:**
The HLA template is already copied to your project. You can use it as-is or modify it.

**For Other Fields:**
Ask Claude to create a domain expert for you:
```
Create a domain expert configuration for my project:
- Field: [your field, e.g., software engineering]
- Research focus: [e.g., security vulnerability analysis]
- Citation style: [e.g., GitHub/DOI]
- Grant type: [e.g., NSF/none]

Adapt the template from .claude/agents/hla-research-director.md
Save as .claude/agents/domain-expert.md
```

### Customizing Your Domain Expert
To modify your domain expert after creation:
1. Edit `.claude/agents/[your-domain]-expert.md` in your project
2. Update research aims, templates, and citation formats
3. Restart Claude to apply changes

See [Domain Expert Templates](install/templates/agents/README.md) for instructions on creating domain-specific templates.

**Currently Included:**
- Medical/Clinical Research (HLA antibody research template)

**User-Created Templates Needed For:**
- Computer Science/Engineering
- Social Sciences
- Other research domains

## Troubleshooting

### Common Issues

| Issue | Solution |
| --- | --- |
| Claude doesn't recognize CLAUDE.md | Restart Claude Desktop after setup |
| "Command not found: claude" | Claude CLI is optional, use Desktop app |
| Validation hooks not running | Check you're in project directory with CLAUDE.md |
| Templates not found | Verify `.claude/agents/domain-expert.md` exists in your project |
| Obsidian connection fails | Enable HTTPS (not HTTP) in Local REST API plugin |

### Getting Help

1. Check **[Troubleshooting Guide](docs/troubleshooting.md)**
2. Review **[Functional Tests](tests/veritas-functional-test.md)**
3. Open an [issue on GitHub](https://github.com/VMWM/VERITAS/issues)

## Contributing

We welcome contributions! 

### Current Priorities

Check out our [open issues](https://github.com/VMWM/VERITAS/issues) for specific tasks that need help.

### Ways to Contribute

- **Domain Templates** - Share your field-specific configurations
- **MCP Integrations** - Connect additional research tools
- **Documentation** - Improve guides and examples
- **Bug Reports** - Help us identify and fix issues
- **Feature Requests** - Suggest improvements via [issues](https://github.com/VMWM/VERITAS/issues/new)

### How to Contribute

1. Check [existing issues](https://github.com/VMWM/VERITAS/issues) first
2. Fork the repository
3. Create a feature branch
4. Submit a pull request to: https://github.com/VMWM/VERITAS

## License

MIT License - See [license](license) file for details

## Acknowledgments

- Built for the Claude Code research community
- Powered by MCP (Model Context Protocol) by Anthropic
- Inspired by scientific best practices

---

## Get VERITAS

### Option 1: Let Claude Code Install VERITAS (Recommended)

**Step 1: Customize this template by replacing the bracketed text:**

```
Install VERITAS for me by executing these steps:
1. Clone https://github.com/VMWM/VERITAS.git to ~/VERITAS
2. Create my project directory at [REPLACE: ~/Projects/YourProjectName]
3. Copy VERITAS files to my project:
   - CLAUDE.md as read-only constitution
   - .claude/ directory with hooks, templates, scripts
4. Create domain expert by adapting ~/VERITAS/install/templates/agents/hla-research-director.md:
   - Read the template file
   - Adapt it for my field: [REPLACE: Choose one: medical/software/social-science/engineering/other]
   - Update research focus: [REPLACE: e.g., "machine learning security" or "cancer immunotherapy"]
   - Change citation style: [REPLACE: Choose one: PMID/DOI/arXiv/GitHub/APA/IEEE]
   - Set grant type: [REPLACE: Choose one: NIH/NSF/DoD/none]
   - Save as .claude/agents/domain-expert.md in my project
5. Install MCP servers:
   - External: sequential-thinking, pubmed, memory, filesystem (via npx)
   - Custom: conversation-logger (from ~/VERITAS/conversation-logger)
6. Configure Claude Desktop for [REPLACE: macOS or Linux]
   - Include conversation-logger with absolute path to ~/VERITAS
7. Test that everything works

After installation: Configure Obsidian manually (see Configuration Guide)
```

**Step 2: Copy your customized version to Claude Code**

Claude will execute the installation commands directly, showing you each step.

### Ready-to-Use Examples

**Example 1: Software Engineering (copy this exactly):**
```
Install VERITAS for me by executing these steps:
1. Clone https://github.com/VMWM/VERITAS.git to ~/VERITAS
2. Create my project directory at ~/Projects/SecurityAudit
3. Copy VERITAS files to my project:
   - CLAUDE.md as read-only constitution
   - .claude/ directory with hooks, templates, scripts
4. Create domain expert by adapting ~/VERITAS/install/templates/agents/hla-research-director.md:
   - Read the template file
   - Adapt it for software engineering
   - Update research focus to: open source security vulnerability analysis
   - Change citation style from PMID to: GitHub URLs and CVE IDs
   - Remove grant-specific sections (no grant funding)
   - Save as .claude/agents/domain-expert.md in my project
5. Install MCP servers:
   - External: sequential-thinking, pubmed, memory, filesystem (via npx)
   - Custom: conversation-logger (from ~/VERITAS/conversation-logger)
6. Configure Claude Desktop for macOS
   - Include conversation-logger with absolute path to ~/VERITAS
7. Test that everything works

After installation: Configure Obsidian manually (see Configuration Guide)
```

**Example 2: Medical Research (copy this exactly):**
```
Install VERITAS for me by executing these steps:
1. Clone https://github.com/VMWM/VERITAS.git to ~/VERITAS
2. Create my project directory at ~/Projects/TransplantResearch
3. Copy VERITAS files to my project:
   - CLAUDE.md as read-only constitution
   - .claude/ directory with hooks, templates, scripts
4. Create domain expert by copying ~/VERITAS/install/templates/agents/hla-research-director.md:
   - Copy the template file (already configured for medical research)
   - Keep PMID citation style
   - Update research focus if needed (current: transplant immunology and HLA antibodies)
   - Keep NIH grant sections
   - Save as .claude/agents/hla-research-director.md in my project
5. Install MCP servers:
   - External: sequential-thinking, pubmed, memory, filesystem (via npx)
   - Custom: conversation-logger (from ~/VERITAS/conversation-logger)
6. Configure Claude Desktop for macOS
   - Include conversation-logger with absolute path to ~/VERITAS
7. Test that everything works

After installation: Configure Obsidian manually (see Configuration Guide)
```

### Option 2: Manual Installation

For interactive installation with prompts:

```bash
# Clone the repository
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS

# Run setup (you'll be prompted for your project directory)
./install/scripts/setup.sh

# Configure Claude Desktop
./install/scripts/configure-claude.sh

# Restart Claude Desktop completely
```

**Note**: The setup scripts are interactive and will prompt you for choices. Claude Code cannot respond to these prompts automatically, which is why Option 1 has Claude execute the steps directly.

### Verify Your Installation

**Quick Check:**
Start a new Claude Code conversation and say:
```
"What is your role according to CLAUDE.md?"
```
Claude should respond with awareness of the VERITAS system and its research integrity requirements.

**Comprehensive Testing:**
Run the verification scripts in the `/tests` folder:
```bash
# Run automated verification
cd ~/VERITAS/tests
./verify-installation.sh

# Or follow the functional test guide
cat veritas-functional-test.md
# Then test each prompt in Claude Code
```

The functional tests verify:
- MCP server connections
- Citation enforcement
- Template creation
- Knowledge graph storage
- Conversation logging

For medical research users, also test:
```bash
cat veritas-functional-test-HLA-specific.md
# Test HLA-specific workflows
```

### Configure Obsidian (Required)

After installation, set up Obsidian manually:

1. Install Obsidian and create vault(s)
2. Install Local REST API plugin from Community Plugins
3. Configure authentication (Bearer token or API key)
4. Set port (27124 for single vault, or 27124/27125 for dual vault)
5. Update MCP configuration with your Obsidian settings

See [Configuration Guide](docs/configuration-guide.md) for detailed Obsidian setup instructions.

---

**Ready to transform your research workflow?** Get started with VERITAS today!