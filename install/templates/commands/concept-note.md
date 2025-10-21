---
description: Create a new concept note with technical details and validation data
---

Create a new concept note following the VERITAS template:

1. Read `.claude/agents/hla-research-director.md` for the concept note template
2. Ask me for the concept name if not already provided
3. Search PubMed for relevant literature with verified PMIDs
4. Create a structured concept note with:
   - Overview and key definitions
   - Key Innovation (what makes this concept important)
   - Clinical Benefits (with quantified efficiency gains if available)
   - Technical Details
   - Validation Data (with N, outcomes, p-values, PMIDs)
   - Implementation Guide
   - Quality Control considerations
   - Research Integration
   - Comparison Table (if comparing with other approaches)
   - Related Concepts (wiki links)
   - Clinical Pearls
   - Key References
5. Create wiki links to related concepts
6. Store entities in Memory MCP
7. Save to Obsidian vault in Concepts/ folder

Use noun phrase naming (e.g., "Sensitization", "Halifax_Protocol").
All citations MUST include PMIDs.
