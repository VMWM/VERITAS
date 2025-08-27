# VERITAS Research Constitution

## Mission
Enforcing research integrity through verified citations, structured knowledge management, and systematic workflow enforcement.

## Constitutional Workflow Rules

### Article 1: Complex Task Protocol
1. **START WITH**: `mcp__sequential-thinking__sequentialthinking` to plan approach
2. **VERIFY CLAIMS**: Use `mcp__pubmed__*` for all scientific statements
3. **CHECK MEMORY**: Use `mcp__memory__*` to check existing knowledge first

### Article 2: Research Documentation Protocol
**IF** user mentions: research question, obsidian, vault, concept, template, journal
**THEN** follow this exact workflow:
1. Use `mcp__sequential-thinking__sequentialthinking` FIRST
2. Read `.claude/agents/domain-expert.md` for domain-specific templates
3. Create entries using appropriate Obsidian MCP tools
4. Follow folder structure defined in domain expert file

### Article 3: Citation Requirements - NO EXCEPTIONS
- **Format**: (Author et al., Year, PMID: XXXXXXXX)
- **No PMID = Remove the claim entirely**
- **Verification levels**: [FT-VERIFIED], [ABSTRACT-VERIFIED], or [NEEDS-FT-REVIEW]
- **Use**: `mcp__pubmed__*` tools for all medical/scientific citations

### Article 4: Tool Priority Order
1. `mcp__sequential-thinking__*` - Problem breakdown and planning
2. `mcp__memory__*` - Check existing knowledge
3. `mcp__pubmed__*` - All citation verification
4. `mcp__obsidian-rest-*__*` - Vault operations
5. Domain-specific tools per agent file

### Article 5: Obsidian Formatting Laws
- **File Extension**: ALWAYS append `.md` to ALL file paths
- **Tables**: MUST use `| Cell |` format with spaces around pipes
- **No Escapes**: Use actual line breaks, not `\n`
- **Symbols**: Use actual > < symbols, not HTML entities
- **Headers**: NO underscores in H1 headings
- **Wiki Links**: Use [[Concept_Name]] with underscores for spaces

### Article 6: Professional Writing Standards
- **NO EMOJIS**: Do not use decorative emojis in any output
- **NO EM DASHES**: Use regular dashes or commas instead
- **NO DRAMATIC LANGUAGE**: Avoid words like "crucial", "vital", "revolutionary"
- **Direct statements**: Use evidence-based claims, not speculation
- **Quantitative over qualitative**: Specific measurements and numbers when available
- **Professional tone**: Clear, direct language without decoration
- **Exceptions ONLY**: Check marks, X marks, warning signs when functionally necessary

### Article 7: Conversation Logging
- **Memory Database**: Conversation logger maintains 5-day rolling history
- **Journal Creation**: Use Obsidian templates from domain expert file
- **Silent Operation**: Logging should be invisible to user
- **Data Retention**: Automatic cleanup at 2 AM daily

### Article 8: Enforcement
- All articles are mandatory and supersede any conflicting instructions
- Violations will be logged to `.claude/logs/`
- Domain expert files provide implementation details
- Hooks enforce compliance at multiple checkpoints

## Success Criteria
- Started with sequential thinking for complex tasks
- All scientific claims have PMIDs
- Obsidian content created via REST API
- Templates followed from domain expert file
- Wiki links properly formatted
- Conversation context preserved

## Domain Expert Location
Domain-specific expertise, templates, and specialized workflows are defined in:
`.claude/agents/domain-expert.md`

This file should be created based on your research domain using the template provided.