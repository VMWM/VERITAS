# Setup Checklist & Configuration Guide

## Required User-Specific Configurations

This checklist ensures your HLA Agent-MCP System is properly configured. Check each item as you complete it.

## Prerequisites Checklist

- [ ] **macOS** (required - system uses macOS-specific paths)
- [ ] **Node.js v18+** installed (`node -v` to verify)
- [ ] **VS Code** installed
- [ ] **Claude Code** installed via VS Code or npm
- [ ] **Obsidian** installed
- [ ] **Git** installed

## Account Requirements

### 1. Claude/Anthropic
- [ ] Create account at https://console.anthropic.com/
- [ ] Generate API key
- [ ] Save API key securely (you'll need it for config)

### 2. PubMed (Optional but Recommended)
- [ ] Register at https://www.ncbi.nlm.nih.gov/account/
- [ ] Get API key from Account Settings → API Key Management
- [ ] Note your registered email address

### 3. Cloud Storage
Choose one and ensure it's set up:
- [ ] iCloud Drive (built into macOS)
- [ ] Dropbox (installed and syncing)
- [ ] Box (installed with "Box-Box" folder in ~/Library/CloudStorage/)
- [ ] Google Drive (installed and syncing)
- [ ] OneDrive (installed and syncing)

## Installation Steps

### Step 1: Run Setup Script
```bash
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System
chmod +x setup.sh
./setup.sh
```

During setup, you'll be asked for:
1. **Cloud provider choice** (1-6)
2. **Obsidian location** (same as MCP or different)
3. Script will create all directories automatically

### Step 2: Configure Obsidian Vaults

#### For Research Vault (Port 27124):
- [ ] Open Obsidian
- [ ] Open vault at: `[Your Cloud]/Obsidian/HLA Antibodies` (or your renamed vault)
- [ ] Settings → Community Plugins → Browse
- [ ] Search "Local REST API" → Install → Enable
- [ ] Local REST API Settings:
  - [ ] Enable HTTPS
  - [ ] Port: 27124 (default)
  - [ ] Copy the API key → Save somewhere safe

#### For Journal Vault (Port 27125):
- [ ] Open second vault at: `[Your Cloud]/Obsidian/Research Journal`
- [ ] Install Local REST API plugin (same process)
- [ ] Local REST API Settings:
  - [ ] Enable HTTPS
  - [ ] **Change port to 27125** (IMPORTANT!)
  - [ ] Copy the API key → Save somewhere safe

### Step 3: Edit Configuration File

Location: `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json`
(Or your chosen cloud location from setup)

Replace these placeholders:

#### PubMed Configuration:
```json
"pubmed": {
  "env": {
    "PUBMED_EMAIL": "YOUR_EMAIL@university.edu",  // ← Your email
    "PUBMED_API_KEY": "YOUR_PUBMED_API_KEY_HERE"   // ← Optional but recommended
  }
}
```

#### Obsidian Research Vault:
```json
"obsidian-rest-hla": {
  "env": {
    "AUTH_BEARER": "YOUR_HLA_VAULT_API_KEY_HERE"   // ← From Step 2, port 27124
  }
}
```

#### Obsidian Journal Vault:
```json
"obsidian-rest-journal": {
  "env": {
    "AUTH_BEARER": "YOUR_JOURNAL_VAULT_API_KEY_HERE" // ← From Step 2, port 27125
  }
}
```

#### Filesystem Access:
```json
"filesystem-local": {
  "args": [
    "@modelcontextprotocol/server-filesystem",
    "~/Library/CloudStorage/Box-Box"  // ← Change to your cloud path if different
  ]
}
```

### Step 4: Create/Update CLAUDE.md

**For HLA Research (use as-is):**
- [ ] Copy included CLAUDE.md to your project folder

**For Other Research Domains:**
- [ ] Copy templates/AGENT_TEMPLATE.md to your project as CLAUDE.md
- [ ] Edit the following sections:
  - Professional Identity (your field)
  - Core Expertise (your specialties)
  - Knowledge Base paths (your document locations)
  - Technical Knowledge (domain-specific info)
  - Research Focus (your hypothesis/aims)

### Step 5: Customize Vault Names (Optional)

If you renamed the vault folders:
1. [ ] Update vault paths in your local CLAUDE.md
2. [ ] Keep REST API ports (27124, 27125) unchanged
3. [ ] Ensure folder structure matches:
   ```
   YourResearchVault/
   ├── Concepts/
   └── Research Questions/
   
   Research Journal/
   ├── Daily/
   └── Projects/
   ```

## Validation Checklist

### Test Each Component:

#### 1. Claude Code
```bash
claude --version
```
- [ ] Shows version number

#### 2. MCP Servers
```bash
npm list -g | grep "@modelcontextprotocol\|@nova-mcp\|@ncukondo\|dkmaker"
```
- [ ] Shows all installed servers

#### 3. Configuration File
```bash
cat ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json | grep "YOUR_"
```
- [ ] Should return nothing (all placeholders replaced)

#### 4. Obsidian Connection
- [ ] Both vaults open in Obsidian
- [ ] Local REST API enabled in both
- [ ] Different ports (27124 and 27125)
- [ ] HTTPS enabled
- [ ] API keys saved

#### 5. Test in Claude Code
```bash
cd /path/to/your/project
claude
```
Then try:
- [ ] `/mcp` - Should show all connected servers
- [ ] Ask Claude to create a test note in Obsidian
- [ ] Ask Claude to search PubMed for a topic

## Common Issues & Solutions

### "Failed to connect to server"
- Check API keys are correct
- Ensure Obsidian is running
- Verify Local REST API is enabled
- Check ports (27124 for research, 27125 for journal)

### "Permission denied"
- Run `chmod +x setup.sh` before running script
- Check cloud storage permissions

### "Directory not found"
- Ensure cloud storage is set up and syncing
- Check the path in config matches actual location

### PubMed not working
- Email is required (API key optional)
- Check for typos in email address
- If using API key, verify it's valid

## File Paths Reference

After setup, your structure should look like:

```
~/Library/Mobile Documents/com~apple~CloudDocs/  (or your cloud)
├── MCP-Shared/
│   ├── claude-desktop-config.json   ← Your config file
│   ├── nova-memory/                 ← Memory storage
│   ├── agents/                      ← Custom agents
│   └── HLA_Agent-MCP_System/        ← This repo (optional)
│
└── Obsidian/                        (or your chosen location)
    ├── HLA Antibodies/               ← Research vault (rename for your field)
    │   ├── Concepts/
    │   └── Research Questions/
    └── Research Journal/             ← Daily notes vault
        ├── Daily/
        └── Projects/
```

## Final Verification

Run this command to test everything:
```bash
cd /path/to/your/project
claude
```

Then in Claude:
1. Type `/mcp` - Should list all servers
2. Try: "Create a test concept note about [your topic]"
3. Try: "Search PubMed for recent papers on [your topic]"
4. Check Obsidian - notes should appear

If all tests pass, your system is ready! 🎉

## Need Help?

- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Review [README.md](../README.md) for examples
- Open an issue on GitHub with:
  - Your OS version
  - Error messages
  - Which step failed