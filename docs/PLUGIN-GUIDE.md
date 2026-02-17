# Building OpenClaw Plugins

A guide to creating plugins that extend what your AI agent can do.

---

## What Is a Plugin?

A plugin is a small program that hooks into OpenClaw events. When something happens (like a conversation getting too long and being compacted), your plugin can run custom code in response.

Think of it like a notification system. OpenClaw says "hey, this event just happened," and your plugin responds with whatever action you want: saving a backup, checking a rule, loading extra memory, or anything else.

**Plugins are different from skills.** A skill is a markdown file that teaches your agent how to use a tool (like Twitter or Notion). A plugin is JavaScript code that runs automatically when specific events occur. Skills are instructions for the agent. Plugins are code that runs alongside the agent.

---

## Where Plugins Live

Plugins live in the OpenClaw extensions folder:

```
~/.openclaw/extensions/
├── history-backup/
│   ├── index.js
│   └── openclaw.plugin.json
├── memory-loader/
│   ├── index.js
│   └── openclaw.plugin.json
└── rule-checker/
    ├── index.js
    └── openclaw.plugin.json
```

Each plugin gets its own folder inside `~/.openclaw/extensions/`. The folder name is the plugin's identifier.

---

## Required Files

Every plugin needs exactly two files:

### 1. openclaw.plugin.json

This is the plugin's metadata. It tells OpenClaw what the plugin is, what version it is, and what settings it accepts.

```json
{
  "id": "my-plugin",
  "name": "My Plugin",
  "version": "1.0.0",
  "description": "A short description of what this plugin does",
  "main": "index.js",
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "enabled": {
        "type": "boolean",
        "default": true
      }
    }
  }
}
```

**Fields explained:**

- **id**: A unique identifier for your plugin. Use lowercase with dashes (like `my-plugin`).
- **name**: A human-readable name. This shows up in logs and status displays.
- **version**: Standard version numbering (major.minor.patch).
- **description**: What your plugin does, in one sentence.
- **main**: The JavaScript file to load. Almost always `index.js`.
- **configSchema**: Optional. Defines what settings your plugin accepts. Uses JSON Schema format. If your plugin needs custom settings (like an output directory or a threshold number), define them here.

### 2. index.js

This is the actual code. It exports a function that receives the OpenClaw plugin API and registers hooks (event listeners).

```javascript
module.exports = function register(api) {
  // Register a hook for an event
  api.registerHook('event_name', async (event, ctx) => {
    // Your code runs when this event fires
    api.logger.info('Something happened!');
  }, { name: 'my-hook-name' });
};

// Required: unique identifier
module.exports.id = 'my-plugin';
// Required: display name
module.exports.name = 'My Plugin';
```

---

## Registering Your Plugin

After creating the plugin files, you need to tell OpenClaw about it. Add an entry to your `~/.openclaw/openclaw.json` file, inside the `plugins.entries` section:

```json
{
  "plugins": {
    "entries": {
      "my-plugin": {
        "enabled": true
      }
    }
  }
}
```

If your plugin has custom settings (defined in `configSchema`), you can pass them here:

```json
{
  "plugins": {
    "entries": {
      "my-plugin": {
        "enabled": true,
        "config": {
          "outputDir": "/custom/path",
          "maxRetries": 3
        }
      }
    }
  }
}
```

After adding the entry, restart the gateway for your plugin to load:

```bash
openclaw gateway restart
```

---

## Available Hooks

Hooks are the events your plugin can listen for. Here are the ones currently available:

### before_compaction

Fires right before OpenClaw compacts (summarizes and shortens) a conversation that has gotten too long. This is the most commonly used hook.

**Why it matters:** When a conversation is compacted, the original messages are replaced with a summary. If you want to preserve the full conversation, this is your chance to save it before it gets shortened.

**Event data:**
- `event.sessionFile`: Path to the session's JSONL file (the raw conversation data)
- `event.sessionKey`: The session identifier (like `main` or `discord:general`)
- `event.sessionId`: A unique ID for this specific session

**Context data:**
- `ctx.workspaceDir`: Path to the agent's workspace folder

---

## Example: History Backup Plugin

Here is a real, working plugin that saves a copy of the full conversation before it gets compacted. This way, you never lose context even when conversations get shortened.

### openclaw.plugin.json

