# Workspace Templates

These are the files that live in your agent's workspace (the folder OpenClaw points to). They define your agent's personality, memory, behavior, and structure.

**These are reference copies.** Browse them, understand what each one does, then customize the versions in your own workspace. OpenClaw creates most of these automatically when you run `openclaw onboard`, so you do not need to copy them manually. They are here so you can see what goes into each file and tweak yours with confidence.

---

## What Each File Does

### AGENTS.md

The "rules of the house." This file tells your agent how to behave in every session: what to read on startup, how to handle memory, safety guidelines, when to speak in group chats, and how to use heartbeats (periodic check-ins).

Think of it as the employee handbook for your AI.

**When to customize:** When you want to change how your agent handles group chats, what it checks during heartbeats, or its general operating rules.

---

### SOUL.md

Your agent's personality. Its voice, humor level, boundaries, and core values. This file gets filled in during the first conversation (the bootstrap), but you can edit it anytime.

If you change this file, your agent's personality changes. It is literally its soul.

**When to customize:** When you want your agent to sound different, be funnier (or less funny), set new boundaries, or shift its overall vibe.

---

### USER.md

What your agent knows about you. Name, timezone, preferences, projects, communication style. The agent updates this over time as it learns about you.

**When to customize:** You usually do not need to edit this directly. Your agent fills it in during the first conversation and updates it as you chat. But you can add things manually if you want.

---

### IDENTITY.md

Your agent's name, emoji, avatar, and "creature type" (AI assistant, familiar, ghost in the machine, whatever feels right). A quick identity card that gets set up during the bootstrap.

**When to customize:** When you want to rename your agent, change its emoji, or update its avatar image.

---

### MEMORY.md

Long-term memory. The curated, distilled version of everything important your agent has learned over time. This is separate from daily memory files, which are raw logs.

Think of daily files as journal entries. MEMORY.md is the wisdom your agent has extracted from those entries.

**Security note:** This file only loads in private (one-on-one) sessions with you. It never loads in group chats, so your personal context stays private.

**When to customize:** Your agent manages this file itself, but you can add or remove things anytime.

---

### TOOLS.md

A personal cheat sheet for environment-specific details: camera names, SSH hosts, preferred voices, device nicknames. Skills (in the skills folder) define how tools work in general. TOOLS.md holds the specifics that are unique to your setup.

**When to customize:** Whenever you add new devices, services, or tools to your setup. This is your agent's quick-reference card.

---

### HEARTBEAT.md

A checklist your agent runs through during periodic heartbeat polls (automatic check-ins that happen every 30 minutes or so). You can add tasks like "check email," "review calendar," or "scan for notifications."

Keep this file small. The bigger it is, the more tokens (and cost) each heartbeat burns.

**When to customize:** When you want your agent to proactively check on things without you asking. Add items to the checklist, remove ones you do not need.

---

### BOOTSTRAP.md

The "first run" script. When your agent wakes up for the very first time, it reads this file and starts a conversation with you to figure out its personality, learn about you, and set up the workspace.

After the first conversation, the agent deletes this file. It is a one-time thing.

**When to customize:** Before your agent's first run, if you want to change how the onboarding conversation flows. After that, this file is gone and does not matter.

---

## How to Use These Templates

1. **Browse the files here** to understand what each one does.
2. **Run `openclaw onboard`** to set up your workspace. OpenClaw creates these files for you.
3. **Compare your workspace files** with these templates to see if there are sections you want to add or ideas you want to borrow.
4. **Copy specific sections** into your own files as needed. No need to replace entire files.

You can also share these templates with teammates or collaborators who are setting up their own agents.
