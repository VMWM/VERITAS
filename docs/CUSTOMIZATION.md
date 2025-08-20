# Customization Guide

This guide helps you adapt the system from HLA research to your specific domain.

## Quick Customization Steps

1. **Rename Obsidian vaults** to match your research area
2. **Copy agent template** and modify for your domain
3. **Update config paths** if using different folder structure
4. **Adjust templates** for your note-taking style

## 🏗️ Vault Customization

### Option A: Two-Vault System (Recommended)
Keep research separate from daily notes:
```
Obsidian/
├── [Your Research Topic]/      # e.g., "Cancer Biology", "Neuroscience"
│   ├── Concepts/
│   ├── Research Questions/
│   └── Literature/
└── Research Journal/            # Daily logs and project notes
    ├── Daily/
    └── Projects/
```

**Config**: Keep both `obsidian-rest-hla` and `obsidian-rest-journal` (rename as needed)

### Option B: Single Vault (Simpler)
Everything in one place:
```
Obsidian/
└── Research/
    ├── Concepts/
    ├── Questions/
    ├── Daily/
    └── Literature/
```

**Config**: Use only one `obsidian-rest` server, remove the journal server

### Option C: Project-Based Vaults
Separate vault per project:
```
Obsidian/
├── Grant_F31_2025/
├── Clinical_Trial_XYZ/
└── Lab_Protocols/
```

**Config**: Add MCP server for each vault with unique ports (27124, 27125, 27126...)

## 🎭 Creating Your Domain Agent

### Step 1: Start with Template
```bash
cp templates/AGENT_TEMPLATE.md ~/my-project/CLAUDE.md
```

### Step 2: Customize Core Sections

#### Agent Identity
```markdown
# [Your Field] Research Expert Agent

## Role & Expertise
Expert in [your specific domain] with focus on [your research goals]

## Primary Research Focus
- **Current Project**: [Your main project]
- **Key Questions**: [What you're investigating]
- **Methods**: [Your approaches]
```

#### Knowledge Sources
Replace HLA-specific paths with yours:
```markdown
## Knowledge Sources
1. **Literature**: ~/Documents/Papers/[Your Field]/
2. **Data**: ~/Research/Data/
3. **Protocols**: ~/Lab/Protocols/
```

#### Domain Vocabulary
Add field-specific terms:
```markdown
## Domain-Specific Knowledge
- Key concepts: [List important concepts]
- Common abbreviations: [Field-specific acronyms]
- Important methods: [Techniques you use]
```

### Step 3: Tool Configuration

#### For Wet Lab Research
Emphasize protocol management:
```markdown
## Workflow Priorities
1. Check protocols folder first
2. Version control for protocol changes
3. Link to relevant safety docs
```

#### For Clinical Research
Add patient data handling:
```markdown
## Data Handling Rules
- Never include PHI in notes
- Use study IDs only
- Follow HIPAA guidelines
```

#### For Computational Research
Focus on code and analysis:
```markdown
## Code Management
- Link to GitHub repos
- Document analysis pipelines
- Track software versions
```

## 📝 Template Customization

### Concept Note Template
Edit `templates/concept.md`:
```markdown
# {{title}}

## Definition
[Adjust for your field's style]

## Clinical Significance  → ## Research Impact
## Mechanisms           → ## Theoretical Framework
## References           → ## Citations
```

### Daily Entry Template
Edit `templates/daily-entry.md`:
```markdown
# {{date}}

## Experiments Completed  → ## Work Completed
## Lab Observations      → ## Key Findings
## Protocol Changes      → ## Methods Notes
```

### Research Question Template
Adapt to your field's format:
```markdown
# Research Question

## Hypothesis        → ## Research Aim
## Background       → ## Literature Context
## Methodology      → ## Proposed Approach
## Expected Impact  → ## Significance
```

## 🔧 Advanced Customization

### Custom MCP Servers
Add field-specific tools:
```json
{
  "mcpServers": {
    "protein-db": {
      "command": "npx",
      "args": ["@your-org/protein-mcp"]
    }
  }
}
```

### API Integrations
Connect to your field's databases:
- **Biology**: UniProt, NCBI, PDB
- **Chemistry**: PubChem, ChEMBL
- **Clinical**: ClinicalTrials.gov, FDA
- **Physics**: arXiv, INSPIRE-HEP

### Workflow Automation
Create field-specific commands:
```markdown
## Custom Commands
- "Update lab notebook" → Creates daily entry with experiment template
- "Review literature" → Searches field-specific databases
- "Generate figure legend" → Formats according to journal requirements
```

## 💡 Examples by Field

### Neuroscience Example
```markdown
## Agent Configuration
- Focus: Neural circuits and behavior
- Databases: PubMed, Allen Brain Atlas
- Vaults: "Neural Circuits", "Behavior Data"
- Templates: Include imaging protocols
```

### Cancer Biology Example
```markdown
## Agent Configuration
- Focus: Tumor microenvironment
- Databases: COSMIC, cBioPortal
- Vaults: "Cancer Mechanisms", "Drug Screening"
- Templates: Include cell line tracking
```

### Bioinformatics Example
```markdown
## Agent Configuration
- Focus: Genomic analysis pipelines
- Databases: GEO, SRA, Ensembl
- Vaults: "Pipelines", "Analysis Results"
- Templates: Include code snippets
```

## 🚀 Quick Start for New Domain

1. **Clone HLA agent as starting point**:
   ```bash
   cp agents/HLA-Research-Agent.md agents/My-Field-Agent.md
   ```

2. **Find & Replace**:
   - "HLA" → Your field
   - "antibodies" → Your focus
   - "transplant" → Your application

3. **Update paths**:
   - Change vault names
   - Update literature folders
   - Fix protocol locations

4. **Test with simple query**:
   ```
   /agent "What are the key concepts in [your field]?"
   ```

## 📚 Resources

- **Agent Library**: Share agents at github.com/VMWM/HLA_Agent-MCP_System/agents
- **Template Collection**: Community templates in `/templates`
- **Custom MCP Servers**: Build your own at modelcontextprotocol.org

---

*Remember: The system is flexible - start simple and add complexity as needed*