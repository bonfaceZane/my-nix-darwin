# AST Outline

Produce a signature-only outline of a file or directory so the model can reason
about structure without paying for full bodies. This is the on-demand companion
to the repo map.

## When to use

- Before editing a file: get its shape, then read only the relevant ranges.
- When a repo map is too coarse and you need one file's structure.
- When deciding which symbols to `@`-include.

## Tools

- `ast-grep` — AST-based structural search (Tree-sitter under the hood).
- `ctags` / `universal-ctags` — fast symbol index for many languages.
- `tree-sitter` CLI — parse and query when ast-grep patterns are awkward.

## Workflow

1. Outline a single file (signatures only):

   ```bash
   ast-grep --pattern '$FUNC($$$ARGS) { $$$BODY }' --lang ts --json path/to/file.ts \
     | jq -r '.[] | "\(.range.start.line): \(.text | split("\n")[0])"'
   ```

2. Outline a directory with ctags (language-agnostic, very cheap):

   ```bash
   ctags -R --fields=+n -f - . | awk '{print $1, $2, $3, $4}'
   ```

3. For classes, interfaces, and imports, add patterns:

   ```bash
   ast-grep --pattern 'class $NAME { $$$BODY }' --lang ts --json .
   ast-grep --pattern 'import $$$X from $MOD' --lang ts --json .
   ```

4. Feed the outline to the model, then read only the ranges you need:

   ```
   @path/to/file.ts:42-88
   ```

## Rules

- Never dump full file bodies when an outline suffices.
- Prefer line ranges over whole-file includes.
- Re-run the outline after edits instead of re-reading the whole file.
- Keep outlines in `.opencode/` and out of version control.
