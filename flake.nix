{
  # Entry point for nix-darwin + Home Manager configuration
  #
  # Tips:
  # - To add another Mac host, see the "Add another machine" section in README.md.
  # - Values like `username`, `useremail`, `system`, and `hostname` are passed to
  #   both system and Home Manager modules via `specialArgs` for convenience.
  description = "Darwin system flakes for Zane";

  ##################################################################################################################
  #
  # Nix in details? beginner-friendly tutorial
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    home-manager,
    flake-utils,
    ...
  }: let
    username = "obwoni000";
    useremail = "bonfacezane@gmail.com";
    system = "aarch64-darwin"; # aarch64-darwin or x86_64-darwin
    hostname = "rafiki";

    specialArgs =
      inputs
      // {
        inherit username useremail hostname;
      };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rafiki
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        # --- System modules (nix-darwin) ---
        ./modules/apps.nix
        ./modules/nix-core.nix
        ./modules/systems.nix
        ./modules/host-users.nix

        # --- Home Manager (user) modules ---
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Safely handle existing dotfiles managed by Home Manager by creating backups
          # instead of refusing to overwrite. This avoids clobber errors like for ~/.zshenv.
          # The original file will be moved to filename.hm-bak on first write.
          home-manager.backupFileExtension = ".hm-bak";
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    # nix code formatter
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
  };
}
