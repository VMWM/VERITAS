# Obsidian REST API Setup Guide

## Getting Your API Token

1. **Open Obsidian**
   - Launch Obsidian with your HLA Antibodies vault

2. **Navigate to Settings**
   - Click the gear icon or press `Cmd + ,`
   - Go to "Community plugins"
   - Find "Local REST API" in your installed plugins

3. **Copy the API Token**
   - Click on the options icon next to "Local REST API"
   - You'll see your API Key displayed
   - Click the copy button to copy it

4. **Save the Token**
   ```bash
   # Create the token file
   echo 'YOUR_TOKEN_HERE' > ~/.obsidian_api_token
   
   # Verify it was saved
   cat ~/.obsidian_api_token
   ```

5. **Set Up Environment**
   ```bash
   # Source the setup script
   source /Users/vmwm/VERITAS/setup-env.sh
   
   # Verify the token is set
   echo $OBSIDIAN_API_TOKEN
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
- Port 27124: HLA Antibodies vault
- Port 27125: Research Journal vault
- Both should use the same API token

## Making Environment Variables Permanent

Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# VERITAS Environment
export CLAUDE_PROJECT_DIR="/Users/vmwm/Library/CloudStorage/Box-Box/VM_F31_2025"
[ -f ~/.obsidian_api_token ] && export OBSIDIAN_API_TOKEN=$(cat ~/.obsidian_api_token)
```

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```