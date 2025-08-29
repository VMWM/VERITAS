<p align="center">
  <img src="assets/VERITAS.png" alt="VERITAS" width="600">
</p>

# VERITAS

Verification-Enforced Research Infrastructure with Tracking and Automated Structuring

A Claude Code research framework optimized for biomedical and medical research that enforces PubMed citation compliance, validates scientific claims in real-time, and automatically structures your knowledge base for grant applications and publications.

## Demo

[![VERITAS Demo Video](https://img.youtube.com/vi/y-mCZ2RODqw/maxresdefault.jpg)](https://www.youtube.com/watch?v=y-mCZ2RODqw)
*Click the image above to watch the VERITAS demo on YouTube*

<!-- For embedding in documentation sites, use this iframe:
<iframe width="560" height="315" src="https://www.youtube.com/embed/y-mCZ2RODqw?si=NkycriEI9UMhMRu8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
-->

## Table of Contents

- [Demo](#demo)
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

VERITAS embodies the core principle of truth in biomedical research. Designed specifically for medical and life science researchers, it ensures every scientific claim is backed by PubMed citations, maintains research integrity, and streamlines grant application workflows.

- **Verification-Enforced** - Automatic PubMed citation verification (35+ million articles)
- **Research Infrastructure** - Complete framework for NIH grant applications and clinical research
- **Tracking and Automated Structuring** - Intelligent organization of biomedical literature and findings

**GitHub**: https://github.com/VMWM/VERITAS

**Primary Focus**: Biomedical, medical, and clinical research with PMID-based citation enforcement

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

- **PMID Verification System** - Zero-tolerance policy for citation errors
  - Automatic verification against PubMed database
  - Pre-commit hooks block documents with invalid PMIDs
  - Python script validates author names and publication years
  - All verifications logged for audit trail
- **Citation Validation** - Every claim must include (Author et al., Year, PMID: XXXXXXXX)
- **Format Guidelines** - Tables, headers, and links follow strict standards
- **Output Verification** - Post-execution checks report compliance status

### Knowledge Integration

- **Memory MCP** - Persistent knowledge graph for entities and relationships
- **Obsidian Vaults** - Direct integration with your research notes
- **Session Tracking** - Automatic conversation logging with 5-day retention

## System Components

### MCP Servers

#### Globally Installed Servers (npm install -g)

1. **PubMed (@ncukondo/pubmed-mcp)** - Citation search and verification (requires NCBI credentials)
2. **Obsidian REST** - Vault operations (supports multiple vault configurations)

#### npx Executed Servers (no installation required)

3. **Sequential Thinking** - Task decomposition and planning
4. **Memory** - Knowledge graph storage
5. **Filesystem** - Project file access

#### Custom VERITAS Server

6. **Conversation Logger** - Session tracking and journal generation
   - **Special**: Custom-built server that runs from VERITAS directory
   - **Not copied**: Stays in `/conversation-logger/`, acts as shared service
   - **Uses absolute path**: Points to `~/VERITAS/conversation-logger/index.js`
   - **Important**: If you move VERITAS after installation, update the path in Claude Desktop config
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
│   │   ├── pre-citation-hook.sh # PMID verification
│   │   └── ...              # Other validation hooks
│   ├── agents/              # Domain expertise
│   │   └── domain-expert.md # Your field-specific configuration
│   ├── templates/           # Note templates
│   │   ├── research_question_template.md
│   │   ├── concept_template.md
│   │   └── daily_journal_template.md
│   ├── scripts/             # Utility scripts
│   │   └── verify_pmids.py  # PMID validation script
│   ├── logs/                # Validation logs
│   └── project.json         # Project configuration
└── [Your existing files]      # Your research content
```

The VERITAS repository remains at `~/VERITAS/` with this structure:

```
~/VERITAS/
├── assets/                    # Images and logos
├── conversation-logger/       # MCP conversation logger
├── docs/                      # Documentation
├── install/
│   ├── CLAUDE.md             # Constitutional document
│   ├── hooks/                # All enforcement hooks
│   ├── mcp-wrappers/         # MCP compatibility wrappers
│   │   └── pubmed-wrapper.js # PubMed MCP wrapper for Desktop
│   ├── scripts/              # Setup and configuration scripts
│   └── templates/
│       ├── agents/           # Domain expert templates
│       ├── config/           # Configuration templates
│       └── obsidian/         # Note templates
└── tests/                     # Verification scripts
```
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

## Domain Configuration

VERITAS is optimized for **biomedical and medical research**, with built-in support for:

- PubMed citation verification (35+ million articles)
- PMID enforcement for all scientific claims
- NIH grant application formatting
- Clinical research documentation standards
- HLA/immunology research templates

### Customizing for Your Research Area

The setup script installs a medical research template (HLA antibody research). To adapt it for your specific biomedical field:

1. **Edit the domain expert file** at `.claude/agents/hla-research-director.md`
2. **Update research focus areas** to match your field (e.g., oncology, neuroscience, genetics)
3. **Modify grant sections** for your funding agency (NIH, NSF, DoD)
4. **Adjust templates** for your documentation needs

### Example Customization

```
Ask Claude: "Adapt the HLA domain expert for [your biomedical field]:
- Research focus: [e.g., cancer immunotherapy, neurodegeneration]
- Grant type: [e.g., R01, K99/R00, F32]
- Specific requirements: [e.g., clinical trial protocols, biomarker analysis]"
```

### For Non-Biomedical Research

VERITAS's core features assume biomedical research workflows. Adapting for other domains (software engineering, social sciences) requires manual configuration:

See the section **"Adapting VERITAS for Other Domains"** below for instructions.

## Troubleshooting

### Common Issues

| Issue                              | Solution                                                          |
| ---------------------------------- | ----------------------------------------------------------------- |
| Claude doesn't recognize CLAUDE.md | Restart Claude Desktop after setup                                |
| "Command not found: claude"        | Claude CLI is optional, use Desktop app                           |
| Validation hooks not running       | Check you're in project directory with CLAUDE.md                  |
| Templates not found                | Verify `.claude/agents/domain-expert.md` exists in your project |
| Obsidian connection fails          | Enable HTTPS (not HTTP) in Local REST API plugin                  |

### Getting Help

1. Check **[Troubleshooting Guide](docs/troubleshooting.md)**
2. Review **[Functional Tests](tests/veritas-functional-test.md)**
3. Open an [issue on GitHub](https://github.com/VMWM/VERITAS/issues)

## Adapting VERITAS for Other Domains

While VERITAS is optimized for biomedical research, it can be manually adapted for other fields. Here's what you'll need to modify:

### For Software Engineering

1. **Disable PubMed enforcement** in `.claude/project.json`:

   ```json
   "strict_citations": false,
   "type": "software"
   ```
2. **Create a new domain expert**:

   - Remove biomedical-specific sections from the HLA template
   - Replace PMID requirements with GitHub/DOI citations
   - Add software-specific templates (code reviews, documentation, testing)
3. **Adjust MCP servers** (optional):

   - You may not need the PubMed server
   - Consider adding GitHub or GitLab integration tools
4. **Modify hooks** in `.claude/hooks/`:

   - Edit `post-command.py` to check for different citation formats
   - Adjust validation rules for your documentation standards

### For Social Sciences/Humanities

1. **Update citation style** in the domain expert:

   - Replace PMID with DOI/ISBN/URL citations
   - Use APA/MLA/Chicago formatting
2. **Modify templates** for qualitative research:

   - Interview protocols
   - Literature review structures
   - Theoretical frameworks
3. **Adjust enforcement levels** to match your field's standards

### General Adaptation Steps

1. **Run the standard installation** first
2. **Edit `.claude/project.json`** to change project type
3. **Create a custom domain expert** file
4. **Test and iterate** on the configuration

**Note**: Core VERITAS features (sequential thinking, memory management, conversation logging) work across all domains. The main adaptations involve citation styles and domain-specific templates.

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

**For Biomedical Research Projects: modify the bracketed sections and paste into your Claude Code chat.**

```
Install VERITAS for me by executing these steps:
1. Clone https://github.com/VMWM/VERITAS.git to ~/VERITAS
2. Create my project directory at [REPLACE: ~/Projects/YourResearchProject]
3. Copy VERITAS files to my project:
   - CLAUDE.md as read-only constitution
   - .claude/ directory with hooks, templates, scripts
4. Install the HLA research template:
   - Copy ~/VERITAS/install/templates/agents/hla-research-director.md
   - Customize for my specific field: [REPLACE: e.g., "cancer immunotherapy" or "neurodegeneration"]
   - Update grant type if needed: [REPLACE: e.g., "F31", "R01", "K99/R00"]
   - Save as .claude/agents/hla-research-director.md in my project
5. Install MCP servers:
   - Global installs: pubmed (@ncukondo/pubmed-mcp), obsidian-rest (@modelcontextprotocol/server-obsidian-rest)
   - npx execution (no install): sequential-thinking, memory, filesystem
   - Custom: conversation-logger (from ~/VERITAS/conversation-logger)
   - Note: PubMed server requires NCBI email and API key (see docs/SETUP_PUBMED.md)
6. Configure Claude Desktop for [REPLACE: macOS or Linux]
   - Include conversation-logger with absolute path to ~/VERITAS/conversation-logger
7. Test that everything works

After installation: Configure Obsidian manually (see Configuration Guide)
```

### Ready-to-Use Example

**Biomedical Research Installation (copy and customize):**

```
Install VERITAS for me by executing these steps:
1. Clone https://github.com/VMWM/VERITAS.git to ~/VERITAS
2. Create my project directory at ~/Projects/MyBiomedicalResearch
3. Copy VERITAS files to my project:
   - CLAUDE.md as read-only constitution
   - .claude/ directory with hooks, templates, scripts
4. Install the medical research template:
   - Copy ~/VERITAS/install/templates/agents/hla-research-director.md
   - This template is pre-configured for biomedical research with PMID citations
   - Update research focus for your specific area (e.g., cancer, neuroscience, immunology)
   - Modify grant sections for your funding agency (NIH F31, R01, K99/R00, etc.)
   - Save as .claude/agents/hla-research-director.md in my project
5. Install MCP servers:
   - Global installs: pubmed (@ncukondo/pubmed-mcp), obsidian-rest (@modelcontextprotocol/server-obsidian-rest)
   - npx execution (no install): sequential-thinking, memory, filesystem
   - Custom: conversation-logger (from ~/VERITAS/conversation-logger)
   - Note: PubMed server requires NCBI email and API key (see docs/SETUP_PUBMED.md)
6. Configure Claude Desktop for macOS
   - Include conversation-logger with absolute path to ~/VERITAS/conversation-logger
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
