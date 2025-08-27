#!/bin/bash

# Startup Check - Ensures Claude checks instructions at conversation start

echo "════════════════════════════════════════════════════════════════════"
echo "                    CLAUDE CODE STARTUP CHECK                       "
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "📍 PROJECT: Research Project"
echo "📍 LOCATION: [Project Directory]"
echo ""
echo "CRITICAL INSTRUCTION LOCATIONS:"
echo "   1. CLAUDE.md - Main instructions"
echo "   2. .claude/agents/research-director.md - Templates"
echo "   3. .claude/config/verification.json - Validation rules"
echo ""
echo "MANDATORY RULES:"
echo "   • START with sequential thinking for planning"
echo "   • Obsidian tasks → Use mcp__obsidian__* tools ONLY"
echo "   • Research/concepts → Go to Obsidian vault folders"
echo "   • NEVER use filesystem tools for Obsidian content"
echo "   • ALL medical claims need PMIDs"
echo ""
echo "REQUIRED FIRST ACTION:"
echo "   If user mentions research/vault/obsidian:"
echo "   1. Use mcp__sequential-thinking__sequentialthinking"
echo "   2. Read research-director.md for templates"
echo "   3. Use mcp__obsidian__* tools exclusively"
echo ""
echo "════════════════════════════════════════════════════════════════════"

# Set environment variables
export ENFORCE_OBSIDIAN_MCP=1
# These should be set by the user in their environment or during setup
export CLAUDE_PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-$(pwd)}"
export OBSIDIAN_VAULT_PATH="${OBSIDIAN_VAULT_PATH:-Obsidian/Vault}"