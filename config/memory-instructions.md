# Memory MCP Instructions and Templates

## Overview
These instructions are stored in Memory MCP to ensure consistent behavior across sessions.

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