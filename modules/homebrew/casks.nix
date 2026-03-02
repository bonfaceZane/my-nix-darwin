{...}: {
  # Homebrew casks (GUI apps) and Mac App Store apps via `mas`
  # To find the ID of an app in the Mac App Store, run:
  # `mas search <app name>`
  homebrew = {
    masApps = {
      "Be Focused" = 973134470;
      "Letter Opener" = 411897373;
      "Notion Web Clipper" = 1559269364;
      "Okta Verify" = 490179405;
      "Slack" = 803453959;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
    };

    casks = [
      "firefox"
      "google-chrome"

      # for managing fn keys for different keyboards in macOS
      "fluor"

      # IM & audio & remote desktop & meeting
      "telegram"
      "discord"

      # Development
      "insomnia" # REST client
      "wireshark-app" # network analyzer
      "proxyman" # proxy manager
      "postman" # REST client
      "visual-studio-code" # IDE
      "bruno"
      "ghostty"

      # Productivity
      "alfred" # hotkey app
      "bettertouchtool" # hotkey app
      "obsidian" # markdown editor
      "notion" # markdown editor
      "alt-tab"
      "font-fira-code-nerd-font"

      # misc
      "anki"
      "iina" # video player
      "raycast" # launcher and automation
      "stats" # system monitor
      "spotify"
      "zoom"
      "hammerspoon" # macOS automation

      "claude-code"
      # "maestro"

    ];
  };
}
