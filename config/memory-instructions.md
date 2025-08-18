# Core Memory Instructions for HLA Research MCP System

## Overview
These instructions are pre-loaded into Memory MCP to ensure consistent behavior across all sessions.
This provides the exact same experience for all users while allowing customization.

## CRITICAL: Obsidian Note Formatting Rules

### Research Questions
- **MUST be phrased as actual questions** ending with "?"
- Store in `/Research Questions/` folder
- Correct examples:
  - "How does prozone effect impact SAB interpretation?"
  - "What MFI cutoff strategies optimize virtual crossmatch accuracy?"
- Incorrect examples (DO NOT USE):
  - "Prozone Effect Impact" ❌
  - "MFI Cutoff Strategies" ❌

### Concepts
- Use descriptive noun phrases (NOT questions)
- Store in `/Concepts/` folder
- Examples: `Halifax_Protocol.md`, `MFI_Cutoffs.md`, `Epitope_Analysis.md`

## Knowledge Graph Linking Rules

### Required for Every Concept Page:
1. **Related Concepts Section** - Minimum 3-5 wiki-links using `[[Concept_Name]]` format
2. **Bidirectional Linking** - Update existing concepts to link back
3. **Frontmatter Aliases** - Include alternative names
4. **Hierarchical Tags** - Use tags like `[concept, HLA, antibodies]`
5. **In-Text Linking** - Link first mention of concepts

## MCP Server Usage Rules

### ALWAYS Use:
- **obsidian-rest** for ALL Obsidian operations (works from ANY folder)
- **filesystem-local** for reading project files (limited to current folder)
- **memory** for storing validated facts
- **pubmed** for literature verification

### NEVER Use:
- **obsidian-file** or **obsidian-vault** - These cause "Access denied" errors
- Do NOT manually add Authorization headers

## HLA Domain Knowledge Base

### MFI Cutoff Standards (US Practice 2023):
- 22% of labs use 1,000 MFI cutoff
- 55% use 2,000-3,000 MFI range
- 87% apply same thresholds for HLA-A, B, DR, DQ
- Source: Puttarajappa et al. Human Immunology 84 (2023)

### Halifax Protocol:
- Mix EDTA with beads BEFORE adding serum
- 60% time reduction, 95.7% sensitivity, 96.6% specificity
- Detects ~27 additional antibodies in highly sensitized patients
- Source: Liwski et al. Human Immunology 79 (2018)

## Templates

### Daily Entry Template (ID: 10)
```markdown
---
date: {{date}}
type: daily-entry
tags: [daily, research-journal]
---

# {{date}} - Research Journal

## Today's Focus
- Main research goals

## Completed Tasks
- [ ] Task items

## Cross-Project Insights
- Key insights

## Literature Reviewed
| Source | Key Finding | Relevance |
|--------|-------------|-----------|
| | | |

## Notes and Observations
- General notes
```

### Research Question Template (ID: 11)
```markdown
---
type: research-question
tags: [research, literature-review, HLA]
verified: true
---

# {{Question}}

## Key Findings
| Study | Population | Finding | PMID |
|-------|------------|---------|------|
| | | | |

## Analysis
- Current evidence summary
- Knowledge gaps
- Clinical implications

## References
- All citations with PMIDs
```

### Concept Template (ID: 12)
```markdown
---
type: concept
tags: [concept, HLA]
---

# {{Concept Name}}

## Definition
Clear definition

## Key Points
- Important points

## Clinical Applications
How this applies in practice

## Related Concepts
- [[Related 1]]
- [[Related 2]]
```

## Routing Rules (ID: 13)

### Automatic Content Routing
```
IF query contains HLA/antibody/transplant terms:
  → Route to: HLA Antibodies vault

IF query contains "daily" or "journal":
  → Route to: Research Journal/Daily

IF query contains "prevalence/incidence" + medical:
  → Trigger: PubMed search
  → Route to: HLA Antibodies/Research Questions

IF general concept:
  → Route to: Research Journal/Concepts
```

## Agent Workflow Instructions (ID: 14)

### Complete HLA Research Workflow
1. **Parse Query**: Identify medical terms, statistics needed
2. **Search Knowledge Base**: Check local PDFs first
3. **Query PubMed**: If medical, get PMIDs
4. **Extract Data**: Pull statistics, create tables
5. **Create Research Question**: Use template ID 11
6. **Identify Concepts**: Extract [[linked concepts]]
7. **Create Concept Pages**: Use template ID 12 for each
8. **Cross-link**: Create bidirectional links
9. **Update Memory**: Store search history

### Agent Auto-Triggers
- "How often" → Statistical search
- "What percentage" → Prevalence query
- "Compare" → Comparison table
- HLA terms → Domain-specific search

## Memory Persistence Settings

### What to Remember
- All templates (persistent)
- Search queries and results
- User preferences
- File paths accessed
- Concept relationships

### What to Forget
- Temporary calculations
- Error messages
- Debug information

---

*These instructions ensure consistent behavior across all Claude Code sessions*