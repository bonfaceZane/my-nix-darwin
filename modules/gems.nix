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

  # gem-wrappers

  # set rbenv environment variables
  home.environment = {
    RBENV_ROOT = "${pkgs.rbenv}/lib/rbenv";
    PATH = "${pkgs.rbenv}/bin";

    # rbenv
    RBENV_VERSIONS = "${pkgs.rbenv}/versions";
    RBENV_VERSION = "2.7.4";
  };
}
