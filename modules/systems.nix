{ pkgs, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{
  system = {
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;  # show 24 hour clock
      dock.autohide = true;

      # apps to show in dock
      dock.persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "${pkgs.firefox}/Applications/Firefox.app"
        "${pkgs.notion}/Applications/Notion.app"
        "${pkgs.visual-studio-code}/Applications/Visual Studio Code.app"
      ];

      finder.FXPreferredViewStyle = "clmv";


      # other macOS's defaults configuration.
      # ......
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

}
