---
name: nix-rebuild
description: Rebuild and switch the nix-darwin configuration for rafiki. Use when nix config changes need to be applied.
version: 1.0.0
---

# Nix Rebuild

Applies the current nix-darwin + home-manager configuration.

## Steps

1. `cd ~/Documents/subira/my-nix-darwin`
2. Run the rebuild:
   ```bash
   darwin-rebuild switch --flake .#rafiki
   ```
3. If it succeeds, confirm what changed.
4. If it fails, read the error carefully:
   - `error: ... collision between ...` — a file conflict; check `home/dotfiles.nix` for duplicate entries or remove the conflicting file manually
   - `Permission denied` — a nix store symlink is blocking the backup; `sudo rm` the conflicting path and retry
   - `attribute ... missing` — a referenced nix attribute doesn't exist; check the flake inputs or module options
   - Any other error — show the full error to the user and suggest a fix before retrying
