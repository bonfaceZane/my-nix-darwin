---
name: grilling
description: Shared protocol for the explicit-use grill-me and grill-with-docs workflows. Load only as part of one of those workflows.
---

# Grilling protocol

Adapted from Matt Pocock's [`grilling`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md) skill. Use this only after the user explicitly invokes a grill workflow.

## Interview rounds

- Build a decision tree for the plan or design. Ask only questions whose
  prerequisites are resolved; look up facts available from project files or
  tools instead of asking the user to repeat them.
- Ask at most one to three high-impact questions per round, each about one
  decision. Include a recommended answer and the practical tradeoff.
- Wait for the user's answer before making decisions that depend on it. Revisit
  the next unresolved questions after incorporating the answer.
- Stop when the important decisions are resolved. Summarize the agreed plan,
  open risks, and assumptions.
- Do not implement or create project artifacts as a consequence of the
  interview alone; wait for the user's implementation request.

Keep questions focused and concise. Do not use this workflow for routine coding
requests or when the user has not asked to be grilled.
