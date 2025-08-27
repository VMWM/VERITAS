#!/usr/bin/env python3
"""
First Response Enforcer - Forces checking of instructions on every new conversation
"""

import os
import json
from pathlib import Path

def check_conversation_state():
    """Check if this is a new conversation or continuation"""
    # This would need integration with Claude's conversation tracking
    # For now, we'll use a marker file
    marker = Path("/tmp/.claude_conversation_marker")
    
    if not marker.exists():
        # New conversation - force instruction check
        return "NEW"
    else:
        # Check if marker is older than 30 minutes (new session)
        import time
        age = time.time() - marker.stat().st_mtime
        if age > 1800:  # 30 minutes
            return "NEW"
        return "CONTINUING"

def enforce_instruction_check():
    """Force Claude to check instructions"""
    print("""
╔══════════════════════════════════════════════════════════════════╗
║                    MANDATORY FIRST CHECK                         ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  BEFORE RESPONDING, YOU MUST:                                   ║
║                                                                  ║
║  1. READ: ${PROJECT_DIR}/CLAUDE.md                             ║
║  2. READ: ${PROJECT_DIR}/.claude/agents/*                      ║
║  3. START WITH: mcp__sequential-thinking__sequentialthinking    ║
║                                                                  ║
║  CRITICAL RULES:                                                ║
║  • Obsidian content → Use mcp__obsidian__* ONLY               ║
║  • Medical claims → Need (Author et al., Year, PMID: XXXXXXXX) ║
║  • Research questions → Go to Obsidian vault, NOT /Notes/      ║
║                                                                  ║
║  VIOLATIONS WILL BE LOGGED AND REPORTED                         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝

CONVERSATION STATE: {state}
ENFORCEMENT ACTIVE: TRUE
""".format(state=check_conversation_state()))
    
    # Update marker
    Path("/tmp/.claude_conversation_marker").touch()

if __name__ == "__main__":
    enforce_instruction_check()