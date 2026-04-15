# GAIA OS

Everything your AI agent needs to get started, stay updated, and grow.

---

## Quick Start

Run this on a fresh Debian/Ubuntu VM (e.g. GCP Compute Engine):

```bash
bash <(curl -sL https://raw.githubusercontent.com/SEStarkman/gaia-os/master/scripts/setup.sh)
```

This installs all dependencies (system packages, Homebrew, Node.js, OpenClaw) and sets up your PATH. When it finishes, run `openclaw onboard` to configure your agent.

---

## Guides

Short, practical docs for the things you will actually do.

| Guide | What it covers |
|-------|---------------|
| [Workspace Files](guides/workspace-files.md) | What SOUL.md, USER.md, IDENTITY.md, and all the other workspace files do. One doc explaining all of them. |
| [Command Cheat Sheet](guides/command-cheat-sheet.md) | Every OpenClaw command you will use, organized by task. Bookmark this one. |
| [Updating OpenClaw](guides/updating-openclaw.md) | Step by step instructions for updating to the latest version. Takes about 2 minutes. |
| [Secret Management](guides/secret-management.md) | How to safely handle API keys and passwords without leaking them into chat. |
| [Building Skills](guides/building-skills.md) | How to teach your agent new tools by writing skill files. |
| [Building Plugins](guides/building-plugins.md) | How to extend OpenClaw with custom JavaScript plugins that run on events. |
| [Writing Style Guide](guides/writing-style-guide.md) | A template for defining your agent's writing voice across platforms. |

---

## Examples

Real, working examples you can learn from and adapt.

- **[examples/skills/](examples/skills/)**: Four skill files showing how to teach your agent tools like Twitter, Notion, meeting transcripts, and content scanning.
- **[examples/plugins/](examples/plugins/)**: A working plugin that backs up conversation history before it gets compacted.

---

## First Time Setup

Open [INITIALIZATION-PROMPT.md](INITIALIZATION-PROMPT.md), fill in your details, and paste it as your first message to your agent. That single step sets up your agent's personality, learns about you, and gets everything running.

---

## License

MIT. Do whatever you want with it.

<sub>Built by [Sam Starkman](https://samstarkman.com). If you want help setting up an AI agent for yourself or your business, [get in touch](https://samstarkman.com).</sub>
