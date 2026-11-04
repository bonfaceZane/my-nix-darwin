# Shared agent instructions

## Working safely

- Follow the current repository's instructions and use its existing dependencies and tooling. Preserve unrelated user changes and other agents' work.
- Never read, print, copy, or commit credentials or secrets (including `secrets.yaml`, private `.env` files, keychain data, `~/.ssh`, and `~/.config/sops`). Treat `.sops.yaml` as sensitive configuration; do not change it without approval.
- Work within the client's existing approval and sandbox controls. These instructions do not grant tool permissions or replace an enforced security policy.
- Ask before publishing, pushing, committing, decrypting or re-encrypting secrets, activating system configuration, or performing destructive cleanup such as `brew cleanup --zap`, Nix garbage collection, or deletion outside the workspace.
- Do not bypass a denied operation using another tool, shell command, or MCP server.

## Nix-managed machine

- Manage machine setup through this Nix configuration, not manual `brew install`, global npm installs, or pip installs.
- When working in `my-nix-darwin`, locate the current module and Home Manager declarations before editing; module paths may change during refactors.
- Edit repository dotfile sources rather than generated files or symlink targets in the Nix store. Keep authentication and client-generated state outside version control.
- Validate changed syntax and run appropriate checks. In this Nix repository, use `nix flake check` when feasible; report failures and limitations accurately. `darwin-rebuild switch` changes the live system and requires approval, not automatic execution after every edit.

## Git

- Commit only when requested. Treat “commit” as a request to review staged and unstaged changes and split the authorized changes into atomic commits, one logical purpose per commit. Create multiple commits when changes have independent purposes; one cohesive change needs only one commit.
- Never create a commit unless the user explicitly requests one. A request to change instructions is not a request to commit.
- Before committing, inspect the complete Git status and both staged and unstaged diffs. Inventory every changed path and hunk, then identify which changes the user authorized. Do not infer authorization from staging, file proximity, or a request to commit other work.
- Preserve unrelated work exactly, including its staged or unstaged state. Do not stage, unstage, reset, restore, amend, or otherwise alter unrelated work. If a hunk mixes authorized and unrelated edits, stage only the authorized hunk; ask if ownership or inclusion is unclear.
- Make each commit one independently reviewable purpose, not one file. Keep implementation, directly related tests, and necessary documentation together. Split independently reviewable or revertible changes, including hunks within a file. Never bundle unrelated changes to reduce commit count.
- Stage only paths and hunks for the current purpose; never use blanket staging such as `git add .` or `git add -A`. Inspect the staged diff to confirm it contains only that purpose and no secrets or generated state. Run relevant checks before committing.
- Use one Conventional Commit subject per purpose: `<type>(<scope>): <description>`, imperative, specific, and under 72 characters. Do not combine purposes in one subject or body.
- After each commit, inspect the commit and Git status to confirm the intended changes were committed and unrelated work remains untouched. Summarize each commit and validation performed.
- Do not push, rewrite history, amend existing commits, or create branches without explicit authorization. A request to commit does not authorize these operations.

## Nx workspaces

- Apply Nx guidance only when the current repository actually uses Nx. Prefer its installed Nx tasks (`nx run`, `nx run-many`, `nx affected`) over invoking underlying tools directly.
- Use Nx MCP tools only if available in the current session; discover the actual tool names rather than assuming a particular server version.
- Consult current Nx documentation for configuration questions. Check `node_modules/@nx/<plugin>/PLUGIN.md` when present.
- Do not install Nx or start workspace-specific MCP servers globally just to satisfy these instructions.

## Skills and MCP

- Before using a skill supplied by the current repository, read the global `AGENTS.md` first, then the current repository's applicable `AGENTS.md`, then the skill's `SKILL.md`. Follow all three; user authorization and applicable agent instructions take precedence if they conflict with a skill.
- Use installed skills when their descriptions match the task. Load the skill's `SKILL.md` and follow its instructions, subject to the current task scope and permissions.
- Shared user skills live in `~/.agents/skills`; Claude Code additionally uses `~/.claude/skills`. Keep Nix-fetched upstream skills immutable and link individual skill directories without replacing user-owned skill collections.
- MCP configuration is client-specific. Do not assume that a shared `.mcp.json` is automatically loaded by every client, or that instructions alone enable a server.
- Use native Git tools when no Git MCP server is configured. Do not download an unverified MCP package as a substitute.

## Code intelligence

- `codegraph` is the primary MCP server for code intelligence and is configured for every client. Prefer its tools over ad-hoc searching when the question is about symbols, definitions, callers/callees, impact, or "where is this used".
- Run `codegraph init` once in a project that is not indexed yet, and `codegraph sync` after large changes; `codegraph status` shows index freshness. Without an index the server has nothing to answer from.
- Fall back to `ripgrep`/`grep` and the file tools for plain-text, configuration, documentation, and dependency files, which are not part of the symbol graph.
- Do not let codegraph answers replace reading the code you are about to change.
