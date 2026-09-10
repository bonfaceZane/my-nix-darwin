---
name: nix-darwin-maintenance
description: Audit, change, and validate this my-nix-darwin macOS configuration, including Home Manager dotfile links, shell integration, AI client settings, and Nix activation failures.
---

# Nix Darwin maintenance

Use this workflow for `my-nix-darwin`, not unrelated projects. Find its checkout and read its root `AGENTS.md` before changes.

1. Inspect `git --no-optional-locks status --short` and the relevant diff. Preserve unrelated changes and never activate a system or commit without explicit approval.
2. Trace ownership: `flake.nix` composes system modules; `home/default.nix` imports Home Manager modules. Use `modules/systems.nix` for macOS defaults, `modules/homebrew/` for Brew apps, `home/app-settings/` for shell/Git/prompt/mise, and `home/dotfiles.nix` for links.
3. For a missing setting, inspect the pinned input's option type before choosing a value. Syntax parsing does not prove an option exists or accepts that type.
4. For dotfile changes, verify the source exists with exact capitalization and is tracked. Use individual AI settings/instruction/skill links, not whole state directories. Codex `config.base.toml` seeds new profiles; existing local config is intentionally not overwritten. Never read or copy auth files, private keys, or secret values.
5. For MCP, verify the client schema, executable and runtime separately. Prefer existing native tools for Nix/Git. Do not add workspace-specific Nx/Radon servers globally. An MCP manifest is not proof of a working handshake.
6. Run `python3 scripts/validate-config.py`; parse changed Nix files with `nix-instantiate --parse PATH`; then `git diff --check`. Where feasible run `mise run build` (no activation) or `nix flake check --impure` with a bounded timeout. These broader commands may access the network and build dependencies.
7. Explain source edits versus active machine state. Report checks actually run and failures accurately. Recommend `mise run switch` only for approved activation; it can upgrade Homebrew apps as configured.
