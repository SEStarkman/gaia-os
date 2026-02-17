# Setting Up Your AI Agent

This guide walks you through setting up a personal AI agent on Google Cloud with OpenClaw and Telegram. By the end, you'll have an always-on agent you can message from your phone.

**Total time:** ~40 minutes

**What you'll need:**
- A Google account with a billing method
- Telegram installed on your phone and desktop
- Your filled-in [initialization template](../INITIALIZATION-PROMPT.md)
- An Anthropic API key or Claude Pro/Max subscription (see [Step 6](#6-connect-your-anthropic-account))

---

## 1. Create a Google Cloud Project

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Click **Select project** in the top bar, then **New Project**
3. Name it something like `gaia-agent`
4. Select your billing account and click **Create**
5. Once it's ready, click on it to switch to it

## 2. Enable Compute Engine

1. In the left navigation, click **Compute Engine**
2. Click **Enable** when prompted (this takes a couple minutes)

## 3. Create the VM

1. Go to **Compute Engine → VM instances → Create instance**
2. Use these settings:
   - **Name:** `gaia-agent`
   - **Region:** `us-central1` (cheapest and most stable)
   - **Machine type:** `e2-standard-2` (2 vCPU, 8 GB RAM)
   - **Boot disk:** Click **Change**, select Debian 12, set size to 50 GB
   - **Firewall:** Check both **Allow HTTP traffic** and **Allow HTTPS traffic**
3. Click **Create** and wait for the green checkmark

## 4. Create a Telegram Bot

While the VM is spinning up:

1. Open Telegram and search for **@BotFather**
2. Send `/start`, then `/newbot`
3. Follow the prompts to name your bot and pick a username
4. Copy the **HTTP API token** it gives you. You'll need this in a minute.

## 5. Run the Setup Script

1. Back in Google Cloud, click **SSH** next to your VM to open a terminal
2. Run this single command:

```bash
curl -sL https://raw.githubusercontent.com/SEStarkman/gaia-os/master/scripts/setup.sh | bash
```

The script installs everything automatically: system packages, Node.js, OpenClaw, and the workspace structure. It will ask you to paste your Telegram bot token and whether you want auto-start on reboot.

This takes about 5 minutes. Just follow the prompts.

## 6. Connect Your Anthropic Account

There are two ways to authenticate with Anthropic. Pick whichever fits your situation.

### Option A: API Key (pay per token)

Best if you don't have a Claude subscription, or you want usage-based billing with full control over costs.

1. Go to [console.anthropic.com](https://console.anthropic.com/)
2. Create an account (or sign in)
3. Add a payment method under **Billing**
4. Go to **API Keys** and create a new key
5. Back in your VM terminal, run:

```bash
openclaw configure
```

6. Paste the API key when prompted

**Pricing:** You pay per token used. Costs vary by model. See [Anthropic's pricing page](https://www.anthropic.com/pricing) for details.

### Option B: Setup Token (use your Claude Pro/Max subscription)

Best if you already pay for Claude Pro ($20/mo) or Claude Max ($100/mo). This lets your agent use your existing subscription instead of paying separately for API access.

1. On any computer where you have the Claude CLI installed, run:

```bash
claude setup-token
```

2. Copy the token it outputs
3. In your VM terminal, run:

```bash
openclaw models auth setup-token --provider anthropic
```

4. Paste the token when prompted
5. Verify it worked:

```bash
openclaw models status
```

You should see your Anthropic account listed with a valid token.

**Don't have the Claude CLI?** Install it first with `npm install -g @anthropic-ai/claude-code`, then run `claude setup-token`.

**Note:** Subscription auth shares your existing Claude usage limits. If you're a heavy Claude user and your agent is also active, you may hit rate limits faster than with a separate API key.

## 7. Start the Agent

```bash
openclaw gateway start
```

## 8. Initialize Your Agent

1. Open Telegram and search for your bot's username
2. Tap **Start**
3. Paste your filled-in initialization template as the first message
4. The agent reads it and configures itself: personality, memory, preferences, everything from your template

To verify it worked, run `ls ~/gaia/` in the SSH terminal. You should see files like `SOUL.md`, `USER.md`, `IDENTITY.md`, and `MEMORY.md`.

## 9. Verify Everything Works

A few quick checks:

1. Ask the agent something in Telegram. It should respond.
2. In SSH, run `openclaw gateway status` to confirm it's running.
3. Try `openclaw gateway stop` and `openclaw gateway start` so you know how to restart it.

## 10. You're Done

Your agent is live. A few things to know going forward:

- The agent learns over time as it builds memory from your conversations
- Reference guides are in this repo: [command cheat sheet](command-cheat-sheet.md), [updating OpenClaw](updating-openclaw.md), [secret management](secret-management.md)
- Take a **Compute Engine snapshot** of your VM as a backup (Compute Engine → Snapshots → Create)

---

## Troubleshooting

**"command not found: openclaw"**
The install script may have failed partway. Run `sudo npm i -g openclaw` manually.

**Bot not responding in Telegram**
Run `openclaw gateway status` to check if it's running. Double-check the bot token in `~/.openclaw/openclaw.json`.

**"Permission denied" on gateway start**
Don't run as root. Use your normal user account.

**SSH terminal disconnects**
Browser SSH can be flaky. Use `tmux` to keep sessions alive: run `tmux` before starting anything, and `tmux attach` to reconnect.

**Agent gives generic/confused responses**
The initialization template probably wasn't pasted. Send it as a message in Telegram.

**Script fails on apt update**
The VM might need a minute after creation to be fully ready. Wait 30 seconds and re-run the command.
