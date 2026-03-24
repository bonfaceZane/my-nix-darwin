{ lib, config, ... }:
let
  bashAliasesPath = ../dotfiles/.bash_aliases;
  amvPath = ../dotfiles/amv;
  dotfiles = "${config.home.homeDirectory}/Documents/baantu/my-nix-darwin/dotfiles";
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
    ".config/helix" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/helix";
    };

    # Bash aliases file
    ".bash_aliases" = lib.mkIf (builtins.pathExists bashAliasesPath) {
      source = bashAliasesPath;
      force = true;
    };

    # Zellij config directory
    ".config/zellij" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zellij";
    };

    ".aws" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/aws";
    };

    # Zed config directory
    ".config/zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zed";
    };

    # Antigravity config files
    ".gemini/antigravity/mcp_config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/antigravity/mcp_config.json";
    };
    ".gemini/antigravity/user_settings.pb" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/antigravity/user_settings.pb";
    };
    ".gemini/antigravity/browserAllowlist.txt" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/antigravity/browserAllowlist.txt";
    };

    # Global Git Ignore
    ".gitignore_global" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitignore_global";
    };

    # Work Git Ignore
    ".gitignore_work" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitignore_work";
    };

    ".gitconfig_work" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitconfig_work";
    };
    ".gitconfig_personal" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.gitconfig_personal";
    };

    # Neovim config directory
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    };

    # Nushell config directory
    "Library/Application Support/nushell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nushell";
    };

    # Ghostty config directory
    ".config/ghostty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty";
    };

    # AMV Apps mise config
    "Documents/work/amv-apps/mise.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/AMV/mise.toml";
    };

    # Husky pre commit config
    "Documents/work/amv-apps/.husky/pre-commit" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/pre-commit";
    };

    # Husky pre push config
    "Documents/work/amv-apps/.husky/pre-push" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/pre-commit";
    };

    "Documents/work/amv-apps/.lintstagedrc.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/.lintstagedrc.json";
    };

    # Claude Code settings (only settings.json — runtime dirs stay untracked)
    ".claude/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/settings.json";
      force = true;
    };

    # Claude Code notes
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/CLAUDE.md";
    };

    # Claude Code skills
    ".claude/skills/nix-rebuild" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/skills/nix-rebuild";
    };
    ".claude/skills/nix-update" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/skills/nix-update";
    };
    ".claude/skills/sops-edit" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/skills/sops-edit";
    };

  };
}
