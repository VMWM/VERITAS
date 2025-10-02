#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
const readline = require('readline');

// Get the Claude projects directory
const CLAUDE_DIR = path.join(os.homedir(), '.claude', 'projects');

/**
 * MCP Server for reading Claude Code conversation transcripts
 */
class ClaudeTranscriptReader {
  constructor() {
    this.name = 'claude-transcript-reader';
    this.version = '1.0.0';
  }

  /**
   * Find the project directory for the given path
   */
  getProjectDir(projectPath) {
    // Convert path to safe directory name (Claude Code format)
    // Replace / with - and _ with - to match Claude's format
    const safeName = projectPath.replace(/\//g, '-').replace(/_/g, '-');
    return path.join(CLAUDE_DIR, safeName);
  }

  /**
   * Get all JSONL files in a project directory
   */
  async getTranscriptFiles(projectPath) {
    const projectDir = this.getProjectDir(projectPath);

    if (!fs.existsSync(projectDir)) {
      return [];
    }

    const files = fs.readdirSync(projectDir);
    return files
      .filter(f => f.endsWith('.jsonl'))
      .map(f => path.join(projectDir, f));
  }

  /**
   * Read a JSONL file and parse messages
   */
  async readTranscript(filePath, daysAgo = 5) {
    const messages = [];
    const fileStats = fs.statSync(filePath);
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysAgo);

    // Skip files older than retention period
    if (fileStats.mtime < cutoffDate) {
      return { messages: [], sessionId: null, timestamp: null };
    }

    const fileStream = fs.createReadStream(filePath);
    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity
    });

    let sessionId = null;
    let sessionTimestamp = null;

    for await (const line of rl) {
      try {
        const data = JSON.parse(line);

        // Extract session ID from first message
        if (!sessionId && data.sessionId) {
          sessionId = data.sessionId;
        }

        // Extract message data
        if (data.type && data.message) {
          const timestamp = data.timestamp || fileStats.mtime.getTime();

          if (!sessionTimestamp) {
            sessionTimestamp = timestamp;
          }

          messages.push({
            role: data.message.role,
            content: this.extractContent(data.message.content),
            timestamp: timestamp,
            toolsUsed: this.extractToolsUsed(data),
            filesModified: []
          });
        }
      } catch (e) {
        // Skip invalid JSON lines
        continue;
      }
    }

    return { messages, sessionId, timestamp: sessionTimestamp };
  }

  /**
   * Extract text content from message content array
   */
  extractContent(contentArray) {
    if (typeof contentArray === 'string') {
      return contentArray;
    }

    if (Array.isArray(contentArray)) {
      return contentArray
        .filter(item => item.type === 'text')
        .map(item => item.text)
        .join('\n');
    }

    return '';
  }

  /**
   * Extract tools used from message data
   */
  extractToolsUsed(data) {
    const tools = [];

    if (data.message && data.message.content && Array.isArray(data.message.content)) {
      data.message.content.forEach(item => {
        if (item.type === 'tool_use' && item.name) {
          tools.push(item.name);
        }
      });
    }

    return tools;
  }

  /**
   * Get all conversations from the last N days
   */
  async getRecentConversations(projectPath, daysAgo = 5) {
    const files = await this.getTranscriptFiles(projectPath);
    const conversations = [];

    for (const file of files) {
      const transcript = await this.readTranscript(file, daysAgo);
      if (transcript.messages.length > 0) {
        conversations.push({
          sessionId: transcript.sessionId || path.basename(file, '.jsonl'),
          timestamp: transcript.timestamp,
          messageCount: transcript.messages.length,
          messages: transcript.messages,
          filePath: file
        });
      }
    }

    // Sort by timestamp (most recent first)
    conversations.sort((a, b) => b.timestamp - a.timestamp);

    return conversations;
  }

  /**
   * Generate journal entry for a specific date
   */
  async generateJournal(projectPath, dateStr) {
    const conversations = await this.getRecentConversations(projectPath, 5);
    const targetDate = dateStr ? new Date(dateStr) : new Date();
    targetDate.setHours(0, 0, 0, 0);

    const nextDay = new Date(targetDate);
    nextDay.setDate(nextDay.getDate() + 1);

    // Filter conversations for target date
    const dayConversations = conversations.filter(conv => {
      const convDate = new Date(conv.timestamp);
      return convDate >= targetDate && convDate < nextDay;
    });

    if (dayConversations.length === 0) {
      return {
        date: targetDate.toISOString().split('T')[0],
        summary: 'No conversations found for this date.',
        sessionCount: 0,
        totalMessages: 0,
        conversations: []
      };
    }

    // Generate summary
    const totalMessages = dayConversations.reduce((sum, conv) => sum + conv.messageCount, 0);
    const toolsUsed = new Set();

    dayConversations.forEach(conv => {
      conv.messages.forEach(msg => {
        if (msg.toolsUsed) {
          msg.toolsUsed.forEach(tool => toolsUsed.add(tool));
        }
      });
    });

    return {
      date: targetDate.toISOString().split('T')[0],
      summary: `${dayConversations.length} conversation(s) with ${totalMessages} total messages. Tools used: ${Array.from(toolsUsed).join(', ') || 'none'}.`,
      sessionCount: dayConversations.length,
      totalMessages: totalMessages,
      conversations: dayConversations.map(conv => ({
        sessionId: conv.sessionId,
        timestamp: new Date(conv.timestamp).toISOString(),
        messageCount: conv.messageCount,
        preview: conv.messages[0] ? conv.messages[0].content.substring(0, 200) : ''
      }))
    };
  }

  /**
   * Get session stats
   */
  async getSessionStats(projectPath) {
    const conversations = await this.getRecentConversations(projectPath, 5);

    const totalMessages = conversations.reduce((sum, conv) => sum + conv.messageCount, 0);
    const oldestSession = conversations.length > 0 ? conversations[conversations.length - 1] : null;
    const newestSession = conversations.length > 0 ? conversations[0] : null;

    return {
      sessionCount: conversations.length,
      totalMessages: totalMessages,
      oldestSession: oldestSession ? {
        sessionId: oldestSession.sessionId,
        timestamp: new Date(oldestSession.timestamp).toISOString(),
        messageCount: oldestSession.messageCount
      } : null,
      newestSession: newestSession ? {
        sessionId: newestSession.sessionId,
        timestamp: new Date(newestSession.timestamp).toISOString(),
        messageCount: newestSession.messageCount
      } : null
    };
  }

  /**
   * Search conversations
   */
  async searchConversations(projectPath, query, daysAgo = 5) {
    const conversations = await this.getRecentConversations(projectPath, daysAgo);
    const results = [];

    conversations.forEach(conv => {
      conv.messages.forEach((msg, idx) => {
        if (msg.content.toLowerCase().includes(query.toLowerCase())) {
          results.push({
            sessionId: conv.sessionId,
            messageIndex: idx,
            role: msg.role,
            content: msg.content.substring(0, 500),
            timestamp: new Date(msg.timestamp).toISOString()
          });
        }
      });
    });

    return {
      query: query,
      resultCount: results.length,
      results: results.slice(0, 50) // Limit to 50 results
    };
  }

  /**
   * Handle MCP tool calls
   */
  async handleToolCall(toolName, args) {
    const projectPath = args.projectPath || process.cwd();

    switch (toolName) {
      case 'generate_journal':
        return await this.generateJournal(projectPath, args.date);

      case 'get_session_stats':
        return await this.getSessionStats(projectPath);

      case 'search_conversations':
        return await this.searchConversations(projectPath, args.query, args.daysAgo || 5);

      default:
        throw new Error(`Unknown tool: ${toolName}`);
    }
  }

  /**
   * Start MCP server
   */
  start() {
    // MCP stdio server implementation
    const processLine = async (line) => {
      try {
        const request = JSON.parse(line);

        if (request.method === 'initialize') {
          process.stdout.write(JSON.stringify({
            jsonrpc: '2.0',
            id: request.id,
            result: {
              protocolVersion: '2024-11-05',
              serverInfo: {
                name: this.name,
                version: this.version
              },
              capabilities: {
                tools: {}
              }
            }
          }) + '\n');
          // Log to stderr so it appears in Claude logs
          console.error('Claude Transcript Reader MCP Server running on stdio');
        } else if (request.method === 'tools/list') {
          process.stdout.write(JSON.stringify({
            jsonrpc: '2.0',
            id: request.id,
            result: {
              tools: [
                {
                  name: 'generate_journal',
                  description: 'Generate a daily journal entry from conversation transcripts',
                  inputSchema: {
                    type: 'object',
                    properties: {
                      projectPath: {
                        type: 'string',
                        description: 'Project path (optional, defaults to current directory)'
                      },
                      date: {
                        type: 'string',
                        description: 'Date in YYYY-MM-DD format (optional, defaults to today)'
                      }
                    }
                  }
                },
                {
                  name: 'get_session_stats',
                  description: 'Get statistics about recent conversation sessions',
                  inputSchema: {
                    type: 'object',
                    properties: {
                      projectPath: {
                        type: 'string',
                        description: 'Project path (optional, defaults to current directory)'
                      }
                    }
                  }
                },
                {
                  name: 'search_conversations',
                  description: 'Search through recent conversations',
                  inputSchema: {
                    type: 'object',
                    properties: {
                      projectPath: {
                        type: 'string',
                        description: 'Project path (optional, defaults to current directory)'
                      },
                      query: {
                        type: 'string',
                        description: 'Search query'
                      },
                      daysAgo: {
                        type: 'number',
                        description: 'Number of days to search back (default: 5)'
                      }
                    },
                    required: ['query']
                  }
                }
              ]
            }
          }) + '\n');
        } else if (request.method === 'tools/call') {
          const result = await this.handleToolCall(request.params.name, request.params.arguments || {});
          process.stdout.write(JSON.stringify({
            jsonrpc: '2.0',
            id: request.id,
            result: {
              content: [
                {
                  type: 'text',
                  text: JSON.stringify(result, null, 2)
                }
              ]
            }
          }) + '\n');
        }
      } catch (error) {
        process.stdout.write(JSON.stringify({
          jsonrpc: '2.0',
          id: null,
          error: {
            code: -32603,
            message: error.message
          }
        }) + '\n');
      }
    };

    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      terminal: false
    });

    rl.on('line', processLine);
  }
}

// Start server
const server = new ClaudeTranscriptReader();
server.start();
