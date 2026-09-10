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

- Commit only when requested. Keep each commit to one logical change and use a conventional commit subject: `<type>(<scope>): <description>`, imperative and under 72 characters.
- Do not rewrite history or create branches without authorization.

## Nx workspaces

- Apply Nx guidance only when the current repository actually uses Nx. Prefer its installed Nx tasks (`nx run`, `nx run-many`, `nx affected`) over invoking underlying tools directly.
- Use Nx MCP tools only if available in the current session; discover the actual tool names rather than assuming a particular server version.
- Consult current Nx documentation for configuration questions. Check `node_modules/@nx/<plugin>/PLUGIN.md` when present.
- Do not install Nx or start workspace-specific MCP servers globally just to satisfy these instructions.

## Skills and MCP

- Use installed skills when their descriptions match the task. Load the skill's `SKILL.md` and follow its instructions, subject to the current task scope and permissions.
- Shared user skills live in `~/.agents/skills`; Claude Code additionally uses `~/.claude/skills`. Keep Nix-fetched upstream skills immutable and link individual skill directories without replacing user-owned skill collections.
- MCP configuration is client-specific. Do not assume that a shared `.mcp.json` is automatically loaded by every client, or that instructions alone enable a server.
- Use native Git tools when no Git MCP server is configured. Do not download an unverified MCP package as a substitute.
