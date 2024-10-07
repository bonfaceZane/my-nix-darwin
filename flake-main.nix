{
  description = "Darwin system flake for Zane";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

     # Optional: Declarative tap management

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs,  nix-homebrew, ...}:
  let
    configuration = { pkgs, ... }: {

      # usename = "obwoni000";
      # system = "aarch64-darwin";
      # hostname = "rafiki"

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.zsh
          pkgs.alacritty
          pkgs.neovim
          pkgs.wget
          pkgs.mkalias
        ];

        # homebrew = {
        #   enable = true;
        #   autoUpdate = true;
        #   upgrade = true;
        #   cask = [
        #     "hammerspoon"
        #     "firefox"
        #     "google-chrome"
        #     "spotify"
        #     "zoom"
        #     "slack"
        #     "visual-studio-code"
        #     "iina"
        #   ];
        #   onActivation.cleanup = "zap";
        # };

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
        ];


      # security.pam.enableSudoTouchIdAuth = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."rafiki" = nix-darwin.lib.darwinSystem {
      modules = [ 
        # ./modules/apps.nix
        # ./modules/nix-core.nix
        ./modules/systems.nix
        configuration 

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
              user = "obwoni000";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;

          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."rafiki".pkgs;
  };
}
