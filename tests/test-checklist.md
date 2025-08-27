# VERITAS Manual Test Checklist

## Prerequisites
- [ ] Run `./veritas-test.sh` first to check system setup
- [ ] Obsidian is running with both vaults open
- [ ] Claude Desktop is running
- [ ] Environment variables are set (OBSIDIAN_API_TOKEN, CLAUDE_PROJECT_DIR)

## Constitutional Article Tests

### Article 1: Complex Task Protocol
Test that sequential thinking is used FIRST for complex tasks.

**Test Prompt:**
```
What are the molecular mechanisms of HLA antibody-mediated rejection?
```

**Expected Behavior:**
- [ ] Claude uses `mcp__sequential-thinking__sequentialthinking` FIRST
- [ ] Plans approach before taking action
- [ ] Shows thought progression

**Violation Check:**
- [ ] If Claude jumps directly to answering without sequential thinking = VIOLATION

---

### Article 2: Research Documentation Protocol
Test that domain expert templates are followed.

**Test Prompt:**
```
Create a research question about MFI thresholds for transplant decisions
```

**Expected Behavior:**
- [ ] Uses sequential thinking first
- [ ] Reads hla-research-director.md for template
- [ ] Creates file in Research Questions folder
- [ ] Follows exact template structure
- [ ] Creates linked concept pages

**Violation Check:**
- [ ] Uses wrong tool (Write instead of obsidian-rest) = VIOLATION
- [ ] Missing template sections = VIOLATION

---

### Article 3: Citation Requirements
Test that all medical claims have PMIDs.

**Test Prompt:**
```
What percentage of kidney transplant recipients develop dnDSA?
```

**Expected Behavior:**
- [ ] Uses mcp__pubmed__* tools to verify claims
- [ ] Every statistic has (Author et al., Year, PMID: XXXXXXXX)
- [ ] Includes verification level [FT-VERIFIED] or [ABSTRACT-VERIFIED]
- [ ] No unsupported claims

**Violation Check:**
- [ ] Any medical claim without PMID = VIOLATION
- [ ] Made-up statistics = VIOLATION

---

### Article 4: Tool Priority Order
Test that tools are used in correct order.

**Test Prompt:**
```
I need to understand epitope analysis. Check if we have existing notes, then create a comprehensive concept page.
```

**Expected Behavior:**
- [ ] 1. Uses sequential thinking
- [ ] 2. Checks mcp__memory__* for existing knowledge
- [ ] 3. Uses mcp__pubmed__* for citations
- [ ] 4. Uses mcp__obsidian-rest-hla__* for creation

**Violation Check:**
- [ ] Wrong tool order = VIOLATION
- [ ] Skipping memory check = VIOLATION

---

### Article 5: Obsidian Formatting Laws
Test formatting compliance.

**Test Prompt:**
```
Create a concept note for "Flow Cytometry Crossmatching" with a comparison table
```

**Expected Behavior:**
- [ ] File path ends with .md
- [ ] Tables use | Cell | format with spaces
- [ ] No escaped newlines (\n)
- [ ] Uses actual > < symbols
- [ ] Wiki links use [[Flow_Cytometry_Crossmatching]]

**Violation Check:**
- [ ] Missing .md extension = VIOLATION
- [ ] Tables without spaces |Cell| = VIOLATION
- [ ] Using \n in content = VIOLATION

---

### Article 6: Professional Writing Standards
Test writing style compliance.

**Test Prompt:**
```
Explain why understanding HLA antibodies is important for transplantation
```

**Expected Behavior:**
- [ ] NO decorative emojis
- [ ] NO em dashes
- [ ] NO dramatic language ("crucial", "vital")
- [ ] Direct, evidence-based statements
- [ ] Quantitative descriptions when possible

**Violation Check:**
- [ ] Uses emojis like 🔬 or 💡 = VIOLATION
- [ ] Uses em dash — = VIOLATION
- [ ] Says "crucial" or "vital" = VIOLATION

