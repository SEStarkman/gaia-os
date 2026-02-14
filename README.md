# GAIA OS

**A production-tested [OpenClaw](https://docs.openclaw.ai) workspace template.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/Powered%20by-OpenClaw-purple)](https://docs.openclaw.ai)

GAIA OS gives your AI agent structure. Memory that persists between conversations. A personality that sticks. Skills for your favorite tools. Automations that run on schedule. Clone it, install [OpenClaw](https://docs.openclaw.ai), and start chatting. Your agent handles the rest.

---

## What You Get

- **Memory that lasts.** Your agent remembers what happened yesterday, last week, and last month, even though it wakes up fresh every session.

- **A real personality.** Your agent figures out who it is through a first-run conversation with you. No generic chatbot energy.

- **Skills for your tools.** Teach your agent how to use Notion, Twitter, or anything else with simple markdown files.

- **Automations.** Morning briefings, content scanning, reminders, weekly reviews. Just tell your agent what you want and when.

- **Battle-tested conventions.** Safety rules, group chat etiquette, and proactive work guidelines from hundreds of real sessions.

## Quick Start

### 1. Clone this repo

```bash
git clone https://github.com/SEStarkman/gaia-os.git ~/gaia
cd ~/gaia
```

### 2. Install OpenClaw

```bash
npm i -g openclaw
```

(`-g` installs it globally so `openclaw` works as a command from anywhere)

### 3. Run onboarding

```bash
openclaw onboard
```

When it asks for your workspace path, point it at `~/gaia` (or wherever you cloned). This sets up your API key, Telegram bot, and config. Because the workspace files already exist from the clone, OpenClaw uses them instead of creating blank defaults.

### 4. Start chatting

```bash
openclaw gateway start
```

Send your first message. Your agent will introduce itself, learn about you, and set up its own personality. That's it. You're running.

---

## How It Works

Your agent wakes up with no memory each session. These files fix that:

- **SOUL.md** is your agent's personality. Built during the first conversation, evolves over time.

- **USER.md** is what your agent knows about you. Updated as it learns.

- **MEMORY.md** is long-term memory. The important stuff, curated over time.

- **memory/YYYY-MM-DD.md** files are daily journals. What happened today.

Every session, the agent reads these files first. That's how it remembers.

### Skills

Skills are markdown files that teach your agent how to use a tool. The commands, the auth, the gotchas. See `skills/` for examples and a template to create your own.

### Automations

Tell your agent to do things on a schedule: "Every morning at 7am, check my email and calendar." No config files needed. Just describe what you want in plain English. See [crons/README.md](crons/README.md) for inspiration.

### Bootstrap

The first time your agent runs, it has a real conversation with you. Not a form. A conversation. It figures out its name, personality, humor level, and your preferences. Then it writes everything to the workspace files so every future session starts from that foundation.

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

- **Different personality?** Edit `SOUL.md` or just tell your agent to change.

- **New tools?** Copy `skills/SKILL-TEMPLATE.md` and fill it in.

- **Automations?** Just ask your agent to set them up.

---

## Documentation

- [Philosophy & Design Principles](docs/PHILOSOPHY.md)
- [Creating Skills](docs/SKILL-CREATION.md)
- [Writing Style Guide](docs/WRITING-STYLE-GUIDE.md)
- [OpenClaw Docs](https://docs.openclaw.ai)

---

## Contributing

This repo reflects patterns tested in production. If you've found something that works better, open an issue or PR.

## License

MIT. Do whatever you want with it.

---

<sub>Built by [Sam Starkman](https://samstarkman.com). If you want help setting up an AI agent for yourself or your business, [get in touch](https://samstarkman.com).</sub>
