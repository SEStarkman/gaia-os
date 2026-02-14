---
name: my-skill-name
description: "Use when [specific trigger conditions]. Contains [what's inside: auth, commands, patterns, gotchas]."
---

<!-- 
SKILL TEMPLATE
==============
Copy this file to skills/my-tool/SKILL.md and fill in each section.
Delete these comments when you're done.

Tips:
- The description in frontmatter is routing logic. Be specific about WHEN this skill activates.
- Include negative examples. Your agent WILL hallucinate commands without them.
- Auth setup should be copy-pasteable. Don't make the agent guess.
- "DO NOT" sections prevent the most common mistakes.
-->

# [Tool Name]

_One-line description of what this tool does._

## Auth Setup

<!-- How to authenticate. Include the exact commands. -->

```bash
source ~/.secrets.env
# Sets TOOL_API_KEY
```

## Commands

<!-- List every command the agent might need. Include syntax, flags, and examples. -->

### Command One

```bash
tool action "argument" --flag VALUE
```

- `"argument"` — what this is
- `--flag VALUE` — what this controls

### Command Two

```bash
tool other-action --option
```

## CRITICAL: Commands That DO NOT Exist

<!-- List commands the agent might hallucinate. This prevents real mistakes. -->

- ~~`tool wrong-command`~~ — DOES NOT EXIST. Use `tool right-command` instead.

## Common Patterns

<!-- Recipes for typical workflows your agent will encounter. -->

### Pattern: [Typical Use Case]

```bash
# Step 1
tool action "query"

# Step 2
tool follow-up --with-results
```

## Output Handling

<!-- How to handle output. Truncation, parsing, formatting notes. -->

Always pipe through `head` to prevent output overflow:
```bash
tool action | head -100
```

## DO NOT

<!-- Hard rules. What should never happen with this tool. -->

- Do not use deprecated commands
- Do not skip auth setup
- Do not run without output capping
