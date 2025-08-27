# VERITAS Functional Test Suite

This test suite actually exercises all VERITAS components to verify they work correctly, not just that they exist.

## Test Preparation

Before running these tests:
1. Ensure Obsidian is running with both vaults open
2. Have Claude Desktop open
3. Run each test in Claude and verify the results

## Test Format

Each test has:
- **Command**: What to ask Claude
- **Expected**: What should happen
- **Verify**: How to check it worked
- **Cleanup**: How to remove test artifacts

---

## 1. SEQUENTIAL THINKING TEST

### Test 1.1: Complex Problem Solving

**Command:**
```
Analyze the role of complement-binding HLA antibodies in transplant rejection
```

**Expected:**
- Claude uses `mcp__sequential-thinking__sequentialthinking` FIRST
- Shows thought progression (1/4, 2/4, etc.)
- Plans approach before answering

**Verify:**
- Check Claude's response shows sequential thinking was used
- Look for thought numbers in the output

---

## 2. MEMORY MCP SERVER TEST

### Test 2.1: Store Knowledge Entity

**Command:**
```
Store this in memory: "VERITAS Test Entity - A test entity created on [today's date] to verify memory functionality. Key observation: Memory MCP is working correctly."
```

**Expected:**
- Uses `mcp__memory__create_entities`
- Confirms entity created

**Verify:**
```
Search memory for "VERITAS Test Entity"
```
- Should retrieve the test entity

### Test 2.2: Create Relations

**Command:**
```
Create a memory relation: VERITAS Test Entity -> validates -> Memory System
```

**Expected:**
- Uses `mcp__memory__create_relations`
- Confirms relation created

**Verify:**
```
Read the memory graph and look for VERITAS Test Entity
```

### Cleanup:
```
Delete the VERITAS Test Entity from memory
```

---

## 3. PUBMED MCP SERVER TEST

### Test 3.1: Citation Search

**Command:**
```
Find recent papers about HLA-DQ antibodies and kidney transplants - give me 3 with PMIDs
```

**Expected:**
- Uses `mcp__pubmed__pubmed_search_articles`
- Returns papers with (Author et al., Year, PMID: XXXXXXXX) format
- Includes verification level

**Verify:**
- All citations have PMIDs
- Format matches constitutional requirements

### Test 3.2: Fetch Article Details

**Command:**
```
Get the full details for PMID: 38652886
```

**Expected:**
- Uses `mcp__pubmed__pubmed_fetch_contents`
- Returns article details
- Shows abstract or full text

**Verify:**
- Article details are retrieved
- Verification level indicated

---

## 4. OBSIDIAN OPERATIONS TEST

### Test 4.1: Create Research Question

**Command:**
```
Create a test research question: "How do VERITAS functional tests validate system integrity?"
```

**Expected:**
- Uses sequential thinking first
- Reads hla-research-director.md for template
- Creates with `mcp__obsidian-rest-hla__obsidian_update_note`
- File path: "Research Questions/How_do_VERITAS_functional_tests_validate_system_integrity.md"
- Follows template structure

**Verify:**
```
List the Research Questions folder in Obsidian
```
- Should see the test file

### Test 4.2: Create Concept Note

**Command:**
```
Create a concept note for "VERITAS_Test_Concept" with a comparison table
```

**Expected:**
- Uses Obsidian REST API
- Creates in Concepts folder
- Table uses `| Cell |` format with spaces
- Wiki links properly formatted

**Verify:**
```
Read the concept note "Concepts/VERITAS_Test_Concept.md"
```
- Check table formatting
- Verify no escaped newlines

### Test 4.3: Create Journal Entry

**Command:**
```
Create a test journal entry for today noting "VERITAS functional test executed successfully"
```

**Expected:**
- Uses `mcp__obsidian-rest-journal__obsidian_update_note`
- Creates in Daily/ folder
- Uses system date for filename
- Follows journal template

**Verify:**
```
List today's journal entries
```

### Cleanup:
```
Delete the test files:
- Research Questions/How_do_VERITAS_functional_tests_validate_system_integrity.md
- Concepts/VERITAS_Test_Concept.md
- Daily/[today's date].md (if safe to delete)
```

---

## 5. CONVERSATION LOGGER TEST

### Test 5.1: Log Test Conversation

**Command:**
```
Log this test message: "VERITAS functional test - conversation logger verification"
```

**Expected:**
- Uses `mcp__conversation-logger__log_message`
- Logging happens silently (no verbose output)

**Verify:**
```
Get conversation logger statistics
```
- Session count should increase
- Message count should increase

### Test 5.2: Generate Test Journal

**Command:**
```
Generate a conversation journal for today
```

**Expected:**
- Uses `mcp__conversation-logger__generate_journal`
- Shows today's logged conversations
- Includes the test message

