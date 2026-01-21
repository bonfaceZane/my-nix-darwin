{
  lib,
  config,
  username,
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
      };
      # migrated from extraConfig
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    extraConfig = {
      user.email = "!echo $USER_EMAIL";
    };

    includes = [
      {
        # use diffrent email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

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
