---
description: Verify all PMIDs in current directory or specified file
---

Verify citations in markdown files:

1. Ask me which file(s) to check, or check all .md files in current directory
2. Extract all PMIDs from citations in format (Author et al., Year, PMID: XXXXXXXX)
3. For each PMID found:
   - Use `mcp__pubmed__fetch_summary` to retrieve article details
   - Verify author name matches
   - Verify year matches
   - Check that the paper title is relevant to the citation context
4. Report any issues:
   - PMIDs that don't exist
   - Author name mismatches
   - Year mismatches
   - Missing verification levels ([FT-VERIFIED], [ABSTRACT-VERIFIED], [NEEDS-FT-REVIEW])
5. Provide summary of:
   - Total citations found
   - Citations verified successfully
   - Citations with errors
   - Citations missing verification levels

This uses the PubMed MCP server for real-time verification, not the manual verify_pmids.py script.
