# VERITAS Slash Commands

This directory contains example slash commands that provide quick access to common VERITAS workflows.

## Available Commands

### `/research-question`
Create a new research question with PubMed citations and grant-ready formatting.

**Usage**: `/research-question [optional topic]`

**Example**:
```
/research-question machine learning in transplant matching
```

### `/concept-note`
Create a structured concept note with technical details and validation data.

**Usage**: `/concept-note [optional concept name]`

**Example**:
```
/concept-note Epitope Analysis
```

### `/verify-citations`
Verify all PMIDs in markdown files using PubMed MCP.

**Usage**: `/verify-citations [optional file path]`

**Example**:
```
/verify-citations
# Checks all .md files in current directory

/verify-citations docs/research-question.md
# Checks specific file
```

### `/daily-journal`
Generate daily journal entry from conversation transcripts and memory.

**Usage**: `/daily-journal [optional date]`

**Example**:
```
/daily-journal
# Creates journal for today

/daily-journal 2024-10-20
# Creates journal for specific date
```

## Installation

To use these slash commands in your project:

1. Copy this `commands/` directory to your project's `.claude/` folder:
   ```bash
   cp -r ~/VERITAS/install/templates/commands ~/.claude/
   ```

2. Restart your Claude Code session

3. Type `/` in your conversation to see available commands

## Customization

You can create your own slash commands by:

1. Creating a new `.md` file in `.claude/commands/`
2. Adding a `description` in the frontmatter:
   ```markdown
   ---
   description: What your command does
   ---

   Detailed instructions for Claude...
   ```

3. Saving the file and restarting Claude Code

## Notes

- Slash commands are optional - you can use VERITAS without them
- Commands simply provide structured prompts - Claude still reads CLAUDE.md and domain expert files
- You can modify these templates to match your specific workflow
