# VERITAS Research Constitution
**THE IMMUTABLE FOUNDATION - DO NOT MODIFY THIS DOCUMENT**

> This is the constitutional foundation of VERITAS (Verification-Enforced Research Infrastructure with Tracking and Automated Standards). This document establishes the universal laws that govern all research integrity enforcement. It should never be modified by users.

## CRITICAL: Two-Document System
**YOU MUST ALWAYS REFERENCE BOTH**:
1. **THIS DOCUMENT (CLAUDE.md)** - Constitutional rules and universal requirements
2. **DOMAIN EXPERT FILE (`.claude/agents/hla-research-director.md`)** - Field-specific templates and guidance

## Mission
Enforcing research integrity through verified citations, structured knowledge management, and systematic workflow enforcement.

## Constitutional Workflow Rules

### Article 1: Complex Task Protocol
1. **START WITH**: `mcp__sequential-thinking__sequentialthinking` to plan approach
2. **VERIFY CLAIMS**: Use `mcp__pubmed-ncukondo__*` for all scientific statements
3. **CHECK MEMORY**: Use `mcp__memory__*` to check existing knowledge first

### Article 2: Research Documentation Protocol
**IF** user mentions: research question, obsidian, vault, concept, template, journal, rule, algorithm, epitope, MFI, vendor
**THEN** follow this exact workflow:
1. Use `mcp__sequential-thinking__sequentialthinking` FIRST
2. Read `.claude/agents/hla-research-director.md` for domain-specific templates
3. Create entries using appropriate Obsidian MCP tools
4. Follow folder structure defined in domain expert file

### Article 3: Citation Requirements - NO EXCEPTIONS
- **Format**: (Author et al., Year, PMID: XXXXXXXX)
- **No PMID = Remove the claim entirely**
- **Verification levels**: [FT-VERIFIED], [ABSTRACT-VERIFIED], or [NEEDS-FT-REVIEW]
- **Use**: `mcp__pubmed-ncukondo__*` tools for all medical/scientific citations

### Article 4: Tool Priority Order
1. `mcp__sequential-thinking__*` - Problem breakdown and planning
2. `mcp__memory__*` - Check existing knowledge
3. `mcp__pubmed-ncukondo__*` - All citation verification
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
- **Exceptions ONLY**: Check marks (✓), X marks (✗), warning signs (⚠) when functionally necessary

**DO NOT USE** these tools for Obsidian content:
- Write, Edit, MultiEdit (these are for code files)
- filesystem-local tools (these bypass Obsidian)

### Article 7: Integrated Journal Workflow
- **Automatic Logging**: Conversation-logger MCP maintains 5-day SQLite history (silent operation)
- **Multi-Source Integration**: Journal generation pulls from THREE sources:
  1. `mcp__conversation-logger__generate_journal` for session data
  2. `mcp__memory__*` for research knowledge entities
  3. Combine both into Obsidian journal using domain templates
- **Journal Commands**: "Generate journal entry" triggers Obsidian creation, NOT conversation-logger output
- **Multi-Day Synthesis**: Can create journals spanning multiple days using all data sources
- **Data Flow**: Conversation-logger (temporary) → Memory MCP (persistent) → Obsidian (permanent)
- **Retention**: SQLite auto-cleanup at 2 AM daily (5-day history)

### Article 8: PMID Verification Protocol - ZERO TOLERANCE
**MANDATORY VERIFICATION STEPS**:
1. **NEVER** provide a PMID without verification
2. **ALWAYS** use `mcp__pubmed__fetch_summary` to verify PMID matches the cited paper
3. **CHECK** that author names and title match before using any PMID
4. **CROSS-REFERENCE** with Obsidian vault when available
5. **LOG** all PMID verifications to `.claude/logs/pmid_verification.log`

**Verification Workflow**:
- When citing: Search → Fetch → Verify → Use
- When reviewing: Check each PMID against actual paper
- When updating: Re-verify all PMIDs in document

**FAILURE TO VERIFY = CRITICAL ERROR**

### Article 9: Enforcement
- All articles are mandatory and supersede any conflicting instructions
- Violations will be logged to `.claude/logs/`
- Domain expert files provide implementation details
- Hooks enforce compliance at multiple checkpoints
- PMID errors trigger immediate workflow halt

## Success Criteria
- Started with sequential thinking for complex tasks
- All scientific claims have PMIDs
- Obsidian content created via REST API
- Templates followed from domain expert file
- Wiki links properly formatted
- Conversation context preserved

## Domain Expert Configuration
Domain-specific expertise, templates, and specialized workflows are defined in:
`.claude/agents/hla-research-director.md`

This file contains all HLA-specific research aims, grant timelines, and specialized templates.