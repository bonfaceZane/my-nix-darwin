{ ... }:
{
  # Home Manager owns ~/.config/git/config and handles collisions there.
  # Git also reads ~/.gitconfig; preserve it and its higher-priority user settings.

  programs.git = {
    enable = true;
    lfs.enable = true;

    # Per Home Manager deprecations, user info now lives under `settings.user.*`
    settings = {
      user = {
        name = "rafiki";
        email = "bonfacezane@gmail.com";
      };
      core.excludesfile = "~/.gitignore_global";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;
      # Atomic commits enforcement: one logical change per commit, conventional commits
      commit.verbose = true;
      # Help enforce atomic commits via commit template guidance (also in zed: agent.commit_message_instructions)
    };

    includes = [
      {
        # Use the personal identity for repositories under ~/Documents/subira/.
        path = "~/.gitconfig_personal";
        condition = "gitdir:~/Documents/subira/";
      }
      {
        # Use the work identity for repositories under ~/Documents/work/.
        path = "~/.gitconfig_work";
        condition = "gitdir:~/Documents/work/";
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
