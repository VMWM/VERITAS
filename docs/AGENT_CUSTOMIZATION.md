# Creating Custom Agents

The Claude Code agent system allows you to create specialized "personalities" for different tasks and domains.

## What is an Agent?

An agent is a configuration file (`CLAUDE.md`) that tells Claude:
- What role to assume
- Which tools to prioritize
- Domain-specific knowledge
- Behavioral rules and constraints
- Output formatting preferences

## Quick Start

1. **Copy the template:**
   ```bash
   cp templates/AGENT_TEMPLATE.md ~/my-project/CLAUDE.md
   ```

2. **Customize for your domain**

3. **Use with `/agent` command:**
   ```
   /agent [your prompt]
   ```

## Agent Template Structure

### Essential Sections

**Agent Role & Identity**
- Define the specialization
- Set primary goals
- Establish expertise level

**MCP Server Usage**
- Specify which servers to use
- Define priority order
- Set usage triggers

**Core Knowledge Base**
- Domain-specific facts
- Key references
- Important thresholds

**Behavioral Rules**
- Always/Never lists
- Quality checks
- Verification steps

## Example Agents

### Research Agent (HLA-Research-Agent)
- Dual vault support
- PubMed integration
- Sequential thinking for complex questions
- Knowledge graph maintenance

### Clinical Trial Agent (Example)
```markdown
## Agent Role
Clinical trial protocol specialist with focus on FDA compliance

## Core Knowledge
- 21 CFR Part 312 (IND regulations)
- ICH-GCP guidelines
- Protocol amendment procedures
```

### Lab Protocol Agent (Example)
```markdown
## Agent Role
Laboratory procedure documentation specialist

## Behavioral Rules
### Always:
- Include safety warnings
- List required PPE
- Specify reagent catalog numbers
- Version control changes
```

## Best Practices

1. **Keep agents focused** - One domain per agent
2. **Include quality checks** - Verification steps
3. **Document tool usage** - Clear MCP server priorities
4. **Version your agents** - Track changes over time
5. **Test thoroughly** - Verify before sharing

## Managing Multiple Agents

Create an agents library:
```
~/agents/
├── Research-Agent.md
├── Grant-Writing-Agent.md
├── Protocol-Agent.md
└── Analysis-Agent.md
```

Copy the appropriate agent to your project as `CLAUDE.md`:
```bash
cp ~/agents/Grant-Writing-Agent.md ./CLAUDE.md
```

## Sharing Agents

Agents are portable - share the `.md` file with colleagues for consistent behavior across teams.

## Advanced Features

### Conditional Behavior
```markdown
### For complex questions (>3 variables):
- Use sequential thinking
- Break into sub-problems
- Verify each step
```

### Tool Coordination
```markdown
1. sequential-thinking → Plan approach
2. memory → Check existing knowledge
3. pubmed → Verify claims
4. obsidian → Document findings
```

### Quality Gates
```markdown
Before completing task:
- [ ] All claims verified
- [ ] Sources cited
- [ ] Output formatted correctly
```

## Troubleshooting

**Agent not loading?**
- Ensure file is named `CLAUDE.md`
- Check file is in current directory
- Verify markdown syntax

**Wrong behavior?**
- Review MCP server configuration
- Check behavioral rules section
- Verify tool priorities

**Need help?**
- Use the template as starting point
- Copy existing agents and modify
- Test incrementally

---
*See `templates/AGENT_TEMPLATE.md` for complete template*
*See `templates/CLAUDE.md` for HLA Research Agent example*