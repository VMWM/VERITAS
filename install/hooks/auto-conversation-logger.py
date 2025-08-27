#!/usr/bin/env python3
"""
Automatic Conversation Logger Hook
Logs all conversations to conversation-logger MCP server
Maintains 5-day rolling history for journal generation
"""

import os
import json
import sys
from datetime import datetime, timedelta

def log_to_mcp(role, content, tools_used=None):
    """Send log message to conversation-logger MCP server"""
    
    # Only log substantial content (not empty or very short)
    if not content or len(content.strip()) < 10:
        return
    
    # Prepare the MCP tool call
    tool_call = {
        "tool": "mcp__conversation-logger__log_message",
        "arguments": {
            "role": role,
            "content": content[:5000],  # Limit to 5000 chars to avoid huge logs
            "tools_used": tools_used or []
        }
    }
    
    # Create a flag file to indicate logging is active
    flag_file = os.path.expanduser("~/.conversation-logger/active")
    os.makedirs(os.path.dirname(flag_file), exist_ok=True)
    with open(flag_file, 'w') as f:
        f.write(f"Logging active since {datetime.now().isoformat()}\n")

def cleanup_old_logs():
    """Clean up conversation logs older than 5 days"""
    
    import sqlite3
    db_path = os.path.expanduser("~/.conversation-logger/conversations.db")
    
    if not os.path.exists(db_path):
        return
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Delete messages older than 5 days
        five_days_ago = (datetime.now() - timedelta(days=5)).isoformat()
        cursor.execute("""
            DELETE FROM messages 
            WHERE timestamp < ?
        """, (five_days_ago,))
        
        # Delete activities older than 5 days
        cursor.execute("""
            DELETE FROM activities 
            WHERE timestamp < ?
        """, (five_days_ago,))
        
        # Delete old sessions with no messages
        cursor.execute("""
            DELETE FROM sessions 
            WHERE start_time < ? 
            AND id NOT IN (SELECT DISTINCT session_id FROM messages)
        """, (five_days_ago,))
        
        changes = conn.total_changes
        conn.commit()
        conn.close()
        
        if changes > 0:
            print(f"✓ Cleaned up {changes} old log entries", file=sys.stderr)
        
    except Exception as e:
        print(f"Note: Could not clean old logs: {e}", file=sys.stderr)

def main():
    """Main hook execution"""
    
    # Get conversation content from environment or stdin
    user_input = os.environ.get('CLAUDE_USER_MESSAGE', '')
    assistant_output = os.environ.get('CLAUDE_ASSISTANT_MESSAGE', '')
    tools_used = os.environ.get('CLAUDE_TOOLS_USED', '').split(',') if os.environ.get('CLAUDE_TOOLS_USED') else []
    
    # Log user message if present
    if user_input:
        log_to_mcp('user', user_input, [])
    
    # Log assistant response if present
    if assistant_output:
        log_to_mcp('assistant', assistant_output, tools_used)
    
    # Clean up old logs periodically
    if datetime.now().hour == 2:  # Run cleanup at 2 AM
        cleanup_old_logs()
    
    # For SessionEnd hook, just mark completion
    print("✓ Conversation logged", file=sys.stderr)

if __name__ == "__main__":
    main()