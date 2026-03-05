{...}: {
  # Homebrew formulae (brew install <name>)
  homebrew.brews = [
    "fastlane"
    "zsh"
    "nushell"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-autocomplete"
    "mole" # for cleaning your Mac computer
    "zellij"
    "htop"
    "mas"
    "libksba" # libksba is a library to make X.509 certificates and CMS easily accessible by C programs
    "gh"
    "git"
    "gmp"
    "libyaml"
    "openssl"
    "automake"
    "zlib"
    "neovim"
    "helix"
    "zstd" # zstd
    "caddy" # caddy web server
    "glow" # markdown previewer in terminal
    "sk" # grep with preview
    "watchman" # watchman file system watcher
    "libtool"
    "jump" # jump to frequently used directories
    "tree" # list files in tree structure
    "bat" # cat with syntax highlight
    "fd" # find with syntax highlight
    "ripgrep" # grep with syntax highlight
    "fzf" # fuzzy finder
    "just" # justfile to simplify nix-darwin's commands
    "starship" # cross-shell prompt
    "scrcpy" # screen copy for android
    "mise" # package manager
    "zoxide"
    "coreutils" # GNU core utilities
    "wget" # download tool
    "curl" # do not install curl via nixpkgs; works better via Homebrew on macOS
    "aria2" # download tool supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink
    "httpie" # http client
    "tailscale"
    "file" # file command to determine file type
    "jc" # json parser cli
    "jq" # json parser
    "llvm" # llvm compiler for c++, c and rust
    "mobile-dev-inc/tap/maestro"
  ];
}
