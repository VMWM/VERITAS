#!/bin/bash
#
# Install Conversation Watcher Daemon
# Automatically logs Claude Code conversations to conversation-logger database
#

set -e

echo "=== VERITAS Conversation Watcher Installation ==="
echo ""

# Get paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
LAUNCHAGENTS_DIR="$USER_HOME/Library/LaunchAgents"
PLIST_NAME="com.veritas.conversation-watcher.plist"
PLIST_PATH="$LAUNCHAGENTS_DIR/$PLIST_NAME"

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org"
    exit 1
fi

NODE_PATH=$(which node)
echo "✓ Found Node.js at: $NODE_PATH"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCHAGENTS_DIR"

# Create conversation-logger directory
mkdir -p "$USER_HOME/.conversation-logger"

# Copy and customize plist file
echo "Installing LaunchAgent..."
sed "s|/usr/local/bin/node|$NODE_PATH|g" "$SCRIPT_DIR/$PLIST_NAME" | \
sed "s|USER_HOME|$USER_HOME|g" > "$PLIST_PATH"

echo "✓ LaunchAgent installed at: $PLIST_PATH"

# Unload if already running
if launchctl list | grep -q "com.veritas.conversation-watcher"; then
    echo "Stopping existing watcher..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Load the LaunchAgent
echo "Starting conversation watcher daemon..."
launchctl load "$PLIST_PATH"

# Wait a moment and check if it's running
sleep 2

if launchctl list | grep -q "com.veritas.conversation-watcher"; then
    echo ""
    echo "✓ Conversation watcher daemon installed and running!"
    echo ""
    echo "The daemon will now automatically log all Claude Code conversations."
    echo ""
    echo "Logs location:"
    echo "  - Output: ~/.conversation-logger/watcher.log"
    echo "  - Errors: ~/.conversation-logger/watcher-error.log"
    echo "  - Database: ~/.conversation-logger/conversations.db"
    echo ""
    echo "To stop the daemon:"
    echo "  launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
    echo ""
    echo "To restart the daemon:"
    echo "  launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
    echo "  launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
    echo ""
else
    echo ""
    echo "Warning: Daemon may not have started correctly"
    echo "Check logs at ~/.conversation-logger/watcher-error.log"
    exit 1
fi
