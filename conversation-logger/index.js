#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import Database from 'sqlite3';
import { promisify } from 'util';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';
import fs from 'fs/promises';
import os from 'os';

const DB_PATH = path.join(os.homedir(), '.conversation-logger', 'conversations.db');

class ConversationLogger {
  constructor() {
    this.db = null;
    this.currentSessionId = null;
    this.sessionStartTime = null;
  }

  async initialize() {
    // Ensure directory exists
    const dbDir = path.dirname(DB_PATH);
    await fs.mkdir(dbDir, { recursive: true });

    // Initialize database
    const sqlite3 = Database.verbose();
    this.db = new sqlite3.Database(DB_PATH);
    
    // Promisify database methods
    this.db.run = promisify(this.db.run);
    this.db.get = promisify(this.db.get);
    this.db.all = promisify(this.db.all);

    // Create tables
    await this.db.run(`
      CREATE TABLE IF NOT EXISTS sessions (
        id TEXT PRIMARY KEY,
        start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        end_time DATETIME,
        project_path TEXT,
        summary TEXT
      )
    `);

    await this.db.run(`
      CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        role TEXT,
        content TEXT,
        tools_used TEXT,
        files_modified TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions (id)
      )
    `);

    await this.db.run(`
      CREATE TABLE IF NOT EXISTS activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        activity_type TEXT,
        description TEXT,
        metadata TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions (id)
      )
    `);

    // Start new session
    await this.startSession();
  }

  async startSession() {
    this.currentSessionId = uuidv4();
    this.sessionStartTime = new Date();
    const projectPath = process.cwd();
    
    await this.db.run(
      'INSERT INTO sessions (id, project_path) VALUES (?, ?)',
      [this.currentSessionId, projectPath]
    );
    
    return this.currentSessionId;
  }

  async logMessage(role, content, toolsUsed = [], filesModified = []) {
    if (!this.currentSessionId) {
      await this.startSession();
    }

    await this.db.run(
      `INSERT INTO messages (session_id, role, content, tools_used, files_modified) 
       VALUES (?, ?, ?, ?, ?)`,
      [
        this.currentSessionId,
        role,
        content,
        JSON.stringify(toolsUsed),
        JSON.stringify(filesModified)
      ]
    );
  }

  async logActivity(activityType, description, metadata = {}) {
    if (!this.currentSessionId) {
      await this.startSession();
    }

    await this.db.run(
      `INSERT INTO activities (session_id, activity_type, description, metadata) 
       VALUES (?, ?, ?, ?)`,
      [
        this.currentSessionId,
        activityType,
        description,
        JSON.stringify(metadata)
      ]
    );
  }

  async generateJournal(date = null) {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    // Get all sessions for the date
    const sessions = await this.db.all(
      `SELECT * FROM sessions 
       WHERE DATE(start_time) = DATE(?)
       ORDER BY start_time`,
      [targetDate]
    );

    if (sessions.length === 0) {
      return `No sessions found for ${targetDate}`;
    }

    let journal = `# Daily Research Log: ${targetDate}\n\n`;
    journal += `## Sessions Summary\n`;
    journal += `**Total Sessions**: ${sessions.length}\n\n`;

    for (const session of sessions) {
      journal += `---\n\n`;
      journal += `### Session ${session.id.substring(0, 8)}\n`;
      journal += `**Start Time**: ${session.start_time}\n`;
      journal += `**Project**: ${session.project_path}\n\n`;

      // Get messages for this session
      const messages = await this.db.all(
        `SELECT * FROM messages 
         WHERE session_id = ?
         ORDER BY timestamp`,
        [session.id]
      );

      // Get activities for this session
      const activities = await this.db.all(
        `SELECT * FROM activities 
         WHERE session_id = ?
         ORDER BY timestamp`,
        [session.id]
      );

      // Analyze conversation topics
      const topics = this.extractTopics(messages);
      if (topics.length > 0) {
        journal += `#### Key Topics\n`;
        topics.forEach(topic => {
          journal += `- ${topic}\n`;
        });
        journal += `\n`;
      }

      // List tools used
      const toolsUsed = this.extractTools(messages);
      if (toolsUsed.size > 0) {
        journal += `#### Tools Used\n`;
        Array.from(toolsUsed).forEach(tool => {
          journal += `- ${tool}\n`;
        });
        journal += `\n`;
      }

      // List files modified
      const filesModified = this.extractFiles(messages);
      if (filesModified.size > 0) {
        journal += `#### Files Modified\n`;
        Array.from(filesModified).forEach(file => {
          journal += `- ${file}\n`;
        });
        journal += `\n`;
      }

      // Include activities
      if (activities.length > 0) {
        journal += `#### Activities\n`;
        activities.forEach(activity => {
          journal += `- **${activity.activity_type}**: ${activity.description}\n`;
        });
        journal += `\n`;
      }

      // Generate conversation summary
      const summary = this.summarizeConversation(messages);
      if (summary) {
        journal += `#### Conversation Summary\n`;
        journal += `${summary}\n\n`;
      }
    }

    journal += `---\n\n`;
    journal += `*Generated: ${new Date().toISOString()}*\n`;
    journal += `*Session Logger MCP + Claude Code*\n`;

    return journal;
  }

