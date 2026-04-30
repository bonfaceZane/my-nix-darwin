{ pkgs, username, ... }:
{
  # Fish is the primary interactive shell.
  programs.fish = {
    enable = true;

    # Plugins
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "pisces";
        src = pkgs.fishPlugins.pisces.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
    ];

    # Functions ported from .zshrc
    functions = {
      _auto_claude_settings = {
        onVariable = "PWD";
        body = ''
          set settings "$HOME/.claude/settings.json"
          set work_settings "$HOME/Documents/subira/my-nix-darwin/dotfiles/.claude-work/settings.json"
          set personal_settings "$HOME/Documents/subira/my-nix-darwin/dotfiles/.claude/settings.json"
          if string match -q "$HOME/Documents/work*" "$PWD"
            ln -sf $work_settings $settings
          else
            ln -sf $personal_settings $settings
          end
        '';
      };

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
      # Auto-swap Claude settings based on directory
      _auto_claude_settings

      # Homebrew environment (Apple Silicon)
      if test (uname -m) = arm64
        eval (/opt/homebrew/bin/brew shellenv)
      end

      # Load Secrets from sops-nix
      if test -f /run/secrets/anthropic_api_key
          set -gx ANTHROPIC_API_KEY (cat /run/secrets/anthropic_api_key)
      end

      # ---------------------------------------------------
      # Environment Variables & PATHs Migrated from .zshrc
      # ---------------------------------------------------

      # Android Development paths (vars come from home.sessionVariables)
      fish_add_path $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools

      # Add all standard bins to PATH (vars come from home.sessionVariables)
      fish_add_path $PNPM_HOME $BUN_INSTALL/bin $MODULAR_HOME/pkg/packages.modular.com_mojo/bin $HOME/.pyenv/shims $PROTO_HOME/shims $PROTO_HOME/bin $HOME/.maestro/bin $HOME/.local/share/mise/shims $GEM_HOME/bin $HOME/bin $HOME/.local/bin $HOME/go/bin
    '';
  };

  # Zsh stays available as a fallback for scripts that need it.
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent =
      let
        userZshrc = ../dotfiles/zshrc/.zshrc;
        userZshrcContent = if builtins.pathExists userZshrc then builtins.readFile userZshrc else "";
      in
      userZshrcContent
      + ''
        # --- Home Manager additions (appended) ---
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        # Load Secrets from sops-nix
        if [ -f /run/secrets/anthropic_api_key ]; then
            export ANTHROPIC_API_KEY=$(cat /run/secrets/anthropic_api_key)
        fi

        # Auto-swap Claude settings based on directory (mirrors Fish _auto_claude_settings)
        _auto_claude_settings() {
          local settings="$HOME/.claude/settings.json"
          local work_settings="$HOME/Documents/subira/my-nix-darwin/dotfiles/.claude-work/settings.json"
          local personal_settings="$HOME/Documents/subira/my-nix-darwin/dotfiles/.claude/settings.json"
          if [[ "$PWD" == "$HOME/Documents/work"* ]]; then
            ln -sf "$work_settings" "$settings"
          else
            ln -sf "$personal_settings" "$settings"
          fi
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _auto_claude_settings
        _auto_claude_settings  # run once on shell init
        # --- End HM additions ---
      '';
  };

  # Persistent environment variables — available to Fish, Zsh, and all child processes.
  # For one-off or Fish-specific vars use `set -gx` in interactiveShellInit instead.
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
    PNPM_HOME = "/Users/rafiki/Library/pnpm";
    BUN_INSTALL = "$HOME/.bun";
    MODULAR_HOME = "/Users/rafiki/.modular";
    PROTO_HOME = "$HOME/.proto";
    GEM_HOME = "$HOME/.gem";
  };

  home.shellAliases = {
    # Package managers
    p = "pnpm";
    i = "pnpm i";
    c = "pnpm cache";
    d = "pnpx npkill -D -y";

    # Kubernetes
    k = "kubectl";

    # Jump (autojump)
    j = "jump";

    # Use python3 as default python
    python = "python3";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    # Terminal tools
    gt = "ghostty";
    dash = "gh dash";
    y = "yazi";
    ye = "yeet";

    # ls
    ls = "ls --color=auto";
    ll = "ls -l";
    la = "ls -A";
    l = "ls -CF";

    # grep
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";

    # Docker
    dk = "docker";
    dkc = "docker-compose";
    dps = "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'";
    dkr = "docker run --rm -it";
    dke = "docker exec -it";

    # Devbox
    db = "devbox";
    dbs = "devbox shell";
    dbi = "devbox init";
    dba = "devbox add";

    # mise
    m = "mise";
    dev = "mise dev";
    ios = "mise ios";
    android = "mise android";
  };
}
