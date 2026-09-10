# `home/` — Home Manager modules

Home Manager owns the configured user's packages, program configuration, and
home-directory links. `flake.nix` imports `home/default.nix` through
`home-manager.users.${username}`; these are not nix-darwin system modules.
All repository paths below are relative to the repository root.

## Files and ownership

- `home/default.nix` — entrypoint and explicit imports; user home/state version,
  Home Manager enablement, and user-level sops declarations.
- `home/apps.nix` — user-local `home.packages`, including developer tools and
  custom launchers/packages.
- `home/core.nix` — Home Manager program options for eza, Yazi, skim, and direnv;
  also contains the disabled Neovim configuration. It is not the package list.
- `home/app-settings/shell.nix` — primary interactive Fish configuration, fallback
  Zsh configuration, aliases, session variables, and session PATH. Zsh reads
  `dotfiles/zshrc/.zshrc` via `../../dotfiles/zshrc/.zshrc`.
- `home/app-settings/git.nix` — Git, Git LFS, delta, default identity, and
  conditional personal/work Git includes. Identity is not passed from flake
  `specialArgs`.
- `home/app-settings/starship.nix` — prompt configuration and shell integration.
- `home/app-settings/mise.nix` — Home Manager's `programs.mise` package and shell
  integration. Zsh integration is explicit; Fish integration defaults to enabled
  with the pinned Home Manager. This module was moved from `modules/mise.nix`
  without changing its configuration.
- `home/dotfiles.nix` — centralized external dotfile links and generated home files,
  including agent skills and project-specific mise environment files.

## Dotfile policy

Prefer first-class `programs.*` options for supported program configuration.
Keep external links in `home/dotfiles.nix`, and avoid managing the same target
through both a program module and `home.file`:

- `programs.zsh` generates the Zsh configuration, incorporating the repository's
  Zsh source through `home/app-settings/shell.nix`.
- `programs.starship.settings` owns the Starship configuration.
- The global mise configuration is linked by `home/dotfiles.nix`; avoid also
  generating that target with `programs.mise.globalConfig`.

Most external links use `mkOutOfStoreSymlink` and the checkout under
`~/Documents/subira/my-nix-darwin/dotfiles`. They are not all guarded by
`pathExists` or set to `force = true`. Changes to out-of-store source contents are
visible without rebuilding; changes to link definitions require a rebuild.
Do not assume these links are portable to another checkout location.

## Shell ownership

Home Manager configures interactive shells. `modules/systems.nix` enables Fish
and Zsh at the system level, registers shells, and declares Fish as the user's
shell. With the pinned nix-darwin, account changes apply to users managed through
`users.knownUsers`; the existing primary account is not in that list. Do not add
an existing admin account merely to change its shell.

After the system configuration has been activated, if the existing account still
uses another login shell, verify Fish is listed in `/etc/shells`, then use
`chsh -s /run/current-system/sw/bin/fish` and open a new terminal. There is no need
to append a duplicate Fish entry to `/etc/shells` manually.

## Extending the configuration

Use the existing layout: user package additions go in `home/apps.nix`, and
application-specific Home Manager configuration belongs in
`home/app-settings/`. Add new modules explicitly to `home/default.nix`.
Do not introduce a parallel user-module tree or automatic directory imports.
System packages and machine-wide settings belong under `modules/`; see
[`modules/README.md`](../modules/README.md).

## Package ownership follow-up

Homebrew and Home Manager currently both provide Git, mise, Starship, and skim
(Homebrew's `sk`). These installations are intentionally retained. A separate
cleanup should choose one package owner for each tool while preserving required
Home Manager configuration/integration and checking PATH/version behavior before
removing any installation. System-level PostgreSQL overlap is documented in
[`modules/README.md`](../modules/README.md).
