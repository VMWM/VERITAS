#!/usr/bin/env node

/**
 * Obsidian Journal Generator
 * Generates comprehensive journal entries from conversation logs
 * and posts them to Obsidian via REST API
 */

import Database from 'sqlite3';
import { promisify } from 'util';
import path from 'path';
import os from 'os';
import fetch from 'node-fetch';

const DB_PATH = path.join(os.homedir(), '.conversation-logger', 'conversations.db');
const OBSIDIAN_API_URL = 'https://127.0.0.1:27125'; // Journal vault
const OBSIDIAN_API_TOKEN = process.env.OBSIDIAN_API_TOKEN || 'your-token-here';

class ObsidianJournalGenerator {
  constructor() {
    this.db = null;
  }

  async initialize() {
    const sqlite3 = Database.verbose();
    this.db = new sqlite3.Database(DB_PATH);
    
    this.db.run = promisify(this.db.run);
    this.db.get = promisify(this.db.get);
    this.db.all = promisify(this.db.all);
  }

  async generateEnhancedJournal(date = null) {
    const targetDate = date || new Date().toISOString().split('T')[0];
    
    // Get all sessions for the date
    const sessions = await this.db.all(
      `SELECT * FROM sessions 
       WHERE DATE(start_time) = DATE(?)
       ORDER BY start_time`,
      [targetDate]
    );

    if (sessions.length === 0) {
      return null;
    }

    let journal = `# Daily Research Log: ${targetDate}\n\n`;
    
    // Session Summary
    journal += `## Session Summary\n`;
    journal += `**Total Sessions**: ${sessions.length}\n`;
    journal += `**Primary Focus**: `;
    
    // Analyze primary focus from all sessions
    const primaryTopics = await this.analyzePrimaryFocus(sessions);
    journal += primaryTopics.join(', ') + '\n';
    
    const duration = this.calculateTotalDuration(sessions);
    journal += `**Total Duration**: ${duration}\n\n`;
    
    journal += `---\n\n`;

    // Technical Implementations
    journal += `## Technical Implementations\n\n`;
    
    for (const session of sessions) {
      const implementations = await this.extractImplementations(session.id);
      if (implementations.length > 0) {
        journal += `### Session ${session.id.substring(0, 8)}\n`;
        implementations.forEach(impl => {
          journal += `- ${impl}\n`;
        });
        journal += `\n`;
      }
    }

    // Research Insights & Discoveries
    journal += `## Research Insights & Discoveries\n\n`;
    const insights = await this.extractInsights(sessions);
    insights.forEach(insight => {
      journal += `### ${insight.title}\n`;
      journal += `${insight.content}\n\n`;
    });

    // Problems Solved
    journal += `## Problems Solved\n\n`;
    const problems = await this.extractProblems(sessions);
    problems.forEach(problem => {
      journal += `### ${problem.title}\n`;
      journal += `**Problem**: ${problem.description}\n`;
      journal += `**Solution**: ${problem.solution}\n\n`;
    });

    // Session Metrics
    journal += `## Session Metrics\n\n`;
    journal += `| Metric | Value | Notes |\n`;
    journal += `|--------|-------|-------|\n`;
    
    const metrics = await this.calculateMetrics(sessions);
    metrics.forEach(metric => {
      journal += `| ${metric.name} | ${metric.value} | ${metric.notes || ''} |\n`;
    });
    journal += `\n`;

    // Next Actions
    journal += `## Next Actions\n\n`;
    const nextActions = await this.extractNextActions(sessions);
    if (nextActions.immediate.length > 0) {
      journal += `### Immediate\n`;
      nextActions.immediate.forEach(action => {
        journal += `- ${action}\n`;
      });
      journal += `\n`;
    }

    // References and Links
    journal += `## References\n`;
    journal += `- Memory MCP Database: \`~/.nova-global/memory.db\`\n`;
    journal += `- Conversation Logs: \`~/.conversation-logger/conversations.db\`\n`;
    journal += `- Previous day: [[${this.getPreviousDay(targetDate)}]]\n`;
    journal += `- Next day: [[${this.getNextDay(targetDate)}]]\n\n`;

    journal += `---\n\n`;
    journal += `*Generated: ${new Date().toISOString()}*\n`;
    journal += `*Conversation Logger MCP + Claude Code + Obsidian Integration*\n`;

    return journal;
  }

