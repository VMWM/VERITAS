#!/usr/bin/env python3
"""
Task Router - Enforces correct tool usage based on task type
Prevents filesystem operations when Obsidian MCP should be used
"""

import sys
import json
import re
from pathlib import Path

class TaskRouter:
    def __init__(self):
        self.config = self.load_config()
        self.obsidian_paths = [
            "/Obsidian/HLA Antibodies/",
            "/Obsidian/Research Journal/",
            "/Notes/"  # This should trigger Obsidian MCP
        ]
        
    def load_config(self):
        """Load agent configuration"""
        # Try local project path first, then fallback to generic
        import os
        project_dir = os.environ.get('PROJECT_DIR', os.getcwd())
        agent_path = Path(project_dir) / ".claude/agents/research-director.md"
        if not agent_path.exists():
            # Fallback to standard location
            agent_path = Path(".claude/agents/research-director.md")
        if agent_path.exists():
            return agent_path.read_text()
        return ""
    
    def detect_task_type(self, user_input):
        """Determine what type of task is being requested"""
        input_lower = user_input.lower()
        
        # Research question indicators
        if any(phrase in input_lower for phrase in [
            "research question", "add to obsidian", "create concept",
            "vault", "obsidian", "template", "wiki link"
        ]):
            return "obsidian_task"
        
        # Code/analysis indicators
        if any(phrase in input_lower for phrase in [
            "analyze", "code", "implement", "debug", "test"
        ]):
            return "code_task"
            
        return "general_task"
    
    def get_required_tools(self, task_type):
        """Return the required tools for this task type"""
        if task_type == "obsidian_task":
            return {
                "required": [
                    "mcp__sequential-thinking__sequentialthinking",
                    "mcp__obsidian__*",
                    "mcp__pubmed__*"
                ],
                "forbidden": [
                    "filesystem-local",
                    "Write",
                    "Edit"
                ],
                "paths": {
                    "research_questions": "Research Questions/",
                    "concepts": "Concepts/",
                    "journal": "Daily/"
                }
            }
        return {"required": [], "forbidden": []}
    
    def validate_tool_usage(self, planned_action):
        """Check if the planned action uses correct tools"""
        violations = []
        
        # Check for filesystem operations on Obsidian content
        if "filesystem" in planned_action or "Write" in planned_action:
            for path in self.obsidian_paths:
                if path in planned_action:
                    violations.append(f"❌ VIOLATION: Using filesystem tools for Obsidian content at {path}")
                    violations.append(f"✅ REQUIRED: Use mcp__obsidian__* tools instead")
        
        # Check for missing sequential thinking
        if "obsidian" in planned_action.lower() and "sequential-thinking" not in planned_action:
            violations.append(f"❌ VIOLATION: Not using sequential thinking for Obsidian task")
            violations.append(f"✅ REQUIRED: Start with mcp__sequential-thinking__sequentialthinking")
        
        return violations
    
    def generate_enforcement_message(self, task_type, user_input):
        """Generate enforcement instructions"""
        tools = self.get_required_tools(task_type)
        
        if task_type == "obsidian_task":
            return f"""
🚫 TASK ROUTING ENFORCEMENT 🚫
================================
DETECTED: Obsidian-related task

MANDATORY WORKFLOW:
1. ✅ START with mcp__sequential-thinking__sequentialthinking
2. ✅ USE mcp__obsidian__* tools ONLY for vault operations
3. ✅ VERIFY citations with mcp__pubmed__*
4. ❌ DO NOT use filesystem-local, Write, or Edit tools

FILE LOCATIONS:
• Research Questions: {tools['paths']['research_questions']}
• Concepts: {tools['paths']['concepts']}
• Daily Journal: {tools['paths']['journal']}

FILE NAMING:
• Research Questions: Remove "?" from filename
• Concepts: Use noun phrases
• Use wiki links: [[Concept_Name]]

FORMATTING:
• NO escaped newlines (\\n)
• Tables with spaces: | Cell |
• Use actual > < symbols
• NO underscores in H1 headings

THIS IS MANDATORY - VIOLATIONS WILL BE REJECTED
================================
"""
        return ""

def main():
    """Main execution"""
    # Get user input from environment or stdin
    user_input = sys.stdin.read() if not sys.stdin.isatty() else ""
    
    router = TaskRouter()
    task_type = router.detect_task_type(user_input)
    
    if task_type == "obsidian_task":
        enforcement = router.generate_enforcement_message(task_type, user_input)
        print(enforcement)
        
        # Set environment variable to track enforcement
        import os
        os.environ['TASK_TYPE'] = 'obsidian_task'
        os.environ['ENFORCE_OBSIDIAN_MCP'] = '1'

if __name__ == "__main__":
    main()