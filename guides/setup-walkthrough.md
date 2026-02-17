# AI Agent Onboarding: Setup Walkthrough

_Step-by-step guide for setting up a client's personal AI agent on GCP with OpenClaw + Telegram._

---

## Pre-Call Checklist

- Client has a Google account with billing method ready
- Client can access console.cloud.google.com
- Client has Telegram installed (phone + desktop)
- Client has filled in the initialization template you sent them
- Client has an Anthropic API key (or you'll help them get one)

---

## Step 1: Create GCP Project (walk them through in browser)

1. Google Cloud Console → top bar → **Select project** → **New Project**
2. Name: `gaia-agent` (or client's choice)
3. Billing account: select theirs
4. After project creates, click it to switch to it

## Step 2: Enable Compute Engine

1. Left nav → **Compute Engine**
2. Click **Enable** when prompted (takes ~2 minutes)

## Step 3: Create the VM

1. Compute Engine → **VM instances** → **Create instance**
2. Settings:
   - **Name:** `gaia-agent`
   - **Region:** `us-central1` (cheapest, most stable)
   - **Machine type:** `e2-standard-2` (2 vCPU, 8 GB RAM)
   - **Boot disk:** Debian 12, 50 GB standard persistent disk
   - **Firewall:** check both Allow HTTP + Allow HTTPS
3. Click **Create**, wait for status = Running

## Step 4: Create Telegram Bot (while VM spins up)

1. In Telegram, open **@BotFather**
2. Send `/start` then `/newbot`
3. Give it a name and username
4. Copy the **HTTP API token**. They'll need it in a minute.

## Step 5: Run the Setup Script (one command)

1. In VM list, click **SSH** to open browser terminal
2. Have them run:

```bash
curl -sL https://raw.githubusercontent.com/SEStarkman/gaia-os/master/scripts/setup.sh | bash
```

The script handles everything automatically:
- System packages (git, curl, build tools)
- Node.js 20.x
- OpenClaw installation
- Workspace creation at ~/gaia
- Prompts for the Telegram bot token (they paste it)
- Writes the OpenClaw config with Telegram enabled
- Optional: sets up auto-start on reboot (systemd service)

**You just watch and answer questions.** Total time: ~5 minutes.

## Step 6: Configure Anthropic API Key

```bash
openclaw configure
```

Walk them through adding their Anthropic API key when prompted.

## Step 7: Start the Agent

```bash
openclaw gateway start
```

## Step 8: Pair Telegram + Initialize

1. In Telegram, search for their bot username, click **Start**
2. Client pastes their filled-in **initialization template** as the first message
3. Agent auto-configures SOUL.md, USER.md, IDENTITY.md, MEMORY.md
4. Verify: `ls ~/gaia/` should show the new .md files

## Step 9: Post-Setup Verification

1. **Test tools:** Ask the agent to "run `ls` in the workspace"
2. **Check status:** `openclaw gateway status`
3. **Show stop/start:** `openclaw gateway stop` / `openclaw gateway start`

## Step 10: Hand-Off

Share the gaia-os repo link for reference:
- Command cheat sheet
- Update guide (how to update OpenClaw)
- Secret management guide
- Explain that the agent learns over time as memory builds
- Recommend taking a **Compute Engine snapshot** as a backup

---

## Timing Guide

| Section | Time |
|---------|------|
| GCP Project + VM (Steps 1-3) | 10 min |
| Telegram Bot (Step 4) | 5 min |
| Setup Script (Step 5) | 5 min |
| API Key + Start (Steps 6-7) | 3 min |
| Pair + Initialize (Step 8) | 10 min |
| Verify + Hand-off (Steps 9-10) | 5-10 min |
| **Total** | **~40 min** |

---

## Troubleshooting

- **"command not found: openclaw"** → Script may have failed. Run `sudo npm i -g openclaw` manually.
- **Bot not responding in Telegram** → Check `openclaw gateway status`, verify bot token is correct.
- **"Permission denied"** on gateway start → Don't run as root. Run as the normal user.
- **VM SSH disconnects** → Normal for browser SSH. Use `tmux` for persistent sessions.
- **Agent gives generic responses** → Initialization template wasn't pasted. Have them paste it.
- **Script fails on apt update** → VM might need a minute after creation. Wait, then re-run.
