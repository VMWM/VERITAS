# System Architecture

## Overview

The HLA Agent-MCP System is a modular AI research assistant built on Claude Code's Model Context Protocol (MCP) framework. It combines multiple specialized servers to create a comprehensive research environment.

## Architecture Diagram

```
┌──────────────────────────────────────────────────────────┐
│                 VS Code + Claude Code                     │
│         (Works from ANY project folder on ANY machine)    │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
                ~/.claude.json (symlink)
                         │
                         ▼
    ┌────────────────────────────────────────────────────┐
    │          iCloud MCP-Shared Configuration           │
    │            (Syncs across all your machines)        │
    └────────────────────┬───────────────────────────────┘
                         │
             ┌───────────┴───────────────┐
             ▼                           ▼
    ┌─────────────────────┐     ┌─────────────────────┐
    │    MCP Servers      │     │   Knowledge Base    │
    ├─────────────────────┤     ├─────────────────────┤
    │ Memory (templates)  │     │ HLA lectures        │
    │ PubMed (PMIDs)      │     │ Lab protocols       │
    │ Obsidian (notes)    │     │ Literature PDFs     │
    │ Agent (automation)  │     │ Meeting notes       │
    └─────────────────────┘     └─────────────────────┘
                         │
                         ▼
             ┌───────────────────────────┐
             │     Obsidian Vaults       │
             ├───────────────────────────┤
             │ • HLA Antibodies/         │
             │   - Research Questions/   │
             │   - Concepts/             │
             │                           │
             │ • Research Journal/       │
             │   - Daily/                │
             │   - Concepts/             │
             └───────────────────────────┘
```

## Component Details

### 1. User Interface Layer
- **VS Code**: Primary development environment
- **Claude Code CLI**: Interactive command-line interface
- **Access**: Works from any project folder on any machine

### 2. Configuration Layer
- **Location**: `~/.claude.json` symlinked to iCloud
- **Purpose**: Centralized configuration management
- **Features**: 
  - Multi-machine synchronization via iCloud
  - API key management
  - Server configurations
  - Environment variables

### 3. MCP Servers

#### Memory MCP (`@nova-mcp/mcp-nova`)
- **Storage**: SQLite database with vector embeddings
- **Location**: `~/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory/`
- **Key Features**:
  - Persistent template storage (IDs: 10, 11, 12, 13, 14)
  - Intelligent routing rules for content
  - Search history and context maintenance
  - Survives session restarts

#### PubMed MCP (`@ncukondo/pubmed-mcp`)
- **Purpose**: Medical literature verification
- **Auto-triggers**: 
  - Medical terminology detection
  - Statistical queries ("how often", "prevalence")
  - HLA-specific terms
- **Features**:
  - PMID verification
  - Abstract retrieval
  - Citation formatting
  - Rate limiting (1 second between queries)

#### Obsidian Dual-Mode Access

##### REST API (`dkmaker-mcp-rest-api`)
- **When**: Obsidian app is running
- **Port**: 27124 (HTTPS)
- **Capabilities**:
  - Full search functionality
  - Command execution
  - Index updates
  - Real-time sync

##### File System (`@modelcontextprotocol/server-filesystem`)
- **When**: Offline or app closed
- **Path**: Direct to Obsidian vault
- **Capabilities**:
  - File read/write
  - Directory operations
  - Template application

#### Sequential Thinking MCP
- **Purpose**: Complex problem decomposition
- **Use Cases**:
  - Multi-step literature reviews
  - Contradiction analysis
  - Systematic comparisons

### 4. Knowledge Base Structure

```
Your-Cloud-Storage/
├── Research-Materials/
│   ├── Lecture-Notes/
│   │   ├── Expert-Lectures/            # Domain expert materials
│   │   ├── Foundation-Materials/       # Basic concepts
│   │   └── Lab-Protocols/              # Standard procedures
│   └── Literature/                     # Research PDFs
│
└── Obsidian/
    ├── HLA Antibodies/                 # Domain-specific vault
    │   ├── Research Questions/         # PMID-verified Q&As
    │   └── Concepts/                   # Knowledge nodes
    └── Research Journal/               # Daily documentation
        ├── Daily/                      # YYYY-MM-DD entries
        └── Concepts/                   # Cross-project concepts
```

### 5. HLA Research Agent

The agent is a specialized workflow that orchestrates multiple MCP servers:

```python
class HLAResearchAgent:
    def execute(query):
        # Step 1: Parse query intent
        intent = analyze_query(query)
        
        # Step 2: Search knowledge base
        local_results = search_pdfs(knowledge_paths)
        
        # Step 3: Query PubMed if medical
        if is_medical(query):
            pubmed_results = search_pubmed(query)
            verify_pmids(pubmed_results)
        
        # Step 4: Extract and synthesize
        statistics = extract_statistics(all_results)
        concepts = identify_concepts(all_results)
        
        # Step 5: Create notes
        create_research_question(query, statistics)
        for concept in concepts:
            create_concept_page(concept)
        
        # Step 6: Build knowledge graph
        create_links(all_pages)
        
        return summary
```

## Data Flow

### Query Processing
```
User Query
    ↓
Claude Code interprets
    ↓
Memory MCP checks templates/history
    ↓
Agent orchestration begins
    ↓
Parallel execution:
    ├── Knowledge base search
    ├── PubMed query (if medical)
    └── Sequential thinking (if complex)
    ↓
Results synthesis
    ↓
Note creation in Obsidian
    ↓
Memory MCP stores context
```

### Template Application
```
Memory MCP (ID: 10-14)
    ↓
Contains templates for:
    ├── Daily entries
    ├── Research questions
    └── Concept pages
    ↓
Routing rules determine:
    ├── IF HLA/medical → HLA Antibodies vault
    ├── IF daily → Research Journal vault
    └── IF general → Default location
```

## Security & Privacy

### API Key Management
- Stored in local config only
- Never committed to git (.gitignore configured)
- Accessed via environment variables

### Data Privacy
- All processing happens locally
- Only API calls go to external services
- Knowledge base remains on your machine
- iCloud sync is end-to-end encrypted

## Performance Characteristics

### Speed
- Agent query: 1-3 minutes
- Simple search: <5 seconds
- Note creation: <1 second
- PubMed query: 1-10 seconds (rate limited)

### Resource Usage
- Memory: ~200MB for MCP servers
- CPU: Minimal except during agent execution
- Storage: ~50MB for Memory MCP database
- Network: Only for PubMed and Obsidian REST

## Scalability

### Current Limits
- Knowledge base: No practical limit
- Memory MCP: ~1GB recommended max
- Concurrent operations: 5-10 optimal

### Growth Path
- Add domain-specific agents
- Integrate additional MCP servers
- Expand to team knowledge base
- Add cloud backup options

## Error Handling

### Graceful Degradation
- Obsidian REST fails → Falls back to file system
- PubMed unavailable → Continues with local search
- Memory corrupted → Rebuilds from templates

### Recovery Mechanisms
- Automatic session restart
- Template re-initialization
- Configuration validation
- Backup symlink creation

## Future Architecture Considerations

### Planned Enhancements
- Team collaboration features
- Advanced caching strategies
- Plugin architecture for custom MCP servers

### Modular Extensions
- Custom domain agents
- Alternative knowledge bases
- Additional citation sources
- Export formats

---

*This architecture enables a robust, scalable research assistant that maintains context across sessions while providing specialized HLA expertise.*