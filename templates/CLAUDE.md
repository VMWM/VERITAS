# Project Agent Configuration

## MCP Server Usage Guide

### For Obsidian Operations
**✅ ALWAYS USE `obsidian-rest`**
- Works from ANY project folder (no path restrictions)
- Authentication is handled automatically by the MCP server
- DO NOT manually add Authorization headers - they're added automatically
- Example usage:
  ```
  mcp__obsidian-rest__test_request(
    endpoint: "/vault/YourVault/Notes/example.md",
    method: "PUT",
    body: "# Your note content here"
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

1. **Authentication**: The obsidian-rest server automatically includes your API key in all requests. You don't need to handle authentication manually.

2. **Error Messages**: If you see "Access denied - path outside allowed directories", you're using the wrong MCP server. Switch to `obsidian-rest` immediately.

3. **Obsidian Must Be Running**: The Local REST API plugin must be enabled in Obsidian for the REST API to work.

## Obsidian Note Formatting Rules

### Research Questions
- **MUST be phrased as actual questions** ending with "?"
- Examples of correct titles:
  - "How does prozone effect impact SAB interpretation?"
  - "What MFI cutoff strategies optimize virtual crossmatch accuracy?"
  - "Can machine learning improve HLA antibody specificity assignment?"
- Examples of incorrect titles:
  - "Prozone Effect Impact" ❌
  - "MFI Cutoff Strategies" ❌
  - "Machine Learning Applications" ❌

### File Naming Conventions
- Research Questions: Use the actual question as the filename
  - Example: `How_does_prozone_affect_SAB_interpretation.md`
- Concepts: Use descriptive noun phrases
  - Example: `Halifax_Protocol.md`, `MFI_Cutoffs.md`
- Daily Notes: Use ISO date format
  - Example: `2025-01-18.md`

## Project-Specific Instructions
[Add your project-specific instructions here]