```json
{
  "id": "history-backup",
  "name": "History Backup",
  "version": "1.0.0",
  "description": "Saves full conversation history before compaction so context is never lost",
  "main": "index.js",
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "enabled": {
        "type": "boolean",
        "default": true
      },
      "outputDir": {
        "type": "string",
        "description": "Directory to save history backups (default: workspace/memory/history)"
      }
    }
  }
}
```

### index.js

This plugin does three things when a conversation is about to be compacted:

1. Reads the raw session file (which contains the full conversation in JSONL format)
2. Converts it into a readable markdown document
3. Saves it to `memory/history/` with a timestamped filename

It also cleans up old backups, keeping only the 5 most recent ones.

```javascript
const { readFileSync, writeFileSync, mkdirSync, existsSync,
        readdirSync, unlinkSync } = require('fs');
const { join, basename } = require('path');
const os = require('os');

const MAX_BACKUPS = 5;

/**
 * Parse a session JSONL file and pull out the conversation messages.
 * JSONL means each line is a separate JSON object.
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

      if (entry.type === 'session') {
        metadata = entry;
        continue;
      }

      if (entry.type === 'message' && entry.message) {
        const msg = entry.message;
        const role = msg.role;

        if (role === 'user' || role === 'assistant') {
          let text = '';

          if (Array.isArray(msg.content)) {
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
              role,
              content: text.trim(),
              timestamp: entry.timestamp || msg.timestamp
            });
          }
        }
      }

      if (entry.type === 'compaction') {
        messages.push({
          role: 'system',
          content: `[COMPACTION SUMMARY]\n${entry.summary || 'No summary available'}`,
          timestamp: entry.timestamp,
        });
      }
    } catch (e) {
      // Skip lines that are not valid JSON
    }
  }

  return { messages, metadata };
}

/**
 * Turn the parsed messages into a readable markdown file.
 */
function formatAsMarkdown(messages, metadata, sessionKey) {
  const now = new Date();
  const dateStr = now.toISOString().split('T')[0];
  const timeStr = now.toISOString().split('T')[1].split('.')[0];

  const lines = [
    '# Conversation Backup',
    '',
    `**Backed up at:** ${dateStr} ${timeStr} UTC`,
    `**Session Key:** ${sessionKey || 'unknown'}`,
    `**Session ID:** ${metadata?.id || 'unknown'}`,
    `**Total Messages:** ${messages.length}`,
    '',
    '---',
    ''
  ];

  for (const msg of messages) {
    const label = msg.role === 'user' ? '## User'
               : msg.role === 'assistant' ? '## Assistant'
               : '## System';

    lines.push(label);
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
 * Register the plugin with OpenClaw.
 */
module.exports = function register(api) {
  api.logger.info('[history-backup] Registering before_compaction hook');

  api.registerHook('before_compaction', async (event, ctx) => {
    try {
      const sessionFile = event.sessionFile;
      const sessionKey = event.sessionKey || 'unknown';

      api.logger.info(`[history-backup] Compaction triggered for session: ${sessionKey}`);

      if (!sessionFile || !existsSync(sessionFile)) {
        api.logger.warn('[history-backup] No session file found, skipping backup');
        return;
      }

      const { messages, metadata } = parseSessionFile(sessionFile);

      if (messages.length === 0) {
        api.logger.info('[history-backup] No messages to backup');
        return;
      }

      // Determine where to save
      const workspaceDir = ctx?.workspaceDir || process.cwd();
      const outputDir = join(workspaceDir, 'memory', 'history');
      mkdirSync(outputDir, { recursive: true });

      // Generate a timestamped filename
      const now = new Date();
      const dateStr = now.toISOString().split('T')[0];
      const timeStr = now.toISOString().split('T')[1].split('.')[0].replace(/:/g, '');
      const safeKey = sessionKey.replace(/[^a-zA-Z0-9-_]/g, '_').slice(0, 50);
      const filename = `${dateStr}-${timeStr}-${safeKey}.md`;
      const outputPath = join(outputDir, filename);

      // Save the backup
      const markdown = formatAsMarkdown(messages, metadata, sessionKey);
      writeFileSync(outputPath, markdown, 'utf-8');
      api.logger.info(`[history-backup] Saved ${messages.length} messages to ${filename}`);

      // Clean up old backups, keep only the most recent ones
      try {
        const files = readdirSync(outputDir)
          .filter(f => f.endsWith('.md'))
          .sort()
          .reverse();

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
      api.logger.error(`[history-backup] Failed: ${err.message}`);
    }
  }, { name: 'history-backup-compaction' });
};

module.exports.id = 'history-backup';
module.exports.name = 'History Backup';
```

