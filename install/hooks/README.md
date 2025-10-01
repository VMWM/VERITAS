# Universal VERITAS Hooks

These hooks enforce the VERITAS constitution across all projects.

## Active Hooks (8 hooks + 1 config)

### pre-compact.py

- **Purpose**: Auto-logs conversation before compaction
- **When**: Triggered when Claude Code is about to compact the conversation
- **Function**: Captures full conversation context before summarization
- **Note**: Creates systemMessage hint for Claude to log via conversation-logger MCP

### auto-conversation-logger.py

- **Purpose**: Logs conversations to conversation-logger MCP (requires explicit invocation)
- **When**: After each message exchange (if manually triggered)
- **Function**: Maintains conversation history in SQLite database
- **Note**: Hook exists but cannot auto-invoke MCP tools; use pre-compact.py for automatic logging

### pre-command.sh

- **Purpose**: Pre-execution validation and context injection
- **When**: Before any command/tool use
- **Function**:
  - Loads CLAUDE.md requirements
  - Injects grant context
  - Enforces tool priority order
  - Checks for required citations

### post-command.sh

- **Purpose**: Post-execution verification (bash)
- **When**: After command completion
- **Function**:
  - Checks file extensions
  - Validates table formatting
  - Ensures Obsidian compliance

### post-command.py

- **Purpose**: Post-execution verification (python)
- **When**: After command completion
- **Function**:
  - Verifies PMID citations
  - Checks verification levels
  - Validates unsupported claims
  - More comprehensive than bash version

### task-router.py

- **Purpose**: Routes tasks to appropriate handlers
- **When**: Called by other hooks
- **Function**: Analyzes user input and determines task type
- **Required by**: Other hooks import this module

### enforce-claude-md.py

- **Purpose**: Additional CLAUDE.md enforcement
- **When**: Called by pre-command.sh
- **Function**: Python-based enforcement checks
- **Required by**: Referenced in hook chain

### obsidian-enforcer.py

- **Purpose**: Enforces Obsidian formatting and structure rules
- **When**: Called during Obsidian operations
- **Function**:
  - Ensures proper file extensions (.md)
  - Validates table formatting
  - Enforces wiki link conventions
  - Checks header formatting

## Hook Behavior

All hooks work by:

1. Reading CLAUDE.md from the project root (`../CLAUDE.md` relative to hooks)
2. Injecting requirements into Claude's context
3. Monitoring compliance
4. Logging violations to `.claude/logs/`

## Updating Hooks

To update hooks across all projects:

1. Edit the hook in this directory
2. For each project, run: `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/scripts/link-to-project.sh`
3. Choose to overwrite existing hooks when prompted

## Important Notes

- Hooks are COPIED to projects, not symlinked (to preserve relative paths)
- Each hook must be executable (`chmod +x`)
- Hooks assume CLAUDE.md exists in project root
- Violations are logged but don't block execution
- DO NOT DELETE task-router.py or enforce-claude-md.py (required dependencies)

---

Last Updated: 2025-08-27
Tested: Both compliance-validator.sh and first-response.py confirmed redundant
