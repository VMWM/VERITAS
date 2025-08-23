# Setup Checklist

Complete checklist for setting up the Research Agent-MCP System.

## Prerequisites

### System Requirements
- [ ] **Operating System**: macOS, Linux, or Windows with WSL
- [ ] **Node.js**: v16 or higher (`node -v` to verify)
- [ ] **npm**: Latest version (`npm -v` to verify)
- [ ] **Python**: 3.8+ (`python3 --version` to verify)
- [ ] **Git**: Installed (`git --version` to verify)

### Required Software
- [ ] **Claude Desktop**: Downloaded and installed
- [ ] **Obsidian**: Downloaded and installed
- [ ] **Text Editor**: VS Code recommended

## Installation Checklist

### Step 1: Clone Repository
- [ ] Clone from GitHub:
  ```bash
  git clone https://github.com/[username]/Research_Agent-MCP_System.git
  cd Research_Agent-MCP_System
  ```

### Step 2: Run Setup Script
- [ ] Make script executable: `chmod +x setup.sh`
- [ ] Run setup: `./setup.sh`
- [ ] Note your project directory path
- [ ] Note Obsidian port numbers

### Step 3: Install MCP Servers
Verify each installation:
- [ ] **Sequential Thinking**: `npx @modelcontextprotocol/install sequentialthinking`
- [ ] **PubMed**: `npx @modelcontextprotocol/install pubmed`
- [ ] **Memory**: `npx @modelcontextprotocol/install memory`
- [ ] **Filesystem**: `npx @modelcontextprotocol/install filesystem`

### Step 4: Configure Obsidian
- [ ] Install Obsidian Local REST API plugin:
  - Open Obsidian Settings
  - Community Plugins → Browse
  - Search "Local REST API"
  - Install and Enable
- [ ] Configure REST API:
  - [ ] Set port for primary vault (default: 27124)
  - [ ] Set port for journal vault (default: 27125)
  - [ ] Generate bearer token
  - [ ] Save token securely

### Step 5: Create Vault Structure
- [ ] Create primary vault with folders:
  ```
  Your Vault/
  ├── Research Questions/
  ├── Concepts/
  └── Literature/
  ```
- [ ] Create journal vault (optional):
  ```
  Research Journal/
  └── Daily/
  ```

### Step 6: Configure Claude Desktop
- [ ] Locate config file:
  - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
  - Linux: `~/.config/Claude/claude_desktop_config.json`
  - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- [ ] Add MCP server configurations:
  ```json
  {
    "mcpServers": {
      "sequential-thinking": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-sequentialthinking"]
      },
      "pubmed": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-pubmed"]
      },
      "memory": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-memory"]
      },
      "filesystem-local": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-filesystem", "/path/to/project"]
      },
      "obsidian-rest-primary": {
        "command": "npx",
        "args": ["@modelcontextprotocol/server-rest",
                 "--base-url", "http://127.0.0.1:27124",
                 "--auth-type", "bearer",
                 "--auth-token", "YOUR_TOKEN"]
      }
    }
  }
  ```
- [ ] Replace `/path/to/project` with your project directory
- [ ] Replace `YOUR_TOKEN` with Obsidian bearer token
- [ ] Save configuration file

### Step 7: Project Configuration
- [ ] Update CLAUDE.md:
  - [ ] Add project description
  - [ ] Set timeline
  - [ ] Verify directory paths
- [ ] Check hook permissions:
  ```bash
  chmod +x .claude/hooks/*.sh
  chmod +x .claude/hooks/*.py
  chmod +x .claude/scripts/*.py
  ```
- [ ] Create logs directory:
  ```bash
  mkdir -p .claude/logs
  ```

### Step 8: Restart and Test
- [ ] Restart Claude Desktop
- [ ] Open new conversation
- [ ] Test each MCP:
  - [ ] Sequential thinking: "Plan a research task"
  - [ ] PubMed: "Find papers about [topic]"
  - [ ] Memory: "Remember this concept: [concept]"
  - [ ] Filesystem: "Read CLAUDE.md"
  - [ ] Obsidian: "Create a test research question"

## Verification Tests

### Hook System
- [ ] Pre-command hook shows reminders
- [ ] Task router detects Obsidian tasks
- [ ] Compliance validator blocks wrong tools
- [ ] Post-command validator checks output

Test command:
```bash
bash .claude/hooks/pre-command.sh
```

### Obsidian Integration
- [ ] Creates files in correct folders
- [ ] Uses proper templates
- [ ] Wiki links formatted correctly
- [ ] Tables display properly

Test command:
```
"Create a research question about [topic] in my vault"
```

### Citation System
- [ ] Citations include proper format
- [ ] Verification levels added
- [ ] PubMed searches work
- [ ] References formatted correctly

## Troubleshooting Quick Checks

If something isn't working:

### MCP Not Responding
- [ ] Claude Desktop restarted?
- [ ] Config file saved?
- [ ] Paths absolute, not relative?
- [ ] Tokens/ports correct?

### Obsidian Issues
- [ ] REST API plugin enabled?
- [ ] Port not blocked by firewall?
- [ ] Bearer token matches config?
- [ ] Vault folders exist?

### Hook Problems
- [ ] Files executable?
- [ ] Python 3 installed?
- [ ] Paths in settings.local.json correct?

## Final Validation

Complete setup is verified when:
- [ ] All MCPs respond to commands
- [ ] Obsidian integration creates proper files
- [ ] Hooks display and enforce rules
- [ ] Citations are validated
- [ ] Templates are followed

## Support

If issues persist after checklist:
1. Check `docs/TROUBLESHOOTING.md`
2. Review error logs in `.claude/logs/`
3. Submit GitHub issue with details

## Success!

When all items checked:
- System is fully operational
- Begin creating research content
- Customize for your domain (see CUSTOMIZATION.md)