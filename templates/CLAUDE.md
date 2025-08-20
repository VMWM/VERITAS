# Project Agent Configuration

## MCP Server Usage Guide

### For Obsidian Operations

**Dual Vault Configuration (ACTIVE):**
- **✅ USE `obsidian-rest-hla`** for HLA Antibodies vault (Port 27124)
- **✅ USE `obsidian-rest-journal`** for Research Journal vault (Port 27125)
- Both work from ANY project folder (no path restrictions)
- Authentication is handled automatically by each MCP server
- DO NOT manually add Authorization headers - they're added automatically

**⚠️ CRITICAL: Two-Vault Structure**
The user has TWO SEPARATE Obsidian vaults:
1. **HLA Antibodies** vault (Port 27124) - Contains `/Concepts/` and `/Research Questions/` folders
2. **Research Journal** vault (Port 27125) - Contains `/Daily/` and `/Concepts/` folders

**CORRECT PATH FORMAT:**
- ✅ `/vault/Concepts/Example.md` (creates in appropriate vault)
- ✅ `/vault/Research Questions/How does X affect Y.md`
- ❌ `/vault/HLA Antibodies/Concepts/Example.md` (creates duplicate folder!)

Example usage:
```
# For HLA concepts:
mcp__obsidian-rest-hla__test_request(
  endpoint: "/vault/Concepts/MFI_Cutoffs.md",
  method: "PUT",
  body: "# Your note content here"
)

# For Journal entries:
mcp__obsidian-rest-journal__test_request(
  endpoint: "/vault/Daily/2025-01-20.md",
  method: "PUT",
  body: "# Daily journal content here"
)
```

**❌ NEVER USE `obsidian-file` or `obsidian-vault`**
- These are filesystem-based and restricted to current project folder
- Will fail with "Access denied - path outside allowed directories"

### For Reading Local Files
**✅ USE `filesystem-local`**
- For reading PDFs, documents, and project files
- Limited to current project directory and subdirectories
- Perfect for analyzing project-specific materials

### Other MCP Servers
- **memory**: Persistent storage across sessions
- **pubmed**: Literature search and validation
- **sequential-thinking**: Complex problem solving

## Important Notes

1. **Authentication**: Both obsidian-rest servers automatically include their respective API keys. You don't need to handle authentication manually.

2. **Vault Selection**: The agent automatically routes content:
   - HLA concepts, research questions → `obsidian-rest-hla`
   - Daily entries, journal notes → `obsidian-rest-journal`

3. **Error Messages**: If you see "Access denied - path outside allowed directories", you're using the wrong MCP server. Use the appropriate obsidian-rest server.

4. **Obsidian Must Be Running**: Both vaults must be open in Obsidian with Local REST API plugins enabled.

## Obsidian Note Formatting Rules

### Research Questions
- **MUST be phrased as actual questions** ending with "?"
- Store in: `HLA Antibodies/Research Questions/` (NOT nested deeper)
- Examples of correct titles:
  - "How does prozone effect impact SAB interpretation?"
  - "What MFI cutoff strategies optimize virtual crossmatch accuracy?"
  - "Can machine learning improve HLA antibody specificity assignment?"
- Examples of incorrect titles:
  - "Prozone Effect Impact" ❌
  - "MFI Cutoff Strategies" ❌
  - "Machine Learning Applications" ❌

### Concepts
- Use descriptive noun phrases (not questions)
- Store in: `HLA Antibodies/Concepts/` (NOT nested deeper)
- Examples: `Halifax_Protocol.md`, `MFI_Cutoffs.md`, `Epitope_Analysis.md`

### Knowledge Graph Linking Rules
**CRITICAL for Obsidian Graph View:**

1. **Always Include Related Concepts Section**
   - Use `[[Concept_Name]]` wiki-link format
   - Link to 3-5 most relevant related concepts minimum
   - Example: `[[Halifax_Protocol]]`, `[[Prozone_Effect]]`, `[[MFI_Cutoffs]]`

2. **Bidirectional Linking**
   - When creating a new concept that references existing ones, consider updating existing concepts to link back
   - This creates a rich knowledge graph

3. **Use Aliases in Frontmatter**
   ```yaml
   aliases: [DSA, Donor Specific Antibodies, Donor-Specific Antibodies]
   ```
   - Allows multiple terms to link to the same concept

4. **Tag Hierarchy**
   ```yaml
   tags: [concept, HLA, antibodies, transplantation]
   ```
   - Use hierarchical tags for better organization

5. **Cross-Reference Types**
   - Parent concepts: `## Based On: [[Parent_Concept]]`
   - Child concepts: `## Enables: [[Child_Concept]]`
   - Peer concepts: `## Related Concepts: [[Peer_Concept]]`
   - Contradicts/Challenges: `## Challenges: [[Alternative_Theory]]`

6. **In-Text Linking**
   - Link first mention of any concept that has its own page
   - Example: "The [[Halifax_Protocol]] addresses [[Prozone_Effect]] by..."

### File Naming Conventions
- Research Questions: Use the actual question as the filename
  - Example: `How_does_prozone_affect_SAB_interpretation.md`
- Concepts: Use descriptive noun phrases with underscores
  - Example: `Halifax_Protocol.md`, `MFI_Cutoffs.md`
- Daily Notes: Use ISO date format
  - Example: `2025-01-18.md`

## Project-Specific Instructions
[Add your project-specific instructions here]