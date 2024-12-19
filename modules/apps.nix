{pkgs, ...}: {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    mkalias
    # nodejs_18
    nodejs_20
    python3
    nodePackages.yarn
    nodePackages.node-gyp-build
  ];

  # todo: update this to desired one
  environment.variables.EDITOR = "nvim";

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps

      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      Xcode = 497799835;
      # QQMusic = 595615424;
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # zsh
      # "zsh-completions" # zsh completions
      "zsh"

      # nushell
      "nushell"

      # zellij
      "zellij"

      # apple
      "mas"
      "libksba" # libksba is a library to make X.509 certificates and CMS easily accessible by C programs

      # git
      "gh"
      "git"

      "gmp"
      "libyaml"

      # ruby
      "rbenv"

      # node and relatives tools
      "yarn"
      "deno"
      "openssl"

      # IDEs
      "helix"
      # "visual-studio-code"

      "automake"
      "zlib"

      "zstd" # zstd
      "caddy" # caddy web server
      "glow" # markdown previewer in terminal

      #miscellaneous
      "sk" # grep with preview

      # tools
      "watchman"
      "libtool"
      "jump" # jump to frequently used directories
      "tree" # list files in tree structure
      "bat" # cat with syntax highlight
      "fd" # find with syntax highlight
      "ripgrep" # grep with syntax highlight
      "fzf" # fuzzy finder
      "just" # justfile to simplify nix-darwin's commands
      "starship" # cross-shell prompt
      # "1password-cli" # 1password cli
      "scrcpy" # screen copy for android

      # bun
      # "bun" # fast javascript runtime

      # deno
      "deno" # fast javascript runtime

      # GNU
      "coreutils" # GNU core utilities
      "gawk" # awk with GNU extensions

      # network
      "nmap" # network scanner
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink
      "httpie" # http client

      # files * file managers
      "zip" # zip tool for compressing files
      "unzip" # unzip tool for decompressing files
      "file" # file command to determine file type

      # parsers
      "jc" # json parser cli
      "jq" # json parser
    ];

    # `brew install --cask`
    # if app already exists make sure you uninstall it first and let nix do it by itself
    casks = [
      "firefox"
      # "google-chrome"

      # IM & audio & remote desktop & meeting
      "telegram"
      "discord"

      "anki"
      "iina" # video player
      # "raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
      "stats" # beautiful system monitor
      "spotify"
      "zoom"
      "hammerspoon" # macOS automation

      # Development
      "insomnia" # REST client
      "wireshark" # network analyzer
      "proxyman" # proxy manager
      "postman" # REST client
      # "visual-studio-code" # IDE
      "microsoft-openjdk@17"
      "bruno"

      # Productivity
      "alfred" # hotkey app
      "bettertouchtool" # hotkey app
      "obsidian" # markdown editor
      "notion" # markdown editor
      # "slack" # chat app
    ];
  };
}
