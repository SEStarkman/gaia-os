# Creating Skills

A detailed guide to building skills that actually work in production.

## What Is a Skill?

A skill is a markdown file that teaches your agent how to use a tool. It lives at `skills/tool-name/SKILL.md` and contains everything the agent needs: authentication, commands, patterns, and (critically) what NOT to do.

## The Description Is Routing Logic

The most important line in any skill is the `description` in the frontmatter:

```yaml
---
name: my-tool
description: "Use when searching tweets, reading tweets, fetching user timelines, or any X/Twitter interaction."
---
```

OpenClaw reads this description to decide which skill to load. If the description is vague, the skill won't activate when it should. If it's too broad, it'll activate when it shouldn't.

**Good descriptions:**
- "Use when searching tweets, reading tweets, fetching user timelines, or any X/Twitter interaction."
- "Use when creating, reading, updating, or querying Notion pages and databases."
- "Use when given a meeting transcript to process into a structured summary."

**Bad descriptions:**
- "Twitter stuff" (too vague. When does this activate?)
- "Useful tool for many things" (meaningless. This matches everything and nothing.)
- "CLI tool" (which CLI tool? For what?)

### Tips for Descriptions

1. **List specific trigger phrases.** "Use when searching tweets, reading tweets, fetching user timelines" covers the main use cases.
2. **Mention the tool name.** "Via the `bird` command" helps routing when the user asks by tool name.
3. **Include the domain.** "X/Twitter interaction" catches requests that don't mention the tool name.

## Anatomy of a Good Skill

### 1. Auth Setup

Make it copy-pasteable. The agent should be able to run the auth commands without thinking.

```markdown
## Auth Setup (REQUIRED before every command)

\`\`\`bash
source ~/.secrets.env && AUTH_TOKEN="$X_AUTH_TOKEN" CT0="$X_CT0"
\`\`\`

Both `AUTH_TOKEN` and `CT0` must be set. Without them, all commands fail silently.
```

**Key points:**
- Show the exact commands
- Explain what gets set and why
- Mention failure modes ("fail silently" vs "throw an error")

### 2. Commands

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

**Key points:**
- Show the full command, not just the concept
- Explain every flag
- Note defaults and recommendations

### 3. Negative Examples (The Most Important Section)

This is where most skills fail. AI agents hallucinate commands with total confidence. If `bird view` doesn't exist, the agent will try it anyway, unless you explicitly say it doesn't exist.

```markdown
## CRITICAL: Commands That DO NOT Exist

- ~~`bird view`~~ DOES NOT EXIST. Use `bird read` instead.
- ~~`bird tweet`~~ DOES NOT EXIST for reading. Use `bird read`.
- ~~`bird timeline`~~ DOES NOT EXIST. Use `bird user-tweets` instead.
```

**How to build this section:**
1. Use the tool yourself for a week
2. Note every time the agent uses a wrong command
3. Add it to the negative examples
4. This section grows over time. That's normal.

### 4. Common Patterns

Recipes for real workflows. Not abstract descriptions. Actual command sequences.

```markdown
### Search + filter by engagement
\`\`\`bash
bird search "AI tool launch" -n 15 --plain | head -100
\`\`\`
Then filter results by like count in your analysis (100+ for pulse, 500+ for deep scan).
```

### 5. Output Handling

Many tools produce too much output. Cap it.

```markdown
## Output Capping

Always pipe through `head` to prevent output overflow:
\`\`\`bash
tool search "query" | head -100
\`\`\`
```

### 6. DO NOT Section

Hard rules that override everything else.

```markdown
## DO NOT

- Use `tool view` (doesn't exist)
- Skip auth setup
- Make more than 3 API requests/second
- Use jq for JSON parsing (crashes on null values)
```

## Testing Your Skill

1. **Create the skill file** in `skills/tool-name/SKILL.md`
2. **Ask your agent** to do something that should trigger it
3. **Watch what it does.** Did it find the skill? Use the right commands?
4. **Note mistakes.** Every wrong command goes in the negative examples section.
5. **Iterate.** Skills get better over time as you catch more edge cases.

## Common Mistakes

### Writing descriptions that are too broad
The skill activates for irrelevant requests and confuses the agent.

### Skipping negative examples
The agent will confidently use commands that don't exist.

### Making auth setup unclear
If the agent can't authenticate, nothing else matters.

### Not capping output
Tool output can be enormous. Without `head` or truncation, it floods the context window.

### Writing commands from memory instead of testing them
Always test the exact command before putting it in a skill. One wrong flag wastes the agent's (and your) time.

## Skill File Checklist

- [ ] Frontmatter has specific, routing-friendly description
- [ ] Auth setup is copy-pasteable
- [ ] All commands shown with full syntax
- [ ] Negative examples section exists (even if small at first)
- [ ] Common patterns cover the main use cases
- [ ] Output capping instructions included
- [ ] DO NOT section has hard rules
- [ ] You've tested the commands yourself
