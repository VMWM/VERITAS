# Multi-Machine Configuration Synchronization

This guide explains how to synchronize VERITAS configurations across multiple machines using cloud storage services.

## Overview

When working on multiple machines (e.g., home desktop and work laptop), you can keep all Claude configurations perfectly synchronized using cloud storage and symlinks.

## Strategy Comparison

### Single Machine Setup (Default)
- Each Claude interface has its own configuration file
- Changes must be made separately to Desktop and CLI configs
- No synchronization between machines
- Simplest setup with no external dependencies

### Unified Local Setup (Symlink Option)
- Claude Desktop and CLI share the same configuration file locally
- Changes to one automatically affect the other
- Still requires manual sync between machines
- Good for users who primarily use one machine

### Multi-Machine Cloud Sync (Advanced)
- All configurations synchronized via cloud storage
- Changes on any machine propagate to all others
- Single source of truth for all configurations
- Requires cloud storage service (iCloud, Dropbox, etc.)

## Implementation Guide

### Step 1: Choose Your Cloud Service

#### iCloud (macOS)
```bash
CLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"
```

#### Dropbox
```bash
CLOUD_DIR="$HOME/Dropbox/MCP-Shared"
```

#### Google Drive
```bash
CLOUD_DIR="$HOME/Google Drive/MCP-Shared"
```

#### OneDrive
```bash
CLOUD_DIR="$HOME/OneDrive/MCP-Shared"
```

### Step 2: Initial Setup (Primary Machine)

1. Run the standard VERITAS setup:
```bash
cd VERITAS
./setup.sh
./scripts/configure-claude.sh
```

2. When prompted by `configure-claude.sh`:
   - Choose option 1 or 2 for handling existing configs
   - Choose option 2 for symlink configuration

3. Move the master config to cloud storage:
```bash
# Create cloud directory
mkdir -p "$CLOUD_DIR"

# Move config to cloud (keep original as backup)
cp ~/.claude.json "$CLOUD_DIR/claude-config.json"

# Create symlinks from all locations
ln -sf "$CLOUD_DIR/claude-config.json" ~/.claude.json
ln -sf "$CLOUD_DIR/claude-config.json" ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Step 3: Setup on Additional Machines

On each additional machine:

```bash
# Ensure cloud storage is synced
# Wait for $CLOUD_DIR/claude-config.json to appear

# Create symlinks to cloud config
ln -sf "$CLOUD_DIR/claude-config.json" ~/.claude.json
ln -sf "$CLOUD_DIR/claude-config.json" ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Verify symlinks
ls -la ~/.claude.json
ls -la ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Step 4: Conversation Logger Synchronization (Optional)

To sync conversation logs across machines:

```bash
# Move conversation logger database to cloud
mv ~/.conversation-logger "$CLOUD_DIR/conversation-logger-db"

# Symlink on all machines
ln -s "$CLOUD_DIR/conversation-logger-db" ~/.conversation-logger
```

## Project-Specific Configurations

For project-specific MCP servers, you have two options:

### Option 1: Global Configuration
Add all project-specific servers to your cloud config. They'll be available on all machines but only work when the project exists.

### Option 2: Project Symlinks
Each project can have its own `.mcp.json` that symlinks to the cloud config:

```bash
cd /path/to/project
ln -s "$CLOUD_DIR/claude-config.json" .mcp.json
```

## Troubleshooting

### Symlink Not Updating
If changes aren't propagating:
1. Check cloud service is running and synced
2. Verify symlinks are pointing to cloud location: `ls -la ~/.claude.json`
3. Restart Claude Desktop/CLI after sync completes

### Path Differences Between Machines
If you have different usernames or paths:
- Use relative paths where possible
- Consider machine-specific wrapper scripts
- Set environment variables for machine-specific paths

### Permissions Issues
```bash
# Fix permissions on config files
chmod 644 "$CLOUD_DIR/claude-config.json"

# Ensure cloud directory is readable
chmod 755 "$CLOUD_DIR"
```

## Best Practices

