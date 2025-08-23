# Research Agent-MCP System

Transform Claude into your intelligent research assistant with enforced best practices, automated knowledge management, and seamless Obsidian integration.

## What Is This?

A comprehensive enforcement and automation system that ensures Claude Code consistently follows your research workflow, maintains citation standards, and organizes knowledge exactly how you need it. No more repeated instructions, no more formatting fixes, no more missed citations.

## Who Is This For?

### Academic Researchers
- Writing grants, papers, or dissertations
- Managing literature reviews across hundreds of papers
- Building interconnected knowledge graphs
- Tracking daily research progress

### Graduate Students
- Preparing for qualifying exams
- Organizing thesis research
- Managing citations and references
- Creating study notes that connect concepts

### Research Teams
- Standardizing documentation practices
- Sharing knowledge bases
- Maintaining consistent citation standards
- Collaborative literature reviews

### Knowledge Workers
- Building personal knowledge management systems
- Connecting ideas across domains
- Maintaining professional notebooks
- Creating reference documentation

## Core Features

### Multi-Layer Enforcement System
Never repeat instructions again. The system enforces your requirements through:
- **Pre-execution validation** - Checks tasks before they start
- **Smart routing** - Automatically uses correct tools for each task
- **Output verification** - Validates all content meets standards
- **Compliance blocking** - Prevents incorrect operations entirely

### Integrated Literature Management
Seamless PubMed integration with automatic citation verification:
- Every claim backed by peer-reviewed sources
- Automatic PMID verification
- Full-text retrieval when available
- Citation formatting that never fails

### Intelligent Task Planning
Sequential thinking that breaks down complex research:
- Automatic problem decomposition
- Step-by-step execution tracking
- Context-aware decision making
- Progress visualization

### Obsidian Knowledge Graph
Direct integration with your Obsidian vaults:
- Automatic note creation with proper templates
- Wiki-link knowledge connections
- Structured folders for different content types
- Daily research journals with metrics

### Living Knowledge Base
Memory system that grows with your research:
- Persistent concept storage
- Relationship mapping between ideas
- Quick retrieval of past findings
- Knowledge evolution tracking

## Example Use Case

Imagine you're preparing for qualifying exams and need to master 200 papers across 5 research areas:

```
You: "Create a research question about how MFI thresholds affect organ allocation"

Claude: [Automatically]
1. Starts with sequential thinking to plan approach
2. Searches PubMed for latest evidence 
3. Creates formatted research question in Obsidian
4. Includes all citations with PMIDs
5. Links to related concepts
6. Generates grant-ready prose
7. Updates your knowledge graph
```

No manual formatting. No missing citations. No repeated instructions.

## What Makes This Different?

### Traditional Approach
```
You: "Search for papers about X (remember to include PMIDs)"
Claude: [Might forget PMIDs]

You: "Create a note in my Obsidian vault"
Claude: [Creates file in wrong location]

You: "Format it properly with wiki links"
Claude: [Uses wrong formatting]

[Repeat instructions every conversation...]
```

### With Research Agent System
```
You: "Research question about X"
Claude: [Automatically does everything correctly, every time]
```

## System Architecture

The system uses five specialized MCP (Model Context Protocol) servers:

1. **Sequential Thinking** - Structured problem-solving and planning
2. **PubMed** - Direct access to 35+ million biomedical citations
3. **Memory** - Persistent knowledge graph storage
4. **Filesystem** - Local project file access
5. **Obsidian REST** - Direct vault integration

All coordinated through an intelligent hook system that enforces your workflow automatically.

## Real Research Templates

Professional templates designed for academic research:

### Research Questions
- Grant-ready narrative sections
- Evidence-based key points with citations
- Quantitative impact summaries
- Knowledge gap identification
- Direct application to grant writing

### Concept Notes
- Innovation details with validation data
- Implementation guides
- Quality control specifications
- Comparison tables with metrics
- Clinical pearls and key thresholds

### Daily Journals
- Session metrics and achievements
- Decision rationale documentation
- Problem-solving records
- Progress tracking
- Reference management

## Success Stories

*"Reduced my literature review time by 60% while improving citation accuracy to 100%"*

*"Finally have a system that maintains my exact formatting requirements without constant reminders"*

*"Built a 500+ note knowledge base for my dissertation in 3 months"*

## Customization

Fully adaptable to your research domain:
- Medical/Clinical research
- Computer Science/Engineering
- Social Sciences
- Humanities
- Hard Sciences

Customize citation formats, templates, validation rules, and workflows to match your field's requirements.

## Getting Started

Ready to transform your research workflow?

1. **Quick Start**: See [`docs/SETUP.md`](docs/SETUP.md)
2. **Full Checklist**: See [`docs/SETUP_CHECKLIST.md`](docs/SETUP_CHECKLIST.md)  
3. **Customization**: See [`docs/CUSTOMIZATION.md`](docs/CUSTOMIZATION.md)
4. **Troubleshooting**: See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)
5. **MCP Details**: See [`docs/MCP_INSTALLATION.md`](docs/MCP_INSTALLATION.md)

## Requirements

- Claude Desktop (Claude Code)
- Obsidian with REST API plugin
- Node.js 16+
- Python 3.8+
- macOS, Linux, or Windows with WSL

## Installation

```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

The setup script handles everything: MCP installation, hook configuration, and path setup.

## Open Source

MIT Licensed - Contributions welcome!

Fork it, customize it, share it with your research community.

## Support

- **Documentation**: Complete guides in `/docs`
- **Templates**: Professional templates in `/templates/obsidian`
- **Issues**: [GitHub Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues) for bugs and features
- **Customization**: Examples for different research domains

---

*Stop managing Claude. Start doing research.*

**[Get Started →](docs/SETUP.md)** | **[View Documentation](docs/)** | **[Report Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues)**