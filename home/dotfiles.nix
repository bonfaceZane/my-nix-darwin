{ lib, config, pkgs, ... }:
let
  bashAliasesPath = ../dotfiles/.bash_aliases;
  amvPath = ../dotfiles/amv;
  dotfiles = "${config.home.homeDirectory}/Documents/subira/my-nix-darwin/dotfiles";
  ghStackSource = pkgs.fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    rev = "refs/tags/v0.1.0";
    hash = "sha256-48JkOeqbvHlCZ2u3LnwJymw55xMQWLTPJLDbV44clGI=";
  };
  ghStackSkill = pkgs.runCommand "gh-stack-agent-skill" { } ''
    mkdir -p "$out"
    cp -R ${ghStackSource}/skills/gh-stack/. "$out/"
  '';
  ghStackSkillTargets = [
    ".agents/skills/gh-stack" # shared Agent Skills location
    ".claude/skills/gh-stack"
    ".codex/skills/gh-stack"
    ".cursor/skills/gh-stack"
    ".gemini/skills/gh-stack"
    ".gemini/antigravity/skills/gh-stack"
    ".windsurf/skills/gh-stack"
  ];
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
    # General Gemini settings
    ".gemini/settings.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.gemini/settings.json") {
      source = "${dotfiles}/.gemini/settings.json";
      force = true;
    };

    # Copilot MCP config
    ".copilot/mcp-config.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.copilot/mcp-config.json") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.copilot/mcp-config.json";
      force = true;
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

    # WezTerm config directory
    ".config/wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wezterm";
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

    # AMV AI configuration. Keep the workspace's existing AGENTS.md/CLAUDE.md
    # authoritative; only provide these files when the workspace does not own
    # them yet.
    "Documents/work/amv-apps/.gemini/settings.json" = lib.mkIf (
      !builtins.pathExists "${config.home.homeDirectory}/Documents/work/amv-apps/.gemini/settings.json"
    ) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ai/.gemini/settings.json";
      force = true;
    };
    "Documents/work/amv-apps/.mcp.json" = lib.mkIf (
      !builtins.pathExists "${config.home.homeDirectory}/Documents/work/amv-apps/.mcp.json"
    ) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ai/.mcp.json";
      force = true;
    };

    # Fish extra config (auto-sourced by Fish via conf.d; edit dotfiles/fish/extra.fish)
    ".config/fish/conf.d/extra.fish" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fish/extra.fish";
    };
    # Mise config
    ".config/mise/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mise/config.toml";
    };

    # Codex configuration — auto-allow non-sensitive per dotfiles/ai/AGENTS.md
    ".codex/config.toml" = lib.mkIf (builtins.pathExists "${dotfiles}/.codex/config.toml") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.codex/config.toml";
    };
    ".claude/settings.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.claude/settings.json") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/settings.json";
    };
    ".codex/settings.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.claude/settings.json") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/settings.json";
    };

    # Cursor configuration — MCP + agent permissions (mirrors .claude/.codex pattern)
    ".cursor/mcp.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.cursor/mcp.json") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cursor/mcp.json";
    };
    ".cursor/settings.json" = lib.mkIf (builtins.pathExists "${dotfiles}/.cursor/settings.json") {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cursor/settings.json";
    };
  } // builtins.listToAttrs (
    map (target: {
      name = target;
      value = {
        # Keep the upstream skill immutable while centralizing its home links here.
        source = ghStackSkill;
        force = true;
      };
    }) ghStackSkillTargets
  );
}
