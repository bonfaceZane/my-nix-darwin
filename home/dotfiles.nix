{ lib, config, pkgs, ... }:
let
  bashAliasesPath = ../dotfiles/.bash_aliases;

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
    ".codex-work/skills/gh-stack"
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
  # - Let Home Manager back up collisions; never replace whole AI state directories.
  # - Check optional sources in the repository, not against the live home directory.
  # - Dotfiles are tracked under ../dotfiles inside this repo; changes are
  #   picked up on rebuild.
  # - Do NOT manage targets that are already owned by first-class HM modules
  #   (e.g., programs.zsh manages ~/.zshrc; programs.starship manages its config).
  #
  # Add new entries here instead of scattering `home.file` across modules.

  # Important: Starship is configured via programs.starship.settings in
  # home/app-settings/starship.nix. Do not link starship.toml here to avoid conflicts.

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

    # Aider uses the SOPS-managed DEEPSEEK_API_KEY loaded by the shell.
    ".aider.conf.yml".text = ''
      model: deepseek/deepseek-coder
      auto-commits: false
      check-update: false
    '';

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
    # Client settings are live links; credentials and sessions remain client-owned.
    ".gemini/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gemini/settings.json";
    };

    # Copilot MCP config
    ".copilot/mcp-config.json" = lib.mkIf (builtins.pathExists ../dotfiles/.copilot/mcp-config.json) {
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
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/mise.toml";
    };

    # Husky pre commit config
    "Documents/work/amv-apps/.husky/pre-commit" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/pre-commit";
    };

    # Husky pre push config
    "Documents/work/amv-apps/.husky/pre-push" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/amv/pre-push";
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

    # Select a separate Codex login based on the current project directory.
    # Codex owns each auth.json; only CODEX_HOME and shared config are managed.
    "Documents/subira/.mise.toml" = {
      text = ''
        [env]
        CODEX_HOME = "${config.home.homeDirectory}/.codex"
      '';
    };
    "Documents/work/.mise.toml" = {
      text = ''
        [env]
        CODEX_HOME = "${config.home.homeDirectory}/.codex-work"
      '';
    };

    # Codex config is seeded below, not symlinked: the CLI/desktop app writes to it.
    ".claude/mcp.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ai/.mcp.json";
    };
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ai/CLAUDE.md";
    };
    ".claude/settings.json" = lib.mkIf (builtins.pathExists ../dotfiles/.claude/settings.json) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/settings.json";
    };


    # Cursor configuration — MCP + agent permissions (mirrors .claude/.codex pattern)
    ".cursor/mcp.json" = lib.mkIf (builtins.pathExists ../dotfiles/.cursor/mcp.json) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cursor/mcp.json";
    };
    ".cursor/settings.json" = lib.mkIf (builtins.pathExists ../dotfiles/.cursor/settings.json) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cursor/settings.json";
    };
    ".cursor/rules" = lib.mkIf (builtins.pathExists ../dotfiles/.cursor/rules) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cursor/rules";
    };

    # Muse settings — persisted always auto-approve (approval_mode = never)
    ".config/muse/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/muse/settings.json";
    };

    # OpenCode config directory (opencode.json + skills)
    ".config/opencode" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/opencode";
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
  ) // builtins.listToAttrs (
    map (target: {
      name = "${target}/AGENTS.md";
      value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ai/AGENTS.md";
    }) [ ".claude" ".codex" ".codex-work" ".gemini" ]
  ) // builtins.listToAttrs (
    map (target: {
      name = "${target}/skills/nix-darwin-maintenance";
      value.source = ../.agents/skills/nix-darwin-maintenance;
    }) [ ".agents" ".claude" ]
  );

  # Detach only our old repository link before HM removes obsolete managed links.
  # Preserve its contents; leave other existing configs and dangling links untouched.
  home.activation.detachLegacyCodexConfig = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
    for codexHome in "$HOME/.codex" "$HOME/.codex-work"; do
      if [ -L "$codexHome/config.toml" ] && [ -f "$codexHome/config.toml" ] &&
         [ "$(${pkgs.coreutils}/bin/readlink -f "$codexHome/config.toml")" = "${dotfiles}/.codex/config.toml" ]; then
        if [ -z "''${DRY_RUN_CMD:-}" ]; then
          temporary=$(${pkgs.coreutils}/bin/mktemp "$codexHome/config.toml.XXXXXX")
          ${pkgs.coreutils}/bin/install -m 600 "$codexHome/config.toml" "$temporary"
          ${pkgs.coreutils}/bin/mv "$temporary" "$codexHome/config.toml"
        fi
      fi
    done
  '';

  # Seed after obsolete links are removed, including dangling links from old generations.
  home.activation.seedCodexConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    for codexHome in "$HOME/.codex" "$HOME/.codex-work"; do
      if [ ! -e "$codexHome/config.toml" ] && [ ! -L "$codexHome/config.toml" ]; then
        run ${pkgs.coreutils}/bin/mkdir -p "$codexHome"
        run ${pkgs.coreutils}/bin/install -m 600 ${../dotfiles/.codex/config.base.toml} "$codexHome/config.toml"
      fi
    done
  '';
}
