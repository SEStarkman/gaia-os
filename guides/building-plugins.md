# Building Plugins

A plugin is a small program that hooks into OpenClaw events. When something happens (like a conversation getting too long and being compacted), your plugin can run custom code in response: saving a backup, checking a rule, loading extra memory, or anything else.

**Plugins are different from skills.** A skill is a markdown file that teaches your agent how to use a tool (like Twitter or Notion). A plugin is JavaScript code that runs automatically when specific events occur. Skills are instructions for the agent. Plugins are code that runs alongside the agent.

---

## Where Plugins Live

Plugins live in the OpenClaw extensions folder:

```
~/.openclaw/extensions/
├── history-backup/
│   ├── index.js
│   └── openclaw.plugin.json
└── my-other-plugin/
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

- **id**: A unique identifier. Use lowercase with dashes (like `my-plugin`).
- **name**: A human-readable name. Shows up in logs and status displays.
- **version**: Standard version numbering (major.minor.patch).
- **description**: What your plugin does, in one sentence.
- **main**: The JavaScript file to load. Almost always `index.js`.
- **configSchema**: Optional. Defines what settings your plugin accepts using JSON Schema format. If your plugin needs custom settings (like an output directory or a threshold number), define them here.

### 2. index.js

The actual code. It exports a function that receives the OpenClaw plugin API and registers hooks (event listeners).

```javascript
module.exports = function register(api) {
  api.registerHook('event_name', async (event, ctx) => {
    api.logger.info('Something happened!');
  }, { name: 'my-hook-name' });
};

module.exports.id = 'my-plugin';
module.exports.name = 'My Plugin';
```

---

## Registering Your Plugin

After creating the plugin files, tell OpenClaw about it. Add an entry to your `~/.openclaw/openclaw.json` file, inside the `plugins.entries` section:

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

If your plugin has custom settings (defined in `configSchema`), pass them here:

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

After adding the entry, restart the gateway so your plugin loads:

```bash
openclaw gateway restart
```

---

## Available Hooks

Hooks are the events your plugin can listen for.

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

## The Plugin API

When your plugin's `register` function is called, it receives an `api` object with these tools:

### api.registerHook(eventName, handler, options)

Registers a function to run when a specific event fires.

- **eventName**: The event to listen for (like `'before_compaction'`)
- **handler**: An async function that receives `(event, ctx)`
- **options**: An object with a `name` property to identify your hook in logs

### api.logger

A logging object for writing to OpenClaw's log output. Use this instead of `console.log`.

- `api.logger.info('message')`: General information
- `api.logger.warn('message')`: Warnings
- `api.logger.error('message')`: Errors

---

## Building a Plugin: Step by Step

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

- **Check the logs.** Use `openclaw logs --follow` to watch your plugin's output in real time.
- **Use descriptive log prefixes.** Start every log message with your plugin name in brackets, like `[my-plugin]`.
- **Test with small changes.** Get the basic structure working first (just a log message). Then add your actual logic piece by piece.
- **Handle errors gracefully.** Wrap your hook logic in a try/catch block. A crashing plugin can affect the whole system.
- **Check file paths.** Always verify paths exist before using them. Use `existsSync()` and create directories with `mkdirSync(outputDir, { recursive: true })`.
- **Restart after changes.** Plugins load when the gateway starts. After editing code, run `openclaw gateway restart`.

---

## Plugin Ideas

- **Daily summary exporter:** Save a summary of each day's conversations to a file at midnight.
- **Usage tracker:** Log how many messages and tokens are used per session for cost monitoring.
- **Backup rotator:** Save workspace snapshots on a schedule.
- **Context injector:** Automatically load extra context files before specific types of conversations.

---

For a real, working plugin example, see [examples/plugins/history-backup/](../examples/plugins/history-backup/).
