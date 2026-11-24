---
name: codebase-design
description: Design or refactor module responsibilities and interfaces so code stays cohesive, easy to understand, and straightforward to change. Use for architectural choices or when a focused change reveals unclear ownership.
---

# Codebase design

Adapted from Matt Pocock's [`codebase-design`](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md) skill. Use its deep-module ideas with this setup's functional style and React component rules.

## Design for clear ownership

- Read the repository's architecture and nearby code first. Keep existing
  conventions unless there is a concrete reason to change them.
- Give each module a clear responsibility and a small interface. Hide internal
  steps behind functions that express useful behavior instead of exporting
  implementation details to every caller.
- Prefer pure transformations and explicit inputs/outputs. Put I/O, framework
  integration, and other side effects at clear edges; keep domain logic
  independently understandable.
- Put behavior where it can be changed locally. Avoid pass-through wrappers,
  generic abstractions with one trivial caller, and interfaces that merely
  mirror the implementation.
- Define seams only when behavior actually needs to vary, such as a real
  external dependency or a second implementation. Do not add indirection just
  to make hypothetical future changes easier.
- Keep interfaces honest: include relevant invariants, errors, ordering, and
  performance expectations, not just parameter and return types.
- In React projects, continue to use the project's React vocabulary and the
  shared one-component-per-file rule. This skill does not mean one file per
  helper or a new package for every small piece of logic.

## Review a proposed boundary

Ask whether callers can do more with less knowledge, whether complexity stays
with its owner, and whether the interface exposes a stable behavior rather than
internal structure. If splitting a module only moves code around or adds
forwarding layers, keep it cohesive and simpler.

Testability is a design property, not an instruction to add tests by default.
Follow the repository's testing policy and the user's request when choosing
whether and how to test.
