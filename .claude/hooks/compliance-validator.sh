#!/bin/bash

# Compliance Validator - Enforces tool usage rules
# This script runs BEFORE any command execution

echo "COMPLIANCE VALIDATOR ACTIVE"
echo "=============================="

# Check if this is an Obsidian-related task
if [[ "$*" == *"obsidian"* ]] || [[ "$*" == *"vault"* ]] || [[ "$*" == *"research question"* ]]; then
    echo "OBSIDIAN TASK DETECTED"
    echo ""
    echo "MANDATORY REQUIREMENTS:"
    echo "1. USE: mcp__sequential-thinking__sequentialthinking FIRST"
    echo "2. USE: mcp__obsidian__* for ALL vault operations"
    echo "3. USE: mcp__pubmed__* for ALL citations"
    echo "4. NEVER: filesystem-local, Write, or Edit tools"
    echo ""
    echo "CORRECT PATHS:"
    echo "• Research Questions: /Obsidian/Research Vault/Research Questions/"
    echo "• Concepts: /Obsidian/Research Vault/Concepts/"
    echo "• Journal: /Obsidian/Research Journal/Daily/"
    echo ""
    echo "VIOLATIONS WILL CAUSE TASK FAILURE"
    echo "=============================="
    
    # Set flag for enforcement
    export ENFORCE_OBSIDIAN_MCP=1
    export OBSIDIAN_TASK_ACTIVE=1
fi

# Check for filesystem operations on Obsidian paths
if [[ "$*" == *"filesystem"* ]] || [[ "$*" == *"Write"* ]] || [[ "$*" == *"Edit"* ]]; then
    if [[ "$*" == *"/Obsidian/"* ]] || [[ "$*" == *"/Notes/"* ]]; then
        echo ""
        echo "CRITICAL VIOLATION DETECTED"
        echo "================================"
        echo "ERROR: Attempting to use filesystem tools on Obsidian content"
        echo "REQUIRED: MUST use mcp__obsidian__* tools instead"
        echo ""
        echo "This is a blocking error. Task cannot proceed."
        echo "================================"
        
        # Return error code to block execution
        exit 1
    fi
fi

echo "Pre-execution validation complete"
echo "=============================="