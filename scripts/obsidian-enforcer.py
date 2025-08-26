#!/usr/bin/env python3
"""
Obsidian MCP Enforcer
Automatically routes all Obsidian-related operations to correct MCP tools
"""

import json
import sys
import re
from pathlib import Path
from typing import Dict, List, Optional

class ObsidianEnforcer:
    """Enforces Obsidian MCP usage for vault operations"""
    
    def __init__(self):
        # Get vault paths from environment or use defaults
        import os
        base_vault = os.environ.get('OBSIDIAN_VAULT_PATH', 'Obsidian/Vault')
        journal_vault = os.environ.get('OBSIDIAN_JOURNAL_PATH', 'Obsidian/Journal')
        
        self.vault_paths = {
            "research_questions": f"{base_vault}/Research Questions/",
            "concepts": f"{base_vault}/Concepts/",
            "journal": f"{journal_vault}/Daily/"
        }
        
        self.file_naming_rules = {
            "research_questions": {
                "pattern": r"^[A-Z][^?]+$",  # No question marks
                "example": "How_HLA_Variables_Affect_Access.md"
            },
            "concepts": {
                "pattern": r"^[A-Z][A-Za-z_]+$",  # Noun phrases
                "example": "MFI_Cutoff_Standardization.md"
            },
            "journal": {
                "pattern": r"^\d{4}-\d{2}-\d{2}$",  # YYYY-MM-DD
                "example": "2025-01-22.md"
            }
        }
        
        self.wiki_link_pattern = r"\[\[([A-Za-z_\s]+)\]\]"
        
    def detect_content_type(self, content: str, filename: str = "") -> str:
        """Determine what type of Obsidian content this is"""
        
        # Check by tags in frontmatter
        if "tags: [research-question" in content:
            return "research_question"
        elif "tags: [concept" in content:
            return "concept"
        elif "tags: [daily-log" in content:
            return "journal"
        
        # Check by content patterns
        if "## Direct Answer" in content and "## Evidence-Based Key Points" in content:
            return "research_question"
        elif "## Key Innovation" in content and "## Clinical Benefits" in content:
            return "concept"
        elif "## Session Summary" in content:
            return "journal"
        
        # Check by filename
        if filename:
            if not filename.endswith("?") and "How" in filename or "What" in filename:
                return "research_question"
            elif any(term in filename for term in ["Protocol", "Method", "Analysis"]):
                return "concept"
            elif re.match(r"\d{4}-\d{2}-\d{2}", filename):
                return "journal"
        
        return "unknown"
    
    def validate_filename(self, filename: str, content_type: str) -> Dict[str, any]:
        """Validate filename follows rules"""
        result = {"valid": True, "errors": [], "suggestions": []}
        
        # Remove .md extension for checking
        name = filename.replace(".md", "")
        
        if content_type == "research_question":
            if "?" in name:
                result["valid"] = False
                result["errors"].append("Research question filenames must not contain '?'")
                result["suggestions"].append(f"Use: {name.replace('?', '')}.md")
        
        elif content_type == "concept":
            if not re.match(self.file_naming_rules["concepts"]["pattern"], name):
                result["valid"] = False
                result["errors"].append("Concept filenames must be noun phrases with underscores")
                result["suggestions"].append("Example: MFI_Cutoff_Standardization.md")
        
        elif content_type == "journal":
            if not re.match(self.file_naming_rules["journal"]["pattern"], name):
                result["valid"] = False
                result["errors"].append("Journal entries must use YYYY-MM-DD format")
                import datetime
                result["suggestions"].append(f"Use: {datetime.date.today()}.md")
        
        return result
    
    def fix_wiki_links(self, content: str) -> str:
        """Ensure wiki links use proper format"""
        # Fix spaced links to use underscores
        def replace_spaces(match):
            link_text = match.group(1)
            return f"[[{link_text.replace(' ', '_')}]]"
        
        content = re.sub(r'\[\[([A-Za-z\s]+)\]\]', replace_spaces, content)
        return content
    
    def fix_formatting(self, content: str) -> str:
        """Fix common formatting issues"""
        # Replace escaped newlines with actual newlines
        content = content.replace('\\n', '\n')
        
        # Fix table formatting (ensure spaces around pipes)
        lines = content.split('\n')
        fixed_lines = []
        for line in lines:
            if '|' in line and not line.startswith('```'):
                # Add spaces around pipes if missing
                line = re.sub(r'\|([^\s|])', r'| \1', line)
                line = re.sub(r'([^\s|])\|', r'\1 |', line)
            fixed_lines.append(line)
        content = '\n'.join(fixed_lines)
        
        # Replace HTML entities with actual symbols
        content = content.replace('&gt;', '>')
        content = content.replace('&lt;', '<')
        content = content.replace('&amp;', '&')
        
        return content
    
    def get_correct_path(self, content_type: str) -> str:
        """Get the correct vault path for this content type"""
        mapping = {
            "research_question": self.vault_paths["research_questions"],
            "concept": self.vault_paths["concepts"],
            "journal": self.vault_paths["journal"]
        }
        return mapping.get(content_type, "")
    
    def generate_mcp_command(self, filename: str, content: str, content_type: str) -> Dict[str, any]:
        """Generate the correct MCP command for this operation"""
        
        # Fix formatting issues
        content = self.fix_formatting(content)
        content = self.fix_wiki_links(content)
        
        # Validate filename
        validation = self.validate_filename(filename, content_type)
        if not validation["valid"]:
            filename = validation["suggestions"][0] if validation["suggestions"] else filename
        
        # Get correct path
        base_path = self.get_correct_path(content_type)
        
        return {
            "tool": "mcp__obsidian-rest-hla__test_request",
            "parameters": {
                "method": "POST",
                "endpoint": f"/vault/{base_path}{filename}",
                "headers": {
                    "Content-Type": "text/markdown"
                },
                "body": content
            },
            "validation": validation,
            "content_type": content_type,
            "full_path": f"{base_path}{filename}"
        }
    
    def enforce_compliance(self, operation: Dict) -> Dict:
        """Main enforcement function"""
        result = {
            "compliant": False,
            "errors": [],
            "corrections": [],
            "mcp_command": None
        }
        
        # Check if this is a filesystem operation on Obsidian content
        if operation.get("tool") in ["Write", "Edit", "filesystem-local"]:
            if any(path in operation.get("path", "") for path in ["/Obsidian/", "/Notes/"]):
                result["errors"].append("VIOLATION: Using filesystem tools for Obsidian content")
                result["corrections"].append("Must use mcp__obsidian__* tools")
                
                # Try to generate correct MCP command
                if "content" in operation:
                    content_type = self.detect_content_type(
                        operation["content"], 
                        Path(operation["path"]).name
                    )
                    result["mcp_command"] = self.generate_mcp_command(
                        Path(operation["path"]).name,
                        operation["content"],
                        content_type
                    )
        else:
            result["compliant"] = True
        
        return result

def main():
    """CLI interface for the enforcer"""
    if len(sys.argv) < 2:
        print("Usage: obsidian-enforcer.py check|fix|validate")
        sys.exit(1)
    
    command = sys.argv[1]
    enforcer = ObsidianEnforcer()
    
    if command == "check":
        # Read operation from stdin
        operation = json.loads(sys.stdin.read())
        result = enforcer.enforce_compliance(operation)
        print(json.dumps(result, indent=2))
    
    elif command == "validate":
        # Validate a filename
        if len(sys.argv) < 4:
            print("Usage: obsidian-enforcer.py validate <filename> <type>")
            sys.exit(1)
        
        filename = sys.argv[2]
        content_type = sys.argv[3]
        result = enforcer.validate_filename(filename, content_type)
        print(json.dumps(result, indent=2))
    
    elif command == "fix":
        # Fix formatting in content
        content = sys.stdin.read()
        fixed = enforcer.fix_formatting(content)
        fixed = enforcer.fix_wiki_links(fixed)
        print(fixed)

if __name__ == "__main__":
    main()