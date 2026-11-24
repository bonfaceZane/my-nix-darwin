---
name: adhd-context-keeper
description: Keep a concise, resumable brief for multi-step or multi-session work, capturing the goal, verified state, decisions, open questions, and a useful resume point. Use when work spans sessions, changes direction, or risks losing important context; not for single-step questions.
---

# ADHD/autism-informed context keeper

Reduce the amount of task state the user must keep in working memory. Keep a
brief only when it saves more effort than it adds, and make it easy for a fresh
session to resume.

## The brief

Keep it short and scannable. Include only the sections useful for this task:

- **Goal** — one sentence.
- **Done when** — observable outcome.
- **State** — branch, files touched, last verified command and result.
- **Decisions** — what was chosen and why, one line each.
- **Open questions** — what is genuinely unresolved.
- **Parked** — ideas deliberately deferred.
- **Resume point** — the most useful next action, when work is still active.

Use `templates/working-memory.md` as an optional aid. Omit sections that do not
help; this is a working note, not a form the user must fill in.

## Where to keep it

- Default: in the conversation. Share or refresh it at useful checkpoints,
  context switches, or when the user asks for status; do not prepend it to every
  update.
- If the work spans sessions and the user wants persistence, propose **one**
  scratch file, for example `NOTES.md` or `.agent/working-memory.md`.
  - Ask before creating a file in a repository.
  - Never commit it unless asked.
  - If it is not meant to be shared, suggest adding it to `.gitignore`.
- Do not create a second notes file if the project already has one. Use the
  existing file and match its style.

## When to update

- At the start of a task expected to span sessions, or when the active context
  is already crowded.
- After a real decision, discovery, or failed approach.
- Before switching tasks or files.
- At the end of a session: include a **Resume here** line with the next action
  and any command to run first.
- When the user asks "where were we?" — read the brief back before doing
  anything else.

## Rules

- The brief is a dashboard, not a diary. Prune resolved items.
- Record **why**, not a transcript.
- Keep the resume point concrete enough to start without rereading the whole
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
