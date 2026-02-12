{
  config,
  pkgs,
  libs,
  ...
}:
{
  # Mise

  # The front-end to your dev env.
  # https://github.com/jdx/mise

  programs.mise = {
    enable = true;
    package = unstable.mise;
    enableZshIntegration = true;

    globalConfig = {
      tools = {
        java = ["adoptopenjdk-latest" "adoptopenjdk-19.0.2+7"];
        # kotlin = ["latest"];
        # sqlite = ["latest"];
        zig = ["latest"];
      };
    };

    settings = {
      always_keep_download = true;
      plugin_autoupdate_last_check_duration = "6 hours";
      trusted_config_paths = ["~/.config" "~/dev"];
      verbose = false;
      asdf_compat = false;
      jobs = 1;
      raw = false;
      disable_tools = [];
      experimental = false;
      log_level = "debug";
    };
  };
}
1
