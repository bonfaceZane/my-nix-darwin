# `modules/` — system-wide nix-darwin modules

Active modules here configure machine-wide settings and packages. User packages,
interactive shell configuration, and dotfiles belong under `home/` (Home Manager).
All repository paths below are relative to the repository root.

## Files and imports

`flake.nix` explicitly imports:

- `modules/apps.nix` — an aggregator, not a package list. It imports:
  - `modules/system-packages.nix` — global nixpkgs packages through
    `environment.systemPackages`, plus `EDITOR` and `VISUAL`.
  - `modules/homebrew/base.nix` — Homebrew enablement, Brewfile generation, and
    activation update/upgrade settings.
  - `modules/homebrew/brews.nix` — Homebrew CLI formulae.
  - `modules/homebrew/casks.nix` — Homebrew GUI casks and Mac App Store entries.
- `modules/nix-core.nix` — nixpkgs policy and Nix settings. `nix.enable = false`
  means nix-darwin does not manage Nix itself; settings declared here should not
  be mistaken for an actively managed daemon configuration.
- `modules/systems.nix` — macOS defaults, keyboard mappings, sudo/Touch ID,
  system shell enablement, primary-user selection, and the user's shell setting.
- `modules/host-users.nix` — hostname, user home/description, and the Nix
  trusted-users declaration (also subject to `nix.enable = false`).
- `services/postgres.nix` — the nix-darwin PostgreSQL service, explicitly pinned
  to PostgreSQL 18. It remains in the existing `services/` directory.

`flake.nix` also imports the upstream Darwin sops and Home Manager modules.
Home Manager then imports `home/default.nix` as a separate user-module graph.

### Legacy and user modules

- Mise now lives at `home/app-settings/mise.nix` and is imported only by
  `home/default.nix`. Its `programs.mise` options belong to Home Manager, not the
  Darwin module graph.
- `modules/gems.nix` is an unimported legacy Home Manager fragment, not an active
  system module. Its `home.environment` option is invalid for Home Manager; do
  not import it as-is. Retire it or repair its Ruby environment separately if it
  is still needed.

## Where to put changes

| Concern | Existing owner |
| --- | --- |
| Global nixpkgs packages | `modules/system-packages.nix` |
| Homebrew formulae | `modules/homebrew/brews.nix` |
| Homebrew casks / App Store apps | `modules/homebrew/casks.nix` |
| macOS defaults and system shells | `modules/systems.nix` |
| Host and user attributes | `modules/host-users.nix` |
| User-local packages | `home/apps.nix` |
| User application settings | `home/app-settings/` |
| External dotfile links | `home/dotfiles.nix` |

Keep the explicit import lists and current aggregators. Extend an existing owner
when practical; add a focused system module to the `flake.nix` module list only
when it introduces a distinct concern. No parallel `darwin/`, `user/`, or new
module tree is needed for this single-host configuration. Do not move services
or split macOS defaults merely for directory symmetry.

## Follow-up: duplicate package ownership

These overlaps remain deliberately unchanged; documentation is not a request to
uninstall or replace anything:

- Git, mise, Starship, and skim are installed through both Homebrew and Home
  Manager. Choose an owner per tool in a separate change, retaining shell/program
  integration and checking executable precedence before removing packages.
- Homebrew declares `postgresql@18`, while `services/postgres.nix` installs and
  configures nix-darwin's PostgreSQL 18 service. The formula declaration alone
  does not establish that a Homebrew service is running. Check service ownership,
  data directories, ports, and migration/backup needs before consolidating.

The `nix-homebrew` flake input is unused: ordinary nix-darwin `homebrew.*` options
currently manage the Brewfile; the nix-homebrew module is not imported.
`flake-utils` is also unused. Removing those inputs should be paired with
lockfile cleanup in a separate change, not with package replacement.

See [`home/README.md`](../home/README.md) for user-module and login-shell ownership.
