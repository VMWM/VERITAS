#!/usr/bin/env python3
"""
CLAUDE.md Enforcement Hook
Ensures Claude follows all instructions in CLAUDE.md
Runs before every response to reinforce critical requirements
"""

import os
import sys
from pathlib import Path

def find_project_root():
    """Find the project root directory by looking for CLAUDE.md"""
    # Get the directory where this script is located
    script_path = Path(__file__).resolve()
    script_dir = script_path.parent
    
    # If we're in .claude/hooks/, go up two levels to project root
    if script_dir.name == "hooks" and script_dir.parent.name == ".claude":
        project_root = script_dir.parent.parent
        if (project_root / "CLAUDE.md").exists():
            return project_root
    
    # Fallback: search upward from script directory  
    current = script_dir
    while current != current.parent:
        if (current / "CLAUDE.md").exists():
            return current
        current = current.parent
    
    # Last resort: check current working directory
    if (Path.cwd() / "CLAUDE.md").exists():
        return Path.cwd()
    
    return Path.cwd()

def enforce_claude_md():
    """Display critical CLAUDE.md requirements that must be followed"""
    
    # Check if CLAUDE.md exists
    project_root = find_project_root()
    claude_md_path = project_root / "CLAUDE.md"
    
    if not claude_md_path.exists():
        print("WARNING: CLAUDE.md not found! Critical instructions missing!", file=sys.stderr)
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