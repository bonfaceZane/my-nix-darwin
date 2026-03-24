# Nix Update

Updates all flake inputs (nixpkgs, home-manager, sops-nix, etc.) then rebuilds.

## Steps

1. `cd ~/Documents/baantu/my-nix-darwin`
2. Update all inputs:
   ```bash
   nix flake update
   ```
   Or update a specific input only:
   ```bash
   nix flake update nixpkgs
   ```
3. Review the lock file diff (`git diff flake.lock`) to see what changed.
4. Rebuild:
   ```bash
   darwin-rebuild switch --flake .#rafiki
   ```
5. If the rebuild succeeds, commit both `flake.lock` and any related changes atomically:
   ```
   chore: update flake inputs
   ```
6. If the rebuild fails due to a breaking change in an input, check the release notes for that input and fix the config before retrying.
