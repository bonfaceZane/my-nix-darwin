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
    # make sure this files/directories exist before running home-manager
    file = {
      ".zshrc".source = /Users/${username}/Documents/baantu/dotfiles/zshrc/.zshrc;
      ".config/starship.toml".source = /Users/${username}/Documents/baantu/dotfiles/starship/starship.toml;
      ".config/zellij".source = /Users/${username}/Documents/baantu/dotfiles/zellij;
      ".config/helix".source = /Users/${username}/Documents/baantu/dotfiles/helix;
      "/Users/obwoni000/Library/Application\ Support/nushell/".source = /Users/${username}/Documents/baantu/dotfiles/nushell;
      ".config/nvim".source = /Users/${username}/Documents/baantu/dotfiles/nvim;
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
