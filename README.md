# GAIA OS

**A production-tested [OpenClaw](https://docs.openclaw.ai) workspace template.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/Powered%20by-OpenClaw-purple)](https://docs.openclaw.ai)

GAIA OS gives your AI agent structure — memory that persists between conversations, a personality that sticks, skills for your favorite tools, and automations that run on schedule. Clone it, install [OpenClaw](https://docs.openclaw.ai), and start chatting. Your agent handles the rest.

---

## What You Get

- **Memory that lasts.** Your agent remembers what happened yesterday, last week, and last month — even though it wakes up fresh every session.
- **A real personality.** Not a generic chatbot. Your agent figures out who it is through a first-run conversation with you.
- **Skills for your tools.** Teach your agent how to use Notion, Twitter, or anything else with simple markdown files.
- **Automations.** Morning briefings, content scanning, reminders, weekly reviews — just tell your agent what you want and when.
- **Battle-tested conventions.** Safety rules, group chat etiquette, and proactive work guidelines from hundreds of real sessions.

## Quick Start

### 1. Install OpenClaw

Follow the [OpenClaw setup guide](https://docs.openclaw.ai/getting-started).

### 2. Clone this repo

```bash
git clone https://github.com/SEStarkman/gaia-os.git ~/gaia
cd ~/gaia
```

### 3. Run setup

```bash
bash scripts/setup.sh
```

### 4. Start chatting

```bash
openclaw gateway start
```

Send your first message. Your agent will introduce itself, learn about you, and set up its own personality. That's it — you're running.

---

## How It Works

Your agent wakes up with no memory each session. These files fix that:

- **SOUL.md** — Your agent's personality. Built during the first conversation, evolves over time.
- **USER.md** — What your agent knows about you. Updated as it learns.
- **MEMORY.md** — Long-term memory. The important stuff, curated over time.
- **memory/YYYY-MM-DD.md** — Daily journal. What happened today.

Every session, the agent reads these files first. That's how it remembers.

### Skills

Skills are markdown files that teach your agent how to use a tool — the commands, the auth, the gotchas. See `skills/` for examples and a template to create your own.

### Automations

Tell your agent to do things on a schedule: "Every morning at 7am, check my email and calendar." No config files needed — just describe what you want in plain English. See [crons/README.md](crons/README.md) for inspiration.

### Bootstrap

The first time your agent runs, it has a real conversation with you. Not a form — a conversation. It figures out its name, personality, humor level, and your preferences. Then it writes everything to the workspace files so every future session starts from that foundation.

---

## What's Inside

| Folder | What It Does |
|--------|-------------|
| `skills/` | Tool skills with examples (Twitter, Notion, meeting summaries) and a template |
| `crons/` | Automation inspiration and how to set them up |
| `client-kit/` | Onboarding docs for anyone setting up their own agent |
| `docs/` | Design philosophy, skill creation guide, writing style template |
| `scripts/` | Setup and update helpers |
| `memory/` | Where daily memory files live (starts empty) |

---

## Customization

Every file is a starting point. Edit whatever you want:

- **Different personality?** Edit `SOUL.md` (or just tell your agent to change).
- **New tools?** Copy `skills/SKILL-TEMPLATE.md` and fill it in.
- **Automations?** Just ask your agent to set them up.

---

## Documentation

- [Philosophy & Design Principles](docs/PHILOSOPHY.md) — Why things are built this way
- [Creating Skills](docs/SKILL-CREATION.md) — How to teach your agent new tools
- [Writing Style Guide](docs/WRITING-STYLE-GUIDE.md) — Template for content creation
- [OpenClaw Docs](https://docs.openclaw.ai) — The runtime that powers everything

---

## Contributing

This repo reflects patterns tested in production. If you've found something that works better, open an issue or PR.

## License

MIT — do whatever you want with it.

---

<sub>Built by [Sam Starkman](https://samstarkman.com). If you want help setting up an AI agent for yourself or your business, [get in touch](https://samstarkman.com).</sub>
