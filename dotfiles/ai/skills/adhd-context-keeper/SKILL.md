---
name: adhd-context-keeper
description: Maintain a compact external working memory for multi-step or multi-session coding work — goal, state, decisions, open questions, parked ideas, and the next action. Use at session start or end, before a context switch, after a decision, or when the user seems to have lost the thread; not for single-step questions.
---

# ADHD-friendly context keeper

Do not make the user hold the task in their head. Keep a short, current brief
that anyone, including a fresh session, can resume from.

## The brief

Keep it to 15 lines or fewer, with these sections:

- **Goal** — one sentence.
- **Done when** — observable outcome.
- **State** — branch, files touched, last verified command and result.
- **Decisions** — what was chosen and why, one line each.
- **Open questions** — what is genuinely unresolved.
- **Parked** — ideas deliberately deferred.
- **Next action** — exactly one.

Template: `templates/working-memory.md`.

## Where to keep it

- Default: in the conversation. Put the brief at the top of the first substantive
  update and refresh it at checkpoints.
- If the work spans sessions and the user wants persistence, propose **one**
  scratch file, for example `NOTES.md` or `.agent/working-memory.md`.
  - Ask before creating a file in a repository.
  - Never commit it unless asked.
  - If it is not meant to be shared, suggest adding it to `.gitignore`.
- Do not create a second notes file if the project already has one. Use the
  existing file and match its style.

## When to update

- At the start of any task expected to span more than one turn.
- After a real decision, discovery, or failed approach.
- Before switching tasks or files.
- At the end of a session: write a **Resume here** line with the next action and
  any command to run first.
- When the user asks "where were we?" — read the brief back before doing
  anything else.

## Rules

- The brief is a dashboard, not a diary. Prune resolved items.
- Record **why**, not a transcript.
- Keep the next action concrete enough to start without rereading the
  conversation.
- If the brief and the conversation disagree, trust the code and the latest
  verified result, then update the brief.
- If the task is small, skip the brief. The overhead must stay lower than the
  memory it replaces.

## Handoff

When another person or agent will continue, add:

- what is safe to change,
- what must not be touched,
- the exact command that shows the current state.
