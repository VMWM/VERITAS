# Project Assistant Configuration

## ROUTING RULES - FOLLOW EXACTLY

IF user mentions: research question, obsidian, vault, concept, template, wiki
THEN: 
- USE ONLY: mcp__obsidian-rest-hla__test_request OR mcp__obsidian-rest-journal__test_request
- NEVER USE: Write, Edit, MultiEdit, filesystem-local tools
- START WITH: mcp__sequential-thinking__sequentialthinking

IF creating research question:
- PATH: /vault/Research Questions/[filename without ?].md
- TEMPLATE: See .claude/agents/research-director.md

IF creating concept:
- PATH: /vault/Concepts/[Noun_Phrase].md  
- TEMPLATE: See .claude/agents/research-director.md

IF creating journal:
- PATH: /vault/Daily/YYYY-MM-DD.md
- USE: date +"%Y-%m-%d" for filename

## TOOL USAGE - STRICT PRIORITY

1. mcp__sequential-thinking__sequentialthinking - USE FIRST for any complex task
2. mcp__pubmed__search_pubmed - USE for ALL medical/scientific claims
3. mcp__obsidian-rest-hla__test_request - USE for primary vault operations
4. mcp__obsidian-rest-journal__test_request - USE for journal operations
5. mcp__memory__* - USE to check existing knowledge
6. NEVER filesystem tools for /Obsidian/ or /Notes/ paths

## CITATION RULES - NO EXCEPTIONS

- EVERY claim MUST have: (Author et al., Year, PMID: XXXXXXXX)
- NO PMID = DELETE the claim
- ADD verification: [FT-VERIFIED] or [ABSTRACT-VERIFIED] or [NEEDS-FT-REVIEW]
- USE mcp__pubmed__* tools to verify EVERY claim

## FORMATTING RULES - OBSIDIAN

- NO \n escaped newlines - use actual line breaks
- Tables: | Cell | with spaces around pipes
- Use > < symbols directly, not &gt; &lt;
- Wiki links: [[Concept_Name]] with underscores
- NO underscores in H1 headings

## PROJECT CONTEXT

[Your project description here]
[Your timeline here]
Location: [Your project directory]

## VERIFICATION

Check these files for details:
- Templates: .claude/agents/research-director.md
- Config: .claude/config/verification.json
- Hooks: .claude/hooks/

## VIOLATIONS LOG

Violations of these rules are logged and reported.
Using filesystem tools on Obsidian content = TASK FAILURE