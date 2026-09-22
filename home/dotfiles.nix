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
  sharedSkillTargets = [
    "agent-device"
    "ios-simulator"
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
    # This is the global config, so the VS Code Aider extension picks up the
    # same auto-lint/auto-test behavior as the CLI.
    ".aider.conf.yml".text = ''
      # Aider global config. Shared by the CLI and the VS Code extension.
      # API keys are never stored here: DEEPSEEK_API_KEY is rendered from SOPS
      # into ~/.config/aider/env, which the shell sources at login.

      # Router/architect mode: the reasoner plans, the chat model applies diffs.
      model: deepseek/deepseek-reasoner
      architect: true
      editor-model: deepseek/deepseek-chat
      editor-edit-format: diff

      auto-commits: false
      check-update: false
      show-release-notes: false
      show-model-warnings: false
      analytics: false

      # Quieter output: no spinner redraws, no startup banner, no per-token repaint.
      pretty: false
      stream: false
      show-diffs: false

      # Keep a small repo map. 0 disables it, which is only safe when you /add
      # every file you intend to edit; without it the model frequently cannot see
      # the exact lines a SEARCH/REPLACE edit has to match.
      map-tokens: 1024

      # Feed linter and compiler errors back into the edit loop after each change.
      auto-lint: true
      # Aider keys these by language prefix, so a second `python:` entry replaces
      # the first; chain the Python linters instead.
      lint-cmd:
        - "python: ruff check --output-format=concise && radon cc -s -n C"
        - "typescript: npx tsc --noEmit"
        - "rust: cargo check --quiet"

      # Run this repo's own config validator after each edit and feed failures
      # back. There is no pytest suite here, so `python -m pytest` was noise.
      auto-test: true
      test-cmd: "python dotfiles/ai/validate.py"
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

    # Keep the personal Codex configuration under version control. Codex CLI and
    # desktop changes to this file are written back into the dotfiles repository.
    ".codex/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.codex/config.toml";
    };

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

    # Persistent cross-session memory for the OpenViking OpenCode plugin.
    # The plugin writes through this symlink into the repo so memory survives
    # rebuilds; only the directory itself is managed by Home Manager.
    ".local/share/opencode/memory" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/opencode/memory";
    };

    # Cline global settings (provider/model/reasoning/auto-approval). API keys
    # stay local in ~/.cline/data/secrets.json, never tracked here.
    ".cline/data/globalState.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.cline/globalState.json";
    };

    # VS Code user settings (Aider Composer + editor prefs)
    "Library/Application Support/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/vscode/settings.json";
    };

    # VS Code keybindings (bookmarks + Aider Composer focus)
    "Library/Application Support/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/vscode/keybindings.json";
    };

    # VS Code user MCP servers. Copilot Chat and other MCP-aware extensions read
    # this file, and VS Code rewrites it when servers are added through the UI;
    # the out-of-store symlink keeps those edits in the repository.
    "Library/Application Support/Code/User/mcp.json" = lib.mkIf (builtins.pathExists ../dotfiles/vscode/mcp.json) {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/vscode/mcp.json";
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
    map (skill: {
      name = ".claude/skills/${skill}";
      value = {
        # Codex discovers these from ~/.agents/skills; Claude needs its own link.
        source = "${config.home.homeDirectory}/.agents/skills/${skill}";
        force = true;
      };
    }) sharedSkillTargets
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

}
