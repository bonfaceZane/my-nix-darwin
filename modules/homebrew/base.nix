{...}: {
  # Common Homebrew configuration shared across brews and casks.
  # Splitting Homebrew concerns improves discoverability and avoids one giant file.
  homebrew = {
    enable = true;

    # Generate a Brewfile snapshot on each activation (handy for manual review).
    global.brewfile = true;

    onActivation = {
      autoUpdate = true; # Fetch newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # cleanup = "zap"; # optionally remove anything not declared here
    };

    taps = [
      "homebrew/services"
    ];
  };
}