1. **Always backup before changes**: The cloud config affects all machines
2. **Test on one machine first**: Verify changes work before they sync
3. **Use version control**: Keep your cloud config in git for history
4. **Document machine differences**: Note any machine-specific requirements

## Example Complete Setup Script

Create this as `setup-cloud-sync.sh`:

```bash
#!/bin/bash

# Configuration
CLOUD_SERVICE="icloud"  # Change to: dropbox, gdrive, onedrive
MACHINE_NAME="$(hostname)"

# Set cloud directory based on service
case $CLOUD_SERVICE in
    icloud)
        CLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared"
        ;;
    dropbox)
        CLOUD_DIR="$HOME/Dropbox/MCP-Shared"
        ;;
    gdrive)
        CLOUD_DIR="$HOME/Google Drive/MCP-Shared"
        ;;
    onedrive)
        CLOUD_DIR="$HOME/OneDrive/MCP-Shared"
        ;;
    *)
        echo "Unknown cloud service: $CLOUD_SERVICE"
        exit 1
        ;;
esac

# Create cloud directory
mkdir -p "$CLOUD_DIR"

# Check if this is the primary machine (has existing config)
if [ -f ~/.claude.json ] && [ ! -L ~/.claude.json ]; then
    echo "Setting up primary machine..."
    
    # Backup existing config
    cp ~/.claude.json "$CLOUD_DIR/claude-config.json.backup.$MACHINE_NAME"
    
    # Move to cloud
    mv ~/.claude.json "$CLOUD_DIR/claude-config.json"
    
    echo "Config moved to cloud storage"
else
    echo "Setting up secondary machine..."
    
    # Wait for cloud sync
    echo "Waiting for cloud sync..."
    while [ ! -f "$CLOUD_DIR/claude-config.json" ]; do
        sleep 2
    done
    
    echo "Cloud config detected"
fi

# Create symlinks
echo "Creating symlinks..."

# Remove existing files/links
rm -f ~/.claude.json
rm -f ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Create new symlinks
ln -s "$CLOUD_DIR/claude-config.json" ~/.claude.json
ln -s "$CLOUD_DIR/claude-config.json" ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Also link conversation logger if desired
if [ -d "$CLOUD_DIR/conversation-logger-db" ]; then
    rm -rf ~/.conversation-logger
    ln -s "$CLOUD_DIR/conversation-logger-db" ~/.conversation-logger
fi

echo "✅ Cloud sync configured for $MACHINE_NAME"
echo "Configuration location: $CLOUD_DIR/claude-config.json"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop"
echo "2. Run 'claude' to test CLI"
echo "3. Verify MCP servers with '/mcp' command"
```

## Security Considerations

⚠️ **Important**: Your configuration files may contain API keys and tokens. Ensure:

1. Cloud storage account has strong authentication
2. Don't share cloud folders containing configs
3. Use encrypted cloud storage if available
4. Regularly rotate API keys and tokens
5. Consider using environment variables for sensitive data

## Alternative: Git-Based Sync

For users who prefer version control over cloud storage:

```bash
# Create a private GitHub repo for configs
git init ~/claude-configs
cd ~/claude-configs

# Add your config
cp ~/.claude.json ./claude-config.json
git add claude-config.json
git commit -m "Initial config"
git remote add origin git@github.com:yourusername/claude-configs.git
git push -u origin main

# On other machines
git clone git@github.com:yourusername/claude-configs.git ~/claude-configs
ln -s ~/claude-configs/claude-config.json ~/.claude.json
ln -s ~/claude-configs/claude-config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json

# To sync changes
cd ~/claude-configs
git pull  # Get changes
git add . && git commit -m "Update from $HOSTNAME" && git push  # Send changes
```

## Summary

Multi-machine synchronization allows you to:
- ✅ Maintain identical configurations across all machines
- ✅ Make changes once, apply everywhere
- ✅ Keep project configurations in sync
- ✅ Share conversation history (optional)
- ✅ Reduce configuration maintenance overhead

Choose the approach that best fits your workflow and security requirements.