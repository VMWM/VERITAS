# Customization Guide

## Overview
The HLA Research MCP System comes pre-configured with core knowledge and rules, but is designed to be customized for your specific research needs.

## What Comes Pre-Configured

### Core Knowledge (Automatically Loaded)
- Obsidian formatting rules (Research Questions must end with "?")
- Knowledge graph linking requirements
- MCP server usage guidelines
- HLA domain knowledge base (MFI cutoffs, Halifax Protocol, etc.)

### Templates
- Research Question template
- Concept page template
- Daily journal template
- CLAUDE.md project configuration

## How to Customize

### 1. Add Your Own Domain Knowledge

Edit `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory/core-knowledge.json` to add your domain-specific knowledge:

```json
{
  "your_domain": {
    "key_facts": {
      "fact1": "Your domain-specific fact",
      "source": "Your citation"
    }
  }
}
```

### 2. Customize Templates

Templates are located in `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/templates/`

To modify for your field:
1. Keep the structure but change the content
2. Update tags to match your domain
3. Adjust table headers for your data types

Example for cardiology research:
```markdown
---
type: research-question
tags: [research, literature-review, cardiology, cardiac-imaging]
---
```

### 3. Project-Specific CLAUDE.md

Each project can have its own CLAUDE.md file. Copy the template and customize:

```bash
cp ~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/templates/CLAUDE.md ~/YourProject/CLAUDE.md
```

Then edit the "Project-Specific Instructions" section:
```markdown
## Project-Specific Instructions
- Focus on cardiac MRI imaging protocols
- Use ACC/AHA guideline terminology
- Link to cardiology-specific concept vault
```

### 4. Customize Obsidian Vault Structure

The default structure is:
```
Obsidian/
├── HLA Antibodies/
│   ├── Research Questions/
│   └── Concepts/
└── Research Journal/
    ├── Daily/
    └── Concepts/
```

Create your own structure:
```
Obsidian/
├── Your Research Area/
│   ├── Research Questions/
│   ├── Concepts/
│   ├── Protocols/
│   └── Data Analysis/
└── Lab Notebook/
    └── Experiments/
```

### 5. Add Custom MCP Servers

Edit `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json`:

```json
{
  "mcpServers": {
    // ... existing servers ...
    "your-custom-server": {
      "command": "npx",
      "args": ["your-mcp-package"],
      "env": {
        "YOUR_API_KEY": "key-here"
      }
    }
  }
}
```

### 6. Customize PubMed Searches

Add your field-specific search terms to memory:
```json
{
  "search_preferences": {
    "default_filters": ["your field[MeSH]", "last 5 years"],
    "priority_journals": ["Nature Medicine", "Your Journal"]
  }
}
```

## Sharing Your Customizations

### With Your Lab
1. Export your customized templates and memory files
2. Share via GitHub fork or direct file transfer
3. Others can merge your customizations with their base setup

### Creating a Field-Specific Fork
1. Fork the main repository
2. Replace HLA-specific content with your field
3. Update all templates and examples
4. Share with your community

## Maintaining Core Functionality

### What NOT to Change
- MCP server usage rules (obsidian-rest vs filesystem)
- Basic formatting rules (Research Questions end with "?")
- Knowledge graph linking syntax (`[[Concept]]`)
- Template structure (keep frontmatter and sections)

### Safe to Customize
- Domain knowledge content
- Tag hierarchies
- Folder structures
- Additional templates
- Custom workflows

## Examples of Successful Customizations

### For Genomics Research
- Added VCF file parsing templates
- Created gene variant concept structure
- Integrated with genome browsers

### For Clinical Trials
- Protocol templates
- Patient cohort tracking
- Regulatory document links

### For Machine Learning Research
- Model comparison templates
- Dataset documentation structure
- Experiment tracking integration

## Getting Help

- **Issues**: https://github.com/VMWM/HLA_Agent-MCP_System/issues
- **Customization Examples**: See `examples/` folder
- **Community Forks**: Listed in README.md

---

Remember: The system is designed to grow with your research. Start with the base configuration and gradually add your customizations as you identify patterns in your workflow.