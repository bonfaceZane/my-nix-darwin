---
name: adhd-code-map
description: Navigate unfamiliar or large code with a small, resumable map. Use when onboarding, debugging across files, or tracing behavior; not when editing code whose ownership is already clear.
---

# ADHD/autism-informed code mapping

Use a small map to keep the investigation oriented. Do not scan the whole
repository when one targeted path can answer the question.

## Before reading

State the question in one sentence:

- "Where does a check-in get validated?"
- "Why is this screen empty when the API is down?"
- "Which component owns this sheet?"

If the question is not explicit, infer the likely goal from the request and
state that interpretation briefly. Ask only if a different interpretation
would change the result materially.

## Build a three-level map

1. **Entry point** — the route, handler, command, or screen that starts the
   behaviour.
2. **Owning module** — the file or folder that owns the logic.
3. **One call path** — the next two or three calls, not the whole graph.

When it helps preserve context, write a compact map card (up to five lines):

```
Question:
Entry point:
Owning module:
Path:
What I still do not know:
```

## Read in small passes

- For symbols, callers, and impact, use CodeGraph first as required by the
  shared instructions. Use `rg` for plain-text, config, and documentation
  searches; read the relevant code before drawing conclusions.
- Read only the sections that answer the current question.
- Update the map at meaningful checkpoints, not after every file.
- Stop when the behavior and owning module are clear enough for the requested
  change. Expand the map if the task genuinely needs more depth.

## Before changing code

- Identify the likely owner and affected consumers when that helps scope the
  change.
- Identify the smallest edit that answers the question.
- Note important boundaries or behavior that must not change when scope
  depends on them.
- Make the focused change and verify it according to the user's request and
  project policy.

## If you get lost

- Return to the map card, or briefly restate the current question if no card is
  needed.
- Drop the current thread; do not keep opening files hoping for clarity.
- Ask one targeted question, or run one targeted search.
- If the answer is still unclear, write down the hypothesis and design the
  smallest experiment that would confirm or refute it.
