@dotfiles/ai/AGENTS.md

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
- `.github/copilot-instructions.md` and `dotfiles/ai/clients/cursor/rules/agents.mdc`: client entry points that defer to this file.
- `.junie/memory/`: local agent memory; keep it out of commits unless explicitly requested.

## Safe changes

Keep existing module boundaries and explicit imports. Prefer first-class Nix options; verify option names and types against pinned inputs. Declare machine packages through Nix-managed Homebrew or Nix rather than installing them manually.

No branch creation, input updates, garbage collection, destructive cleanup, or system activation unless explicitly requested.


## Repository skills

Before using any skill supplied by this repository, Codex must read the global `AGENTS.md` first, then this root `AGENTS.md`, then the skill's `SKILL.md` before following its workflow. Apply all three; user authorization and applicable agent instructions take precedence if they conflict with a skill. This applies to every repository-local skill, not only the Nix maintenance skill.

## Validation

1. `python3 scripts/validate-config.py` (Python 3.11+; named non-secret config files only).
2. `nix-instantiate --parse <changed-file.nix>` and `git diff --check`.
3. The validator parses named non-secret config files only; it does not write to live config locations.
4. `mise run build` or `darwin-rebuild build --flake .#rafiki --show-trace --impure` when feasible; this builds but does not activate. `nix flake check --impure` is another broader check.
5. Report any unavailable tools, network/build failures, and untested runtime behavior. Never claim a syntax check validates the deployed system or live MCP connections.

`mise run switch` activates the system using sudo and may upgrade Homebrew apps. Leave activation to the user unless explicitly authorized. Newly added files must be included in Git before normal Git-backed flake builds can see them; do not stage unrelated work.
