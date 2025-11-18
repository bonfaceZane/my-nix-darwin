{ username, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # programs.zsh manages ~/.zshrc. To allow your personal dotfile to be the
    # primary source without conflicts, we read it here and append any HM bits.
    # If the file is missing, we just write the HM bits.
    # Note: `initContent` supersedes the deprecated `initExtra`.
    initContent = let
      # Read user .zshrc tracked inside this repo (dotfiles/zshrc/.zshrc)
      userZshrc = ../dotfiles/zshrc/.zshrc;
      userZshrcContent = if builtins.pathExists userZshrc then builtins.readFile userZshrc else "";
    in
      userZshrcContent + ''
        # --- Home Manager additions (appended) ---
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        # --- End HM additions ---
      '';
  };

  home.shellAliases = {
    # k8s'
    k = "kubectl";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
