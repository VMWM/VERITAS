#!/usr/bin/env python3
"""
Pre-Compact Hook - Automatic Conversation Logger
Triggers when Claude Code is about to compact the conversation.
This captures the full conversation before summarization.
"""

import os
import json
import sys
from datetime import datetime

def log_conversation_before_compact():
    """
    Logs the current conversation to conversation-logger MCP
    This runs right before compaction, capturing the full conversation
    """

    # Get conversation context from environment
    conversation_length = os.environ.get('CLAUDE_CONVERSATION_LENGTH', '0')
    context_used = os.environ.get('CLAUDE_CONTEXT_USED_PERCENT', '0')
    project_path = os.environ.get('CLAUDE_PROJECT_DIR', os.getcwd())

    # Log to stderr (visible to user)
    print(f"⚠ Conversation compacting at {context_used}% context usage", file=sys.stderr)
    print(f"📝 Auto-logging conversation before compaction...", file=sys.stderr)

    # Output special format that Claude Code can use to invoke MCP tool
    # This is a hint to Claude to log the conversation
    output = {
        "systemMessage": "IMPORTANT: Before compacting, please log this conversation using the conversation-logger MCP tool. Use mcp__conversation-logger__log_activity with activity_type='pre_compact' and include the current conversation summary.",
        "additionalContext": f"Conversation about to compact at {context_used}% context. Project: {project_path}",
        "suggestedAction": "log_conversation"
    }

    print(json.dumps(output, indent=2))

    # Also create a marker file
    marker_dir = os.path.expanduser("~/.conversation-logger")
    os.makedirs(marker_dir, exist_ok=True)

    marker_file = os.path.join(marker_dir, "pending_compact_log.json")
    with open(marker_file, 'w') as f:
        json.dump({
            "timestamp": datetime.now().isoformat(),
            "context_used": context_used,
            "project_path": project_path,
            "conversation_length": conversation_length
        }, f, indent=2)

    print(f"✓ Compact marker created", file=sys.stderr)

def main():
    """Main hook execution"""
    try:
        log_conversation_before_compact()
    except Exception as e:
        print(f"Note: Pre-compact logging hook error: {e}", file=sys.stderr)
        # Don't fail the hook - compaction should still proceed

if __name__ == "__main__":
    main()
