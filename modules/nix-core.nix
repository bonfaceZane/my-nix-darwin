{
  pkgs,
  lib,
  ...
}: {
  # Disable nix-darwin's Nix management for Determinate compatibility
  nix.enable = false;

  # enable flakes globally
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow unsupported packages
  nixpkgs.config.allowUnsupportedSystem = true;

  # Allow broken packages
  nixpkgs.config.allowBroken = true;

  # Auto upgrade nix package and the daemon service.
  # nix-darwin now manages nix-daemon unconditionally when `nix.enable` is on
  # nix.package = pkgs.nix;  # Disabled for Determinate

  # do garbage collection weekly to keep disk usage low
  # Disabled when nix.enable = false
  # nix.gc = {
  #   automatic = lib.mkDefault true;
  #   options = lib.mkDefault "--delete-older-than 7d";
  # };

  # Disable auto-optimise-store because of this issue:
  #   https://github.com/NixOS/nix/issues/7273
  # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
  nix.settings = {
    auto-optimise-store = false;
  };
}
