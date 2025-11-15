modules/ — system-wide (nix-darwin) modules
===========================================

This folder contains nix-darwin modules. They affect the whole machine.

- Use this for macOS defaults (Dock, Finder, keyboard), system services, Nix daemon settings, and global packages.
- Prefer GUI apps and large CLI toolchains via Homebrew casks/formulae in apps.nix.
- Keep user-specific, per-login shell settings and dotfiles inside home/ (Home Manager), not here.

Files
-----

- apps.nix — Aggregator that imports the split app concerns below.
- homebrew/
  - base.nix — Common Homebrew enable/taps/activation settings.
  - brews.nix — Homebrew formulae (CLI tools installed via `brew install`).
  - casks.nix — Homebrew casks (GUI apps) and optional `mas` App Store entries.
- system-packages.nix — Global nixpkgs packages (`environment.systemPackages`) and basic env vars like `EDITOR`.
- host-users.nix — Hostname, local user attributes, and trusted-users for Nix.
- nix-core.nix — Nix daemon and nixpkgs options (flakes, unfree, etc.).
- systems.nix — macOS defaults: Dock, Finder, keyboard, login window, TouchID for sudo, etc.

Where to put packages?
----------------------

- System-wide via nixpkgs: modules/system-packages.nix → `environment.systemPackages = with pkgs; [ ... ];`
  - Good for tools required by the OS or all users.
- System-wide via Homebrew: modules/homebrew/{brews,casks}.nix → `homebrew.brews` / `homebrew.casks`
  - Recommended for macOS GUI apps and many CLI tools with better macOS support.
- User-local via Home Manager: home/apps.nix → `home.packages = with pkgs; [ ... ];`
  - Good for developer convenience tools only the main user needs.

Add a new system module
-----------------------

1. Create modules/<name>.nix with the `{ pkgs, ... }: { /* options */ }` signature.
2. Add it to the modules list in flake.nix under the “System modules (nix-darwin)” section.
3. Rebuild:

   darwin-rebuild check --flake .#rafiki
   darwin-rebuild switch --flake .#rafiki

Tips
----

- If you later add multiple hosts, move host-specific settings into hosts/<host>/darwin.nix and import per host.
- Keep modules small and focused; it’s fine to split systems.nix into dock.nix, finder.nix, etc., once it grows.
