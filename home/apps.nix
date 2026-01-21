{pkgs, ...}: {
  # User-local packages managed by Home Manager.
  # Keep developer convenience tools here so they are available to the main user
  # without polluting the entire system.
  home.packages = with pkgs; [
    which # locate a command in PATH
    gnused
    gnutar
    sops
    # Add more user-only tools here, e.g.:
    # ripgrep jq yq-go fzf tree zstd glow
  ];
}
