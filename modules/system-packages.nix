{pkgs, ...}: {
  ##########################################################################
  # System-wide packages and environment variables (nixpkgs)
  # - These tools are available to all users.
  # - Keep this list small; prefer Homebrew for macOS-centric tools and GUI apps,
  #   and Home Manager for user-local developer tools.
  ##########################################################################

  environment.systemPackages = with pkgs; [
    neovim
    mkalias
  ];

  # Global EDITOR; user can override in their shell if desired.
  environment.variables.EDITOR = "nvim";
}
