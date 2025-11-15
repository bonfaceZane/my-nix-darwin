{
  lib,
  username,
  useremail,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    # Per Home Manager deprecations, user info now lives under `settings.user.*`
    settings = {
      user = {
        name = username;
        email = useremail;
      };
      # migrated from extraConfig
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    includes = [
      {
        # use diffrent email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

    # signing = {
    #   key = "xxx";
    #   signByDefault = true;
    # };

    # delta configuration moved to top-level `programs.delta`

    # aliases = {
    #   # common aliases
    #   br = "branch";
    #   co = "checkout";
    #   st = "status";
    #   ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
    #   ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    #   cm = "commit -m";
    #   ca = "commit -am";
    #   dc = "diff --cached";
    #   amend = "commit --amend -m";

    #   # aliases for submodule
    #   update = "submodule update --init --recursive";
    #   foreach = "submodule foreach";
    # };
  };

  # New location for delta config per HM deprecation notices
  programs.delta = {
    enable = true;
    # Explicitly enable Git integration (no longer automatically enabled)
    enableGitIntegration = true;
    options = {
      features = "side-by-side";
    };
  };
}
