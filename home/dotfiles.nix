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
in
{
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

    # Antigravity config files
    ".gemini/antigravity/mcp_config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/antigravity/mcp_config.json";
    };
    ".gemini/antigravity/user_settings.pb" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/antigravity/user_settings.pb";
    };
    ".gemini/antigravity/browserAllowlist.txt" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/antigravity/browserAllowlist.txt";
    };

    # Global Git Ignore
    ".gitignore_global" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitignore_global";
    };

    # Work Git Ignore
    ".gitignore_work" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitignore_work";
    };

    # AMV Apps Git Ignore Configs
    ".gitignore_amv_apps" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitignore_amv_apps";
    };
    ".gitconfig_amv_apps" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitconfig_amv_apps";
    };
    ".gitconfig_work" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitconfig_work";
    };
    ".gitconfig_personal" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/git/.gitconfig_personal";
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

    # AMV Apps mise config
    "Documents/work/amv-apps/mise.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles/AMV/mise.toml";
    };
  };
}
