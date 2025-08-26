# VERITAS Setup Checklist

Use this checklist to ensure successful VERITAS installation. Check off each item as you complete it.

## Pre-Installation

- [ ] **Node.js and npm installed** (v16+)
  ```bash
  node --version  # Should be v16 or higher
  npm --version
  ```

- [ ] **Claude Desktop installed**
- [ ] **Claude CLI installed** (optional but recommended)
  ```bash
  npm install -g @anthropic/claude-cli
  ```

- [ ] **Obsidian installed** with at least one vault created
- [ ] **Python 3.8+ installed**
  ```bash
  python3 --version
  ```

## Installation Steps

### 1. Clone and Setup

- [ ] **Clone VERITAS repository**
  ```bash
  git clone https://github.com/VMWM/VERITAS.git
  cd VERITAS
  ```

- [ ] **Run setup script**
  ```bash
  chmod +x setup.sh
  ./setup.sh
  ```

- [ ] **When prompted for project directory**: Enter YOUR project path (not VERITAS path)

- [ ] **When asked about cleanup**: Choose "y" for automatic 2 AM cleanup

- [ ] **Source environment file** ⚠️ CRITICAL - Often missed!
  ```bash
  source ~/.claude/env.sh  # Or wherever your project is
  ```

- [ ] **Add to shell profile** (for persistence)
  ```bash
  echo "source ~/your-project/.claude/env.sh" >> ~/.bashrc
  # or ~/.zshrc for zsh
  ```

### 2. Configure Claude

- [ ] **Run configuration script**
  ```bash
  ./scripts/configure-claude.sh
  ```
  - Choose option 1 (merge with existing)
  - Choose option 1 (separate config files)

- [ ] **Restart Claude Desktop completely**
  - Quit from menu/system tray
  - Reopen application

- [ ] **Import to CLI** (if using Claude CLI)
  ```bash
  claude mcp add-from-claude-desktop
  ```

- [ ] **Verify MCP servers loaded**
  ```bash
  # In CLI
  claude mcp list
  
  # In Desktop
  Type /mcp in a conversation
  ```

### 3. Configure Obsidian

- [ ] **Install Local REST API plugin**
  - Settings → Community Plugins → Browse
  - Search "Local REST API"
  - Install and Enable

- [ ] **Configure REST API** ⚠️ CRITICAL SETTINGS!
  - [ ] ✅ **Enable Encrypted (HTTPS) Server** - MUST BE ON
  - [ ] ❌ **Enable Non-encrypted (HTTP) Server** - MUST BE OFF
  - [ ] Set port to **27124** for main vault
  - [ ] Generate and save bearer token
  - [ ] For journal vault: Set port to **27125**

- [ ] **Create vault structure**
  - [ ] Main vault folders:
    - `Research Questions/`
    - `Concepts/`
  - [ ] Journal vault folder:
    - `Daily/`

- [ ] **Set environment variable**
  ```bash
  export OBSIDIAN_API_TOKEN="your-bearer-token-here"
  ```

- [ ] **Keep Obsidian running** while using Claude

## Verification

### Test Environment

- [ ] **Check environment variables**
  ```bash
  echo $CLAUDE_PROJECT_DIR  # Should show your project path
  echo $OBSIDIAN_VAULT_PATH  # Should show vault path or default
  echo $OBSIDIAN_API_TOKEN  # Should show your token
  ```

### Test MCP Servers

- [ ] **Test PubMed** (in Claude)
  ```
  Search PubMed for "HLA antibodies transplantation"
  ```

- [ ] **Test Memory** (in Claude)
  ```
  Create an entity for "HLA testing" with observations
  ```

- [ ] **Test Obsidian** (in Claude)
  ```
  Create a test concept note in my vault
  ```

### Test Conversation Logger

- [ ] **Check database exists**
  ```bash
  ls -la ~/.conversation-logger/
  ```

- [ ] **Test journal generation** (in Claude)
  ```
  Generate a journal entry for today
  ```

- [ ] **Verify SessionEnd hook** (check settings.local.json has SessionEnd section)

## Common Problems

If any step fails, check:

1. **[Setup Errors Guide](docs/user/SETUP_ERRORS.md)** - Installation problems
2. **[Troubleshooting Guide](docs/user/TROUBLESHOOTING.md)** - Runtime issues
3. **Run diagnostics**:
   ```bash
   # Check hooks are executable
   ls -la ~/.claude/hooks/*.py
   
   # Test Obsidian connection
   curl -k https://127.0.0.1:27124/vault/ \
     -H "Authorization: Bearer $OBSIDIAN_API_TOKEN"
   ```

## Final Confirmation

- [ ] Created a research question in Obsidian vault
- [ ] Citations include PMIDs
- [ ] Conversation was logged automatically
- [ ] Can generate journal from conversation

## Success! 🎉

If all items are checked, VERITAS is properly installed and configured.

### Next Steps
1. Customize `CLAUDE.md` for your specific project
2. Review templates in `templates/obsidian/`
3. Start your research with confidence!

### Need Help?
- Documentation: `/docs/README.md`
- Report issues: https://github.com/VMWM/VERITAS/issues