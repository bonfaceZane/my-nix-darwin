{ config, lib, pkgs, ... }:

{
  # Link the Zed settings file
  home.file.".config/zed/settings.json" = {
    source = ../dotfiles/zed/settings.json;
    recursive = true;
  };
}
