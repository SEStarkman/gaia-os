# How to Update OpenClaw

_A step-by-step guide for when OpenClaw releases a new version._

---

## Will I Lose Anything?

**No.** Updates only replace the OpenClaw software itself. Your agent's personality, memories, and configuration are stored separately and are never touched by an update.

**Safe (never affected by updates):**
- SOUL.md (your agent's personality)
- USER.md (info about you)
- AGENTS.md (workspace rules)
- MEMORY.md (long-term memory)
- memory/ folder (daily notes)
- HEARTBEAT.md, TOOLS.md, IDENTITY.md
- ~/.openclaw/openclaw.json (your configuration)
- Telegram/WhatsApp/Discord connections

**Updated (replaced with new version):**
- The OpenClaw program itself (the code that runs your agent)

Think of it like updating an app on your phone. Your data stays, the app gets better.

---

## Step 1: Connect to Your Server

### Option A: GCP Console (Easiest)

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Select your project from the dropdown at the top
3. Navigate to **Compute Engine** > **VM instances** (left sidebar)
4. Find your VM in the list
5. Click the **SSH** button on the right side of your VM's row
6. A browser window will open with a terminal connected to your server

### Option B: Terminal (If You Have gcloud Installed)

```bash
gcloud compute ssh YOUR-VM-NAME --zone=YOUR-ZONE
```

Example:
```bash
gcloud compute ssh openclaw-gateway --zone=us-central1-a
```

---

## Step 2: Check Your Current Version

Once connected, run:

```bash
openclaw --version
```

This shows your current version. Write it down in case you need to roll back.

---

## Step 3: Stop the Gateway

Before updating, stop the running agent:

```bash
openclaw gateway stop
```

You should see a confirmation that the gateway stopped. Your Telegram bot will go offline temporarily. This is normal.

**Alternative** (if the above doesn't work):

```bash
systemctl --user stop openclaw-gateway
```

---

## Step 4: Update OpenClaw

Run the update:

```bash
npm install -g openclaw@latest
```

This downloads and installs the newest version. It usually takes 30-60 seconds.

**If you see permission errors**, try:

```bash
sudo npm install -g openclaw@latest
```

---

## Step 5: Run the Doctor

After every update, run the doctor to check for any needed migrations:

```bash
openclaw doctor
```

This will:
- Check your configuration for any changes needed
- Migrate old settings to new formats (if applicable)
- Warn you about anything that needs attention

Read the output. If it says everything is fine, you're good. If it suggests changes, follow its instructions.

---

## Step 6: Restart the Gateway

Start your agent back up:

```bash
openclaw gateway start
```

**Alternative** (if using systemd):

```bash
systemctl --user start openclaw-gateway
```

---

## Step 7: Verify It's Running

Check that everything is working:

```bash
openclaw gateway status
```

You should see the gateway is running. Send a message to your agent via Telegram/WhatsApp to confirm it responds.

Check the new version:

```bash
openclaw --version
```

---

## Quick Reference (All Commands)

For experienced users, here's the whole process in one block:

```bash
# Check current version
openclaw --version

# Stop, update, doctor, restart
openclaw gateway stop
npm install -g openclaw@latest
openclaw doctor
openclaw gateway start

# Verify
openclaw gateway status
openclaw --version
```

Total time: ~2 minutes.

---

## If Something Goes Wrong

### The agent isn't responding after update

1. Check if the gateway is running:
   ```bash
   openclaw gateway status
   ```
2. Check the logs for errors:
   ```bash
   openclaw logs --follow
   ```
3. Try restarting:
   ```bash
   openclaw gateway restart
   ```

### You want to go back to the old version

If the new version has issues, roll back to the version you wrote down in Step 2:

```bash
openclaw gateway stop
npm install -g openclaw@VERSION_NUMBER
openclaw gateway start
```

Example:
```bash
npm install -g openclaw@2026.2.9
```

### Doctor says something is wrong

Run doctor again and read carefully:

```bash
openclaw doctor
```

It usually tells you exactly what to do. If you're stuck, reach out for help.

### Permission errors during update

If npm gives permission errors:

```bash
sudo npm install -g openclaw@latest
```

Or fix npm permissions (one-time):

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## How Often Should I Update?

OpenClaw is actively developed. We recommend checking for updates **every 1-2 weeks**. Major improvements happen frequently.

Your agent will NOT auto-update. You choose when to update.

If you're on a retainer plan, we'll notify you when important updates drop and can handle the update for you.

---

## Need Help?

- **OpenClaw Discord:** [discord.gg/clawd](https://discord.gg/clawd)
- **Your consultant:** Reach out to your consultant for hands-on help
- **OpenClaw docs:** [docs.openclaw.ai](https://docs.openclaw.ai)
