# PMID Verification Workflow
**CRITICAL: Zero Tolerance for PMID Errors**

## Overview
This workflow ensures 100% accuracy of PMIDs in all scientific documents. PMID errors are considered critical failures that compromise scientific integrity.

## Automated Verification System

### 1. Constitutional Requirement (CLAUDE.md Article 8)
- **MANDATORY**: All PMIDs must be verified before use
- **ENFORCEMENT**: Automatic workflow halt on PMID errors
- **LOGGING**: All verifications logged to `.claude/logs/pmid_verification.log`

### 2. Python Verification Script
**Location**: `.claude/scripts/verify_pmids.py`

**Features**:
- Extracts all citations from documents
- Queries PubMed to verify each PMID
- Checks author name and year match
- Logs all verification attempts
- Returns clear error messages for mismatches

**Usage**:
```bash
python3 .claude/scripts/verify_pmids.py /path/to/document.md
```

### 3. Pre-Commit Hook
**Location**: `.claude/hooks/pre-citation-hook.sh`

**Function**:
- Automatically runs before saving documents with PMIDs
- Blocks save if any PMID verification fails
- Provides clear error messages and correction instructions

## Manual Verification Workflow

### For Claude/AI Assistant:

1. **When Adding a Citation**:
   ```
   Search (mcp__pubmed__search_pubmed) 
   → Fetch (mcp__pubmed__fetch_summary) 
   → Verify (check title/authors match)
   → Cross-reference (check Obsidian vault)
   → Use (add to document)
   ```

2. **When Reviewing Citations**:
   - MUST verify each PMID using `mcp__pubmed__fetch_summary`
   - MUST check author names match
   - MUST check publication year matches
   - MUST log any corrections made

3. **When Updating Documents**:
   - Re-verify ALL PMIDs in the document
   - Run verification script before finalizing
   - Document any changes in commit message

### For Human Users:

1. **Before Committing**:
   ```bash
   # Verify all PMIDs in your document
   python3 .claude/scripts/verify_pmids.py F31_Specific_Aims_Final.md
   ```

2. **If Verification Fails**:
   - Review error messages carefully
   - Correct PMIDs using PubMed search
   - Re-run verification until all pass

3. **Quick PMID Check**:
   ```bash
   # Check a single PMID
   curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=PMID_HERE&retmode=json"
   ```

## Error Prevention Strategies

### 1. Always Use Obsidian Vault
- Pre-verified citations in Research Questions
- Cross-reference with existing knowledge base
- Use established PMID-paper mappings

### 2. Double Verification
- AI verifies when adding
- Script verifies before saving
- Human verifies before submitting

### 3. Common Pitfalls to Avoid
- ❌ Using PMIDs from memory
- ❌ Copying PMIDs without verification
- ❌ Assuming similar titles have same PMID
- ❌ Trusting DOI-to-PMID conversions without checking

### 4. Safe Practices
- ✓ Always fetch and verify PMID data
- ✓ Check first author surname matches
- ✓ Verify publication year matches
- ✓ Confirm title is relevant to claim

## Testing the System

### Test Verification Script:
```bash
# Create test file with known good and bad PMIDs
echo "(Wiebe et al., 2012, PMID: 22429309)" > test.md  # Correct
echo "(Wiebe et al., 2012, PMID: 22552107)" >> test.md # Wrong

# Run verification
python3 .claude/scripts/verify_pmids.py test.md
# Should show one success, one failure
```

### Check Logs:
```bash
# View verification history
cat .claude/logs/pmid_verification.log
```

## Emergency Recovery

If PMID errors are discovered after commit:

1. **Immediate Actions**:
   - Run full verification on affected files
   - Create correction commit with "FIX: PMID corrections" message
   - Document errors in `.claude/logs/pmid_corrections.log`

2. **Root Cause Analysis**:
   - Identify how error bypassed checks
   - Update verification scripts if needed
   - Add test case to prevent recurrence

## Integration with Git

### Add to .git/hooks/pre-commit:
```bash
#!/bin/bash
# Run PMID verification on all .md files being committed
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.md$'); do
    if grep -q "PMID:" "$file"; then
        python3 .claude/scripts/verify_pmids.py "$file" || exit 1
    fi
done
```

## Metrics and Monitoring

### Track Verification Success:
```bash
# Count successful verifications
grep "Status: SUCCESS" .claude/logs/pmid_verification.log | wc -l

# Count failures
grep "Status: FAILED" .claude/logs/pmid_verification.log | wc -l
```

### Regular Audits:
- Weekly: Review verification logs
- Monthly: Test verification script with known PMIDs
- Quarterly: Update PubMed API integration if needed

## Support and Troubleshooting

### Common Issues:

1. **PubMed API Timeout**:
   - Wait 1 minute and retry
   - Check internet connection
   - Use backup verification method (manual check)

2. **Author Name Variations**:
   - Check for special characters (ü, ñ, etc.)
   - Try last name only matching
   - Verify against paper PDF if available

3. **Year Discrepancies**:
   - Check epub vs print dates
   - Use year from PubMed as authoritative
   - Document any corrections needed

## Compliance Statement

By using this system, you acknowledge that:
- PMID accuracy is critical for scientific integrity
- All citations must be verified before use
- Errors will trigger workflow stops
- This is a zero-tolerance policy

---
*Last Updated: 2025-01-29*
*Version: 1.0*
*Contact: Research Integrity Team*