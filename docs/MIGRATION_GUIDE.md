# VERITAS Migration Guide

**Upgrading from Hook-Based VERITAS to Modern Claude Code Version**

This guide helps existing VERITAS users migrate to the updated version that leverages Claude Code's built-in features instead of deprecated hooks.

## What Changed

### Removed Features
1. **Pre/Post-Command Hooks** - No longer supported by Claude Code
2. **Manual Conversation Logger** - Replaced with built-in JSONL transcript system
3. **Hook-based Enforcement** - Now uses CLAUDE.md and output style system
4. **Complex Hook Scripts** - Simplified to core constitutional rules

### New Features
1. **TodoWrite Integration** - Track multi-step research tasks automatically
2. **Slash Commands** - Quick access to common workflows
3. **Smart Parallel Execution** - Optimized tool usage based on operation type
4. **Simplified MCP Configuration** - Automatic in VS Code extension
5. **Claude Code Native Logging** - Built-in JSONL conversation tracking

### Updated Features
1. **Article 4: Tool Usage Rules** - Now includes guidance on parallel vs sequential execution
2. **Article 7: Journal Workflow** - Updated for built-in JSONL logging
3. **Article 8: Task Management** - New article for TodoWrite integration
4. **Sequential Thinking** - Now optional, only for complex multi-step tasks

## Migration Steps

### Step 1: Backup Your Current Setup

```bash
# Backup your current CLAUDE.md
cp CLAUDE.md CLAUDE.md.backup.$(date +%Y%m%d)

# Backup your .claude directory
cp -r .claude .claude.backup.$(date +%Y%m%d)
```

### Step 2: Update VERITAS Repository

```bash
cd ~/VERITAS
git pull origin main
```

### Step 3: Update CLAUDE.md

Replace your project's `CLAUDE.md` with the new version:

```bash
# From your project directory
cp ~/VERITAS/install/CLAUDE.md ./CLAUDE.md
```

**Key changes**:
- Article 1: Sequential thinking is now optional
- Article 2: Domain expert checked first, sequential thinking only if needed
- Article 4: NEW - Smart parallel/sequential execution rules
- Article 7: Updated for built-in JSONL logging
- Article 8: NEW - TodoWrite task management
- Article 9: Enforcement (formerly Article 8, updated)

### Step 4: Remove Hooks Directory

Hooks are no longer used:

```bash
# From your project directory
rm -rf .claude/hooks

# Optional: Keep for reference
# mv .claude/hooks .claude/hooks.deprecated
```

### Step 5: Add Slash Commands (Optional)

```bash
# Copy example slash commands
mkdir -p .claude/commands
cp ~/VERITAS/install/templates/commands/* .claude/commands/
```

Available commands:
- `/research-question` - Create research questions
- `/concept-note` - Create concept notes
- `/verify-citations` - Verify PMIDs
- `/daily-journal` - Generate journal entries

### Step 6: Update Domain Expert File

Your domain expert file should work as-is, but you may want to:

1. Remove any hook-related instructions
2. Add TodoWrite usage guidance if desired
3. Update journal workflow to reference JSONL transcripts instead of manual logging

### Step 7: Verify Installation

Start a new Claude Code conversation and test:

```
1. "What is your role according to CLAUDE.md?"
   - Should mention VERITAS constitutional rules

2. "Create a research question about [your topic]"
   - Should NOT automatically start with sequential thinking
   - Should use TodoWrite to track progress

3. "Search PubMed for papers on [topic]"
   - Should work with built-in PubMed MCP

4. "Generate a journal for today"
   - Should use claude-transcript-reader MCP
```

## Breaking Changes

### 1. No More Pre-Command Reminders

**Before**: Hooks displayed reminders before every command
**Now**: CLAUDE.md is automatically loaded by Claude Code
**Action**: No action needed - Claude Code handles this

### 2. No Post-Command Validation

**Before**: Scripts checked output after commands
**Now**: Constitutional rules enforced through output style
**Action**: Trust Claude Code to follow CLAUDE.md instructions

### 3. Manual Logging Removed

**Before**: `mcp__conversation-logger__log_conversation` tools
**Now**: Automatic JSONL logging by Claude Code
**Action**: Use `mcp__claude-transcript-reader__generate_journal` instead

### 4. Sequential Thinking Not Mandatory

**Before**: Article 1 required sequential thinking for all complex tasks
**Now**: Article 1 recommends thinking first, sequential thinking MCP only for very complex tasks
**Action**: Claude will use sequential thinking less frequently (this is good!)

## Troubleshooting

### Issue: "Hooks not running"
**Solution**: Hooks are deprecated. Remove them and rely on CLAUDE.md instructions.

### Issue: "Conversation logger not found"
**Solution**: Update to use `mcp__claude-transcript-reader__*` tools instead of conversation-logger.

### Issue: "Too many sequential thinking calls"
**Solution**: Update CLAUDE.md Article 1 to make sequential thinking optional.

### Issue: "Missing MCP servers in VS Code"
**Solution**: MCP servers are automatic in VS Code extension. For Desktop, check claude_desktop_config.json.

### Issue: "Citations not verified"
**Solution**: PMID verification now happens through PubMed MCP calls, not post-command hooks.

## Configuration Comparison

### Old Setup (Hook-Based)
```
YourProject/
├── CLAUDE.md
├── .claude/
│   ├── hooks/              # ❌ Deprecated
│   │   ├── pre-command.sh
│   │   ├── post-command.py
│   │   └── ...
│   ├── agents/
│   ├── templates/
│   └── scripts/
```

### New Setup (Claude Code Native)
```
YourProject/
├── CLAUDE.md
├── .claude/
│   ├── agents/             # ✓ Same
│   ├── templates/          # ✓ Same
│   ├── commands/           # ✓ NEW - Slash commands
│   └── scripts/            # ✓ Same (manual utilities)
```

## Benefits of Migration

1. **Simpler Setup** - No hook configuration needed
2. **Better Performance** - Claude Code native features are faster
3. **More Reliable** - Built-in systems vs custom scripts
4. **Better UX** - TodoWrite tracking, slash commands
5. **Smarter Execution** - Parallel when safe, sequential when needed
6. **Automatic Updates** - Claude Code improvements benefit VERITAS

## Rollback Procedure

If you need to rollback:

```bash
# Restore backup
cp CLAUDE.md.backup.YYYYMMDD CLAUDE.md
cp -r .claude.backup.YYYYMMDD .claude

# Revert VERITAS repo
cd ~/VERITAS
git checkout <previous-commit-hash>
```

## Support

- **Issues**: https://github.com/VMWM/VERITAS/issues
- **Discussions**: https://github.com/VMWM/VERITAS/discussions
- **Documentation**: https://github.com/VMWM/VERITAS/docs

## Migration Checklist

- [ ] Backup current CLAUDE.md and .claude directory
- [ ] Update VERITAS repository
- [ ] Replace CLAUDE.md with new version
- [ ] Remove or archive .claude/hooks directory
- [ ] Add slash commands (optional)
- [ ] Test basic workflows
- [ ] Test research question creation
- [ ] Test PubMed searches
- [ ] Test journal generation
- [ ] Verify TodoWrite tracking works
- [ ] Update domain expert if needed
- [ ] Remove old hook references from documentation

## Timeline

- **v1.0 (Original)**: Hook-based enforcement
- **v2.0 (Current)**: Claude Code native features
- **Deprecation**: Hooks no longer work in current Claude Code
- **Migration Deadline**: Migrate immediately - hooks are non-functional

---

**Questions?** Open an issue on GitHub or check the troubleshooting guide.
