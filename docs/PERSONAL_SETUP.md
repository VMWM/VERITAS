# Personalizing Your Setup

This system comes pre-configured for HLA research, but you should customize it for your own research focus and vault structure.

## 🏗️ Vault Architecture

### Default Setup (HLA Research)
The system expects two Obsidian vaults:
1. **HLA Antibodies** - Domain-specific research
2. **Research Journal** - Daily logs and project notes

### Creating Your Own Vault Structure

#### Option A: Keep the Two-Vault System
Rename the vaults to match your research:
```
Obsidian/
├── [Your Research Topic]/      # Replace "HLA Antibodies"
│   ├── Concepts/
│   ├── Research Questions/
│   └── [Your Custom Folders]/
└── Research Journal/           # Keep this for daily notes
    ├── Daily/
    └── Projects/
```

#### Option B: Single Vault Setup
Combine everything in one vault:
```
Obsidian/
└── Research Vault/
    ├── Concepts/
    ├── Questions/
    ├── Daily/
    ├── Projects/
    └── Literature/
```

**To use single vault:**
1. Use only `obsidian-rest` (not dual configuration)
2. Remove `obsidian-rest-journal` from config
3. All notes go to one vault

#### Option C: Multi-Vault Setup (3+)
For complex research with multiple domains:
```
Obsidian/
├── Clinical Research/
├── Lab Protocols/
├── Grant Writing/
└── Research Journal/
```

**Setup:** Add more `obsidian-rest-[name]` entries with different ports (27126, 27127, etc.)

## 🎭 Creating Your Research Agent

### Step 1: Copy the Template
```bash
cp ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/AGENT_TEMPLATE.md \
   ~/Library/"Mobile Documents"/com~apple~CloudDocs/MCP-Shared/agents/My-Research-Agent.md
```

### Step 2: Customize for Your Domain

Replace the HLA-specific content with your research area:

#### For Cardiac Research
```markdown
## Agent Role & Identity
Expert in cardiac electrophysiology, arrhythmia mechanisms, and clinical trials

## Core Knowledge Base
### Key Guidelines
- 2020 ESC Guidelines for AF Management
- 2019 AHA/ACC/HRS Focused Update
- CHA2DS2-VASc scoring

### Research Focus
- Atrial fibrillation mechanisms
- Catheter ablation outcomes
- Anticoagulation strategies
```

#### For Cancer Research
```markdown
## Agent Role & Identity
Expert in tumor immunology, checkpoint inhibitors, and clinical oncology

## Core Knowledge Base
### Treatment Protocols
- NCCN Guidelines current version
- FDA-approved immunotherapy combinations
- Clinical trial phases and endpoints

### Key Pathways
- PD-1/PD-L1 axis
- CTLA-4 inhibition
- CAR-T cell therapy
```

#### For Neuroscience Research
```markdown
## Agent Role & Identity
Expert in neurodegeneration, synaptic plasticity, and behavioral neuroscience

## Core Knowledge Base
### Disease Models
- Alzheimer's pathology (tau, amyloid)
- Parkinson's mechanisms
- ALS/FTD spectrum

### Techniques
- Patch-clamp electrophysiology
- Two-photon imaging
- Optogenetics
```

### Step 3: Define Your Workflow

Customize the MCP server priorities for your needs:

```markdown
### MCP Server Priority Order

1. **sequential-thinking** - Complex experimental design
2. **memory** - Track experimental conditions
3. **pubmed** - Literature validation
4. **obsidian-rest-[your-vault]** - Document protocols
5. **filesystem-local** - Read data files
```

## 📚 Vault Folder Customization

### Research Questions Format

Choose your preferred organization:

**Option 1: Question-Based** (Default)
```
/Research Questions/
├── How_does_X_affect_Y.md
└── What_mechanisms_underlie_Z.md
```

**Option 2: Hypothesis-Based**
```
/Hypotheses/
├── H1_Treatment_X_improves_Y.md
└── H2_Pathway_Z_mediates_effect.md
```

