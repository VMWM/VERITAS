# Obsidian Content Validation System

## Overview

This document describes the comprehensive validation system implemented to prevent markdown rendering issues in Obsidian vaults. The system validates content BEFORE writing to ensure proper display.

## Problem Statement

When markdown content contains certain formatting errors, Obsidian's parser fails and displays the entire note as raw text instead of rendered markdown. Common causes include:
- Malformed table separators (`|---|---|---|`)
- Invalid YAML frontmatter
- Unclosed formatting tags
- Inconsistent structure

## Solution Architecture

### 1. Pre-Write Validation
All content is validated before writing to Obsidian vaults using rules defined in `config/obsidian-content-validation.json`.

### 2. Auto-Fix System
Common issues are automatically corrected:
- Table separator formatting
- Heading spacing
- Link closure
- Tab-to-space conversion

### 3. Validation Rules

#### Table Validation
```markdown
✅ CORRECT: | Column 1 | Column 2 | Column 3 |
            | --- | --- | --- |
            | Data | Data | Data |

❌ WRONG:   |---|---|---|  (No spaces)
```

#### Frontmatter Validation
- Valid YAML syntax
- Proper `---` delimiters
- No blank lines within frontmatter

#### Link Validation
- All `[[wiki links]]` closed
- All `[markdown](links)` complete
- No orphaned brackets

#### Formatting Validation
- **Bold** and *italic* tags closed
- Code blocks properly terminated
- Headers with proper spacing

## Implementation

### Configuration Files
- `config/obsidian-content-validation.json` - Main validation rules
- `templates/obsidian-table-formatting.md` - Table format reference
- `templates/CLAUDE.md` - Agent instructions

### Workflow Integration
```json
{
  "id": 5,
  "name": "content_validation",
  "actions": ["validate_markdown", "fix_formatting", "check_table_syntax"],
  "required": true,
  "config_ref": "obsidian-content-validation.json"
}
```

### Templates Updated
All templates in `/templates/` directory include:
- Proper table formatting
- Valid frontmatter structure
- Consistent markdown syntax

## Usage

### For Agents
1. Load validation rules from config
2. Validate content before write operations
3. Apply auto-fixes where possible
4. Abort write if validation fails

### For Manual Checks
Run validation against content:
```bash
# Check markdown syntax
# Apply auto-fixes
# Verify frontmatter
```

## Common Issues and Fixes

| Issue | Auto-Fix | Manual Action |
| --- | --- | --- |
| Wrong table separator | `\|---\|---\|` → `\| --- \| --- \|` | None needed |
| Missing heading space | `#Title` → `# Title` | None needed |
| Unclosed wiki link | `[[Link` → `[[Link]]` | None needed |
| Invalid frontmatter | Fix YAML syntax | Review structure |
| Multiple blank lines | Reduce to single | None needed |

## Testing

Before deploying content:
1. Validate against all rules
2. Test render in markdown preview
3. Verify in Obsidian sandbox
4. Deploy to production vault

## Error Handling

If validation fails:
1. Log specific validation errors
2. Attempt auto-fix
3. If auto-fix fails, abort write
4. Request manual review

## Maintenance

### Adding New Rules
1. Update `obsidian-content-validation.json`
2. Add auto-fix if applicable
3. Update this documentation
4. Test with sample content

### Monitoring
- Track validation failures
- Identify common patterns
- Update rules accordingly

## References

- [Obsidian Markdown Guide](https://help.obsidian.md/Editing+and+formatting/Basic+formatting+syntax)
- [CommonMark Specification](https://commonmark.org/)
- [YAML Specification](https://yaml.org/spec/)

---
*Version: 1.0*
*Last Updated: 2025-01-20*
*Maintained by: HLA Agent MCP System*