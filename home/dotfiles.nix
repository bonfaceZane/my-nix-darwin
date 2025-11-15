{ lib, config, username, ... }:
let
  # Convenience: create out-of-store symlinks
  # Home Manager exposes mkOutOfStoreSymlink under config.lib.file
  ext = config.lib.file.mkOutOfStoreSymlink;

  dotfilesRoot = "/Users/${username}/Documents/baantu/dotfiles";
  helixPath = "${dotfilesRoot}/helix";
  zellijPath = "${dotfilesRoot}/zellij";
  nvimPath = "${dotfilesRoot}/nvim";
  nushellPath = "${dotfilesRoot}/nushell";
  ghosttyPath = "${dotfilesRoot}/ghostty";
in
{
  # Central place to safely link external dotfiles into $HOME.
  #
  # Goals:
  # - Avoid conflicts/failures when files already exist (use force = true).
  # - Only attempt to link when the external source actually exists.
  # - Prefer out-of-store symlinks so changes to your dotfiles repo take effect
  #   without a rebuild.
  # - Do NOT manage targets that are already owned by first-class HM modules
  #   (e.g., programs.zsh manages ~/.zshrc; programs.starship manages its config).
  #
  # Add new entries here instead of scattering `home.file` across modules.

  # Important: Starship is configured via programs.starship.settings in
  # home/starship.nix. Do not link starship.toml here to avoid conflicts.

  home.file = {
    # Helix config directory
    ".config/helix" = lib.mkIf (builtins.pathExists helixPath) {
      source = ext helixPath;
      recursive = true;
      force = true;
    };

    # Zellij config directory
    ".config/zellij" = lib.mkIf (builtins.pathExists zellijPath) {
      source = ext zellijPath;
      recursive = true;
      force = true;
    };

    # Neovim config directory (kept even if Neovim isn’t installed, harmless)
    ".config/nvim" = lib.mkIf (builtins.pathExists nvimPath) {
      source = ext nvimPath;
      recursive = true;
      force = true;
    };

    # Nushell config directory
    "Library/Application Support/nushell" = lib.mkIf (builtins.pathExists nushellPath) {
      source = ext nushellPath;
      recursive = true;
      force = true;
    };

    #    ghostty
    ".config/ghostty" = lib.mkIf (builtins.pathExists ghosttyPath) {
      source = ext ghosttyPath;
      recursive = true;
      force = true;
    };
  };
}
