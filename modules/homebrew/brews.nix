{...}: {
  # Homebrew formulae (brew install <name>)
  # you can search by typing: `brew search <name>`
  homebrew.brews = [
    "fastlane"
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
    "neovim"
    "helix"
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
    "httpie" # http client
    "tailscale"
    "file" # file command to determine file type
    "llvm" # llvm compiler for c++, c and rust
    "mobile-dev-inc/tap/maestro"
    "yeet" # package manager/tool
  ];
}
