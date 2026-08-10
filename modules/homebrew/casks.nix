{ ... }:
{
  # Homebrew casks (GUI apps) and Mac App Store apps via `mas`
  # To find the ID of an app in the Mac App Store, run:
  # `mas search <app name>`
  homebrew = {
    masApps = {
      "Be Focused" = 973134470;
      "Notion Web Clipper" = 1559269364;
      "Okta Verify" = 490179405;
      "Slack" = 803453959;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
      "Microsoft Outlook" = 985367838;
      #      "CodeX" = 6759583690;
    };

    casks = [
      "alfred"
      "alt-tab"
      "bettertouchtool"
      "codex"
      "codex-app"
      "docker-desktop"
      "fluor" # for managing fn keys for different keyboards in macOS
      "font-fira-code-nerd-font"
      # "google-chrome"
      "hammerspoon" # macOS automation
      "keyman" # for keyboard management
      "maestro"
      "nordpass"
      "nordvpn"
      "notion" # markdown editor
      "ollama-app" # local AI models for Zed edit predictions
      "proxyman"
      "raycast" # launcher and automation
      "stats" # system monitor
      "supacode" # Supabase CLI terminal
      "visual-studio-code" # ide
      "warp" # terminal emulator
      "wezterm" # terminal emulator
      "whatsapp" # messaging app
      "zed" # IDE
      "zoom"
    ];
  };
}
