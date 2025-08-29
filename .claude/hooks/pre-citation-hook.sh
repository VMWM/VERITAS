#!/bin/bash
# VERITAS PMID Verification Pre-Commit Hook
# Prevents saving documents with unverified PMIDs

echo "===================================="
echo "VERITAS PMID Verification Check"
echo "===================================="

# Find the .claude directory
if [ -n "$VERITAS_ROOT" ]; then
    CLAUDE_DIR="$VERITAS_ROOT/.claude"
elif [ -d ".claude" ]; then
    CLAUDE_DIR=".claude"
elif [ -d "../.claude" ]; then
    CLAUDE_DIR="../.claude"
elif [ -d "../../.claude" ]; then
    CLAUDE_DIR="../../.claude"
else
    # Try to find it relative to script location
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    CLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
fi

VERIFY_SCRIPT="$CLAUDE_DIR/scripts/verify_pmids.py"

# Check if verification script exists
if [ ! -f "$VERIFY_SCRIPT" ]; then
    echo "Warning: PMID verification script not found at $VERIFY_SCRIPT"
    echo "Skipping PMID verification"
    exit 0
fi

# Check if file contains PMIDs
if grep -q "PMID:" "$1" 2>/dev/null; then
    echo "PMIDs detected in document. Running verification..."
    
    # Run Python verification script
    if python3 "$VERIFY_SCRIPT" "$1"; then
        echo "✓ All PMIDs verified successfully"
    else
        echo ""
        echo "⚠️  CRITICAL ERROR: PMID VERIFICATION FAILED"
        echo "===================================="
        echo "One or more PMIDs do not match their cited papers."
        echo "This violates VERITAS Article 8: PMID Verification Protocol"
        echo ""
        echo "Required Actions:"
        echo "1. Review the error messages above"
        echo "2. Correct the mismatched PMIDs"
        echo "3. Re-verify using: python3 $VERIFY_SCRIPT <file>"
        echo ""
        echo "DOCUMENT SAVE BLOCKED UNTIL PMIDS ARE CORRECTED"
        echo "===================================="
        exit 1
    fi
else
    echo "No PMIDs found in document - skipping verification"
fi

echo "===================================="
echo "✅ Pre-citation check completed"
echo "===================================="