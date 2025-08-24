# Quick Start Guide - 5 Minutes to VERITAS

Get VERITAS running in 5 minutes with this streamlined setup guide.

## Prerequisites Check (30 seconds)

Ensure you have:
- ✅ Claude Desktop or Claude Code CLI
- ✅ Node.js 16+ (`node --version`)
- ✅ Git (`git --version`)
- ✅ Obsidian (optional, for note-taking features)

## Step 1: Clone & Install (2 minutes)

```bash
# Clone the repository
git clone https://github.com/VMWM/VERITAS.git
cd VERITAS

# Run automated setup
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Install all MCP servers automatically
- Copy necessary configuration files
- Set up the conversation logger

## Step 2: Configure Claude (2 minutes)

```bash
# Run the configuration wizard
./scripts/configure-claude.sh
```

When prompted:
1. Choose **option 1** to merge with existing configs (or 2 for fresh install)
2. Choose **option 1** for separate configs (recommended for beginners)
3. Enter your project directory path
4. Skip Obsidian settings if not using (just press Enter)

## Step 3: Restart Claude (30 seconds)

- **Claude Desktop**: Quit completely and reopen
- **Claude CLI**: Run `claude restart`

## Step 4: Verify Installation (30 seconds)

Start a new Claude session and type:
```
/mcp
```

You should see these servers:
- ✅ sequential-thinking
- ✅ pubmed
- ✅ memory
- ✅ filesystem-local
- ✅ conversation-logger

## 🎉 You're Done!

### Test Your Setup

Try these commands to verify everything works:

```
"Use sequential thinking to plan a research task"
"Search PubMed for papers on HLA antibodies"
"Store a concept about testing in memory"
```

## Optional: Obsidian Integration

If you want to use Obsidian for research notes:

1. Install Obsidian Local REST API plugin
2. Generate an API key in plugin settings
3. Re-run `./scripts/configure-claude.sh` with your API key
4. Create these folders in your vault:
   - `Research Questions/`
   - `Concepts/`
   - `Daily/`

## Next Steps

- **Full documentation**: See [INSTALLATION.md](INSTALLATION.md) for detailed setup
- **Multiple machines**: See [MULTI_MACHINE.md](MULTI_MACHINE.md) for sync setup
- **Customization**: See [../developer/CUSTOMIZATION.md](../developer/CUSTOMIZATION.md)
- **Troubleshooting**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Common Issues

**MCP servers not showing?**
- Restart Claude completely (not just the window)
- Check JSON syntax in config file

**PubMed not working?**
- Run: `npm install -g @cyanheads/pubmed-mcp-server`

**Need help?**
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Open an issue on [GitHub](https://github.com/VMWM/VERITAS/issues)