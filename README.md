# GAIA OS

**A reference library for building and running AI agents with [OpenClaw](https://docs.openclaw.ai).**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/Powered%20by-OpenClaw-purple)](https://docs.openclaw.ai)

GAIA OS is a collection of guides, templates, and examples for getting the most out of your AI agent. It covers everything from first-time setup to building custom plugins. Browse what you need, copy what works, and make it your own.

---

## How to Use This Repo

This is a reference library, not a starter template you clone and run. Think of it like a cookbook: you browse the recipes, pick what you need, and adapt them to your kitchen.

**If you are setting up an agent for the first time**, start with the [Guides](#guides) section.

**If your agent is already running**, explore the [Templates](#workspace-templates), [Skills](#skills), or [Docs](#docs) sections to level up.

---

## What's Inside

### Guides

📂 **[guides/](guides/)**: Start here. Step-by-step instructions for the most common tasks.

- [Initialization Prompt](guides/INITIALIZATION-PROMPT.md): The template you paste as your first message to set up your agent
- [Command Cheat Sheet](guides/COMMAND-CHEAT-SHEET.md): Every OpenClaw command you will actually use
- [How to Update OpenClaw](guides/OPENCLAW-UPDATE-GUIDE.md): Updating to the latest version (takes about 2 minutes)
- [Secret Management](guides/SECRET-MANAGEMENT.md): How to safely handle API keys and passwords
- [Image Generation Prompts](guides/IMAGE-GEN-PROMPTS.md): Tips for getting great results from AI image generation

---

### Workspace Templates

📂 **[templates/](templates/)**: Reference copies of every workspace file your agent uses.

These are the files that define your agent's personality, memory, behavior, and rules. OpenClaw creates them automatically during setup. The copies here let you see what goes into each file so you can customize yours with confidence.

- [AGENTS.md](templates/AGENTS.md): The "rules of the house" for your agent
- [SOUL.md](templates/SOUL.md): Your agent's personality and voice
- [USER.md](templates/USER.md): What your agent knows about you
- [IDENTITY.md](templates/IDENTITY.md): Your agent's name, emoji, and avatar
- [MEMORY.md](templates/MEMORY.md): Long-term memory structure
- [TOOLS.md](templates/TOOLS.md): Environment-specific notes (cameras, SSH hosts, devices)
- [HEARTBEAT.md](templates/HEARTBEAT.md): Periodic check-in task list
- [BOOTSTRAP.md](templates/BOOTSTRAP.md): First-run onboarding conversation script

See the [templates README](templates/README.md) for what each file does and when to customize it.

---

### Skills

📂 **[skills/](skills/)**: How to teach your agent new tools.

Skills are markdown files that give your agent step-by-step instructions for using a tool (like Twitter, Notion, or a meeting transcript processor). The skills folder includes a template and several real examples.

- [Skills Overview](skills/README.md): How the skill system works
- [Skill Template](skills/SKILL-TEMPLATE.md): Copy this to create a new skill
- **Examples:**
  - [bird-cli](skills/examples/bird-cli/SKILL.md): X/Twitter CLI tool
  - [x-content-scan](skills/examples/x-content-scan/SKILL.md): Scan X for trending content
  - [notion-workspace](skills/examples/notion-workspace/SKILL.md): Notion API patterns
  - [meeting-summary](skills/examples/meeting-summary/SKILL.md): Process meeting transcripts

---

### Automations

📂 **[crons/](crons/)**: Ideas for things your agent can do on a schedule.

Morning briefings, content scanning, email monitoring, weekly reviews, daily reflections. You do not need to write code. Just tell your agent what you want and when.

- [Automations Guide](crons/README.md): How to set up scheduled tasks with plain English

---

### Docs

📂 **[docs/](docs/)**: Deeper reading on design decisions and advanced topics.

- [Philosophy and Design Principles](docs/PHILOSOPHY.md): Why GAIA OS works the way it does
- [Creating Skills](docs/SKILL-CREATION.md): A detailed guide to writing production-quality skills
- [Writing Style Guide](docs/WRITING-STYLE-GUIDE.md): Template for defining your agent's writing voice
- [Building Plugins](docs/PLUGIN-GUIDE.md): How to extend OpenClaw with custom JavaScript plugins

---

### Other

- **[scripts/](scripts/)**: Helper scripts for setup and updates
- **[memory/](memory/)**: Example daily memory file showing the format your agent uses

---

## Quick Start (For New Users)

If you just got set up and want to hit the ground running:

1. **Read the [Initialization Prompt](guides/INITIALIZATION-PROMPT.md)**, fill in your details, and paste it as your first message to your agent.
2. **Bookmark the [Command Cheat Sheet](guides/COMMAND-CHEAT-SHEET.md)** for daily reference.
3. **Browse the [templates](templates/)** to understand what each workspace file does.
4. **Check the [automations ideas](crons/README.md)** for things your agent can do on autopilot.

That is it. Your agent handles the rest.

---

## Further Reading

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Philosophy and Design Principles](docs/PHILOSOPHY.md)
- [Building Plugins](docs/PLUGIN-GUIDE.md)

---

## Contributing

This repo reflects patterns tested in production. If you have found something that works better, open an issue or PR.

## License

MIT. Do whatever you want with it.

---

<sub>Built by [Sam Starkman](https://samstarkman.com). If you want help setting up an AI agent for yourself or your business, [get in touch](https://samstarkman.com).</sub>
