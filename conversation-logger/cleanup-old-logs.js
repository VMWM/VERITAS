#!/usr/bin/env node

/**
 * Cleanup script for conversation-logger
 * Maintains only last 5 days of conversation history
 * Run daily via cron or manually
 */

import Database from 'sqlite3';
import { promisify } from 'util';
import path from 'path';
import os from 'os';

const DB_PATH = path.join(os.homedir(), '.conversation-logger', 'conversations.db');
const RETENTION_DAYS = 5;

async function cleanupOldLogs() {
  const sqlite3 = Database.verbose();
  const db = new sqlite3.Database(DB_PATH);
  
  // Promisify database methods
  db.run = promisify(db.run);
  db.get = promisify(db.get);
  
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - RETENTION_DAYS);
  const cutoffISO = cutoffDate.toISOString();
  
  console.log(`Cleaning up logs older than ${cutoffDate.toLocaleDateString()}`);
  
  try {
    // Delete old messages
    const messagesResult = await db.run(
      `DELETE FROM messages WHERE timestamp < ?`,
      [cutoffISO]
    );
    console.log(`Deleted ${messagesResult?.changes || 0} old messages`);
    
    // Delete old activities
    const activitiesResult = await db.run(
      `DELETE FROM activities WHERE timestamp < ?`,
      [cutoffISO]
    );
    console.log(`Deleted ${activitiesResult?.changes || 0} old activities`);
    
    // Delete old sessions that have no messages
    const sessionsResult = await db.run(
      `DELETE FROM sessions 
       WHERE start_time < ? 
       AND id NOT IN (SELECT DISTINCT session_id FROM messages)`,
      [cutoffISO]
    );
    console.log(`Deleted ${sessionsResult?.changes || 0} old sessions`);
    
    // Vacuum to reclaim space
    await db.run('VACUUM');
    console.log('Database vacuumed');
    
    // Get current database size
    const stats = await db.get(
      `SELECT COUNT(*) as messages, 
              (SELECT COUNT(*) FROM sessions) as sessions,
              (SELECT COUNT(*) FROM activities) as activities
       FROM messages`
    );
    
    console.log('\nCurrent database status:');
    console.log(`  Sessions: ${stats.sessions}`);
    console.log(`  Messages: ${stats.messages}`);
    console.log(`  Activities: ${stats.activities}`);
    
  } catch (error) {
    console.error('Error during cleanup:', error);
  } finally {
    db.close();
  }
}

// Run cleanup
cleanupOldLogs().catch(console.error);