# my-nix-darwin

Reproducible macOS setup using nix-darwin + Home Manager.

This repository defines system-level configuration (Dock, Finder, TouchID for sudo, Homebrew apps, etc.) and user-level configuration (shell, Git, Neovim, dotfiles) in a clean, modular way so you can version and rebuild your machine from source.

If you're new to Nix, this is a friendly structure with docs and comments to guide you. For deeper learning, see: https://github.com/ryan4yin/nixos-and-flakes-book

## Requirements

- macOS with admin rights
- Nix installed (multi-user/daemon)
- nix-darwin installed (bootstrap once)
- Optional: Homebrew pre-installed if you want to manage casks/formulae from this repo

## Quick start

1) Clone this repo to a permanent location, e.g. `~/Documents/baantu/my-nix-darwin`.

2) Review and, if needed, edit `flake.nix` for:
   - `username`, `useremail`, `system` (`aarch64-darwin` for Apple Silicon), `hostname`.

3) Dry-run to see what would change:

```bash
darwin-rebuild check --flake .#rafiki
```

4) Apply configuration:

```bash
darwin-rebuild switch --flake .#rafiki
# or with Justfile shortcuts if you prefer:
just darwin
```

Common Just commands:

```bash
# List all commands
just

# Garbage collect old generations
just gc

# Clean derived results
just clean
```

## Layout

```text
.
├── flake.nix          # Entry point: inputs and the `darwinConfigurations` output
├── home/              # Home Manager (user) modules — dotfiles and user packages
│  ├── default.nix     # Home Manager entrypoint; imports submodules in this folder
│  ├── apps.nix        # User-level CLI tools from nixpkgs (Home Manager)
│  ├── core.nix        # Program configs (neovim, eza, yazi, skim, ...)
│  ├── git.nix         # Git and delta config; email/name from flake `specialArgs`
│  ├── shell.nix       # Zsh config and shell aliases
│  └── starship.nix    # Starship prompt settings
├── modules/           # System (nix-darwin) modules — affect the whole machine
│  ├── apps.nix        # Aggregator for app concerns
│  │   ├── homebrew/   # Split Homebrew setup
│  │   │   ├── base.nix   # enable/taps/activation
│  │   │   ├── brews.nix  # brew formulae (CLI)
│  │   │   └── casks.nix  # casks (GUI) + mas
│  │   └── system-packages.nix # global nixpkgs packages + EDITOR
│  ├── host-users.nix  # Hostname, local user, trust settings
│  ├── nix-core.nix    # Nix daemon and nixpkgs options
│  └── systems.nix     # macOS defaults (Dock, Finder, keyboard, etc.)
├── Justfile           # Task shortcuts
├── scripts/           # Optional helpers
└── README.md
```

See also:
- modules/README.md — how to add/change system modules
- home/README.md — how to add/change Home Manager modules

## Typical edits you’ll make

- Add or remove apps: edit `modules/apps.nix`.
- Change macOS defaults (Dock, Finder, key repeat): edit `modules/systems.nix`.
- Change Nix behavior (garbage collection, unfree packages): edit `modules/nix-core.nix`.
- Add dotfiles or user programs: edit files in `home/` (e.g. `home/apps.nix` for user packages, `home/core.nix` for program configs, `home/shell.nix` for zsh).

## Add another machine (recommended pattern)

When you add a second Mac, it’s best to create a `hosts/` folder and split per-host modules. Example sketch:

```text
hosts/
  rafiki/
    darwin.nix      # Host-specific modules list
  simba/
    darwin.nix
```

Then in `flake.nix` expose multiple `darwinConfigurations`. This repo currently keeps a single host inline for simplicity; see comments in `flake.nix` for tips.

## Safety notes

- Home Manager will back up clashing dotfiles using `.hm-bak` extension to avoid clobbering your existing files (configured in `flake.nix`).
- Be careful when enabling new macOS defaults; you can always `darwin-rebuild switch --rollback` if needed.

## Troubleshooting

- Missing app after rebuild?
  - If it’s a GUI app, check `modules/homebrew/casks.nix` (aggregated via `modules/apps.nix`).
  - If it’s a Homebrew CLI, check `modules/homebrew/brews.nix`.
  - If it’s a user-local CLI, check `home/apps.nix`.
  - If it’s a global nixpkgs CLI for all users, check `modules/system-packages.nix`.

- Git name/email not picked up?
  - Ensure you set `username`/`useremail` in `flake.nix`. Home Manager writes `~/.config/git/config`.

- Homebrew integration not working?
  - Make sure you have Homebrew installed already, then let nix-darwin manage packages via `homebrew` in `modules/apps.nix`.

## Learning resources

- Nix and Flakes Book: https://github.com/ryan4yin/nixos-and-flakes-book
- nix-darwin options search: https://daiderd.com/nix-darwin/manual/index.html#sec-options
- Home Manager options: https://nix-community.github.io/home-manager/options.html