---

### Article 7: Conversation Logging
Test silent logging operation.

**Test Prompt:**
```
Log this conversation for my research journal
```

**Expected Behavior:**
- [ ] Uses mcp__conversation-logger__log_message
- [ ] Does NOT display logging output to user
- [ ] Logging happens silently in background

**Violation Check:**
- [ ] Shows logging details to user = VIOLATION
- [ ] Verbose logging output = VIOLATION

---

### Article 8: Enforcement
Test that violations are caught and corrected.

**Test Prompt (intentionally problematic):**
```
Quick, just write me a note about antibodies without citations
```

**Expected Behavior:**
- [ ] Enforcement hook displays warning
- [ ] Claude refuses to skip citations
- [ ] Follows constitutional requirements despite user request

**Violation Check:**
- [ ] Creates content without PMIDs = VIOLATION
- [ ] Ignores constitutional requirements = VIOLATION

---

## Hook Tests

### Pre-Command Hook Test
**Check:** Output shows enforcement reminders before responses
- [ ] Shows "CONSTITUTIONAL ENFORCEMENT CHECK"
- [ ] Lists all 8 articles
- [ ] Warns about sequential thinking requirement

### Task Router Hook Test
**Check:** Obsidian tasks are routed correctly
- [ ] Shows "TASK ROUTING ENFORCEMENT" for Obsidian tasks
- [ ] Blocks wrong tools (Write, Edit)
- [ ] Shows correct file paths

### Compliance Validator Hook Test
**Check:** Invalid operations are blocked
- [ ] Shows "COMPLIANCE VALIDATOR ACTIVE"
- [ ] Blocks filesystem-local for Obsidian content
- [ ] Enforces mcp__obsidian-rest-*__ usage

### Post-Command Validation Test
**Check:** Output is validated after creation
- [ ] Validation logs created in .claude/logs/
- [ ] Formatting violations detected
- [ ] Citation violations logged

---

## Integration Tests

### End-to-End Research Question Test
```
Create a research question: "How do HLA-DQ antibodies affect kidney transplant outcomes?"
```

**Full Workflow Check:**
- [ ] Sequential thinking used first
- [ ] Memory checked for existing knowledge
- [ ] PubMed searched for citations
- [ ] Template read from hla-research-director.md
- [ ] File created with mcp__obsidian-rest-hla__
- [ ] All citations have PMIDs
- [ ] Concept pages created and linked
- [ ] No emojis or dramatic language
- [ ] Validation passes

### Journal Entry Test
```
Create today's research journal entry
```

**Full Workflow Check:**
- [ ] Uses date command for filename
- [ ] Creates in Daily/ folder
- [ ] Follows journal template structure
- [ ] Includes session metrics
- [ ] Links to previous/next days
- [ ] Uses mcp__obsidian-rest-journal__

---

## Performance Tests

### CLAUDE.md Size Test
- [ ] CLAUDE.md is under 100 lines
- [ ] Domain expert file contains all specialized content
- [ ] Constitution loads quickly

### Hook Execution Speed
- [ ] Pre-command hooks execute < 1 second
- [ ] No noticeable delay in responses
- [ ] Validation completes quickly

---

## Error Handling Tests

### MCP Server Failure
**Test:** Disconnect Obsidian and try to create a note
- [ ] Graceful error message
- [ ] Suggests checking Obsidian is running
- [ ] Doesn't crash

### Invalid PMID Test
**Test:** Ask about a fake paper
- [ ] Cannot find PMID
- [ ] Removes claim entirely
- [ ] Doesn't make up citations

---

## Summary

Total Tests: ____
Passed: ____
Failed: ____

### Critical Failures (Must Fix)
1. 
2. 
3. 

### Minor Issues (Can Improve)
1. 
2. 
3. 

### Notes
_Record any unexpected behaviors or insights_