{
  pkgs,
  lib,
  ...
}: {
  # gems
  home.packages = with pkgs; [
    bundler
    gem-wrappers
  ];
}
