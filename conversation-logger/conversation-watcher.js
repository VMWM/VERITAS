#!/usr/bin/env node

/**
 * Conversation Watcher Daemon
 * Monitors ~/.claude.json for conversation updates and automatically logs them
 * to the conversation-logger database. Provides truly automatic logging without
 * relying on hooks or MCP tool invocations.
 */

import fs from 'fs/promises';
import fsSync from 'fs';
import path from 'path';
import os from 'os';
import Database from 'sqlite3';
import { promisify } from 'util';
import { v4 as uuidv4 } from 'uuid';
import chokidar from 'chokidar';

const CLAUDE_CONFIG_PATH = path.join(os.homedir(), '.claude.json');
const DB_PATH = path.join(os.homedir(), '.conversation-logger', 'conversations.db');
const STATE_PATH = path.join(os.homedir(), '.conversation-logger', 'watcher-state.json');

class ConversationWatcher {
  constructor() {
    this.db = null;
    this.lastProcessedIndex = {};
    this.currentSessionId = null;
    this.isProcessing = false;
    this.lastCleanupDate = null;
    this.RETENTION_DAYS = 5;
    this.CLEANUP_HOUR = 2; // 2 AM
  }

  async initialize() {
    console.error('[Watcher] Initializing conversation watcher daemon...');

    // Ensure directory exists
    const dbDir = path.dirname(DB_PATH);
    await fs.mkdir(dbDir, { recursive: true });

    // Initialize database
    const sqlite3 = Database.verbose();
    this.db = new sqlite3.Database(DB_PATH);

    // Promisify database methods
    this.db.run = promisify(this.db.run.bind(this.db));
    this.db.get = promisify(this.db.get.bind(this.db));
    this.db.all = promisify(this.db.all.bind(this.db));

    // Load previous state
    await this.loadState();

    console.error('[Watcher] Database connected');
  }

  async loadState() {
    try {
      const stateData = await fs.readFile(STATE_PATH, 'utf-8');
      const state = JSON.parse(stateData);
      this.lastProcessedIndex = state.lastProcessedIndex || {};
      this.currentSessionId = state.currentSessionId;
      this.lastCleanupDate = state.lastCleanupDate || null;
      console.error(`[Watcher] Loaded state: ${Object.keys(this.lastProcessedIndex).length} projects tracked`);
      if (this.lastCleanupDate) {
        console.error(`[Watcher] Last cleanup: ${this.lastCleanupDate}`);
      }
    } catch (error) {
      // First run or state file doesn't exist
      console.error('[Watcher] No previous state found, starting fresh');
      this.lastProcessedIndex = {};
    }
  }

  async saveState() {
    const state = {
      lastProcessedIndex: this.lastProcessedIndex,
      currentSessionId: this.currentSessionId,
      lastCleanupDate: this.lastCleanupDate,
      lastUpdate: new Date().toISOString()
    };
    await fs.writeFile(STATE_PATH, JSON.stringify(state, null, 2));
  }

