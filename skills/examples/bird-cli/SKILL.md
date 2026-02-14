---
name: bird-cli
description: "X/Twitter CLI via the `bird` command. Use when searching tweets, reading tweets, fetching user timelines, or any X/Twitter interaction. Provides correct command syntax, auth pattern, and common pitfalls."
---

# bird CLI - X/Twitter Tool

## Auth Setup (REQUIRED before every bird command)

```bash
source ~/.secrets.env && AUTH_TOKEN="$X_AUTH_TOKEN" CT0="$X_CT0"
```

Both `AUTH_TOKEN` and `CT0` must be set. Without them, all commands fail silently or with auth errors.

## Commands

### Search tweets

```bash
bird search "query terms" -n COUNT --plain
```

- `"query terms"` supports OR: `"AI agent OR Claude OR coding"`
- `-n COUNT` limits results (default 20)
- `--plain` for clean text output (always use this)
- Pipe through `| head -N` to cap output length

### Read a specific tweet

```bash
bird read URL --plain
```

- Fetches full tweet content, replies, engagement stats
- URL format: `https://x.com/handle/status/ID`

### Fetch user's recent tweets

```bash
bird user-tweets @HANDLE -n COUNT --plain
```

- Gets a user's recent posts
- Always include `@` prefix

## CRITICAL: Commands That DO NOT Exist

- ~~`bird view`~~ DOES NOT EXIST. Use `bird read` instead.
- ~~`bird tweet`~~ DOES NOT EXIST for reading. Use `bird read` for fetching tweets.
- ~~`bird timeline`~~ DOES NOT EXIST. Use `bird user-tweets` instead.
- ~~`bird fetch`~~ DOES NOT EXIST. Use `bird read` instead.
- ~~`bird get`~~ DOES NOT EXIST. Use `bird read` instead.

## Output Capping

Always pipe through `head` to prevent output overflow:

```bash
bird search "AI agent" -n 15 --plain | head -100
bird user-tweets @example -n 5 --plain | head -40
```

## Common Patterns

### Search + filter by engagement

```bash
bird search "AI tool launch" -n 15 --plain | head -100
```

Then filter results by like count in your analysis.

### Check specific account activity

```bash
bird user-tweets @example -n 5 --plain | head -40
```

### Read a tweet for context before replying

```bash
bird read https://x.com/handle/status/12345 --plain
```

## DO NOT

- Use `bird view` (doesn't exist, use `bird read`)
- Forget to set auth before running commands
- Skip `--plain` flag (output will be messy)
- Skip output capping with `head` (output overflow risk)
