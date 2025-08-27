# Obsidian REST API Setup Guide

## Two-Vault Configuration

VERITAS uses two separate Obsidian vaults, each with its own REST API token:
- **HLA Antibodies vault** (port 27124) - Main research vault
- **Research Journal vault** (port 27125) - Daily journal entries

## Getting Your API Tokens

### For HLA Antibodies Vault (Port 27124)

1. **Open Obsidian HLA Antibodies Vault**
   - Launch Obsidian and open your HLA Antibodies vault

2. **Get the Token**
   - Settings → Community Plugins → Local REST API
   - Click the options icon next to "Local REST API"
   - Copy the API Key displayed

3. **Save the HLA Token**
   ```bash
   echo 'YOUR_HLA_TOKEN_HERE' > ~/.obsidian_api_token_hla
   ```

### For Research Journal Vault (Port 27125)

1. **Open Obsidian Research Journal Vault**
   - Open your Research Journal vault in Obsidian

2. **Get the Token**
   - Settings → Community Plugins → Local REST API
   - Click the options icon next to "Local REST API"
   - Copy the API Key displayed

3. **Save the Journal Token**
   ```bash
   echo 'YOUR_JOURNAL_TOKEN_HERE' > ~/.obsidian_api_token_journal
   ```

## Set Up Environment

After saving both tokens:

```bash
# Tokens are automatically loaded from Claude's MCP server configuration
# No manual environment setup needed

# Verify the tokens are set
echo "HLA Token: $OBSIDIAN_API_TOKEN_HLA"
echo "Journal Token: $OBSIDIAN_API_TOKEN_JOURNAL"
```

## Testing the Connection

After setting up, run the test:

```bash
cd /Users/vmwm/VERITAS/tests
./veritas-test.sh
```

The Obsidian tests should now pass showing:
- "Obsidian REST API (main vault) responding and authenticated"
- "Obsidian REST API (journal vault) responding and authenticated"

## Troubleshooting

### API Not Responding
- Ensure Obsidian is running
- Check that Local REST API plugin is enabled
- Verify ports 27124 and 27125 are not blocked

### Authentication Failed
- Token may have changed - get a new one from Obsidian settings
- Check token file permissions: `ls -la ~/.obsidian_api_token`
- Ensure no extra spaces or newlines in token file

### Different Vaults on Different Ports
- Port 27124: HLA Antibodies vault (uses OBSIDIAN_API_TOKEN_HLA)
- Port 27125: Research Journal vault (uses OBSIDIAN_API_TOKEN_JOURNAL)
- Each vault has its own unique token for security

## Making Environment Variables Permanent

Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# VERITAS Environment
export CLAUDE_PROJECT_DIR="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
[ -f ~/.obsidian_api_token_hla ] && export OBSIDIAN_API_TOKEN_HLA=$(cat ~/.obsidian_api_token_hla)
[ -f ~/.obsidian_api_token_journal ] && export OBSIDIAN_API_TOKEN_JOURNAL=$(cat ~/.obsidian_api_token_journal)
[ -n "$OBSIDIAN_API_TOKEN_HLA" ] && export OBSIDIAN_API_TOKEN="$OBSIDIAN_API_TOKEN_HLA"
```

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```