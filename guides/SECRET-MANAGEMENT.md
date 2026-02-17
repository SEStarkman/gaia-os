# Secret Management Basics

_How to safely handle API keys, tokens, and credentials with your AI agent._

---

## The Golden Rule

**Never paste secrets directly into chat.** Your agent's conversation history is stored in files. Anything you type becomes part of the log.

Instead, use one of the methods below to give your agent access to credentials safely.

---

## Method 1: Environment Variables (Recommended)

Environment variables are the safest way to give your agent access to API keys. They live in your server's memory, not in files your agent reads.

### How to Set Them

SSH into your server, then:

**Temporary (gone after reboot):**
```bash
export MY_API_KEY="sk-abc123..."
```

**Permanent (survives reboot):**

Add to your shell config:
```bash
echo 'export MY_API_KEY="sk-abc123..."' >> ~/.bashrc
source ~/.bashrc
```

Or create a secrets file:
```bash
# Create the file
nano ~/.secrets.env

# Add your secrets (one per line):
MY_API_KEY=sk-abc123...
ANOTHER_KEY=xyz789...

# Load them in your shell config
echo 'set -a; source ~/.secrets.env; set +a' >> ~/.bashrc
source ~/.bashrc
```

After setting environment variables, restart the gateway so your agent can access them:
```bash
openclaw gateway restart
```

### How Your Agent Uses Them

Your agent can read environment variables at runtime. For example, if a skill needs a Notion API key, set `NOTION_API_KEY` as an environment variable and the skill will pick it up automatically.

---

## Method 2: Config Files

Some tools expect credentials in specific config files. These are fine as long as:
- The file permissions are restricted (only your user can read it)
- The file is NOT inside your agent's workspace (not in the chat-accessible area)

**Good locations:**
- `~/.config/toolname/credentials`
- `~/.toolname/config`

**Bad locations:**
- Inside the workspace folder (your agent can read and share this)
- In MEMORY.md or any .md file

### Setting File Permissions

Make sure only your user can read secret files:
```bash
chmod 600 ~/.config/toolname/credentials
```

---

## Method 3: OpenClaw's Built-in Auth

OpenClaw manages its own credentials for model providers (Anthropic, OpenAI, etc.) securely:

```bash
# Set up model auth (interactive)
openclaw models auth setup-token

# Check auth status
openclaw models status
```

For channels (Telegram, WhatsApp, Discord), OpenClaw stores tokens in `~/.openclaw/credentials/`, which is separate from the workspace.

---

## What Your Agent Can and Can't See

| Location | Agent Can Read? | Safe for Secrets? |
|----------|----------------|-------------------|
| Workspace files (SOUL.md, memory/, etc.) | Yes | No |
| Chat messages | Yes (they're logged) | No |
| Environment variables | Yes (at runtime) | Yes |
| ~/.openclaw/credentials/ | No (managed by OpenClaw) | Yes |
| ~/.config/ files | Only via shell commands | Mostly yes |
| ~/.secrets.env | Only via shell commands | Yes |

---

## Common Secrets You'll Need

| Secret | Where It Goes | What It's For |
|--------|--------------|---------------|
| Anthropic API key | OpenClaw auth system | Powers the AI model |
| Telegram bot token | OpenClaw channel config | Chat connection |
| Notion API key | `NOTION_API_KEY` env var | Reading/writing Notion |
| GitHub token | `GITHUB_TOKEN` env var | Code repository access |
| Google API credentials | Config file in ~/.config/ | Gmail, Calendar, etc. |

---

## Checklist

- [ ] Never type API keys directly into chat
- [ ] Use environment variables for tool-specific keys
- [ ] Use `openclaw models auth` for model provider keys
- [ ] Set `chmod 600` on any files containing secrets
- [ ] Keep secrets out of the workspace folder
- [ ] Restart the gateway after adding new environment variables
- [ ] If you accidentally leak a key in chat, rotate it immediately

---

## If You Accidentally Share a Secret

1. **Rotate the key immediately.** Go to the provider's website and generate a new one.
2. Replace the old key in your environment variables or config.
3. Restart the gateway: `openclaw gateway restart`
4. The old key in your chat history is now useless.

Don't panic. Just rotate and move on.
