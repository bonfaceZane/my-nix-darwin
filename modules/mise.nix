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

    globalConfig = {
      env = {
        MISE_RUBY_COMPILE = "false";
      };
      tools = {
        node = "lts";
        yarn = "1.22.22";
        pnpm = "latest";
        rust = "latest";
        ruby = "3.2.2";
        java = "17";
        zig = "latest";
        swift = "latest";
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
        # log_level = "debug";
        idiomatic_version_file_enable_tools = ["ruby"];
      };
    };
  };
}