### Registration in openclaw.json

```json
{
  "plugins": {
    "entries": {
      "history-backup": {
        "enabled": true
      }
    }
  }
}
```

---

## The Plugin API

When your plugin's `register` function is called, it receives an `api` object with these tools:

### api.registerHook(eventName, handler, options)

Registers a function to run when a specific event fires.

- **eventName**: The event to listen for (like `'before_compaction'`)
- **handler**: An async function that receives `(event, ctx)`
  - `event`: Data about what happened (varies by hook type)
  - `ctx`: Context about the current environment (workspace directory, etc.)
- **options**: An object with a `name` property to identify your hook in logs

### api.logger

A logging object for writing to OpenClaw's log output. Use this instead of `console.log` so your messages show up properly in `openclaw logs`.

- `api.logger.info('message')`: General information
- `api.logger.warn('message')`: Warnings (something unexpected but not broken)
- `api.logger.error('message')`: Errors (something went wrong)

---

## Building Your Own Plugin: Step by Step

### 1. Create the folder

```bash
mkdir -p ~/.openclaw/extensions/my-plugin
```

### 2. Create openclaw.plugin.json

```bash
cat > ~/.openclaw/extensions/my-plugin/openclaw.plugin.json << 'EOF'
{
  "id": "my-plugin",
  "name": "My Plugin",
  "version": "1.0.0",
  "description": "What your plugin does",
  "main": "index.js"
}
EOF
```

### 3. Create index.js

```bash
cat > ~/.openclaw/extensions/my-plugin/index.js << 'EOF'
module.exports = function register(api) {
  api.logger.info('[my-plugin] Loaded successfully');

  api.registerHook('before_compaction', async (event, ctx) => {
    api.logger.info('[my-plugin] Compaction is about to happen!');
    // Your custom logic here
  }, { name: 'my-plugin-hook' });
};

module.exports.id = 'my-plugin';
module.exports.name = 'My Plugin';
EOF
```

### 4. Register it in openclaw.json

Open `~/.openclaw/openclaw.json` and add your plugin to the `plugins.entries` section:

```json
"my-plugin": {
  "enabled": true
}
```

### 5. Restart and test

```bash
openclaw gateway restart
openclaw logs --follow
```

Watch the logs for your `[my-plugin] Loaded successfully` message. If you see it, your plugin is running.

---

## Testing and Debugging Tips

**Check the logs.** Use `openclaw logs --follow` to watch your plugin's output in real time. Every `api.logger` call shows up here.

**Use descriptive log prefixes.** Start every log message with your plugin name in brackets, like `[my-plugin]`. This makes it easy to filter your messages from everything else in the logs.

**Test with small changes.** Get the basic structure working first (just a log message in the hook). Then add your actual logic piece by piece.

**Handle errors gracefully.** Wrap your hook logic in a try/catch block. A crashing plugin can affect the whole system. Log the error and move on.

**Check file paths.** If your plugin reads or writes files, always verify paths exist before using them. Use `existsSync()` from Node.js and create directories with `mkdirSync(outputDir, { recursive: true })`.

**Restart after changes.** Plugins are loaded when the gateway starts. After editing your plugin code, run `openclaw gateway restart` to pick up the changes.

---

## Plugin Ideas

Here are some plugins you could build:

- **Daily summary exporter:** Save a summary of each day's conversations to a file at midnight.
- **Notification filter:** Block or modify certain types of notifications before they reach your agent.
- **Context injector:** Automatically load extra context files before specific types of conversations.
- **Usage tracker:** Log how many messages and tokens are used per session for cost monitoring.
- **Backup rotator:** Save workspace snapshots on a schedule.

---

## Quick Reference

| What | Where |
|------|-------|
| Plugin folder | `~/.openclaw/extensions/your-plugin/` |
| Required files | `index.js` + `openclaw.plugin.json` |
| Registration | `~/.openclaw/openclaw.json` under `plugins.entries` |
| Logs | `openclaw logs --follow` |
| Restart after changes | `openclaw gateway restart` |
