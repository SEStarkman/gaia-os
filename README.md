# GAIA OS

**A production-tested [OpenClaw](https://docs.openclaw.ai) workspace template.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/Powered%20by-OpenClaw-purple)](https://docs.openclaw.ai)

GAIA OS is the workspace that runs behind your AI agent. It gives OpenClaw structure — memory that persists, skills that route correctly, crons that fire on time, and conventions that survive hundreds of sessions without falling apart.

This isn't a framework. It's a filing system for an AI that wakes up with amnesia every time you talk to it.

---

## What You Get

| Component | What It Does |
|-----------|-------------|
| **Structured Memory** | Daily files + curated long-term memory. Your agent journals what happens and distills what matters. |
| **Skills Framework** | Markdown skill files that teach your agent how to use tools. Description = routing logic. |
| **Cron Templates** | Scheduled tasks: morning digests, content scans, memory maintenance, daily reflections. |
| **Bootstrap Flow** | First-run conversation that builds your agent's personality, learns about you, and writes everything to the right files. |
| **Battle-Tested Conventions** | Safety rules, group chat etiquette, heartbeat strategy, proactive work guidelines — all from production use. |
| **Client Kit** | Onboarding docs you can hand to anyone setting up their own agent. |

## Quick Start

### 1. Install OpenClaw

Follow the [OpenClaw setup guide](https://docs.openclaw.ai/getting-started) to get OpenClaw running.

### 2. Clone This Repo Into Your Workspace

```bash
git clone https://github.com/SEStarkman/gaia-os.git ~/gaia
cd ~/gaia
```

### 3. Run Setup

```bash
bash scripts/setup.sh
```

This checks your environment and prepares the workspace.

### 4. Start Your Agent

```bash
openclaw gateway start
```

Send your first message. The agent will find `BOOTSTRAP.md` and start the getting-to-know-you conversation. It'll figure out who it is, learn about you, and write everything to the workspace files.

That's it. You're running.

---

## Project Structure

```
gaia-os/
├── AGENTS.md              # Operating protocol (start here)
├── SOUL.md                # Agent personality (filled during bootstrap)
├── USER.md                # About you (filled during bootstrap)
├── IDENTITY.md            # Agent name, emoji, vibe
├── MEMORY.md              # Long-term curated memory
├── HEARTBEAT.md           # Periodic check configuration
├── TOOLS.md               # Environment-specific notes
├── BOOTSTRAP.md           # First-run conversation (delete after)
│
├── memory/                # Daily memory files
│   └── YYYY-MM-DD.md
│
├── skills/                # Tool skills
│   ├── README.md
│   ├── SKILL-TEMPLATE.md
│   └── examples/          # Reference implementations
│
├── crons/                 # Scheduled task configs
│   ├── README.md
│   └── examples/
│
├── client-kit/            # Onboarding docs for new users
├── scripts/               # Utility scripts
└── docs/                  # Philosophy, guides, references
```

## How It Works

### Memory Architecture

Your agent wakes up fresh every session. It has no built-in memory. These files *are* its memory:

- **Daily files** (`memory/YYYY-MM-DD.md`) — Raw journal. What happened today.
- **MEMORY.md** — Curated long-term memory. Periodically distilled from daily files.
- **SOUL.md** — Identity. Rarely changes.
- **USER.md** — Understanding of you. Updated as it learns.

Every session starts the same way: read SOUL.md, read USER.md, read today's memory. This gives the agent continuity without needing persistent state.

### Skills = What, Crons = When

**Skills** teach your agent *how* to do something. A skill file contains auth patterns, command syntax, common pitfalls, and negative examples ("this command does NOT exist").

**Crons** tell your agent *when* to do something. They reference skills and define schedules. "Run the content scan every morning at 9 AM using the x-content-scan skill."

Separating the two means you can reuse skills across multiple crons, and update timing without touching the skill logic.

### Bootstrap

The first time your agent runs, it finds `BOOTSTRAP.md` and has a real conversation with you. Not a form — a conversation. It figures out its personality, learns your preferences, sets boundaries, and writes everything to the workspace files. Then it deletes `BOOTSTRAP.md` because it doesn't need a birth certificate anymore.

---

## Customization

Every file in this repo is a starting point. The comments tell you what to change.

- **Want a different personality?** Edit `SOUL.md`.
- **Need new tools?** Create a skill in `skills/` using `SKILL-TEMPLATE.md`.
- **Want scheduled tasks?** Add cron configs in `crons/`.
- **Running this for a client?** Hand them the `client-kit/` folder.

Read [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md) for the design principles behind these choices.

---

## Documentation

- [Philosophy & Design Principles](docs/PHILOSOPHY.md)
- [Creating Skills](docs/SKILL-CREATION.md)
- [Writing Style Guide Template](docs/WRITING-STYLE-GUIDE.md)
- [OpenClaw Documentation](https://docs.openclaw.ai)

---

## Contributing

This repo reflects patterns tested in production. If you've found something that works better, open an issue or PR. Practical beats theoretical.

---

## License

MIT — do whatever you want with it.

---

<sub>Built by [Sam Starkman](https://samstarkman.com). If you want help setting up an AI agent for yourself or your business, [get in touch](https://samstarkman.com).</sub>
