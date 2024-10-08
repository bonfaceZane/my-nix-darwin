{username, ...}: {
  # import sub modules
  imports = [
    # ./shell.nix
    # ./core.nix
    # ./git.nix
    # ./starship.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # Makes sense for user specific applications that shouldn't be available system-wide
    # packages = [
    # ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # ".zshrc".source = ~/Document/baantu/dotfiles/zshrc/.zshrc;
      # ".config/starship".source = ~/Document/baantu/dotfiles/starship;
      # ".config/zellij".source = ~/Document/baantu/dotfiles/zellij;
      # ".config/nvim".source = ~/Document/baantu/dotfiles/nvim;
      # # ".config/nix".source = ~/dotfiles/nix;
      # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    };

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
