---
name: x-content-scan
description: "Scan X/Twitter for trending content opportunities. Finds high-engagement posts about topics in your niche. Use for reply pulse, content discovery, and trend scanning."
---

# X Content Scan

Scan X for trending posts you can reply to, quote tweet, or riff into original content.

## Prerequisites

- Use the `bird-cli` skill for all bird commands
- Auth: `source ~/.secrets.env && AUTH_TOKEN="$X_AUTH_TOKEN" CT0="$X_CT0"`

## Workflow

### 1. Run searches (pick 3-4, rotate across runs)

<!-- Customize these searches for your niche. These examples target AI/tech. Replace with your topics. -->

**Core searches (use at least 2 per run):**

```bash
# Breaking news in your niche
bird search "AI launch OR new model OR AI update OR AI release" -n 15 --plain | head -100

# Tools and products people are buzzing about
bird search "AI tool OR AI app OR AI demo OR built with AI" -n 15 --plain | head -100

# Your specific niche discourse
bird search "AI agent OR agentic OR AI workflow OR AI automation" -n 15 --plain | head -100

# Major players and companies
bird search "Claude OR GPT OR Gemini OR OpenAI OR Anthropic" -n 15 --plain | head -100
```

**Supplemental (1 per run, rotate):**

```bash
# Key accounts in your network (replace with accounts you follow)
bird user-tweets @ACCOUNT_1 -n 3 --plain | head -30
bird user-tweets @ACCOUNT_2 -n 3 --plain | head -30
```

### 2. Filter results

- **Pulse (frequent runs):** Posts from last 3 hours, 100+ likes
- **Deep scan (morning run):** Posts from last 24 hours, 500+ likes
- Use `bird read <url> --plain` to check engagement on promising posts
- Skip anything obviously promotional / newsletter spam / thread-bait with no substance

### 3. Deduplicate

Read a tracking file (e.g., `data/x-replied.json`, create as `[]` if missing). Skip URLs already in the file.

### 4. Recommend engagement type

For each post, recommend the best engagement method:

- **Reply to**: You can add genuine value (experience, technical insight, unique perspective)
- **Quote tweet**: Good for adding your take on top of a trending topic
- **Original post inspiration**: Trending topic you could write your own post about

**Do NOT force all three categories every scan.** If the best 5 posts are all replies, output 5 replies. Quality over category coverage.

### 5. Draft reply ideas

For EVERY post, write 1-2 draft replies/takes. These MUST:

- Follow your established writing style (check your style guide if you have one)
- Sound like a real person, not a bot. Casual, opinionated, specific.
- Reference actual experience where relevant (don't fabricate)
- Be the right length: replies = 1-3 sentences, quote tweets = 2-4 sentences
- Include humor/wit when it lands naturally (not forced)

**Reply style examples:**

- Hot take that adds to the conversation
- Personal experience that's relevant ("I run an AI agent that does X, and...")
- Genuine question that shows expertise
- Dry humor / sharp observation
- Counter-take with reasoning

### BANNED PATTERNS IN DRAFTS

These patterns are dead giveaways for AI-generated content. Zero tolerance.

**Banned structures:**

- "It's not X, it's Y" / "It's not just X, it's Y" / "That's not X, that's Y"
- "Don't do A. Do B." / "Stop X. Start Y."
- "Not only...but also" / "Less X, more Y"
- "Without X? Y. With X? Z."
- "From X to Y" false ranges
- Echo sentences ("It sounds X. It was X.")
- "Here's what nobody..." / "Here's the part no one talks about"
- Contrasting pairs of ANY form. State your point directly.

**Banned vocabulary:**

additionally, furthermore, moreover, testament to, landscape, showcasing, highlighting, crucial, vital, essential, tapestry, interplay, multifaceted, vibrant, breathtaking, delve, dive into, unpack, "it's worth noting," "in order to," "due to the fact that," "at the end of the day," "moving forward," "let me explain," "real value," "the best part?"

**Banned tones:**

- "pivotal moment," "revolutionary," "game-changing," "unparalleled"
- "experts agree" without naming the expert
- "time will tell" or any vague conclusion

**Banned hooks:**

- "I did X. Here's what I learned."
- "Here's what happened" / "Here's why"
- Question openers ("Want to know how I...?")
- "Most people think X. The reality is different."

**Before outputting any draft, mentally check it against these rules. If it violates any, rewrite it.**

### 6. Output format

```
🎯 **X Opportunities**

**Reply to:**
- [@handle] (likes, Xhr ago) - [one line context]
  💬 "[draft reply]"
  [link]

**Quote tweet:**
- [@handle] (likes, Xhr ago) - [one line context]
  💬 "[draft quote tweet text]"
  [link]

**Original post inspiration:**
- [trending topic] (Xhr ago) - [why it's hot right now]
  💬 "[draft post text]"
  [link to reference post]
```

**Freshness format:** Use relative time: "12m ago", "2hr ago", "5hr ago", "1d ago". Helps prioritize replies to fresher posts.

## What to reference in drafts

<!-- Replace this section with YOUR credentials, experience, and expertise. 
     This is what makes drafts authentic instead of generic. -->

- Your relevant experience and what you build
- Your unique perspective and niche expertise
- Your voice and communication style
- Specific projects or tools you actually use

## Rules

- Every post MUST have a clickable link
- 3-5 posts per scan (quality over quantity)
- Links format: `https://x.com/handle/status/ID`
- If nothing worth posting about: respond with NO_REPLY
- Prioritize TRENDING TOPICS and NEWS over any single account
- Do NOT pad with low-engagement filler just to hit 3 posts

## DO NOT

- Use `bird view` (doesn't exist, use `bird read`)
- Include posts older than the scan window
- Include posts already engaged with
- Include newsletter spam, engagement bait, or promotional threads
- Output anything other than the formatted opportunities or NO_REPLY
- Over-index on any single account
- Fabricate experiences or credentials in draft replies
