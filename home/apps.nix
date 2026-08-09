{ pkgs, ... }:
let
  ghStack = pkgs.stdenv.mkDerivation rec {
    pname = "gh-stack";
    version = "0.1.0";

    src = pkgs.fetchurl {
      url = "https://github.com/github/gh-stack/releases/download/v${version}/darwin-arm64";
      hash = "sha256-XKmCQaJl1t4BgJXNrl88QNpcp4JFDuwOqRqo4+sYMQM=";
    };

    dontUnpack = true;
    installPhase = ''
      install -Dm755 "$src" "$out/bin/gh-stack"
    '';

    meta = {
      description = "GitHub CLI extension for stacked pull requests";
      homepage = "https://github.com/github/gh-stack";
      license = pkgs.lib.licenses.mit;
      mainProgram = "gh-stack";
      platforms = pkgs.lib.platforms.darwin;
    };
  };
  gitkrakenMcp = pkgs.writeShellScriptBin "gitkraken-mcp" ''
    exec "$HOME/Library/Application Support/Antigravity/User/globalStorage/eamodio.gitlens/gk" "$@"
  '';
in
{
  # User-local packages managed by Home Manager.
  # Keep developer convenience tools here so they are available to the main user
  # without polluting the entire system.
  home.packages = with pkgs; [
    which # locate a command in PATH
    gnused
    gnutar
    sops
    devbox # Nix-based dev environment manager
    ghStack # GitHub CLI extension for stacked pull requests
    gitkrakenMcp # Portable launcher for the GitKraken Antigravity MCP server

    # Language Servers & Formatters
    nodePackages.typescript-language-server
    vscode-langservers-extracted # eslint, html, css, json
    nodePackages.prettier
    nil # Nix language server
    biome

    # Add more user-only tools here, e.g.:
    # ripgrep jq yq-go fzf tree zstd glow
  ];
}
