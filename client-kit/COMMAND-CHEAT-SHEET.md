# OpenClaw Command Cheat Sheet

_The commands you'll actually use. Keep this handy._

---

## Daily Commands

These are the ones you'll use most:

| What | Command |
|------|---------|
| Check if your agent is running | `openclaw gateway status` |
| Restart your agent | `openclaw gateway restart` |
| Stop your agent | `openclaw gateway stop` |
| Start your agent | `openclaw gateway start` |
| See recent logs | `openclaw logs --follow` |
| Check overall health | `openclaw status` |

---

## Updates

| What | Command |
|------|---------|
| Check current version | `openclaw --version` |
| Update to latest | `npm install -g openclaw@latest` |
| Run health check after update | `openclaw doctor` |
| Roll back to specific version | `npm install -g openclaw@VERSION` |

Full update flow:
```
openclaw gateway stop
npm install -g openclaw@latest
openclaw doctor
openclaw gateway start
```

---

## Chat Commands

Type these directly in your chat with the agent (Telegram, WhatsApp, etc.):

| What | Command |
|------|---------|
| Check agent status | `/status` |
| Change model | `/model anthropic/claude-sonnet-4-20250514` |
| Toggle reasoning mode | `/reasoning` |
| See current config | `/config` |

---

## Models

| What | Command |
|------|---------|
| See available models | `openclaw models list` |
| Check auth status | `openclaw models status` |
| Change default model | `openclaw models set MODEL_NAME` |
| Refresh API auth | `openclaw models auth setup-token` |

---

## Channels (Telegram, WhatsApp, etc.)

| What | Command |
|------|---------|
| List connected channels | `openclaw channels list` |
| Check channel health | `openclaw channels status` |
| Add a new channel | `openclaw channels add` |
| See channel logs | `openclaw channels logs` |

---

## Cron Jobs (Scheduled Tasks)

| What | Command |
|------|---------|
| List all scheduled jobs | `openclaw cron list` |
| See job run history | `openclaw cron runs --id JOB_ID` |
| Trigger a job manually | `openclaw cron run JOB_ID` |
| Disable a job | `openclaw cron disable JOB_ID` |
| Enable a job | `openclaw cron enable JOB_ID` |
| Delete a job | `openclaw cron rm JOB_ID` |

---

## Troubleshooting

| What | Command |
|------|---------|
| Run diagnostics | `openclaw doctor` |
| Deep health check | `openclaw status --deep` |
| Check gateway health | `openclaw health` |
| View error logs | `openclaw logs --follow` |
| Security audit | `openclaw security audit` |

---

## Advanced

| What | Command |
|------|---------|
| Open terminal UI | `openclaw tui` |
| Search agent memory | `openclaw memory search "query"` |
| Reindex memory | `openclaw memory index` |
| Send a system event | `openclaw system event --text "message"` |
| Access web dashboard | SSH tunnel then open http://127.0.0.1:18789 |

### SSH Tunnel (to access web dashboard from your laptop):
```
gcloud compute ssh YOUR-VM-NAME --zone=YOUR-ZONE -- -L 18789:127.0.0.1:18789
```
Then open http://127.0.0.1:18789 in your browser.

---

## Quick Fixes

**Agent not responding:**
```
openclaw gateway restart
```

**Something weird happening:**
```
openclaw doctor
openclaw gateway restart
```

**Need to check what's going on:**
```
openclaw status --deep
openclaw logs --follow
```

**Model auth expired:**
```
openclaw models auth setup-token
openclaw gateway restart
```
