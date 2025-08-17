# API Keys and File Paths Setup Guide

## Table of Contents
1. [Required API Keys](#required-api-keys)
2. [Optional API Keys](#optional-api-keys)
3. [Setting Up File Paths](#setting-up-file-paths)
4. [Configuration Steps](#configuration-steps)

---

## Required API Keys

### 1. Claude API Key (REQUIRED)
**Cost**: ~$20/month for heavy use
**Where to get it**:
1. Go to https://console.anthropic.com/
2. Sign up or log in
3. Navigate to "API Keys" section
4. Click "Create Key"
5. Copy the key (starts with `sk-ant-api...`)

**Where to add it**:
- VS Code: Settings → Search "Claude" → Add API key
- Or set environment variable: `export ANTHROPIC_API_KEY="sk-ant-api..."`

### 2. Obsidian REST API Key (REQUIRED)
**Cost**: Free
**Where to get it**:
1. Open Obsidian
2. Settings → Community Plugins → Browse
3. Search for "Local REST API"
4. Install and Enable
5. Go to plugin settings
6. Click "Generate New API Key"
7. Copy the generated key

**Where to add it** in `claude-desktop-config.json`:
```json
"obsidian-rest": {
  "env": {
    "REST_API_KEY": "paste-your-key-here",
    "REST_DEFAULT_HEADERS": "{\"Authorization\": \"Bearer paste-your-key-here\"}"
  }
}
```
Note: Add the same key in BOTH places!

---

## Optional API Keys

### 3. PubMed API Key (OPTIONAL but recommended)
**Cost**: Free
**Benefits**: 
- Higher rate limits (10 requests/second vs 3/second)
- More stable access
- Priority during high traffic

**Where to get it**:
1. Go to https://www.ncbi.nlm.nih.gov/account/
2. Sign in with NIH, Google, or create account
3. Go to "Settings" → "API Key Management"
4. Click "Create API Key"
5. Copy the key

**Where to add it** in `claude-desktop-config.json`:
```json
"pubmed": {
  "env": {
    "PUBMED_EMAIL": "your.email@university.edu",
    "PUBMED_API_KEY": "paste-your-pubmed-key-here"
  }
}
```

---

## Setting Up File Paths

### Understanding Path Types

**Knowledge Paths** (Where your PDFs and notes are):
```json
"knowledge_paths": [
  "~/path/to/your/PDF_library",        # Research papers
  "~/path/to/your/lecture_slides",     # Course materials  
  "~/path/to/your/protocols",          # Lab protocols
  "~/path/to/your/meeting_notes"       # Other documents
]
```

**Output Paths** (Where notes will be created):
```json
"output_paths": {
  "research_questions": "~/path/to/Obsidian/vault/Research Questions",
  "concepts": "~/path/to/Obsidian/vault/Concepts",
  "daily_entries": "~/path/to/Obsidian/vault/Daily"
}
```

### Finding Your Paths

#### On macOS:
1. **Find a folder in Finder**
2. **Right-click** → "Get Info"
3. **Copy the path** from "Where:"
4. **Add to config** with home directory notation:
   - Replace `/Users/yourname/` with `~/`
   - Example: `/Users/john/Documents/PDFs` → `~/Documents/PDFs`

#### Common Locations:

**iCloud Drive**:
```
~/Library/Mobile Documents/com~apple~CloudDocs/
```

**Dropbox**:
```
~/Dropbox/
```

**Box**:
```
~/Library/CloudStorage/Box-Box/
```

**OneDrive**:
```
~/Library/CloudStorage/OneDrive-YourOrg/
```

**Local Documents**:
```
~/Documents/
```

### Path Configuration Examples

#### Example 1: Academic Researcher
```json
"knowledge_paths": [
  "~/Documents/Literature/HLA_Papers",
  "~/Dropbox/Lab_Shared/Protocols",
  "~/Library/CloudStorage/Box-Box/Lectures",
  "~/Documents/Research/Grant_Materials"
],
"output_paths": {
  "research_questions": "~/Documents/Obsidian/Research/Questions",
  "concepts": "~/Documents/Obsidian/Research/Concepts",
  "daily_entries": "~/Documents/Obsidian/Journal/Daily"
}
```

#### Example 2: Medical Fellow
```json
"knowledge_paths": [
  "~/Library/Mobile Documents/com~apple~CloudDocs/Fellowship/Papers",
  "~/Library/CloudStorage/Box-Box/Clinical_Protocols",
  "~/Documents/Conference_Presentations",
  "~/Dropbox/Case_Studies"
],
"output_paths": {
  "research_questions": "~/Documents/Obsidian/Clinical/Questions",
  "concepts": "~/Documents/Obsidian/Clinical/Concepts",
  "daily_entries": "~/Documents/Obsidian/Clinical/Daily"
}
```

---

## Configuration Steps

### Step 1: Copy Template
```bash
cd HLA_Agent-MCP_System
cp config/claude-desktop-config.template.json config/claude-desktop-config.json
```

### Step 2: Edit Configuration
Open `config/claude-desktop-config.json` and replace:
1. `YOUR_EMAIL@university.edu` → Your email
2. `YOUR_PUBMED_API_KEY_HERE` → Your PubMed key (or delete if not using)
3. `YOUR_OBSIDIAN_API_KEY_HERE` → Your Obsidian REST API key (both places!)
4. Update the Obsidian file path:
   ```json
   "obsidian-file": {
     "args": [
       "@modelcontextprotocol/server-filesystem",
       "~/path/to/your/Obsidian"  // ← Change this
     ]
   }
   ```

### Step 3: Edit Agent Specification
Open `config/agent-specification.json` and update:
1. All paths in `knowledge_paths` array
2. All paths in `output_paths` object

### Step 4: Move to iCloud (for multi-machine sync)
```bash
# Create MCP-Shared folder
mkdir -p ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared

# Copy your configured file
cp config/claude-desktop-config.json ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/

# Create symlink
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/MCP-Shared/claude-desktop-config.json ~/.claude.json
```

### Step 5: Test Your Setup
```bash
# Start Claude
claude

# Check connections
/mcp

# Test PubMed (if configured)
"Search PubMed for HLA antibodies"

# Test Obsidian
"Create a test note in Research Journal"
```

---

## Troubleshooting

### API Key Issues

**Claude API Key Not Working**:
- Check for extra spaces
- Ensure it starts with `sk-ant-api`
- Verify billing is set up at console.anthropic.com

**Obsidian API Key Not Working**:
- Ensure Obsidian is running
- Check REST API plugin is enabled
- Regenerate key if needed
- Make sure key is in BOTH places in config

**PubMed Not Connecting**:
- It's optional - works without key but slower
- Check email format is correct
- Verify at https://www.ncbi.nlm.nih.gov/account/

### Path Issues

**"File not found" errors**:
- Use absolute paths starting with `~/`
- Check for spaces in folder names (keep them!)
- Verify folder exists before adding to config

**Obsidian notes not appearing**:
- Check Obsidian vault location
- Ensure output paths exist
- Try file system mode if REST fails

### Quick Fixes

```bash
# Check if path exists
ls -la ~/path/to/your/folder

# Create missing folders
mkdir -p ~/Documents/Obsidian/HLA\ Antibodies/Research\ Questions

# Test file access
cat ~/path/to/test/file.pdf
```

---

## Security Notes

**NEVER**:
- Commit your actual API keys to Git
- Share your config file with keys
- Post keys in GitHub issues

**ALWAYS**:
- Use template files for sharing
- Keep your actual config local
- Use environment variables when possible

---

*If you need help, create an issue on GitHub WITHOUT including your actual keys or personal paths!*