  async analyzePrimaryFocus(sessions) {
    const topics = [];
    for (const session of sessions) {
      const messages = await this.db.all(
        `SELECT content FROM messages 
         WHERE session_id = ? AND role = 'user'
         LIMIT 5`,
        [session.id]
      );
      
      // Extract main topics from first few user messages
      messages.forEach(msg => {
        if (msg.content && msg.content.length > 20) {
          const topic = this.extractMainTopic(msg.content);
          if (topic) topics.push(topic);
        }
      });
    }
    
    // Return unique topics
    return [...new Set(topics)].slice(0, 3);
  }

  extractMainTopic(content) {
    // Simple topic extraction - enhance with NLP if needed
    const patterns = [
      { pattern: /MCP\s+server/i, topic: '[[Memory MCP]] configuration' },
      { pattern: /journal|log/i, topic: 'Journal generation' },
      { pattern: /obsidian/i, topic: '[[Obsidian]] integration' },
      { pattern: /HLA|antibod/i, topic: '[[HLA Antibodies]] research' },
      { pattern: /grant|F31/i, topic: 'F31 grant preparation' },
      { pattern: /citation|pubmed/i, topic: 'Citation verification' }
    ];
    
    for (const { pattern, topic } of patterns) {
      if (pattern.test(content)) {
        return topic;
      }
    }
    
    return null;
  }

  calculateTotalDuration(sessions) {
    if (sessions.length === 0) return '0 hours';
    
    const first = new Date(sessions[0].start_time);
    const last = sessions[sessions.length - 1].end_time 
      ? new Date(sessions[sessions.length - 1].end_time)
      : new Date();
    
    const hours = Math.round((last - first) / (1000 * 60 * 60) * 10) / 10;
    return `${hours} hours`;
  }

  async extractImplementations(sessionId) {
    const implementations = [];
    
    const activities = await this.db.all(
      `SELECT * FROM activities 
       WHERE session_id = ? AND activity_type IN ('implementation', 'creation', 'configuration')`,
      [sessionId]
    );
    
    activities.forEach(activity => {
      implementations.push(activity.description);
    });
    
    return implementations;
  }

  async extractInsights(sessions) {
    const insights = [];
    
    for (const session of sessions) {
      const messages = await this.db.all(
        `SELECT content FROM messages 
         WHERE session_id = ? AND role = 'assistant' AND content LIKE '%insight%'
         LIMIT 3`,
        [session.id]
      );
      
      messages.forEach(msg => {
        if (msg.content && msg.content.includes('Insight')) {
          insights.push({
            title: 'Key Learning',
            content: this.extractInsightContent(msg.content)
          });
        }
      });
    }
    
    return insights;
  }

  extractInsightContent(content) {
    // Extract content between insight markers
    const match = content.match(/★ Insight[^★]+?([\s\S]+?)─+/);
    return match ? match[1].trim() : content.substring(0, 200);
  }

  async extractProblems(sessions) {
    const problems = [];
    
    for (const session of sessions) {
      const activities = await this.db.all(
        `SELECT * FROM activities 
         WHERE session_id = ? AND activity_type = 'problem_solved'`,
        [session.id]
      );
      
      activities.forEach(activity => {
        try {
          const metadata = JSON.parse(activity.metadata || '{}');
          problems.push({
            title: metadata.title || 'Issue Resolved',
            description: metadata.problem || activity.description,
            solution: metadata.solution || 'See session logs for details'
          });
        } catch (e) {}
      });
    }
    
    return problems;
  }

