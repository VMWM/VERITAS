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

# Copy core knowledge file if it doesn't exist
MEMORY_FILE="$MEMORY_DIR/core-knowledge.json"
KNOWLEDGE_SOURCE="../config/core-knowledge.template.json"

if [ ! -f "$MEMORY_FILE" ]; then
    if [ -f "$KNOWLEDGE_SOURCE" ]; then
        cp "$KNOWLEDGE_SOURCE" "$MEMORY_FILE"
        echo -e "${GREEN}✓${NC} Core knowledge initialized from template"
    else
        echo -e "${YELLOW}⚠${NC} Core knowledge template not found at $KNOWLEDGE_SOURCE"
        echo "Creating minimal configuration..."
        # Fallback to minimal config if template not found
        echo '{"formatting_rules": {"research_questions": {"rule": "MUST end with ?"}}}' > "$MEMORY_FILE"
    fi
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