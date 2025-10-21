---
description: Generate daily journal entry from conversation transcripts and memory
---

Generate a daily journal entry:

1. Ask me for the date if not specified (default: today)
2. Use `mcp__claude-transcript-reader__generate_journal` to get session data from JSONL transcripts
3. Use `mcp__memory__search_nodes` to find relevant research entities created/modified today
4. Read `.claude/agents/hla-research-director.md` for the daily journal template
5. Combine transcript data and memory entities into a structured journal entry with:
   - Daily Research Log
   - Session Summary
   - Technical Implementations
   - Research Insights
   - Decisions & Rationale
   - Problems Solved
   - Session Metrics (table)
   - Next Actions
   - References (files created, papers reviewed with PMIDs)
   - Navigation (Previous/Next day wiki links)
6. Create the journal entry in Obsidian vault at Research Journal/Daily/YYYY-MM-DD.md

For multi-day journals, specify date range and I'll create individual entries for each day.

Note: This uses Claude Code's built-in JSONL logging, not manual conversation logging.
