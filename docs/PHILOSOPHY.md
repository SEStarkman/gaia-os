# Philosophy

_Skills from production, not a lab._

## Why GAIA OS Exists

Most AI agent setups start from scratch every time. You install the runtime, connect a channel, and then... figure out the hard parts yourself. How should memory work? What happens when the agent wakes up? How do you stop it from hallucinating commands? How do you make it actually useful on day two, week two, month two?

GAIA OS exists because someone already figured this out the hard way. These aren't theoretical best practices. They're patterns that survived hundreds of real sessions: the mistakes that got documented, the conventions that actually stuck, the memory architecture that didn't fall apart.

## Design Principles

### Opinionated Defaults Over Blank Canvases

A blank `SOUL.md` teaches you nothing. A template with sections, guidance comments, and sensible defaults teaches you the structure while letting you customize everything.

Every file in GAIA OS has a point of view. You can change any of it, but you start with something that works.

### Memory Architecture Matters

The single most important thing in a long-running AI agent is memory. Without it, every session is groundhog day.

GAIA OS uses a two-tier memory system:

- **Daily files** (`memory/YYYY-MM-DD.md`): Raw journal entries. What happened today. Written in real-time.
- **Curated memory** (`MEMORY.md`): The distilled long-term memory. Periodically reviewed and updated from daily files.

This mirrors how humans actually remember things: you experience events (daily files), then your brain consolidates the important stuff into long-term memory while you sleep (weekly review). The daily files are the journal. MEMORY.md is the wisdom.

**Why not just one file?** Because raw logs grow forever and become noise. And because curated-only memory loses the details you might need later. Both layers serve a purpose.

### Skills Over Prompts

A prompt tells an AI what to do once. A skill teaches it how to do something forever.

Skills are markdown files that contain:
- Auth setup (copy-pasteable)
- Command syntax (exact, tested)
- Common patterns (recipes for real workflows)
- Negative examples (commands that DON'T exist)
- Hard rules (what to never do)

The negative examples are the secret weapon. AI agents hallucinate commands with total confidence. Documenting what *doesn't* exist is as important as documenting what does.

### Crons for Automation

An agent that only responds when you talk to it is half an agent. The other half is proactive work: checking your email, scanning for opportunities, maintaining memory, sending daily reflections.

GAIA OS separates **skills** (what) from **crons** (when). A skill teaches the agent how to scan Twitter. A cron tells it to do that scan every morning at 9 AM. This separation means you can:

- Reuse skills across multiple schedules
- Update timing without touching skill logic
- Use different models for different tasks (cheap model for simple checks, expensive model for analysis)

### The Bootstrap Matters

First impressions set the trajectory. A rushed bootstrap means weeks of friction as you correct the agent's assumptions about your preferences. A thoughtful 10-minute conversation means the agent starts with a real understanding of who you are, how you communicate, and what you need.

GAIA OS includes a battle-tested bootstrap flow that turns the first conversation into a personality-building exercise. It's not a form. It's a conversation. And the output goes straight into the workspace files that define every future interaction.

### Safety as Default Behavior

The agent has access to your life. Messages, files, maybe your calendar and email. That access comes with rules:

- **Internal actions are free.** Reading, organizing, learning. Go ahead.
- **External actions require permission.** Emails, tweets, anything public. Ask first.
- **Memory has access controls.** MEMORY.md only loads in private sessions, never in group chats.
- **Recoverable > destructive.** `trash` over `rm`. Always.

These aren't suggestions. They're defaults baked into AGENTS.md.

### Write It Down

AI agents don't have persistent memory between sessions. If you want to remember something, write it to a file. "Mental notes" die on restart.

This principle extends to everything:
- Learned a lesson? Update AGENTS.md.
- Discovered a tool gotcha? Update the skill file.
- Made a mistake? Document it in memory so future sessions don't repeat it.

The workspace is the brain. Files are the neurons. Writing things down is how the agent thinks across time.

---

## The Net

GAIA OS is opinionated because opinions are what separate a useful system from an empty template. Every convention here exists because the alternative was tried and failed. You're welcome to change anything, but at least you're starting from something that works.
