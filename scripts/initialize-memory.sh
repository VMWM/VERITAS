#!/bin/bash

# Memory Initialization Script for HLA Research MCP System
# This script pre-loads core knowledge into the memory system

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================================"
echo "Initializing Memory MCP with Core Knowledge"
echo "================================================"
echo ""

# Check if memory directory exists
MEMORY_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MCP-Shared/nova-memory"
if [ ! -d "$MEMORY_DIR" ]; then
    echo -e "${YELLOW}⚠${NC} Memory directory not found. Run setup script first."
    exit 1
fi

# Create initial memory state file if it doesn't exist
MEMORY_FILE="$MEMORY_DIR/core-knowledge.json"
if [ ! -f "$MEMORY_FILE" ]; then
    cat > "$MEMORY_FILE" << 'EOF'
{
  "formatting_rules": {
    "research_questions": {
      "rule": "MUST be phrased as actual questions ending with ?",
      "folder": "/Research Questions/",
      "examples_correct": [
        "How does prozone effect impact SAB interpretation?",
        "What MFI cutoff strategies optimize virtual crossmatch accuracy?"
      ],
      "examples_incorrect": [
        "Prozone Effect Impact",
        "MFI Cutoff Strategies"
      ]
    },
    "concepts": {
      "rule": "Use descriptive noun phrases (NOT questions)",
      "folder": "/Concepts/",
      "examples": [
        "Halifax_Protocol.md",
        "MFI_Cutoffs.md",
        "Epitope_Analysis.md"
      ]
    }
  },
  "knowledge_graph_rules": {
    "related_concepts": "Minimum 3-5 wiki-links using [[Concept_Name]] format",
    "bidirectional_linking": "Update existing concepts to link back",
    "frontmatter_aliases": "Include alternative names and abbreviations",
    "hierarchical_tags": "Use tags like [concept, HLA, antibodies, transplantation]",
    "in_text_linking": "Link first mention of any concept with its own page"
  },
  "mcp_server_rules": {
    "always_use": {
      "obsidian-rest": "For ALL Obsidian operations (works from ANY folder)",
      "filesystem-local": "For reading project files (limited to current folder)",
      "memory": "For storing validated facts with citations",
      "pubmed": "For literature verification"
    },
    "never_use": {
      "obsidian-file": "Causes 'Access denied' errors",
      "obsidian-vault": "Causes 'Access denied' errors",
      "manual_auth": "Do NOT manually add Authorization headers"
    }
  },
  "hla_domain_knowledge": {
    "mfi_cutoffs_2023": {
      "1000_mfi": "22% of labs",
      "2000_3000_mfi": "55% of labs",
      "same_thresholds": "87% apply same for HLA-A,B,DR,DQ",
      "high_cutoff_cdp": "35-38% use ≥5000 for HLA-C,DP",
      "source": "Puttarajappa et al. Human Immunology 84 (2023) 214-223"
    },
    "halifax_protocol": {
      "method": "Mix EDTA with beads BEFORE adding serum",
      "time_reduction": "60%",
      "sensitivity": "95.7%",
      "specificity": "96.6%",
      "additional_antibodies": "~27 in highly sensitized patients",
      "source": "Liwski et al. Human Immunology 79 (2018) 28-38"
    },
    "virtual_crossmatch_concordance": {
      "1000_1999_mfi": "41.9%",
      "2000_2999_mfi": "85.0%",
      "3000_4999_mfi": "93.4%",
      "5000_plus_mfi": "100%"
    }
  }
}
EOF
    echo -e "${GREEN}✓${NC} Core knowledge initialized"
else
    echo -e "${YELLOW}⚠${NC} Core knowledge already exists. Skipping initialization."
fi

# Copy memory instructions to be accessible
INSTRUCTIONS_SOURCE="../config/memory-instructions.md"
INSTRUCTIONS_DEST="$MEMORY_DIR/instructions.md"
if [ -f "$INSTRUCTIONS_SOURCE" ]; then
    cp "$INSTRUCTIONS_SOURCE" "$INSTRUCTIONS_DEST"
    echo -e "${GREEN}✓${NC} Memory instructions copied"
else
    echo -e "${YELLOW}⚠${NC} Instructions file not found"
fi

echo ""
echo "================================================"
echo "Memory Initialization Complete!"
echo "================================================"
echo ""
echo "Core knowledge has been loaded into the memory system."
echo "This includes:"
echo "  • Obsidian formatting rules"
echo "  • Knowledge graph linking requirements"
echo "  • MCP server usage guidelines"
echo "  • HLA domain knowledge base"
echo ""
echo "Users can customize by adding their own knowledge on top of this base."
echo ""