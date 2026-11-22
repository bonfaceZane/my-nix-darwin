---
name: adhd-code-map
description: Navigate unfamiliar or large code without losing the thread — build a small map, choose one entry point, follow one call path, and summarize before changing anything. Use when onboarding, debugging across files, or reading a large file or repository; not when editing a file you already understand.
---

# ADHD-friendly code mapping

Understanding is a sequence of small, closed questions. Do not open the whole
repository at once.

## Before reading

State the question in one sentence:

- "Where does a check-in get validated?"
- "Why is this screen empty when the API is down?"
- "Which component owns this sheet?"

If you cannot state the question, the task is not ready to read code. Use
`adhd-focus-sprint` to narrow it first.

## Build a three-level map

1. **Entry point** — the route, handler, command, or screen that starts the
   behaviour.
2. **Owning module** — the file or folder that owns the logic.
3. **One call path** — the next two or three calls, not the whole graph.

Write a five-line map card:

```
Question:
Entry point:
Owning module:
Path:
What I still do not know:
```

## Read in small passes

- Use `grep` and symbols before full-file reads.
- Read only the sections that answer the current question.
- After each file, add one line to the map card. If you cannot, you are reading
  without a question.
- Stop when you can explain the behaviour in five lines.
- If you have opened more than a handful of files without a summary, stop and
  write the map card.

## Before changing code

- Say which file owns the change and which files only consume it.
- Identify the smallest edit that answers the question.
- List what must not change.
- Then make one change and verify it.

## If you get lost

- Return to the map card and restate the question.
- Drop the current thread; do not keep opening files hoping for clarity.
- Ask one targeted question, or run one targeted search.
- If the answer is still unclear, write down the hypothesis and design the
  smallest experiment that would confirm or refute it.