  async calculateMetrics(sessions) {
    const metrics = [];
    
    // Count messages
    let totalMessages = 0;
    let totalActivities = 0;
    let filesModified = new Set();
    let toolsUsed = new Set();
    
    for (const session of sessions) {
      const msgCount = await this.db.get(
        'SELECT COUNT(*) as count FROM messages WHERE session_id = ?',
        [session.id]
      );
      totalMessages += msgCount.count;
      
      const actCount = await this.db.get(
        'SELECT COUNT(*) as count FROM activities WHERE session_id = ?',
        [session.id]
      );
      totalActivities += actCount.count;
      
      // Get unique files and tools
      const messages = await this.db.all(
        'SELECT files_modified, tools_used FROM messages WHERE session_id = ?',
        [session.id]
      );
      
      messages.forEach(msg => {
        try {
          if (msg.files_modified) {
            JSON.parse(msg.files_modified).forEach(f => filesModified.add(f));
          }
          if (msg.tools_used) {
            JSON.parse(msg.tools_used).forEach(t => toolsUsed.add(t));
          }
        } catch (e) {}
      });
    }
    
    metrics.push({ name: 'Total Messages', value: totalMessages, notes: 'User + Assistant' });
    metrics.push({ name: 'Activities Logged', value: totalActivities, notes: '' });
    metrics.push({ name: 'Files Modified', value: filesModified.size, notes: 'Unique files' });
    metrics.push({ name: 'Tools Used', value: toolsUsed.size, notes: 'Unique tools' });
    metrics.push({ name: 'Sessions', value: sessions.length, notes: '' });
    
    return metrics;
  }

  async extractNextActions(sessions) {
    // Extract TODO items or next steps mentioned in conversations
    const nextActions = {
      immediate: [],
      thisWeek: [],
      future: []
    };
    
    for (const session of sessions) {
      const messages = await this.db.all(
        `SELECT content FROM messages 
         WHERE session_id = ? AND content LIKE '%TODO%' OR content LIKE '%next%'
         LIMIT 5`,
        [session.id]
      );
      
      messages.forEach(msg => {
        const todos = this.extractTodos(msg.content);
        nextActions.immediate.push(...todos);
      });
    }
    
    return nextActions;
  }

  extractTodos(content) {
    const todos = [];
    const lines = content.split('\n');
    
    lines.forEach(line => {
      if (line.includes('TODO') || line.includes('- [ ]')) {
        const todo = line.replace(/.*TODO:|.*\[ \]/, '').trim();
        if (todo.length > 5) {
          todos.push(todo);
        }
      }
    });
    
    return todos;
  }

  getPreviousDay(date) {
    const d = new Date(date);
    d.setDate(d.getDate() - 1);
    return d.toISOString().split('T')[0];
  }

  getNextDay(date) {
    const d = new Date(date);
    d.setDate(d.getDate() + 1);
    return d.toISOString().split('T')[0];
  }

  async postToObsidian(journal, date) {
    const filename = `${date}.md`;
    const endpoint = `/vault/Daily/${filename}`;
    
    try {
      const response = await fetch(`${OBSIDIAN_API_URL}${endpoint}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${OBSIDIAN_API_TOKEN}`,
          'Content-Type': 'text/markdown'
        },
        body: journal,
        // Ignore SSL certificate errors for local Obsidian
        rejectUnauthorized: false
      });
      
      if (response.ok) {
        console.log(`Journal posted to Obsidian: Daily/${filename}`);
        return true;
      } else {
        console.error('Failed to post to Obsidian:', response.statusText);
        return false;
      }
    } catch (error) {
      console.error('Error posting to Obsidian:', error);
      return false;
    }
  }
}

// CLI usage
async function main() {
  const generator = new ObsidianJournalGenerator();
  await generator.initialize();
  
  const date = process.argv[2] || new Date().toISOString().split('T')[0];
  const journal = await generator.generateEnhancedJournal(date);
  
  if (journal) {
    console.log(journal);
    
    // Optionally post to Obsidian
    if (process.argv.includes('--post')) {
      await generator.postToObsidian(journal, date);
    }
  } else {
    console.log(`No sessions found for ${date}`);
  }
}

if (require.main === module) {
  main().catch(console.error);
}

export default ObsidianJournalGenerator;