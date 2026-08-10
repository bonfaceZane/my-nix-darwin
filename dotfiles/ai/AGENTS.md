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
- GUI apps & formulae: `modules/homebrew/casks.nix` + `modules/homebrew/brews.nix` (managed via `nix-homebrew`, `homebrew.onActivation.cleanup = "zap"` enforces declarative state).
- System packages: `modules/system-packages.nix`
- User packages & language servers: `home/apps.nix` + `home/core.nix`
- Dotfiles: `home/dotfiles.nix` links `dotfiles/*` via `mkOutOfStoreSymlink` — edit there, then `darwin-rebuild switch --flake .#rafiki`.
- Secrets: `sops-nix` (`secrets.yaml` + `home/default.nix:sops`).
- After any change: `nix flake check` / `darwin-rebuild switch --flake .#rafiki` to verify.

## Atomic Commits
- Every commit is atomic: one logical change per commit, conventional commit message `<type>(<scope>): <description>` (imperative, <72 chars subject), as configured in `dotfiles/zed/settings.json:agent.commit_message_instructions` and `dotfiles/git/config`.
- Group related file changes together; split unrelated changes into separate commits.
- No fixup in a single atomic commit — use `git commit` per feature/fix/doc/refactor.

## Auto-Permissions (non-sensitive)
- By default, auto-allow file edits, builds, lints, tests, and safe reads that do not touch secrets, network exfiltration, or destructive system changes.
- Require explicit approval for: writes to `secrets.yaml`/keychain, `sops` re-encryption, network publishes, `brew cleanup --zap` deletions, `nix store` GC, or any `rm -rf` outside the workspace.
- This policy applies to Codex (`dotfiles/.codex/config.toml`), Muse (`dotfiles/.claude/settings.json` / `dotfiles/ai/.agent/settings.json`), and Gemini (`dotfiles/.gemini/settings.json` / `dotfiles/ai/.gemini/settings.json`).

## Skills
- This repo's AI skills are centrally documented here and mirror-linked via `home/dotfiles.nix:ghStackSkillTargets` to `.agents/skills`, `.codex/skills`, `.claude/skills`, etc. Keep skills immutable upstream, link them here.
