# MCP Installation Guide

This guide documents all Model Context Protocol (MCP) servers required for the Research Agent system. All MCP servers are installed with the setup.sh run. This is for information purposes only. 

## Required MCP Servers

### 1. Sequential Thinking MCP
**Purpose**: Provides structured problem-solving and planning capabilities
**Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
```bash
npx @modelcontextprotocol/install sequentialthinking
```

### 2. PubMed MCP
**Purpose**: Enables citation verification and literature search
**Repository**: https://github.com/modelcontextprotocol/servers/tree/main/src/pubmed
```bash
npx @modelcontextprotocol/install pubmed
```

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

### 5. Obsidian REST API
**Purpose**: Direct integration with Obsidian vaults
**Installation**: 
1. Install Obsidian Local REST API plugin from Community Plugins
2. Configure authentication (Bearer token recommended)
3. Set unique ports for each vault (e.g., 27124, 27125)

## Configuration in Claude Desktop

After installation, add to your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sequentialthinking"]
    },
    "pubmed": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-pubmed"]
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "filesystem-local": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "obsidian-rest-hla": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-rest", 
               "--base-url", "http://127.0.0.1:27124",
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
3. `mcp__pubmed__*` - Citation verification
4. `mcp__obsidian-rest__*` - Vault operations
5. `mcp__filesystem-local__*` - Project file access

## Updates

Check for MCP updates regularly:
```bash
npm update @modelcontextprotocol/install
```

Monitor the official MCP repository for new servers:
https://github.com/modelcontextprotocol/servers
