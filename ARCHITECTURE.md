# VERITAS Architecture: Constitutional Design

## Overview

VERITAS uses a **constitutional architecture** that separates universal research integrity rules from domain-specific expertise. This design ensures VERITAS can be adapted to any research domain while maintaining consistent quality standards.

## Two-File Architecture

### 1. CLAUDE.md - The Constitution
**Location**: `.claude/CLAUDE.md` (or project root)
**Purpose**: Universal rules that govern ALL VERITAS installations
**Size**: ~70-100 lines (intentionally compact)

The constitution contains:
- **Article 1**: Complex Task Protocol (sequential thinking requirement)
- **Article 2**: Research Documentation Protocol (workflow routing)
- **Article 3**: Citation Requirements (PMID enforcement)
- **Article 4**: Tool Priority Order (universal tool chain)
- **Article 5**: Obsidian Formatting Laws (markdown standards)
- **Article 6**: Conversation Logging (memory database)
- **Article 7**: Enforcement (compliance mechanisms)

**Key Principle**: The constitution NEVER changes between domains. It's the same whether you're researching HLA antibodies, cancer genomics, or climate science.

### 2. Domain Expert Files - The Legislation
**Location**: `.claude/agents/[domain]-expert.md`
**Purpose**: Domain-specific knowledge, templates, and workflows
**Size**: Can be extensive (200+ lines)

Domain expert files contain:
- Research aims and objectives
- Grant-specific requirements
- Domain-specific templates
- Specialized folder structures
- Field-specific terminology
- Custom validation rules

## Why This Architecture?

### 1. **Cognitive Load Management**
Large CLAUDE.md files can overwhelm Claude's instruction processing, leading to:
- Missed instructions
- Inconsistent compliance
- Performance degradation

By keeping CLAUDE.md compact and focused, we ensure critical rules are always followed.

### 2. **Separation of Concerns**
- **Constitution**: WHAT to do and WHEN (universal workflow)
- **Domain Expert**: HOW to do it (specialized knowledge)

This mirrors successful software design patterns and governmental systems.

### 3. **Domain Portability**
New users can:
1. Copy the universal CLAUDE.md
2. Create their own domain expert file
3. Immediately have a working VERITAS system

No need to edit core rules or risk breaking the system.

### 4. **Maintainability**
- Updates to core VERITAS behavior only require changing the constitution
- Domain-specific improvements stay isolated in expert files
- Clear ownership and responsibility boundaries

## Implementation Guide

### For New VERITAS Users

1. **Copy the Constitution**
   ```bash
   cp templates/CLAUDE.md ~/.claude/CLAUDE.md
   ```

2. **Create Your Domain Expert**
   ```bash
   cp templates/agents/example-domain-expert.md ~/.claude/agents/[your-domain]-expert.md
   ```

3. **Customize the Domain Expert**
   - Replace placeholder text with your research focus
   - Define your grant targets
   - Create your templates
   - Specify your folder structure

4. **Update Article 2 in CLAUDE.md**
   - Change the reference from `domain-expert.md` to `[your-domain]-expert.md`

### For Existing Users

1. **Backup Current CLAUDE.md**
   ```bash
   cp CLAUDE.md CLAUDE.md.backup
   ```

2. **Extract Domain-Specific Content**
   - Move research aims to domain expert file
   - Move specialized templates
   - Move project-specific paths

3. **Replace with Constitution**
   - Use the universal CLAUDE.md
   - Ensure domain expert file is referenced

## File Size Guidelines

### CLAUDE.md (Constitution)
- **Target**: 70-100 lines
- **Maximum**: 150 lines
- **Content**: Only universal rules
- **No**: Domain-specific content, detailed templates, project paths

### Domain Expert Files
- **Minimum**: 50 lines (basic templates)
- **Typical**: 200-300 lines
- **Maximum**: No hard limit, but consider splitting if >500 lines
- **Content**: All domain-specific knowledge

## Enforcement Hierarchy

1. **Constitution** (CLAUDE.md) - Highest priority
2. **Domain Expert** - Implements constitutional requirements
3. **Hooks** - Enforce both constitution and domain rules
4. **User Instructions** - Cannot override constitution

## Example Implementations

### HLA Research (Immunology)
- **Constitution**: Standard CLAUDE.md
- **Domain Expert**: `hla-research-director.md`
- **Focus**: Transplant antibodies, F31 grant

### Cancer Genomics (Hypothetical)
- **Constitution**: Standard CLAUDE.md
- **Domain Expert**: `cancer-genomics-expert.md`
- **Focus**: Tumor mutations, R01 grant

### Climate Science (Hypothetical)
- **Constitution**: Standard CLAUDE.md
- **Domain Expert**: `climate-research-expert.md`
- **Focus**: Carbon modeling, NSF CAREER grant

## Troubleshooting

### Problem: Instructions being ignored
**Solution**: Check CLAUDE.md size. If >150 lines, move content to domain expert.

### Problem: Domain expert not loading
**Solution**: Verify Article 2 in CLAUDE.md points to correct file.

### Problem: Conflicting instructions
**Solution**: Constitution always wins. Domain expert implements, never overrides.

## Future Enhancements

### Multiple Domain Experts
Future versions may support multiple domain experts:
- `agents/writing-expert.md` - Academic writing standards
- `agents/statistics-expert.md` - Statistical analysis rules
- `agents/grant-expert.md` - Grant-specific requirements

### Dynamic Loading
Potential for context-aware expert loading:
```markdown
IF task involves statistics THEN load statistics-expert.md
IF task involves writing THEN load writing-expert.md
```

## Conclusion

The constitutional architecture makes VERITAS:
- **Universal**: Same core rules for all research
- **Adaptable**: Easy to customize for any domain
- **Maintainable**: Clear separation of concerns
- **Reliable**: Compact constitution ensures compliance

This design philosophy - separating immutable principles from domain expertise - creates a robust, portable research infrastructure.