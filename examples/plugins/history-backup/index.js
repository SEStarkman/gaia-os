const { readFileSync, writeFileSync, mkdirSync, existsSync, readdirSync, unlinkSync } = require('fs');
const { join, basename } = require('path');
const os = require('os');

const MAX_BACKUPS = 5; // Only keep the last N backup files

/**
 * Parse a session JSONL file and extract conversation messages
 */
function parseSessionFile(sessionFilePath) {
  if (!existsSync(sessionFilePath)) {
    return { messages: [], metadata: null };
  }

  const content = readFileSync(sessionFilePath, 'utf-8');
  const lines = content.trim().split('\n');
  
  const messages = [];
  let metadata = null;

  for (const line of lines) {
    if (!line.trim()) continue;
    
    try {
      const entry = JSON.parse(line);
      
      // First line is session metadata
      if (entry.type === 'session') {
        metadata = entry;
        continue;
      }
      
      // Extract messages
      if (entry.type === 'message' && entry.message) {
        const msg = entry.message;
        const role = msg.role;
        
        if (role === 'user' || role === 'assistant') {
          let text = '';
          
          if (Array.isArray(msg.content)) {
            // Handle content array
            for (const block of msg.content) {
              if (block.type === 'text') {
                text += block.text + '\n';
              } else if (block.type === 'tool_use') {
                text += `[Tool: ${block.name}]\n`;
              } else if (block.type === 'tool_result') {
                text += `[Tool Result]\n`;
              }
            }
          } else if (typeof msg.content === 'string') {
            text = msg.content;
          }
          
          if (text.trim()) {
            messages.push({
              id: entry.id,
              parentId: entry.parentId,
              role,
              content: text.trim(),
              timestamp: entry.timestamp || msg.timestamp
            });
          }
        }
      }
      
      // Also capture compaction summaries
      if (entry.type === 'compaction') {
        messages.push({
          id: entry.id,
          parentId: entry.parentId,
          role: 'system',
          content: `[COMPACTION SUMMARY]\n${entry.summary || 'No summary available'}`,
          timestamp: entry.timestamp,
          isCompaction: true
        });
      }
    } catch (e) {
      // Skip invalid JSON lines
    }
  }

  return { messages, metadata };
}

/**
 * Format messages into readable markdown
 */
function formatAsMarkdown(messages, metadata, sessionKey) {
  const now = new Date();
  const dateStr = now.toISOString().split('T')[0];
  const timeStr = now.toISOString().split('T')[1].split('.')[0];
  
  const lines = [
    `# Conversation Backup`,
    ``,
    `**Backed up at:** ${dateStr} ${timeStr} UTC`,
    `**Session Key:** ${sessionKey || 'unknown'}`,
    `**Session ID:** ${metadata?.id || 'unknown'}`,
    `**Total Messages:** ${messages.length}`,
    ``,
    `---`,
    ``
  ];
  
  for (const msg of messages) {
    const roleLabel = msg.role === 'user' ? '## 👤 User' : 
                      msg.role === 'assistant' ? '## 🤖 Assistant' : 
                      '## 📋 System';
    
    lines.push(roleLabel);
    if (msg.timestamp) {
      lines.push(`*${new Date(msg.timestamp).toISOString()}*`);
    }
    lines.push('');
    lines.push(msg.content);
    lines.push('');
    lines.push('---');
    lines.push('');
  }
  
  return lines.join('\n');
}

/**
 * Plugin registration
 */
module.exports = function register(api) {
  api.logger.info('[history-backup] Registering before_compaction hook');
  
  // Register the before_compaction hook
  api.registerHook('before_compaction', async (event, ctx) => {
    try {
      const sessionFile = event.sessionFile;
      const sessionKey = event.sessionKey || 'unknown';
      const sessionId = event.sessionId || basename(sessionFile || '').replace('.jsonl', '');
      
      api.logger.info(`[history-backup] Compaction triggered for session: ${sessionKey}`);
      
      if (!sessionFile || !existsSync(sessionFile)) {
        api.logger.warn('[history-backup] No session file found, skipping backup');
        return;
      }
      
      // Parse the session file
      const { messages, metadata } = parseSessionFile(sessionFile);
      
      if (messages.length === 0) {
        api.logger.info('[history-backup] No messages to backup');
        return;
      }
      
      api.logger.info(`[history-backup] Found ${messages.length} messages to backup`);
      
      // Determine output directory
      const workspaceDir = ctx?.workspaceDir || process.cwd();
      const outputDir = join(workspaceDir, 'memory', 'history');
      mkdirSync(outputDir, { recursive: true });
      
      // Generate filename
      const now = new Date();
      const dateStr = now.toISOString().split('T')[0];
      const timeStr = now.toISOString().split('T')[1].split('.')[0].replace(/:/g, '');
      const safeSessionKey = sessionKey.replace(/[^a-zA-Z0-9-_]/g, '_').slice(0, 50);
      const filename = `${dateStr}-${timeStr}-${safeSessionKey}.md`;
      const outputPath = join(outputDir, filename);
      
      // Format and save
      const markdown = formatAsMarkdown(messages, metadata, sessionKey);
      writeFileSync(outputPath, markdown, 'utf-8');
      
      const relPath = outputPath.replace(os.homedir(), '~');
      api.logger.info(`[history-backup] Conversation saved to ${relPath}`);
      
      // Cleanup old backups - keep only the last MAX_BACKUPS
      try {
        const files = readdirSync(outputDir)
          .filter(f => f.endsWith('.md'))
          .sort()
          .reverse(); // Newest first (filenames are date-sorted)
        
        if (files.length > MAX_BACKUPS) {
          const toDelete = files.slice(MAX_BACKUPS);
          for (const file of toDelete) {
            unlinkSync(join(outputDir, file));
            api.logger.info(`[history-backup] Deleted old backup: ${file}`);
          }
        }
      } catch (cleanupErr) {
        api.logger.warn(`[history-backup] Cleanup failed: ${cleanupErr.message}`);
      }
      
    } catch (err) {
      api.logger.error(`[history-backup] Failed to backup history: ${err.message}`);
    }
  }, { name: 'history-backup-compaction' });
};

module.exports.id = 'history-backup';
module.exports.name = 'History Backup';
