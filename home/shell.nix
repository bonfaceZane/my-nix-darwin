{ pkgs, username, ... }: {
  # Fish is the primary interactive shell.
  programs.fish = {
    enable = true;

    # Plugins
    plugins = [
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
    ];

    # Functions ported from .zshrc
    functions = {
      prebuild = ''
        set app $argv[1]; if test -z "$app"; set app "gpd"; end
        yarn $app prebuild --clean
      '';

      run = ''
        set app $argv[1]; if test -z "$app"; set app "gpd"; end
        set os $argv[2]; if test -z "$os"; set os "ios"; end
        yarn $app $os --device='Iphone Air'
      '';

      build = "eas build --platform=$argv[1] --profile=$argv[2]";

      osha = "npx npkill -D -y";
    };

    interactiveShellInit = ''
      # Homebrew environment (Apple Silicon)
      if test (uname -m) = arm64
        eval (/opt/homebrew/bin/brew shellenv)
      end

      # Load Secrets
      if test -f /run/secrets/anthropic_api_key
          set -gx ANTHROPIC_PERSONAL_KEY (cat /run/secrets/anthropic_api_key)
      end
      if test -f /run/secrets/anthropic_api_key_work
          set -gx ANTHROPIC_WORK_KEY (cat /run/secrets/anthropic_api_key_work)
      end

      # ---------------------------------------------------
      # Environment Variables & PATHs Migrated from .zshrc
      # ---------------------------------------------------

      # Android Development
      set -gx ANDROID_HOME $HOME/Library/Android/sdk
      set -gx ANDROID_SDK_ROOT $HOME/Library/Android/sdk
      fish_add_path $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools $HOME/Library/Android/sdk/emulator/

      # Package Managers & Runtimes
      set -gx PNPM_HOME "/Users/obwoni000/Library/pnpm"
      set -gx BUN_INSTALL "$HOME/.bun"
      set -gx MODULAR_HOME "/Users/obwoni000/.modular"
      set -gx PROTO_HOME "$HOME/.proto"
      set -gx GEM_HOME "$HOME/.gem"

      # Add all standard bins to PATH
      fish_add_path $PNPM_HOME $BUN_INSTALL/bin $MODULAR_HOME/pkg/packages.modular.com_mojo/bin $HOME/.pyenv/shims $PROTO_HOME/shims $PROTO_HOME/bin $HOME/.maestro/bin $HOME/.local/share/mise/shims $GEM_HOME/bin $HOME/bin $HOME/.local/bin $HOME/go/bin
    '';
  };

  # Zsh stays available as a fallback for scripts that need it.
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = let
      userZshrc = ../dotfiles/zshrc/.zshrc;
      userZshrcContent = if builtins.pathExists userZshrc then builtins.readFile userZshrc else "";
    in
      userZshrcContent + ''
        # --- Home Manager additions (appended) ---
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        # Load Secrets
        if [ -f /run/secrets/anthropic_api_key ]; then
            export ANTHROPIC_PERSONAL_KEY=$(cat /run/secrets/anthropic_api_key)
        fi
        if [ -f /run/secrets/anthropic_api_key_work ]; then
            export ANTHROPIC_WORK_KEY=$(cat /run/secrets/anthropic_api_key_work)
        fi
        # --- End HM additions ---
      '';
  };

  home.shellAliases = {
    # pnpm alias
    p = "pnpm";

    # k8s
    k = "kubectl";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
