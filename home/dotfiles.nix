{ lib, config, ... }:
let
  # Use direct path literals so types remain paths, not strings.
  helixPath = ../dotfiles/helix;
  zellijPath = ../dotfiles/zellij;
  nvimPath = ../dotfiles/nvim;
  nushellPath = ../dotfiles/nushell;
  ghosttyPath = ../dotfiles/ghostty;
  zedPath = ../dotfiles/zed;
  bashAliasesPath = ../dotfiles/.bash_aliases;
in {
  # Central place to safely link repo-tracked dotfiles into $HOME.
  #
  # Goals:
  # - Avoid conflicts/failures when files already exist (use force = true).
  # - Only attempt to link when the external source actually exists.
  # - Dotfiles are tracked under ../dotfiles inside this repo; changes are
  #   picked up on rebuild.
  # - Do NOT manage targets that are already owned by first-class HM modules
  #   (e.g., programs.zsh manages ~/.zshrc; programs.starship manages its config).
  #
  # Add new entries here instead of scattering `home.file` across modules.

  # Important: Starship is configured via programs.starship.settings in
  # home/starship.nix. Do not link starship.toml here to avoid conflicts.

  home.file = {
    # Helix config directory
    ".config/helix" = lib.mkIf (builtins.pathExists helixPath) {
      source = helixPath;
      recursive = true;
      force = true;
    };

    # Bash aliases file
    ".bash_aliases" = lib.mkIf (builtins.pathExists bashAliasesPath) {
      source = bashAliasesPath;
      force = true;
    };

    # Zellij config directory
    ".config/zellij" = lib.mkIf (builtins.pathExists zellijPath) {
      source = zellijPath;
      recursive = true;
      force = true;
    };

    # Zed config directory
    ".config/zed" = {
       source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/zed";
    };

    # Neovim config directory (keep even if Neovim isn’t installed, harmless)
    ".config/nvim" = lib.mkIf (builtins.pathExists nvimPath) {
      source = nvimPath;
      recursive = true;
      force = true;
    };

    # Nushell config directory
    "Library/Application Support/nushell" = lib.mkIf (builtins.pathExists nushellPath) {
      source = nushellPath;
      recursive = true;
      force = true;
    };

    #    ghostty
    ".config/ghostty" = lib.mkIf (builtins.pathExists ghosttyPath) {
      source = ghosttyPath;
      recursive = true;
      force = true;
    };
  };
}
