# Setting Up GitHub Copilot as an HLA Research Agent

## Overview

While GitHub Copilot doesn't have a built-in `/agent` command like Claude Code, you can configure it to behave as an autonomous research agent using custom instructions.

## Setup Instructions

### 1. Configure Custom Instructions

1. Open VS Code Settings (Cmd+,)
2. Search for "GitHub Copilot"
3. Find "GitHub Copilot: Instructions" setting
4. Click "Edit in settings.json"
5. Add the instructions from `config/github-copilot-instructions.md`

**Alternative method:**
```bash
# Copy the instructions to your clipboard
cat config/github-copilot-instructions.md | pbcopy

# Then paste into the GitHub Copilot instructions field in VS Code settings
```

### 2. Settings Configuration

In VS Code settings.json, add:

```json
{
  "github.copilot.instructions": [
    {
      "text": "# Paste the contents of github-copilot-instructions.md here"
    }
  ],
  "github.copilot.chat.localeOverride": "en",
  "github.copilot.chat.welcomeMessage": "HLA Research Agent ready. I'll execute multi-step workflows automatically.",
  "github.copilot.advanced": {
    "inlineSuggestCount": 3,
    "listCount": 10
  }
}
```

### 3. Testing the Agent Behavior

After setup, test with these prompts:

```
@github What causes prozone effect in SAB testing?
```

GitHub Copilot should automatically:
- Search PubMed
- Verify PMIDs
- Create research question note
- Create concept pages
- Provide summary

```
@github Create today's research journal entry
```

Should automatically:
- Retrieve template from Memory MCP
- Create formatted daily entry
- Save to correct location

## Key Differences from Claude Code

| Feature | Claude Code | GitHub Copilot with Instructions |
|---------|------------|----------------------------------|
| Trigger | `/agent "query"` | `@github query` |
| Automation | Built-in agent system | Instructions-driven |
| Consistency | Always follows agent spec | Depends on model interpretation |
| Complex workflows | Native support | Instruction-guided |

## Tips for Best Results

1. **Be explicit initially**: First few queries might need more specific language until Copilot learns your patterns

2. **Reference the behavior**: Remind Copilot it should act as an agent:
   ```
   @github As an HLA Research Agent, analyze recent papers on dnDSA
   ```

3. **Use workflow keywords**: These trigger agent behavior:
   - "Research": Triggers full workflow
   - "Create": Triggers note creation
   - "Analyze": Triggers Sequential Thinking
   - "Find papers": Triggers PubMed search

4. **Batch operations**: Copilot handles these well:
   ```
   @github Research prozone effect, create all relevant concept pages, and document findings
   ```

## Customizing Agent Behavior

Edit `config/github-copilot-instructions.md` to:
- Add new workflow patterns
- Modify file paths
- Change template behaviors
- Add domain-specific rules

## Troubleshooting

### Agent behavior not working?

1. Verify instructions are loaded:
   ```
   @github What are your instructions for HLA research?
   ```

2. Check MCP servers are connected:
   ```
   @github List available MCP servers
   ```

3. Restart VS Code after changing instructions

### Partial execution only?

- Add "Execute the complete workflow" to your prompt
- Reference specific steps you want completed
- Use the Sequential Thinking MCP explicitly

## Advanced Configuration

### Creating Slash Commands (Future)

GitHub Copilot may add custom slash commands. When available, you could create:
- `/hla-agent`: Execute HLA research workflow
- `/daily-entry`: Create journal entry
- `/concept`: Create concept page

### Workspace-Specific Instructions

For project-specific behavior, create `.github/copilot-instructions.md` in your workspace root.

## Example Workflows

### Literature Review
```
@github Conduct a literature review on complement interference in Luminex assays. Create comprehensive notes with all findings.
```

### Daily Documentation
```
@github Create today's journal entry summarizing work on HAML implementation, including challenges with MFI threshold validation.
```

### Concept Mapping
```
@github Map the relationship between prozone effect, C1q interference, and EDTA treatment. Create interconnected concept pages.
```

---

*With these instructions, GitHub Copilot becomes a functional equivalent to Claude Code's agent system, executing multi-step research workflows automatically.*