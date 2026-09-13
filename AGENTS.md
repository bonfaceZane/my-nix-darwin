# Contributing to my-nix-darwin

This is a single-user Apple Silicon macOS configuration, not a Node/Nx application. Read `README.md` and, for AI setup, `dotfiles/ai/README.md`.

## Ownership

- `flake.nix` / `flake.lock`: composition and pinned inputs; host is `rafiki`.
- `modules/`: system-level nix-darwin options. Homebrew declarations are split under `modules/homebrew/`.
- `home/default.nix`: explicit Home Manager imports.
- `home/app-settings/`: shell, Git, Starship, and mise settings.
- `home/dotfiles.nix`: links to this checkout's `dotfiles/` and initial Codex configs.
- `dotfiles/`: editable application config sources. Do not move them without updating their consumers.
- `dotfiles/opencode/`: global OpenCode config (LSP servers, skills, OpenViking plugin) linked to `~/.config/opencode`; `opencode.local.json` is the per-project template and `memory/` is the plugin's persistent store.
- `dotfiles/setup.sh`: idempotently wires the OpenCode config globally and, for projects that lack one, writes a local `opencode.json`.
- `dotfiles/mise/config.toml`: declares CLI tools, including Aider; the Aider BYOK environment lives in the per-shell configs under `dotfiles/`.
- `.agents/skills/nix-darwin-maintenance/`: focused maintenance workflow.
- `.github/copilot-instructions.md` and `dotfiles/.cursor/rules/agents.mdc`: client entry points that defer to this file.
- `.junie/memory/`: local agent memory; keep it out of commits unless explicitly requested.

## Safe changes

Inspect Git status and preserve unrelated work. Do not read, print, copy, decrypt, or commit credentials, private environment files, `secrets.yaml`, or client auth/session state. Do not edit `.sops.yaml` without approval. Do not bypass denied operations through another tool. Treat OpenViking memory under `dotfiles/opencode/memory/` as user data: review it before committing and never store credentials or secrets in it.

Keep existing module boundaries and explicit imports. Prefer first-class Nix options; verify option names/types against pinned inputs. Do not install tools manually with Brew/npm/pip when the package can be declared here. No branch creation, commits, pushes, input updates, garbage collection, destructive cleanup, or system activation unless requested.

AI instructions are not permissions. Keep approval/sandbox protections; do not enable blanket auto-approval to make an agent more capable. Sync client-specific settings in their native format rather than copying Claude JSON into Codex. Keep existing writable Codex config separate from the tracked seed. Do not commit `opencode.json` files written by `dotfiles/setup.sh`; only `dotfiles/opencode/opencode.json` and `opencode.local.json` are tracked.

## Atomic commits

- Commit only when requested. Treat “commit” as a request to review staged and unstaged changes and split the authorized changes into atomic commits, one logical purpose per commit. Create multiple commits when changes have independent purposes; one cohesive change needs only one commit.
- Atomic means one logical change, not one file. Keep related implementation, tests, and documentation together; split hunks within a file when needed. Do not group unrelated changes merely because they are already staged.
- Preserve unrelated user work and its staging state. Ask if its inclusion is unclear. Inspect each staged diff before committing and run checks appropriate to that change.
- Use a Conventional Commit subject: `<type>(<scope>): <description>`, imperative and under 72 characters. Summarize the resulting commits and validation.
- Do not push, rewrite history, or create branches without explicit authorization. A request to commit does not authorize these operations.

## Validation

1. `python3 scripts/validate-config.py` (Python 3.11+; named non-secret config files only).
2. `nix-instantiate --parse <changed-file.nix>` and `git diff --check`.
3. The validator also parses `dotfiles/opencode/opencode.json` and `opencode.local.json`; do not run `dotfiles/setup.sh` (or `mise run oc-setup`) as a validation step, since it writes to live config locations.
3. `mise run build` or `darwin-rebuild build --flake .#rafiki --show-trace --impure` when feasible; this builds but does not activate. `nix flake check --impure` is another broader check.
4. Report any unavailable tools, network/build failures, and untested runtime behavior. Never claim a syntax check validates the deployed system or live MCP connections.

`mise run switch` activates the system using sudo and may upgrade Homebrew apps. Leave activation to the user unless explicitly authorized. Newly added files must be included in Git before normal Git-backed flake builds can see them; do not stage unrelated work.
