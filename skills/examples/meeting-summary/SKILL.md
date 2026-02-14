---
name: meeting-summary
description: "Process meeting transcripts into structured summaries. Use when given a transcript (from Otter.ai, manual paste, audio transcription, or file). Extracts action items, decisions, key topics, and follow-ups."
---

# Meeting Summary

Process meeting transcripts into clean, actionable summaries.

## Input Methods

This skill handles transcripts from any source:

1. **Pasted text** — Human pastes transcript directly into chat
2. **File reference** — Human points to a file: `memory/meetings/2026-01-15-standup.txt`
3. **Otter.ai export** — Copy-pasted from Otter.ai transcript view
4. **Audio transcription** — If your setup has speech-to-text, transcribe first then process

## Workflow

### 1. Receive the transcript

If pasted directly, acknowledge and start processing. If referenced as a file, read it first.

For very long transcripts (>50K chars), process in chunks — summarize each section, then synthesize.

### 2. Extract structure

Pull out these elements:

- **Meeting type** — standup, 1:1, client call, brainstorm, etc.
- **Attendees** — who was there (from speaker labels or context)
- **Duration** — if timestamps are available
- **Key topics discussed** — major subjects, in order
- **Decisions made** — anything that was agreed on
- **Action items** — who's doing what, with deadlines if mentioned
- **Open questions** — things raised but not resolved
- **Follow-ups needed** — next steps, future meetings, things to check

### 3. Output format

```markdown
# Meeting Summary: [Topic/Type]
**Date:** YYYY-MM-DD
**Attendees:** [names]
**Duration:** [if known]

## Key Topics
- [Topic 1]: [2-3 sentence summary of discussion]
- [Topic 2]: [2-3 sentence summary]

## Decisions
- [Decision 1]
- [Decision 2]

## Action Items
- [ ] [Person]: [Task] (by [deadline if mentioned])
- [ ] [Person]: [Task]

## Open Questions
- [Question that wasn't resolved]

## Follow-ups
- [Next step or future meeting needed]

## Raw Notes
[Optional: any important quotes or details worth preserving verbatim]
```

### 4. Save the summary

Save to `memory/meetings/YYYY-MM-DD-[topic].md` unless the human specifies a different location.

Update today's daily memory file with a reference:
```markdown
## Meetings
- Processed [meeting type] transcript → memory/meetings/YYYY-MM-DD-[topic].md
- Key decisions: [1-2 line summary]
```

## Tips for Better Summaries

- **Speaker attribution matters.** If the transcript has speaker labels, use them for action items. "John will handle X" is better than "someone will handle X."
- **Don't over-summarize.** If a topic was discussed for 20 minutes, it deserves more than one bullet point.
- **Preserve specific numbers, dates, and names.** "Revenue target of $500K by Q3" not "discussed revenue targets."
- **Flag disagreements.** If people disagreed on something, note both positions. The human needs to know.
- **Action items are the most important output.** Get these right above all else.

## Handling Poor Transcripts

Otter.ai and similar tools produce imperfect transcripts. Common issues:

- **Misattributed speakers** — Note when you're uncertain who said what
- **Garbled text** — Mark unclear sections with `[unclear]` rather than guessing
- **Missing context** — Ask the human to clarify if a decision hinges on something you can't parse
- **Filler words** — Strip "um", "uh", "you know" from quotes. Keep the meaning, drop the noise.

## DO NOT

- Fabricate action items or decisions that aren't in the transcript
- Attribute statements to the wrong person (when unsure, say "someone mentioned")
- Skip the action items section even if none are explicit (note "No explicit action items identified")
- Over-editorialize — summarize what was said, don't add your opinion unless asked
- Lose specific details (numbers, dates, names) in the summarization
