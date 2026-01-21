{
  username,
  sops-nix,
  ...
}: {
  # Home Manager entrypoint for user `${username}`
  #
  # This file composes user-level modules that manage dotfiles and user packages.
  # Add new user modules to the `imports` list below to keep things modular.
  #
  # Tip: Prefer keeping system-wide apps in `modules/apps.nix` and user-specific
  # tools here in Home Manager.
  #
  # Inputs provided via `specialArgs` from flake.nix include `username` and
  # `useremail` (used by `home/git.nix`).
  #
  # import sub modules
  imports = [
    ./shell.nix
    ./dotfiles.nix
    ./apps.nix
    ./core.nix
    ./git.nix
    ./starship.nix
    ./zed.nix
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.sshKeyPaths = [ "/Users/obwoni000/.ssh/id_ed25519" ];
    secrets.useremail = {};
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # Makes sense for user specific applications that shouldn't be available system-wide
    # packages = [
    # ];

    # Dotfiles linking policy
    # - Prefer first-class modules (programs.*) over home.file to avoid HM
    #   double-management conflicts.
    # - External dotfiles are linked centrally in `home/dotfiles.nix` using
    #   out-of-store symlinks and force=true. Keep this attribute set empty here.
    file = {};

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
