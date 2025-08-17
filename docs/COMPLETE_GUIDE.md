# Complete System Documentation

## Table of Contents
1. [System Overview](#system-overview)
2. [Problem & Solution](#problem--solution)
3. [Core Components](#core-components)
4. [The HLA Research Agent](#the-hla-research-agent)
5. [Setup Instructions](#setup-instructions)
6. [Daily Workflows](#daily-workflows)
7. [Advanced Features](#advanced-features)
8. [Cost-Benefit Analysis](#cost-benefit-analysis)
9. [Troubleshooting](#troubleshooting)
10. [Technical Specifications](#technical-specifications)

---

## System Overview

The HLA Agent-MCP System is an AI-powered research assistant specifically designed for HLA (Human Leukocyte Antigen) and transplant immunology research. It transforms Claude Code into a comprehensive research tool that automates literature reviews, manages knowledge, and maintains persistent context across all research activities.

### Key Capabilities
- Searches both PubMed and local knowledge bases simultaneously
- Creates properly formatted notes with verified citations (PMIDs)
- Maintains context across all projects and machines
- Automates complex multi-step research workflows
- Builds an interconnected knowledge graph

## Problem & Solution

### Before This System
- Literature reviews took 6+ hours of manual searching
- Notes scattered across different projects and folders
- Citations required manual verification
- Context lost between research sessions
- Inconsistent formatting across team members
- Knowledge not searchable or interconnected

### After Implementation
- Literature reviews completed in 10 minutes
- All notes centralized in Obsidian vaults
- Citations auto-verified with PubMed PMIDs
- Context persists indefinitely via Memory MCP
- Consistent formatting via templates
- Everything searchable and cross-linked

## Core Components

### MCP Servers (Model Context Protocol)

MCP servers are specialized modules that extend Claude's capabilities:

#### 1. Memory MCP
- **Purpose**: Persistent knowledge and templates
- **Storage**: SQLite database at `/MCP-Shared/nova-memory/`
- **Contains**: 
  - Templates (IDs: 10, 11, 12, 13, 14)
  - Routing rules for content organization
  - Search history and context
  - Agent specifications
- **Key Feature**: Survives restarts, maintains context forever

#### 2. PubMed MCP
- **Purpose**: Medical literature verification
- **Auto-triggers on**:
  - Medical terminology
  - Statistical queries ("prevalence", "incidence")
  - HLA-specific terms
- **Output**: Verified citations with PMIDs
- **Rate Limiting**: Automatic 1-second delay

#### 3. Obsidian Access (Dual Mode)

**REST API Mode** (When Obsidian is running):
- Full search capabilities
- Command execution
- Real-time updates
- Index synchronization

**File System Mode** (Offline/backup):
- Direct file operations
- Works without Obsidian app
- Template application
- Bulk operations

#### 4. Sequential-Thinking MCP
- **Purpose**: Complex problem decomposition
- **Use Cases**:
  - Multi-step analyses
  - Systematic comparisons
  - Contradiction detection

### Knowledge Base Structure

```
Your Files/
├── VM_F31_2025/                        # F31 grant materials
│   ├── Notes/
│   │   ├── 2025_Specialist_Handouts/   # HLA expert lectures
│   │   ├── 2025_Basic_Handouts/        # Foundation materials
│   │   └── LG Stuff/                   # Professor's materials
│   └── LitReview/                      # Research PDFs
│
└── Obsidian/                           # Note vaults
    ├── HLA Antibodies/                 # Domain-specific
    │   ├── Research Questions/         # Q&As with PMIDs
    │   └── Concepts/                   # Knowledge nodes
    └── Research Journal/               # Daily work
        ├── Daily/                      # YYYY-MM-DD entries
        └── Concepts/                   # General concepts
```

### Template System

Templates stored in Memory MCP ensure consistency:

**Daily Entry Template** (ID: 10):
- Today's Focus
- Completed Tasks
- Cross-Project Insights
- Literature Reviewed
- Notes and Observations

**Research Question Template** (ID: 11):
- Key Findings table
- Analysis with [[wiki-links]]
- References with PMIDs

**Concept Template** (ID: 12):
- Definition
- Key Points
- Clinical Applications
- Related Concepts

### Intelligent Routing

The system automatically routes content:
```
IF medical/HLA question → HLA Antibodies vault
IF daily entry → Research Journal vault
IF "prevalence" + medical → Auto-search PubMed → HLA vault
IF general concept → Research Journal/Concepts
```

## The HLA Research Agent

### What Makes Agents Special

**Regular Claude**: Responds to single requests
**Agent**: Completes entire research workflows autonomously

### Agent Workflow

```
User: /agent "What is the prevalence of prozone effect?"

Agent autonomously:
1. Searches lecture PDFs for prozone mentions
2. Queries PubMed for recent papers
3. Extracts statistics (finds 70-85% in highly sensitized)
4. Creates Research Question note with findings
5. Identifies concepts: [[Prozone Effect]], [[C1q Interference]]
6. Creates 4-6 concept pages
7. Cross-links everything
8. Returns executive summary

Time: 2 minutes (vs 6 hours manual)
```

### Real-World Examples

#### SAB Pattern Recognition
- Input: "What SAB patterns do experts recognize?"
- Output: 10 pattern categories with detailed tables
- Created: 1 research question + 4 concept pages
- Citations: 12 PMIDs verified

#### Prozone Effect Analysis
- Found: 80% prevalence in cPRA ≥95%
- Identified: C1q complement mechanism
- Created: Complete documentation with mitigation
- Linked: Technical artifacts, EDTA treatment

### Agent Capabilities

1. **Literature Review**
   - Query expansion with MeSH terms
   - Multi-source searching
   - Quality filtering by study design
   - Data extraction and synthesis
   - Contradiction detection

2. **Knowledge Synthesis**
   - Extract preliminary data from files
   - Find supporting citations
   - Identify knowledge gaps
   - Compare methodologies
   - Synthesize conflicting findings

3. **Knowledge Graph Building**
   - Creates research question notes
   - Generates 3-8 concept pages per query
   - Establishes bidirectional links
   - Grows interconnected knowledge base

## Setup Instructions

### Prerequisites
- macOS
- VS Code
- Node.js v18+
- Obsidian
- Claude API key
- iCloud Drive enabled

### Quick Setup (15 minutes)

1. **Clone Repository**
```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

2. **Configure API Keys**
Edit the config file with your keys:
- Claude API key (required)
- PubMed API key (optional but recommended)
- Obsidian REST API key (from plugin)

3. **Create Symlink**
```bash
ln -s "~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json" ~/.claude.json
```

4. **Install Obsidian Plugin**
- Open Obsidian → Settings → Community Plugins
- Search "Local REST API"
- Install, enable, generate key
- Add key to config

5. **Test System**
```bash
claude
/mcp  # Should show all servers connected
/agent "test query about HLA"
```

### Multi-Machine Setup

On second machine, just create the symlink:
```bash
ln -s "~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json" ~/.claude.json
```
Everything syncs via iCloud automatically.

## Daily Workflows

### Morning Literature Review (5 minutes)
```bash
/agent "Find new papers this week on pediatric kidney transplantation"
```

### Research Question Investigation (10 minutes)
```bash
/agent "What percentage of recipients develop dnDSA post-transplant?"
```

### Knowledge Synthesis Session
```bash
# Extract your data
/agent "Analyze prozone patterns in my lecture notes"

# Compare methods
/agent "Compare SAB vs Luminex interpretation across labs"

# Find contradictions
/agent "What conflicts exist in MFI threshold literature?"
```

### Daily Documentation
```bash
"Create today's research journal entry with focus on SAB optimization"
```

## Advanced Features

### Complete Workflow Automation

```
Research Question
       ↓
Identifies [[concepts]]
       ↓
Creates concept page for EACH
       ↓
Cross-links everything
       ↓
Updates knowledge graph
```

### Pattern Recognition

The system recognizes complex patterns:
- MFI distribution patterns
- Epitope vs allele-specific antibodies
- Complement interference patterns
- Technical artifacts vs true positives
- Vendor-specific differences

### Contradiction Detection

Automatically identifies:
- Same data → different interpretations
- Methodological conflicts
- Evolving standards over time

## Cost-Benefit Analysis

### Monthly Costs
- Claude API: ~$20 for heavy daily use
- Setup time: 30 minutes once
- Maintenance: Near zero

### Monthly Benefits
- Time saved: 100+ hours on literature review
- Citation accuracy: 100% vs 70% manual
- Knowledge retention: Everything preserved
- Consistency: Perfect across all work

### ROI Calculation
- Time value: 100 hours × $30/hour = $3,000
- Cost: $20
- **Return: 150× investment monthly**

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| MCP not connecting | Restart: `claude` |
| Obsidian files not created | Check REST API enabled |
| PubMed rate limited | Automatic 1-sec delay handles this |
| Agent stuck | Wait 60 seconds for completion |
| Wrong vault used | Update Memory MCP routing rules |

### Diagnostic Commands
```bash
# Check servers
/mcp

# Test memory
"Store: test value 42"
"Recall: what was the test value?"

# Test PubMed
"Search PubMed for HLA papers from 2024"

# Check logs
cat ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/logs/*.log
```

## Technical Specifications

### Memory MCP Storage
- Location: `/MCP-Shared/nova-memory/memory.db`
- Format: SQLite with vector embeddings
- Key template IDs:
  - 10: Daily entry template
  - 11: Research question template
  - 12: Concept template
  - 13: Routing rules
  - 14: Complete workflow

### Performance Metrics
- Agent query: 1-3 minutes
- Simple search: <5 seconds
- Note creation: <1 second
- Memory lookup: Instant

### File Paths
```bash
# Configuration
~/.claude.json → iCloud/MCP-Shared/claude-desktop-config.json

# Knowledge Base
~/Library/CloudStorage/Box-Box/VM_F31_2025/
~/Library/CloudStorage/Box-Box/Obsidian/

# Memory Database
~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory/
```

## Key Differentiators

### This is NOT ChatGPT

| Feature | ChatGPT | HLA Agent-MCP |
|---------|---------|---------------|
| Your files | No | Yes - all PDFs |
| PubMed | No | Automatic PMIDs |
| Memory | Per chat | Permanent |
| Citations | Often fake | Always verified |
| Output | Chat only | Obsidian files |
| Sync | No | All machines |
| HLA expertise | Generic | Specialized |

### Why This Matters for Research

1. **Reproducibility**: All citations verifiable
2. **Accumulation**: Knowledge builds over time
3. **Collaboration**: Shareable configurations
4. **Efficiency**: 10× faster than manual
5. **Accuracy**: No fabricated references

## Future Enhancements

### Immediate Roadmap
- Team knowledge base sharing
- Automated weekly literature reports

### Long-term Vision
- Custom lab-specific agents
- Integration with lab instruments
- Automated manuscript drafting
- Clinical decision support

---

*System Version: 2.0*
*Last Updated: August 2025*
*Daily Active Use: 8+ hours*