  extractTopics(messages) {
    // Simple topic extraction - can be enhanced with NLP
    const topics = new Set();
    messages.forEach(msg => {
      if (msg.role === 'user' && msg.content) {
        // Extract first 50 chars of user messages as topics
        const topic = msg.content.substring(0, 80).replace(/\n/g, ' ').trim();
        if (topic.length > 10) {
          topics.add(topic + (msg.content.length > 80 ? '...' : ''));
        }
      }
    });
    return Array.from(topics);
  }

  extractTools(messages) {
    const tools = new Set();
    messages.forEach(msg => {
      if (msg.tools_used) {
        try {
          const toolList = JSON.parse(msg.tools_used);
          toolList.forEach(tool => tools.add(tool));
        } catch (e) {}
      }
    });
    return tools;
  }

  extractFiles(messages) {
    const files = new Set();
    messages.forEach(msg => {
      if (msg.files_modified) {
        try {
          const fileList = JSON.parse(msg.files_modified);
          fileList.forEach(file => files.add(file));
        } catch (e) {}
      }
    });
    return files;
  }

  summarizeConversation(messages) {
    // Create a basic summary from messages
    const userMessages = messages.filter(m => m.role === 'user').length;
    const assistantMessages = messages.filter(m => m.role === 'assistant').length;
    
    return `Total exchanges: ${userMessages} user messages, ${assistantMessages} assistant responses`;
  }

  async getSessionStats() {
    const today = new Date().toISOString().split('T')[0];
    
    const stats = {
      currentSessionId: this.currentSessionId,
      sessionStartTime: this.sessionStartTime,
      todaySessions: await this.db.get(
        'SELECT COUNT(*) as count FROM sessions WHERE DATE(start_time) = DATE(?)',
        [today]
      ),
      todayMessages: await this.db.get(
        'SELECT COUNT(*) as count FROM messages WHERE DATE(timestamp) = DATE(?)',
        [today]
      ),
      totalSessions: await this.db.get(
        'SELECT COUNT(*) as count FROM sessions'
      ),
      totalMessages: await this.db.get(
        'SELECT COUNT(*) as count FROM messages'
      )
    };
    
    return stats;
  }
}

// Initialize server
const logger = new ConversationLogger();
const server = new Server(
  {
    name: 'conversation-logger',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Handle tool listing
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'log_message',
        description: 'Log a conversation message',
        inputSchema: {
          type: 'object',
          properties: {
            role: { type: 'string', enum: ['user', 'assistant', 'system'] },
            content: { type: 'string' },
            tools_used: { type: 'array', items: { type: 'string' } },
            files_modified: { type: 'array', items: { type: 'string' } }
          },
          required: ['role', 'content']
        }
      },
      {
        name: 'log_activity',
        description: 'Log an activity or event',
        inputSchema: {
          type: 'object',
          properties: {
            activity_type: { type: 'string' },
            description: { type: 'string' },
            metadata: { type: 'object' }
          },
          required: ['activity_type', 'description']
        }
      },
      {
        name: 'generate_journal',
        description: 'Generate a journal entry for a specific date',
        inputSchema: {
          type: 'object',
          properties: {
            date: { type: 'string', description: 'Date in YYYY-MM-DD format (optional, defaults to today)' }
          }
        }
      },
      {
        name: 'get_session_stats',
        description: 'Get statistics about logged sessions',
        inputSchema: {
          type: 'object',
          properties: {}
        }
      },
      {
        name: 'start_new_session',
        description: 'Start a new logging session',
        inputSchema: {
          type: 'object',
          properties: {}
        }
      }
    ]
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'log_message':
      await logger.logMessage(
        args.role,
        args.content,
        args.tools_used || [],
        args.files_modified || []
      );
      return {
        content: [{ type: 'text', text: 'Message logged successfully' }]
      };

    case 'log_activity':
      await logger.logActivity(
        args.activity_type,
        args.description,
        args.metadata || {}
      );
      return {
        content: [{ type: 'text', text: 'Activity logged successfully' }]
      };

    case 'generate_journal':
      const journal = await logger.generateJournal(args.date);
      return {
        content: [{ type: 'text', text: journal }]
      };

    case 'get_session_stats':
      const stats = await logger.getSessionStats();
      return {
        content: [{ type: 'text', text: JSON.stringify(stats, null, 2) }]
      };

    case 'start_new_session':
      const sessionId = await logger.startSession();
      return {
        content: [{ type: 'text', text: `New session started: ${sessionId}` }]
      };

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// Start the server
async function main() {
  await logger.initialize();
  
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Conversation Logger MCP Server running...');
}

main().catch(console.error);