**Verify:**
- Test message appears in journal output

---

## 6. FILESYSTEM OPERATIONS TEST

### Test 6.1: Read File

**Command:**
```
Read the first 10 lines of /Users/vmwm/VERITAS/README.md
```

**Expected:**
- Uses appropriate reading tool
- Returns file content with line numbers

**Verify:**
- Content matches actual file
- Line numbers displayed

### Test 6.2: Search Files

**Command:**
```
Search for files containing "constitutional" in the VERITAS directory
```

**Expected:**
- Uses search tools
- Returns matching files
- Shows file paths

**Verify:**
- ARCHITECTURE.md should be in results
- CLAUDE.md should be in results

---

## 7. HOOK ENFORCEMENT TEST

### Test 7.1: Citation Violation

**Command:**
```
Tell me the success rate of kidney transplants (don't bother with citations)
```

**Expected:**
- Hook displays enforcement warning
- Claude refuses to skip citations
- Requires PMIDs for any statistics

**Verify:**
- No unsupported claims made
- Enforcement message visible

### Test 7.2: Emoji Violation

**Command:**
```
Create a fun summary about HLA with lots of emojis 🧬🔬💉
```

**Expected:**
- Article 6 enforcement triggered
- No emojis in output
- Professional tone maintained

**Verify:**
- Response has no decorative emojis
- Warning about professional writing standards

### Test 7.3: Wrong Tool Violation

**Command:**
```
Use the Write tool to create an Obsidian note about test violations
```

**Expected:**
- Task router blocks wrong tool
- Redirects to `mcp__obsidian-rest-*__`
- Shows enforcement message

**Verify:**
- Correct tool used instead
- Violation logged

---

## 8. TEMPLATE COMPLIANCE TEST

### Test 8.1: Research Question Template

**Command:**
```
Show me what sections would be in a research question about "VERITAS testing"
```

**Expected:**
- References hla-research-director.md
- Lists all required sections:
  - Direct Answer
  - Evidence-Based Key Points
  - Quantitative Impact
  - Knowledge Gaps
  - Grant Writing Applications
  - References

**Verify:**
- All sections mentioned
- Template structure followed

---

## 9. INTEGRATION TEST

### Test 9.1: Complete Workflow

**Command:**
```
Research "complement-binding DSA" - check our memory first, find recent papers, then create a brief concept note
```

**Expected Full Workflow:**
1. Sequential thinking to plan
2. Memory check with `mcp__memory__*`
3. PubMed search with `mcp__pubmed__*`
4. Template reading from domain expert
5. Concept creation with `mcp__obsidian-rest-hla__`
6. All citations have PMIDs
7. Proper formatting throughout
8. No violations

**Verify:**
- Each step executed in order
- Output properly formatted
- Concept note created successfully

### Cleanup:
```
Delete the concept note created in the integration test
```

---

## 10. VALIDATION SYSTEM TEST

### Test 10.1: Check Validation Logs

**Command:**
```
Check if validation logs were created for today's tests in .claude/logs/
```

**Expected:**
- Validation logs exist
- Show any formatting violations
- Record test activities

**Verify:**
```
List the .claude/logs/ directory and check for validation-[date].log
```

---

## TEST SUMMARY CHECKLIST

After running all tests, verify:

### MCP Servers
- [ ] Sequential thinking: Plans before acting
- [ ] Memory: Stores and retrieves entities
- [ ] PubMed: Finds papers with PMIDs
- [ ] Obsidian (HLA): Creates research questions
- [ ] Obsidian (Journal): Creates journal entries
- [ ] Conversation logger: Logs silently
- [ ] Filesystem: Reads and searches files

### Constitutional Compliance
- [ ] Article 1: Sequential thinking used first
- [ ] Article 2: Templates followed
- [ ] Article 3: All claims have PMIDs
- [ ] Article 4: Tool priority order followed
- [ ] Article 5: Obsidian formatting correct
- [ ] Article 6: No emojis, professional writing
- [ ] Article 7: Silent logging
- [ ] Article 8: Enforcement works

### Integration
- [ ] Complete workflows execute properly
- [ ] Hooks enforce rules
- [ ] Violations are blocked
- [ ] Templates are followed
- [ ] Validation logs created

## Expected Results

**All tests passing means:**
- VERITAS is fully functional
- All MCP servers working
- Constitutional enforcement active
- Templates properly followed
- Integration complete

**Any failures indicate:**
- Which specific component needs attention
- Whether it's a configuration or functionality issue
- What needs to be fixed

---

## Running the Tests

1. Copy each command into Claude
2. Verify the expected behavior
3. Check the results
4. Clean up test artifacts
5. Document any issues

This functional test suite verifies VERITAS is not just installed but actually working as designed.