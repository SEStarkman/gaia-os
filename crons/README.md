# Crons

Crons tell your agent **when** to do something. Skills tell it **how**. Keeping them separate means you can reuse one skill across multiple schedules and update timing without touching the skill logic.

## How Crons Work

OpenClaw cron jobs are JSON configs that define:

- **Schedule** — When to run (cron syntax)
- **Prompt** — What to tell the agent
- **Channel** — Where to deliver results
- **Model** — Which model to use (optional, defaults to your main model)

Each cron run is an isolated sub-agent session. It doesn't see your main conversation history, which means:

- It won't leak context from private conversations
- It starts fresh with just the workspace files + the prompt
- It can use a cheaper/faster model for simple tasks

## Creating a Cron

Use the OpenClaw CLI:

```bash
openclaw cron add \
  --name "morning-digest" \
  --schedule "0 7 * * *" \
  --prompt "Check email, calendar, and weather. Summarize what's coming today." \
  --channel telegram
```

Or manage them through conversation with your agent — it can create cron jobs for you.

## Cron Syntax Quick Reference

```
┌───────────── minute (0-59)
│ ┌───────────── hour (0-23)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-7, Sun=0 or 7)
│ │ │ │ │
* * * * *
```

**Common patterns:**

| Schedule | Cron Expression |
|----------|----------------|
| Every morning at 7am | `0 7 * * *` |
| Every 30 minutes, 7am-9pm | `0,30 7-21 * * *` |
| Every Monday at 9am | `0 9 * * 1` |
| Sunday at 10am | `0 10 * * 0` |
| Every 4 hours | `0 */4 * * *` |
| Weekdays at 6pm | `0 18 * * 1-5` |

**Timezone:** Append your timezone to schedules. Example: `0 7 * * * ET` for 7am Eastern.

## Best Practices

### Stagger your crons

Don't schedule everything at the same time. Stagger by 5-15 minutes to avoid:

- Out-of-order message delivery
- Main session contention
- API rate limiting

```
5:00am  — Daily memory file
5:15am  — Morning digest
5:30am  — Content scan
```

### Keep prompts self-contained

Each cron runs in isolation. It doesn't know what happened in your last conversation. Include everything it needs:

```
Read the x-content-scan skill. Search for trending AI posts from the last 24 hours 
with 500+ likes. Output 3-5 opportunities in the standard format. 
Read writing-style-guide.md and validate all drafts against it.
```

### Clean output only

Cron results go directly to your channel. No one wants to see internal narration or debugging output. Instruct the cron to output clean summaries.

### Use the right model

Expensive models aren't always needed. A content scan might work fine with a faster model. A complex analysis might need your best model.

## Skill + Cron Relationship

The cron prompt references skills by name or by telling the agent what to do:

```
"Use the bird-cli skill to search for AI content. 
Follow the x-content-scan workflow for filtering and formatting."
```

This means:
- **Skill update** → All crons using it automatically get the new instructions
- **Cron update** → Skills stay untouched, only timing/delivery changes
- **New cron, same skill** → Just create a new schedule with a different prompt

## Managing Crons

```bash
# List all crons
openclaw cron list

# See run history
openclaw cron runs --id JOB_ID

# Trigger manually (for testing)
openclaw cron run JOB_ID

# Disable without deleting
openclaw cron disable JOB_ID

# Delete
openclaw cron rm JOB_ID
```

## Example Configs

The `examples/` directory contains reference configurations for common patterns. These are illustrative — adapt the prompts, schedules, and channels to your setup.

| Config | Purpose |
|--------|---------|
| [morning-digest.json](examples/morning-digest.json) | Daily briefing (email, calendar, weather) |
| [content-pulse.json](examples/content-pulse.json) | Periodic social media scanning |
| [daily-memory.json](examples/daily-memory.json) | Create today's memory file |
| [homework-for-life.json](examples/homework-for-life.json) | Daily reflection prompt |
| [weekly-review.json](examples/weekly-review.json) | Weekly memory maintenance |
