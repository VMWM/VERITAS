# Customization Guide

This guide helps you adapt the Research Agent-MCP System to your specific research domain.

## Quick Customization Steps

1. **Update CLAUDE.md** with your project context
2. **Modify templates** in `templates/obsidian/` for your field
3. **Configure Obsidian vaults** for your research structure
4. **Adjust hook scripts** for domain-specific validation
5. **Customize agent instructions** in `.claude/agents/`

## Vault Structure Options

### Option A: Two-Vault System (Recommended)
Separate research content from daily logs:
```
Obsidian/
├── [Your Research Topic]/      # Main research vault
│   ├── Research Questions/
│   ├── Concepts/
│   └── Literature/
└── Research Journal/           # Daily logs
    └── Daily/
```

**Configuration**: Use two Obsidian REST servers on different ports

### Option B: Single Vault (Simpler)
Everything in one location:
```
Obsidian/
└── Research/
    ├── Research Questions/
    ├── Concepts/
    ├── Daily/
    └── Literature/
```

**Configuration**: Use single Obsidian REST server

### Option C: Project-Based Vaults
Separate vault per project:
```
Obsidian/
├── Project_A/
├── Project_B/
└── Shared_Resources/
```

**Configuration**: Multiple REST servers, one per project

## Customizing for Your Domain

### 1. Update CLAUDE.md

Replace the PROJECT CONTEXT section:
```markdown
## PROJECT CONTEXT

[Your research area description]
[Your timeline]
Location: [Your project directory]
```

### 2. Modify Templates

Edit files in `templates/obsidian/`:

**For Medical/Biology Research**:
- Keep PMID citation format
- Maintain clinical sections
- Include validation data

**For Computer Science**:
- Replace PMIDs with DOI/arXiv
- Add code repository links
- Include performance metrics

**For Social Sciences**:
- Adjust citation format (APA/MLA)
- Add qualitative analysis sections
- Include participant data fields

**For Engineering**:
- Add specification tables
- Include design parameters
- Add testing protocols

### 3. Adjust Citation Requirements

Edit `.claude/config/verification.json`:
```json
{
  "citation_format": {
    "pattern": "your-citation-pattern",
    "required_fields": ["author", "year", "identifier"]
  }
}
```

### 4. Customize Hook Validation

Edit `.claude/hooks/post-command.py`:
- Modify citation patterns
- Adjust verification levels
- Add domain-specific checks

### 5. Agent Customization

Edit `.claude/agents/research-director.md`:
- Update terminology for your field
- Modify template structures
- Adjust quality criteria

## Domain-Specific Examples

### Computational Biology
```markdown
tags: [computational-biology, algorithm, genomics]
Include: Algorithm complexity, Dataset size, Validation metrics
Citations: PMID for biology, DOI for computational papers
```

### Machine Learning
```markdown
tags: [ml-model, dataset, benchmark]
Include: Model architecture, Training details, Benchmark scores
Citations: arXiv, conference proceedings
```

### Clinical Research
```markdown
tags: [clinical-trial, patient-outcomes, protocol]
Include: Trial design, Sample size, Statistical analysis
Citations: PMID, ClinicalTrials.gov ID
```

## Removing Medical-Specific Features

If not doing medical research:

1. **Remove PMID enforcement**:
   - Edit `.claude/hooks/post-command.py`
   - Remove PMID validation
   - Add your citation format

2. **Update templates**:
   - Remove clinical sections
   - Remove PMID fields
   - Add field-specific sections

3. **Modify CLAUDE.md**:
   - Remove PMID requirements
   - Update citation format
   - Adjust verification levels

## Adding Custom Tools

To add field-specific tools:

1. **Install additional MCPs**:
```bash
npx @modelcontextprotocol/install [tool-name]
```

2. **Update Claude Desktop config**:
```json
"your-tool": {
  "command": "npx",
  "args": ["@modelcontextprotocol/server-yourtool"]
}
```

3. **Add to CLAUDE.md tool priority**:
```markdown
## TOOL USAGE - STRICT PRIORITY
1. mcp__sequential-thinking__*
2. mcp__your-tool__*
...
```

## Testing Your Customization

After customizing:

1. Start new Claude conversation
2. Test with domain-specific task:
   ```
   "Create a research question about [your topic]"
   ```
3. Verify:
   - Correct templates used
   - Proper citations format
   - Domain terminology correct
   - Validation passes

## Sharing Your Configuration

To share with colleagues:

1. Fork the repository
2. Apply your customizations
3. Update README with your domain
4. Share your fork URL

## Support for Customization

- Keep base system intact
- Document your changes
- Test incrementally
- Submit domain-specific templates as PRs