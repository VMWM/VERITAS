# Complete Setup Guide

## Quick Start (5 minutes)

### 1. Install Everything
```bash
# Clone repository
git clone https://github.com/VMWM/HLA_Agent-MCP_System.git
cd HLA_Agent-MCP_System

# Run setup script
chmod +x setup.sh
./setup.sh

# Install PubMed MCP (if not installed by setup)
npm install -g @ncukondo/pubmed-mcp
```

### 2. Configure API Keys

Edit your config file (location shown by setup script):
- **iCloud**: `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json`
- **Box**: `~/Library/CloudStorage/Box-Box/MCP-Shared/claude-desktop-config.json`
- **Dropbox**: `~/Dropbox/MCP-Shared/claude-desktop-config.json`

Add your keys:

```json
{
  "claude": {
    "apiKey": "sk-ant-YOUR-KEY"  // Required - from console.anthropic.com
  },
  "mcpServers": {
    "pubmed": {
      "command": "npx",
      "args": ["@ncukondo/pubmed-mcp"],
      "env": {
        "PUBMED_EMAIL": "your.email@edu",     // Required
        "PUBMED_API_KEY": "your-key"          // Optional (higher rate limits)
      }
    },
    "obsidian-rest-hla": {
      "env": {
        "AUTH_BEARER": "your-obsidian-api-key"  // Required - from Obsidian plugin
      }
    }
  }
}
```

### 3. Configure PubMed via CLI (Alternative)
```bash
claude mcp add-json pubmed '{
  "command": "npx",
  "args": ["@ncukondo/pubmed-mcp"],
  "env": {
    "PUBMED_EMAIL": "your.email@edu",
    "PUBMED_API_KEY": "optional-key"
  }
}'
```

### 4. Test Everything
```bash
claude
/mcp  # Should show all servers connected
```

---

## API Keys Explained

### Required Keys

#### Claude API Key
- **Get it**: https://console.anthropic.com/ → API Keys → Create Key
- **Cost**: ~$20/month for heavy use
- **Format**: `sk-ant-api...`
- **Add to**: VS Code settings or environment variable

#### Obsidian REST API Key
- **Get it**: Obsidian → Settings → Community Plugins → Local REST API → Generate Key
- **Cost**: Free
- **Note**: Add to AUTH_BEARER field in config
- **Important**: Obsidian must be running

#### PubMed Email
- **Required**: NCBI requires email for API access
- **Format**: Any valid email address
- **Purpose**: Rate limiting and usage tracking

### Optional Keys

#### PubMed API Key
- **Get it**: https://www.ncbi.nlm.nih.gov/account/ → API Key Management
- **Benefits**: 10 requests/sec (vs 3 without)
- **Cost**: Free
- **Recommended for**: Heavy research use

---

## Dual Vault Setup (for HLA Research)

If using the HLA Research Agent with two Obsidian vaults:

### Vault 1: HLA Antibodies (Port 27124)
```json
"obsidian-rest-hla": {
  "command": "npx",
  "args": ["dkmaker-mcp-rest-api@latest"],
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27124",
    "AUTH_BEARER": "your-hla-vault-api-key",
    "REST_ENABLE_SSL_VERIFY": "false",
    "NODE_TLS_REJECT_UNAUTHORIZED": "0"
  }
}
```

### Vault 2: Research Journal (Port 27125)
```json
"obsidian-rest-journal": {
  "command": "npx",
  "args": ["dkmaker-mcp-rest-api@latest"],
  "env": {
    "REST_BASE_URL": "https://127.0.0.1:27125",
    "AUTH_BEARER": "your-journal-vault-api-key",
    "REST_ENABLE_SSL_VERIFY": "false",
    "NODE_TLS_REJECT_UNAUTHORIZED": "0"
  }
}
```

**Setup in Obsidian**:
1. Install Local REST API plugin in BOTH vaults
2. Set different ports (27124 and 27125)
3. Generate separate API keys for each
4. Enable HTTPS in both

---

## Troubleshooting

### PubMed Not Connecting
```bash
# Check installation
which pubmed-mcp

# Reinstall if needed
npm install -g @ncukondo/pubmed-mcp

# Configure with CLI
claude mcp remove pubmed
claude mcp add-json pubmed '{"command":"npx","args":["@ncukondo/pubmed-mcp"],"env":{"PUBMED_EMAIL":"your@email.edu"}}'
```

### Common Errors

| Error | Solution |
|-------|----------|
| "PUBMED_EMAIL required" | Add email to config |
| "Failed to connect" | Run `npm install -g @ncukondo/pubmed-mcp` |
| "401 Unauthorized" (Obsidian) | Regenerate API key in plugin |
| "Rate limit exceeded" | Add PubMed API key |

### Quick Fixes
```bash
# Restart Claude
claude restart

# Check all servers
claude mcp list

# Test PubMed
/agent Search PubMed for kidney transplant 2024

# Test Obsidian
/agent Create test note in Concepts folder
```

---

## File Paths (Optional Configuration)

If you need to customize paths for your research:

### Common Cloud Locations
- **iCloud**: `~/Library/Mobile Documents/com~apple~CloudDocs/`
- **Box**: `~/Library/CloudStorage/Box-Box/`
- **Dropbox**: `~/Dropbox/`
- **OneDrive**: `~/Library/CloudStorage/OneDrive-*/`

### Filesystem MCP Configuration
```json
"filesystem-local": {
  "command": "npx",
  "args": [
    "@modelcontextprotocol/server-filesystem",
    "~/Your/Research/Folder"  // Change this to your folder
  ]
}
```

---

## Security Notes

**DO NOT**:
- Commit API keys to Git
- Share config files with keys
- Post keys in GitHub issues

**DO**:
- Use template files for sharing
- Keep actual config local or in private cloud
- Regenerate keys if exposed

---

## Need Help?

1. Check `/mcp` to see server status
2. See [Troubleshooting Guide](TROUBLESHOOTING.md) for detailed fixes
3. Create GitHub issue (without keys!)
4. Join MCP Discord community

---

*Last updated: 2025-01-20*