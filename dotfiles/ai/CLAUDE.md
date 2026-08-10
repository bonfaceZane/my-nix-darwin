<!-- nx configuration start-->
<!-- Leave the start & end comments to automatically receive updates. -->

# General Guidelines for working with Nx

- When running tasks (for example build, lint, test, e2e, etc.), always prefer running the task through `nx` (i.e. `nx run`, `nx run-many`, `nx affected`) instead of using the underlying tooling directly
- You have access to the Nx MCP server and its tools, use them to help the user
- When answering questions about the repository, use the `nx_workspace` tool first to gain an understanding of the workspace architecture where applicable.
- When working in individual projects, use the `nx_project_details` mcp tool to analyze and understand the specific project structure and dependencies
- For questions around nx configuration, best practices or if you're unsure, use the `nx_docs` tool to get relevant, up-to-date docs. Always use this instead of assuming things about nx configuration
- If the user needs help with an Nx configuration or project graph error, use the `nx_workspace` tool to get any errors
- For Nx plugin best practices, check `node_modules/@nx/<plugin>/PLUGIN.md`. Not all plugins have this file - proceed without it if unavailable.

<!-- nx configuration end-->

# Repo Conventions — my-nix-darwin

## Nix as Source of Truth
- All setup is done through Nix — no manual `brew install`/`npm -g`/`pip install`.
- GUI apps & formulae: `modules/homebrew/casks.nix` + `modules/homebrew/brews.nix` (managed via `nix-homebrew`; activation upgrades declared packages).
- System packages: `modules/system-packages.nix`
- User packages: `home/apps.nix` + `home/core.nix`
- Dotfiles: `home/dotfiles.nix` via `mkOutOfStoreSymlink`
- After change: `darwin-rebuild switch --flake .#rafiki`

## Atomic Commits
- Every commit atomic: one logical change, conventional commit `<type>(<scope>): <description>` imperative <72 chars.
- As in `dotfiles/zed/settings.json:agent.commit_message_instructions`.

## Auto-Permissions
- Auto-allow non-sensitive: file edits, builds, lints, tests, safe reads.
- Require approval: secrets.yaml, keychain, sops, network publish, `brew cleanup --zap`, destructive `rm -rf`.
- Applies to Codex, Muse, Gemini configs under `dotfiles/`.
