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
        dart = ["latest" "2.19.2"];
        elixir = ["latest" "1.14.3-otp-25" "1.12.0-otp-22"];
        erlang = ["latest" "25.2.3"];
        flutter = ["latest" "3.7.5-stable"];
        java = ["adoptopenjdk-latest" "adoptopenjdk-19.0.2+7"];
        kotlin = ["latest" "1.8.0"];
        node = ["latest" "lts"];
        postgres = ["latest" "14.8"];
        sqlite = ["latest" "3.39.4"];
        python = ["latest" "3.10.12"];
        ruby = ["latest" "3.1.4"];
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
      disable_tools = ["node"];
      experimental = false;
      log_level = "debug";
    };
  };
}
1
