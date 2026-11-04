# Contributing to my-nix-darwin

This is a single-user Apple Silicon macOS configuration, not a Node/Nx application. Read `README.md` and, for AI setup, `dotfiles/ai/README.md`.

## Ownership

- `flake.nix` / `flake.lock`: composition and pinned inputs; host is `rafiki`.
- `modules/`: system-level nix-darwin options. Homebrew declarations are split under `modules/homebrew/`.
- `home/default.nix`: explicit Home Manager imports.
- `home/app-settings/`: shell, Git, Starship, and mise settings.
- `home/dotfiles.nix`: links to this checkout's `dotfiles/` and initial Codex configs.
- `dotfiles/`: editable application config sources. Do not move them without updating their consumers.
- `dotfiles/mise/config.toml`: declares CLI tools, including Aider; the Aider BYOK environment lives in the per-shell configs under `dotfiles/`.
- `dotfiles/ai/skills/nix-darwin-maintenance/`: shared, Nix-managed maintenance workflow; linked into user skill discovery paths.
- `.github/copilot-instructions.md` and `dotfiles/.cursor/rules/agents.mdc`: client entry points that defer to this file.
- `.junie/memory/`: local agent memory; keep it out of commits unless explicitly requested.

## Safe changes

Inspect Git status and preserve unrelated work. Do not read, print, copy, decrypt, or commit credentials, private environment files, `secrets.yaml`, or client auth/session state. Do not edit `.sops.yaml` without approval. Do not bypass denied operations through another tool.

Keep existing module boundaries and explicit imports. Prefer first-class Nix options; verify option names/types against pinned inputs. Do not install tools manually with Brew/npm/pip when the package can be declared here. No branch creation, commits, pushes, input updates, garbage collection, destructive cleanup, or system activation unless requested.

AI instructions are not permissions. Keep approval/sandbox protections; do not enable blanket auto-approval to make an agent more capable. Sync client-specific settings in their native format rather than copying Claude JSON into Codex. Keep existing writable Codex config separate from the tracked seed.

## Repository skills

Before using any skill supplied by this repository, Codex must read the global `AGENTS.md` first, then this root `AGENTS.md`, then the skill's `SKILL.md` before following its workflow. Apply all three; user authorization and applicable agent instructions take precedence if they conflict with a skill. This applies to every repository-local skill, not only the Nix maintenance skill.

## Atomic commits

- Never create a commit unless the user explicitly requests a commit. A request to change these instructions is not a request to commit.
- Before committing, inspect the complete Git status and both staged and unstaged diffs. Inventory every changed path and hunk, then identify which changes the user authorized for this commit. Do not infer authorization from staging, file proximity, or a request to commit other work.
- Preserve unrelated changes exactly, including their staged or unstaged state. Do not stage, unstage, reset, restore, amend, or otherwise alter unrelated user work. If a hunk mixes authorized and unrelated edits, stage only the authorized hunk; ask the user if its ownership or inclusion is unclear.
- Make each commit one independently reviewable purpose. Keep implementation, directly related tests, and necessary documentation together. Separate changes that can be reviewed or reverted independently, even when they touch the same file. Never bundle unrelated changes to reduce the number of commits.
- Stage only the paths and hunks for the current purpose; never use blanket staging such as `git add .` or `git add -A`. After staging, inspect the staged diff and confirm it contains only that purpose and no secrets or generated state. Run the checks relevant to that commit before creating it.
- Use one Conventional Commit subject per purpose: `<type>(<scope>): <description>`, imperative, specific, and under 72 characters. Do not combine multiple purposes in one subject or body.
- After each commit, inspect the commit and Git status to confirm the intended changes were committed and unrelated work remains untouched. Summarize each commit and the validation performed.
- A request to commit does not authorize pushing, rewriting history, amending existing commits, or creating branches. Obtain explicit authorization for those actions separately.

## Validation

1. `python3 scripts/validate-config.py` (Python 3.11+; named non-secret config files only).
2. `nix-instantiate --parse <changed-file.nix>` and `git diff --check`.
3. The validator parses named non-secret config files only; it does not write to live config locations.
4. `mise run build` or `darwin-rebuild build --flake .#rafiki --show-trace --impure` when feasible; this builds but does not activate. `nix flake check --impure` is another broader check.
5. Report any unavailable tools, network/build failures, and untested runtime behavior. Never claim a syntax check validates the deployed system or live MCP connections.

`mise run switch` activates the system using sudo and may upgrade Homebrew apps. Leave activation to the user unless explicitly authorized. Newly added files must be included in Git before normal Git-backed flake builds can see them; do not stage unrelated work.
