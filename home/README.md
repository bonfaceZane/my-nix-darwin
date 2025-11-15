home/ — Home Manager (user) modules
===================================

Home Manager controls your user-level configuration: shell, editors, Git, prompt, and dotfiles placed under your home directory. These only affect the configured user (see `flake.nix` → `home-manager.users.${username}`).

Files
-----

- default.nix — Home Manager entrypoint; imports submodules from this folder.
- core.nix — Handy CLI tools you want available for the user via nixpkgs.
- shell.nix — Zsh configuration and shell aliases.
- git.nix — Git configuration (name/email taken from flake `specialArgs`).
- starship.nix — Prompt settings.
- dotfiles.nix — Centralized, safe links to external dotfiles (Helix, Zellij, Nushell, Neovim). Uses out-of-store symlinks and guards to avoid conflicts.

Add a new user module
---------------------

1. Create a Nix module here, e.g. `alacritty.nix` or `wezterm.nix`.
2. Add it to the `imports` array in `default.nix`.
3. Rebuild:

   darwin-rebuild check --flake .#rafiki
   darwin-rebuild switch --flake .#rafiki

Dotfiles
--------

Prefer program-specific options (e.g. `programs.zsh.*`, `programs.git.*`,
`programs.starship.settings`) over `home.file` when the program is supported by Home Manager. This avoids conflicts and keeps configs declarative.

Use `home.file` for configs that don’t yet have first-class modules. Example:

```
home.file = {
  ".config/helix".source = /Users/${username}/Documents/baantu/dotfiles/helix;
};
```

Recommended pattern (already implemented here):

- Do not scatter `home.file` across multiple modules. Instead, keep all external
  dotfile links in `home/dotfiles.nix`.
- `home/dotfiles.nix` links external paths using `config.lib.file.mkOutOfStoreSymlink`
  so your edits in the dotfiles repo take effect without a rebuild.
- Links are guarded with `builtins.pathExists` and created with `force = true` to
  avoid “conflicting managed target files” errors when files already exist.
- Avoid managing targets owned by first-class modules:
  - zsh: `programs.zsh` owns `~/.zshrc` (we read your personal zshrc content into
    `initContent` in `home/shell.nix`).
  - starship: `programs.starship.settings` writes its config; do not link
    `~/.config/starship.toml` via `home.file`.

Where to put packages?
----------------------

- If the package is personal and for development convenience, put it in `home/core.nix` under `home.packages`.
- If the package should be available to all users or needed system-wide, put it in `modules/apps.nix` under `environment.systemPackages` or Homebrew sections.
