# Building Skills

A skill is a markdown file that teaches your agent how to use a tool. It lives at `skills/tool-name/SKILL.md` in your workspace and contains everything the agent needs: how to authenticate, what commands to run, common patterns, and (critically) what NOT to do.

---

## How Skills Work

When your agent needs to do something, like search Twitter, query Notion, or process a meeting transcript, it looks for a matching skill. The **description** in the skill's frontmatter is the routing logic. OpenClaw reads the description to decide which skill to load for a given task.

```yaml
---
name: my-skill
description: "Use when searching tweets, reading tweets, fetching user timelines, or any X/Twitter interaction."
---
```

The description is the most important line in the file. If it is vague, the skill will not activate when it should. If it is too broad, it will activate when it should not.

**Good descriptions:**
- "Use when searching tweets, reading tweets, fetching user timelines, or any X/Twitter interaction."
- "Use when creating, reading, updating, or querying Notion pages and databases."
- "Use when given a meeting transcript to process into a structured summary."

**Bad descriptions:**
- "Twitter stuff" (too vague)
- "Useful tool for many things" (matches everything and nothing)
- "CLI tool" (which one? for what?)

### Tips for Descriptions

1. **List specific trigger phrases.** "Use when searching tweets, reading tweets, fetching user timelines" covers the main use cases.
2. **Mention the tool name.** "Via the `bird` command" helps routing when the user asks by tool name.
3. **Include the domain.** "X/Twitter interaction" catches requests that do not mention the tool name.

---

## Folder Structure

Each skill gets its own folder with a single SKILL.md file:

```
skills/
└── my-tool/
    └── SKILL.md
```

---

## Anatomy of a Good Skill

### 1. Frontmatter

The YAML header with name and description:

```yaml
---
name: my-skill-name
description: "Use when [specific trigger conditions]. Contains [what's inside: auth, commands, patterns, gotchas]."
---
```

### 2. Auth Setup

Make it copy-pasteable. The agent should be able to run the auth commands without thinking.

```markdown
## Auth Setup (REQUIRED before every command)

\`\`\`bash
source ~/.secrets.env && AUTH_TOKEN="$MY_AUTH_TOKEN"
\`\`\`

AUTH_TOKEN must be set. Without it, all commands fail silently.
```

Key points:
- Show the exact commands
- Explain what gets set and why
- Mention failure modes ("fail silently" vs "throw an error")

### 3. Commands

List every command with syntax, flags, and a short example.

```markdown
### Search tweets
\`\`\`bash
bird search "query terms" -n COUNT --plain
\`\`\`
- `"query terms"` supports OR: `"AI agent OR Claude"`
- `-n COUNT` limits results (default 20)
- `--plain` for clean text output (always use this)
```

Key points:
- Show the full command, not just the concept
- Explain every flag
- Note defaults and recommendations

### 4. Negative Examples (the Most Important Section)

This is where most skills fail. AI agents hallucinate commands with confidence. If `bird view` does not exist, the agent will try it anyway, unless you explicitly say it does not exist.

```markdown
## CRITICAL: Commands That DO NOT Exist

- ~~`bird view`~~ DOES NOT EXIST. Use `bird read` instead.
- ~~`bird tweet`~~ DOES NOT EXIST for reading. Use `bird read`.
- ~~`bird timeline`~~ DOES NOT EXIST. Use `bird user-tweets` instead.
```

How to build this section:
1. Use the tool yourself for a week
2. Note every time the agent uses a wrong command
3. Add it to the negative examples
4. This section grows over time. That is normal.

### 5. Common Patterns

Recipes for real workflows. Not abstract descriptions. Actual command sequences.

```markdown
### Search and filter by engagement
\`\`\`bash
bird search "AI tool launch" -n 15 --plain | head -100
\`\`\`
Then filter results by like count in your analysis.
```

### 6. Output Handling

Many tools produce too much output. Cap it.

```markdown
## Output Capping

Always pipe through `head` to prevent output overflow:
\`\`\`bash
tool search "query" | head -100
\`\`\`
```

### 7. DO NOT Section

Hard rules that override everything else.

```markdown
## DO NOT

- Use `tool view` (does not exist)
- Skip auth setup
- Make more than 3 API requests per second
- Use jq for JSON parsing (crashes on null values)
```

---

## Skill Template

Here is a blank template you can copy to start a new skill. Save it as `skills/my-tool/SKILL.md` in your workspace.

```yaml
---
name: my-skill-name
description: "Use when [specific trigger conditions]. Contains [what's inside]."
---
```

```markdown
# [Tool Name]

_One-line description of what this tool does._

## Auth Setup

\`\`\`bash
source ~/.secrets.env
# Sets TOOL_API_KEY
\`\`\`

## Commands

### Command One

\`\`\`bash
tool action "argument" --flag VALUE
\`\`\`

## CRITICAL: Commands That DO NOT Exist

- ~~`tool wrong-command`~~ DOES NOT EXIST. Use `tool right-command` instead.

## Common Patterns

### Pattern: [Typical Use Case]

\`\`\`bash
tool action "query"
\`\`\`

## Output Handling

Always pipe through `head` to prevent output overflow:
\`\`\`bash
tool action | head -100
\`\`\`

## DO NOT

- Do not use deprecated commands
- Do not skip auth setup
- Do not run without output capping
```

---

## Testing Your Skill

1. **Create the skill file** in `skills/tool-name/SKILL.md` inside your workspace.
2. **Ask your agent** to do something that should trigger it.
3. **Watch what it does.** Did it find the skill? Use the right commands?
4. **Note mistakes.** Every wrong command goes in the negative examples section.
5. **Iterate.** Skills get better over time as you catch more edge cases.

---

## Common Mistakes

- **Writing descriptions that are too broad.** The skill activates for irrelevant requests and confuses the agent.
- **Skipping negative examples.** The agent will confidently use commands that do not exist.
- **Making auth setup unclear.** If the agent cannot authenticate, nothing else matters.
- **Not capping output.** Tool output can be enormous. Without `head` or truncation, it floods the context window.
- **Writing commands from memory instead of testing them.** Always test the exact command before putting it in a skill.

---

## Checklist

- [ ] Frontmatter has a specific, routing-friendly description
- [ ] Auth setup is copy-pasteable
- [ ] All commands shown with full syntax
- [ ] Negative examples section exists (even if small at first)
- [ ] Common patterns cover the main use cases
- [ ] Output capping instructions included
- [ ] DO NOT section has hard rules
- [ ] You have tested the commands yourself

---

For real examples, see the [examples/skills/](../examples/skills/) folder.