**Option 3: Aim-Based**
```
/Specific Aims/
├── Aim1_Characterize_mechanism.md
├── Aim2_Test_intervention.md
└── Aim3_Clinical_translation.md
```

Update your agent's rules accordingly:
```markdown
### Research Organization
- Store hypotheses in: `/Hypotheses/` folder
- Format: "H1_[Brief_Description].md"
- Must start with hypothesis number (H1, H2, etc.)
```

## 🔧 Configuration Modifications

### Changing Vault Names

Edit `claude-desktop-config.json`:

```json
"obsidian-rest-main": {
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27124",
    "AUTH_BEARER": "YOUR_API_KEY"
  }
}
```

### Adding Custom MCP Servers

For specialized tools in your field:

```json
"image-analysis": {
  "command": "npx",
  "args": ["@your-lab/image-mcp"],
  "env": {
    "DATA_PATH": "/path/to/images"
  }
}
```

## 📝 Template Customization

### Daily Entry Template

Modify `templates/daily-entry.md` for your workflow:

#### For Wet Lab Work
```markdown
# {{date}}

## Experiments
- [ ] Protocol:
- [ ] Samples:
- [ ] Controls:

## Results
- Observations:
- Data location:

## Issues
- Technical problems:
- Troubleshooting:

## Next Steps
- [ ] 
```

#### For Clinical Research
```markdown
# {{date}}

## Patient Recruitment
- Screened:
- Enrolled:
- Screen failures:

## Data Collection
- [ ] REDCap entries
- [ ] Adverse events
- [ ] Protocol deviations

## Regulatory
- [ ] IRB communications
- [ ] DSMB reports
```

#### For Computational Work
```markdown
# {{date}}

## Code Development
- Branch:
- Features added:
- Tests written:

## Analysis
- Dataset:
- Methods:
- Results:

## Performance
- Runtime:
- Memory usage:
- Optimization notes:
```

## 🚀 Quick Start for Your Domain

### 1. Bioinformatics Researcher
```bash
# Rename vaults
mv "HLA Antibodies" "Genomics Analysis"

# Create custom agent
cp AGENT_TEMPLATE.md Bioinformatics-Agent.md
# Add: R/Python integration, BLAST searches, pathway analysis

# Update folders
Genomics Analysis/
├── Pipelines/
├── Datasets/
└── Results/
```

### 2. Clinical Researcher
```bash
# Create vaults
mkdir "Clinical Trials"
mkdir "Patient Data"

# Custom agent focus
- Protocol development
- Inclusion/exclusion criteria
- Statistical analysis plans
- Regulatory compliance
```

### 3. Basic Science Researcher
```bash
# Vault structure
Lab Notebooks/
├── Protocols/
├── Results/
├── Troubleshooting/
└── Meeting Notes/

# Agent specialization
- Experimental design
- Control selection
- Statistical power
- Figure preparation
```

## 🔄 Migration from Existing Notes

If you have existing Obsidian vaults:

1. **Keep your structure** - Just add the REST API plugin
2. **Update agent** - Modify to match your folder names
3. **Test gradually** - Start with read operations before creating

## 📊 Field-Specific Examples

### Psychology Research
- Vaults: "Behavioral Studies", "Literature Review"
- Agent focus: Study design, IRB protocols, statistical analysis
- Special folders: `/Measures/`, `/Protocols/`, `/Data Analysis/`

### Engineering Research  
- Vaults: "Design Iterations", "Test Results"
- Agent focus: CAD integration, simulation results, patent searches
- Special folders: `/Designs/`, `/Simulations/`, `/Patents/`

### Social Sciences
- Vaults: "Qualitative Data", "Theoretical Framework"
- Agent focus: Coding schemes, thematic analysis, theory development
- Special folders: `/Interviews/`, `/Codes/`, `/Themes/`

## 🎯 Remember

1. **Start simple** - Use one vault first, add complexity later
2. **Document your setup** - Update the agent file with your choices
3. **Share with your lab** - Your setup can help others
4. **Iterate** - Refine based on actual usage

---
*The beauty of this system is its flexibility. Make it yours!*