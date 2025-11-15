{pkgs, ...}: {
  ##########################################################################
  # System-wide packages and environment variables (nixpkgs)
  # - These tools are available to all users.
  # - Keep this list small; prefer Homebrew for macOS-centric tools and GUI apps,
  #   and Home Manager for user-local developer tools.
  ##########################################################################

  environment.systemPackages = with pkgs; [
    mkalias
  ];

  # Global EDITOR; user can override in their shell if desired.
  # Helix's CLI is `hx`.
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx"; # many tools respect VISUAL if set
  };
}
