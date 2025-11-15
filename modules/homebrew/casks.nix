{...}: {
  # Homebrew casks (GUI apps) and Mac App Store apps via `mas`.
  homebrew = {
    masApps = {
      # Example:
      # Xcode = 497799835;
    };

    casks = [
      "firefox"
      "google-chrome"

      # IM & audio & remote desktop & meeting
      "telegram"
      "discord"

      # Development
      "insomnia" # REST client
      "wireshark" # network analyzer
      "proxyman" # proxy manager
      "postman" # REST client
      "visual-studio-code" # IDE
      "microsoft-openjdk@17"
      "bruno"
      "ghostty"

      # Productivity
      "alfred" # hotkey app
      "bettertouchtool" # hotkey app
      "obsidian" # markdown editor
      "notion" # markdown editor
      "slack" # chat app
      "alt-tab"

      # misc
      "anki"
      "iina" # video player
      "raycast" # launcher and automation
      "stats" # system monitor
      "spotify"
      "zoom"
      "hammerspoon" # macOS automation
    ];
  };
}
