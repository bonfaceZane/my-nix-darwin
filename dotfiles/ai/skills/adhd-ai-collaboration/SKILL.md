---
name: adhd-ai-collaboration
description: Shape AI collaboration for a low-friction, ADHD-friendly workflow — short briefs, concise answers, one decision at a time, explicit recommendations, checkpoints, and protection against context switching. Use when briefing an AI, evaluating a large AI output, or working across long or multiple AI sessions; not for quick factual questions.
---

# ADHD-friendly AI collaboration

Treat the AI as a collaborator with a narrow brief, not an oracle. The aim is to
reduce decisions, context, and output size at every step.

## Brief the AI once

Before a substantial task, provide or ask for:

- **Goal** — one sentence.
- **Context** — the files, constraints, and prior decisions that matter.
- **Done when** — the observable finish line.
- **Do not touch** — files, APIs, or behaviours that are out of scope.
- **Output shape** — a plan, a patch, a diagnosis, or a short answer.

Template: `templates/brief.md`.

If the brief is missing and a wrong guess would be expensive, ask for it.
Otherwise state the assumption and proceed.

## Response shape

- Start with a 1–3 sentence TL;DR and the recommended next action.
- Put the detail after the answer, not before it.
- Show the relevant diff or a short excerpt, not a whole file, unless the user
  asks for the whole file.
- Use headings and checklists sparingly. A short paragraph is easier to act on
  than a wall of bullets.
- End with **exactly one** next action or one clear question.

## Decisions

- Present one decision at a time.
- If several are unavoidable, number them, give a recommendation for each, and
  say which one to answer first.
- Record the chosen option and the reason in the working brief
  (`adhd-context-keeper`).
- Do not reopen a settled decision without new evidence.

## Checkpoints

- After each substantial change, report: changed, verified, next.
- If the work is exploratory, timebox it and say what would make you stop.
- If the request expands mid-task, park the new item rather than absorbing it
  silently.

## Detect overload

When any of these appear, shrink the interaction:

- the user says "I don't know where to start", "too much", "lost", or "what now";
- the conversation has several open threads;
- the next step depends on more than one unresolved decision.

Response: restate the goal, list at most three open items, recommend one, and
give a single next action.

## Avoid

- Mega-prompts with several unrelated asks.
- "Fix everything" requests with no finish line.
- Accepting a large diff without a summary of what changed and what was verified.
- Repeating the whole context in every message; use the working brief.
- Long explanations of options the user did not ask about.
