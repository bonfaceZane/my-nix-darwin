{pkgs, ...}:
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
    # Set the primary user for options that require it
    primaryUser = "obwoni000";

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      dock.autohide = true;

      # apps to show in dock
      dock.persistent-apps = [
        "/Applications/slack.app"
        "/Applications/Notion.app"
        "/Applications/Warp.app"
        "/Applications/webstorm.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Xcode.app"
        "/Applications/Windsurf.app"
        "/Applications/Arc.app"
        "/Applications/Proxyman.app"
        "/Applications/Ghostty.app"
        # "/Applications/Playgrounds.app"
      ];

      finder.FXPreferredViewStyle = "clmv";
      loginwindow.GuestEnabled = false;

      # customize finder
      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleICUForce24HourTime = true;
        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.

        NSAutomaticCapitalizationEnabled = false; # disable auto capitalization(自动大写)

        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
      };

      # Customize settings that not supported by nix-darwin directly
      # see the source code of this project to get more undocumented options:
      #    https://github.com/rgcr/m-cli
      #
      # All custom entries can be found by running `defaults read` command.
      # or `defaults read xxx` to read a specific domain.
      CustomUserPreferences = {
        NSGlobalDomain = {
          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;
        };

        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };

        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        loginwindow = {
          GuestEnabled = false; # disable guest user
          SHOWFULLNAME = true; # show full name in login window
        };

        # keyboard settings is not very useful on macOS
        # the most important thing is to remap option key to alt key globally,
        # but it's not supported by macOS yet.
        keyboard = {
          enableKeyMapping = true; # enable key mapping so that we can use `option` as `control`

          # NOTE: do NOT support remap capslock to both control and escape at the same time
          remapCapsLockToControl = true; # remap caps lock to control, useful for emac users
          remapCapsLockToEscape = false; # remap caps lock to escape, useful for vim users

          # swap left command and left alt
          # so it matches common keyboard layout: `ctrl | command | alt`
          #
          # disabled, caused only problems!
          swapLeftCommandAndLeftAlt = false;
        };
      };

      # other macOS's defaults configuration.
      # ......
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
}
