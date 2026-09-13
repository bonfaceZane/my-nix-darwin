# Repo Map

Give OpenCode Aider-style structural awareness of a codebase without dumping
raw files into the context window.

## When to use

- Starting work in an unfamiliar or large repository.
- Before asking for a multi-file refactor.
- When the context window is filling up with raw file contents.

## Tools

- `ast-grep` — AST-based structural search (Tree-sitter under the hood).
- `repomix` — packs a repo into a single token-optimized payload.

## Workflow

1. Generate a compact structural map of the repository:

   ```bash
   ast-grep --pattern '$FUNC($$$ARGS) { $$$BODY }' --lang ts --json > .opencode/repo-map.json
   ```

   Adjust `--lang` and `--pattern` per language. Prefer signature-only patterns
   (function/class/import declarations) over full bodies.

2. For a broader, prompt-friendly outline, pack the repo:

   ```bash
   repomix --style xml --parsable-style --output .opencode/repomix-output.xml
   ```

3. Reference the generated artifacts in the session instead of raw files:

   ```
   @.opencode/repo-map.json
   @.opencode/repomix-output.xml
   ```

4. Keep `.opencode/` out of version control (add it to `.gitignore`).

## Token discipline

- Prefer the repo map over `@`-including whole directories.
- Run `/compact` when chat history grows.
- Use a strong reasoning model to plan, then switch to a cheaper model to edit.
