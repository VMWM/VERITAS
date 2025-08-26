# HLA F31 Grant Assistant

## Mission
Developing standardized approaches for HLA antibody interpretation and risk assessment to expand transplant access for sensitized patients while maintaining safety.

**Timeline**: Preliminary Exam (Sept 2025) → F31 submission (Dec 2025)

## Research Aims

**Aim 1:** Develop rule-based algorithm for standardized unacceptable antigen reporting codifying expert patterns (epitope analysis, CREG, self-antigen exclusion). Validate against experts and flow crossmatching. Create benchmark dataset.

**Aim 2:** Establish evidence-based risk classification for transplanting across weak anti-HLA (MFI 500-5000) using multivariable models. Identify which weak DSA can be safely crossed in specific clinical contexts.

**Aim 3:** Develop decision support tool predicting AMR risk at organ offer by integrating pre-transplant antibody risk with predicted dnDSA risk (FIBERS). Adapt EuroTransplant Acceptable Antigens approach to include safe weak antibodies.

## CRITICAL WORKFLOW RULES

### For ALL Complex Tasks
1. **START WITH**: `mcp__sequential-thinking__sequentialthinking` to plan approach
2. **VERIFY CLAIMS**: Use `mcp__pubmed__*` for all medical/scientific statements
3. **CHECK MEMORY**: Use `mcp__memory__*` to check existing knowledge first

### For Obsidian/Vault/Research Questions/Concepts/Rules
**IF** user mentions: research question, obsidian, vault, concept, template, wiki links, rule, algorithm, epitope, MFI, vendor
**THEN** follow this exact workflow:

1. Use `mcp__sequential-thinking__sequentialthinking` FIRST
2. Read `.claude/agents/hla-research-director.md` for templates
3. Create entries using `mcp__obsidian-rest-hla__obsidian_update_note`:
   - **CRITICAL**: ALWAYS append `.md` to ALL file paths
   - **CRITICAL**: Tables MUST use `| Cell |` format with spaces around pipes
   - Parameter: `targetIdentifier` MUST end with `.md`
   - Example: `"Concepts/De_Novo_DSA.md"` ✅ NOT `"Concepts/De_Novo_DSA"` ❌

**Folder Structure** (ALWAYS include .md extension):
- Research Questions: `Research Questions/[Title_Without_Question_Mark].md`
- Concepts: `Concepts/[Noun_Phrase].md`
- Rules: `Rules/[Category]/RULE_[CATEGORY]_[SPECIFIC]_[NUMBER].md`
- Journal: `Daily/YYYY-MM-DD.md`

**DO NOT USE** these tools for Obsidian content:
- Write, Edit, MultiEdit (these are for code files)
- filesystem-local tools (these bypass Obsidian)

## Citation Requirements - NO EXCEPTIONS

- **Format**: (Author et al., Year, PMID: XXXXXXXX)
- **No PMID = Remove the claim entirely**
- **Add verification level**: [FT-VERIFIED], [ABSTRACT-VERIFIED], or [NEEDS-FT-REVIEW]
- **Use**: `mcp__pubmed__search_pubmed`, `mcp__pubmed__fetch_summary`, `mcp__pubmed__get_fulltext`

## Tool Priority Order

1. `mcp__sequential-thinking__*` - Problem breakdown and planning
2. `mcp__memory__*` - Check existing knowledge first
3. `mcp__pubmed__*` - All medical citations and verification
4. `mcp__obsidian-rest-hla__*` - HLA vault operations
5. `mcp__obsidian-rest-journal__*` - Journal operations
6. Project files: `/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025/`
7. Standard tools (Write, Edit, etc.) - For code and non-Obsidian files only

## Obsidian Formatting Rules - MANDATORY

**EVERY Obsidian file creation MUST follow these rules:**
1. **File Extension**: ALWAYS append `.md` to targetIdentifier/filePath
2. **Table Format**: ALWAYS use `| Cell |` with spaces around EVERY pipe
3. **No Escapes**: Use actual line breaks, not `\n`
4. **No HTML**: Use `>` `<` symbols, not `&gt;` `&lt;`
5. **Wiki Links**: `[[Concept_Name]]` with underscores for spaces
6. **H1 Headers**: NO underscores in H1 headings

**Table Example** (CORRECT):
```
| Header 1 | Header 2 | Header 3 |
| --- | --- | --- |
| Data 1 | Data 2 | Data 3 |
```

## Key Resources

- **Templates**: `.claude/agents/hla-research-director.md`
- **Config**: `.claude/config/verification.json`
- **Hooks**: `.claude/hooks/`
- **Project Root**: `/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025/`
- **Public Repository**: `/Users/vmwm/Library/CloudStorage/Box-Box/automated-antibody-analysis/`
  - Rules symlinked to Obsidian: `rules/` ↔ `HLA Antibodies/Rules/`
  - Python scripts: `scripts/` folder
  - Analysis reports: `reports/` folder

## Success Criteria

✅ Started with sequential thinking for complex tasks
✅ All medical claims have PMIDs
✅ Obsidian content created via REST API
✅ Templates followed from hla-research-director.md
✅ Wiki links properly formatted
✅ Rules auto-indexed and cross-linked
✅ New rule categories automatically created

## Notes
- Obsidian REST API at port 27124 for HLA vault
- Obsidian REST API at port 27125 for Journal vault
- Violations are logged in `.claude/logs/`

## Conversation Logging Policy
- **AUTOMATICALLY LOG** all HLA research conversations using `mcp__conversation-logger__log_message`
- Log both user messages and assistant responses
- Include tools used and files modified
- Logs retained for 5 days (older auto-deleted)
- Use `mcp__conversation-logger__generate_journal` when user requests daily journal