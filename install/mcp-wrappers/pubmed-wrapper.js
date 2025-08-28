#!/usr/bin/env node

/**
 * PubMed MCP Wrapper for VERITAS
 * 
 * This wrapper filters out non-JSON startup messages from the @ncukondo/pubmed-mcp server
 * to ensure compatibility with Claude Desktop's JSON-RPC parser.
 * 
 * Problem: The PubMed MCP server outputs diagnostic text before JSON, causing parsing errors
 * Solution: This wrapper filters output to only pass through valid JSON-RPC messages
 */

const { spawn } = require('child_process');
const readline = require('readline');

// Pass environment variables to the child process
const env = {
  ...process.env,
  PUBMED_EMAIL: process.env.PUBMED_EMAIL,
  PUBMED_API_KEY: process.env.PUBMED_API_KEY,
  PUBMED_CACHE_DIR: process.env.PUBMED_CACHE_DIR,
  PUBMED_CACHE_TTL: process.env.PUBMED_CACHE_TTL
};

// Spawn the actual PubMed MCP server
const pubmedServer = spawn('npx', ['@ncukondo/pubmed-mcp'], {
  env,
  stdio: ['pipe', 'pipe', 'pipe']
});

// Track if we've seen the first JSON line
let jsonStarted = false;

// Create readline interface for stdout
const rlOut = readline.createInterface({
  input: pubmedServer.stdout,
  crlfDelay: Infinity
});

// Filter stdout - skip non-JSON startup messages
rlOut.on('line', (line) => {
  // Check if this line starts with JSON
  if (line.trim().startsWith('{') || line.trim().startsWith('[')) {
    jsonStarted = true;
  }
  
  // Once we've seen JSON, output everything
  if (jsonStarted) {
    console.log(line);
  }
});

// Pass through stderr without filtering
pubmedServer.stderr.on('data', (data) => {
  process.stderr.write(data);
});

// Pass stdin to the child process
process.stdin.pipe(pubmedServer.stdin);

// Handle process exit
pubmedServer.on('exit', (code) => {
  process.exit(code);
});

// Handle errors
pubmedServer.on('error', (err) => {
  console.error('Failed to start PubMed MCP server:', err);
  process.exit(1);
});