# VERITAS Configuration Guide

This guide helps you adapt VERITAS to your specific research domain and configure Obsidian integration for your research workflow.

## Domain Customization

### Quick Customization Steps

1. **Update CLAUDE.md** with your project context
2. **Create domain expert** in `.claude/agents/` for your field
3. **Configure Obsidian vaults** for your research structure
4. **Adjust hook scripts** for domain-specific validation
5. **Customize templates** in `.claude/templates/` for your field (copied from install)

### Vault Structure Options

#### Option A: Two-Vault System (Recommended)
Separate research content from daily logs:
```
Obsidian/
├── [Your Research Topic]/      # Main research vault
│   ├── Research Questions/
│   ├── Concepts/
│   └── Literature/
└── Research Journal/           # Daily logs
    └── Daily/
```

**Configuration**: Use two Obsidian REST servers on different ports

#### Option B: Single Vault (Simpler)
Everything in one location:
```
Obsidian/
└── Research/
    ├── Research Questions/
    ├── Concepts/
    ├── Daily/
    └── Literature/
```

**Configuration**: Use single Obsidian REST server

#### Option C: Project-Based Vaults
Separate vault per project:
```
Obsidian/
├── Project_A/
├── Project_B/
└── Shared_Resources/
```

**Configuration**: Multiple REST servers, one per project

### Customizing for Your Domain

#### 1. Update CLAUDE.md

Replace the PROJECT CONTEXT section:
```markdown
## PROJECT CONTEXT

[Your research area description]
[Your timeline]
Location: [Your project directory]
```

#### 2. Create Domain Expert File

Create `.claude/agents/[your-domain]-expert.md`:
```markdown
# Domain Expert: [Your Field] Research Director

## Role Definition
- **Type**: Domain Expert Module
- **Activated By**: CLAUDE.md Constitution when research tasks detected
- **Purpose**: [Your specific purpose]
- **Authority**: Implements constitutional requirements for [your domain]

## Domain Configuration
- **Research Focus**: [Your specific area]
- **Grant Target**: [NIH R01, NSF, DoD, etc.]
- **Timeline**: [Your milestones]
- **Primary Database**: [PubMed, arXiv, etc.]

## Research Aims
**Aim 1:** [Your first research aim]
**Aim 2:** [Your second research aim]
**Aim 3:** [Your third research aim]

## Templates
### Research Question Template
[Your field-specific research question format]

### Concept Note Template
[Your field-specific concept format]

### Daily Journal Template
[Your field-specific journal format]
```

#### 3. Modify Templates

Edit files in `.claude/templates/` (copied during setup):

**For Medical/Biology Research**:
- Keep PMID citation format
- Maintain clinical sections
- Include validation data

**For Computer Science**:
- Replace PMIDs with DOI/arXiv
- Add code repository links
- Include performance metrics

**For Social Sciences**:
- Adjust citation format (APA/MLA)
- Add qualitative analysis sections
- Include participant data fields

**For Engineering**:
- Add specification tables
- Include design parameters
- Add testing protocols

#### 4. Adjust Citation Requirements

Edit `.claude/project.json` for verification settings:
```json
{
  "citation_format": {
    "pattern": "your-citation-pattern",
    "required_fields": ["author", "year", "identifier"]
  }
}
```

#### 5. Customize Hook Validation

Edit `.claude/hooks/post-command.py`:
- Modify citation patterns
- Adjust verification levels
- Add domain-specific checks

### Domain-Specific Examples

#### Computational Biology
```markdown
tags: [computational-biology, algorithm, genomics]
Include: Algorithm complexity, Dataset size, Validation metrics
Citations: PMID for biology, DOI for computational papers
```

#### Machine Learning
```markdown
tags: [ml-model, dataset, benchmark]
Include: Model architecture, Training details, Benchmark scores
Citations: arXiv, conference proceedings
```

#### Clinical Research
```markdown
tags: [clinical-trial, patient-outcomes, protocol]
Include: Trial design, Sample size, Statistical analysis
Citations: PMID, ClinicalTrials.gov ID
```

### Removing Medical-Specific Features

If not doing medical research:

1. **Remove PMID enforcement**:
   - Edit `.claude/hooks/post-command.py`
   - Remove PMID validation
   - Add your citation format

2. **Update templates**:
   - Remove clinical sections
   - Remove PMID fields
   - Add field-specific sections

3. **Update domain expert**:
   - Adjust citation requirements in `.claude/agents/domain-expert.md`
   - Modify verification levels for your field
   - Note: Keep CLAUDE.md unchanged - it's the VERITAS constitution

### Adding Custom Tools

To add field-specific tools:

1. **Install additional MCPs**:
```bash
npx @modelcontextprotocol/install [tool-name]
```

