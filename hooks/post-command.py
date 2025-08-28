#!/usr/bin/env python3

"""
Post-command hook for HLA Research Assistant
Verifies that all outputs comply with CLAUDE.md requirements
"""

import sys
import re
import json
import os
from datetime import datetime
from pathlib import Path

class HLAOutputVerifier:
    def __init__(self):
        self.violations = []
        self.warnings = []
        # Enable logging with rotation
        self.log_path = Path("/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/logs")
        self.log_path.mkdir(parents=True, exist_ok=True)
        
        # Load verification config
        config_path = Path("/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025/.claude/config/verification.json")
        with open(config_path, 'r') as f:
            self.config = json.load(f)
    
    def check_pmid_citations(self, content):
        """Verify all medical claims have proper PMID citations"""
        # Pattern for valid citation
        valid_pattern = r'\([A-Z][a-z]+ et al\., \d{4}, PMID: \d{8}\)'
        
        # Medical/scientific claim indicators
        claim_indicators = [
            r'\b\d+(?:\.\d+)?%\b',  # Percentages
            r'\b(?:increased?|decreased?|associated?|correlated?|significant)\b',
            r'\b(?:incidence|prevalence|rate|risk|odds|hazard|ratio)\b',
            r'\b(?:p\s*[<=]\s*0\.\d+)\b',  # p-values
            r'\b(?:n\s*=\s*\d+)\b',  # sample sizes
        ]
        
        lines = content.split('\n')
        for i, line in enumerate(lines, 1):
            # Skip headers, empty lines, and code blocks
            if line.startswith('#') or not line.strip() or line.startswith('```'):
                continue
            
            # Check for claim indicators
            for indicator in claim_indicators:
                if re.search(indicator, line, re.IGNORECASE):
                    # Check if line has valid PMID citation
                    if not re.search(valid_pattern, line):
                        self.violations.append({
                            'line': i,
                            'type': 'missing_pmid',
                            'content': line[:100],
                            'severity': 'error'
                        })
    
    def check_verification_levels(self, content):
        """Check for proper verification level tags"""
        valid_levels = ['[FT-VERIFIED]', '[ABSTRACT-VERIFIED]', '[NEEDS-FT-REVIEW]']
        
        # Check if content has citations but no verification levels
        if 'PMID:' in content:
            has_any_level = any(level in content for level in valid_levels)
            if not has_any_level:
                self.warnings.append({
                    'type': 'missing_verification_level',
                    'message': 'Citations present but no verification levels found',
                    'severity': 'warning'
                })
    
    def check_obsidian_formatting(self, content, is_markdown=False):
        """Check for proper Obsidian formatting"""
        if not is_markdown:
            return
        
        violations = []
        
        # Check for escaped newlines
        if r'\n' in content:
            violations.append('Contains escaped newlines (\\n)')
        
        # Check for HTML entities
        if '&gt;' in content or '&lt;' in content:
            violations.append('Contains HTML entities (&gt; or &lt;)')
        
        # Check H1 headings for underscores
        h1_pattern = r'^#\s+.*_.*$'
        for line in content.split('\n'):
            if re.match(h1_pattern, line):
                violations.append(f'H1 heading contains underscore: {line}')
        
        # Check table formatting
        table_pattern = r'\|(?! )|(?<! )\|'
        if '|' in content:
            for line in content.split('\n'):
                if '|' in line and re.search(table_pattern, line):
                    self.warnings.append({
                        'type': 'table_formatting',
                        'message': f'Table may need spaces around pipes: {line[:50]}',
                        'severity': 'warning'
                    })
        
        for v in violations:
            self.violations.append({
                'type': 'obsidian_formatting',
                'content': v,
                'severity': 'error'
            })
    
    def check_unsupported_claims(self, content):
        """Check for unsupported general claims"""
        forbidden_phrases = [
            (r'\b(?:it is (?:well )?known)\b', 'it is known'),
            (r'\b(?:studies show)\b', 'studies show'),
            (r'\b(?:research indicates)\b', 'research indicates'),
            (r'\b(?:evidence suggests)\b', 'evidence suggests'),
            (r'\b(?:has been shown)\b', 'has been shown'),
            (r'\b(?:data demonstrates?)\b', 'data demonstrates'),
        ]
        
        lines = content.split('\n')
        for i, line in enumerate(lines, 1):
            for pattern, phrase in forbidden_phrases:
                if re.search(pattern, line, re.IGNORECASE):
                    # Check if followed by PMID within same paragraph
                    if 'PMID:' not in line and (i >= len(lines) or 'PMID:' not in lines[i]):
                        self.violations.append({
                            'line': i,
                            'type': 'unsupported_claim',
                            'content': f'"{phrase}" without citation',
                            'severity': 'error'
                        })
    
    def verify_output(self, output_content, output_type='text'):
        """Main verification function"""
        print("\nHLA Output Verification Running...")
        print("=" * 50)
        
        # Determine if markdown
        is_markdown = output_type == 'markdown' or output_content.startswith('#')
        
        # Run all checks
        self.check_pmid_citations(output_content)
        self.check_verification_levels(output_content)
        self.check_obsidian_formatting(output_content, is_markdown)
        self.check_unsupported_claims(output_content)
        
        # Generate report
        self.generate_report()
        
        # Log results for audit trail
        self.log_results(output_content)
        
        # Return status
        return len(self.violations) == 0
    
    def generate_report(self):
        """Generate verification report"""
        if not self.violations and not self.warnings:
            print("✅ All checks passed! Output complies with CLAUDE.md requirements.")
            return
        
        if self.violations:
            print(f"\n❌ Found {len(self.violations)} violation(s):")
            for v in self.violations[:5]:  # Show first 5
                print(f"  - Line {v.get('line', 'N/A')}: {v['type']} - {v['content']}")
            if len(self.violations) > 5:
                print(f"  ... and {len(self.violations) - 5} more")
        
        if self.warnings:
            print(f"\n⚠️  Found {len(self.warnings)} warning(s):")
            for w in self.warnings[:3]:
                print(f"  - {w['type']}: {w['message']}")
        
        print("\n📋 Required Actions:")
        if any(v['type'] == 'missing_pmid' for v in self.violations):
            print("  1. Add PMID citations for all medical claims")
            print("     Use: mcp__pubmed-ncukondo__search")
        if any(v['type'] == 'obsidian_formatting' for v in self.violations):
            print("  2. Fix Obsidian formatting issues")
        if self.warnings:
            print("  3. Add verification levels to citations")
        
        print("\n" + "=" * 50)
    
    def log_results(self, content):
        """Log verification results"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        log_file = self.log_path / f"verification_{timestamp}.json"
        
        log_data = {
            'timestamp': timestamp,
            'violations': self.violations,
            'warnings': self.warnings,
            'content_length': len(content),
            'passed': len(self.violations) == 0
        }
        
        with open(log_file, 'w') as f:
            json.dump(log_data, f, indent=2)

def main():
    """Main hook execution - check recently modified files"""
    verifier = HLAOutputVerifier()
    
    # Check files modified in last 2 minutes
    import subprocess
    try:
        # Find recently modified .md files
        result = subprocess.run(
            ["find", "/Users/vmwm", "-name", "*.md", "-mmin", "-2", "-type", "f"],
            capture_output=True,
            text=True,
            timeout=5
        )
        
        recent_files = [f for f in result.stdout.strip().split('\n') if f and '.Trash' not in f]
        
        all_violations = []
        for filepath in recent_files[:5]:  # Check up to 5 recent files
            try:
                with open(filepath, 'r') as f:
                    content = f.read()
                    verifier.violations = []  # Reset for each file
                    success = verifier.verify_output(content)
                    if not success:
                        all_violations.append((filepath, verifier.violations[:]))
            except:
                pass
        
        # Report violations if any
        if all_violations:
            print("\n⚠️  POST-EXECUTION VALIDATOR")
            print("="*40)
            for filepath, violations in all_violations:
                print(f"\nFile: {filepath}")
                for v in violations[:3]:  # Show first 3 violations per file
                    print(f"  - {v}")
            print("="*40)
    except:
        pass  # Silent fail if checking doesn't work
    
    sys.exit(0)

if __name__ == "__main__":
    main()