# Workspace Files

Your agent uses these files to know who it is and how to behave. They live in your agent's workspace folder (the folder OpenClaw points to). OpenClaw creates most of them automatically when you run `openclaw onboard`, so you do not need to build them from scratch.

This guide explains what each file does, what goes in it, and when you would edit it.

---

## SOUL.md

**What it is:** Your agent's personality. Its voice, humor, boundaries, and core values.

**What goes in it:** How your agent should behave, how formal or casual it sounds, what kind of humor it uses, and any lines it should never cross.

**Example snippet:**

```markdown
## Core Truths

**Be genuinely helpful, not performatively helpful.** Skip the "Great question!" and
"I'd be happy to help!" Just help.

**Have opinions.** You're allowed to disagree, prefer things, find stuff amusing or boring.

## Voice & Humor

Dry wit, sharp, competence first. Humor setting: 20%.

## Boundaries

- Private things stay private. Period.
- When in doubt, ask before acting externally.
```

**When to edit it:** When you want your agent to sound different, be funnier (or less funny), set new boundaries, or shift its overall vibe. If your agent changes this file, it should tell you. It is literally its soul.

---

## USER.md

**What it is:** What your agent knows about you. Name, timezone, preferences, projects, communication style.

**What goes in it:** Basic info about you and any context that helps your agent be more helpful. Your agent fills this in during your first conversation and updates it over time.

**Example snippet:**

```markdown
- **Name:** Jane
- **What to call them:** Jane
- **Pronouns:** she/her
- **Timezone:** America/New_York
- **Notes:** Product manager at a startup. Prefers concise answers.
```

**When to edit it:** You usually do not need to edit this directly. Your agent fills it in and updates it as you chat. But you can add things manually if you want.

---

## IDENTITY.md

**What it is:** Your agent's name, emoji, avatar, and "creature type" (AI assistant, familiar, ghost in the machine, whatever feels right).

**What goes in it:** A quick identity card. Gets set up during the first conversation.

**Example snippet:**

```markdown
- **Name:** Nova
- **Creature:** AI familiar
- **Vibe:** Sharp, warm, slightly chaotic
- **Emoji:** 🌀
- **Avatar:** avatars/nova.png
```

**When to edit it:** When you want to rename your agent, change its emoji, or update its avatar image.

---

## MEMORY.md

**What it is:** Long-term memory. The curated, distilled version of everything important your agent has learned over time.

**What goes in it:** Key facts about you, active projects, infrastructure details, hard rules, pending actions, personal context, and lessons learned. Think of daily memory files as journal entries. MEMORY.md is the wisdom your agent has extracted from those entries.

**Example snippet:**

```markdown
## About Jane

- **Location:** San Francisco
- **Work:** Product manager at a startup
- **Pet peeves:** Sycophantic AI responses, unnecessary meetings

## Active Projects

- **Project Alpha:** Mobile app redesign. In testing phase. Due March 15.

## Hard Rules

- ASK before sending any emails or public posts
- Always use Eastern Time, never UTC
```

**Security note:** This file only loads in private (one on one) sessions with you. It never loads in group chats, so your personal context stays private.

**When to edit it:** Your agent manages this file itself, but you can add or remove things anytime.

---

## AGENTS.md

**What it is:** The "rules of the house." It tells your agent how to behave in every session: what to read on startup, how to handle memory, safety guidelines, when to speak in group chats, and how to use heartbeats (periodic check-ins).

**What goes in it:** Startup routines, memory management rules, safety policies, group chat behavior, and heartbeat configuration.

**Example snippet:**

```markdown
## Every Session

Before doing anything else:

1. Read SOUL.md. This is who you are.
2. Read USER.md. This is who you're helping.
3. Read memory/YYYY-MM-DD.md (today + yesterday) for recent context.

## Safety

- Don't exfiltrate private data. Ever.
- Don't run destructive commands without asking.
- trash > rm (recoverable beats gone forever)
```

**When to edit it:** When you want to change how your agent handles group chats, what it checks during heartbeats, or its general operating rules. Think of it as the employee handbook for your AI.

---

## TOOLS.md

**What it is:** A personal cheat sheet for environment-specific details. Skills (separate files) define how tools work in general. TOOLS.md holds the specifics that are unique to your setup.

**What goes in it:** Camera names, SSH hosts, preferred TTS voices, device nicknames, speaker/room names, and anything else specific to your environment.

**Example snippet:**

```markdown
### Cameras

- living-room: Main area, 180 degree wide angle
- front-door: Entrance, motion-triggered

### SSH

- home-server: 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

**When to edit it:** Whenever you add new devices, services, or tools to your setup.

---

## HEARTBEAT.md

**What it is:** A checklist your agent runs through during periodic heartbeat polls. Heartbeats are automatic check-ins that happen every 30 minutes or so.

**What goes in it:** Tasks you want your agent to check on proactively, like "check email," "review calendar," or "scan for notifications."

**Example snippet:**

```markdown
- [ ] Check email for urgent messages
- [ ] Review calendar for events in next 2 hours
- [ ] Check weather if outdoor plans today
```

**Tip:** Keep this file small. The bigger it is, the more tokens (and cost) each heartbeat burns. Stick to 3 to 5 items.

**When to edit it:** When you want your agent to proactively check on things without you asking. Add items to the checklist, remove ones you do not need.

---

## BOOTSTRAP.md

**What it is:** The "first run" script. When your agent wakes up for the very first time, it reads this file and starts a conversation with you to figure out its personality, learn about you, and set up the workspace.

**What goes in it:** Instructions for how the onboarding conversation should flow. After the first conversation, the agent deletes this file. It is a one-time thing.

**Example snippet:**

```markdown
Start with something like:

> "Hey. I just came online. Who am I? Who are you?"

Then figure out together:

1. Your name. What should they call you?
2. Your nature. What kind of creature are you?
3. Your vibe. Formal? Casual? Snarky? Warm?
4. Your emoji. Everyone needs a signature.
```

**When to edit it:** Before your agent's first run, if you want to change how the onboarding conversation flows. After that, this file is gone and does not matter.

---

## How These Files Work Together

When your agent starts a session, it reads AGENTS.md first to know the rules. Then it reads SOUL.md to remember its personality, USER.md to remember who you are, and recent memory files for context. IDENTITY.md, TOOLS.md, and HEARTBEAT.md are referenced as needed.

The [Initialization Prompt](../INITIALIZATION-PROMPT.md) fills in most of these files automatically during your first conversation, so you do not need to write them by hand. They are here so you can see what goes into each file and tweak yours with confidence.
