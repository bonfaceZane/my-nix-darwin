# Token Discipline

Keep OpenCode sessions cheap and fast while preserving Aider-level capability.
Apply these rules by default; they are not optional.

## Context

- Never `@`-include a whole directory. Include specific files or line ranges.
- Prefer the repo map (`skills/repo-map`) and AST outlines (`skills/ast-outline`)
  over raw file dumps.
- Read files by symbol or line range once the map locates them.
- Drop stale context: run `/compact` when history grows or topics change.

## Editing

- Plan with a strong reasoning model, then switch to a cheaper model to apply
  edits. Do not burn reasoning tokens on mechanical changes.
- Make minimal, targeted edits. Avoid rewriting files wholesale.
- Batch related edits into one pass instead of many round-trips.

## Output

- Ask for diffs, not full files, when reviewing changes.
- Suppress verbose tool output; pipe through `head`, `jq`, or `--quiet`.
- Summarize long command output instead of pasting it verbatim.

## Parity with Aider

- Aider's repo map ranks symbols and emits signatures within a token budget.
  Mirror this with `skills/repo-map` and a `--map-tokens`-style cap.
- Aider reads only the files it needs; do the same via outlines and ranges.
- Aider uses `/tokens` to report usage; check usage before large operations.
