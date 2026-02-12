{...}: {
  # Homebrew formulae (brew install <name>)
  homebrew.brews = [
    # shells
    "zsh"
    "nushell"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-autocomplete"

    # terminal multiplexer
    "zellij"

    # languages
    "rust"
    "rustup"

    "htop"

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

    "openssl"

    "automake"
    "zlib"

    "neovim"
    "helix"

    "zstd" # zstd
    "caddy" # caddy web server
    "glow" # markdown previewer in terminal

    # miscellaneous
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
    "mise" # package manager
    "zoxide"

    # GNU
    "coreutils" # GNU core utilities
    "gawk" # awk with GNU extensions

    # network
    "nmap" # network scanner
    "wget" # download tool
    "curl" # do not install curl via nixpkgs; works better via Homebrew on macOS
    "aria2" # download tool supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink
    "httpie" # http client
    "tailscale"

    # files * file managers
    "zip" # zip tool for compressing files
    "unzip" # unzip tool for decompressing files
    "file" # file command to determine file type

    # parsers
    "jc" # json parser cli
    "jq" # json parser

    # misc
    "llvm" # llvm compiler for c++, c and rust

    "mobile-dev-inc/tap/maestro"
  ];
}
