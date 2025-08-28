# MCP Installation Guide

This guide documents all Model Context Protocol (MCP) servers required for the VERITAS system. All MCP servers are installed with the setup.sh run. This is for information purposes only.

## MCP Server Types

This system uses three categories of MCP servers:
1. **Third-Party MCP Servers** - External npm packages from the MCP community
2. **Obsidian REST API** - Integration via Obsidian's Local REST API plugin
3. **Custom-Built MCP Server** - The Conversation Logger, developed specifically for this system

## Third-Party MCP Servers (External npm packages)

### 1. Sequential Thinking MCP
**Purpose**: Provides structured problem-solving and planning capabilities
**Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
```bash
npx @modelcontextprotocol/install sequentialthinking
```

### 2. PubMed MCP
**Purpose**: Enables citation verification and literature search
**Package**: @ncukondo/pubmed-mcp (NCBI-compliant with proper credential handling)
**Repository**: https://github.com/ncukondo/pubmed-mcp
**Requirements**: NCBI email and API key (for rate limiting compliance)
```bash
npm install -g @ncukondo/pubmed-mcp
```
See [SETUP_PUBMED.md](../SETUP_PUBMED.md) for configuration details.

### 3. Memory MCP
**Purpose**: Knowledge graph storage and retrieval
**Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/memory
```bash
npx @modelcontextprotocol/install memory
```

### 4. Filesystem MCP
**Purpose**: Local file system access for project files
**Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem
```bash
npx @modelcontextprotocol/install filesystem
```

## Obsidian Integration

### Obsidian REST API
**Purpose**: Direct integration with Obsidian vaults
**Installation**: 
1. Install Obsidian Local REST API plugin from Community Plugins
2. Configure authentication (Bearer token recommended)
3. Set unique ports for each vault (e.g., 27124, 27125)

## Custom-Built MCP Server

### Conversation Logger
**Purpose**: Conversation tracking and journal generation
**Location**: `conversation-logger/` directory in this repository
**Development**: Custom-built specifically for this research system

This is the only MCP server in this system that was developed from scratch rather than installed from external sources. Key features:
- Persistent conversation memory across Claude sessions
- Automatic journal generation from actual conversation data
- SQLite database for conversation storage
- Direct integration with Obsidian for journal posting

**Why Custom-Built?**
No existing MCP server provided the specific combination of conversation tracking, journal generation, and research-oriented features needed for VERITAS. The Conversation Logger fills this gap with functionality tailored to research documentation workflows.

## Configuration in Claude Desktop

After installation, add to your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed-ncukondo": {
      "command": "npx",
      "args": ["@ncukondo/pubmed-mcp"],
      "env": {
        "PUBMED_EMAIL": "your-email@example.com",
        "PUBMED_API_KEY": "your-ncbi-api-key",
        "PUBMED_CACHE_DIR": "/tmp/pubmed-cache",
        "PUBMED_CACHE_TTL": "86400"
      }
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
               "--base-url", "https://127.0.0.1:27124",
               "--auth-type", "bearer",
               "--auth-token", "YOUR_TOKEN"]
    }
  }
}
```

## Verification

Test each MCP installation:

1. **Sequential Thinking**: Ask Claude to plan a complex task
2. **PubMed**: Request a citation verification
3. **Memory**: Store and retrieve a concept
4. **Filesystem**: Read a project file
5. **Obsidian**: Create a test note in vault

## Troubleshooting

### Common Issues

**MCP not responding**:
- Check Claude Desktop is restarted after configuration
- Verify npm/npx is installed
- Check server logs in Claude Desktop

**Obsidian connection failed**:
- Verify REST API plugin is enabled
- Check port isn't blocked by firewall
- Confirm authentication token matches

**PubMed rate limiting**:
- Add delays between requests
- Use batch queries when possible

## Tool Priority in CLAUDE.md

The system enforces this tool priority:
1. `mcp__sequential-thinking__*` - Always first for planning
2. `mcp__memory__*` - Check existing knowledge
3. `mcp__pubmed-ncukondo__*` - Citation verification
4. `mcp__obsidian-rest__*` - Vault operations
5. `mcp__filesystem-local__*` - Project file access

## Updates

Check for MCP updates regularly:
```bash
npm update @modelcontextprotocol/install
```

Monitor the official MCP repository for new servers:
https://github.com/modelcontextprotocol/servers
