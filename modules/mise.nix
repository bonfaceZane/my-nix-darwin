{
  config,
  pkgs,
  ...
}:
{
  # Mise

  # The front-end to your dev env.
  # https://github.com/jdx/mise

  programs.mise = {
    enable = true;
    package = pkgs.mise;
    enableZshIntegration = true;
  };
}
