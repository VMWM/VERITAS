#!/usr/bin/env python3
"""
CLAUDE.md Enforcement Hook
Ensures Claude follows all instructions in CLAUDE.md
Runs before every response to reinforce critical requirements
"""

import os
import sys
from pathlib import Path

def enforce_claude_md():
    """Display critical CLAUDE.md requirements that must be followed"""
    
    # Check if CLAUDE.md exists
    claude_md_path = Path("/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025/CLAUDE.md")
    
    if not claude_md_path.exists():
        print("⚠️ WARNING: CLAUDE.md not found! Critical instructions missing!", file=sys.stderr)
        return
    
    # Output enforcement reminder (will be injected into context)
    enforcement = """
CONSTITUTIONAL ENFORCEMENT CHECK
================================
ARTICLE 1 VIOLATION DETECTOR ACTIVE

MANDATORY: You MUST use mcp__sequential-thinking__sequentialthinking FIRST for:
   - ANY complex task
   - Research questions
   - Obsidian operations
   - Multi-step workflows
   
If you haven't used sequential thinking yet, STOP and use it NOW.

CONSTITUTIONAL ARTICLES:
1. Article 1: START with sequential thinking
2. Article 2: Read domain expert file for templates
3. Article 3: PMID required for all claims
4. Article 4: Follow tool priority order
5. Article 5: Obsidian formatting laws
6. Article 6: NO EMOJIS (except check/X/warning when needed)
7. Article 7: Silent conversation logging
8. Article 8: All articles are mandatory

ARTICLE 6 WRITING STANDARDS CHECK:
- NO decorative emojis in any output
- NO em dashes (use regular dashes or commas)
- NO dramatic language ("crucial", "vital", "revolutionary")
- Use direct, evidence-based statements
- Quantitative over qualitative descriptions
- ONLY permitted symbols: check mark, X mark, warning sign when functionally necessary

DOMAIN EXPERT: .claude/agents/hla-research-director.md

WARNING: FAILURE TO START WITH SEQUENTIAL THINKING = CONSTITUTIONAL VIOLATION
================================
"""
    
    print(enforcement)

if __name__ == "__main__":
    enforce_claude_md()