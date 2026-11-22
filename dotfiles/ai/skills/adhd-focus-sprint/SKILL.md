---
name: adhd-focus-sprint
description: Break coding and AI work into short, verifiable sprints with one next action, a clear done condition, and a parking lot for distractions. Use when a task feels vague, large, overwhelming, stalled, or starts drifting into a rabbit hole; not for one-line fixes.
---

# ADHD-friendly focus sprints

The goal is momentum, not a perfect plan. Reduce activation energy, make progress
visible, and always leave one obvious next action.

## At the start of a task

1. Restate the goal in one sentence, in the user's words where possible.
2. Define **done** as something observable: a command exits 0, a test passes, a
   screen renders, a file exists.
3. Choose the smallest useful slice. If the user asks for a large feature,
   propose the first slice and say what is deferred.
4. Give exactly **one** next action that takes 2–15 minutes.
   - If the user is stuck, make the first action a 2-minute activation step:
     open the file, run the failing test, reproduce the bug.
5. Put everything else in a **Parking lot**, not in the current sprint.

Use this card when the task will take more than a few minutes:

```
Goal:
Done when:
Next action (≤15 min):
Parked:
```

## While working

- End each batch at a verifiable checkpoint. Run the relevant test, build,
  typecheck, or take a screenshot.
- Report a checkpoint in 3–5 lines: what changed, what passed, what is next.
- If a step grows beyond the sprint, stop and split it. Do not silently expand
  scope.
- Treat "while we're here" changes as parking-lot items unless they block the
  current checkpoint.
- Prefer one file or one call path at a time. If you must touch several, say why
  first.

## Stop rules

- Timebox the sprint. When the box expires, summarize and choose: finish, split,
  or park.
- Leave the work at a clean stopping point: green tests, or a documented failing
  state with the exact next command.
- If the user is in a long hyperfocus session, surface the elapsed time and offer
  a save-and-stop option that makes resuming easy.
- Never end a turn without one next action or one clear question.

## Communication

- Short updates. No walls of text.
- At most one question per turn.
- Offer at most three options, and recommend one.
- If the user sounds overwhelmed, shrink the sprint instead of adding detail.
- Do not reopen a settled decision unless new evidence appears.

## Avoid

- Multi-file refactors with no checkpoint.
- A 20-step plan when the next two minutes are unclear.
- Opening many files "to get context" without a map; use `adhd-code-map`.
- Continuing past the stop rule because the task is almost done.
