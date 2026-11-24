---
name: domain-modeling
description: Clarify domain concepts, names, relationships, and state models before changing TypeScript, Rust, API, or application behavior. Use when domain meaning is ambiguous or the model itself is changing.
---

# Domain modeling

Adapted from Matt Pocock's [`domain-modeling`](https://github.com/mattpocock/skills/blob/main/skills/engineering/domain-modeling/SKILL.md) skill. Use this for model changes, not as a mandatory step for every implementation task.

## Workflow

1. Read the relevant types, callers, user-facing language, and any existing
   glossary or architecture decisions. Follow the project's established terms.
2. Name the concepts and their ownership. Distinguish values from entities,
   identity from equality, and current state from derived state where it
   matters to the behavior.
3. Describe important invariants, transitions, and invalid combinations with
   concrete examples. Resolve contradictions against the existing code and
   product behavior before changing the model.
4. Choose types that make valid states clear and invalid states harder to
   represent. In TypeScript, consider discriminated unions and branded or
   domain-specific types when they improve safety. In Rust, consider enums,
   newtypes, and explicit error types. Follow local conventions and keep the
   model no more complex than its domain requires.
5. Keep names consistent across types, functions, files, UI, and API boundaries.
   Ask a concise question only when an unresolved distinction changes behavior.
6. Change the narrowest owning model and its affected consumers. Explain
   significant tradeoffs and compatibility implications.

## Project documentation

- Reuse an existing glossary or domain document when the repository has one.
  Update it only when a meaningful domain term was resolved and the document is
  intended to own that vocabulary.
- Create a glossary or ADR only when the user asks or the repository's
  established contribution process calls for it. Keep implementation notes out
  of glossaries and record only durable, non-obvious decisions in ADRs.
- Follow the user's and repository's testing policy when validating model
  changes; do not treat this skill as permission to add or run tests.

Source: [Matt Pocock's `domain-modeling`](https://github.com/mattpocock/skills/blob/main/skills/engineering/domain-modeling/SKILL.md), MIT-licensed.