  async cleanupOldLogs() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - this.RETENTION_DAYS);
    const cutoffISO = cutoffDate.toISOString();

    console.error(`[Watcher] Cleaning up logs older than ${cutoffDate.toLocaleDateString()}...`);

    try {
      // Delete old messages
      await this.db.run(
        `DELETE FROM messages WHERE timestamp < ?`,
        [cutoffISO]
      );

      // Delete old activities
      await this.db.run(
        `DELETE FROM activities WHERE timestamp < ?`,
        [cutoffISO]
      );

      // Delete old sessions that have no messages
      await this.db.run(
        `DELETE FROM sessions
         WHERE start_time < ?
         AND id NOT IN (SELECT DISTINCT session_id FROM messages)`,
        [cutoffISO]
      );

      // Vacuum to reclaim space
      await this.db.run('VACUUM');

      this.lastCleanupDate = new Date().toISOString();
      await this.saveState();

      console.error('[Watcher] Cleanup completed successfully');
    } catch (error) {
      console.error(`[Watcher] Error during cleanup: ${error.message}`);
    }
  }

  async checkAndRunCleanup() {
    const now = new Date();
    const currentHour = now.getHours();
    const today = now.toISOString().split('T')[0];

    // Only run if it's the cleanup hour and we haven't run today
    if (currentHour === this.CLEANUP_HOUR) {
      const lastCleanupDay = this.lastCleanupDate ? this.lastCleanupDate.split('T')[0] : null;

      if (lastCleanupDay !== today) {
        await this.cleanupOldLogs();
      }
    }
  }

  async startNewSession(projectPath) {
    const sessionId = uuidv4();
    await this.db.run(
      'INSERT INTO sessions (id, project_path, start_time) VALUES (?, ?, datetime("now"))',
      [sessionId, projectPath]
    );
    this.currentSessionId = sessionId;
    console.error(`[Watcher] Started new session: ${sessionId} for ${projectPath}`);
    return sessionId;
  }

  async logMessage(sessionId, role, content, toolsUsed = []) {
    // Skip empty or very short messages
    if (!content || content.trim().length < 10) {
      return;
    }

    try {
      await this.db.run(
        `INSERT INTO messages (session_id, role, content, tools_used, timestamp)
         VALUES (?, ?, ?, ?, datetime("now"))`,
        [sessionId, role, content, JSON.stringify(toolsUsed)]
      );
      console.error(`[Watcher] Logged ${role} message (${content.length} chars)`);
    } catch (error) {
      console.error(`[Watcher] Error logging message: ${error.message}`);
    }
  }

  async processConversationHistory(projectPath, history) {
    if (!history || !Array.isArray(history) || history.length === 0) {
      return;
    }

    // Get last processed index for this project
    const lastIndex = this.lastProcessedIndex[projectPath] || -1;

    // Process only new messages
    const newMessages = history.slice(lastIndex + 1);

    if (newMessages.length === 0) {
      return;
    }

    console.error(`[Watcher] Processing ${newMessages.length} new messages for ${projectPath}`);

    // Start new session if needed
    if (!this.currentSessionId) {
      await this.startNewSession(projectPath);
    }

    // Process each new message
    for (let i = 0; i < newMessages.length; i++) {
      const message = newMessages[i];
      const index = lastIndex + 1 + i;

      if (message.role === 'user' || message.role === 'assistant') {
        const content = this.extractMessageContent(message);
        const toolsUsed = this.extractToolsUsed(message);

        await this.logMessage(this.currentSessionId, message.role, content, toolsUsed);
      }

      // Update last processed index
      this.lastProcessedIndex[projectPath] = index;
    }

    // Save state after processing
    await this.saveState();
  }

  extractMessageContent(message) {
    if (typeof message.content === 'string') {
      return message.content;
    }

    if (Array.isArray(message.content)) {
      // Extract text from content blocks
      return message.content
        .filter(block => block.type === 'text')
        .map(block => block.text)
        .join('\n');
    }

    return '';
  }

  extractToolsUsed(message) {
    if (!message.content || !Array.isArray(message.content)) {
      return [];
    }

    return message.content
      .filter(block => block.type === 'tool_use')
      .map(block => block.name);
  }

  async processClaudeConfig() {
    if (this.isProcessing) {
      return; // Avoid concurrent processing
    }

    this.isProcessing = true;

    try {
      // Read Claude config
      const configData = await fs.readFile(CLAUDE_CONFIG_PATH, 'utf-8');
      const config = JSON.parse(configData);

      if (!config.projects) {
        console.error('[Watcher] No projects found in config');
        return;
      }

      // Process each project's history
      for (const [projectPath, projectData] of Object.entries(config.projects)) {
        if (projectData.history && projectData.history.length > 0) {
          await this.processConversationHistory(projectPath, projectData.history);
        }
      }

      // Check if cleanup should run
      await this.checkAndRunCleanup();

    } catch (error) {
      if (error.code !== 'ENOENT') {
        console.error(`[Watcher] Error processing config: ${error.message}`);
      }
    } finally {
      this.isProcessing = false;
    }
  }

  async startWatching() {
    console.error(`[Watcher] Watching ${CLAUDE_CONFIG_PATH} for changes...`);

    // Initial processing
    await this.processClaudeConfig();

    // Watch for file changes
    const watcher = chokidar.watch(CLAUDE_CONFIG_PATH, {
      persistent: true,
      ignoreInitial: true,
      awaitWriteFinish: {
        stabilityThreshold: 500,
        pollInterval: 100
      }
    });

    watcher.on('change', async () => {
      console.error('[Watcher] Config file changed, processing...');
      await this.processClaudeConfig();
    });

    watcher.on('error', error => {
      console.error(`[Watcher] Watcher error: ${error.message}`);
    });

    // Keep process alive
    process.on('SIGINT', async () => {
      console.error('[Watcher] Shutting down...');
      await this.saveState();
      await watcher.close();
      process.exit(0);
    });

    console.error('[Watcher] Daemon running. Press Ctrl+C to stop.');
  }
}

// Main execution
async function main() {
  const watcher = new ConversationWatcher();
  await watcher.initialize();
  await watcher.startWatching();
}

main().catch(error => {
  console.error(`[Watcher] Fatal error: ${error.message}`);
  process.exit(1);
});