2. **Update Claude Desktop config**:
```json
"your-tool": {
  "command": "npx",
  "args": ["@modelcontextprotocol/server-yourtool"]
}
```

3. **Add to CLAUDE.md tool priority**:
```markdown
## TOOL USAGE - STRICT PRIORITY
1. mcp__sequential-thinking__*
2. mcp__your-tool__*
...
```

## Obsidian Integration Setup

VERITAS can integrate directly with Obsidian vaults to automatically create and update research notes, concepts, and daily journals.

### Prerequisites

1. **Obsidian** installed with your research vault(s) set up
2. **Local REST API plugin** installed from Community Plugins
3. **VERITAS** already installed (see [Getting Started](getting-started.md))

### Step 1: Install Local REST API Plugin

1. Open Obsidian and go to Settings → Community Plugins
2. Browse and search for "Local REST API"
3. Install and enable the plugin
4. Go to the plugin settings to configure authentication

### Step 2: Configure Authentication

#### Option A: Bearer Token (Recommended)
1. In Local REST API settings, enable "Require authentication"
2. Set authentication method to "Bearer token"
3. Generate or set a secure token
4. Copy the token - you'll need it for VERITAS configuration

#### Option B: API Key
1. In Local REST API settings, note the auto-generated API key
2. Copy this key for VERITAS configuration

### Step 3: Configure Ports

#### Single Vault Setup
- Set Local REST API to port 27124
- This will be your main research vault

#### Dual Vault Setup
- **Research Vault**: Port 27124
- **Journal Vault**: Port 27125
- Configure each vault separately with different ports

### Step 4: Set Up Vault Structure

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

### Step 5: Configure VERITAS

Save your API credentials:

#### Single Vault
```bash
# Save your token
echo 'YOUR_TOKEN_HERE' > ~/.obsidian_api_token

# Or if using API key
echo 'YOUR_API_KEY_HERE' > ~/.obsidian_api_key
```

#### Dual Vault
```bash
# Research vault token (port 27124)
echo 'YOUR_RESEARCH_TOKEN' > ~/.obsidian_api_token_research

# Journal vault token (port 27125) 
echo 'YOUR_JOURNAL_TOKEN' > ~/.obsidian_api_token_journal
```

### Step 6: Test the Integration

1. Start a new Claude Code conversation
2. Test the connection:
   ```
   "Create a test concept note in my Obsidian vault"
   ```

3. Check your vault - you should see a new note created automatically

### Vault Integration Features

Once configured, VERITAS can:

- **Create Research Questions** - Automatically formatted and filed
- **Generate Concept Notes** - With proper templates and cross-links
- **Build Rule Libraries** - For methodological standards
- **Generate Daily Journals** - From conversation history
- **Auto-link Related Content** - Using wiki-link format

### Usage Examples

#### Creating Research Content
```
"Create a research question about the effectiveness of intervention X"
```

#### Generating Concepts
```
"Add a concept note for machine learning bias to my vault"
```

#### Daily Documentation
```
"Generate today's research journal entry"
```

## Testing Your Configuration

After customizing:

1. Start new Claude conversation
2. Test with domain-specific task:
   ```
   "Create a research question about [your topic]"
   ```
3. Verify:
   - Correct templates used
   - Proper citations format
   - Domain terminology correct
   - Validation passes

## Troubleshooting Integration

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

## CLI vs Desktop Configuration Differences

### Important: PubMed MCP Compatibility

VERITAS automatically handles a critical difference between Claude CLI and Claude Desktop:

**The Issue**: The `@ncukondo/pubmed-mcp` server outputs diagnostic text before JSON, which breaks Claude Desktop's JSON-RPC parser but works fine in CLI.

**The Solution**: VERITAS uses different configurations:
- **Claude CLI**: Direct command `npx @ncukondo/pubmed-mcp`
- **Claude Desktop**: Wrapper script at `install/mcp-wrappers/pubmed-wrapper.js`

### Configuration Management

When running `configure-claude.sh`, you'll be asked about configuration management:

1. **Separate configs (RECOMMENDED)**: Maintains independent configurations for CLI and Desktop
   - Allows different PubMed configurations
   - Each can be optimized for its environment
   
2. **Symlinked configs (NOT RECOMMENDED)**: Makes Desktop use CLI's configuration
   - Will break PubMed MCP in Desktop
   - Only use if you don't need PubMed functionality

The setup script automatically applies the correct configuration for each environment.

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

## Sharing Your Configuration

To share with colleagues:

1. Fork the repository
2. Apply your customizations
3. Update README with your domain
4. Share your fork URL

## Support for Configuration

- Keep base system intact
- Document your changes
- Test incrementally
- Submit domain-specific templates as PRs

For additional help, see [Troubleshooting Guide](troubleshooting.md) or check the [reference documentation](reference/).