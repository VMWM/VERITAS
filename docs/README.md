# HLA Agent-MCP System Documentation

Welcome to the comprehensive documentation for the HLA Agent-MCP System. This system provides a complete research infrastructure for Claude Code with automated citation management, conversation tracking, and Obsidian integration.

## Documentation Index

### Getting Started
- **[Setup Guide](SETUP.md)** - Complete installation instructions
- **[Setup Checklist](SETUP_CHECKLIST.md)** - Interactive checklist for verification
- **[Troubleshooting](TROUBLESHOOTING.md)** - Common issues and solutions

### Core Components
- **[MCP Servers Information](MCP_INFO.md)** - Details on all 7 MCP servers
- **[Conversation Logger](CONVERSATION_LOGGER.md)** - Complete guide to conversation tracking and journal generation
- **[Customization Guide](CUSTOMIZATION.md)** - Adapting the system for your needs

## Quick Navigation

### First Time Setup
1. Start with [SETUP.md](SETUP.md)
2. Use [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) to verify
3. Read [CONVERSATION_LOGGER.md](CONVERSATION_LOGGER.md) for journal features

### For Developers
- [CUSTOMIZATION.md](CUSTOMIZATION.md) - Modify templates and workflows
- [CONVERSATION_LOGGER.md#api-reference](CONVERSATION_LOGGER.md#api-reference) - API documentation
- [MCP_INFO.md](MCP_INFO.md) - Technical server details

### Need Help?
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Fix common problems
- [CONVERSATION_LOGGER.md#troubleshooting](CONVERSATION_LOGGER.md#troubleshooting) - Logger-specific issues
- [GitHub Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues) - Report bugs

## Documentation Overview

### [SETUP.md](SETUP.md)
Complete setup instructions including:
- Prerequisites and requirements
- Step-by-step installation
- MCP server configuration
- Obsidian integration
- Hook system setup

### [CONVERSATION_LOGGER.md](CONVERSATION_LOGGER.md)
Comprehensive guide covering:
- Architecture and data flow
- Installation and configuration
- All 5 MCP tools with examples
- Journal generation templates
- Database schema and queries
- Integration workflows
- Advanced configuration
- API reference

### [MCP_INFO.md](MCP_INFO.md)
Technical details for all MCP servers:
- Sequential Thinking MCP
- PubMed MCP (35+ million articles)
- Memory MCP (knowledge graphs)
- Filesystem MCP
- Obsidian REST APIs (2 instances)
- Conversation Logger MCP

### [CUSTOMIZATION.md](CUSTOMIZATION.md)
Adapt the system to your needs:
- Template modification
- Citation format changes
- Workflow customization
- Hook configuration
- Research domain adaptation

### [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)
Interactive verification checklist:
- [ ] All MCP servers connected
- [ ] Conversation logger active
- [ ] Database created
- [ ] Journal generation working
- [ ] Obsidian integration verified

### [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
Solutions for common issues:
- MCP connection problems
- Hook execution errors
- Database issues
- Journal generation failures
- Obsidian API problems

## Key Features Documented

### Conversation Tracking
The [Conversation Logger](CONVERSATION_LOGGER.md) provides:
- Persistent memory across sessions
- Automatic activity tracking
- Journal generation from actual conversation data
- Project context awareness
- Integration with Memory MCP

### Citation Management
Enforced throughout the system:
- Automatic PubMed verification
- PMID requirement for all claims
- Citation format: (Author et al., Year, PMID: XXXXXXXX)
- Verification levels: FT-VERIFIED, ABSTRACT-VERIFIED, NEEDS-FT-REVIEW

### Obsidian Integration
Two-vault system documented:
- Primary vault (port 27124): Research content
- Journal vault (port 27125): Daily logs
- Automatic wiki linking
- Template-based creation

### Research Workflows
Complete workflows for:
- Literature review with citations
- Research question documentation
- Concept note creation
- Daily journal generation
- Knowledge graph building

## Version Information

- **System Version**: 2.0.0
- **Conversation Logger**: 1.0.0
- **Documentation Updated**: January 2025
- **Repository**: [GitHub](https://github.com/VMWM/HLA_Agent-MCP_System)

## Contributing

Documentation improvements welcome! Please:
1. Follow existing format patterns
2. Include practical examples
3. Test all code snippets
4. Update this index when adding new docs

## Support

- **Issues**: [GitHub Issues](https://github.com/VMWM/HLA_Agent-MCP_System/issues)
- **Documentation**: You're here!
- **Community**: Claude Code users and researchers

---

*For the main repository README, see [../README.md](../README.md)*