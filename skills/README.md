# Skills

Skills teach your agent how to use tools. Each skill is a markdown file (`SKILL.md`) in its own directory that contains everything the agent needs: auth patterns, command syntax, common pitfalls, and negative examples.

## How Skills Work

When your agent needs to do something — search Twitter, query Notion, process a meeting transcript — it looks for a matching skill. The **description** in the skill's frontmatter is the routing logic. OpenClaw reads the description to decide which skill to load for a given task.

```yaml
---
name: my-skill
description: "Use when doing X, Y, or Z. Contains auth patterns, command syntax, and gotchas."
---
```

**The description is the most important line in the file.** It determines when the skill gets activated. Be specific about what triggers it.

## Anatomy of a Skill

```
skills/
└── my-tool/
    └── SKILL.md
```

A skill file typically contains:

1. **Frontmatter** — Name and description (YAML between `---` markers)
2. **Auth Setup** — How to authenticate (env vars, tokens, config files)
3. **Commands/API Patterns** — The actual usage instructions
4. **Common Patterns** — Recipes for typical workflows
5. **Negative Examples** — What NOT to do (critical for preventing mistakes)
6. **DO NOT** — Hard rules and forbidden actions

### Why Negative Examples Matter

AI agents hallucinate commands. They'll confidently use `bird view` when only `bird read` exists. Negative examples are your defense:

```markdown
## CRITICAL: Commands That DO NOT Exist

- ~~`tool view`~~ — DOES NOT EXIST. Use `tool read` instead.
- ~~`tool fetch`~~ — DOES NOT EXIST. Use `tool get` instead.
```

Every skill should include a "DO NOT" section. The mistakes you prevent matter as much as the instructions you provide.

## Creating a New Skill

1. Copy `SKILL-TEMPLATE.md` into a new directory:
   ```bash
   mkdir skills/my-tool
   cp skills/SKILL-TEMPLATE.md skills/my-tool/SKILL.md
   ```

2. Fill in the sections. Be thorough — this is the only thing standing between your agent and confused hallucination.

3. Test it by asking your agent to do something that should trigger the skill.

See the [Skill Creation Guide](../docs/SKILL-CREATION.md) for a detailed walkthrough.

## Skill + Cron Relationship

**Skills = what.** How to do something.

**Crons = when.** When to do something.

A cron job references a skill but adds timing, output format, and delivery instructions. This means you can:
- Reuse one skill across multiple crons (e.g., "content scan" skill used by both "morning deep scan" and "afternoon pulse" crons)
- Update the skill without touching any cron configs
- Update cron timing without touching the skill

See the [Automations Guide](../crons/README.md) for more on scheduling.

## Example Skills

The `examples/` directory contains reference implementations:

| Skill | What It Does |
|-------|-------------|
| [bird-cli](examples/bird-cli/SKILL.md) | X/Twitter CLI tool — search, read, fetch timelines |
| [x-content-scan](examples/x-content-scan/SKILL.md) | Scan X for trending content opportunities |
| [notion-workspace](examples/notion-workspace/SKILL.md) | Notion API patterns and gotchas |
| [meeting-summary](examples/meeting-summary/SKILL.md) | Process meeting transcripts into summaries |

These are generalized from production use. Copy and adapt them for your setup.
