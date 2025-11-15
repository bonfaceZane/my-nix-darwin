{...}: {
  ##############################################################################
  # Apps aggregator module
  #
  # This file now only aggregates separate concerns to keep things tidy:
  # - modules/system-packages.nix  → global nixpkgs packages and EDITOR
  # - modules/homebrew/base.nix    → common Homebrew enable + activation knobs
  # - modules/homebrew/brews.nix   → Homebrew formulae (CLI)
  # - modules/homebrew/casks.nix   → Homebrew casks (GUI) + mas apps
  ##############################################################################

  imports = [
    ./system-packages.nix
    ./homebrew/base.nix
    ./homebrew/brews.nix
    ./homebrew/casks.nix
  ];
}
