#!/bin/bash
#
# Install Transcript Cleanup LaunchAgent
# Runs daily at 2 AM to delete transcripts older than 5 days
#

set -e

echo "=== VERITAS Transcript Cleanup Installation ==="
echo ""

# Get paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
LAUNCHAGENTS_DIR="$USER_HOME/Library/LaunchAgents"
PLIST_NAME="com.veritas.transcript-cleanup.plist"
PLIST_PATH="$LAUNCHAGENTS_DIR/$PLIST_NAME"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCHAGENTS_DIR"

# Create conversation-logger directory for logs
mkdir -p "$USER_HOME/.conversation-logger"

# Copy and customize plist file
echo "Installing LaunchAgent..."
sed "s|USER_HOME|$USER_HOME|g" "$SCRIPT_DIR/$PLIST_NAME" > "$PLIST_PATH"

echo "✓ LaunchAgent installed at: $PLIST_PATH"

# Unload if already running
if launchctl list | grep -q "com.veritas.transcript-cleanup"; then
    echo "Stopping existing cleanup task..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Load the LaunchAgent
echo "Starting cleanup task..."
launchctl load "$PLIST_PATH"

echo ""
echo "✓ Transcript cleanup installed successfully!"
echo ""
echo "The cleanup task will run daily at 2 AM and delete transcript files older than 5 days."
echo ""
echo "Logs location:"
echo "  - Output: ~/.conversation-logger/cleanup.log"
echo "  - Errors: ~/.conversation-logger/cleanup-error.log"
echo ""
echo "To uninstall:"
echo "  launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "  rm ~/Library/LaunchAgents/$PLIST_NAME"
echo ""
