{ ... }:
{
  # Homebrew casks (GUI apps) and Mac App Store apps via `mas`
  # To find the ID of an app in the Mac App Store, run:
  # `mas search <app name>`
  homebrew = {
    masApps = {
      "Be Focused" = 973134470;
      "Bear" = 1091189122;
      "Developer" = 640199958;
      "Notion Web Clipper" = 1559269364;
      "Okta Verify" = 490179405;
      "NordPass® Password Manager & Digital Vault" = 6443917910;
      "NordVPN 2" = 905953485;
      "Symbols Finder" = 6651821897;
      "Slack" = 803453959;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
      "Microsoft Outlook" = 985367838;
    };

    casks = [
      "alfred"
      "alt-tab"
      "antigravity" # Google Antigravity
      {
        name = "android-studio";
        args.appdir = "~/Applications";
      }
      "caskhub"
      "claude-code"
      "codex"
      "codex-app"
      "cursor" # AI-first IDE
      "deepseek-harness"
      "docker-desktop"
      "emacs-app" # GNU Emacs editor
      "expo-orbit"
      "fluor" # for managing fn keys for different keyboards in macOS
      "font-fira-code-nerd-font"
      # "google-chrome"
      "hammerspoon" # macOS automation
      "jetbrains-toolbox"
      "keyman" # for keyboard management
      "logi-options+" # Logitech Options+
      "maestro"
      "notion" # markdown editor
      "opencode-desktop"
      "scrivener"
      "stablyai/orca/orca" # AI agent orchestrator IDE (fully qualified; core `orca` is a disabled plotly tool)
      "thebrowsercompany-dia" # Dia browser
      "proxyman"
      "raycast" # launcher and automation
      {
        name = "rustrover";
        args.appdir = "~/Applications";
      }
      "stats" # system monitor
      {
        name = "webstorm";
        args.appdir = "~/Applications";
      }
      "visual-studio-code" # ide
      "warp" # terminal emulator
      "whatsapp" # messaging app
      "zed" # IDE
      "zoom"
    ];
  };
}
