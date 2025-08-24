# Repository Renaming Instructions

This document provides instructions for renaming the repository from `HLA_Agent-MCP_System` to `claude-research-framework`.

## GitHub Repository Rename

### Step 1: Rename on GitHub

1. Go to https://github.com/VMWM/HLA_Agent-MCP_System
2. Click on "Settings" tab
3. Under "General" settings, find "Repository name"
4. Change from `HLA_Agent-MCP_System` to `claude-research-framework`
5. Click "Rename"

GitHub will automatically:
- Redirect the old URL to the new one
- Update all existing links
- Preserve all issues, PRs, and stars

### Step 2: Update Local Repository

After renaming on GitHub, update your local clone:

```bash
# Navigate to your local repository
cd "/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/HLA_Agent-MCP_System"

# Update the remote URL
git remote set-url origin https://github.com/VMWM/claude-research-framework.git

# Verify the change
git remote -v
```

### Step 3: Rename Local Directory (Optional)

If you want to rename the local directory to match:

```bash
# Move to parent directory
cd "/Users/vmwm/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"

# Rename the directory
mv HLA_Agent-MCP_System claude-research-framework

# Enter the renamed directory
cd claude-research-framework
```

### Step 4: Update Configuration Files

Update any references in your configuration files:

1. **Claude MCP Configuration** (`~/.claude.json`):
   - Update the path for conversation-logger if using absolute paths

2. **Shell Configuration** (`.zshrc` or `.bashrc`):
   - Update any aliases or PATH additions

3. **Documentation**:
   - Internal documentation will be updated automatically via git

## Verification

After renaming, verify everything works:

```bash
# Test git operations
git fetch
git status

# Test the conversation logger MCP
claude mcp list | grep conversation-logger

# Run the setup script to ensure all paths are correct
./setup.sh
```

## Notes

- GitHub's automatic redirects will handle old links for a while
- Update any bookmarks to use the new URL
- The system name is now **VERITAS** but the repository uses a descriptive name
- All functionality remains the same, only the name changes

## New Repository URL

After renaming:
- **Old**: https://github.com/VMWM/HLA_Agent-MCP_System
- **New**: https://github.com/VMWM/claude-research-framework

The old URL will redirect automatically, but it's best to update references to use the new URL.