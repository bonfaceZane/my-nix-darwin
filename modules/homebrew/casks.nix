{ ... }:
{
  # Homebrew casks (GUI apps) and Mac App Store apps via `mas`
  # To find the ID of an app in the Mac App Store, run:
  # `mas search <app name>`
  homebrew = {
    masApps = {
      # "Be Focused" = 973134470;
      # "Letter Opener" = 411897373;
      "Notion Web Clipper" = 1559269364;
      "Okta Verify" = 490179405;
      "Slack" = 803453959;
      "Tailscale" = 1475387142;
      # "Xcode" = 497799835;
    };

    casks = [
      "nordpass"
      # "nordvpn"
      # "google-chrome"
      "fluor" # for managing fn keys for different keyboards in macOS
      # "discord"
      "proxyman" # proxy manager
      "visual-studio-code" # IDE
      "alfred" # todo: for managing search and hotkeys, alternative for mac search ( uses Spotlight - * check if need )
      "bettertouchtool" # hotkey app
      "notion" # markdown editor
      "alt-tab"
      "font-fira-code-nerd-font" # todo:  move this ups to important
      "raycast" # launcher and automation
      # "stats" # system monitor
      "zoom"
      "hammerspoon" # macOS automation
      "claude-code" # AI assistant
      "cursor" # AI Code Editor
      "codex-app" # OpenAI Codex Desktop App
      "cmux" # terminal built on ghostty
      "affine" # workspace app
      "whatsapp" # messaging app
      "wezterm" # terminal emulator
    ];
  };
}
