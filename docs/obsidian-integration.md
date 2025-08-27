# Obsidian Integration Setup

VERITAS can integrate directly with Obsidian vaults to automatically create and update research notes, concepts, and daily journals.

## Overview

VERITAS supports two integration patterns:

### Single Vault Setup (Recommended for Most Users)
- One Obsidian vault contains all research content
- Simpler to manage and maintain
- Easier backup and sync

### Dual Vault Setup (Advanced)
- Separate vault for research content and daily journals  
- More complex but provides better organization for large projects
- Useful for researchers with extensive daily logging needs

## Prerequisites

1. **Obsidian** installed with your research vault(s) set up
2. **Local REST API plugin** installed from Community Plugins
3. **VERITAS** already installed (see [Getting Started](getting-started.md))

## Step 1: Install Local REST API Plugin

1. Open Obsidian and go to Settings → Community Plugins
2. Browse and search for "Local REST API"
3. Install and enable the plugin
4. Go to the plugin settings to configure authentication

## Step 2: Configure Authentication

### Option A: Bearer Token (Recommended)
1. In Local REST API settings, enable "Require authentication"
2. Set authentication method to "Bearer token"
3. Generate or set a secure token
4. Copy the token - you'll need it for VERITAS configuration

### Option B: API Key
1. In Local REST API settings, note the auto-generated API key
2. Copy this key for VERITAS configuration

## Step 3: Configure Ports

### Single Vault Setup
- Set Local REST API to port 27124
- This will be your main research vault

### Dual Vault Setup
- **Research Vault**: Port 27124
- **Journal Vault**: Port 27125
- Configure each vault separately with different ports

## Step 4: Set Up Vault Structure

Create these folders in your research vault:

```
Your Research Vault/
├── Research Questions/
├── Concepts/
├── Rules/                  # For research methodologies
└── Literature/            # Optional: for reference materials
```

If using dual vault setup, create this structure in your journal vault:

```
Your Journal Vault/
└── Daily/                 # For daily research logs
```

## Step 5: Configure VERITAS

Save your API credentials:

### Single Vault
```bash
# Save your token
echo 'YOUR_TOKEN_HERE' > ~/.obsidian_api_token

# Or if using API key
echo 'YOUR_API_KEY_HERE' > ~/.obsidian_api_key
```

### Dual Vault
```bash
# Research vault token (port 27124)
echo 'YOUR_RESEARCH_TOKEN' > ~/.obsidian_api_token_research

# Journal vault token (port 27125) 
echo 'YOUR_JOURNAL_TOKEN' > ~/.obsidian_api_token_journal
```

## Step 6: Test the Integration

1. Start a new Claude Code conversation
2. Test the connection:
   ```
   "Create a test concept note in my Obsidian vault"
   ```

3. Check your vault - you should see a new note created automatically

## Vault Integration Features

Once configured, VERITAS can:

- **Create Research Questions** - Automatically formatted and filed
- **Generate Concept Notes** - With proper templates and cross-links
- **Build Rule Libraries** - For methodological standards
- **Generate Daily Journals** - From conversation history
- **Auto-link Related Content** - Using wiki-link format

## Usage Examples

### Creating Research Content
```
"Create a research question about the effectiveness of intervention X"
```

### Generating Concepts
```
"Add a concept note for machine learning bias to my vault"
```

### Daily Documentation
```
"Generate today's research journal entry"
```

## Troubleshooting

### Connection Issues

**Cannot connect to vault**:
- Verify Local REST API plugin is enabled
- Check that Obsidian is running with the correct vault open
- Confirm the port number matches your configuration

**Authentication failed**:
- Verify your token/API key is correct
- Check that authentication is properly enabled in plugin settings
- Ensure the credential file has the right permissions

**Notes not appearing**:
- Check that the folder structure exists in your vault
- Verify you have write permissions
- Look for error messages in Claude Code

### Performance Issues

**Slow response times**:
- Local REST API can be slower with very large vaults
- Consider using SSD storage for better performance
- Close unnecessary Obsidian plugins that might slow the API

**Memory usage**:
- Large vaults may use more system memory
- Monitor system resources if you have thousands of notes

## Advanced Configuration

### Custom Folder Structure
You can customize where VERITAS creates different types of content by modifying the folder names in your vault. VERITAS will adapt to your existing structure.

### Multiple Projects
To use VERITAS with multiple research projects:
1. Create separate vaults for each project
2. Use different port numbers for each vault
3. Switch between configurations as needed

### Backup Considerations
- Regular vault backups are essential
- Consider using Obsidian Sync or third-party sync solutions
- Test restore procedures with your integration setup

For additional help, see [Troubleshooting Guide](troubleshooting.md) or check the [reference documentation](reference/).